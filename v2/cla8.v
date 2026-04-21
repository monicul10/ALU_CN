module cla8(

	input wire [7:0] x,
	input wire [7:0] y,
	input wire c0,

	output wire [7:0] z,
	output wire carry_out
);

wire [7:0] g, p;
wire [8:0] c;

wire [3:0] g_2, p_2;
wire [1:0] g_4, p_4;
wire g_8, p_8;

assign c[0] = c0;

genvar i;

// layer 0 (8 AC)
generate
	for (i = 0; i < 8; i = i + 1) begin: vect
		ac ac_i (x[i], y[i], c[i], g[i], p[i], z[i]);
	end
endgenerate

// layer 1 (4 BC)
bc bc_10 (g[1], p[1], g[0], p[0], c[0], g_2[0], p_2[0], c[1]);
bc bc_11 (g[3], p[3], g[2], p[2], c[2], g_2[1], p_2[1], c[3]);
bc bc_12 (g[5], p[5], g[4], p[4], c[4], g_2[2], p_2[2], c[5]);
bc bc_p3 (g[7], p[7], g[6], p[6], c[6], g_2[3], p_2[3], c[7]);

// layer 2 (2 AC)
bc bc_20 (g_2[1], p_2[1], g_2[0], p_2[0], c[0], g_4[0], p_4[0], c[2]);
bc bc_21 (g_2[3], p_2[3], g_2[2], p_2[2], c[4], g_4[1], p_4[1], c[6]);

// layer 3 (1 AC)
bc bc_3 (g_4[1], p_4[1], g_4[0], p_4[0], c[0], g_8, p_8, c[4]);

assign carry_out = g_8 | ( p_8 & c[0]);

endmodule




