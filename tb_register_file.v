`timescale 1ns/1ps

module tb_register_file;

    reg        clk;
    reg        rst;
    reg        RegWrite;
    reg  [4:0] rs1;
    reg  [4:0] rs2;
    reg  [4:0] rd;
    reg  [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file uut (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk        = 0;
        rst        = 1;
        RegWrite   = 0;
        rs1        = 0;
        rs2        = 0;
        rd         = 0;
        write_data = 0;

        // Reset
        #12;
        rst = 0;

        // Write 100 into x1
        #3;
        RegWrite   = 1;
        rd         = 5'd1;
        write_data = 32'd100;

        #10;

        // Write 200 into x2
        rd         = 5'd2;
        write_data = 32'd200;

        #10;

        // Stop writing
        RegWrite = 0;

        // Read x1 and x2
        rs1 = 5'd1;
        rs2 = 5'd2;

        #10;

        // Check x0
        rs1 = 5'd0;
        rs2 = 5'd0;

        #10;

        $stop;

    end

endmodule