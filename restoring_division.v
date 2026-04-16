module restoring_division(
    input wire clk,
    input wire rst,
    input wire start_op,
    input wire [15:0] x, 
    input wire [7:0]  y, 
    output reg [15:0] outbus, // Rezultat: [15:8] Restul, [7:0] Câtul
    output reg done
);

    reg [8:0] A;      // Registru pentru rest (9 biti pentru a vedea semnul)
    reg [7:0] M;     
    reg [7:0] Q;    
    reg [1:0] state;
    reg [3:0] count; 

    localparam S_IDLE   = 2'd0,
               S_PROC   = 2'd1,
               S_DONE   = 2'd2;

    // Calculam scaderea în avans
    // Shiftam A la stânga si aducem bitul cel mai semnificativ din Q
    wire [8:0] A_shifted = {A[7:0], Q[7]};
    wire [8:0] sub_res   = A_shifted - {1'b0, M};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= S_IDLE;
            done   <= 1'b0;
            outbus <= 16'd0;
            A <= 0; M <= 0; Q <= 0; count <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    if (start_op) begin
                        // Pasul 0: Încarcam x în A si Q
                        A     <= {1'b0, x[15:8]}; 
                        Q     <= x[7:0];
                        M     <= y;
                        count <= 4'd0;
                        state <= S_PROC;
                    end
                end

                S_PROC: begin
                    // Implementare Shift + Subtract + Restore într-un singur ciclu
                    if (sub_res[8]) begin
                        // rezultat negativ: Nu putem scadea
                        // Doar shiftam, A ramâne neschimbat (restaurat), Q[0] devine 0
                        A <= A_shifted;
                        Q <= {Q[6:0], 1'b0};
                    end else begin
                        // rezultat pozitiv: Putem scadea
                        // Actualizam A cu rezultatul scaderii, Q[0] devine 1
                        A <= sub_res;
                        Q <= {Q[6:0], 1'b1};
                    end

                    if (count == 4'd7) begin
                        state <= S_DONE;
                    end else begin
                        count <= count + 4'd1;
                    end
                end

                S_DONE: begin
                    done   <= 1'b1;
                    // outbus[15:8] este Restul (A), outbus[7:0] este Câtul (Q)
                    outbus <= {A[7:0], Q}; 
                    state  <= S_IDLE;
                end
            endcase
        end
    end
endmodule
