`timescale 1ns/1ps

module tb_pc_plus4;

    reg [31:0] current_pc;
    wire [31:0] next_pc;

    // Unit Under Test
    pc_plus4 uut (
        .current_pc(current_pc),
        .next_pc(next_pc)
    );

    initial begin

        // Test 1
        current_pc = 32'd0;
        #10;

        // Test 2
        current_pc = 32'd4;
        #10;

        // Test 3
        current_pc = 32'd8;
        #10;

        // Test 4
        current_pc = 32'd12;
        #10;

        // Test 5
        current_pc = 32'd100;
        #10;

        $stop;

    end

endmodule