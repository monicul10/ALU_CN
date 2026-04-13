module booth_radix2 (
    input  wire              clk,
    input  wire              rst,
    input  wire              start_op,
    input  wire signed [7:0] x,
    input  wire signed [7:0] y,
    output reg  signed [15:0] outbus,
    output reg               done
);

    reg signed [8:0] A, M;
    reg [8:0]        Q;
    reg [2:0]        state;
    reg [3:0]        count;

    localparam S_IDLE   = 3'd0,
               S_DECIDE = 3'd1,
               S_SHIFT  = 3'd2,
               S_DONE   = 3'd3;

    wire signed [8:0] sum_AM = A + M;
    wire signed [8:0] sub_AM = A - M;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= S_IDLE;
            done   <= 1'b0;
            outbus <= 16'd0;
            A      <= 9'd0;
            M      <= 9'd0;
            Q      <= 9'd0;
            count  <= 4'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    if (start_op) begin
                        A     <= 9'd0;
                        M     <= {y[7], y};
                        Q     <= {x, 1'b0};
                        count <= 4'd0;
                        state <= S_DECIDE;
                    end
                end

                S_DECIDE: begin
                    case (Q[1:0])
                        2'b01:   A <= sum_AM;
                        2'b10:   A <= sub_AM;
                        default: A <= A;
                    endcase
                    state <= S_SHIFT;
                end

                S_SHIFT: begin
                    {A, Q} <= {A[8], A, Q[8:1]};
                    if (count == 4'd7)
                        state <= S_DONE;
                    else begin
                        count <= count + 1'b1;
                        state <= S_DECIDE;
                    end
                end

                S_DONE: begin
                    outbus <= {A[7:0], Q[8:1]};
                    done   <= 1'b1;
                    state  <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
