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
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign check = (sum == 0)? 0 : 10 - sum;
assign out_valid = (rst_n)? !w1: 0;
assign out_legal_id = (rst_n)? (check == n1): 0;
assign sum_temp = (in_valid)? (sum + n0 + n1 * w1): 0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        w1 <= 10;
        n0 <= 0;
        n1 <= 0;
    end
    else begin
        if(in_valid) begin
            n0 <= in_id / 10;
            n1 <= in_id - ((in_id / 10) * 10);
            //w1 <= w1 - 1;
        end
        sum <= sum_temp - (sum_temp / 10) * 10;
        w1 <= (out_valid)? 10 : (in_valid)? w1 - 1 : 10;
    end
end

endmodule