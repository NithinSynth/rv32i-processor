`timescale 1ns/1ps

module tb_fetch_decode_stage_top;

    reg         clk;
    reg         rst_n;

    reg  [31:0] next_pc;
    reg         flush;

    reg         wb_RegWrite;
    reg  [4:0]  wb_rd;
    reg  [31:0] wb_write_data;

    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instruction;

    wire [31:0] ID_PC;
    wire [31:0] ID_Instruction;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [2:0] funct3;
    wire       funct7;
    wire [6:0] opcode;

    wire       RegWrite;
    wire       MemRead;
    wire       MemWrite;
    wire       MemToReg;
    wire       ALUSrc;
    wire       Branch;
    wire       Jump;
    wire [1:0] ALUOp;


    // =========================================
    // FETCH + DECODE
    // =========================================

    fetch_decode_stage_top uut (

        .clk           (clk),
        .rst_n         (rst_n),

        .next_pc       (next_pc),
        .flush         (flush),

        .wb_RegWrite   (wb_RegWrite),
        .wb_rd         (wb_rd),
        .wb_write_data (wb_write_data),

        .pc            (pc),
        .pc_plus4      (pc_plus4),
        .instruction   (instruction),

        .ID_PC         (ID_PC),
        .ID_Instruction(ID_Instruction),

        .rs1_data      (rs1_data),
        .rs2_data      (rs2_data),

        .immediate     (immediate),

        .rs1           (rs1),
        .rs2           (rs2),
        .rd            (rd),

        .funct3        (funct3),
        .funct7        (funct7),
        .opcode        (opcode),

        .RegWrite      (RegWrite),
        .MemRead       (MemRead),
        .MemWrite      (MemWrite),
        .MemToReg      (MemToReg),
        .ALUSrc        (ALUSrc),
        .Branch        (Branch),
        .Jump          (Jump),
        .ALUOp         (ALUOp)

    );


    // =========================================
    // CLOCK
    // =========================================

    always #5 clk = ~clk;


    // =========================================
    // TEST
    // =========================================

    initial begin

        clk = 1'b0;

        // Reset
        rst_n = 1'b0;

        next_pc = 32'd0;
        flush = 1'b0;

        // No write-back initially
        wb_RegWrite = 1'b0;
        wb_rd = 5'd0;
        wb_write_data = 32'd0;

        #10;

        // Release reset
        rst_n = 1'b1;

        // =====================================
        // TEST 1
        // Fetch address 0
        // =====================================

        next_pc = 32'd0;

        #10;


        // =====================================
        // TEST 2
        // Fetch address 4
        // =====================================

        next_pc = 32'd4;

        #10;


        // =====================================
        // TEST 3
        // Write x1 = 100
        // =====================================

        wb_RegWrite   = 1'b1;
        wb_rd         = 5'd1;
        wb_write_data = 32'd100;

        next_pc = 32'd8;

        #10;

        wb_RegWrite = 1'b0;


        // =====================================
        // TEST 4
        // Continue
        // =====================================

        next_pc = 32'd12;

        #10;


        // =====================================
        // TEST 5
        // Forwarding test
        //
        // Write x2 = 200
        // =====================================

        wb_RegWrite   = 1'b1;
        wb_rd         = 5'd2;
        wb_write_data = 32'd200;

        next_pc = 32'd16;

        #10;

        wb_RegWrite = 1'b0;


        // =====================================
        // TEST 6
        // Normal operation
        // =====================================

        next_pc = 32'd20;

        #10;


        // =====================================
        // TEST 7
        // Flush
        // =====================================

        flush   = 1'b1;
        next_pc = 32'd24;

        #10;

        flush = 1'b0;


        // =====================================
        // Finish
        // =====================================

        #10;

        $stop;

    end

endmodule