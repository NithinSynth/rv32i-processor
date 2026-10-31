module fetch_top (

    input        clk,
    input        rst_n,

    input  [31:0] next_pc,

    output [31:0] pc,
    output [31:0] pc_plus4,
    output [31:0] instruction

);

    // -----------------------------------------
    // Program Counter
    // -----------------------------------------

    Program_counter PC (

        .clk     (clk),
        .rst_n   (rst_n),
        .next_pc (next_pc),
        .pc      (pc)

    );


    // -----------------------------------------
    // PC + 4
    // -----------------------------------------

    pc_plus4 PC4 (

        .current_pc (pc),
        .next_pc    (pc_plus4)

    );


    // -----------------------------------------
    // Instruction Memory
    // -----------------------------------------

    instruction_memory IMEM (

        .address     (pc),
        .instruction (instruction)

    );

endmodule