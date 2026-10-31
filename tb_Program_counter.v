`timescale 1ns/1ps

module tb_Program_counter;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [31:0] next_pc;

    wire [31:0] pc;

    // Instantiate the Program Counter
    Program_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        // Initial values
        clk = 0;
        rst_n = 0;
        next_pc = 32'b0;

        // Hold reset
        #10;

        // Release reset
        rst_n = 1;

        // Test PC = 4
        next_pc = 32'd4;
        #10;

        // Test PC = 8
        next_pc = 32'd8;
        #10;

        // Test PC = 12
        next_pc = 32'd12;
        #10;

        // Test PC = 16
        next_pc = 32'd16;
        #10;

        $stop;

    end

endmodule