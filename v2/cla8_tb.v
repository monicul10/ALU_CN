`timescale 1 ns / 1 ps

module cla8_tb;

	reg [7:0] x;
	reg [7:0] y;
	reg c0;

	wire [7:0] z;
	wire carry_out;


cla8 uut(
	.x(x),
	.y(y),
	.c0(c0),
	.z(z),
	.carry_out(carry_out)
);

initial begin
	$monitor("time=%0t | x=%d y=%d cin=%b | z=%d cout=%b", 
                 $time, x, y, carry_in, z, carry_out);

	x = 8'd15; 
	y = 8'd10;
	c0 = 0;

	#10;
	$finish;

end
endmodule

