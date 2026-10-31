`timescale 1ns/1ps

module tb_fetch_decode_top;

    reg         clk;
    reg         rst_n;
    reg  [31:0] next_pc;
    reg         flush;

    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instruction;

    wire [31:0] ID_PC;
    wire [31:0] ID_Instruction;


    // =========================================
    // Fetch + IF/ID
    // =========================================

    fetch_decode_top uut (

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
    // Clock
    // =========================================

    always #5 clk = ~clk;


    // =========================================
    // Test
    // =========================================

    initial begin

        clk     = 1'b0;
        rst_n   = 1'b0;

        next_pc = 32'd0;
        flush   = 1'b0;

        // -------------------------------------
        // Reset
        // -------------------------------------

        #10;

        rst_n = 1'b1;


        // -------------------------------------
        // Fetch address 0
        // -------------------------------------

        next_pc = 32'd0;

        #10;


        // -------------------------------------
        // Fetch address 4
        // -------------------------------------

        next_pc = 32'd4;

        #10;


        // -------------------------------------
        // Fetch address 8
        // -------------------------------------

        next_pc = 32'd8;

        #10;


        // -------------------------------------
        // TEST: Flush
        //
        // The instruction currently entering
        // IF/ID must become NOP.
        // -------------------------------------

        flush   = 1'b1;
        next_pc = 32'd12;

        #10;


        // -------------------------------------
        // Release flush
        //
        // Normal operation resumes.
        // -------------------------------------

        flush   = 1'b0;
        next_pc = 32'd16;

        #10;


        // -------------------------------------
        // Continue normally
        // -------------------------------------

        next_pc = 32'd20;

        #10;


        $stop;

    end

endmodule