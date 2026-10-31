module pc_plus4 (
    input  [31:0] current_pc,
    output [31:0] next_pc
);

    assign next_pc = current_pc + 32'd4;

endmodule