`timescale 1ns/1ps

module tb_instruction_memory;

    reg  [31:0] address;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        address = 32'd0;
        #10;

        address = 32'd4;
        #10;

        address = 32'd8;
        #10;

        address = 32'd12;
        #10;

        address = 32'd16;
        #10;

        $stop;
    end

endmodule