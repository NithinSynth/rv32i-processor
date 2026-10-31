module register_file (
    input        clk,
    input        rst,
    input        RegWrite,
    input  [4:0] rs1,
    input  [4:0] rs2,
    input  [4:0] rd,
    input  [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [0:31];

    integer i;

    // Reset registers
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (RegWrite && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    // x0 is always zero
    assign read_data1 = (rs1 == 5'd0) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'b0 : registers[rs2];

endmodule