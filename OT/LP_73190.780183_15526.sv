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
logic signed [5:0] xa1[0:5], xa2[0:5];
logic signed [11:0] xb[0:5];
logic signed [5:0] c1, c2;
logic [3:0] cnt;

logic signed [11:0] bdx_max, bdx_min, bdy_max, bdy_min;
logic bxmaxok, bxminok, bymaxok, byminok;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
logic signed [0:11] x1, x2;

logic cnt_2;
logic out_ok;

always @(posedge clk) begin
    if(in_valid) begin
        x1 <= bdx_min;
        x2 <= bdy_min;
        cnt_2 <= 0;
    end
    else begin
        cnt_2 <= 1;
        if(cnt_2 == 0) begin
            x1 <= bdx_min;
            x2 <= bdy_min;
        end
        else begin
            x1 <= (x1 == bdx_max)? bdx_min: (x1 + 1);
            x2 <= (x1 == bdx_max)? (x2 + 1): x2;
        end
        // if(out_valid) begin
        //     out_ok <= 0;
        // end
    end
end

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_max_value <= 0;
        out_valid <= 0;
        cnt <= 0;
        bxmaxok <= 0;
        bxminok <= 0;
        bymaxok <= 0;
        byminok <= 0;
        out_ok <= 0;
    end
    else begin
        if(in_valid) begin
            out_ok <= 1;
            out_max_value <= -2048;
            cnt <= cnt + 1;
            if(cnt == 0) begin
                c1 <= in_a1;
                c2 <= in_a2;
            end
            if(1 <= cnt && cnt <= 6) begin
                xa1[cnt - 1] <= in_a1;
                xa2[cnt - 1] <= in_a2;
                xb[cnt - 1] <= in_b;
                if(in_a1 == 1 && in_a2 == 0) begin
                    if(bxmaxok == 0) begin
                        bdx_max <= in_b;
                        bxmaxok <= 1;
                    end
                    else begin
                        if(in_b < bdx_max) begin
                            bdx_max <= in_b;
                        end
                    end
                end
                if(in_a1 == -1 && in_a2 == 0) begin
                    if(bxminok == 0) begin
                        bdx_min <= -in_b;
                        bxminok <= 1;
                    end
                    else begin
                        if(-in_b > bdx_min) begin
                            bdx_min <= -in_b;
                        end
                    end
                end
                if(in_a1 == 0 && in_a2 == 1) begin
                    if(bymaxok == 0) begin
                        bdy_max <= in_b;
                        bymaxok <= 1;
                    end
                    else begin
                        if(in_b < bdy_max) begin
                            bdy_max <= in_b;
                        end
                    end
                end
                if(in_a1 == 0 && in_a2 == -1) begin
                    if(byminok == 0) begin
                        bdy_min <= -in_b;
                        byminok <= 1;
                    end
                    else begin
                        if(-in_b > bdy_min) begin
                            bdy_min <= -in_b;
                        end
                    end
                end
            end
        end
        else begin
            if(xa1[0] * x1 + xa2[0] * x2 <= xb[0] && xa1[1] * x1 + xa2[1] * x2 <= xb[1] && xa1[2] * x1 + xa2[2] * x2 <= xb[2] && 
                xa1[3] * x1 + xa2[3] * x2 <= xb[3] && xa1[4] * x1 + xa2[4] * x2 <= xb[4] && xa1[5] * x1 + xa2[5] * x2 <= xb[5]) begin
                out_max_value <= (c1 * x1 + c2 * x2 < out_max_value)? out_max_value : c1 * x1 + c2 * x2;
            end
        end
        if(x2 == bdy_max && x1 == bdx_max && out_ok && !in_valid) begin
            out_valid <= 1;
        end
        if(out_valid) begin
            out_valid <= 0;
            cnt <= 0;
            bxmaxok <= 0;
            bxminok <= 0;
            bymaxok <= 0;
            byminok <= 0;
            out_ok <= 0;
        end
        
    end
end

endmodule