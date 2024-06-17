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
logic [23:0] h[0:7][0:7];
logic [23:0] avg[0:7];
logic [31:0] out[0:7];
logic wr_ok, o_ok, o_down;

logic [3:0] cntx;
logic [2:0] cnty;
logic [2:0] cntw;
logic [2:0] cnto;
integer i, j;


always @(posedge clk) begin //multiply
	if(w_ready) begin
		for(i = 0; i < 8; i++) begin
			out[i] <= 0;
		end
	end
	if(w_valid) begin
		for(i = 0; i < 8; i++) begin
			out[i] <= out[i] + h[i][cntw] * w_data;
		end
	end
end


always @(*) begin
	for(i = 0; i < 8; i++) begin
		avg[i] = ((((h[i][0] + h[i][1]) + (h[i][2] + h[i][3])) + ((h[i][4] + h[i][5]) + (h[i][6] + h[i][7]))) >> 3);
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 8; i++) begin
			for(j = 0; j < 8; j++) begin
				h[i][j] <= 0;
			end
		end
	end
	else begin
		if(w_ready) begin //RAT
			for(i = 0; i < 8; i++) begin
				for(j = 0; j < 8; j++) begin
					h[i][j] <= (h[i][j] < avg[i])? 0: h[i][j];
				end
			end		
		end
		if(i_valid)begin //multiply
			for(i = 0; i < 8; i++) begin
				for(j = i + 1; j < 8; j++) begin //斜對角對稱
					if(cnty == j) begin
						h[j][i] <= h[j][i] + data[i][cntx] * i_data;
						h[i][j] <= h[j][i] + data[i][cntx] * i_data;
					end
				end
				if(cnty == i) begin
					h[i][i] <= h[i][i] + i_data * i_data;
				end
			end
		end
		if(o_down) begin
			for(i = 0; i < 8; i++) begin
				for(j = 0; j < 8; j++) begin
					h[i][j] <= 0;
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
		cnty <= 0;
		wr_ok <= 0;
		o_ok <= 0;
		o_down <= 0;
		cnto <= 0;
		cntw <= 0;
	end
	else begin
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
			cntw <= cntw + 1;
		end
		if(cntw == 7) begin
			o_ok <= 1;
		end
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
