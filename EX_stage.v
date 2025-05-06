module EX_stage (
	input clk, rst_n, memWrite_E, memRead_E, regWrite_E,
   input [2:0] resultScr_E, // write back
   input [3:0] alu_ctrl_E,
   input alu_srcB_E, muxjalr, jump_E,
   input[2:0] funct3, // nối vào alu tín hiệu xác định loại rẽ nhánh.
	input branch_E,
   input [31:0] pc_E, pc4_E, imm_extended_E, RD1_E, RD2_E, write_Data_E,
   input [4:0] rd_E,
   input [2:0] mode_E,
	
	output memWrite_M, memRead_M, regWrite_M, PCSrc_E,
	output [2:0] resultScr_M,
	output [31:0] pc4_M, imm_extended_M, ALURuslt_M, write_Data_M, PC_target_mux_M, PC_target_E,
	output [4:0] rd_M,
	output [2:0] mode_M
);

	wire [31:0] mux1, mux2, alu_out, add_out, ALURuslt_E;
	wire Zero_E;
	mux2to1 outmux1 (RD1_E, pc_E, muxjalr, mux1);
	mux2to1 outmux2 (RD2_E, imm_extended_E, alu_srcB_E, mux2);
	add outadd (mux1, imm_extended_E, add_out);
	assign PC_target_E = add_out;
	alu outalu (RD1_E, mux2, alu_ctrl_E, funct3, ALURuslt_E, Zero_E);
	M_register m_reg (clk, rst_n, regWrite_E, memWrite_E, memRead_E, resultScr_E, ALURuslt_E, imm_extended_E, write_Data_E, add_out,
							rd_E, pc4_E, mode_E, regWrite_M, memWrite_M, memRead_M, resultScr_M, ALURuslt_M, imm_extended_M, write_Data_M,
							PC_target_mux_M, rd_M, pc4_M, mode_M);
	assign PCSrc_E = (Zero_E && branch_E) || jump_E;
endmodule
//-------------------------------------------------------forwarding-----------------------------------


module EX_stage (
	input clk, rst_n, memWrite_E, memRead_E, regWrite_E,
   input [2:0] resultScr_E, // write back
   input [3:0] alu_ctrl_E,
   input alu_srcB_E, muxjalr, jump_E,
   input[2:0] funct3, // nối vào alu tín hiệu xác định loại rẽ nhánh.
	input branch_E,
   input [31:0] pc_E, pc4_E, imm_extended_E, RD1_E, RD2_E, write_Data_E, ResultW,
   input [4:0] rd_E,
   input [2:0] mode_E,
	input [1:0] ForwardAE, ForwardBE,
	
	output memWrite_M, memRead_M, regWrite_M, PCSrc_E,
	output [2:0] resultScr_M,
	output [31:0] pc4_M, imm_extended_M, ALURuslt_M, write_Data_M, PC_target_mux_M, PC_target_E,
	output [4:0] rd_M,
	output [2:0] mode_M
);

	wire [31:0] mux1, mux2, mux3, mux4, alu_out, add_out, ALURuslt_E;
	wire Zero_E;
	mux3to1 outmux1 (RD1_E, ResultW, ALURuslt_M, ForwardAE, mux1);
	mux3to1 outmux2 (RD2_E, ResultW , ALURuslt_M, ForwardBE, mux2);
	mux2to1 outmux3 (mux1, pc_E, muxjalr, mux3);
	mux2to1 outmux4 (mux2, imm_extended_E, alu_srcB_E, mux4);
	add outadd (mux3, imm_extended_E, add_out);
	assign PC_target_E = add_out;
	alu outalu (mux1, mux4, alu_ctrl_E, funct3, ALURuslt_E, Zero_E);
	M_register m_reg (clk, rst_n, regWrite_E, memWrite_E, memRead_E, resultScr_E, ALURuslt_E, imm_extended_E, write_Data_E, add_out,
							rd_E, pc4_E, mode_E, regWrite_M, memWrite_M, memRead_M, resultScr_M, ALURuslt_M, imm_extended_M, write_Data_M,
							PC_target_mux_M, rd_M, pc4_M, mode_M);
	assign PCSrc_E = (Zero_E && branch_E) || jump_E;
endmodule

	
	
