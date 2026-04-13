`timescale 1ns / 1ps

module rca8_tb;

	reg [7:0] x;
	reg [7:0] y;
	reg carry_in;

	wire [8:0] z;
	wire carry_out;

rca8 uut(
	.x(x),
	.y(y),
	.carry_in(carry_in),
	.z(z),
	.carry_out(carry_out)
);

initial begin
	$monitor("time=%0t | x=%d y=%d cin=%b | z=%d cout=%b", 
                 $time, x, y, carry_in, z, carry_out);

	x = 8'd10;
	y = 8'd20;
	carry_in = 0;

	#10;
	$finish
end
endmodule

