`timescale 1ns/1ps

module tb_forwarding_unit;

    // Register File outputs
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;

    // Current instruction source registers
    reg [4:0] rs1;
    reg [4:0] rs2;

    // Write-back information
    reg        wb_reg_write;
    reg [4:0]  wb_rd_addr;
    reg [31:0] wb_write_data;

    // Forwarded outputs
    wire [31:0] forwarded_rs1_data;
    wire [31:0] forwarded_rs2_data;


    // -----------------------------------------
    // Instantiate Forwarding Unit
    // -----------------------------------------

    forwarding_unit uut (

        .rs1_data            (rs1_data),
        .rs2_data            (rs2_data),

        .rs1                 (rs1),
        .rs2                 (rs2),

        .wb_reg_write        (wb_reg_write),
        .wb_rd_addr          (wb_rd_addr),
        .wb_write_data       (wb_write_data),

        .forwarded_rs1_data  (forwarded_rs1_data),
        .forwarded_rs2_data  (forwarded_rs2_data)

    );


    initial begin

        // =====================================
        // Initial values
        // =====================================

        rs1_data = 32'd100;
        rs2_data = 32'd200;

        rs1 = 5'd1;
        rs2 = 5'd2;

        wb_reg_write = 1'b0;
        wb_rd_addr = 5'd0;
        wb_write_data = 32'd0;

        #10;


        // =====================================
        // TEST 1: No Hazard
        //
        // rs1 = x1
        // rs2 = x2
        // WB destination = x5
        //
        // No register match
        // =====================================

        wb_reg_write = 1'b1;
        wb_rd_addr = 5'd5;
        wb_write_data = 32'd500;

        #10;


        // =====================================
        // TEST 2: Forward to rs1
        //
        // Current instruction uses x1
        // WB is writing x1
        //
        // Expected:
        // forwarded_rs1_data = 500
        // =====================================

        rs1 = 5'd1;

        wb_reg_write = 1'b1;
        wb_rd_addr = 5'd1;
        wb_write_data = 32'd500;

        #10;


        // =====================================
        // TEST 3: Forward to rs2
        //
        // Current instruction uses x2
        // WB is writing x2
        //
        // Expected:
        // forwarded_rs2_data = 600
        // =====================================

        rs2 = 5'd2;

        wb_reg_write = 1'b1;
        wb_rd_addr = 5'd2;
        wb_write_data = 32'd600;

        #10;


        // =====================================
        // TEST 4: Forward to BOTH rs1 and rs2
        //
        // Current instruction:
        // rs1 = x1
        // rs2 = x2
        //
        // WB can only have one destination,
        // so change WB destination between tests.
        // =====================================

        rs1 = 5'd1;
        rs2 = 5'd2;

        wb_rd_addr = 5'd1;
        wb_write_data = 32'd700;

        #10;


        // =====================================
        // TEST 5: x0 protection
        //
        // WB attempts to write x0
        //
        // Expected:
        // NO forwarding
        // =====================================

        rs1 = 5'd0;
        wb_reg_write = 1'b1;
        wb_rd_addr = 5'd0;
        wb_write_data = 32'd999;

        #10;


        // =====================================
        // TEST 6: RegWrite disabled
        //
        // Destination matches rs1,
        // but write-back is disabled.
        //
        // Expected:
        // NO forwarding
        // =====================================

        rs1 = 5'd1;
        wb_rd_addr = 5'd1;
        wb_write_data = 32'd888;
        wb_reg_write = 1'b0;

        #10;


        // =====================================
        // TEST 7: Different destination
        //
        // rs1 = x1
        // WB destination = x3
        //
        // Expected:
        // NO forwarding
        // =====================================

        rs1 = 5'd1;
        wb_rd_addr = 5'd3;
        wb_write_data = 32'd777;
        wb_reg_write = 1'b1;

        #10;


        $stop;

    end

endmodule