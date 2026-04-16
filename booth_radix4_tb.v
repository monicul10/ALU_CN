`timescale 1ns / 1ps

module booth_radix4_tb;

    // Intrari
    reg clk;
    reg rst;
    reg start_op;
    reg signed [7:0] x;
    reg signed [7:0] y;

    // Iesiri
    wire signed [15:0] outbus;
    wire done_all;

    // Instantierea Unitatii sub Test (UUT)
    booth_radix4 uut (
        .clk(clk), 
        .rst(rst), 
        .start_op(start_op), 
        .x(x), 
        .y(y), 
        .outbus(outbus), 
        .done_all(done_all)
    );

    // Generare Ceas (perioada de 10ns -> 100MHz)
    always #5 clk = ~clk;

    // Task pentru rularea unei operatii de inmultire
    task run_multiplier(input signed [7:0] a_in, input signed [7:0] b_in);
        begin
            @(posedge clk);
            x = a_in;
            y = b_in;
            start_op = 1;
            @(posedge clk);
            start_op = 0;
            
            // Asteapta finalizarea operatiei
            wait(done_all);
            
            $display("Test: %d * %d = %d (Asteptat: %d)", a_in, b_in, outbus, a_in * b_in);
            
            if (outbus == a_in * b_in)
                $display("Status: SUCCES\n");
            else
                $display("Status: EROARE\n");
                
            @(posedge clk);
        end
    endtask

    initial begin
        // Initializare semnale
        clk = 0;
        rst = 1;
        start_op = 0;
        x = 0;
        y = 0;

        // Resetare sistem
        #20 rst = 0;
        #10;

        // Scenariul 1: Pozitiv * Pozitiv
        run_multiplier(8'd12, 8'd5);

        // Scenariul 2: Pozitiv * Negativ
        run_multiplier(8'd10, -8'd4);

        // Scenariul 3: Negativ * Pozitiv
        run_multiplier(-8'd7, 8'd3);

        // Scenariul 4: Negativ * Negativ
        run_multiplier(-8'd12, -8'd10);

        // Scenariul 5: Inmultire cu Zero
        run_multiplier(8'd0, 8'd127);

        // Scenariul 6: Valorile maxime (Edge case)
        run_multiplier(8'd127, 8'd127);
        run_multiplier(-8'd128, 8'd1);

        $display("Simulare terminata!");
        $finish;
    end
      
endmodule