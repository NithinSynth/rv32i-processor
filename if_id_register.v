module if_id_register (
    input         clk,
    input         rst_n,
    input         flush,

    input  [31:0] IF_PC,
    input  [31:0] IF_Instruction,

    output reg [31:0] ID_PC,
    output reg [31:0] ID_Instruction
);

    always @(posedge clk or negedge rst_n) begin

        // Active-low reset
        if (!rst_n) begin
            ID_PC          <= 32'b0;
            ID_Instruction <= 32'h00000013; // NOP
        end

        // Flush wrongly fetched instruction
        else if (flush) begin
            ID_PC          <= 32'b0;
            ID_Instruction <= 32'h00000013; // NOP
        end

        // Normal pipeline operation
        else begin
            ID_PC          <= IF_PC;
            ID_Instruction <= IF_Instruction;
        end

    end

endmodule