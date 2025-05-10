module rv32i_pipeline (
	input clk, reset,
	output [31:0] RD1D_check, RD2D_check, ALUResultE_check, ReadDataM_check, ResultW_check, InstrF_check, InstrD_check,
	output [4:0] RR1D_check, RR2D_check, WAD_check
);

	wire PCSrcE;
	wire [31:0] nextPCF, PCF, PCPlus4F, InstrD, InstrF, PCTargetE, PCD, PCPlus4D;
	
	wire MemReadD, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, MuxjalrD, RegWriteE;
	wire RegWriteW;
	wire [2:0] ResultSrcD, ImmSrc;
	wire [3:0] ALUControlD;
	wire [31:0] RD1D, RD2D, ImmExtD,  ResultW;
	wire [4:0] RdW;
	
	wire Stall, Flush, MemReadE, MemWriteE, JumpE, BranchE, ALUSrcE, MuxjalrE; 
	wire [2:0] ResultSrcE, f3E;
	wire [3:0] ALUControlE;
	wire [31:0] RD1E, RD2E, ImmExtE, PCPlus4E, PCE;
	wire [4:0] Rs1E, Rs2E, RdE;
	
	wire FlagE;
	wire [31:0] SrcAE, SrcBE, ALUResultE, ALUResultM, WriteDataE;
	
	wire [1:0] ForwardAE, ForwardBE;
	wire [31:0] PC_RS1;
	
	wire RegWriteM, MemReadM, MemWriteM;
	wire [2:0] ResultSrcM, f3M;
	wire [31:0] WriteDataM, PCTargetM, ImmExtM, PCPlus4M, ReadDataM;
	wire [4:0] RdM;
	
	wire [2:0] ResultSrcW;
	wire [31:0] ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W;


	//-----------------------IF Stage-------------------------------------------------------------------------------------------
	PC pc (.clk(clk), .en(Stall), .rst(reset), .addr_in(nextPCF), .addr_out(PCF));
	assign nextPCF = (PCSrcE) ? PCTargetE : PCPlus4F;
	instruction_Mem imem (.addr(PCF), .inst(InstrF));
	assign PCPlus4F = PCF + 4;
	IF_ID_register if_id (.clk(clk), .stall(Stall), .rst(~Flush), .instF(InstrF), .PCF(PCF), .PCPlus4F(PCPlus4F), .instD(InstrD), 
	.PCD(PCD), .PCPlus4D(PCPlus4D));
	
	
	//---------------------ID Stage---------------------------------------------------------------------------------------------
	Control_Unit controlunit(
		.funct7(InstrD[31:25]), .opcode(InstrD[6:0]),
		.funct3(InstrD[14:12]),
		.MemReadD(MemReadD), .MemWriteD(MemWriteD), .ALUSrcD(ALUSrcD), .JumpD(JumpD), .RegWriteD(RegWriteD), .BranchD(BranchD), .MuxjalrD(MuxjalrD),
		.ALUOpD(ALUControlD), .ImmControlD(ImmSrc), .WriteBackD(ResultSrcD)
	);
	
	rf_32_32 rf (.clk(clk), .reg_write(RegWriteW),  .data_write(ResultW), .wa(RdW), .ra1(InstrD[19:15]), .ra2(InstrD[24:20]), 
	.rd1(RD1D), .rd2(RD2D));
	
	Sign_Extend sign_extend (.inst(InstrD[31:7]), .control(ImmSrc), .imm(ImmExtD));
	
	ID_EX_register id_ex (
		.MemReadD(MemReadD), .MemWriteD(MemWriteD), .ALUSrcD(ALUSrcD), .JumpD(JumpD), .RegWriteD(RegWriteD), .BranchD(BranchD), 
		.MuxjalrD(MuxjalrD), .Stall(Stall), .clk(clk), .reset(~Flush),
		.ALUOpD(ALUControlD),
		.WriteBackD(ResultSrcD), .funct3D(InstrD[14:12]),
		.RD1D(RD1D), .RD2D(RD2D), .PCD(PCD), 
		.RdD(InstrD[11:7]), .Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]),
		.ImmExtD(ImmExtD), .PCPlus4D(PCPlus4D),
	
		.MemReadE(MemReadE), .MemWriteE(MemWriteE), .ALUSrcE(ALUSrcE), .JumpE(JumpE), .RegWriteE(RegWriteE), .BranchE(BranchE), 
		.MuxjalrE(MuxjalrE),
		.ALUOpE(ALUControlE),
		.WriteBackE(ResultSrcE), .funct3E(f3E),
		.RD1E(RD1E), .RD2E(RD2E), .PCE(PCE), 
		.RdE(RdE), .Rs1E(Rs1E), .Rs2E(Rs2E), 
		.ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E)
	);
	
	//---------------------EX Stage---------------------------------------------------------------------------------------------
	
	assign PCSrcE = (FlagE && BranchE) || JumpE;
	alu ALU (.A(SrcAE), .B(SrcBE), .opcode(ALUControlE), .branch(f3E), .result(ALUResultE), .Z(FlagE));
	assign SrcAE = (ForwardAE==2'b00) ? RD1E :
						(ForwardAE==2'b01) ? ResultW : ALUResultM;
						
	assign SrcBE = (ALUSrcE) ? ImmExtE : WriteDataE;
	assign WriteDataE = (ForwardBE==2'b00) ? RD2E :
							  (ForwardBE==2'b01) ? ResultW : ALUResultM;
	assign PC_RS1 = (MuxjalrE) ? RD1E : PCE;
	assign PCTargetE = PC_RS1 + ImmExtE;
	
	EX_M_register ex_m (
		.clk(clk), .rst_n(reset),
		.regWrite_E(RegWriteE), .memWrite_E(MemWriteE), .memRead_E(MemReadE), // dmem có tín hiệu đọc ghi riêng
		.resultScr_E(ResultSrcE), // write_back_E,
		.alu_rsl_E(ALUResultE),
		.imm_extended_E(ImmExtE),
		.write_Data_E(WriteDataE), .PC_target_mux_E(PCTargetE), // 
		.rd_E(RdE),
		.pc4_E(PCPlus4E),
		.mode_E(f3E), // chọn chế độ đọc ghi dmem

		.regWrite_M(RegWriteM), .memWrite_M(MemWriteM), .memRead_M(MemReadM),
		.resultScr_M(ResultSrcM), //write_back_M,
		.alu_rsl_M(ALUResultM),
		.imm_extended_M (ImmExtM),
		.write_Data_M(WriteDataM), .PC_target_mux_M(PCTargetM),
		.rd_M(RdM),
		.pc4_M(PCPlus4M),
		.mode_M(f3M)
		);
	
	
	//---------------------MEM Stage---------------------------------------------------------------------------------------------
	
	dmem DMEM (.clk(clk), .we(MemWriteM), .re(MemReadM),  .mode(f3M), .addr(ALUResultM[9:0]), .write_data(WriteDataM), .mem_out(ReadDataM));
	MEM_WB_register mem_wb (
	.RegWriteM(RegWriteM), .clk(clk), .reset(reset),
	.WriteBackM(ResultSrcM),
	.ALUResultM(ALUResultM), .ReadDataM(ReadDataM), .PCTargetM(PCTargetM), .ImmExtM(ImmExtM), .PCPlus4M(PCPlus4M),
	.RdM(RdM),
	
	.RegWriteW(RegWriteW),
	.WriteBackW(ResultSrcW),
	.ALUResultW(ALUResultW), .ReadDataW(ReadDataW), .PCTargetW(PCTargetW), .ImmExtW(ImmExtW), .PCPlus4W(PCPlus4W),
	.RdW (RdW)
	);
	
	//---------------------WB Stage---------------------------------------------------------------------------------------------
	assign ResultW = (ResultSrcW==3'b000) ? ALUResultW :
						  (ResultSrcW==3'b001) ? ReadDataW :
						  (ResultSrcW==3'b010) ? PCPlus4W :
						  (ResultSrcW==3'b011) ? ImmExtW : PCTargetW;
	
	//---------------------Control Hazard---------------------------------------------------------------------------------------------
	hazard_unit controlhazard (
		.regWrite_M(RegWriteM),
		.regWrite_W(RegWriteW),
		.PCSrc_E(PCSrcE),
		.resultSrc_E(ResultSrcE),
		.rd_M(RdM),
		.rd_W(RdW),
		.rs1_D(InstrD[19:15]),
		.rs2_D(InstrD[24:20]),
		.rs1_E(Rs1E),
		.rs2_E(Rs2E),
		.rd_E(RdE),
		.forwardAE(ForwardAE),
		.forwardBE(ForwardBE),
		.stall(Stall),
		.flush(Flush)
		);
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	assign RD1D_check = RD1D, 
	RD2D_check = RD2D, 
	ALUResultE_check = ALUResultE, 
	ReadDataM_check = ReadDataM, 
	ResultW_check = ResultW, 
	InstrF_check = InstrF,
	RR1D_check = InstrD[19:15], 
	RR2D_check = InstrD[24:20], 
	WAD_check = RdW,
	InstrD_check = InstrD;
	

endmodule 
	
	
	
	
	
	
	
	
	
	
	
