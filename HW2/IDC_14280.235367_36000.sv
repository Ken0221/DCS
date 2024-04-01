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
logic [5:0] n1_1, n1_2, n2, n3, n4, n5, n6, n7, n8, n9, n10;
logic [8:0] sum;
logic [3:0] cnt, o_cnt;
logic [3:0] w1_1, w1_2, w2, w3, w4, w5, w6, w7, w8, w9;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        out_legal_id <= 0;
        sum <= 0;
        cnt <= 0;
        o_cnt <= 0;
        w1_1 <= 1;
        w1_2 <= 9;
        w2 <= 8;
        w3 <= 7;
        w4 <= 6;
        w5 <= 5;
        w6 <= 4;
        w7 <= 3;
        w8 <= 2;
        w9 <= 1;
    end
    else begin
        if(in_valid) begin
            n10 <= in_id;
            n9 <= n10;
            n8 <= n9;
            n7 <= n8;
            n6 <= n7;
            n5 <= n6;
            n4 <= n5;
            n3 <= n4;
            n2 <= n3;
            n1_2 <= n2;
            cnt <= cnt + 1;
        end
        if(cnt == 10) begin
            n1_2 <= n1_2 % 10;
            n1_1 <= n1_2 / 10;
            cnt <= cnt + 1;
        end
        if(cnt == 11) begin
            n8 <= n9;
            n7 <= n8;
            n6 <= n7;
            n5 <= n6;
            n4 <= n5;
            n3 <= n4;
            n2 <= n3;
            n1_2 <= n2;
            n1_1 <= n1_2;
            
            sum <= sum + (n1_1 * w1_1);

            w8 <= w9;
            w7 <= w8;
            w6 <= w7;
            w5 <= w6;
            w4 <= w5;
            w3 <= w4;
            w2 <= w3;
            w1_2 <= w2;
            w1_1 <= w1_2;
            o_cnt <= o_cnt + 1;
        end
        if(o_cnt == 10) begin
            if(n10 == (10 - (sum % 10)) % 10) begin
                out_legal_id <= 1;
            end
            else begin
                out_legal_id <= 0;
            end
            out_valid <= 1;
        end
        if(out_valid == 1) begin
            out_valid <= 0;
            out_legal_id <= 0;
            sum <= 0;
            cnt <= 0;
            o_cnt <= 0;
            w1_1 <= 1;
            w1_2 <= 9;
            w2 <= 8;
            w3 <= 7;
            w4 <= 6;
            w5 <= 5;
            w6 <= 4;
            w7 <= 3;
            w8 <= 2;
            w9 <= 1;
        end
    end
end

endmodule