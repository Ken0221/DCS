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
logic [3:0] n0, n1, check;
logic [8:0] sum;
logic [3:0] w1;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign check = (10 - (sum % 10)) % 10;
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        out_legal_id <= 0;
        sum <= 0;
        w1 <= 10;
        n0 <= 0;
        n1 <= 0;
    end
    else begin
        if(in_valid) begin
            n0 <= in_id / 10;
            n1 <= in_id % 10;
            sum <= sum + (n1 * w1) + n0;
            w1 <= w1 - 1;
        end
        
        out_valid <= !w1;
        out_legal_id <= (n1 == check)? 1 : 0;
        
        if(out_valid) begin
            out_valid <= 0;
            out_legal_id <= 0;
            sum <= 0;
            w1 <= 10;
        end
    end
end

endmodule