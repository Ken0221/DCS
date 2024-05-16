module MIPS(
    //INPUT
    clk,
    rst_n,
    in_valid,
    instruction,

    //OUTPUT
    out_valid,
    instruction_fail,
    out_0,
    out_1,
    out_2,
    out_3,
    out_4,
    out_5
);
// INPUT
input clk;
input rst_n;
input in_valid;
input [31:0] instruction;

// OUTPUT
output logic out_valid, instruction_fail;
output logic [15:0] out_0, out_1, out_2, out_3, out_4, out_5;

//================================================================
// DESIGN 
//================================================================
logic [5:0] opcode, func;
logic [4:0] rs, rt, rd, shamt;
logic [15:0] imd;
logic [15:0] rs_value, rt_value, op_value;
logic [2:0] cnt, cnt2, cnt3;

logic [5:0] opcode2, opcode3, func2;
logic [4:0] rs2, rt2, rd2, rt3, rd3, shamt2;
logic [15:0] imd2;
logic [15:0] out_02, out_12, out_22, out_32, out_42, out_52;

// logic [15:0] mem [5:0];
always @(posedge clk) begin //1st
    case(rs)
        5'b10001: rs_value <= out_0;
        5'b10010: rs_value <= out_1;
        5'b01000: rs_value <= out_2;
        5'b10111: rs_value <= out_3;
        5'b11111: rs_value <= out_4;
        5'b10000: rs_value <= out_5;
        // default: rs_value = 0;
    endcase
    case(rt)
        5'b10001: rt_value <= out_0;
        5'b10010: rt_value <= out_1;
        5'b01000: rt_value <= out_2;
        5'b10111: rt_value <= out_3;
        5'b11111: rt_value <= out_4;
        5'b10000: rt_value <= out_5;
        // default: rt_value = 0;
    endcase
end

logic [4:0] addr;

always @(*) begin //2nd
    addr = 0;
    op_value = 0;
    if(opcode2 == 6'b000000) begin
        case(func2)
            6'b100000: op_value = (rs_value + rt_value);
            6'b100100: op_value = (rs_value & rt_value);
            6'b100101: op_value = (rs_value | rt_value);
            6'b100111: op_value = ~(rs_value | rt_value);
            6'b000000: op_value = (rt_value << shamt2);
            6'b000010: op_value = (rt_value >> shamt2);
            // default: op_value = 0;
        endcase
        addr = rd2;
    end
    else if(opcode2 == 6'b001000)begin
        op_value = rs_value + imd2;
        addr = rt2;
    end
end

always @(posedge clk, negedge rst_n) begin //3rd
    if(!rst_n) begin
        out_0 <= 0;
        out_1 <= 0;
        out_2 <= 0;
        out_3 <= 0;
        out_4 <= 0;
        out_5 <= 0;
    end
    else begin
        case(addr)
            5'b10001: out_0 <= op_value;
            5'b10010: out_1 <= op_value;
            5'b01000: out_2 <= op_value;
            5'b10111: out_3 <= op_value;
            5'b11111: out_4 <= op_value;
            5'b10000: out_5 <= op_value;
        endcase
        // if(!opcode2) begin //r-type
        //     case(rd2)
        //         5'b10001: out_0 <= op_value;
        //         5'b10010: out_1 <= op_value;
        //         5'b01000: out_2 <= op_value;
        //         5'b10111: out_3 <= op_value;
        //         5'b11111: out_4 <= op_value;
        //         5'b10000: out_5 <= op_value;
        //     endcase
        // end
        // else if(opcode2 == 6'b001000) begin //i-type and fail
        //     case(rt2)
        //         5'b10001: out_0 <= op_value;
        //         5'b10010: out_1 <= op_value;
        //         5'b01000: out_2 <= op_value;
        //         5'b10111: out_3 <= op_value;
        //         5'b11111: out_4 <= op_value;
        //         5'b10000: out_5 <= op_value;
        //     endcase
        // end
        if(!cnt2) begin
            out_0 <= 0;
            out_1 <= 0;
            out_2 <= 0;
            out_3 <= 0;
            out_4 <= 0;
            out_5 <= 0;
        end
    end
end

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        instruction_fail <= 0;
        out_valid <= 0;
        cnt <= 0;
    end
    else begin
        if(in_valid) begin
            opcode <= instruction[31:26];
            rs <= instruction[25:21];
            rt <= instruction[20:16];
            rd <= instruction[15:11];
            shamt <= instruction[10:6];
            func <= instruction[5:0];
            imd <= instruction[15:0];
            cnt <= 1;
        end
        else begin
            cnt <= 0;
        end
        if(cnt2 == 1) begin
            out_valid <= 1;
        end
        else begin
            out_valid <= 0;
        end
        if(opcode2 == 6'b000000 || opcode2 == 6'b001000) begin //R-type
            instruction_fail <= 0;
        end
        else begin
            instruction_fail <= 1;
        end
        opcode2 <= opcode;
        func2 <= func;
        rd2 <= rd;
        rt2 <= rt;
        imd2 <= imd;
        shamt2 <= shamt;
        cnt2 <= cnt;
    end
end

endmodule
