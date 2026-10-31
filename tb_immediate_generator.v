`timescale 1ns/1ps

module tb_immediate_generator;

    reg  [31:0] instruction;
    wire [31:0] immediate;

    immediate_generator uut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin

        // I-type
        // ADDI x1, x2, 10
        instruction = 32'h00A10093;
        #10;

        // S-type
        // SW x1, 8(x2)
        instruction = 32'h00112423;
        #10;

        // B-type
        // BEQ x2, x1, 8
        instruction = 32'h00110463;
        #10;

        // U-type
        // LUI x1, 0x12345
        instruction = 32'h123450B7;
        #10;

        // J-type
        // JAL x1, 16
        instruction = 32'h010000EF;
        #10;

        // Invalid opcode
        instruction = 32'hFFFFFFFF;
        #10;

        $stop;

    end

endmodule