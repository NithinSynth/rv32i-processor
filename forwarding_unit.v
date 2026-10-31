module forwarding_unit (

    // Normal Register File outputs
    input  [31:0] rs1_data,
    input  [31:0] rs2_data,

    // Current instruction source registers
    input  [4:0]  rs1,
    input  [4:0]  rs2,

    // Write-back information from later stage
    input         wb_reg_write,
    input  [4:0]  wb_rd_addr,
    input  [31:0] wb_write_data,

    // Forwarded outputs
    output reg [31:0] forwarded_rs1_data,
    output reg [31:0] forwarded_rs2_data
);

    always @(*) begin

        // ----------------------------------------
        // Default: use Register File values
        // ----------------------------------------

        forwarded_rs1_data = rs1_data;
        forwarded_rs2_data = rs2_data;


        // ----------------------------------------
        // Forward to rs1
        // ----------------------------------------

        if (wb_reg_write &&
            (wb_rd_addr != 5'd0) &&
            (wb_rd_addr == rs1)) begin

            forwarded_rs1_data = wb_write_data;

        end


        // ----------------------------------------
        // Forward to rs2
        // ----------------------------------------

        if (wb_reg_write &&
            (wb_rd_addr != 5'd0) &&
            (wb_rd_addr == rs2)) begin

            forwarded_rs2_data = wb_write_data;

        end

    end

endmodule