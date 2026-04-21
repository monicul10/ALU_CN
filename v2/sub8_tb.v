`timescale 1ns / 1ps

module sub8_tb;

	reg [7:0] x;
	reg [7:0] y;

	wire [7:0] z;
	wire borrow_out;
	
sub8 uut(
	.x(x),
	.y(y),
	.z(z),
	.borrow_out(borrow_out)
);

initial begin
	$monitor("time=%0t | x=%d y=%d | z=%d bout=%b", 
                 $time, x, y, $signed(z), borrow_out);

	x = 8'd50;
	y = 8'd20;

	#10;
	$finish
end
endmodule
