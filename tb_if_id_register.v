`timescale 1ns/1ps

module tb_if_id_register;

    reg        clk;
    reg        rst_n;
    reg        flush;

    reg [31:0] IF_PC;
    reg [31:0] IF_Instruction;

    wire [31:0] ID_PC;
    wire [31:0] ID_Instruction;


    // Instantiate IF/ID Pipeline Register
    if_id_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .IF_PC(IF_PC),
        .IF_Instruction(IF_Instruction),
        .ID_PC(ID_PC),
        .ID_Instruction(ID_Instruction)
    );


    // Clock: 10 ns period
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 1'b0;
        rst_n = 1'b0;
        flush = 1'b0;

        IF_PC = 32'b0;
        IF_Instruction = 32'b0;


        // --------------------------------
        // TEST 1: RESET
        // --------------------------------
        #10;

        rst_n = 1'b1;


        // --------------------------------
        // TEST 2: NORMAL CAPTURE
        // --------------------------------

        IF_PC = 32'h00000000;
        IF_Instruction = 32'h00500093;   // ADDI x1,x0,5

        #10;


        // --------------------------------
        // TEST 3: CAPTURE NEXT INSTRUCTION
        // --------------------------------

        IF_PC = 32'h00000004;
        IF_Instruction = 32'h00A00113;   // ADDI x2,x0,10

        #10;


        // --------------------------------
        // TEST 4: ANOTHER INSTRUCTION
        // --------------------------------

        IF_PC = 32'h00000008;
        IF_Instruction = 32'h002081B3;   // ADD x3,x1,x2

        #10;


        // --------------------------------
        // TEST 5: FLUSH
        // --------------------------------

        flush = 1'b1;

        IF_PC = 32'h0000000C;
        IF_Instruction = 32'h00310233;   // Instruction to be flushed

        #10;


        // --------------------------------
        // TEST 6: NORMAL OPERATION AFTER FLUSH
        // --------------------------------

        flush = 1'b0;

        IF_PC = 32'h00000010;
        IF_Instruction = 32'h004182B3;   // ADD x5,x3,x4

        #10;


        $stop;

    end

endmodule