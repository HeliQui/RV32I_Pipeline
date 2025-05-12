module alu (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  opcode,
    input  [2:0]  branch,
    output [31:0] result,
    output        Z
);

    wire [31:0] sum, sub, sll, srl, sra, slt, sltu, logic_or, logic_and, logic_xor;
    wire        zero_eq, zero_ne, zero_lt, zero_ge, zero_ltu, zero_geu;

    // Arithmetic
    assign sum     = A + B;
    assign sub     = A - B;

    // Shift
    assign sll     = A << B[4:0];
    assign srl     = A >> B[4:0];
    assign sra     = $signed(A) >>> B[4:0];

    // Compare
    assign slt     = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
    assign sltu    = ($unsigned(A) < $unsigned(B)) ? 32'd1 : 32'd0;

    // Logic
    assign logic_or  = A | B;
    assign logic_and = A & B;
    assign logic_xor = A ^ B;

    // Output MUX based on opcode
    assign result = (opcode == 4'b0000) ? sum     :  // ADD, ADDI
                    (opcode == 4'b0001) ? sll     :  // SLL, SLLI
                    (opcode == 4'b0010) ? slt     :  // SLT, SLTI
                    (opcode == 4'b0011) ? sltu    :  // SLTU, SLTIU
                    (opcode == 4'b0100) ? logic_xor :// XOR, XORI
                    (opcode == 4'b0101) ? srl     :  // SRL, SRLI
                    (opcode == 4'b0110) ? logic_or  :// OR, ORI
                    (opcode == 4'b0111) ? logic_and :// AND, ANDI
                    (opcode == 4'b1000) ? sub     :  // SUB
                    (opcode == 4'b1001) ? sra     :  // SRA, SRAI
                    32'd0;

    // Branch comparison output (Z flag)
    assign zero_eq  = (A == B);
    assign zero_ne  = (A != B);
    assign zero_lt  = ($signed(A) < $signed(B));
    assign zero_ge  = ~zero_lt;
    assign zero_ltu = ($unsigned(A) < $unsigned(B));
    assign zero_geu = ~zero_ltu;

    assign Z = (branch == 3'b000) ? zero_eq  :  // BEQ
                (branch == 3'b001) ? zero_ne  :  // BNE
                (branch == 3'b100) ? zero_lt  :  // BLT
                (branch == 3'b101) ? zero_ge  :  // BGE
                (branch == 3'b110) ? zero_ltu :  // BLTU
                (branch == 3'b111) ? zero_geu :  // BGEU
                1'b0;

endmodule
