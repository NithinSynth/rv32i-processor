module branch_unit (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  funct3,
    input         Branch,

    output reg    TakeBranch
);

    always @(*) begin

        // Default: branch not taken
        TakeBranch = 1'b0;

        if (Branch) begin

            case (funct3)

                3'b000: begin
                    // BEQ: Branch if Equal
                    TakeBranch = (A == B);
                end

                3'b001: begin
                    // BNE: Branch if Not Equal
                    TakeBranch = (A != B);
                end

                3'b100: begin
                    // BLT: Branch if Less Than (signed)
                    TakeBranch = ($signed(A) < $signed(B));
                end

                3'b101: begin
                    // BGE: Branch if Greater Than or Equal (signed)
                    TakeBranch = ($signed(A) >= $signed(B));
                end

                3'b110: begin
                    // BLTU: Branch if Less Than (unsigned)
                    TakeBranch = (A < B);
                end

                3'b111: begin
                    // BGEU: Branch if Greater Than or Equal (unsigned)
                    TakeBranch = (A >= B);
                end

                default: begin
                    TakeBranch = 1'b0;
                end

            endcase
        end

    end

endmodule