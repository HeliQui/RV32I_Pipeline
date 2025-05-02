module IF_stage (
    input clk, rst,
    input stallF,
    input PCSrcE,
    input [31:0] PCTargetE,

    output [31:0] instD, PCD, PCPlus4D
);

    wire [31:0] PCF, PCPlus4F, nextPC;
    wire [31:0] instF;

    assign PCPlus4F = PCF + 4;
    assign nextPC = (PCSrcE) ? PCTargetE : PCPlus4F;

    PC pc_reg (
        .clk(clk),
        .en(stallF),         // Nếu stall, không cập nhật PC
        .rst(rst),
        .addr_in(nextPC),
        .addr_out(PCF)
    );

    instruction_Mem imem (
        .addr(PCF),
        .inst(instF)
    );

    IF_register if_id_reg (
        .clk(clk),
        .stall(stallF),       // Nếu stall, giữ nguyên output
        .rst(rst),
        .instF(instF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .instD(instD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

endmodule
