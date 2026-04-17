module booth_radix4 (
    input clk,
    input rst,          
    input start_op,     
    input signed [7:0] x,
    input signed [7:0] y,
    output reg [15:0] outbus,
    output reg done        
);

  
    wire [2:0] count_val; 
    wire       step_done;
    reg        cnt_en;
    reg        cnt_clr;

    counter custom_counter(
        .clock(clk),
        .reset(rst),
        .enable(cnt_en),   
        .clear(cnt_clr),
        .limit(3'd3),      
        .count(count_val),
        .done(step_done)   
    );

    reg signed [8:0] A, M;
    reg [8:0] Q;
    reg [2:0] state;

    localparam S_IDLE   = 3'd0,
               S_INIT   = 3'd1, // Adăugăm o stare de inițializare clară
               S_DECIDE = 3'd2,
               S_SHIFT  = 3'd3,
               S_DONE   = 3'd4;

    wire signed [8:0] sum_AM  = A + M;
    wire signed [8:0] sub_AM  = A - M;
    wire signed [8:0] sum_A2M = A + (M << 1);
    wire signed [8:0] sub_A2M = A - (M << 1);

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            outbus <= 16'd0;
            done <= 1'b0;
            cnt_en <= 1'b0;
            cnt_clr <= 1'b1;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    cnt_en <= 1'b0;
                    cnt_clr <= 1'b1;
                    if (start_op) begin
                        A <= 9'b0;
                        M <= {y[7], y};
                        Q <= {x, 1'b0};
                        cnt_clr <= 1'b0; // Eliberăm reset-ul contorului
                        state <= S_DECIDE;
                    end
                end

                S_DECIDE: begin
                    cnt_en <= 1'b0; // Nu numărăm în timpul deciziei
                    case (Q[2:0])
                        3'b001, 3'b010: A <= sum_AM;
                        3'b011:         A <= sum_A2M;
                        3'b100:         A <= sub_A2M;
                        3'b101, 3'b110: A <= sub_AM;
                        default:        A <= A;
                    endcase
                    state <= S_SHIFT;
                end

                S_SHIFT: begin
                    {A, Q} <= $signed({A, Q}) >>> 2;
                    cnt_en <= 1'b1; // Activăm numărarea pentru acest pas finalizat
                    
                    // Verificăm dacă am terminat cele 4 iterații
                    // Verificăm count_val direct pentru a fi siguri de sincronizare
                    if (step_done) 
                        state <= S_DONE;
                    else 
                        state <= S_DECIDE;
                end

                S_DONE: begin
                    cnt_en <= 1'b0;
                    cnt_clr <= 1'b1;
                    outbus <= {A[7:0], Q[8:1]};
                    done <= 1'b1;
                    state <= S_IDLE;
                end
                
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
