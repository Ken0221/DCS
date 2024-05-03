module PIPE(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_1,
  in_2,
  in_3,
  in_4,
  mode,
  // Output signals
  out_valid,
  out_value
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input  logic clk,rst_n,in_valid;
input  logic [5:0]in_1,in_2,in_3,in_4;
input  logic [1:0] mode;

output logic out_valid;

output logic [26:0]out_value;
//---------------------------------------------------------------------
//   Design
//---------------------------------------------------------------------
logic [11:0] m12, m34;
logic [6:0] p34;
logic [11:0] m12_t1, m34_t1, p34_t1;
logic [11:0] m12_t2, m34_t2, p34_t2;

always @(posedge clk) begin
  m12_t1 <= m12;
  m34_t1 <= m34;
  p34_t1 <= p34;
  m12_t2 <= m12_t1;
  m34_t2 <= m34_t1;
  p34_t2 <= p34_t1;
end

logic [2:0] l1, s1, l2, s2;
logic [2:0] l3, s3, l4, s4;
logic [11:0] p12_4, p12_3, p12_2, p12_1;
logic [11:0] p34_1, p34_2, p34_3, p34_4;

logic [5:0] ll1, ss1, ll2, ss2;
logic [23:0] p4, p3, p2, p1;

logic [23:0] m1234;
logic [1:0] mode_1, mode_2, mode_3, mode_4;

logic in_valid_1, in_valid_2, in_valid_3, in_valid_4;

logic [5:0] in_3_1, in_3_2;
logic [5:0] in_4_1, in_4_2;

assign out_valid = (rst_n && in_valid_4)? 1: 0;

always @(posedge clk) begin
  in_valid_1 <= in_valid;
  in_valid_2 <= in_valid_1;
  in_valid_3 <= in_valid_2;
  in_valid_4 <= in_valid_3;
  mode_1 <= mode;
  mode_2 <= mode_1;
  mode_3 <= mode_2;
  mode_4 <= mode_3;
  in_3_1 <= in_3;
  in_3_2 <= in_3_1;
  in_4_1 <= in_4;
  in_4_2 <= in_4_1;
end
assign p34 = in_3_2 + in_4_2;

assign  l1 = in_1[5:3];
assign  l2 = in_2[5:3];
assign  l3 = in_3[5:3];
assign  l4 = in_4[5:3];
assign  s1 = in_1[2:0];
assign  s2 = in_2[2:0];
assign  s3 = in_3[2:0];
assign  s4 = in_4[2:0];

assign ll1 = m12[11:6];
assign ss1 = m12[5:0];
assign ll2 = m34[11:6];
assign ss2 = m34[5:0];

always @(posedge clk) begin
      p12_4 <= l1 * l2;
      p12_3 <= l1 * s2;
      p12_2 <= s1 * l2;
      p12_1 <= s1 * s2;
      p34_4 <= l3 * l4;
      p34_3 <= l3 * s4;
      p34_2 <= s3 * l4;
      p34_1 <= s3 * s4;

      p4 <= ll1 * ll2;
      p3 <= ll1 * ss2;
      p2 <= ss1 * ll2;
      p1 <= ss1 * ss2;
end

always @(*) begin
  if(!rst_n)begin
    out_value = 0;
  end
  else begin
    case(mode_4)
      0: out_value = m12_t2;
      1: out_value = p34_t2;
      2: out_value = m1234;
      default: out_value = 0;
    endcase
    if(out_valid == 0) begin
      out_value = 0;
    end
  end
end

always @(posedge clk, negedge rst_n) begin
  if(!rst_n) begin
  end
  else begin
    if(in_valid) begin
      
    end
    m12 <= (p12_4 << 6) + (p12_3 << 3) + (p12_2 << 3) + p12_1;
    m34 <= (p34_4 << 6) + (p34_3 << 3) + (p34_2 << 3) + p34_1;
    m1234 <= (p4 << 12) + (p3 << 6) + (p2 << 6) + p1;
  end
end

endmodule
