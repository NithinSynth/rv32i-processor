module fetch_decode_top (

    input        clk,
    input        rst_n,

    // Next PC from Next-PC logic
    input  [31:0] next_pc,

    // Branch flush
    input        flush,

    // Fetch outputs
    output [31:0] pc,
    output [31:0] pc_plus4,
    output [31:0] instruction,

    // Decode-stage outputs
    output [31:0] ID_PC,
    output [31:0] ID_Instruction

);

    // =========================================
    // FETCH STAGE
    // =========================================

    fetch_top FETCH (

        .clk         (clk),
        .rst_n       (rst_n),
        .next_pc     (next_pc),

        .pc          (pc),
        .pc_plus4    (pc_plus4),
        .instruction (instruction)

    );


    // =========================================
    // IF / ID PIPELINE REGISTER
    // =========================================

    if_id_register IF_ID (

        .clk            (clk),
        .rst_n          (rst_n),
        .flush          (flush),

        .IF_PC          (pc),
        .IF_Instruction (instruction),

        .ID_PC          (ID_PC),
        .ID_Instruction (ID_Instruction)

    );

endmodule