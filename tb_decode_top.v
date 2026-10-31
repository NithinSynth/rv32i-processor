`timescale 1ns/1ps

module tb_decode_top;

    reg        clk;
    reg        rst;

    reg [31:0] ID_Instruction;

    // Write-back inputs
    reg        wb_RegWrite;
    reg  [4:0] wb_rd;
    reg [31:0] wb_write_data;

    // Decode outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [2:0] funct3;
    wire       funct7;
    wire [6:0] opcode;

    // Control signals
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire [1:0] ALUOp;


    // -----------------------------------------
    // Instantiate Decode Top
    // -----------------------------------------

    decode_top uut (

        .clk           (clk),
        .rst           (rst),

        .ID_Instruction(ID_Instruction),

        .wb_RegWrite   (wb_RegWrite),
        .wb_rd         (wb_rd),
        .wb_write_data (wb_write_data),

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


    // -----------------------------------------
    // Clock
    // -----------------------------------------

    always #5 clk = ~clk;


    // -----------------------------------------
    // Test sequence
    // -----------------------------------------

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        ID_Instruction = 32'b0;

        wb_RegWrite   = 1'b0;
        wb_rd         = 5'b0;
        wb_write_data = 32'b0;

        #10;

        rst = 1'b0;


        // =====================================
        // TEST 1
        // Write x1 = 100
        // =====================================

        wb_RegWrite   = 1'b1;
        wb_rd         = 5'd1;
        wb_write_data = 32'd100;

        #10;


        // =====================================
        // TEST 2
        // Write x2 = 200
        // =====================================

        wb_rd         = 5'd2;
        wb_write_data = 32'd200;

        #10;

        wb_RegWrite = 1'b0;


        // =====================================
        // TEST 3
        // ADD x3, x1, x2
        //
        // Instruction:
        // 0000000 00010 00001 000 00011 0110011
        //
        // Hex = 002081B3
        // =====================================

        ID_Instruction = 32'h002081B3;

        #10;


        // =====================================
        // TEST 4
        // ADDI x4, x1, 10
        //
        // Hex = 00A08213
        // =====================================

        ID_Instruction = 32'h00A08213;

        #10;


        // =====================================
        // TEST 5
        // LW x5, 8(x1)
        //
        // Hex = 0080A283
        // =====================================

        ID_Instruction = 32'h0080A283;

        #10;


        // =====================================
        // TEST 6
        // SW x2, 12(x1)
        //
        // Hex = 0020A623
        // =====================================

        ID_Instruction = 32'h0020A623;

        #10;


        // =====================================
        // TEST 7
        // BEQ x1, x2, 8
        //
        // Hex = 00208463
        // =====================================

        ID_Instruction = 32'h00208463;

        #10;


        // =====================================
        // TEST 8
        // LUI x6, 0x12345
        //
        // Hex = 12345337
        // =====================================

        ID_Instruction = 32'h12345337;

        #10;


        $stop;

    end

endmodule