`timescale 1ns / 1ps

module booth_radix2_tb;
  
    reg        clk;
    reg        rst;
    reg        start_op;
    reg  signed [7:0] x;
    reg  signed [7:0] y;
    wire signed [15:0] outbus;
    wire       done;

    // Instantierea modulului Booth
    booth_radix2 uut (
        .clk(clk),
        .rst(rst),
        .start_op(start_op),
        .x(x),
        .y(y),
        .outbus(outbus),
        .done(done)
    );

    // perioada 10ns
    always #5 clk = ~clk;
  
    initial begin
        clk = 0;
        rst = 1;
        start_op = 0;
        x = 0;
        y = 0;

        
        #20 rst = 0;
        #10;

        // --- Test 1: Pozitiv * Pozitiv (7 * 3 = 21) ---
        x = 8'd7; 
        y = 8'd3;
        start_op = 1;
        #10 start_op = 0;
        wait(done);
        $display("Test 1: %d * %d = %d (Asteptat: 21)", x, y, outbus);
        #40;

        // --- Test 2: Pozitiv * Negativ (12 * -5 = -60) ---
        x = 8'd12;
        y = -8'd5;
        start_op = 1;
        #10 start_op = 0;
        wait(done);
        $display("Test 2: %d * %d = %d (Asteptat: -60)", x, y, outbus);
        #40;

        // --- Test 3: Negativ * Negativ (-10 * -4 = 40) ---
        x = -8'd10;
        y = -8'd4;
        start_op = 1;
        #10 start_op = 0;
        wait(done);
        $display("Test 3: %d * %d = %d (Asteptat: 40)", x, y, outbus);
        #40;

        // --- Test 4: Valori la limita (-128 * 2 = -256) ---
        x = -8'sd128;
        y = 8'sd2;
        start_op = 1;
        #10 start_op = 0;
        wait(done);
        $display("Test 4: %d * %d = %d (Asteptat: -256)", x, y, outbus);

        #100;
        $stop;
    end

endmodule
