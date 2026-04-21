module main_tb();
    reg clk, rst, start;
    reg [1:0] op_sel;
    reg signed [15:0] x;
    reg signed [7:0] y;
    wire [15:0] result;
    wire done;

    main uut (
        .clk(clk), 
        .rst(rst), 
        .start(start), 
        .op_sel(op_sel), 
        .x(x), 
        .y(y), 
        .result(result), 
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
	// initializare semnale
        clk = 0; rst = 1; start = 0;
        x = 8'd10; y = 8'd3;
        #20 rst = 0;

        // adunare (10 + 3)
        x = 16'd10; y = 8'd3; 
	op_sel = 2'b00; 
	#10 start = 1;
	#10 start = 0;
        wait(done);

        $display("[ADD] %d + %d = %d", x, y, result[7:0]);

        // scadere (20 - 7)
        x = 16'd20; y = 8'd7; 
	op_sel = 2'b01; 
	#10 start = 1; 
	#10 start = 0;
        wait(done);
        $display("[SUB] %d - %d = %d", x, y, result[7:0]);

        // inmultire (7 * 6)
        x = 16'd7; y = 8'd6; 
	op_sel = 2'b10; 
	#10 start = 1; 
	#10 start = 0;
        wait(done);
        $display("[MUL] %d * %d = %d", x, y, result);

        // impartire (100 / 10)
        x = 16'd1000; y = 8'd10; 
	op_sel = 2'b11; 
	#10 start = 1; 
	#10 start = 0;
        wait(done);
        
        $display("[DIV] %d / %d = Q: %d, R: %d", x, y, result[7:0], result[15:8]);
        #50 $finish;
    end
endmodule