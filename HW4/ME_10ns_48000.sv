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
logic [7:0] search_area[0:7][0:7];
logic [7:0] curr_block[0:3][0:3];
logic [1:0] x_curr, y_curr;
logic [2:0] x_area, y_area;
logic signed [2:0] vector_x, vector_y;
logic cnt;
logic IsInvalid;
logic [7:0] abs00[0:3][0:3], abs01[0:3][0:3], abs02[0:3][0:3], abs03[0:3][0:3], abs04[0:3][0:3],
            abs10[0:3][0:3], abs11[0:3][0:3], abs12[0:3][0:3], abs13[0:3][0:3], abs14[0:3][0:3],
            abs20[0:3][0:3], abs21[0:3][0:3], abs22[0:3][0:3], abs23[0:3][0:3], abs24[0:3][0:3],
            abs30[0:3][0:3], abs31[0:3][0:3], abs32[0:3][0:3], abs33[0:3][0:3], abs34[0:3][0:3],
            abs40[0:3][0:3], abs41[0:3][0:3], abs42[0:3][0:3], abs43[0:3][0:3], abs44[0:3][0:3];
logic [11:0] sum00, sum01, sum02, sum03, sum04,
            sum10, sum11, sum12, sum13, sum14,
            sum20, sum21, sum22, sum23, sum24,
            sum30, sum31, sum32, sum33, sum34,
            sum40, sum41, sum42, sum43, sum44;
logic [4:0] min_pos, min_pos1, min_pos_f;
logic [11:0] min_num, min_num1, min_num_f;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
initial begin
    integer i, j;
    for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
            search_area[i][j] = 8'd0;  // 初始化為0
        end
    end
end

always @(*) begin
    if(!rst_n) begin
        out_vector = 0;
    end
    else begin
        if(out_valid) begin
            out_vector = (cnt == 0)? vector_x: vector_y;
        end
        else begin
            out_vector = 0;
        end
    end 
end

always @(*) begin
        min_num1 = (min_num < sum43)? min_num: sum43;
        min_pos1 = (min_num < sum43)? min_pos: 23;
        min_num_f = (min_num1 < sum44)? min_num1: sum44;
        min_pos_f = (min_num1 < sum44)? min_pos1: 24;
        case(min_pos_f) //vector
            // 0: begin
            //     vector_x = -2;
            //     vector_y = 2;
            // end
            1:begin
                vector_x = -1;
                vector_y = 2;
            end
            2:begin
                vector_x = 0;
                vector_y = 2;
            end
            3:begin
                vector_x = 1;
                vector_y = 2;
            end
            4:begin
                vector_x = 2;
                vector_y = 2;
            end
            5:begin
                vector_x = -2;
                vector_y = 1;
            end
            6:begin
                vector_x = -1;
                vector_y = 1;
            end
            7:begin
                vector_x = 0;
                vector_y = 1;
            end
            8:begin
                vector_x = 1;
                vector_y = 1;
            end
            9:begin
                vector_x = 2;
                vector_y = 1;
            end
            10:begin
                vector_x = -2;
                vector_y = 0;
            end
            11:begin
                vector_x = -1;
                vector_y = 0;
            end
            12:begin
                vector_x = 0;
                vector_y = 0;
            end
            13:begin
                vector_x = 1;
                vector_y = 0;
            end
            14:begin
                vector_x = 2;
                vector_y = 0;
            end
            15:begin
                vector_x = -2;
                vector_y = -1;
            end
            16:begin
                vector_x = -1;
                vector_y = -1;
            end
            17:begin
                vector_x = 0;
                vector_y = -1;
            end
            18:begin
                vector_x = 1;
                vector_y = -1;
            end
            19:begin
                vector_x = 2;
                vector_y = -1;
            end
            20:begin
                vector_x = -2;
                vector_y = -2;
            end
            21:begin
                vector_x = -1;
                vector_y = -2;
            end
            22:begin
                vector_x = 0;
                vector_y = -2;
            end
            23:begin
                vector_x = 1;
                vector_y = -2;
            end
            24:begin
                vector_x = 2;
                vector_y = -2;
            end
            default: begin
                vector_x = -2;
                vector_y = 2;
            end
        endcase
end

