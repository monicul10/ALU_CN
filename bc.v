module bc(
	
	input wire G,
	input wire P,
	input wire g,
	input wire p,
	input wire cin,

	output wire gout,
	output wire pout,
	output wire cout
);

assign gout = G | (P & g);
assign pout = P & p;
assign cout = g | (p & cin);

endmodule