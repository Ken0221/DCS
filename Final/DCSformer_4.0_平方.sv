module DCSformer(
	// Input signals
	clk,
	rst_n,
	i_valid,
	w_valid,
	i_data,
	w_data,
	// Output signals
	w_ready,
	o_valid,
	o_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input               clk, rst_n, i_valid, w_valid;
input         [7:0] i_data, w_data;
output logic        w_ready, o_valid;
output logic [31:0] o_data;
//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
logic [7:0] data[0:127];
logic [19:0] h[0:7][0:7];
logic [22:0] avg[0:7];
logic [31:0] out[0:7];
logic wr_ok, o_ok, o_ok_2, o_down;

logic [3:0] cntx, cntx_2;
logic [2:0] cnty;
logic [2:0] cntw;
logic [2:0] cnto, cnto_2;
integer i, j;
logic [27:0] mul_hw[0:7], mul_di[0:7];
logic w_valid_2, w_valid_3, i_valid_2, i_valid_3, i_valid_4, i_valid_5, i_valid_6;
logic [7:0] w_data_2;

always @(posedge clk) begin //multiply
	w_valid_2 <= w_valid;
	w_valid_3 <= w_valid_2;
	if(w_ready) begin
		for(i = 0; i < 8; i++) begin
			out[i] <= 0;
		end
	end
	w_data_2 <= w_data;

	for(i = 0; i < 8; i++) begin
		mul_hw[i] <= (h[0][i] < avg[i])? 0: h[0][i] * w_data_2;
	end
	
	if(w_valid_3) begin
		for(i = 0; i < 8; i++) begin
			out[i] <= out[(i + 1) % 8] + mul_hw[(i + 1) % 8];
		end
	end
end

always @(*) begin
	avg[0] = ((h[0][0] + h[0][1] + h[0][2] + h[0][3] + h[0][4] + h[0][5] + h[0][6] + h[0][7]) >> 3);
    avg[1] = ((h[0][1] + h[1][1] + h[1][2] + h[1][3] + h[1][4] + h[1][5] + h[1][6] + h[1][7]) >> 3);
    avg[2] = ((h[0][2] + h[1][2] + h[2][2] + h[2][3] + h[2][4] + h[2][5] + h[2][6] + h[2][7]) >> 3);
    avg[3] = ((h[0][3] + h[1][3] + h[2][3] + h[3][3] + h[3][4] + h[3][5] + h[3][6] + h[3][7]) >> 3);
    avg[4] = ((h[0][4] + h[1][4] + h[2][4] + h[3][4] + h[4][4] + h[4][5] + h[4][6] + h[4][7]) >> 3);
    avg[5] = ((h[0][5] + h[1][5] + h[2][5] + h[3][5] + h[4][5] + h[5][5] + h[5][6] + h[5][7]) >> 3);
    avg[6] = ((h[0][6] + h[1][6] + h[2][6] + h[3][6] + h[4][6] + h[5][6] + h[6][6] + h[6][7]) >> 3);
    avg[7] = ((h[0][7] + h[1][7] + h[2][7] + h[3][7] + h[4][7] + h[5][7] + h[6][7] + h[7][7]) >> 3);
end

logic [2:0] cnt_s1_1[0:3], cnt_s1_2[0:3];
logic [15:0] accum[0:3];
logic [7:0] temp[0:3], num[0:3];

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cnt_s1_1[0] <= 6;
		// cnt_s1_1[1] <= 6;
		// cnt_s1_1[2] <= 6;
		// cnt_s1_1[3] <= 6;
		cnt_s1_2[0] <= 7;
		// cnt_s1_2[1] <= 7;
		// cnt_s1_2[2] <= 7;
		// cnt_s1_2[3] <= 7;
		accum[0] <= 0;
		accum[1] <= 0;
		accum[2] <= 0;
		accum[3] <= 0;
		i_valid_4 <= 0;
		// i_valid_5 <= 0;
		// i_valid_6 <= 0;
	end
	else begin
		i_valid_4 <= i_valid_3;
		i_valid_5 <= i_valid_4;
		i_valid_6 <= i_valid_5;
		if(i_valid || i_valid_5) begin
			cnt_s1_1[0] <= cnt_s1_1[0] + 2;
			cnt_s1_2[0] <= cnt_s1_1[0] + 3;
		end
		cnt_s1_1[1] <= cnt_s1_1[0];
		cnt_s1_2[1] <= cnt_s1_2[0];
		cnt_s1_1[2] <= cnt_s1_1[1];
		cnt_s1_2[2] <= cnt_s1_2[1];
		cnt_s1_1[3] <= cnt_s1_1[2];
		cnt_s1_2[3] <= cnt_s1_2[2];
		if(i_valid || i_valid_2) begin
			if(cnt_s1_1[0] == 6) begin
				num[0] <= i_data;
				temp[0] <= i_data;
			end
			else begin
				temp[0] <= (temp[0] >> 2); // Right shift temp[0] for next bit processing
			end

			if (temp[0][0] && !temp[0][1]) begin
				accum[0] <= (cnt_s1_1[0] == 0)? (num[0] << cnt_s1_1[0]): accum[0] + (num[0] << cnt_s1_1[0]); // Left shift num[0] by cnt and add to accum[0]ulator
			end
			else if (temp[0][1] && !temp[0][0]) begin
				accum[0] <= (cnt_s1_1[0] == 0)? (num[0] << cnt_s1_2[0]): accum[0] + (num[0] << cnt_s1_2[0]); // Left shift num[0] by cnt and add to accum[0]ulator
			end
			else if (temp[0][0] && temp[0][1]) begin
				accum[0] <= (cnt_s1_1[0] == 0)? (num[0] << cnt_s1_1[0]) + (num[0] << cnt_s1_2[0]): accum[0] + (num[0] << cnt_s1_1[0]) + (num[0] << cnt_s1_2[0]); // Left shift num[0] by cnt and add to accum[0]ulator
			end
			else if(cnt_s1_1[0] == 0) begin
				accum[0] <= 0;
			end
		end
		if(i_valid_2 || i_valid_3) begin
			if(cnt_s1_1[1] == 6) begin
				num[1] <= i_data;
				temp[1] <= i_data;
			end
			else begin
				temp[1] <= (temp[1] >> 2); // Right shift temp[1] for next bit processing
			end

			if (temp[1][0] && !temp[1][1]) begin
				accum[1] <= (cnt_s1_1[1] == 0)? (num[1] << cnt_s1_1[1]): accum[1] + (num[1] << cnt_s1_1[1]); // Left shift num[1] by cnt and add to accum[1]ulator
			end
			else if (temp[1][1] && !temp[1][0]) begin
				accum[1] <= (cnt_s1_1[1] == 0)? (num[1] << cnt_s1_2[1]): accum[1] + (num[1] << cnt_s1_2[1]); // Left shift num[1] by cnt and add to accum[1]ulator
			end
			else if (temp[1][0] && temp[1][1]) begin
				accum[1] <= (cnt_s1_1[1] == 0)? (num[1] << cnt_s1_1[1]) + (num[1] << cnt_s1_2[1]): accum[1] + (num[1] << cnt_s1_1[1]) + (num[1] << cnt_s1_2[1]); // Left shift num[1] by cnt and add to accum[1]ulator
			end
			else if(cnt_s1_1[1] == 0) begin
				accum[1] <= 0;
			end
		end
		if(i_valid_3 || i_valid_4) begin
			if(cnt_s1_1[2] == 6) begin
				num[2] <= i_data;
				temp[2] <= i_data;
			end
			else begin
				temp[2] <= (temp[2] >> 2); // Right shift temp[2] for next bit processing
			end

			if (temp[2][0] && !temp[2][1]) begin
				accum[2] <= (cnt_s1_1[2] == 0)? (num[2] << cnt_s1_1[2]): accum[2] + (num[2] << cnt_s1_1[2]); // Left shift num[2] by cnt and add to accum[2]ulator
			end
			else if (temp[2][1] && !temp[2][0]) begin
				accum[2] <= (cnt_s1_1[2] == 0)? (num[2] << cnt_s1_2[2]): accum[2] + (num[2] << cnt_s1_2[2]); // Left shift num[2] by cnt and add to accum[2]ulator
			end
			else if (temp[2][0] && temp[2][1]) begin
				accum[2] <= (cnt_s1_1[2] == 0)? (num[2] << cnt_s1_1[2]) + (num[2] << cnt_s1_2[2]): accum[2] + (num[2] << cnt_s1_1[2]) + (num[2] << cnt_s1_2[2]); // Left shift num[2] by cnt and add to accum[2]ulator
			end
			else if(cnt_s1_1[2] == 0) begin
				accum[2] <= 0;
			end
		end
		if(i_valid_4 || i_valid_5) begin
			if(cnt_s1_1[3] == 6) begin
				num[3] <= i_data;
				temp[3] <= i_data;
			end
			else begin
				temp[3] <= (temp[3] >> 2); // Right shift temp[3] for next bit processing
			end

			if (temp[3][0] && !temp[3][1]) begin
				accum[3] <= (cnt_s1_1[3] == 0)? (num[3] << cnt_s1_1[3]): accum[3] + (num[3] << cnt_s1_1[3]); // Left shift num[3] by cnt and add to accum[3]ulator
			end
			else if (temp[3][1] && !temp[3][0]) begin
				accum[3] <= (cnt_s1_1[3] == 0)? (num[3] << cnt_s1_2[3]): accum[3] + (num[3] << cnt_s1_2[3]); // Left shift num[3] by cnt and add to accum[3]ulator
			end
			else if (temp[3][0] && temp[3][1]) begin
				accum[3] <= (cnt_s1_1[3] == 0)? (num[3] << cnt_s1_1[3]) + (num[3] << cnt_s1_2[3]): accum[3] + (num[3] << cnt_s1_1[3]) + (num[3] << cnt_s1_2[3]); // Left shift num[3] by cnt and add to accum[3]ulator
			end
			else if(cnt_s1_1[3] == 0) begin
				accum[3] <= 0;
			end
		end
	end
end



always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 8; i++) begin
			for(j = i; j < 8; j++) begin
				h[i][j] <= 0;
			end
		end
		cntx_2 <= 0;
		i_valid_2 <= 0;
		i_valid_3 <= 0;
	end
	else begin
		i_valid_2 <= i_valid;
		i_valid_3 <= i_valid_2;
		cntx_2 <= cntx;
		if(i_valid_2) begin
			if(cntx) begin
				for(i = 0; i < 8; i++) begin
					mul_di[i] <= data[16 * i] * data[0];
				end
			end
		end
		if(i_valid_3) begin //multiply
			if(cntx_2 == 0) begin
				for(i = 0; i < 7; i++) begin
					h[i][7] <= data[16*(7-i) + 1] * data[1];
				end
				for(j = 0; j < 7; j++) begin
					for(i = 6; i >= 0 && i - j >= 0 && i - j != i; i--) begin
						h[i - j][i] <= h[i - j + 1][i + 1];
					end
				end
			end
			else begin
				for(j = 1; j < 8; j++) begin
					h[7 - j][7] <= h[7 - j][7] + mul_di[j];
				end
			end
		end
		if(i_valid_5 || i_valid_6) begin
			if(cnt_s1_1[0] == 0) begin
				h[7][7] <= (cntx == 4)? accum[0]: h[7][7] + accum[0];
				for(i = 0; i < 7; i++) begin
					h[i][i] <= (cntx == 4)? h[i + 1][i + 1]: h[i][i];
				end
			end
			if(cnt_s1_1[1] == 0) begin
				h[7][7] <= h[7][7] + accum[1];
			end
			if(cnt_s1_1[2] == 0) begin
				h[7][7] <= h[7][7] + accum[2];
			end
			if(cnt_s1_1[3] == 0) begin
				h[7][7] <= h[7][7] + accum[3];
			end
		end
		if(o_down) begin
			for(i = 0; i < 8; i++) begin
				for(j = i; j < 8; j++) begin
					h[i][j] <= 0;
				end
			end
		end
		if(w_valid_2) begin
			for(i = 1; i < 8; i++) begin
				for(j = i; j < 8; j++) begin
					h[i - 1][j - 1] <= h[i][j];
				end
			end
			h[7][7] <= h[0][0];
			for(i = 0; i < 7; i++) begin
				h[i][7] <= h[0][i + 1];
			end
		end
	end
