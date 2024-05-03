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
logic [11:0] sum_array[0:63];
logic [7:0] data;
logic signed [2:0] vector_x, vector_y;
logic out_cnt;
logic IsInvalid;
logic signed [2:0] min_x, min_y;
logic signed [2:0] min_x_t, min_y_t;


logic [11:0] min_num;
logic [5:0] check;

logic [3:0] in_cnt;
logic [5:0] abs_cnt;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign check = (abs_cnt >> 4);
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

// logic [3:0]

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        IsInvalid <= 0;
        in_cnt <= 0; 
        abs_cnt <= 0;
    end
    else begin
        if(block_valid) begin
            curr_block[in_cnt] <= in_data;
            in_cnt <= in_cnt + 1;
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
            sum_array[28] <= 0;
            sum_array[29] <= 0;
            sum_array[30] <= 0;
            sum_array[31] <= 0;
            sum_array[32] <= 0;
            sum_array[33] <= 0;
            sum_array[34] <= 0;
            sum_array[35] <= 0;
            sum_array[36] <= 0;
            sum_array[37] <= 0;
            sum_array[38] <= 0;
            sum_array[39] <= 0;
            sum_array[40] <= 0;
            sum_array[41] <= 0;
            sum_array[42] <= 0;
            sum_array[43] <= 0;
            sum_array[44] <= 0;
            sum_array[45] <= 0;
            sum_array[46] <= 0;
            sum_array[47] <= 0;
            sum_array[48] <= 0;
            sum_array[49] <= 0;
            sum_array[50] <= 0;
            sum_array[51] <= 0;
            sum_array[52] <= 0;
            sum_array[53] <= 0;
            sum_array[54] <= 0;
            sum_array[55] <= 0;
            sum_array[56] <= 0;
            sum_array[57] <= 0;
            sum_array[58] <= 0;
            sum_array[59] <= 0;
            sum_array[60] <= 0;
            sum_array[61] <= 0;
            sum_array[62] <= 0;
            sum_array[63] <= 0;
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
            sum_array[28] <= sum_array[27];
            sum_array[29] <= sum_array[28];
            sum_array[30] <= sum_array[29];
            sum_array[31] <= sum_array[30];
            sum_array[32] <= sum_array[31];
            sum_array[33] <= sum_array[32];
            sum_array[34] <= sum_array[33];
            sum_array[35] <= sum_array[34];
            sum_array[36] <= sum_array[35];
            sum_array[37] <= sum_array[36];
            sum_array[38] <= sum_array[37];
            sum_array[39] <= sum_array[38];
            sum_array[40] <= sum_array[39];
            sum_array[41] <= sum_array[40];
            sum_array[42] <= sum_array[41];
            sum_array[43] <= sum_array[42];
            sum_array[44] <= sum_array[43];
            sum_array[45] <= sum_array[44];
            sum_array[46] <= sum_array[45];
            sum_array[47] <= sum_array[46];
            sum_array[48] <= sum_array[47];
            sum_array[49] <= sum_array[48];
            sum_array[50] <= sum_array[49];
            sum_array[51] <= sum_array[50];
            sum_array[52] <= sum_array[51];
            sum_array[53] <= sum_array[52];
            sum_array[54] <= sum_array[53];
            sum_array[55] <= sum_array[54];
            sum_array[56] <= sum_array[55];
            sum_array[57] <= sum_array[56];
            sum_array[58] <= sum_array[57];
            sum_array[59] <= sum_array[58];
            sum_array[60] <= sum_array[59];
            sum_array[61] <= sum_array[60];
            sum_array[62] <= sum_array[61];
            sum_array[63] <= sum_array[62];
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