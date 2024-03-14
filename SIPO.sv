module SIPO(
	// input signals
	clk,
	rst_n,
	in_valid,
	s_in,
	
	// output signals
	out_valid,
	p_out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n;
input in_valid;
input s_in;
output logic out_valid;
output logic [3:0] p_out;
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [0:0] D1, D2, D3, D4;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

logic [2:0] count;
always @( posedge clk, negedge rst_n ) begin
	if(~rst_n) begin
		count <= 0;
		p_out <= 0;
		out_valid <= 0;
	end
	else begin
		if(in_valid) begin
			D1 <= s_in;
			D2 <= D1;
			D3 <= D2;
			D4 <= D3;
			count <= count + 1;;
		end
		else begin
			D1 <= 0;
			D2 <= 0;
			D3 <= 0;
			D4 <= 0;
		end
		if(count == 4)begin
			p_out [0] <= D1;
			p_out [1] <= D2;
			p_out [2] <= D3;
			p_out [3] <= D4;
			out_valid <= 1;
			count <= 0;
		end
		else begin
			out_valid <= 0;
		end
	end
end

endmodule