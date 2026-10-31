module decode_top (

    input         clk,
    input         rst,

    // Instruction from IF/ID pipeline register
    input  [31:0] ID_Instruction,

    // Write-back interface
    input         wb_RegWrite,
    input  [4:0]  wb_rd,
    input  [31:0] wb_write_data,

    // Decoded register values
    output [31:0] rs1_data,
    output [31:0] rs2_data,

    // Immediate
    output [31:0] immediate,

    // Instruction fields
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd,
    output [2:0]  funct3,
    output        funct7,
    output [6:0]  opcode,

    // Control signals
    output        RegWrite,
    output        MemRead,
    output        MemWrite,
    output        MemToReg,
    output        ALUSrc,
    output        Branch,
    output        Jump,
    output [1:0]  ALUOp

);


    // =================================================
    // RAW Register File outputs
    // =================================================

    wire [31:0] raw_rs1_data;
    wire [31:0] raw_rs2_data;


    // =================================================
    // Instruction field extraction
    // =================================================

    assign opcode = ID_Instruction[6:0];

    assign rd     = ID_Instruction[11:7];

    assign funct3 = ID_Instruction[14:12];

    assign rs1    = ID_Instruction[19:15];

    assign rs2    = ID_Instruction[24:20];

    assign funct7 = ID_Instruction[30];


    // =================================================
    // Control Unit
    // =================================================

    control_unit CU (

        .opcode    (opcode),

        .RegWrite  (RegWrite),
        .MemRead   (MemRead),
        .MemWrite  (MemWrite),
        .MemToReg  (MemToReg),
        .ALUSrc    (ALUSrc),
        .Branch    (Branch),
        .Jump      (Jump),
        .ALUOp      (ALUOp)

    );


    // =================================================
    // Register File
    // =================================================

    register_file RF (

        .clk        (clk),
        .rst        (rst),

        .RegWrite   (wb_RegWrite),

        .rs1        (rs1),
        .rs2        (rs2),

        .rd         (wb_rd),

        .write_data (wb_write_data),

        .read_data1 (raw_rs1_data),
        .read_data2 (raw_rs2_data)

    );


    // =================================================
    // Forwarding Unit
    // =================================================

    forwarding_unit FU (

        .rs1_data           (raw_rs1_data),
        .rs2_data           (raw_rs2_data),

        .rs1                (rs1),
        .rs2                (rs2),

        .wb_reg_write       (wb_RegWrite),
        .wb_rd_addr         (wb_rd),
        .wb_write_data      (wb_write_data),

        .forwarded_rs1_data (rs1_data),
        .forwarded_rs2_data (rs2_data)

    );


    // =================================================
    // Immediate Generator
    // =================================================

    immediate_generator IMM_GEN (

        .instruction (ID_Instruction),

        .immediate   (immediate)

    );


endmodule