end

always @(*) begin
	if(!rst_n) begin
		o_data = 0;
	end
	else begin
		if(o_valid)
			o_data = out[cnto_2];
		else
			o_data = 0;
	end	
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		o_valid <= 0;
		w_ready <= 0;
		cntx <= 0;
		wr_ok <= 0;
		o_ok <= 0;
		o_ok_2 <= 0;
		o_down <= 0;
		cnto <= 0;
		cntw <= 0;
		cnty <= 0;
	end
	else begin
		if(i_valid_2) begin
			cntx <= cntx + 1;
			for(i = 1; i < 128; i++) begin
				data[i] <= data[i - 1];
			end
		end
		if(i_valid) begin
			cnty <= (cntx == 15)? cnty + 1: cnty;
			data[0] <= i_data;
			cntw <= 0;
			cnto <= 0;
			wr_ok <= 1;
		end
		else if(wr_ok) begin
			w_ready <= 1;
			wr_ok <= 0;
		end
		else begin
			w_ready <= 0;
		end
		if(w_valid_2 == 1) begin
			cntw <= cntw + 1;
		end
		if(cntw == 7) begin
			o_ok <= 1;
		end
		o_ok_2 <= o_ok;
		if(o_ok_2) begin
			cnto <= cnto + 1;
			o_valid <= 1;
		end
		cnto_2 <= cnto;
		if(cnto == 7) begin
			o_down <= 1;
		end
		if(o_down) begin
			o_valid <= 0;
			cnto <= 0;
			cntw <= 0;
			o_ok <= 0;
			o_ok_2 <= 0;
			o_down <= 0;
			for(i = 0; i < 128; i++) begin
				data[i] <= 0;
			end
		end
	end
end

endmodule
