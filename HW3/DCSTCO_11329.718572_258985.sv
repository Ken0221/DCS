module DCSTCO(
    // Input signals
	clk,
	rst_n,
    in_valid,
	target_product,
    // Output signals
    out_valid,
	ten,
	five,
	one,
	run_out_ing,
	// AHB-interconnect input signals
	ready_refri,
	ready_kitch,
	// AHB-interconnect output signals
	valid_refri,
	valid_kitch,
	product_out,
	number_out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input        clk, rst_n ;
input        in_valid ;
input        [11:0] target_product ;
input        ready_refri ;
input        ready_kitch ;
output logic out_valid ;
output logic [3:0] ten ;
output logic five ;
output logic [2:0] one ;
output logic run_out_ing ;
output logic valid_refri ;
output logic valid_kitch ;
output logic product_out ;
output logic [5:0] number_out ; 

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
parameter [1:0] p_nugget = 3;
parameter [2:0] p_fried_rice = 5;
parameter [1:0] p_apple = 2;
parameter [2:0] p_peach = 4;

parameter addr_kc_nugget = 1;
parameter addr_kc_fried_rice = 0;
parameter addr_fr_apple = 1;
parameter addr_fr_peach = 0;

parameter [5:0] FULL = 50;
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [2:0] g_nugget, g_fried_rice, g_apple, g_peach;
logic  IsSuff;
logic IsSuff_nugget, IsSuff_fried_rice, IsSuff_apple, IsSuff_peach;
logic [4:0] cost_nugget, cost_peach; //apple only need 4 bits // rice need 6 bits
logic [3:0] cost_apple;
logic [5:0] cost_fried_rice;
logic [6:0] sum;
logic [3:0] ten_t ;
logic five_t ;
logic [2:0] one_t ;

logic IsHandshake_kitch, IsHandshake_refri;
logic Isout;
//---------------------------------------------------------------------
//   DON'T MODIFIED THE REGISTER'S NAME (PRODUCT REGISTER)
//---------------------------------------------------------------------
logic [5:0] nugget_in_shop, fried_rice_in_shop ;
logic [5:0] apple_in_shop , peach_in_shop ;
//---------------------------------------------------------------------
parameter S_suff = 'd1;
parameter S_unsuff = 'd2;

logic [1:0] cur_state, next_state;
//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cur_state = S_unsuff;
	end
	else begin
		cur_state = next_state;
	end
end

always_comb begin
	case(cur_state)
		S_suff: begin
			if(in_valid && !IsSuff) begin
				next_state = S_unsuff;
			end
			else begin
				next_state = cur_state;
			end
		end
		S_unsuff: begin
			if(in_valid && IsSuff) begin
				next_state = S_suff;
			end
			else begin
				next_state = cur_state;
			end
		end
		default: begin
			next_state = cur_state;
		end
	endcase
end
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign IsSuff_nugget = (nugget_in_shop >= g_nugget);
assign IsSuff_fried_rice = (fried_rice_in_shop >= g_fried_rice);
assign IsSuff_apple = (apple_in_shop >= g_apple);
assign IsSuff_peach = (peach_in_shop >= g_peach);
assign IsSuff = (IsSuff_apple && IsSuff_nugget && IsSuff_peach && IsSuff_fried_rice);
assign IsHandshake_kitch = (ready_kitch && valid_kitch);
assign IsHandshake_refri = (ready_refri && valid_refri);

always @(posedge clk) begin
	cost_nugget <= p_nugget * g_nugget;
	cost_fried_rice <= p_fried_rice * g_fried_rice;
	cost_apple <= p_apple * g_apple;
	cost_peach <= p_peach * g_peach;
	sum <= (cost_apple + cost_fried_rice) + (cost_nugget + cost_peach);
end

always @(*) begin //compute coins
	one_t = (cur_state == S_suff)? sum % 5: 0;
	ten_t = (cur_state == S_suff)? sum / 10: 0;
	five_t = (cur_state == S_suff)? sum - 10 * ten_t - one_t: 0;
end

assign one = (cur_state == S_suff && out_valid)? one_t: 0;
assign five = (cur_state == S_suff && out_valid)? five_t: 0;
assign ten = (cur_state == S_suff && out_valid)? ten_t: 0;

always @(posedge clk, negedge rst_n) begin //reset shop、out for store
	if(!rst_n) begin
		nugget_in_shop <= 0;
		fried_rice_in_shop <= 0;
		apple_in_shop <= 0;
		peach_in_shop <= 0;
	end
	else begin
		nugget_in_shop <= (next_state == S_suff && in_valid)? nugget_in_shop - g_nugget: ((IsHandshake_kitch && product_out)? FULL: nugget_in_shop);
		fried_rice_in_shop <= (next_state == S_suff && in_valid)? fried_rice_in_shop - g_fried_rice: ((IsHandshake_kitch)? ((product_out)? fried_rice_in_shop: FULL): fried_rice_in_shop);
		apple_in_shop <= (next_state == S_suff && in_valid)? apple_in_shop - g_apple: ((!IsHandshake_kitch && IsHandshake_refri && product_out)? FULL: apple_in_shop);
		peach_in_shop <= (next_state == S_suff && in_valid)? peach_in_shop - g_peach: ((!IsHandshake_kitch && IsHandshake_refri)? ((product_out)? peach_in_shop: FULL): peach_in_shop);
	end
end

//assign product_out = (!IsSuff_nugget || !IsSuff_apple)? 1: 0;

always @(posedge clk, negedge rst_n) begin //if cur == unsuff pull up valid kitch/refri
	if(!rst_n) begin
		product_out <= 0;
		number_out <= 0;
		valid_kitch <= 0;
		valid_refri <= 0;
	end
	else begin	
		if(cur_state == S_unsuff && !in_valid) begin
			if(!IsSuff_nugget) begin
				product_out <= addr_kc_nugget;
				number_out <= FULL - nugget_in_shop;
				valid_kitch <= 1;
				valid_refri <= 0;
			end
			else if(!IsSuff_apple) begin
				product_out <= addr_fr_apple;
				number_out <= FULL - apple_in_shop;
				valid_refri <= 1;
				valid_kitch <= 0;
			end
			else if(!IsSuff_peach) begin
				product_out <= addr_fr_peach;
				number_out <= FULL - peach_in_shop;
				valid_refri <= 1;
				valid_kitch <= 0;
			end
			else if(!IsSuff_fried_rice) begin
				product_out <= addr_kc_fried_rice;
				number_out <= FULL - fried_rice_in_shop;
				valid_kitch <= 1;
				valid_refri <= 0;
			end
			else begin
				product_out <= 0;
				number_out <= 0;
				valid_kitch <= 0;
				valid_refri <= 0;
			end
		end
		else begin
			product_out <= 0;
			number_out <= 0;
			valid_kitch <= 0;
			valid_refri <= 0;
		end
	end
end

logic [2:0] g_nugget_reg, g_fried_rice_reg, g_apple_reg, g_peach_reg;

always @(posedge clk) begin
	if(in_valid) begin
		g_nugget_reg <= target_product[11:9];
 		g_fried_rice_reg <= target_product[8:6];
 		g_apple_reg <= target_product[5:3];
 		g_peach_reg <= target_product[2:0];
	end
end

assign g_nugget = (!rst_n)? 0 : (in_valid)? target_product[11:9]: g_nugget_reg;
assign g_fried_rice = (!rst_n)? 0 : (in_valid)? target_product[8:6]: g_fried_rice_reg;
assign g_apple = (!rst_n)? 0 : (in_valid)? target_product[5:3]: g_apple_reg;
assign g_peach = (!rst_n)? 0 : (in_valid)? target_product[2:0]: g_peach_reg;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 0;
		run_out_ing <= 0;
		Isout <= 0;
	end
	else begin
		if(in_valid) begin
			Isout <= 0;
			out_valid <= 0;
			run_out_ing <= 0;
		end
		else if(out_valid) begin
			out_valid <= 0;
			run_out_ing <= 0;
			Isout <= 1;
		end
		else if(cur_state == S_suff && !Isout) begin
			out_valid <= 1;
			run_out_ing <= 0;
		end
		else if(cur_state == S_unsuff && IsSuff && !Isout) begin
			out_valid <= 1;
			run_out_ing <= 1;
		end
		else begin
			out_valid <= 0;
		end	
	end
end

endmodule