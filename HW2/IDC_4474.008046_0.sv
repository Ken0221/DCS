module IDC(
    // Input signals
	clk,
	rst_n,
	in_valid,
    in_id,
    // Output signals
    out_valid,
    out_legal_id
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [5:0] in_id;

output logic out_valid;
output logic out_legal_id;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [1:0] n0;
logic [3:0] n1;
logic [3:0] sum;
logic [3:0] w1;
logic [3:0] check;
logic [6:0] sum_temp;
logic [6:0] mul;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always @(*) begin
    check = (sum == 0)? 0 : 10 - sum;
    out_valid = (rst_n)? !w1: 0;
    out_legal_id = (rst_n)? (check == n1): 0;
    sum_temp = (in_valid)? (sum + n0 + n1*w1): 0;
end
 
always @(posedge clk) begin
    n0 <= (in_valid)? in_id / 10: 0;
    n1 <= (in_valid)? in_id - ((in_id / 10) * 10): 0;
    sum <= sum_temp - (sum_temp / 10) * 10;
    w1 <= (out_valid)? 10 : (in_valid)? w1 - 1 : 10;
end

endmodule