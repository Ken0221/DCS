module inter(
  // Input signals
  clk,
  rst_n,
  in_valid_1,
  in_valid_2,
  data_in_1,
  data_in_2,
  ready_slave1,
  ready_slave2,
  // Output signals
  valid_slave1,
  valid_slave2,
  addr_out,
  value_out,
  handshake_slave1,
  handshake_slave2
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid_1, in_valid_2;
input [6:0] data_in_1, data_in_2; 
input ready_slave1, ready_slave2;

output logic valid_slave1, valid_slave2;
output logic [2:0] addr_out, value_out;
output logic handshake_slave1, handshake_slave2;

logic in1, in2;
logic m1_slv, m2_slv;
logic [2:0] m1_addr, m2_addr;
logic [2:0] m1_val, m2_val;

parameter S_idle = 'd0;
parameter S_master1 = 'd1;
parameter S_master2 = 'd2;
parameter S_handshake = 'd3;
logic [1:0] cur_state, next_state;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= S_idle;
    else
        cur_state <= next_state;
end

always_comb begin
    case(cur_state)
        S_idle: begin
            next_state = (in2)? S_master2: ((in1)? S_master1: cur_state);
        end

        S_master1: begin
            if(m1_slv == 0) begin //salve1
                if(valid_slave1 && ready_slave1 == 1) begin
                    next_state = S_handshake;
                end
                else begin
                    next_state = cur_state;
                end
            end
            else begin //slave2
                if(valid_slave2 && ready_slave2 == 1) begin
                    next_state = S_handshake;
                end
                else begin
                    next_state = cur_state;
                end
            end
        end

        S_master2: begin
            if(m2_slv == 0) begin //slave1
                if(valid_slave1 && ready_slave1 == 1) begin
                    next_state = S_handshake;
                end
                else begin
                    next_state = cur_state;
                end
            end
            else begin //slave2
                if(valid_slave2 && ready_slave2 == 1) begin
                    next_state = S_handshake;
                end
                else begin
                    next_state = cur_state;
                end
            end
        end

        S_handshake: begin
            next_state = (in2)? S_master2: ((in1)? S_master1: cur_state);
        end

        default: begin
            next_state = cur_state;
        end
    endcase 
end 

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        valid_slave1 <= 0;
        valid_slave2 <= 0;
        addr_out <= 0;
        value_out <= 0;
        handshake_slave1 <= 0;
        handshake_slave2 <= 0;
        in1 <= 0;
        in2 <= 0;
    end
    else begin
        if(in_valid_1) begin
            m1_slv <= data_in_1[6];
            m1_addr <= data_in_1[5:3];
            m1_val <= data_in_1[2:0];
        end
        if(in_valid_2) begin
            m2_slv <= data_in_2[6];
            m2_addr <= data_in_2[5:3];
            m2_val <= data_in_2[2:0];
        end

        if(in_valid_1) begin
            in1 <= in_valid_1;
        end
        else begin
          in1 <= in1;
        end

        if(in1) begin
          if(cur_state == S_master1) begin
                valid_slave1 <= !m1_slv;
                valid_slave2 <= m1_slv;
                addr_out <= m1_addr;
                value_out <= m1_val;
            end
        end

        if(in_valid_2) begin
            in2 <= in_valid_2;
        end
        else begin
          in2 <= in2;
        end

        if(in2) begin
          if(cur_state == S_master2) begin
                valid_slave1 <= !m2_slv;
                valid_slave2 <= m2_slv;
                addr_out <= m2_addr;
                value_out <= m2_val;
            end
        end
        

        if(valid_slave1 && ready_slave1) begin
            handshake_slave1 <= 1;
        end

        if(valid_slave2 && ready_slave2) begin
            handshake_slave2 <= 1;
        end

        if(next_state == S_handshake) begin
          if(cur_state == S_master1) begin
            in1 <= 0;
          end
          if(cur_state == S_master2) begin
            in2 <= 0;
          end
        end

        if(handshake_slave1) begin
            handshake_slave1 <= 0;
            valid_slave1 <= 0;
            addr_out <= 0;
            value_out <= 0;
        end

        if(handshake_slave2) begin
            handshake_slave2 <= 0;
            valid_slave2 <= 0;
            addr_out <= 0;
            value_out <= 0;
        end
        
    end
end


endmodule
