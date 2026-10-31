`timescale 1ns/1ps

module tb_branch_if_id;

    reg        clk;
    reg        rst_n;

    // Branch control
    reg        Branch;
    reg        branch_taken;

    // Fetch stage signals
    reg [31:0] IF_PC;
    reg [31:0] IF_Instruction;

    // Outputs
    wire       flush;

    wire [31:0] ID_PC;
    wire [31:0] ID_Instruction;


    // =================================================
    // Branch Flush Unit
    // =================================================

    branch_flush_unit FLUSH_UNIT (

        .Branch       (Branch),
        .branch_taken (branch_taken),
        .flush        (flush)

    );


    // =================================================
    // IF/ID Pipeline Register
    // =================================================

    if_id_register IF_ID (

        .clk            (clk),
        .rst_n          (rst_n),
        .flush          (flush),

        .IF_PC          (IF_PC),
        .IF_Instruction (IF_Instruction),

        .ID_PC          (ID_PC),
        .ID_Instruction (ID_Instruction)

    );


    // =================================================
    // Clock
    // =================================================

    always #5 clk = ~clk;


    // =================================================
    // Test Sequence
    // =================================================

    initial begin

        clk = 1'b0;

        rst_n = 1'b0;

        Branch = 1'b0;
        branch_taken = 1'b0;

        IF_PC = 32'b0;
        IF_Instruction = 32'b0;

        #10;


        // =============================================
        // TEST 1: Release reset
        // =============================================

        rst_n = 1'b1;

        IF_PC = 32'h00000000;
        IF_Instruction = 32'h00500093;

        #10;


        // =============================================
        // TEST 2: Normal instruction
        //
        // Should enter IF/ID normally
        // =============================================

        Branch = 1'b0;
        branch_taken = 1'b0;

        IF_PC = 32'h00000004;
        IF_Instruction = 32'h00A00113;

        #10;


        // =============================================
        // TEST 3: Taken branch
        //
        // The instruction currently in Fetch
        // is considered wrongly fetched.
        //
        // Branch = 1
        // branch_taken = 1
        //
        // Therefore:
        // flush = 1
        //
        // ID_Instruction = 00000013
        // =============================================

        Branch = 1'b1;
        branch_taken = 1'b1;

        IF_PC = 32'h00000008;
        IF_Instruction = 32'h002081B3;

        #10;


        // =============================================
        // TEST 4: Branch no longer active
        //
        // Normal instruction after flush
        // =============================================

        Branch = 1'b0;
        branch_taken = 1'b0;

        IF_PC = 32'h00000020;
        IF_Instruction = 32'h00310233;

        #10;


        // =============================================
        // TEST 5: Branch enabled but NOT taken
        //
        // Instruction should NOT be flushed
        // =============================================

        Branch = 1'b1;
        branch_taken = 1'b0;

        IF_PC = 32'h00000024;
        IF_Instruction = 32'h004182B3;

        #10;


        $stop;

    end

endmodule