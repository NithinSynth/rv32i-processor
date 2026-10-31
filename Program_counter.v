module Program_counter (
    input clk,
    input rst_n,
    input [31:0] next_pc,
    output reg [31:0] pc
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 32'b0;   // Reset
    end else begin
        pc <= next_pc; // Update
    end
end

endmodule