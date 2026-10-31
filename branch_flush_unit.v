module branch_flush_unit (

    input  Branch,
    input  branch_taken,

    output reg flush

);

    always @(*) begin

        // Default: no flush
        flush = 1'b0;

        // Flush when a conditional branch is taken
        if (Branch && branch_taken)
            flush = 1'b1;

    end

endmodule