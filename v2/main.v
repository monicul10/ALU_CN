module main (
    input clk,
    input rst,
    input start,
    input [1:0] op_sel,
    input signed [7:0] x,
    input signed [7:0] y,
    output reg [15:0] result,
    output done
);

    // Internal wires for arithmetic results
    wire [7:0] add_res, sub_res;
    wire [15:0] mul_res, div_res;
    wire mul_done_sig, div_done_sig;
    wire start_mul, start_div;
    wire [2:0] state;

    // Instantiate Control Unit
    control_unit brain (
        .clk(clk), .rst(rst), .start(start), .op_sel(op_sel),
        .mul_done(mul_done_sig), .div_done(div_done_sig),
        .start_mul(start_mul), .start_div(start_div),
        .done(done), .state(state)
    );

    // Addition (CLA8)
    cla8 adder (
        .x(x), .y(y), .c0(1'b0), 
        .z(add_res), .carry_out()
    ); 

    // Subtraction (CLA_SUB8)
    cla_sub8 subtractor (
        .x(x), .y(y), 
        .z(sub_res), .borrow_out()
    ); 

    // Multiplication (Booth Radix-4)
    booth_radix4 multiplier (
        .clk(clk), .rst(rst), .start_op(start_mul),
        .x(x), .y(y), .outbus(mul_res), .done(mul_done_sig)
    ); 

    // Division (Restoring Division)
    // Note: Division expects 16-bit dividend, we pad x
    restoring_division divider (
        .clk(clk), .rst(rst), .start_op(start_div),
        .x({8'b0, x}), .y(y), .outbus(div_res), .done(div_done_sig)
    ); 

    // Output Mux based on state
    always @(*) begin
        case (state)
            3'd1:    result = {8'b0, add_res};
            3'd2:    result = {8'b0, sub_res};
            3'd3:    result = mul_res;
            3'd4:    result = div_res;
            default: result = result; 
        endcase
    end

endmodule