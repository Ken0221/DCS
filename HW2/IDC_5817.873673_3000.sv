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
logic [8:0] sum; //sum Max = 407 < 512(2^9)
logic [3:0] w1;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

get_check g1(.num(sum), .out(check));
// assign check = (10 - (sum % 10)) % 10;
always @(posedge clk or negedge rst_n) begin
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

module get_check(num, out);
input [8:0] num;
output logic [3:0] out;

logic [6:0] mod1;
logic [3:0] mod2, tenMinus;
logic [5:0] c1;
logic [3:0] c2;

always @(*) begin
    //sum % 10
    c1 = num / 10;
    mod1 = num - c1 * 10;
    c2 = mod1 / 10;
    mod2 = mod1 - c2 * 10;

    //10 - (sum % 10)
    tenMinus = 10 - mod2;

    //(10 - (sum % 10) % 10)
    out = (tenMinus == 10)? 0: tenMinus;
end

endmodule