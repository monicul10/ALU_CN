`timescale 1ns / 1ps

module booth_radix4_tb();
    reg clk;
    reg rst;
    reg start_op;
    reg signed [7:0] x;
    reg signed [7:0] y;
    wire [15:0] outbus;
    wire done;

    // Conectare explicit? prin nume (Port Mapping)
    booth_radix4 dut (
        .clk(clk),
        .rst(rst),
        .start_op(start_op),
        .x(x),
        .y(y),
        .outbus(outbus),
        .done(done)      // <--- Aici trebuie s? existe 'done' în booth_radix4.v
    );

    always #5 clk = ~clk;

    initial begin
        // Reset secven??
        clk = 0; rst = 0; start_op = 0; x = 0; y = 0;
        #20 rst = 1;
        #20;

        // Test: 12 * 5
        x = -8'd5; y = -8'd3;
        #10 start_op = 1;
        #10 start_op = 0;

        wait(done);
        #10;
        $display("Rezultat final: %d", $signed(outbus));
        #50 $finish;
    end
endmodule
