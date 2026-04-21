module control_unit (
    input clk,
    input rst,
    input start,
    input [1:0] op_sel,    // 00: Add, 01: Sub, 10: Mul, 11: Div
    input mul_done,
    input div_done,
    output reg start_mul,
    output reg start_div,
    output reg done,
    output reg [2:0] state
);

    localparam S_IDLE = 3'd0,
               S_ADD  = 3'd1,
               S_SUB  = 3'd2,
               S_MUL  = 3'd3,
               S_DIV  = 3'd4,
               S_DONE = 3'd5;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            start_mul <= 0;
            start_div <= 0;
            done <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (start) begin
                        case (op_sel)
                            2'b00: state <= S_ADD;
                            2'b01: state <= S_SUB;
                            2'b10: state <= S_MUL;
                            2'b11: state <= S_DIV;
                        endcase
                    end
                end

                S_ADD, S_SUB: state <= S_DONE; // Combinational ops finish in 1 cycle

                S_MUL: begin
                    if (!mul_done) start_mul <= 1;
                    else begin
                        start_mul <= 0;
                        state <= S_DONE;
                    end
                end

                S_DIV: begin
                    if (!div_done) start_div <= 1;
                    else begin
                        start_div <= 0;
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done <= 1;
                    state <= S_IDLE;
                end
                
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule