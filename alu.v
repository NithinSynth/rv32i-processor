module alu (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,

    output reg [31:0] Result,
    output             Zero
);

    always @(*) begin

        case (ALUControl)

            // AND
            4'b0000:
                Result = A & B;

            // OR
            4'b0001:
                Result = A | B;

            // ADD
            4'b0010:
                Result = A + B;

            // SLL
            4'b0011:
                Result = A << B[4:0];

            // XOR
            4'b0100:
                Result = A ^ B;

            // SRL
            4'b0101:
                Result = A >> B[4:0];

            // SUB
            4'b0110:
                Result = A - B;

            // SLT - signed comparison
            4'b0111:
                Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

            // SLTU - unsigned comparison
            4'b1000:
                Result = (A < B) ? 32'd1 : 32'd0;

            // SRA - arithmetic right shift
            4'b1001:
                Result = $signed(A) >>> B[4:0];

            // LUI
            4'b1010:
                Result = B;

            // Default
            default:
                Result = 32'b0;

        endcase

    end

    // Zero flag
    assign Zero = (Result == 32'b0);

endmodule