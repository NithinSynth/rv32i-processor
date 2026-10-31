`timescale 1ns/1ps

module tb_decode_forwarding;

    reg        clk;
    reg        rst;

    reg [31:0] ID_Instruction;

    reg        wb_RegWrite;
    reg  [4:0] wb_rd;
    reg [31:0] wb_write_data;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    wire [31:0] immediate;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [2:0] funct3;
    wire       funct7;
    wire [6:0] opcode;

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire [1:0] ALUOp;


    decode_top uut (

        .clk            (clk),
        .rst            (rst),

        .ID_Instruction (ID_Instruction),

        .wb_RegWrite    (wb_RegWrite),
        .wb_rd          (wb_rd),
        .wb_write_data  (wb_write_data),

        .rs1_data       (rs1_data),
        .rs2_data       (rs2_data),

        .immediate      (immediate),

        .rs1            (rs1),
        .rs2            (rs2),
        .rd             (rd),

        .funct3         (funct3),
        .funct7         (funct7),
        .opcode         (opcode),

        .RegWrite       (RegWrite),
        .MemRead        (MemRead),
        .MemWrite       (MemWrite),
        .MemToReg       (MemToReg),
        .ALUSrc         (ALUSrc),
        .Branch         (Branch),
        .Jump           (Jump),
        .ALUOp          (ALUOp)

    );


    always #5 clk = ~clk;


    initial begin

        clk = 0;
        rst = 1;

        ID_Instruction = 32'b0;

        wb_RegWrite = 0;
        wb_rd = 5'd0;
        wb_write_data = 32'd0;

        #10;

        rst = 0;


        // -----------------------------------------
        // First write x1 = 100
        // -----------------------------------------

        wb_RegWrite = 1;
        wb_rd = 5'd1;
        wb_write_data = 32'd100;

        #10;


        // Stop normal register-file write
        wb_RegWrite = 0;

        // ADD x3, x1, x2
        // rs1 = x1
        // rs2 = x2
        ID_Instruction = 32'h002081B3;

        #10;


        // -----------------------------------------
        // RAW HAZARD
        //
        // Register File contains x1 = 100
        //
        // WB is simultaneously providing:
        // x1 = 500
        //
        // Forwarding must select 500
        // -----------------------------------------

        wb_RegWrite = 1;
        wb_rd = 5'd1;
        wb_write_data = 32'd500;

        #10;


        // -----------------------------------------
        // Test rs2 forwarding
        //
        // Current instruction uses x2
        // WB writes x2 = 600
        // -----------------------------------------

        ID_Instruction = 32'h002081B3;

        wb_RegWrite = 1;
        wb_rd = 5'd2;
        wb_write_data = 32'd600;

        #10;


        // -----------------------------------------
        // Disable forwarding
        // -----------------------------------------

        wb_RegWrite = 0;

        #10;


        $stop;

    end

endmodule