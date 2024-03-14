module Sort(
    // Input signals
	in_num0,
	in_num1,
	in_num2,
	in_num3,
	in_num4,
    // Output signals
	out_num
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input  [5:0] in_num0, in_num1, in_num2, in_num3, in_num4;
output logic [5:0] out_num;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------

//logic [5:0] n0[4:0], n1[4:0], n2[4:0], n3[4:0], n4[4:0];
logic [5:0] n0, n1, n2, n3, n4;

logic [2:0] c;
logic [5:0] temp;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always @(*) begin
	n0 = in_num0;
	n1 = in_num1;
	n2 = in_num2;
	n3 = in_num3;
	n4 = in_num4;
	for(c = 0; c < 5; c++) begin
		if(c % 2 == 0) begin
			if(n0 > n1)
			begin
				temp = n0;
		 		n0 = n1;
		 		// n1 <= n0;
				n1 = temp;
			end
			else
			begin
				n0 = n0;
				n1 = n1;
			end

			if(n2 > n3)
			begin
				temp = n2;
				n2 = n3;
				// n3 <= n2;
				n3 = temp;
			end
			else
			begin
				n2 = n2;
				n3 = n3;
			end
		end

		else begin
			if(n1 > n2)
			begin
				temp = n1;
				n1 = n2;
				// n2 <= n1;
				n2 = temp;
			end
			else
			begin
				n1 = n1;
				n2 = n2;
			end

			if(n3 > n4)
			begin
				temp = n3;
				n3 = n4;
				// n4 <= n3;
				n4 = temp;
			end
			else
			begin
				n3 = n3;
				n4 = n4;
			end
		end
	end

	out_num = n2;

end

endmodule