module sub8(
    input  wire [7:0] x,
    input  wire [7:0] y,
    
    output wire [7:0] z,
    output wire borrow_out
);

wire [8:0] c;
wire [7:0] y_inv;

assign y_inv = ~y;
assign c[0] = 1'b1;

genvar i;
generate
for(i = 0; i < 8; i = i + 1) begin: vect
	
	fac fac_i(
                .x(x[i]),
                .y(y_inv[i]),
                .cin(c[i]),
                .z(z[i]),
                .cout(c[i+1])
         );

end
endgenerate
   
assign borrow_out = ~c[8];

endmodule