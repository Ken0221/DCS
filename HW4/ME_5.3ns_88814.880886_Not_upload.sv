module ME(
    // Input signals
	clk,
	rst_n,
    block_valid,
	area_valid,
    in_data,
    // Output signals
    out_valid,
    out_vector
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, block_valid, area_valid;
input [7:0] in_data;

output logic out_valid;
output logic signed [2:0] out_vector;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [7:0] curr_block[0:15];
logic [11:0] sum_array[0:27];
logic out_cnt;
logic IsInvalid;
logic signed [2:0] min_x, min_y;
logic signed [2:0] min_x_t, min_y_t;

logic [11:0] min_num;

logic [5:0] abs_cnt;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign min_x_t = (min_num > sum_array[27])? 2: min_x;
assign min_y_t = (min_num > sum_array[27])? -2: min_y;

assign out_vector = (rst_n && out_valid)? ((out_cnt)? min_y_t: min_x_t): 0;
logic [0:2] x_cnt, y_cnt;
always @(posedge clk) begin
    if(block_valid) begin
        min_num <= 12'b111111111111;
        x_cnt <= 0;
        y_cnt <= 0;
    end
    if(abs_cnt >= 28 && (abs_cnt - 28) % 8 < 5) begin
        if(x_cnt == 4) begin
            y_cnt <= y_cnt + 1;
            x_cnt <= 0;
        end
        else
            x_cnt <= x_cnt + 1;
        
        if(min_num > sum_array[27]) begin
            min_x <=  x_cnt - 2;
            min_y <=  2 - y_cnt;
            min_num <= sum_array[27];
        end
    end
end

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        IsInvalid <= 0;
        abs_cnt <= 0;
    end
    else begin
        if(block_valid) begin
            curr_block[15] <= in_data;
            curr_block[14] <= curr_block[15];
            curr_block[13] <= curr_block[14];
            curr_block[12] <= curr_block[13];
            curr_block[11] <= curr_block[12];
            curr_block[10] <= curr_block[11];
            curr_block[9] <= curr_block[10];
            curr_block[8] <= curr_block[9];
            curr_block[7] <= curr_block[8];
            curr_block[6] <= curr_block[7];
            curr_block[5] <= curr_block[6];
            curr_block[4] <= curr_block[5];
            curr_block[3] <= curr_block[4];
            curr_block[2] <= curr_block[3];
            curr_block[1] <= curr_block[2];
            curr_block[0] <= curr_block[1];
            IsInvalid <= 1;
            sum_array[0] <= 0;
            sum_array[1] <= 0;
            sum_array[2] <= 0;
            sum_array[3] <= 0;
            sum_array[4] <= 0;
            sum_array[5] <= 0;
            sum_array[6] <= 0;
            sum_array[7] <= 0;
            sum_array[8] <= 0;
            sum_array[9] <= 0;
            sum_array[10] <= 0;
            sum_array[11] <= 0;
            sum_array[12] <= 0;
            sum_array[13] <= 0;
            sum_array[14] <= 0;
            sum_array[15] <= 0;
            sum_array[16] <= 0;
            sum_array[17] <= 0;
            sum_array[18] <= 0;
            sum_array[19] <= 0;
            sum_array[20] <= 0;
            sum_array[21] <= 0;
            sum_array[22] <= 0;
            sum_array[23] <= 0;
            sum_array[24] <= 0;
            sum_array[25] <= 0;
            sum_array[26] <= 0;
            sum_array[27] <= 0;
        end
        if(area_valid)begin
            abs_cnt <= abs_cnt + 1;
            sum_array[0] <= (in_data > curr_block[0])? in_data - curr_block[0]: curr_block[0] - in_data;
            sum_array[1] <= sum_array[0] + ((in_data > curr_block[1])? in_data - curr_block[1]: curr_block[1] - in_data);
            sum_array[2] <= sum_array[1] + ((in_data > curr_block[2])? in_data - curr_block[2]: curr_block[2] - in_data);
            sum_array[3] <= sum_array[2] + ((in_data > curr_block[3])? in_data - curr_block[3]: curr_block[3] - in_data);
            sum_array[4] <= sum_array[3];
            sum_array[5] <= sum_array[4];
            sum_array[6] <= sum_array[5];
            sum_array[7] <= sum_array[6];
            sum_array[8] <= sum_array[7] + ((in_data > curr_block[4])? in_data - curr_block[4]: curr_block[4] - in_data);
            sum_array[9] <= sum_array[8] + ((in_data > curr_block[5])? in_data - curr_block[5]: curr_block[5] - in_data);
            sum_array[10] <= sum_array[9] + ((in_data > curr_block[6])? in_data - curr_block[6]: curr_block[6] - in_data);
            sum_array[11] <= sum_array[10] + ((in_data > curr_block[7])? in_data - curr_block[7]: curr_block[7] - in_data);
            sum_array[12] <= sum_array[11];
            sum_array[13] <= sum_array[12];
            sum_array[14] <= sum_array[13];
            sum_array[15] <= sum_array[14];
            sum_array[16] <= sum_array[15] + ((in_data > curr_block[8])? in_data - curr_block[8]: curr_block[8] - in_data);
            sum_array[17] <= sum_array[16] + ((in_data > curr_block[9])? in_data - curr_block[9]: curr_block[9] - in_data);
            sum_array[18] <= sum_array[17] + ((in_data > curr_block[10])? in_data - curr_block[10]: curr_block[10] - in_data);
            sum_array[19] <= sum_array[18] + ((in_data > curr_block[11])? in_data - curr_block[11]: curr_block[11] - in_data);
            sum_array[20] <= sum_array[19];
            sum_array[21] <= sum_array[20];
            sum_array[22] <= sum_array[21];
            sum_array[23] <= sum_array[22];
            sum_array[24] <= sum_array[23] + ((in_data > curr_block[12])? in_data - curr_block[12]: curr_block[12] - in_data);
            sum_array[25] <= sum_array[24] + ((in_data > curr_block[13])? in_data - curr_block[13]: curr_block[13] - in_data);
            sum_array[26] <= sum_array[25] + ((in_data > curr_block[14])? in_data - curr_block[14]: curr_block[14] - in_data);
            sum_array[27] <= sum_array[26] + ((in_data > curr_block[15])? in_data - curr_block[15]: curr_block[15] - in_data);
        end
            

        if(IsInvalid && !area_valid && !block_valid) begin
            out_valid <= 1;
        end
        if(out_valid) begin
            out_cnt <= out_cnt + 1;
        end
        else begin
            out_cnt <= 0;
        end
        if(out_cnt == 1) begin
            out_valid <= 0;
            IsInvalid <= 0;
        end
    end
end

endmodule