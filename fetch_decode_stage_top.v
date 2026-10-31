module fetch_decode_stage_top (

    input         clk,
    input         rst_n,

    // Next PC
    input  [31:0] next_pc,

    // Branch flush
    input         flush,

    // Write-back interface
    input         wb_RegWrite,
    input  [4:0]  wb_rd,
    input  [31:0] wb_write_data,

    // Fetch outputs
    output [31:0] pc,
    output [31:0] pc_plus4,
    output [31:0] instruction,

    // Decode outputs
    output [31:0] ID_PC,
    output [31:0] ID_Instruction,

    output [31:0] rs1_data,
    output [31:0] rs2_data,

    output [31:0] immediate,

    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,

    output [2:0] funct3,
    output       funct7,
    output [6:0] opcode,

    // Control signals
    output       RegWrite,
    output       MemRead,
    output       MemWrite,
    output       MemToReg,
    output       ALUSrc,
    output       Branch,
    output       Jump,
    output [1:0] ALUOp

);


    // =========================================
    // Reset conversion
    //
    // Program Counter uses active-low rst_n
    // Register File uses active-high rst
    // =========================================

    wire rst;

    assign rst = ~rst_n;


    // =========================================
    // FETCH + IF/ID
    // =========================================

    fetch_decode_top FETCH_DECODE (

        .clk            (clk),
        .rst_n          (rst_n),

        .next_pc        (next_pc),
        .flush          (flush),

        .pc             (pc),
        .pc_plus4       (pc_plus4),
        .instruction    (instruction),

        .ID_PC          (ID_PC),
        .ID_Instruction (ID_Instruction)

    );


    // =========================================
    // DECODE
    // =========================================

    decode_top DECODE (

        .clk            (clk),
        .rst            (rst),

        .ID_Instruction (ID_Instruction),

        // Write-back
        .wb_RegWrite    (wb_RegWrite),
        .wb_rd          (wb_rd),
        .wb_write_data  (wb_write_data),

        // Register data
        .rs1_data       (rs1_data),
        .rs2_data       (rs2_data),

        // Immediate
        .immediate      (immediate),

        // Instruction fields
        .rs1            (rs1),
        .rs2            (rs2),
        .rd             (rd),
        .funct3         (funct3),
        .funct7         (funct7),
        .opcode         (opcode),

        // Control
        .RegWrite       (RegWrite),
        .MemRead        (MemRead),
        .MemWrite       (MemWrite),
        .MemToReg       (MemToReg),
        .ALUSrc         (ALUSrc),
        .Branch         (Branch),
        .Jump           (Jump),
        .ALUOp           (ALUOp)

    );

endmodule