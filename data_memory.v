module data_memory (
    input        clk,
    input        MemRead,
    input        MemWrite,
    input  [31:0] address,
    input  [31:0] write_data,

    output [31:0] read_data
);

    // 256 x 32-bit memory
    reg [31:0] memory [0:255];

    integer i;

    // Initialize memory to zero
    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;
    end

    // Write operation
    always @(posedge clk) begin
        if (MemWrite)
            memory[address[9:2]] <= write_data;
    end

    // Read operation
    assign read_data = MemRead ? memory[address[9:2]] : 32'b0;

endmodule