module rv32i_cpu (

    input clk,
    input rst_n

);

    // =========================================================
    // FETCH / DECODE CONNECTIONS
    // =========================================================

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

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire [1:0] ALUOp;


    // =========================================================
    // WRITE-BACK CONNECTIONS
    // =========================================================

    wire [31:0] wb_data;
    wire wb_RegWrite;
    wire [4:0] wb_rd;

    assign wb_rd = rd;

    // =========================================================
    // EXECUTE CONNECTIONS
    // =========================================================

    wire [31:0] mem_write_data;
    wire [31:0] alu_result;
    wire        alu_zero;

    wire [31:0] mem_read_data;

    wire        branch_taken;
    wire [31:0] branch_target;


    // =========================================================
    // NEXT-PC LOGIC
    // =========================================================

    wire [31:0] next_pc;

    wire [31:0] jalr_target;

    assign jalr_target =
        (rs1_data + immediate) & 32'hFFFFFFFE;


    // ---------------------------------------------------------
    // PC selection
    //
    // 1. JALR
    // 2. JAL
    // 3. Taken branch
    // 4. PC + 4
    // ---------------------------------------------------------

    assign next_pc =
        (opcode == 7'b1100111) ? jalr_target :
        (opcode == 7'b1101111) ? branch_target :
        (branch_taken)         ? branch_target :
                                  pc_plus4;


    // =========================================================
    // FLUSH
    // =========================================================

    wire flush;

    assign flush = branch_taken |
                   (opcode == 7'b1101111) |
                   (opcode == 7'b1100111);


    // =========================================================
    // FETCH + DECODE
    // =========================================================

    fetch_decode_stage_top FETCH_DECODE (

        .clk            (clk),
        .rst_n          (rst_n),

        .next_pc        (next_pc),
        .flush          (flush),

        .wb_RegWrite    (wb_RegWrite),
        .wb_rd          (wb_rd),
        .wb_write_data  (wb_data),

        .pc             (pc),
        .pc_plus4       (pc_plus4),
        .instruction    (instruction),

        .ID_PC          (ID_PC),
        .ID_Instruction (ID_Instruction),

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
        .ALUOp           (ALUOp)

    );


    // =========================================================
    // EXECUTE
    // =========================================================

    execute_top EXECUTE (

        .clk            (clk),

        .rs1_data       (rs1_data),
        .rs2_data       (rs2_data),
        .immediate      (immediate),

        .ex_pc          (ID_PC),

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

        .ALUOp          (ALUOp),

        .mem_write_data (mem_write_data),

        .alu_result     (alu_result),
        .alu_zero       (alu_zero),

        .mem_read_data  (mem_read_data),

        .branch_taken   (branch_taken),
        .branch_target  (branch_target),

        .wb_data        (wb_data),
        .wb_RegWrite    (wb_RegWrite)

    );

endmodule