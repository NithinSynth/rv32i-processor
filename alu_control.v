module alu_control (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7,

    output reg [3:0] ALUControl
);

    always @(*) begin

        case (ALUOp)

            // Load / Store / JALR / AUIPC
            2'b00: begin
                ALUControl = 4'b0010;   // ADD
            end

            // Branch
            2'b01: begin
                ALUControl = 4'b0110;   // SUB
            end

            // R-type and I-type ALU operations
            2'b10: begin

                case (funct3)

                    3'b000: begin
                        if (funct7)
                            ALUControl = 4'b0110; // SUB
                        else
                            ALUControl = 4'b0010; // ADD
                    end

                    3'b001:
                        ALUControl = 4'b0011;     // SLL

                    3'b010:
                        ALUControl = 4'b0111;     // SLT

                    3'b011:
                        ALUControl = 4'b1000;     // SLTU

                    3'b100:
                        ALUControl = 4'b0100;     // XOR

                    3'b101: begin
                        if (funct7)
                            ALUControl = 4'b1001; // SRA
                        else
                            ALUControl = 4'b0101; // SRL
                    end

                    3'b110:
                        ALUControl = 4'b0001;     // OR

                    3'b111:
                        ALUControl = 4'b0000;     // AND

                    default:
                        ALUControl = 4'b0010;     // ADD

                endcase
            end

            // LUI
            2'b11: begin
                ALUControl = 4'b1010;
            end

            default:
                ALUControl = 4'b0010;             // ADD

        endcase

    end

endmodule