module LP(
    // Input signals
	clk,
	rst_n,
	in_valid,
    in_a1,
	in_a2,
	in_b,
    // Output signals
    out_valid,
    out_max_value
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input signed [5:0] in_a1,in_a2;
input signed [11:0] in_b;

output logic out_valid;
output logic signed [11:0] out_max_value;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic signed [5:0] xa1[0:1], xa2[0:1];
logic signed [11:0] xb[0:1];
logic signed [5:0] c1, c2;
logic cnt;

logic signed [11:0] bdx_max, bdx_min, bdy_max;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
logic signed [11:0] x1, x2;
logic out_ok;
logic mn;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_max_value <= 0;
        out_valid <= 0;
        cnt <= 0;
        out_ok <= 0;
        mn <= 0;
    end
    else begin
        if(in_valid) begin
            out_ok <= 1;
            out_max_value <= -2047;
            cnt <= 1;
            if(cnt == 0) begin
                c1 <= in_a1;
                c2 <= in_a2;
            end
            else begin
                if(in_a1 == 1 && in_a2 == 0) begin
                    bdx_max <= in_b;
                end
                else if(in_a1 == -1 && in_a2 == 0) begin
                    bdx_min <= -in_b;
                    x1 <= -in_b;
                end
                else if(in_a1 == 0 && in_a2 == 1) begin
                    bdy_max <= in_b;
                end
                else if(in_a1 == 0 && in_a2 == -1) begin
                    x2 <= -in_b;
                end
                else begin
                    xa1[mn] <= in_a1;
                    xa2[mn] <= in_a2;
                    xb[mn] <= in_b;
                    mn <= 1;
                end
            end
        end
        else begin
            if(xa1[0] * x1 + xa2[0] * x2 <= xb[0] && xa1[1] * x1 + xa2[1] * x2 <= xb[1]) begin
                out_max_value <= (c1 * x1 + c2 * x2 < out_max_value)? out_max_value : c1 * x1 + c2 * x2;
            end
            x1 <= (x1 == bdx_max)? bdx_min : (x1 + 1);
            x2 <= (x1 == bdx_max)? (x2 + 1): x2;
            if(x2 == bdy_max && x1 == bdx_max && out_ok && !in_valid) begin
                out_valid <= 1;
            end
            if(out_valid) begin
                out_valid <= 0;
                cnt <= 0;
                out_ok <= 0;
                mn <= 0;
            end
        end
    end
end

endmodule