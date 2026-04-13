module rca8(

	input wire [7:0] x,
	input wire [7:0] y,
	input wire carry_in,
	
	output wire [7:0] z, 
	output wire carry_out
);

wire [8:0] c;

assign c[0] = carry_in;

genvar i;
generate
for(i = 0; i < 8; i = i + 1) begin: vect

	fac fac_i(
		.x(x[i]),
                .y(y[i]),
                .cin(c[i]),
                .z(z[i]),
                .cout(c[i+1])
        );
end
endgenerate

assign carry_out = c[8];

endmodule		