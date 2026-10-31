module execute_top (

    input         clk,

    // Data from Decode Stage
    input  [31:0] rs1_data,
    input  [31:0] rs2_data,
    input  [31:0] immediate,

    // PC of current instruction
    input  [31:0] ex_pc,

    // Instruction fields
    input  [2:0]  funct3,
    input         funct7,
    input  [6:0]  opcode,

    // Control signals
    input         RegWrite,
    input         MemRead,
    input         MemWrite,
    input         MemToReg,
    input         ALUSrc,
    input         Branch,
    input         Jump,

    input  [1:0]  ALUOp,

    // Data Memory write data
    output [31:0] mem_write_data,

    // ALU outputs
    output [31:0] alu_result,
    output        alu_zero,

    // Data Memory output
    output [31:0] mem_read_data,

    // Branch outputs
    output        branch_taken,
    output [31:0] branch_target,

    // Write-back result
    output [31:0] wb_data,

    // Pass control signal toward Write Back
    output        wb_RegWrite

);


    // ------------------------------------------------
    // Internal signals
    // ------------------------------------------------

    wire [3:0] ALUControl;
    wire [31:0] ALU_B;


    // ------------------------------------------------
    // ALUSrc Multiplexer
    // ------------------------------------------------

    assign ALU_B = ALUSrc ? immediate : rs2_data;


    // ------------------------------------------------
    // ALU Control
    // ------------------------------------------------

    alu_control ALU_CTRL (

        .ALUOp      (ALUOp),
        .funct3     (funct3),
        .funct7     (funct7),
        .ALUControl (ALUControl)

    );


    // ------------------------------------------------
    // ALU
    // ------------------------------------------------

    alu ALU (

        .A          (rs1_data),
        .B          (ALU_B),
        .ALUControl (ALUControl),
        .Result     (alu_result),
        .Zero       (alu_zero)

    );


    // ------------------------------------------------
    // Data Memory
    // ------------------------------------------------

    assign mem_write_data = rs2_data;

    data_memory DATA_MEM (

        .clk        (clk),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .address    (alu_result),
        .write_data (mem_write_data),
        .read_data  (mem_read_data)

    );


    // ------------------------------------------------
    // Branch Unit
    // ------------------------------------------------

    branch_unit BRANCH_UNIT (

        .A          (rs1_data),
        .B          (rs2_data),
        .funct3     (funct3),
        .Branch     (Branch),
        .TakeBranch (branch_taken)

    );


    // ------------------------------------------------
    // Branch Target
    // ------------------------------------------------

    assign branch_target = ex_pc + immediate;


    // ------------------------------------------------
    // Write-Back MUX
    //
    // JAL/JALR  -> PC + 4
    // AUIPC     -> PC + immediate
    // LUI       -> ALU result
    // Load      -> Data memory
    // Others    -> ALU result
    // ------------------------------------------------

    reg [31:0] wb_result;

    always @(*) begin

        // Default
        wb_result = alu_result;

        // Load
        if (MemToReg)
            wb_result = mem_read_data;

        // JAL / JALR
        if (Jump)
            wb_result = ex_pc + 32'd4;

        // AUIPC
        if (opcode == 7'b0010111)
            wb_result = ex_pc + immediate;

    end

    assign wb_data = wb_result;


    // ------------------------------------------------
    // Write Enable
    // ------------------------------------------------

    assign wb_RegWrite = RegWrite;

endmodule