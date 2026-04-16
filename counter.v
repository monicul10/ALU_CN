module counter(

	input wire clock,
	input wire reset,
	input wire enable,
	input wire clear,
	input wire mode, // 0 pentru inmultitor(Radix-4 - 4), 1 pentru impartitor (Restoring Division - 8)

	output reg [2:0] count,
	output wire done
);

always @(posedge clock or negedge reset) begin

	if (!reset)
		count <= 3'b000;

	else if (clear)
		count <= 3'b000;

	else if (enable && !done)
		count <= count + 1'b1;
end

assign done = (mode == 0) ? (count == 3'd3) : (count == 3'd7); // numarul de pasi

endmodule