`timescale 1ns/1ps

module tb_data_memory;

    reg        clk;
    reg        MemRead;
    reg        MemWrite;
    reg [31:0] address;
    reg [31:0] write_data;

    wire [31:0] read_data;

    data_memory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk       = 0;
        MemRead   = 0;
        MemWrite  = 0;
        address   = 32'd0;
        write_data = 32'd0;

        // --------------------------------
        // STORE 1
        // Address = 0x00
        // Data = 0x12345678
        // --------------------------------
        #10;
        address    = 32'h00000000;
        write_data = 32'h12345678;
        MemWrite   = 1;
        #10;

        MemWrite = 0;

        // --------------------------------
        // LOAD 1
        // Address = 0x00
        // Expected = 0x12345678
        // --------------------------------
        MemRead = 1;
        #10;

        MemRead = 0;

        // --------------------------------
        // STORE 2
        // Address = 0x04
        // Data = 0xABCDEF01
        // --------------------------------
        address    = 32'h00000004;
        write_data = 32'hABCDEF01;
        MemWrite   = 1;
        #10;

        MemWrite = 0;

        // --------------------------------
        // LOAD 2
        // Address = 0x04
        // Expected = 0xABCDEF01
        // --------------------------------
        MemRead = 1;
        #10;

        MemRead = 0;

        // --------------------------------
        // LOAD 1 AGAIN
        // Verify first location
        // was not overwritten
        // --------------------------------
        address = 32'h00000000;
        MemRead = 1;
        #10;

        MemRead = 0;

        // --------------------------------
        // Address = 0x08
        // Should still be zero
        // --------------------------------
        address = 32'h00000008;
        MemRead = 1;
        #10;

        MemRead = 0;

        #10;
        $stop;

    end

endmodule