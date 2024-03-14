module combinational_operations(
    output [4:0] out_num0, out_num1,
    input [3:0] in_num0, in_num1, in_num2, in_num3
);
logic [3:0] A, B, C, D;
logic [4:0] sum_AB, sum_CD;



assign sum_AB = A + B;
assign sum_CD = C + D;

assign out_num0 = (sum_AB <= sum_CD)? sum_AB : sum_CD;
assign out_num1 = (sum_AB > sum_CD)? sum_AB : sum_CD;

endmodule