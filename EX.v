module EX (
	input clk, rst_n, StallE, memWrite_D, memRead_D, regWrite_D, // đi ra
	input [1:0] write_back_D, // đi ra
	input [3:0] alu_ctrl_D, // opcode,  đi vào alu 
	input alu_srcB_D, // đi vào mux
	input jumpReg_D, // đi vào mux
	input jump_D, // tín hiệu có nhảy hay không
	input [2:0] branch_D, // đi vào alu, tín hiệu rẽ nhánh , phân loại loại rẽ nhánh nào
	input branch0_D, // quyết định xem có rẽ nhánh hay không.
	input [31:0] pc_D, pc4_D, imm_extended_D, RD1_D, RD2_D,
	input [4:0] rs1_D, rs2_D, rd_D,
	input [2:0] mode_D,
	
	input [31:0] WB_data, alu_rsl_M,
	input [1:0] FowardAE, FowardBE,
	
	output memWrite_E, memRead_E, regWrite_E,
	output[1:0] write_back_E,
	output Z, // tín hiệu branch
	output [31:0] alu_rsl_E, pc_E, pc4_E, imm_extended_E,
	output [4:0] rs1_E, rs2_E, rd_E,
	output [2:0] mode_E,
	output [31:0] PC_Target_E,
	output PCSrctE
);

	wire [3:0] alu_ctrl_E; // opcode
	wire alu_srcB_E;
	wire jumpReg_E, jump_E;
	wire [2:0] branch_E;
	wire branch0_E;
	wire [31:0] RD1_E, RD2_E;
	wire [31:0] mux1, mux2, mux3, mux4;
	EX_register ex_reg (clk, rst_n, StallE, memWrite_D, memRead_D, regWrite_D, write_back_D, alu_ctrl_D, alu_srcB_D, jumpReg_D, jump_D,
					branch_D, branch0_D, pc_D, pc4_D, imm_extended_D, RD1_D, RD2_D, rs1_D, rs2_D, rd_D, mode_D,
					memWrite_E, memRead_E, regWrite_E, write_back_E, alu_ctrl_E, alu_srcB_E, jumpReg_E, jump_E, branch_E, branch0_E, pc_E,
					pc4_E, imm_extended_E, RD1_E, RD2_E, rs1_E, rs2_E, rd_E, mode_E);
					
	
	mux3to1 outmux1 (RD1_E, WB_data, alu_rsl_M, FowardAE, mux1);
	mux3to1 outmux2 (RD2_E, WB_data, alu_rsl_M, FowardBE, mux2);
	mux2to1 outmux3 (mux2, imm_extended_E, alu_srcB_E, mux3);
	mux2to1 outmux4 (pc_E, mux1, jumpReg_E, mux4);
	alu alu1 (mux1, mux3, alu_ctrl_E, branch_E, alu_rsl_E, Z);
	add add1 (imm_extended_E, mux4, PC_Target_E);
	assign PCSrctE = (Z && branch0_E) || jump_E; 
endmodule

