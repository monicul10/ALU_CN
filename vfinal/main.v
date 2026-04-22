module main (
    input clk,
    input rst,
    input start,
    input [1:0] op_sel,
    input signed [15:0] x, // operand de 16 biti pentru impartire
    input signed [7:0]  y, 
    output [15:0] result,
    output done
);

    // registrii
    reg signed [7:0] A, Q, M; 

    assign result = {A, Q};

    wire load_regs, start_mul, start_div, mul_done, div_done;
    wire [7:0] add_out, sub_out;
    wire [15:0] mul_out, div_out;
    wire [2:0] state;

    control_unit brain (
        .clk(clk), .rst(rst), .start(start), .op_sel(op_sel),
        .mul_done(mul_done), .div_done(div_done),
        .start_mul(start_mul), .start_div(start_div),
        .load_regs(load_regs), .done(done), .state(state)
    );

  always @(posedge clk or posedge rst) begin

    if (rst) begin
        A <= 8'd0; 
        Q <= 8'd0; 
        M <= 8'd0; 

    end else if (load_regs) begin
        if (op_sel == 2'b11) begin
            A <= x[15:8]; 
            Q <= x[7:0];  

        end else begin
            A <= 8'b0; 
            Q <= x[7:0];
        end
        M <= y; 
    end
    else if (done) begin
            case (op_sel)
                2'b00: {A, Q} <= {8'b0, add_out}; 
                2'b01: {A, Q} <= {8'b0, sub_out};
                2'b10: {A, Q} <= mul_out;      
                2'b11: {A, Q} <= div_out;        
            endcase
        end
end

   // instantieri de module

    cla8 adder (.x(Q), .y(M), .c0(op_sel[0]), .z(add_out), .carry_out());

    cla_sub8 sub_unit (.x(Q), .y(M), .z(sub_out), .borrow_out());
    
    booth_radix4 multiplier (
        .clk(clk), .rst(rst), .start_op(start_mul),
        .x(Q), .y(M), .outbus(mul_out), .done(mul_done)
    );

    restoring_division divider (
        .clk(clk), .rst(rst), .start_op(start_div),
        .x({A, Q}), .y(M), .outbus(div_out), .done(div_done)
    );
endmodule