module rv32i_pipeline (
    input clk, rst
);

    // ---------- WIRE DECLARATIONS ----------
    // IF-Stage to ID-Stage
    wire [31:0] instD, PCD, PCPlus4D;
    wire stallF, PCSrcE;
    wire [31:0] PCTargetE;

    // ID-Stage to EX-Stage
    wire MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE;
    wire [3:0] ALUOpE;
    wire [2:0] ImmControlE, WriteBackE, funct3E;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [4:0] RdE, Rs1E, Rs2E;

    // EX-Stage to MEM-Stage
    wire memWrite_M, memRead_M, regWrite_M;
    wire [2:0] resultScr_M, mode_M;
    wire [31:0] pc4_M, imm_extended_M, ALURuslt_M, write_Data_M, PC_target_mux_M, PC_target_E;
    wire [4:0] rd_M;

    // MEM-Stage to WB-Stage
    wire RegWriteW;
    wire [2:0] WriteBackW;
    wire [31:0] ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W;
    wire [4:0] RdW;

    // Write-back result
    wire [31:0] ResultW;

    // ---------- MODULE INSTANCES ----------

    // Instruction Fetch Stage
    IF_stage if_stage_inst (
        .clk(clk),
        .rst(rst),
        .stallF(stallF),
        .PCSrcE(PCSrcE),
        .PCTargetE(PC_target_E),
        .instD(instD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Instruction Decode Stage
    ID_stage id_stage_inst (
        .clk(clk),
        .reset(rst),
        .we3(RegWriteW),
        .opcode(instD[6:0]),
        .funct7(instD[31:25]),
        .funct3(instD[14:12]),
        .a1(instD[19:15]),
        .a2(instD[24:20]),
        .RdD(instD[11:7]),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .a3(ResultW),
        .in_Extend(instD[31:7]),

        .MemReadE(MemReadE),
        .MemWriteE(MemWriteE),
        .ALUSrcE(ALUSrcE),
        .JumpE(JumpE),
        .RegWriteE(RegWriteE),
        .BranchE(BranchE),
        .MuxjalrE(MuxjalrE),
        .ALUOpE(ALUOpE),
        .ImmControlE(ImmControlE),
        .WriteBackE(WriteBackE),
        .funct3E(funct3E),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E)
    );

    // Execution Stage
    EX_stage ex_stage_inst (
        .clk(clk),
        .rst_n(~rst),
        .memWrite_E(MemWriteE),
        .memRead_E(MemReadE),
        .regWrite_E(RegWriteE),
        .resultScr_E(WriteBackE),
        .alu_ctrl_E(ALUOpE),
        .alu_srcB_E(ALUSrcE),
        .muxjalr(MuxjalrE),
        .jump_E(JumpE),
        .funct3(funct3E),
        .branch_E(BranchE),
        .pc_E(PCE),
        .pc4_E(PCPlus4E),
        .imm_extended_E(ImmExtE),
        .RD1_E(RD1E),
        .RD2_E(RD2E),
        .write_Data_E(RD2E),  // RD2E là write_data cho RAM
        .ResultW(ResultW),
        .rd_E(RdE),
        .mode_E(ImmControlE),
        .ForwardAE(2'b00),
        .ForwardBE(2'b00),

        .memWrite_M(memWrite_M),
        .memRead_M(memRead_M),
        .regWrite_M(regWrite_M),
        .PCSrc_E(PCSrcE),
        .resultScr_M(resultScr_M),
        .pc4_M(pc4_M),
        .imm_extended_M(imm_extended_M),
        .ALURuslt_M(ALURuslt_M),
        .write_Data_M(write_Data_M),
        .PC_target_mux_M(PC_target_mux_M),
        .PC_target_E(PC_target_E),
        .rd_M(rd_M),
        .mode_M(mode_M)
    );

    // Memory Stage
    MEM_stage mem_stage_inst (
        .clk(clk),
        .reset(rst),
        .RegWriteM(regWrite_M),
        .MemReadM(memRead_M),
        .MemWriteM(memWrite_M),
        .WriteBackM(resultScr_M),
        .funct3M(funct3E),
        .ALUResultM(ALURuslt_M),
        .WriteDataM(write_Data_M),
        .PCTargetM(PC_target_mux_M),
        .PCPlus4M(pc4_M),
        .ImmExtM(imm_extended_M),
        .RdM(rd_M),

        .RegWriteW(RegWriteW),
        .WriteBackW(WriteBackW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCTargetW(PCTargetW),
        .ImmExtW(ImmExtW),
        .PCPlus4W(PCPlus4W),
        .RdW(RdW)
    );

    // Write Back Stage
    WB_stage wb_stage_inst (
        .WriteBackW(WriteBackW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCTargetW(PCTargetW),
        .ImmExtW(ImmExtW),
        .PCPlus4W(PCPlus4W),
        .ResultW(ResultW)
    );

endmodule
