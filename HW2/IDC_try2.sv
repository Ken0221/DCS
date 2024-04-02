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
logic [3:0] n1, check;
logic [8:0] sum; //sum Max = 407 < 512(2^9)
logic [3:0] w1;

logic [6:0] mod1;
logic [3:0] mod2, tenMinus;
logic [5:0] c1;
logic [3:0] c2;
logic [6:0] plus;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

//get_check g1(.num(sum), .out(check));
// assign check = (10 - (sum % 10)) % 10;

always @(*) begin
    //sum % 10
    c1 = sum / 10;
    mod1 = sum - c1 * 10;
    c2 = mod1 / 10;
    mod2 = mod1 - c2 * 10;

    //10 - (sum % 10)
    tenMinus = 10 - mod2;

    //(10 - (sum % 10) % 10)
    check = (tenMinus == 10)? 0: tenMinus;
end

always @(rst_n, out_valid, n1) begin
    plus = (!rst_n || out_valid)? 0 : (n1 * w1) + n0;
end
assign n0 = in_id / 10;
assign n1 = (in_valid)? in_id - ((in_id / 10) * 10): n1;
assign out_legal_id = (n1 == check && rst_n && out_valid)? 1: 0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        // out_legal_id <= 0;
        sum <= 0;
        w1 <= 10;
        //n0 <= 0;
        //n1 <= 0;
    end
    else begin
        if(in_valid) begin
            //n0 <= in_id / 10;
            //n1 <= in_id - ((in_id / 10) * 10);
            sum <= sum + plus;
            w1 <= w1 - 1;
        end
        
        out_valid <= !w1;
        // out_legal_id <= (n1 == check)? 1 : 0;
        
        if(out_valid) begin
            out_valid <= 0;
            // out_legal_id <= 0;
            sum <= 0;
            w1 <= 10;
        end
    end
end

endmodule