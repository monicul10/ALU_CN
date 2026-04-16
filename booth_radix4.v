module booth_radix4 (
    input  wire              clk,
    input  wire              rst,
    input  wire              start_op,
    input  wire signed [7:0] x, // Multiplicand
    input  wire signed [7:0] y, // Multiplicator
    output reg  signed [15:0] outbus,
    output wire              done_all
);

    // a. Declaratii conform cerintei tale
    reg signed [8:0] A;       // Acumulator pe 9 biti
    reg [7:0]        Q;       // Multiplicand pe 8 biti
    reg signed [7:0] M;       // Multiplicator pe 8 biti
    reg              Q_minus1;// Bitul suplimentar pentru algoritmul Booth
    
    reg [2:0] state;
    
    // Conexiuni pentru counter-ul tau extern
    wire [2:0] count;
    wire       step_done;
    reg        cnt_en, cnt_clr;

    counter step_counter (
        .clock(clk),
        .reset(rst),
        .enable(cnt_en),
        .clear(cnt_clr),
        .mode(1'b0), // Mod 0 pentru inmultire (numara pana la 3)
        .count(count),
        .done(step_done)
    );

    // Stari FSM
    localparam S_IDLE   = 3'd0,
               S_DECIDE = 3'd1,
               S_SHIFT  = 3'd2,
               S_DONE   = 3'd3;

    // Operatii paralele (atentie la extensia de semn la 9 biti)
    wire signed [8:0] M_ext    = {M[7], M};           // M extins la 9 biti
    wire signed [8:0] M2_ext   = {M[7], M} << 1;      // 2 * M
    wire signed [8:0] sum_AM   = A + M_ext;
    wire signed [8:0] sub_AM   = A - M_ext;
    wire signed [8:0] sum_A2M  = A + M2_ext;
    wire signed [8:0] sub_A2M  = A - M2_ext;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            outbus <= 16'd0;
            cnt_en <= 1'b0;
            cnt_clr <= 1'b1;
            Q_minus1 <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    cnt_en <= 1'b0;
                    cnt_clr <= 1'b1;
                    if (start_op) begin
                        A <= 9'd0;
                        M <= y;
                        Q <= x;
                        Q_minus1 <= 1'b0; // Initializam Q-1 cu 0
                        cnt_clr <= 1'b0;
                        state <= S_DECIDE;
                    end
                end

                S_DECIDE: begin
                    // Analizam tripletul format din ultimii 2 biti ai lui Q si Q-1
                    case ({Q[1:0], Q_minus1})
                        3'b001, 3'b010: A <= sum_AM;
                        3'b011:         A <= sum_A2M;
                        3'b100:         A <= sub_A2M;
                        3'b101, 3'b110: A <= sub_AM;
                        default:        A <= A;
                    endcase
                    state <= S_SHIFT;
                end

               S_SHIFT: begin
    // 1. Capture the bit that becomes the new Q_minus1
    Q_minus1 <= Q[1]; 

    // 2. Perform a combined Arithmetic Shift Right by 2
    // We concatenate A and Q, shift them, then split them back
    {A, Q} <= $signed({A, Q}) >>> 2;

    cnt_en <= 1'b1;
    if (step_done) begin
        cnt_en <= 1'b0;
        state <= S_DONE;
    end else begin
        state <= S_DECIDE;
    end
end
            endcase
        end
    end

    assign done_all = (state == S_DONE);

endmodule