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
logic [7:0] curr_block[0:3][0:3];
logic [1:0] x_curr, y_curr;
logic [2:0] x_area, y_area;
logic signed [2:0] vector_x, vector_y;
logic cnt;
logic IsInvalid;
logic [11:0] sum[0:4][0:4];
// logic [4:0] min_pos;
logic signed [2:0] min_x, min_y;
logic signed [2:0] min_x_f, min_y_f;

logic [11:0] min_num;
logic [2:0] i, j;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------

assign min_x_f = (sum[4][4] < min_num)? 2: min_x;
assign min_y_f = (sum[4][4] < min_num)? -2: min_y;
// always @(*) begin
//     min_x_f = (sum[4][4] < min_num)? 2: min_x;
//     min_y_f = (sum[4][4] < min_num)? -2: min_y;
//     out_vector = (rst_n && out_valid)? ((cnt)? min_y_f: min_x_f): 0;
// end
assign out_vector = (rst_n && out_valid)? ((cnt)? min_y_f: min_x_f): 0;

always @(posedge clk) begin
    case({x_area, y_area}) //min
                {3'd3, 3'd4}: begin
                    min_num <= sum[0][0];
                    min_x <= -2;
                    min_y <= 2;
                end
                {3'd3, 3'd5}: begin
                    min_num <= (sum[0][1] < min_num)? sum[0][1]: min_num;
                    min_x <= (sum[0][1] < min_num)? -1: min_x;
                    // min_y <= (sum[0][1] < min_num)? 1: min_y;
                end
                {3'd3, 3'd6}: begin
                    min_num <= (sum[0][2] < min_num)? sum[0][2]: min_num;
                    min_x <= (sum[0][2] < min_num)? 0: min_x;
                end
                {3'd3, 3'd7}: begin
                    min_num <= (sum[0][3] < min_num)? sum[0][3]: min_num;
                    min_x <= (sum[0][3] < min_num)? 1: min_x;
                end
                //x <= 4
                {3'd4, 3'd0}: begin
                    min_num <= (sum[0][4] < min_num)? sum[0][4]: min_num;
                    min_x <= (sum[0][4] < min_num)? 2: min_x;
                end
                {3'd4, 3'd4}: begin
                    min_num <= (sum[1][0] < min_num)? sum[1][0]: min_num;
                    min_x <= (sum[1][0] < min_num)? -2: min_x;
                    min_y <= (sum[1][0] < min_num)? 1: min_y;
                end
                {3'd4, 3'd5}: begin
                    min_num <= (sum[1][1] < min_num)? sum[1][1]: min_num;
                    min_x <= (sum[1][1] < min_num)? -1: min_x;
                    min_y <= (sum[1][1] < min_num)? 1: min_y;
                end
                {3'd4, 3'd6}: begin
                    min_num <= (sum[1][2] < min_num)? sum[1][2]: min_num;
                    min_x <= (sum[1][2] < min_num)? 0: min_x;
                    min_y <= (sum[1][2] < min_num)? 1: min_y;
                end
                {3'd4, 3'd7}: begin
                    min_num <= (sum[1][3] < min_num)? sum[1][3]: min_num;
                    min_x <= (sum[1][3] < min_num)? 1: min_x;
                    min_y <= (sum[1][3] < min_num)? 1: min_y;
                end
                //x <= 5
                {3'd5, 3'd0}: begin
                    min_num <= (sum[1][4] < min_num)? sum[1][4]: min_num;
                    min_x <= (sum[1][4] < min_num)? 2: min_x;
                    min_y <= (sum[1][4] < min_num)? 1: min_y;
                end
                {3'd5, 3'd4}: begin
                    min_num <= (sum[2][0] < min_num)? sum[2][0]: min_num;
                    min_x <= (sum[2][0] < min_num)? -2: min_x;
                    min_y <= (sum[2][0] < min_num)? 0: min_y;
                end
                {3'd5, 3'd5}: begin
                    min_num <= (sum[2][1] < min_num)? sum[2][1]: min_num;
                    min_x <= (sum[2][1] < min_num)? -1: min_x;
                    min_y <= (sum[2][1] < min_num)? 0: min_y;
                end
                {3'd5, 3'd6}: begin
                    min_num <= (sum[2][2] < min_num)? sum[2][2]: min_num;
                    min_x <= (sum[2][2] < min_num)? 0: min_x;
                    min_y <= (sum[2][2] < min_num)? 0: min_y;
                end
                {3'd5, 3'd7}: begin
                    min_num <= (sum[2][3] < min_num)? sum[2][3]: min_num;
                    min_x <= (sum[2][3] < min_num)? 1: min_x;
                    min_y <= (sum[2][3] < min_num)? 0: min_y;
                end
                //x <= 6
                {3'd6, 3'd0}: begin
                    min_num <= (sum[2][4] < min_num)? sum[2][4]: min_num;
                    min_x <= (sum[2][4] < min_num)? 2: min_x;
                    min_y <= (sum[2][4] < min_num)? 0: min_y;
                end
                {3'd6, 3'd4}: begin
                    min_num <= (sum[3][0] < min_num)? sum[3][0]: min_num;
                    min_x <= (sum[3][0] < min_num)? -2: min_x;
                    min_y <= (sum[3][0] < min_num)? -1: min_y;
                end
                {3'd6, 3'd5}: begin
                    min_num <= (sum[3][1] < min_num)? sum[3][1]: min_num;
                    min_x <= (sum[3][1] < min_num)? -1: min_x;
                    min_y <= (sum[3][1] < min_num)? -1: min_y;
                end
                {3'd6, 3'd6}: begin
                    min_num <= (sum[3][2] < min_num)? sum[3][2]: min_num;
                    min_x <= (sum[3][2] < min_num)? 0: min_x;
                    min_y <= (sum[3][2] < min_num)? -1: min_y;
                end
                {3'd6, 3'd7}: begin
                    min_num <= (sum[3][3] < min_num)? sum[3][3]: min_num;
                    min_x <= (sum[3][3] < min_num)? 1: min_x;
                    min_y <= (sum[3][3] < min_num)? -1: min_y;
                end
                //x = 7
                {3'd7, 3'd0}: begin
                    min_num <= (sum[3][4] < min_num)? sum[3][4]: min_num;
                    min_x <= (sum[3][4] < min_num)? 2: min_x;
                    min_y <= (sum[3][4] < min_num)? -1: min_y;
                end
                {3'd7, 3'd4}: begin
                    min_num <= (sum[4][0] < min_num)? sum[4][0]: min_num;
                    min_x <= (sum[4][0] < min_num)? -2: min_x;
                    min_y <= (sum[4][0] < min_num)? -2: min_y;
                end
                {3'd7, 3'd5}: begin
                    min_num <= (sum[4][1] < min_num)? sum[4][1]: min_num;
                    min_x <= (sum[4][1] < min_num)? -1: min_x;
                    min_y <= (sum[4][1] < min_num)? -2: min_y;
                end
                {3'd7, 3'd6}: begin
                    min_num <= (sum[4][2] < min_num)? sum[4][2]: min_num;
                    min_x <= (sum[4][2] < min_num)? 0: min_x;
                    min_y <= (sum[4][2] < min_num)? -2: min_y;
                end
                {3'd7, 3'd7}: begin
                    min_num <= (sum[4][3] < min_num)? sum[4][3]: min_num;
                    min_x <= (sum[4][3] < min_num)? 1: min_x;
                    min_y <= (sum[4][3] < min_num)? -2: min_y;
                end
                // {3'd0, 3'd0} : begin
                //     min_x <= (sum[4][4] < min_num)? 2: min_x;
                //     min_y <= (sum[4][4] < min_num)? -2: min_y;
                //     // $display("min_x: %d, min_y: %d", min_x, min_y);
                // end
            endcase
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
            sum[0][0] <= 0;
            sum[0][1] <= 0;
            sum[0][2] <= 0;
            sum[0][3] <= 0;
            sum[0][4] <= 0;
            sum[1][0] <= 0;
            sum[1][1] <= 0;
            sum[1][2] <= 0;
            sum[1][3] <= 0;
            sum[1][4] <= 0;
            sum[2][0] <= 0;
            sum[2][1] <= 0;
            sum[2][2] <= 0;
            sum[2][3] <= 0;
            sum[2][4] <= 0;
            sum[3][0] <= 0;
            sum[3][1] <= 0;
            sum[3][2] <= 0;
            sum[3][3] <= 0;
            sum[3][4] <= 0;
            sum[4][0] <= 0;
            sum[4][1] <= 0;
            sum[4][2] <= 0;
            sum[4][3] <= 0;
            sum[4][4] <= 0;
        end
        if(area_valid)begin
            if(y_area == 7)
                x_area <= x_area + 1;
            y_area <= y_area + 1;
            
            sum[0][0] <= sum[0][0] + ((x_area < 4 && y_area < 4)? (in_data > curr_block[x_area][y_area])? in_data - curr_block[x_area][y_area]: curr_block[x_area][y_area] - in_data: 0);
            sum[0][1] <= sum[0][1] + ((x_area < 4 && y_area > 0 && y_area < 5)? (in_data > curr_block[x_area][y_area-1])? in_data - curr_block[x_area][y_area-1]: curr_block[x_area][y_area-1] - in_data: 0);
            sum[0][2] <= sum[0][2] + ((x_area < 4 && y_area > 1 && y_area < 6)? (in_data > curr_block[x_area][y_area-2])? in_data - curr_block[x_area][y_area-2]: curr_block[x_area][y_area-2] - in_data: 0);
            sum[0][3] <= sum[0][3] + ((x_area < 4 && y_area > 2 && y_area < 7)? (in_data > curr_block[x_area][y_area-3])? in_data - curr_block[x_area][y_area-3]: curr_block[x_area][y_area-3] - in_data: 0);
            sum[0][4] <= sum[0][4] + ((x_area < 4 && y_area > 3)? (in_data > curr_block[x_area][y_area-4])? in_data - curr_block[x_area][y_area-4]: curr_block[x_area][y_area-4] - in_data: 0);
            sum[1][0] <= sum[1][0] + ((x_area > 0 && x_area < 5 && y_area < 4)? (in_data > curr_block[x_area-1][y_area])? in_data - curr_block[x_area-1][y_area]: curr_block[x_area-1][y_area] - in_data: 0);
            sum[1][1] <= sum[1][1] + ((x_area > 0 && x_area < 5 && y_area > 0 && y_area < 5)? (in_data > curr_block[x_area-1][y_area-1])? in_data - curr_block[x_area-1][y_area-1]: curr_block[x_area-1][y_area-1] - in_data: 0);
            sum[1][2] <= sum[1][2] + ((x_area > 0 && x_area < 5 && y_area > 1 && y_area < 6)? (in_data > curr_block[x_area-1][y_area-2])? in_data - curr_block[x_area-1][y_area-2]: curr_block[x_area-1][y_area-2] - in_data: 0);
            sum[1][3] <= sum[1][3] + ((x_area > 0 && x_area < 5 && y_area > 2 && y_area < 7)? (in_data > curr_block[x_area-1][y_area-3])? in_data - curr_block[x_area-1][y_area-3]: curr_block[x_area-1][y_area-3] - in_data: 0);
            sum[1][4] <= sum[1][4] + ((x_area > 0 && x_area < 5 && y_area > 3)? (in_data > curr_block[x_area-1][y_area-4])? in_data - curr_block[x_area-1][y_area-4]: curr_block[x_area-1][y_area-4] - in_data: 0);
            sum[2][0] <= sum[2][0] + ((x_area > 1 && x_area < 6 && y_area < 4)? (in_data > curr_block[x_area-2][y_area])? in_data - curr_block[x_area-2][y_area]: curr_block[x_area-2][y_area] - in_data: 0);
            sum[2][1] <= sum[2][1] + ((x_area > 1 && x_area < 6 && y_area > 0 && y_area < 5)? (in_data > curr_block[x_area-2][y_area-1])? in_data - curr_block[x_area-2][y_area-1]: curr_block[x_area-2][y_area-1] - in_data: 0);
            sum[2][2] <= sum[2][2] + ((x_area > 1 && x_area < 6 && y_area > 1 && y_area < 6)? (in_data > curr_block[x_area-2][y_area-2])? in_data - curr_block[x_area-2][y_area-2]: curr_block[x_area-2][y_area-2] - in_data: 0);
            sum[2][3] <= sum[2][3] + ((x_area > 1 && x_area < 6 && y_area > 2 && y_area < 7)? (in_data > curr_block[x_area-2][y_area-3])? in_data - curr_block[x_area-2][y_area-3]: curr_block[x_area-2][y_area-3] - in_data: 0);
            sum[2][4] <= sum[2][4] + ((x_area > 1 && x_area < 6 && y_area > 3)? (in_data > curr_block[x_area-2][y_area-4])? in_data - curr_block[x_area-2][y_area-4]: curr_block[x_area-2][y_area-4] - in_data: 0);
            sum[3][0] <= sum[3][0] + ((x_area > 2 && x_area < 7 && y_area < 4)? (in_data > curr_block[x_area-3][y_area])? in_data - curr_block[x_area-3][y_area]: curr_block[x_area-3][y_area] - in_data: 0);
            sum[3][1] <= sum[3][1] + ((x_area > 2 && x_area < 7 && y_area > 0 && y_area < 5)? (in_data > curr_block[x_area-3][y_area-1])? in_data - curr_block[x_area-3][y_area-1]: curr_block[x_area-3][y_area-1] - in_data: 0);
            sum[3][2] <= sum[3][2] + ((x_area > 2 && x_area < 7 && y_area > 1 && y_area < 6)? (in_data > curr_block[x_area-3][y_area-2])? in_data - curr_block[x_area-3][y_area-2]: curr_block[x_area-3][y_area-2] - in_data: 0);
            sum[3][3] <= sum[3][3] + ((x_area > 2 && x_area < 7 && y_area > 2 && y_area < 7)? (in_data > curr_block[x_area-3][y_area-3])? in_data - curr_block[x_area-3][y_area-3]: curr_block[x_area-3][y_area-3] - in_data: 0);
            sum[3][4] <= sum[3][4] + ((x_area > 2 && x_area < 7 && y_area > 3)? (in_data > curr_block[x_area-3][y_area-4])? in_data - curr_block[x_area-3][y_area-4]: curr_block[x_area-3][y_area-4] - in_data: 0);
            sum[4][0] <= sum[4][0] + ((x_area > 3 && y_area < 4)? (in_data > curr_block[x_area-4][y_area])? in_data - curr_block[x_area-4][y_area]: curr_block[x_area-4][y_area] - in_data: 0);
            sum[4][1] <= sum[4][1] + ((x_area > 3 && y_area > 0 && y_area < 5)? (in_data > curr_block[x_area-4][y_area-1])? in_data - curr_block[x_area-4][y_area-1]: curr_block[x_area-4][y_area-1] - in_data: 0);
            sum[4][2] <= sum[4][2] + ((x_area > 3 && y_area > 1 && y_area < 6)? (in_data > curr_block[x_area-4][y_area-2])? in_data - curr_block[x_area-4][y_area-2]: curr_block[x_area-4][y_area-2] - in_data: 0);
            sum[4][3] <= sum[4][3] + ((x_area > 3 && y_area > 2 && y_area < 7)? (in_data > curr_block[x_area-4][y_area-3])? in_data - curr_block[x_area-4][y_area-3]: curr_block[x_area-4][y_area-3] - in_data: 0);
            sum[4][4] <= sum[4][4] + ((x_area > 3 && y_area > 3)? (in_data > curr_block[x_area-4][y_area-4])? in_data - curr_block[x_area-4][y_area-4]: curr_block[x_area-4][y_area-4] - in_data: 0);
            // case({x_area, y_area}) //sum
            //     //x = 0
            //     {3'd0, 3'd0}: begin
            //         sum[0][0] <= (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd1}:begin
            //         sum[0][0] < sum[0][0] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][1] < sum[0][1] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd2}: begin
            //         sum[0][0] <= sum[0][0] + (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
            //         sum[0][1] <= sum[0][1] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][2] <= sum[0][2] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd3}: begin
            //         sum[0][0] <= sum[0][0] + (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
            //         sum[0][1] <= sum[0][1] + (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
            //         sum[0][2] <= sum[0][2] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][3] <= sum[0][3] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd4}: begin
            //         sum[0][1] <= sum[0][1] + (in_data > curr_block[0][3])? in_data - curr_block[0][3]: curr_block[0][3] - in_data;
            //         sum[0][2] <= sum[0][2] + (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
            //         sum[0][3] <= sum[0][3] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][4] <= sum[0][4] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd5}: begin
            //         sum[0][2] <= sum[0][2] + (in_data > curr_block[0][2])? in_data - curr_block[0][2]: curr_block[0][2] - in_data;
            //         sum[0][3] <= sum[0][3] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][4] <= sum[0][4] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd6}: begin
            //         sum[0][3] <= sum[0][3] + (in_data > curr_block[0][1])? in_data - curr_block[0][1]: curr_block[0][1] - in_data;
            //         sum[0][4] <= sum[0][4] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd0, 3'd7}: begin
            //         sum[0][4] <= sum[0][4] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     //x = 1
            //     {3'd1, 3'd0}: begin
            //         sum[0][0] <= sum[0][0] + (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
            //     end
            //     {3'd1, 3'd1}: begin
            //         sum[0][0] < sum[0][0] + (in_data > curr_block[1][0])? in_data - curr_block[1][0]: curr_block[1][0] - in_data;
            //         sum[0][1] < sum[0][1] + (in_data > curr_block[0][0])? in_data - curr_block[0][0]: curr_block[0][0] - in_data;
            //     end
            //     {3'd1, 3'd2}: begin
            //     end
            //     {3'd1, 3'd3}: begin
            //     end
            //     {3'd1, 3'd4}: begin
            //     end
            //     {3'd1, 3'd5}: begin
            //     end
            //     {3'd1, 3'd6}: begin
            //     end
            //     {3'd1, 3'd7}: begin
                 
            //     end
            //     //x = 2
            //     {3'd2, 3'd0}: begin
     
            //     end
            //     {3'd2, 3'd1}: begin
         
            //     end
            //     {3'd2, 3'd2}: begin
     
            //     end
            //     {3'd2, 3'd3}: begin
    
            //     end
            //     {3'd2, 3'd4}: begin

            //     end
            //     {3'd2, 3'd5}: begin

            //     end
            //     {3'd2, 3'd6}: begin

            //     end
            //     {3'd2, 3'd7}: begin

            //     end
            //     //x = 3
            //     {3'd3, 3'd0}: begin
  
            //     end
            //     {3'd3, 3'd1}: begin
            //     end
            //     {3'd3, 3'd2}: begin

            //     end
            //     {3'd3, 3'd3}: begin
               
            //     end
            //     {3'd3, 3'd4}: begin

            //     end
            //     {3'd3, 3'd5}: begin

            //     end
            //     {3'd3, 3'd6}: begin

            //     end
            //     {3'd3, 3'd7}: begin
            //     end
            //     //x = 4
            //     {3'd4, 3'd0}: begin

            //     end
            //     {3'd4, 3'd1}: begin

            //     end
            //     {3'd4, 3'd2}: begin

            //     end
            //     {3'd4, 3'd3}: begin

            //     end
            //     {3'd4, 3'd4}: begin

            //     end
            //     {3'd4, 3'd5}: begin

            //     end
            //     {3'd4, 3'd6}: begin

            //     end
            //     {3'd4, 3'd7}: begin

            //     end
            //     //x = 5
            //     {3'd5, 3'd0}: begin

            //     end
            //     {3'd5, 3'd1}: begin

            //     end
            //     {3'd5, 3'd2}: begin

            //     end
            //     {3'd5, 3'd3}: begin

            //     end
            //     {3'd5, 3'd4}: begin

            //     end
            //     {3'd5, 3'd5}: begin

            //     end
            //     {3'd5, 3'd6}: begin

            //     end
            //     {3'd5, 3'd7}: begin

            //     end
            //     //x = 6
            //     {3'd6, 3'd0}: begin

            //     end
            //     {3'd6, 3'd1}: begin

            //     end
            //     {3'd6, 3'd2}: begin

            //     end
            //     {3'd6, 3'd3}: begin

            //     end
            //     {3'd6, 3'd4}: begin

            //     end
            //     {3'd6, 3'd5}: begin

            //     end
            //     {3'd6, 3'd6}: begin

            //     end
            //     {3'd6, 3'd7}: begin

            //     end
            //     //x = 7
            //     {3'd7, 3'd0}: begin

            //     end
            //     {3'd7, 3'd1}: begin

            //     end
            //     {3'd7, 3'd2}: begin
                    
            //     end
            //     {3'd7, 3'd3}: begin

            //     end
            //     {3'd7, 3'd4}: begin

            //     end
            //     {3'd7, 3'd5}: begin

            //     end
            //     {3'd7, 3'd6}: begin

            //     end
            //     {3'd7, 3'd7}: begin

            //     end
            // endcase
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