module fac(

	input  wire x,
	input  wire y,
    	input  wire cin,
    	output wire z,
    	output wire cout
);
    	wire w1, w2, w3;

    	assign z = x ^ y ^ cin;
    	assign cout = (x & y) | (cin & (x ^ y));

endmodule