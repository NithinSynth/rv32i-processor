
`timescale 1ns/1ps

module tb_rv32i_cpu;

    reg clk;
    reg rst_n;

    rv32i_cpu DUT (
        .clk   (clk),
        .rst_n (rst_n)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Reset
    initial begin
        rst_n = 1'b0;
        #20 rst_n = 1'b1;
        #500;
        $display("\nSIMULATION FINISHED");
        $finish;
    end

    // Print stage signals on every rising edge
    always @(posedge clk) begin
        #1;

        if (rst_n) begin
            $display("\n");
            $display("====================================================");
            $display(" CYCLE REPORT | TIME = %0t ns", $time);
            $display("====================================================");

            // STAGE 1: INSTRUCTION FETCH
            $display("\n[IF] INSTRUCTION FETCH");
            $display("PC              = %h", DUT.pc);
            $display("Fetched Instr   = %h", DUT.instruction);
            $display("PC + 4          = %h", DUT.pc_plus4);

            // STAGE 2: INSTRUCTION DECODE
            $display("\n[ID] INSTRUCTION DECODE");
            $display("ID_PC           = %h", DUT.ID_PC);
            $display("ID Instruction  = %h", DUT.ID_Instruction);
            $display("Opcode          = %b", DUT.opcode);
            $display("rs1             = %0d", DUT.rs1);
            $display("rs2             = %0d", DUT.rs2);
            $display("rd              = %0d", DUT.rd);
            $display("rs1_data        = %h", DUT.rs1_data);
            $display("rs2_data        = %h", DUT.rs2_data);
            $display("Immediate       = %h", DUT.immediate);

            // STAGE 3: EXECUTE
            $display("\n[EX] EXECUTE");
            $display("ALU Result      = %h", DUT.alu_result);
            $display("ALU Zero        = %b", DUT.alu_zero);
            $display("Branch          = %b", DUT.Branch);
            $display("Branch Taken    = %b", DUT.branch_taken);
            $display("Branch Target   = %h", DUT.branch_target);

            // STAGE 4: MEMORY ACCESS
            $display("\n[MEM] MEMORY ACCESS");
            $display("MemRead         = %b", DUT.MemRead);
            $display("MemWrite        = %b", DUT.MemWrite);
            $display("Memory Address  = %h", DUT.alu_result);
            $display("Memory WriteData= %h", DUT.mem_write_data);
            $display("Memory ReadData = %h", DUT.mem_read_data);

            // STAGE 5: WRITE BACK
            $display("\n[WB] WRITE BACK");
            $display("RegWrite        = %b", DUT.wb_RegWrite);
            $display("Destination rd  = %0d", DUT.wb_rd);
            $display("WriteBack Data  = %h", DUT.wb_data);

            // PIPELINE / CONTROL
            $display("\n[NEXT PC / CONTROL]");
            $display("Next PC         = %h", DUT.next_pc);
            $display("Flush           = %b", DUT.flush);
            $display("JALR Target      = %h", DUT.jalr_target);

            $display("====================================================");
        end
    end

    // Monitor changes in the main instruction flow
    initial begin
        $monitor(
            "MONITOR | t=%0t | PC=%h | IF_INSTR=%h | ID_INSTR=%h | ALU=%h | WB=%h",
            $time,
            DUT.pc,
            DUT.instruction,
            DUT.ID_Instruction,
            DUT.alu_result,
            DUT.wb_data
        );
    end

endmodule
