module counter(

	input wire clock,
	input wire reset,
	input wire enable,
	input wire clear,
	input wire [2:0] limit,

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

assign done = (count == limit);

endmodule