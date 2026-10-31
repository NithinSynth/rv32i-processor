`timescale 1ns/1ps

module tb_next_pc_unit;

    reg [31:0] pc;
    reg [31:0] pc_plus4;

    reg [31:0] rs1_data;
    reg [31:0] immediate;

    reg Branch;
    reg branch_taken;
    reg Jump;

    reg [6:0] opcode;

    wire [31:0] next_pc;


    next_pc_unit uut (

        .pc           (pc),
        .pc_plus4     (pc_plus4),

        .rs1_data     (rs1_data),
        .immediate    (immediate),

        .Branch       (Branch),
        .branch_taken (branch_taken),
        .Jump         (Jump),

        .opcode       (opcode),

        .next_pc      (next_pc)

    );


    initial begin

        // =====================================
        // Initial
        // =====================================

        pc = 32'd100;
        pc_plus4 = 32'd104;

        rs1_data = 32'd0;
        immediate = 32'd0;

        Branch = 1'b0;
        branch_taken = 1'b0;
        Jump = 1'b0;

        opcode = 7'b0000000;

        #10;


        // =====================================
        // TEST 1: Normal PC + 4
        // =====================================

        pc = 32'd100;
        pc_plus4 = 32'd104;

        Branch = 1'b0;
        branch_taken = 1'b0;
        Jump = 1'b0;

        #10;


        // =====================================
        // TEST 2: Taken Branch
        //
        // PC = 100
        // immediate = 16
        // target = 116
        // =====================================

        pc = 32'd100;
        pc_plus4 = 32'd104;

        immediate = 32'd16;

        Branch = 1'b1;
        branch_taken = 1'b1;
        Jump = 1'b0;

        #10;


        // =====================================
        // TEST 3: Branch NOT taken
        // =====================================

        pc = 32'd100;
        pc_plus4 = 32'd104;

        Branch = 1'b1;
        branch_taken = 1'b0;
        Jump = 1'b0;

        #10;


        // =====================================
        // TEST 4: JAL
        //
        // PC = 200
        // immediate = 40
        // target = 240
        // =====================================

        pc = 32'd200;
        pc_plus4 = 32'd204;

        immediate = 32'd40;

        Branch = 1'b0;
        branch_taken = 1'b0;

        Jump = 1'b1;
        opcode = 7'b1101111;

        #10;


        // =====================================
        // TEST 5: JALR
        //
        // rs1 = 300
        // immediate = 20
        // target = 320
        // =====================================

        rs1_data = 32'd300;
        immediate = 32'd20;

        Branch = 1'b0;
        branch_taken = 1'b0;

        Jump = 1'b1;
        opcode = 7'b1100111;

        #10;


        // =====================================
        // TEST 6: JALR alignment
        //
        // 301 + 20 = 321
        // LSB must be cleared
        // Expected = 320
        // =====================================

        rs1_data = 32'd301;
        immediate = 32'd20;

        Jump = 1'b1;
        opcode = 7'b1100111;

        #10;


        $stop;

    end

endmodule