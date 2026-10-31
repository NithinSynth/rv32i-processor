`timescale 1ns/1ps

module tb_branch_unit;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [2:0]  funct3;
    reg         Branch;

    wire        TakeBranch;

    branch_unit uut (
        .A(A),
        .B(B),
        .funct3(funct3),
        .Branch(Branch),
        .TakeBranch(TakeBranch)
    );

    initial begin

        // Enable branch unit
        Branch = 1'b1;


        // --------------------------------
        // BEQ - A == B
        // --------------------------------
        A = 32'd10;
        B = 32'd10;
        funct3 = 3'b000;
        #10;

        // BEQ - A != B
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'b000;
        #10;


        // --------------------------------
        // BNE - A != B
        // --------------------------------
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'b001;
        #10;

        // BNE - A == B
        A = 32'd10;
        B = 32'd10;
        funct3 = 3'b001;
        #10;


        // --------------------------------
        // BLT - signed A < B
        // -5 < 10
        // --------------------------------
        A = 32'hFFFFFFFB;   // -5
        B = 32'd10;
        funct3 = 3'b100;
        #10;

        // BLT - 10 < -5
        A = 32'd10;
        B = 32'hFFFFFFFB;   // -5
        funct3 = 3'b100;
        #10;


        // --------------------------------
        // BGE - signed A >= B
        // 10 >= -5
        // --------------------------------
        A = 32'd10;
        B = 32'hFFFFFFFB;   // -5
        funct3 = 3'b101;
        #10;

        // BGE - -5 >= 10
        A = 32'hFFFFFFFB;   // -5
        B = 32'd10;
        funct3 = 3'b101;
        #10;


        // --------------------------------
        // BLTU - unsigned A < B
        // --------------------------------
        A = 32'd5;
        B = 32'd10;
        funct3 = 3'b110;
        #10;

        // BLTU - 10 < 5
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'b110;
        #10;


        // --------------------------------
        // BGEU - unsigned A >= B
        // --------------------------------
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'b111;
        #10;

        // BGEU - 5 >= 10
        A = 32'd5;
        B = 32'd10;
        funct3 = 3'b111;
        #10;


        // --------------------------------
        // Branch disabled
        // --------------------------------
        Branch = 1'b0;
        A = 32'd10;
        B = 32'd10;
        funct3 = 3'b000;
        #10;


        $stop;

    end

endmodule