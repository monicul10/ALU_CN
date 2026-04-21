`timescale 1ns / 1ps

module restoring_division_tb;

    reg clk;
    reg rst;
    reg start_op;
    reg [15:0] x;
    reg [7:0] y;
    wire [15:0] outbus;
    wire done;

    restoring_division dut(
        .clk(clk),
        .rst(rst),
        .start_op(start_op),
        .x(x),
        .y(y),
        .outbus(outbus),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start_op = 0;
        x = 0;
        y = 0;

        // Resetare sistem
        #20 rst = 0;
        @(posedge clk); // Asteptam un front de ceas pentru sincronizare

        // Test 1: 3625 / 107
        x = 16'd3625;
        y = 8'd107;
        start_op = 1;
        @(posedge clk);
        start_op = 0;

        // A\u0219tept\u0103m terminarea opera\u021biei
        wait(done);
        
        // Asteptam un mic delay sau urmatorul front de clock
        // pentru ca semnalele de iesire sa fie stabile dupa ce 'done' a trecut în 1.
        #1; 
        
        $display("--------------------------------------------------");
        $display("Rezultat Hardware: %d / %d = Cat: %d, Rest: %d", x, y, outbus[7:0], outbus[15:8]);
        $display("Asteptat:          3625 / 107 = Cat: 33, Rest: 94");
        $display("--------------------------------------------------");

        #100;

	// Test 2: 5824 / 99
        x = 16'd5824;
        y = 8'd99;
        start_op = 1;
        @(posedge clk);
        start_op = 0;

        wait(done);
        #1; 
        
        $display("--------------------------------------------------");
        $display("Rezultat Hardware: %d / %d = Cat: %d, Rest: %d", x, y, outbus[7:0], outbus[15:8]);
        $display("Asteptat:          5824 / 99 = Cat: 58, Rest: 82");
        $display("--------------------------------------------------");

        #100;
        $finish; 
    end

endmodule
