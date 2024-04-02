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

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

always @(*) begin
    if(!rst_n) begin
        out_legal_id = 0;
        out_valid = 0;
    end
    else begin
        out_legal_id = ((sum + n1) % 10 == 0)? 1 : 0;
        out_valid = !w1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum <= 0;
        w1 <= 10;
        n0 <= 0;
        n1 <= 0;
    end
    else begin
        if(in_valid) begin
            n0 <= in_id / 10;
            n1 <= in_id - ((in_id / 10) * 10);
            
            sum <= ((sum + n0) + (n1 * w1)) % 10;
            w1 <= w1 - 1;
        end
        
        if(out_valid) begin
            sum <= 0;
            w1 <= 10;
        end
    end
end

endmodule