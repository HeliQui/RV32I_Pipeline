module MEM_stage (
	input clk, reset, RegWriteM, MemReadM, MemWriteM,
	input [2:0] WriteBackM, funct3M,
	input [31:0] ALUResultM, WriteDataM, PCTargetM, PCPlus4M, ImmExtM,
	input [4:0] RdM,
	
	output RegWriteW, 
	output [2:0] WriteBackW,
	output [31:0] ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W,
	output [4:0] RdW
);

	wire [31:0] ReadDataM_wire;

	dmem (clk, MemWriteM, MemReadM, funct3M, ALUResultM [9:0], WriteDataM, ReadDataM_wire);
	
	MEM_WB_register (RegWriteM, clk, reset, WriteBackM, ALUResultM, ReadDataM_wire, PCTargetM, ImmExtM, PCPlus4M, RdM,
	RegWriteW, WriteBackW, ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W, RdW);
	
endmodule 
