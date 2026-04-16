module ac(

	input wire x,
	input wire y,
	input wire cin,

	output wire g,
	output wire p,
	output wire z
);

assign g = x & y;
assign p = x | y;
assign z = (x ^ y) ^ cin;

endmodule