module CT (
    // Input signals
    opcode,
    in_n0,
    in_n1,
    in_n2,
    in_n3,
    in_n4,
    in_n5,
    clk,
    // Output signals
    out_n,
);

    //---------------------------------------------------------------------
    //   INPUT AND OUTPUT DECLARATION                         
    //---------------------------------------------------------------------
    input [3:0] in_n0, in_n1, in_n2, in_n3, in_n4, in_n5;
    input [4:0] opcode;
    input clk;
    output logic [8:0] out_n;

    //---------------------------------------------------------------------
    //   LOGIC DECLARATION
    //---------------------------------------------------------------------

    logic [4:0] value_n0, value_n1, value_n2, value_n3, value_n4, value_n5;
    logic [4:0] n0, n1, n2, n3, n4, n5;
    logic [4:0] temp1, temp2, temp3;
    logic [2:0] sum;

    // logic [4:0] l1_0, l1_1, l1_2, l1_3, l1_4, l1_5;
    // logic [4:0] l2_0, l2_1, l2_2, l2_3, l2_4, l2_5;
    // logic [4:0] l3_0, l3_1, l3_2, l3_3, l3_4, l3_5;
    // logic [4:0] l4_0, l4_1, l4_2, l4_3, l4_4, l4_5;
    // logic [4:0] l5_0, l5_1, l5_2, l5_3, l5_4, l5_5;


    //---------------------------------------------------------------------
    //   Your design                        
    //---------------------------------------------------------------------
    register_file reg0 (
        in_n0,
        value_n0
    );
    register_file reg1 (
        in_n1,
        value_n1
    );
    register_file reg2 (
        in_n2,
        value_n2
    );
    register_file reg3 (
        in_n3,
        value_n3
    );
    register_file reg4 (
        in_n4,
        value_n4
    );
    register_file reg5 (
        in_n5,
        value_n5
    );

    always @(*) begin
        n0 = value_n0;
        n1 = value_n1;
        n2 = value_n2;
        n3 = value_n3;
        n4 = value_n4;
        n5 = value_n5;
        if (opcode[4] == 1'b1) begin
            //1st
            temp1 = (n0 > n1) ? n0 : n1; //多設變數存值，不要回去
            temp2 = (n0 > n1) ? n1 : n0;
            n0 = temp1;
            n1 = temp2;
            temp1 = (n2 > n3) ? n2 : n3;
            temp2 = (n2 > n3) ? n3 : n2;
            n2 = temp1;
            n3 = temp2;
            temp1 = (n4 > n5) ? n4 : n5;
            temp2 = (n4 > n5) ? n5 : n4;
            n4 = temp1;
            n5 = temp2;
            //2nd
            temp1 = (n1 > n2) ? n1 : n2;
            temp2 = (n1 > n2) ? n2 : n1;
            n1 = temp1;
            n2 = temp2;
            temp1 = (n3 > n4) ? n3 : n4;
            temp2 = (n3 > n4) ? n4 : n3;
            n3 = temp1;
            n4 = temp2;
            //3rd
            temp1 = (n0 > n1) ? n0 : n1;
            temp2 = (n0 > n1) ? n1 : n0;
            n0 = temp1;
            n1 = temp2;
            temp1 = (n2 > n3) ? n2 : n3;
            temp2 = (n2 > n3) ? n3 : n2;
            n2 = temp1;
            n3 = temp2;
            temp1 = (n4 > n5) ? n4 : n5;
            temp2 = (n4 > n5) ? n5 : n4;
            n4 = temp1;
            n5 = temp2;
            //4th
            temp1 = (n1 > n2) ? n1 : n2;
            temp2 = (n1 > n2) ? n2 : n1;
            n1 = temp1;
            n2 = temp2;
            temp1 = (n3 > n4) ? n3 : n4;
            temp2 = (n3 > n4) ? n4 : n3;
            n3 = temp1;
            n4 = temp2;
            //5th
            temp1 = (n0 > n1) ? n0 : n1;
            temp2 = (n0 > n1) ? n1 : n0;
            n0 = temp1;
            n1 = temp2;
            temp1 = (n2 > n3) ? n2 : n3;
            temp2 = (n2 > n3) ? n3 : n2;
            n2 = temp1;
            n3 = temp2;
            temp1 = (n4 > n5) ? n4 : n5;
            temp2 = (n4 > n5) ? n5 : n4;
            n4 = temp1;
            n5 = temp2;
            //6th
            temp1 = (n1 > n2) ? n1 : n2;
            temp2 = (n1 > n2) ? n2 : n1;
            n1 = temp1;
            n2 = temp2;
            temp1 = (n3 > n4) ? n3 : n4;
            temp2 = (n3 > n4) ? n4 : n3;
            n3 = temp1;
            n4 = temp2;
        end else begin
            n0 = n0;
            n1 = n1;
            n2 = n2;
            n3 = n3;
            n4 = n4;
            n5 = n5;
        end
        if (opcode[3] == 1'b1) begin
            temp1 = n0;//設六個變數全反
            temp2 = n1;
            temp3 = n2;
            n0 = n5;
            n1 = n4;
            n2 = n3;
            n5 = temp1;
            n4 = temp2;
            n3 = temp3;
        end else begin
            n0 = n0;
            n1 = n1;
            n2 = n2;
            n3 = n3;
            n4 = n4;
            n5 = n5;
        end
        case (opcode[2:0])
            3'b000: begin
                temp1 = (n0 + n1 + n2 + n3 + n4 + n5) / 6; //每個比較結果1/0相加
                sum = 0;
                if (n0 >= temp1) begin
                    sum++;
                end
                if (n1 >= temp1) begin
                    sum++;
                end
                if (n2 >= temp1) begin
                    sum++;
                end
                if (n3 >= temp1) begin
                    sum++;
                end
                if (n4 >= temp1) begin
                    sum++;
                end
                if (n5 >= temp1) begin
                    sum++;
                end
                out_n = sum;
            end
            3'b001:  out_n = n0 + n5;
            3'b010:  out_n = (n3 * n4) / 2;
            3'b011:  out_n = n0 + (n2 * 2);
            3'b100:  out_n = n1 & n2;
            3'b101:  out_n = ~n0;
            3'b110:  out_n = n3 ^ n4;
            3'b111:  out_n = n1 << 1;
            default: out_n = 0;
        endcase
    end
endmodule

//---------------------------------------------------------------------
//   Register design from TA (Do not modify, or demo fails)
//---------------------------------------------------------------------
module register_file (
    address,
    value
);
    input [3:0] address;
    output logic [4:0] value;

    always_comb begin
        case (address)
            4'b0000: value = 5'd9;
            4'b0001: value = 5'd27;
            4'b0010: value = 5'd30;
            4'b0011: value = 5'd3;
            4'b0100: value = 5'd11;
            4'b0101: value = 5'd8;
            4'b0110: value = 5'd26;
            4'b0111: value = 5'd17;
            4'b1000: value = 5'd3;
            4'b1001: value = 5'd12;
            4'b1010: value = 5'd1;
            4'b1011: value = 5'd10;
            4'b1100: value = 5'd15;
            4'b1101: value = 5'd5;
            4'b1110: value = 5'd23;
            4'b1111: value = 5'd20;
            default: value = 0;
        endcase
    end

endmodule
