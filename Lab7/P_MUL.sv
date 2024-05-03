module P_MUL(
    // input signals
	in_1,
	in_2,
	in_3,
	in_4,
	in_valid,
	rst_n,
	clk,
	
    // output signals
    out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [47:0] in_1, in_2;
input [47:0] in_3, in_4;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [95:0] out;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [47:0] max1, max2;
logic [15:0] l1, m1, s1, l2, m2, s2;
logic [95:0] p9, p8, p7, p6, p5, p4, p3, p2, p1;



//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

assign l1 = max1[47:32];
assign m1 = max1[31:16];
assign s1 = max1[15:0];
assign l2 = max2[47:32];
assign m2 = max2[31:16];
assign s2 = max2[15:0];

always @(posedge clk) begin
	p9 <= (l1*l2);
	p8 <= (l1*m2);
	p7 <= (l1*s2);
	p6 <= (m1*l2);
	p5 <= (m1*m2);
	p4 <= (m1*s2);
	p3 <= (s1*l2);
	p2 <= (s1*m2);
	p1 <= (s1*s2);
end

always @(*) begin
	if(!rst_n) begin
		out_valid = 0;
	end
	else begin
		if(out != 0) begin
			out_valid = 1;
		end
		else begin
			out_valid = 0;
		end
	end
end


always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		// out_valid <= 0;
		out <= 0;
	end
	else begin
		if(in_valid) begin
			max1 <= (in_1 > in_2)? in_1: in_2;
			max2 <= (in_3 > in_4)? in_3: in_4;
		end
		else begin
			max1 <= 0;
			max2 <= 0;
		end
		out <= (p9 << 64) + (p8 << 48) + (p7 << 32) + (p6 << 48) + (p5 << 32) + (p4 << 16) + (p3 << 32) + (p2 << 16) + p1;
	end
end



endmodule