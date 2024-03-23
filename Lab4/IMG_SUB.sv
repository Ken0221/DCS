module IMG_SUB(
  // Input signals
	clk,
	rst_n,
  in_valid,
  in_image,
  // Output signals
  out_valid,
	out_diff
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n ;
input in_valid ;
input [3:0] in_image ;
output logic out_valid ;
output logic [3:0] out_diff ;
 
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------

logic [3:0] p1_1, p1_2, p1_3, p1_4, p1_5, p1_6, p1_7, p1_8, p1_9;
logic [3:0] p2_1, p2_2, p2_3, p2_4, p2_5, p2_6, p2_7, p2_8, p2_9;
logic [4:0] cnt, o_cnt;
logic [3:0] temp;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------


always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
      out_valid <= 0;
      out_diff <= 0;
      cnt <= 0;
      o_cnt <= 0;
    end
    else begin
      if(in_valid) begin
        p2_9 <= in_image;
        p1_1 <= p1_2;
        p1_2 <= p1_3;
        p1_3 <= p1_4;
        p1_4 <= p1_5;
        p1_5 <= p1_6;
        p1_6 <= p1_7;
        p1_7 <= p1_8;
        p1_8 <= p1_9;
        p1_9 <= p2_1;
        p2_1 <= p2_2;
        p2_2 <= p2_3;
        p2_3 <= p2_4;
        p2_4 <= p2_5;
        p2_5 <= p2_6;
        p2_6 <= p2_7;
        p2_7 <= p2_8;
        p2_8 <= p2_9;
        

        cnt <= cnt + 1;
        
      end
      
      if(cnt == 18) begin
        out_valid <= 1;
        out_diff <=  (p1_1 - p2_1);
        p1_1 <= p1_2;
        p1_2 <= p1_3;
        p1_3 <= p1_4;
        p1_4 <= p1_5;
        p1_5 <= p1_6;
        p1_6 <= p1_7;
        p1_7 <= p1_8;
        p1_8 <= p1_9;

        p2_1 <= p2_2;
        p2_2 <= p2_3;
        p2_3 <= p2_4;
        p2_4 <= p2_5;
        p2_5 <= p2_6;
        p2_6 <= p2_7;
        p2_7 <= p2_8;
        p2_8 <= p2_9;

        o_cnt <= o_cnt + 1;
      end
      else begin
        out_diff <= 0;
      end
      if(o_cnt == 9) begin
        out_valid <= 0;
        cnt <= 0;
        o_cnt <= 0;
        out_diff <= 0;
      end
      
    end
end

endmodule