always @(posedge clk) begin //sum
    sum00 <= abs00[0][0] + abs00[0][1] + abs00[0][2] + abs00[0][3]
            + abs00[1][0] + abs00[1][1] + abs00[1][2] + abs00[1][3]
            + abs00[2][0] + abs00[2][1] + abs00[2][2] + abs00[2][3]
            + abs00[3][0] + abs00[3][1] + abs00[3][2] + abs00[3][3];
    sum01 <= abs01[0][0] + abs01[0][1] + abs01[0][2] + abs01[0][3]
            + abs01[1][0] + abs01[1][1] + abs01[1][2] + abs01[1][3]
            + abs01[2][0] + abs01[2][1] + abs01[2][2] + abs01[2][3]
            + abs01[3][0] + abs01[3][1] + abs01[3][2] + abs01[3][3];
    sum02 <= abs02[0][0] + abs02[0][1] + abs02[0][2] + abs02[0][3]
            + abs02[1][0] + abs02[1][1] + abs02[1][2] + abs02[1][3]
            + abs02[2][0] + abs02[2][1] + abs02[2][2] + abs02[2][3]
            + abs02[3][0] + abs02[3][1] + abs02[3][2] + abs02[3][3];
    sum03 <= abs03[0][0] + abs03[0][1] + abs03[0][2] + abs03[0][3]
            + abs03[1][0] + abs03[1][1] + abs03[1][2] + abs03[1][3]
            + abs03[2][0] + abs03[2][1] + abs03[2][2] + abs03[2][3]
            + abs03[3][0] + abs03[3][1] + abs03[3][2] + abs03[3][3];
    sum04 <= abs04[0][0] + abs04[0][1] + abs04[0][2] + abs04[0][3]
            + abs04[1][0] + abs04[1][1] + abs04[1][2] + abs04[1][3]
            + abs04[2][0] + abs04[2][1] + abs04[2][2] + abs04[2][3]
            + abs04[3][0] + abs04[3][1] + abs04[3][2] + abs04[3][3];
    sum10 <= abs10[0][0] + abs10[0][1] + abs10[0][2] + abs10[0][3]
            + abs10[1][0] + abs10[1][1] + abs10[1][2] + abs10[1][3]
            + abs10[2][0] + abs10[2][1] + abs10[2][2] + abs10[2][3]
            + abs10[3][0] + abs10[3][1] + abs10[3][2] + abs10[3][3];
    sum11 <= abs11[0][0] + abs11[0][1] + abs11[0][2] + abs11[0][3]
            + abs11[1][0] + abs11[1][1] + abs11[1][2] + abs11[1][3]
            + abs11[2][0] + abs11[2][1] + abs11[2][2] + abs11[2][3]
            + abs11[3][0] + abs11[3][1] + abs11[3][2] + abs11[3][3];
    sum12 <= abs12[0][0] + abs12[0][1] + abs12[0][2] + abs12[0][3]
            + abs12[1][0] + abs12[1][1] + abs12[1][2] + abs12[1][3]
            + abs12[2][0] + abs12[2][1] + abs12[2][2] + abs12[2][3]
            + abs12[3][0] + abs12[3][1] + abs12[3][2] + abs12[3][3];
    sum13 <= abs13[0][0] + abs13[0][1] + abs13[0][2] + abs13[0][3]
            + abs13[1][0] + abs13[1][1] + abs13[1][2] + abs13[1][3]
            + abs13[2][0] + abs13[2][1] + abs13[2][2] + abs13[2][3]
            + abs13[3][0] + abs13[3][1] + abs13[3][2] + abs13[3][3];
    sum14 <= abs14[0][0] + abs14[0][1] + abs14[0][2] + abs14[0][3]
            + abs14[1][0] + abs14[1][1] + abs14[1][2] + abs14[1][3]
            + abs14[2][0] + abs14[2][1] + abs14[2][2] + abs14[2][3]
            + abs14[3][0] + abs14[3][1] + abs14[3][2] + abs14[3][3];
    sum20 <= abs20[0][0] + abs20[0][1] + abs20[0][2] + abs20[0][3]
            + abs20[1][0] + abs20[1][1] + abs20[1][2] + abs20[1][3]
            + abs20[2][0] + abs20[2][1] + abs20[2][2] + abs20[2][3]
            + abs20[3][0] + abs20[3][1] + abs20[3][2] + abs20[3][3];
    sum21 <= abs21[0][0] + abs21[0][1] + abs21[0][2] + abs21[0][3]
            + abs21[1][0] + abs21[1][1] + abs21[1][2] + abs21[1][3]
            + abs21[2][0] + abs21[2][1] + abs21[2][2] + abs21[2][3]
            + abs21[3][0] + abs21[3][1] + abs21[3][2] + abs21[3][3];
    sum22 <= abs22[0][0] + abs22[0][1] + abs22[0][2] + abs22[0][3]
            + abs22[1][0] + abs22[1][1] + abs22[1][2] + abs22[1][3]
            + abs22[2][0] + abs22[2][1] + abs22[2][2] + abs22[2][3]
            + abs22[3][0] + abs22[3][1] + abs22[3][2] + abs22[3][3];
    sum23 <= abs23[0][0] + abs23[0][1] + abs23[0][2] + abs23[0][3]
            + abs23[1][0] + abs23[1][1] + abs23[1][2] + abs23[1][3]
            + abs23[2][0] + abs23[2][1] + abs23[2][2] + abs23[2][3]
            + abs23[3][0] + abs23[3][1] + abs23[3][2] + abs23[3][3];
    sum24 <= abs24[0][0] + abs24[0][1] + abs24[0][2] + abs24[0][3]
            + abs24[1][0] + abs24[1][1] + abs24[1][2] + abs24[1][3]
            + abs24[2][0] + abs24[2][1] + abs24[2][2] + abs24[2][3]
            + abs24[3][0] + abs24[3][1] + abs24[3][2] + abs24[3][3];
    sum30 <= abs30[0][0] + abs30[0][1] + abs30[0][2] + abs30[0][3]
            + abs30[1][0] + abs30[1][1] + abs30[1][2] + abs30[1][3]
            + abs30[2][0] + abs30[2][1] + abs30[2][2] + abs30[2][3]
            + abs30[3][0] + abs30[3][1] + abs30[3][2] + abs30[3][3];
    sum31 <= abs31[0][0] + abs31[0][1] + abs31[0][2] + abs31[0][3]
            + abs31[1][0] + abs31[1][1] + abs31[1][2] + abs31[1][3]
            + abs31[2][0] + abs31[2][1] + abs31[2][2] + abs31[2][3]
            + abs31[3][0] + abs31[3][1] + abs31[3][2] + abs31[3][3];
    sum32 <= abs32[0][0] + abs32[0][1] + abs32[0][2] + abs32[0][3]
            + abs32[1][0] + abs32[1][1] + abs32[1][2] + abs32[1][3]
            + abs32[2][0] + abs32[2][1] + abs32[2][2] + abs32[2][3]
            + abs32[3][0] + abs32[3][1] + abs32[3][2] + abs32[3][3];
    sum33 <= abs33[0][0] + abs33[0][1] + abs33[0][2] + abs33[0][3]
            + abs33[1][0] + abs33[1][1] + abs33[1][2] + abs33[1][3]
            + abs33[2][0] + abs33[2][1] + abs33[2][2] + abs33[2][3]
            + abs33[3][0] + abs33[3][1] + abs33[3][2] + abs33[3][3];
    sum34 <= abs34[0][0] + abs34[0][1] + abs34[0][2] + abs34[0][3]
            + abs34[1][0] + abs34[1][1] + abs34[1][2] + abs34[1][3]
            + abs34[2][0] + abs34[2][1] + abs34[2][2] + abs34[2][3]
            + abs34[3][0] + abs34[3][1] + abs34[3][2] + abs34[3][3];
    sum40 <= abs40[0][0] + abs40[0][1] + abs40[0][2] + abs40[0][3]
            + abs40[1][0] + abs40[1][1] + abs40[1][2] + abs40[1][3]
            + abs40[2][0] + abs40[2][1] + abs40[2][2] + abs40[2][3]
            + abs40[3][0] + abs40[3][1] + abs40[3][2] + abs40[3][3];
    sum41 <= abs41[0][0] + abs41[0][1] + abs41[0][2] + abs41[0][3]
            + abs41[1][0] + abs41[1][1] + abs41[1][2] + abs41[1][3]
            + abs41[2][0] + abs41[2][1] + abs41[2][2] + abs41[2][3]
            + abs41[3][0] + abs41[3][1] + abs41[3][2] + abs41[3][3];
    sum42 <= abs42[0][0] + abs42[0][1] + abs42[0][2] + abs42[0][3]
            + abs42[1][0] + abs42[1][1] + abs42[1][2] + abs42[1][3]
            + abs42[2][0] + abs42[2][1] + abs42[2][2] + abs42[2][3]
            + abs42[3][0] + abs42[3][1] + abs42[3][2] + abs42[3][3];
    sum43 <= abs43[0][0] + abs43[0][1] + abs43[0][2] + abs43[0][3]
            + abs43[1][0] + abs43[1][1] + abs43[1][2] + abs43[1][3]
            + abs43[2][0] + abs43[2][1] + abs43[2][2] + abs43[2][3]
            + abs43[3][0] + abs43[3][1] + abs43[3][2] + abs43[3][3];
    sum44 <= abs44[0][0] + abs44[0][1] + abs44[0][2] + abs44[0][3]
            + abs44[1][0] + abs44[1][1] + abs44[1][2] + abs44[1][3]
            + abs44[2][0] + abs44[2][1] + abs44[2][2] + abs44[2][3]
            + abs44[3][0] + abs44[3][1] + abs44[3][2] + abs44[3][3];
