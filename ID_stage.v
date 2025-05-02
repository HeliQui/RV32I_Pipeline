module ID_stage (
	input clk, reset, we3, // we3 là we của registers file
	input [6:0] opcode, funct7,
	input [2:0] funct3,
	input [4:0] a1, a2, RdD,
	input [31:0] PCD, PCPlus4D, a3, // a3 là data_write của registers file
	input [24:0] in_Extend,
	
	output MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE,
	output [3:0] ALUOpE,
	output [2:0] ImmControlE, WriteBackE, funct3E,
	output [31:0] RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E
);

	wire MemReadw, MemWritew, ALUSrcw, Jumpw, RegWritew, Branchw, Muxjalrw;
	wire [3:0] ALUOpw;
	wire [2:0] ImmControlw, WriteBackw;
	wire [31:0] RD1w, RD2w, PCw, Rdw, ImmExtw, PCPlus4w;
	
	Control_Unit(funct7, opcode, funct3, MemReadw, MemWritew, ALUSrcw, Jumpw, RegWritew, Branchw, Muxjalrw, ALUOpw, ImmControlw, WriteBackw);
	rf_32_32(clk, we3, a3, RdD, a1, a2, RD1w, RD2w);
	Sign_Extend(in_Extend, ImmControlw, ImmExtw);
	ID_EX_register(
		MemReadw, MemWritew, ALUSrcw, Jumpw, RegWritew, Branchw, Muxjalrw, clk, reset,
		ALUOpw,ImmControlw, WriteBackw, funct3, RD1w, RD2w, PCw, Rdw, ImmExtw, PCPlus4w,
	
		MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE, ALUOpE,
		ImmControlE, WriteBackE, funct3E, RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E
	);

endmodule 
