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
logic [7:0] data[0:7][0:15]; //高8長16
// logic [15:0] multi[0:7][0:7];
logic [23:0] h[0:7][0:7];
// logic [15:0] w[0:7];
logic [23:0] avg[0:7];
logic [31:0] out[0:7];
logic wr_ok, o_ok, o_down;

logic i_valid_2;
logic [3:0] cntx, cntx_2;
logic [2:0] cnty, cnty_2;
logic [2:0] cntw;
logic [2:0] cnto;
integer i, j, m, n, i0, j0, k, l, p;
integer dx, dy;


always @(posedge clk, negedge rst_n) begin //multiply
	if(!rst_n) begin
		for(p = 0; p < 8; p++) begin
			out[p] <= 0;
		end
	end
	else begin
		if(w_ready) begin
			for(p = 0; p < 8; p++) begin
				out[p] <= 0;
			end
		end
		if(w_valid) begin
			for(k = 0; k < 8; k++) begin
				out[k] <= out[k] + h[k][cntw] * w_data;
			end
		end
	end
end


always @(*) begin
	for(l = 0; l < 8; l++) begin
		avg[l] = ((h[l][0] + h[l][1] + h[l][2] + h[l][3] + h[l][4] + h[l][5] + h[l][6] + h[l][7]) >> 3);
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		for(i0 = 0; i0 < 8; i0++) begin
			for(j0 = 0; j0 < 8; j0++) begin
				h[i0][j0] <= 0;
			end
		end
	end
	else begin
		if(w_ready) begin //RAT
			for(m = 0; m < 8; m++) begin
				for(n = 0; n < 8; n++) begin
					h[m][n] <= (h[m][n] < avg[m])? 0: h[m][n];
				end
			end		
		end
		if(i_valid_2)begin //multiply
			for(i = 0; i < 8; i++) begin
				for(j = i + 1; j < 8; j++) begin //斜對角對稱
					if(cnty_2 == j) begin
						h[j][i] <= h[j][i] + data[i][cntx_2] * data[j][cntx_2];
						h[i][j] <= h[j][i] + data[i][cntx_2] * data[j][cntx_2];
					end
				end
				if(cnty_2 == i) begin
					h[i][i] <= h[i][i] + data[i][cntx_2] * data[i][cntx_2];
				end
			end
		end
		if(o_down) begin
			for(i0 = 0; i0 < 8; i0++) begin
				for(j0 = 0; j0 < 8; j0++) begin
					h[i0][j0] <= 0;
				end
			end
		end
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		o_data <= 0;
		o_valid <= 0;
		w_ready <= 0;
		cntx <= 0;
		cntx_2 <= 0;
		cnty <= 0;
		wr_ok <= 0;
		o_ok <= 0;
		o_down <= 0;
		cnto <= 0;
		cntw <= 0;
		i_valid_2 <= 0;
	end
	else begin
		i_valid_2 <= i_valid;
		cntx_2 <= cntx;
		cnty_2 <= cnty;
		if(i_valid) begin
			cntx <= cntx + 1;
			cnty <= (cntx == 15)? cnty + 1: cnty;
			data[cnty][cntx] <= i_data;
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
		if(w_valid == 1) begin
			// w[cntw] <= w_data;
			cntw <= cntw + 1;
		end
		if(cntw == 7) begin
			o_ok <= 1;
		end
		// cntw_2 <= cntw;
		if(o_ok) begin
			o_data <= out[cnto];
			cnto <= cnto + 1;
			o_valid <= 1;
		end
		if(cnto == 7) begin
			o_down <= 1;
		end
		if(o_down) begin
			o_valid <= 0;
			cnto <= 0;
			cntw <= 0;
			o_data <= 0;
			o_ok <= 0;
			o_down <= 0;
		end
	end
end

endmodule
