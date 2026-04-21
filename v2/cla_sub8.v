module cla_sub8(
	
	input wire [7:0] x,
	input wire [7:0] y,
	
	output wire [7:0] z,
	output wire borrow_out
);

wire [7:0] y_inv;
wire c;

assign y_inv = ~y;

cla8 cla8_i( 
	.x(x),
	.y(y_inv),
	.c0(1'b1),
	.z(z),
	.carry_out(c)
);

assign borrow_out = ~c;

endmodule