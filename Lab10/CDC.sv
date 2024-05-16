
`include "Handshake_syn.v"

module CDC(
	// Input signals
	clk_1,
	clk_2,
	rst_n,
	in_valid,
	in_data,
	// Output signals
	out_valid,
	out_data
);

input clk_1; 
input clk_2;			
input rst_n;
input in_valid;
input[7:0]in_data;

output logic out_valid;
output logic [4:0]out_data; 			

// ---------------------------------------------------------------------
// logic declaration                 
// ---------------------------------------------------------------------	
// logic [3:0] data1, data2;
logic [7:0] din;
logic sready, sidle, dbusy, dvalid;
logic [7:0] dout;


parameter S_wait_input = 'd1;
parameter S_wait_sync_idle = 'd2;
parameter S_send_data = 'd0;

parameter S_wait_sync_high = 'd1;
parameter S_out = 'd2;
parameter S_wait_sync_low = 'd0;

logic [1:0] cur_state1, next_state1;
logic [1:0] cur_state2, next_state2;

// ---------------------------------------------------------------------
// design              
// ---------------------------------------------------------------------
//FSM
always @(posedge clk_1, negedge rst_n) begin
	if(!rst_n) begin
		cur_state1 = S_wait_input;
	end
	else begin
		cur_state1 = next_state1;
	end
end

always_comb begin
	case(cur_state1)
		S_wait_input: begin
			if(in_valid) begin
				next_state1 = S_wait_sync_idle;
			end
			else begin
				next_state1 = cur_state1;
			end
		end
		S_wait_sync_idle: begin
			if(sidle == 1) begin
				next_state1 = S_send_data;
			end
			else begin
				next_state1 = cur_state1;
			end
		end
		S_send_data: begin
			next_state1 = S_wait_input;
		end
		default: begin
			next_state1 = cur_state1;
		end
	endcase
end

always @(posedge clk_2, negedge rst_n) begin
	if(!rst_n) begin
		cur_state2 = S_wait_sync_high;
	end
	else begin
		cur_state2 = next_state2;
	end
end

always_comb begin
	case(cur_state2)
		S_wait_sync_high: begin
			if(dvalid == 1) begin
				next_state2 = S_out;
			end
			else begin
				next_state2 = cur_state2;
			end
		end
		S_out: begin
			next_state2 = S_wait_sync_low;
		end
		S_wait_sync_low: begin
			if(dvalid == 0) begin
				next_state2 = S_wait_sync_high;
			end
			else begin
				next_state2 = cur_state2;
			end
		end
		default: begin
			next_state2 = cur_state2;
		end
	endcase
end

always @(posedge clk_1) begin
	if(in_valid) begin
		din <= in_data;
	end
end
//
assign sready = (cur_state1 == S_send_data)? 1: 0;
// Handshake_syn sync(.sclk(clk_1), .dclk(clk_2), .*);

always @(posedge clk_2, negedge rst_n) begin
	if(!rst_n) begin
		out_data <= 0;
		out_valid <= 0;
		dbusy <= 0;
	end
	else begin
		dbusy <= 0;
		if(cur_state2 == S_out) begin
			out_valid <= 1;
			out_data <= dout[7:4] + dout[3:0];
		end
		if(out_valid) begin
			out_valid <= 0;
		end
	end
end


Handshake_syn sync(
					.sclk(clk_1), 
					.dclk(clk_2), 
					.rst_n(rst_n),
					.sready(sready), 
					.din(din), 
					.sidle(sidle),
					.dbusy(dbusy),
					.dvalid(dvalid),
					.dout(dout)
);


		
endmodule