`timescale 1ns/1ps

module tb_execute_top;

    reg         clk;

    // Decode-stage inputs
    reg [31:0]  rs1_data;
    reg [31:0]  rs2_data;
    reg [31:0]  immediate;
    reg [31:0]  ex_pc;

    // Instruction fields
    reg [2:0]   funct3;
    reg         funct7;

    // Control signals
    reg         RegWrite;
    reg         MemRead;
    reg         MemWrite;
    reg         MemToReg;
    reg         ALUSrc;
    reg         Branch;
    reg [1:0]   ALUOp;

    // Outputs
    wire [31:0] mem_write_data;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire [31:0] mem_read_data;

    wire        branch_taken;
    wire [31:0] branch_target;

    wire [31:0] wb_data;
    wire        wb_RegWrite;


    // -----------------------------------------
    // Execute Top
    // -----------------------------------------

    execute_top uut (

        .clk           (clk),

        .rs1_data      (rs1_data),
        .rs2_data      (rs2_data),
        .immediate     (immediate),

        .ex_pc         (ex_pc),

        .funct3        (funct3),
        .funct7        (funct7),

        .RegWrite      (RegWrite),
        .MemRead       (MemRead),
        .MemWrite      (MemWrite),
        .MemToReg      (MemToReg),
        .ALUSrc        (ALUSrc),
        .Branch        (Branch),

        .ALUOp         (ALUOp),

        .mem_write_data(mem_write_data),

        .alu_result    (alu_result),
        .alu_zero      (alu_zero),

        .mem_read_data (mem_read_data),

        .branch_taken  (branch_taken),
        .branch_target (branch_target),

        .wb_data       (wb_data),
        .wb_RegWrite   (wb_RegWrite)

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

        // Default values
        rs1_data = 32'b0;
        rs2_data = 32'b0;
        immediate = 32'b0;
        ex_pc = 32'b0;

        funct3 = 3'b000;
        funct7 = 1'b0;

        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        ALUSrc = 1'b0;
        Branch = 1'b0;
        ALUOp = 2'b00;

        #10;


        // =====================================
        // TEST 1: ADD
        //
        // 100 + 200 = 300
        // =====================================

        rs1_data = 32'd100;
        rs2_data = 32'd200;

        immediate = 32'd0;

        funct3 = 3'b000;
        funct7 = 1'b0;

        ALUSrc = 1'b0;
        ALUOp = 2'b10;

        RegWrite = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        Branch = 1'b0;

        #10;


        // =====================================
        // TEST 2: ADDI
        //
        // 100 + 25 = 125
        // =====================================

        rs1_data = 32'd100;
        immediate = 32'd25;

        funct3 = 3'b000;
        funct7 = 1'b0;

        ALUSrc = 1'b1;
        ALUOp = 2'b10;

        RegWrite = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        Branch = 1'b0;

        #10;


        // =====================================
        // TEST 3: SW
        //
        // Store 12345678 at address 16
        //
        // Address = 4 + 12 = 16
        // =====================================

        rs1_data = 32'd4;
        rs2_data = 32'h12345678;
        immediate = 32'd12;

        funct3 = 3'b010;
        funct7 = 1'b0;

        ALUSrc = 1'b1;
        ALUOp = 2'b00;

        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        MemToReg = 1'b0;
        Branch = 1'b0;

        #10;


        // Disable store
        MemWrite = 1'b0;

        #5;


        // =====================================
        // TEST 4: LW
        //
        // Load from address 16
        // Expected = 12345678
        // =====================================

        rs1_data = 32'd4;
        immediate = 32'd12;

        funct3 = 3'b010;
        funct7 = 1'b0;

        ALUSrc = 1'b1;
        ALUOp = 2'b00;

        RegWrite = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        MemToReg = 1'b1;
        Branch = 1'b0;

        #10;


        // =====================================
        // TEST 5: BEQ
        //
        // 50 == 50
        // Branch should be taken
        //
        // PC = 100
        // Immediate = 16
        // Target = 116
        // =====================================

        rs1_data = 32'd50;
        rs2_data = 32'd50;
        immediate = 32'd16;
        ex_pc = 32'd100;

        funct3 = 3'b000;
        funct7 = 1'b0;

        ALUSrc = 1'b0;
        ALUOp = 2'b01;

        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        Branch = 1'b1;

        #10;


        // =====================================
        // TEST 6: BEQ NOT TAKEN
        //
        // 50 != 40
        // =====================================

        rs1_data = 32'd50;
        rs2_data = 32'd40;

        immediate = 32'd20;
        ex_pc = 32'd200;

        funct3 = 3'b000;

        Branch = 1'b1;

        #10;


        // =====================================
        // TEST 7: BNE
        //
        // 50 != 40
        // Branch should be taken
        // =====================================

        rs1_data = 32'd50;
        rs2_data = 32'd40;

        immediate = 32'd12;
        ex_pc = 32'd300;

        funct3 = 3'b001;

        Branch = 1'b1;

        #10;


        // =====================================
        // TEST 8: LUI
        //
        // Result = 12345000
        // =====================================

        rs1_data = 32'd0;
        rs2_data = 32'd0;
        immediate = 32'h12345000;

        funct3 = 3'b000;
        funct7 = 1'b0;

        ALUSrc = 1'b1;
        ALUOp = 2'b11;

        RegWrite = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        Branch = 1'b0;

        #10;


        $stop;

    end

endmodule