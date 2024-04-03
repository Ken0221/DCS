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
logic [4:0] sum_temp;
logic [3:0] mul;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign check = (sum == 0)? 0 : 10 - sum;
assign out_valid = (rst_n)? !w1: 0;
assign out_legal_id = (rst_n)? (check == n1): 0;
assign sum_temp = (in_valid)? ((sum + n0) + mul): 0;

always @(*) begin
    case ({n1, w1})
        {4'd1, 4'd1},{4'd3, 4'd7},{4'd7, 4'd3},{4'd9, 4'd9}: mul = 1;
        {4'd1, 4'd2},{4'd2, 4'd1},{4'd2, 4'd6},{4'd6, 4'd2},{4'd3, 4'd4},{4'd4, 4'd3},{4'd4, 4'd8},{4'd8, 4'd4},{4'd6, 4'd7},{4'd7, 4'd6},{4'd8, 4'd9},{4'd9, 4'd8}: mul = 2;
        {4'd1, 4'd3},{4'd3, 4'd1},{4'd7, 4'd9},{4'd9, 4'd7}: mul = 3;
        {4'd1, 4'd4},{4'd4, 4'd1},{4'd2, 4'd2},{4'd2, 4'd7},{4'd7, 4'd2},{4'd3, 4'd8},{4'd8, 4'd3},{4'd4, 4'd6},{4'd6, 4'd4},{4'd6, 4'd9},{4'd9, 4'd6},{4'd8, 4'd8}: mul = 4;
        {4'd1, 4'd5},{4'd5, 4'd1},{4'd3, 4'd5},{4'd5, 4'd3},{4'd5, 4'd5},{4'd5, 4'd7},{4'd7, 4'd5},{4'd5, 4'd9},{4'd9, 4'd5}: mul = 5;
        {4'd1, 4'd6},{4'd6, 4'd1},{4'd2, 4'd3},{4'd3, 4'd2},{4'd2, 4'd8},{4'd8, 4'd2},{4'd4, 4'd4},{4'd4, 4'd9},{4'd9, 4'd4},{4'd6, 4'd6},{4'd7, 4'd8},{4'd8, 4'd7}: mul = 6;
        {4'd1, 4'd7},{4'd7, 4'd1},{4'd3, 4'd9},{4'd9, 4'd3}: mul = 7;
        {4'd1, 4'd8},{4'd8, 4'd1},{4'd2, 4'd4},{4'd4, 4'd2},{4'd2, 4'd9},{4'd9, 4'd2},{4'd3, 4'd6},{4'd6, 4'd3},{4'd4, 4'd7},{4'd7, 4'd4},{4'd6, 4'd8},{4'd8, 4'd6}: mul = 8;
        {4'd1, 4'd9},{4'd9, 4'd1},{4'd3, 4'd3},{4'd7, 4'd7}: mul = 9;
        default: mul = 0;
    endcase
end

always @(posedge clk) begin
    n0 <= (in_valid)? in_id / 10: 0;
    case (in_id)
        10, 20, 30: n1 <= 0;
        11, 21, 31: n1 <= 1;
        12, 22, 32: n1 <= 2;
        13, 23, 33: n1 <= 3;
        14, 24, 34: n1 <= 4;
        15, 25, 35: n1 <= 5;
        16, 26: n1 <= 6;
        17, 27: n1 <= 7;
        18, 28: n1 <= 8;
        19, 29: n1 <= 9;
        default: n1 <= in_id;
    endcase

    sum <= sum_temp % 10;
    w1 <= (out_valid)? 10 : (in_valid)? w1 - 1 : 10;
end

endmodule