end

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        x_curr <= 0; y_curr <= 0;
        x_area <= 0; y_area <= 0;
        cnt <= 0;
        IsInvalid <= 0;
    end
    else begin
        if(block_valid) begin
            curr_block[x_curr][y_curr] <= in_data;
            if(y_curr == 3)
                x_curr <= x_curr + 1;
            y_curr <= y_curr + 1;
            IsInvalid <= 1;
        end
        if(area_valid)begin
            search_area[x_area][y_area] <= in_data;
            if(y_area == 7)
                x_area <= x_area + 1;
            y_area <= y_area + 1;
            case({x_area, y_area}) //abs
                //x = 0
                {3'd0, 3'd0}: begin
                    abs00[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd0, 3'd1}:begin
                    abs00[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs01[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd0, 3'd2}: begin
                    abs00[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs01[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs02[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd0, 3'd3}: begin
                    abs00[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs01[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs02[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs03[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd0, 3'd4}: begin
                    abs01[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs02[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs03[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs04[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd0, 3'd5}: begin
                    abs02[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs03[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs04[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                end
                {3'd0, 3'd6}: begin
                    abs03[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs04[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                end
                {3'd0, 3'd7}: begin
                    abs04[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                end
                //x = 1
                {3'd1, 3'd0}: begin
                    abs00[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs10[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd1, 3'd1}: begin
                    abs00[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs01[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs10[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs11[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd1, 3'd2}: begin
                    abs00[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs01[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs02[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs10[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs11[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs12[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd1, 3'd3}: begin
                    abs00[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs01[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs02[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs03[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs10[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs11[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs12[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs13[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd1, 3'd4}: begin
                    abs01[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs02[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs03[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs04[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs11[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs12[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs13[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs14[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd1, 3'd5}: begin
                    abs02[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs03[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs04[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs12[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs13[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs14[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                end
                {3'd1, 3'd6}: begin
                    abs03[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs04[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs13[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs14[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                end
                {3'd1, 3'd7}: begin
                    abs04[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs14[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                end
                //x = 2
                {3'd2, 3'd0}: begin
                    abs00[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs10[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs20[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd2, 3'd1}: begin
                    abs00[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs01[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs10[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs11[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs20[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs21[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd2, 3'd2}: begin
                    abs00[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs01[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs02[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs10[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs11[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs12[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs20[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs21[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs22[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd2, 3'd3}: begin
                    abs00[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs01[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs02[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs03[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs10[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs11[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs12[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs13[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs20[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs21[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs22[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs23[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd2, 3'd4}: begin
                    abs01[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs02[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs03[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs04[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs11[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs12[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs13[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs14[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs21[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs22[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs23[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs24[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd2, 3'd5}: begin
                    abs02[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs03[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs04[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs12[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs13[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs14[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs22[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs23[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs24[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                end
                {3'd2, 3'd6}: begin
                    abs03[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs04[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs13[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs14[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs23[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs24[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                end
                {3'd2, 3'd7}: begin
                    abs04[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs14[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs24[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                end
                //x = 3
                {3'd3, 3'd0}: begin
                    abs00[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs10[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs20[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs30[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd3, 3'd1}: begin
                    abs00[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs01[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs10[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs11[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs20[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs21[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs30[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs31[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd3, 3'd2}: begin
                    abs00[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs01[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs02[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs10[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs11[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs12[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs20[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs21[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs22[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs30[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs31[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs32[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd3, 3'd3}: begin
                    abs00[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs01[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs02[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs03[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs10[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs11[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs12[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs13[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs20[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs21[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs22[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs23[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs30[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs31[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs32[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs33[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;                
                end
                {3'd3, 3'd4}: begin
                    abs01[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs02[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs03[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs04[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs11[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs12[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs13[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs14[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs21[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs22[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs23[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs24[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs31[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs32[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs33[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs34[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                    // sum00 <= abs00[0][0] + abs00[0][1] + abs00[0][2] + abs00[0][3]
                    //     + abs00[1][0] + abs00[1][1] + abs00[1][2] + abs00[1][3]
                    //     + abs00[2][0] + abs00[2][1] + abs00[2][2] + abs00[2][3]
                    //     + abs00[3][0] + abs00[3][1] + abs00[3][2] + abs00[3][3];
                end
                {3'd3, 3'd5}: begin
                    abs02[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs03[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs04[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs12[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs13[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs14[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs22[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs23[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs24[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs32[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs33[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs34[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    // sum01 <= abs01[0][0] + abs01[0][1] + abs01[0][2] + abs01[0][3]
                    //     + abs01[1][0] + abs01[1][1] + abs01[1][2] + abs01[1][3]
                    //     + abs01[2][0] + abs01[2][1] + abs01[2][2] + abs01[2][3]
                    //     + abs01[3][0] + abs01[3][1] + abs01[3][2] + abs01[3][3];
                end
                {3'd3, 3'd6}: begin
                    abs03[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs04[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs13[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs14[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs23[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs24[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs33[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs34[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    // sum02 <= abs02[0][0] + abs02[0][1] + abs02[0][2] + abs02[0][3]
                    //     + abs02[1][0] + abs02[1][1] + abs02[1][2] + abs02[1][3]
                    //     + abs02[2][0] + abs02[2][1] + abs02[2][2] + abs02[2][3]
                    //     + abs02[3][0] + abs02[3][1] + abs02[3][2] + abs02[3][3];
                    min_num <= (sum00 < sum01)? sum00: sum01;
                    min_pos <= (sum00 < sum01)? 0: 1;
                end
                {3'd3, 3'd7}: begin
                    abs04[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs14[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs24[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs34[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    // sum03 <= abs03[0][0] + abs03[0][1] + abs03[0][2] + abs03[0][3]
                    //     + abs03[1][0] + abs03[1][1] + abs03[1][2] + abs03[1][3]
                    //     + abs03[2][0] + abs03[2][1] + abs03[2][2] + abs03[2][3]
                    //     + abs03[3][0] + abs03[3][1] + abs03[3][2] + abs03[3][3];
                    min_num <= (sum02 < min_num)? sum02: min_num;
                    min_pos <= (sum02 < min_num)? 2: min_pos;
                end
                //x = 4
                {3'd4, 3'd0}: begin
                    abs10[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs20[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs30[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs40[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                    // sum04 <= abs04[0][0] + abs04[0][1] + abs04[0][2] + abs04[0][3]
                    //     + abs04[1][0] + abs04[1][1] + abs04[1][2] + abs04[1][3]
                    //     + abs04[2][0] + abs04[2][1] + abs04[2][2] + abs04[2][3]
                    //     + abs04[3][0] + abs04[3][1] + abs04[3][2] + abs04[3][3];
                    min_num <= (sum03 < min_num)? sum03: min_num;
                    min_pos <= (sum03 < min_num)? 3: min_pos;
                end
                {3'd4, 3'd1}: begin
                    abs10[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs11[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs20[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs21[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs30[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs31[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs40[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs41[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                    min_num <= (sum04 < min_num)? sum04: min_num;
                    min_pos <= (sum04 < min_num)? 4: min_pos;
                end
                {3'd4, 3'd2}: begin
                    abs10[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs11[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs12[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs20[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs21[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs22[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs30[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs31[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs32[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs40[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs41[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs42[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd4, 3'd3}: begin
                    abs10[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs11[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs12[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs13[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs20[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs21[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs22[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs23[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs30[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs31[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs32[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs33[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs40[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs41[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs42[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs43[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                end
                {3'd4, 3'd4}: begin
                    abs11[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs12[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs13[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs14[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs21[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs22[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs23[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs24[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs31[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs32[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs33[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs34[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    abs41[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs42[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs43[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    abs44[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
                    // sum10 <= abs10[0][0] + abs10[0][1] + abs10[0][2] + abs10[0][3]
                    //     + abs10[1][0] + abs10[1][1] + abs10[1][2] + abs10[1][3]
                    //     + abs10[2][0] + abs10[2][1] + abs10[2][2] + abs10[2][3]
                    //     + abs10[3][0] + abs10[3][1] + abs10[3][2] + abs10[3][3];
                end
                {3'd4, 3'd5}: begin
                    abs12[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs13[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs14[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs22[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs23[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs24[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs32[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs33[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs34[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs42[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs43[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    abs44[0][1] <= (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
                    // sum11 <= abs11[0][0] + abs11[0][1] + abs11[0][2] + abs11[0][3]
                    //     + abs11[1][0] + abs11[1][1] + abs11[1][2] + abs11[1][3]
                    //     + abs11[2][0] + abs11[2][1] + abs11[2][2] + abs11[2][3]
                    //     + abs11[3][0] + abs11[3][1] + abs11[3][2] + abs11[3][3];
                    min_num <= (sum10 < min_num)? sum10: min_num;
                    min_pos <= (sum10 < min_num)? 5: min_pos;
                end
                {3'd4, 3'd6}: begin
                    abs13[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs14[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs23[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs24[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs33[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs34[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs43[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    abs44[0][2] <= (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
                    // sum12 <= abs12[0][0] + abs12[0][1] + abs12[0][2] + abs12[0][3]
                    //     + abs12[1][0] + abs12[1][1] + abs12[1][2] + abs12[1][3]
                    //     + abs12[2][0] + abs12[2][1] + abs12[2][2] + abs12[2][3]
                    //     + abs12[3][0] + abs12[3][1] + abs12[3][2] + abs12[3][3];
                    min_num <= (sum11 < min_num)? sum11: min_num;
                    min_pos <= (sum11 < min_num)? 6: min_pos;
                end
                {3'd4, 3'd7}: begin
                    abs14[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs24[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs34[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs44[0][3] <= (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
                    // sum13 <= abs13[0][0] + abs13[0][1] + abs13[0][2] + abs13[0][3]
                    //     + abs13[1][0] + abs13[1][1] + abs13[1][2] + abs13[1][3]
                    //     + abs13[2][0] + abs13[2][1] + abs13[2][2] + abs13[2][3]
                    //     + abs13[3][0] + abs13[3][1] + abs13[3][2] + abs13[3][3];
                    min_num <= (sum12 < min_num)? sum12: min_num;
                    min_pos <= (sum12 < min_num)? 7: min_pos;
                end
                //x = 5
                {3'd5, 3'd0}: begin
                    abs20[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs30[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs40[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    // sum14 <= abs14[0][0] + abs14[0][1] + abs14[0][2] + abs14[0][3]
                    //     + abs14[1][0] + abs14[1][1] + abs14[1][2] + abs14[1][3]
                    //     + abs14[2][0] + abs14[2][1] + abs14[2][2] + abs14[2][3]
                    //     + abs14[3][0] + abs14[3][1] + abs14[3][2] + abs14[3][3];
                    min_num <= (sum13 < min_num)? sum13: min_num;
                    min_pos <= (sum13 < min_num)? 8: min_pos;
                end
                {3'd5, 3'd1}: begin
                    abs20[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs21[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs30[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs31[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs40[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs41[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    min_num <= (sum14 < min_num)? sum14: min_num;
                    min_pos <= (sum14 < min_num)? 9: min_pos;
                end
                {3'd5, 3'd2}: begin
                    abs20[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs21[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs22[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs30[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs31[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs32[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs40[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs41[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs42[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                end
                {3'd5, 3'd3}: begin
                    abs20[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs21[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs22[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs23[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs30[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs31[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs32[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs33[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs40[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs41[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs42[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs43[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                end
                {3'd5, 3'd4}: begin
                    abs21[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs22[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs23[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs24[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs31[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs32[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs33[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs34[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    abs41[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs42[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs43[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    abs44[1][0] <= (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
                    // sum20 <= abs20[0][0] + abs20[0][1] + abs20[0][2] + abs20[0][3]
                    //     + abs20[1][0] + abs20[1][1] + abs20[1][2] + abs20[1][3]
                    //     + abs20[2][0] + abs20[2][1] + abs20[2][2] + abs20[2][3]
                    //     + abs20[3][0] + abs20[3][1] + abs20[3][2] + abs20[3][3];
                end
                {3'd5, 3'd5}: begin
                    abs22[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs23[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs24[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs32[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs33[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs34[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs42[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs43[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    abs44[1][1] <= (in_data > curr_block[1][1])? in_data - curr_block[1][1]: curr_block[1][1] - in_data;
                    // sum21 <= abs21[0][0] + abs21[0][1] + abs21[0][2] + abs21[0][3]
                    //     + abs21[1][0] + abs21[1][1] + abs21[1][2] + abs21[1][3]
                    //     + abs21[2][0] + abs21[2][1] + abs21[2][2] + abs21[2][3]
                    //     + abs21[3][0] + abs21[3][1] + abs21[3][2] + abs21[3][3];
                    min_num <= (sum20 < min_num)? sum20: min_num;
                    min_pos <= (sum20 < min_num)? 10: min_pos;
                end
                {3'd5, 3'd6}: begin
                    abs23[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs24[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs33[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs34[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs43[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    abs44[1][2] <= (in_data > curr_block[1][2])? in_data - curr_block[1][2]: curr_block[1][2] - in_data;
                    // sum22 <= abs22[0][0] + abs22[0][1] + abs22[0][2] + abs22[0][3]
                    //     + abs22[1][0] + abs22[1][1] + abs22[1][2] + abs22[1][3]
                    //     + abs22[2][0] + abs22[2][1] + abs22[2][2] + abs22[2][3]
                    //     + abs22[3][0] + abs22[3][1] + abs22[3][2] + abs22[3][3];
                    min_num <= (sum21 < min_num)? sum21: min_num;
                    min_pos <= (sum21 < min_num)? 11: min_pos;
                end
                {3'd5, 3'd7}: begin
                    abs24[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs34[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs44[1][3] <= (in_data > curr_block[1][3])? in_data - curr_block[1][3]: curr_block[1][3] - in_data;
                    // sum23 <= abs23[0][0] + abs23[0][1] + abs23[0][2] + abs23[0][3]
                    //     + abs23[1][0] + abs23[1][1] + abs23[1][2] + abs23[1][3]
                    //     + abs23[2][0] + abs23[2][1] + abs23[2][2] + abs23[2][3]
                    //     + abs23[3][0] + abs23[3][1] + abs23[3][2] + abs23[3][3];
                    min_num <= (sum22 < min_num)? sum22: min_num;
                    min_pos <= (sum22 < min_num)? 12: min_pos;
                end
                //x = 6
                {3'd6, 3'd0}: begin
                    abs30[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs40[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    // sum24 <= abs24[0][0] + abs24[0][1] + abs24[0][2] + abs24[0][3]
                    //     + abs24[1][0] + abs24[1][1] + abs24[1][2] + abs24[1][3]
                    //     + abs24[2][0] + abs24[2][1] + abs24[2][2] + abs24[2][3]
                    //     + abs24[3][0] + abs24[3][1] + abs24[3][2] + abs24[3][3];
                    min_num <= (sum23 < min_num)? sum23: min_num;
                    min_pos <= (sum23 < min_num)? 13: min_pos;
                end
                {3'd6, 3'd1}: begin
                    abs30[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs31[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs40[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs41[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    min_num <= (sum24 < min_num)? sum24: min_num;
                    min_pos <= (sum24 < min_num)? 14: min_pos;
                end
                {3'd6, 3'd2}: begin
                    abs30[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs31[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs32[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs40[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs41[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs42[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                end
                {3'd6, 3'd3}: begin
                    abs30[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs31[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs32[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs33[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs40[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs41[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs42[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs43[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                end
                {3'd6, 3'd4}: begin
                    abs31[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs32[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs33[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs34[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    abs41[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs42[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs43[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    abs44[2][0] <= (in_data > curr_block[2][0])? in_data - curr_block[2][0]: curr_block[2][0] - in_data;
                    // sum30 <= abs30[0][0] + abs30[0][1] + abs30[0][2] + abs30[0][3]
                    //     + abs30[1][0] + abs30[1][1] + abs30[1][2] + abs30[1][3]
                    //     + abs30[2][0] + abs30[2][1] + abs30[2][2] + abs30[2][3]
                    //     + abs30[3][0] + abs30[3][1] + abs30[3][2] + abs30[3][3];
                end
                {3'd6, 3'd5}: begin
                    abs32[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs33[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs34[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs42[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs43[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    abs44[2][1] <= (in_data > curr_block[2][1])? in_data - curr_block[2][1]: curr_block[2][1] - in_data;
                    // sum31 <= abs31[0][0] + abs31[0][1] + abs31[0][2] + abs31[0][3]
                    //     + abs31[1][0] + abs31[1][1] + abs31[1][2] + abs31[1][3]
                    //     + abs31[2][0] + abs31[2][1] + abs31[2][2] + abs31[2][3]
                    //     + abs31[3][0] + abs31[3][1] + abs31[3][2] + abs31[3][3];
                    min_num <= (sum30 < min_num)? sum30: min_num;
                    min_pos <= (sum30 < min_num)? 15: min_pos;
                end
                {3'd6, 3'd6}: begin
                    abs33[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs34[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs43[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    abs44[2][2] <= (in_data > curr_block[2][2])? in_data - curr_block[2][2]: curr_block[2][2] - in_data;
                    // sum32 <= abs32[0][0] + abs32[0][1] + abs32[0][2] + abs32[0][3]
                    //     + abs32[1][0] + abs32[1][1] + abs32[1][2] + abs32[1][3]
                    //     + abs32[2][0] + abs32[2][1] + abs32[2][2] + abs32[2][3]
                    //     + abs32[3][0] + abs32[3][1] + abs32[3][2] + abs32[3][3];
                    min_num <= (sum31 < min_num)? sum31: min_num;
                    min_pos <= (sum31 < min_num)? 16: min_pos;
                end
                {3'd6, 3'd7}: begin
                    abs34[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs44[2][3] <= (in_data > curr_block[2][3])? in_data - curr_block[2][3]: curr_block[2][3] - in_data;
                    // sum33 <= abs33[0][0] + abs33[0][1] + abs33[0][2] + abs33[0][3]
                    //     + abs33[1][0] + abs33[1][1] + abs33[1][2] + abs33[1][3]
                    //     + abs33[2][0] + abs33[2][1] + abs33[2][2] + abs33[2][3]
                    //     + abs33[3][0] + abs33[3][1] + abs33[3][2] + abs33[3][3];
                    min_num <= (sum32 < min_num)? sum32: min_num;
                    min_pos <= (sum32 < min_num)? 17: min_pos;
                end
                //x = 7
                {3'd7, 3'd0}: begin
                    abs40[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    // sum34 <= abs34[0][0] + abs34[0][1] + abs34[0][2] + abs34[0][3]
                    //     + abs34[1][0] + abs34[1][1] + abs34[1][2] + abs34[1][3]
                    //     + abs34[2][0] + abs34[2][1] + abs34[2][2] + abs34[2][3]
                    //     + abs34[3][0] + abs34[3][1] + abs34[3][2] + abs34[3][3];
                    min_num <= (sum33 < min_num)? sum33: min_num;
                    min_pos <= (sum33 < min_num)? 18: min_pos;
                end
                {3'd7, 3'd1}: begin
                    abs40[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs41[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    min_num <= (sum34 < min_num)? sum34: min_num;
                    min_pos <= (sum34 < min_num)? 19: min_pos;
                end
                {3'd7, 3'd2}: begin
                    abs40[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs41[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs42[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                end
                {3'd7, 3'd3}: begin
                    abs40[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs41[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs42[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs43[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                end
                {3'd7, 3'd4}: begin
                    abs41[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs42[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs43[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    abs44[3][0] <= (in_data > curr_block[3][0])? in_data - curr_block[3][0]: curr_block[3][0] - in_data;
                    // sum40 <= abs40[0][0] + abs40[0][1] + abs40[0][2] + abs40[0][3]
                    //     + abs40[1][0] + abs40[1][1] + abs40[1][2] + abs40[1][3]
                    //     + abs40[2][0] + abs40[2][1] + abs40[2][2] + abs40[2][3]
                    //     + abs40[3][0] + abs40[3][1] + abs40[3][2] + abs40[3][3];
                end
                {3'd7, 3'd5}: begin
                    abs42[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs43[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    abs44[3][1] <= (in_data > curr_block[3][1])? in_data - curr_block[3][1]: curr_block[3][1] - in_data;
                    // sum41 <= abs41[0][0] + abs41[0][1] + abs41[0][2] + abs41[0][3]
                    //     + abs41[1][0] + abs41[1][1] + abs41[1][2] + abs41[1][3]
                    //     + abs41[2][0] + abs41[2][1] + abs41[2][2] + abs41[2][3]
                    //     + abs41[3][0] + abs41[3][1] + abs41[3][2] + abs41[3][3];
                    min_num <= (sum40 < min_num)? sum40: min_num;
                    min_pos <= (sum40 < min_num)? 20: min_pos;
                end
                {3'd7, 3'd6}: begin
                    abs43[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    abs44[3][2] <= (in_data > curr_block[3][2])? in_data - curr_block[3][2]: curr_block[3][2] - in_data;
                    // sum42 <= abs42[0][0] + abs42[0][1] + abs42[0][2] + abs42[0][3]
                    //     + abs42[1][0] + abs42[1][1] + abs42[1][2] + abs42[1][3]
                    //     + abs42[2][0] + abs42[2][1] + abs42[2][2] + abs42[2][3]
                    //     + abs42[3][0] + abs42[3][1] + abs42[3][2] + abs42[3][3];
                    min_num <= (sum41 < min_num)? sum41: min_num;
                    min_pos <= (sum41 < min_num)? 21: min_pos;
                end
                {3'd7, 3'd7}: begin
                    abs44[3][3] <= (in_data > curr_block[3][3])? in_data - curr_block[3][3]: curr_block[3][3] - in_data;
                    // sum43 <= abs43[0][0] + abs43[0][1] + abs43[0][2] + abs43[0][3]
                    //     + abs43[1][0] + abs43[1][1] + abs43[1][2] + abs43[1][3]
                    //     + abs43[2][0] + abs43[2][1] + abs43[2][2] + abs43[2][3]
                    //     + abs43[3][0] + abs43[3][1] + abs43[3][2] + abs43[3][3];
                    min_num <= (sum42 < min_num)? sum42: min_num;
                    min_pos <= (sum42 < min_num)? 22: min_pos;
                end
            endcase
        end
        if(IsInvalid && !area_valid && !block_valid) begin
            out_valid <= 1;
        end
        if(out_valid) begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= 0;
        end
        if(cnt == 1) begin
            out_valid <= 0;
            IsInvalid <= 0;
        end
    end
end

endmodule