`timescale 1ns/1ps

module tb_control_unit;

    reg  [6:0] opcode;

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire [1:0] ALUOp;

    control_unit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    initial begin

        // R-type
        // ADD, SUB, AND, OR, etc.
        opcode = 7'b0110011;
        #10;

        // I-type arithmetic
        // ADDI, ANDI, ORI, XORI
        opcode = 7'b0010011;
        #10;

        // Load
        // LW
        opcode = 7'b0000011;
        #10;

        // Store
        // SW
        opcode = 7'b0100011;
        #10;

        // Branch
        // BEQ, BNE, BLT, BGE
        opcode = 7'b1100011;
        #10;

        // JALR
        opcode = 7'b1100111;
        #10;

        // JAL
        opcode = 7'b1101111;
        #10;

        // LUI
        opcode = 7'b0110111;
        #10;

        // AUIPC
        opcode = 7'b0010111;
        #10;

        // Invalid opcode
        opcode = 7'b1111111;
        #10;

        $stop;

    end

endmodule