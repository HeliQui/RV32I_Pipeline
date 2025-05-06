module WB_stage ( 
	input [2:0] WriteBackW,
	input [31:0] ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W,
	output [31:0] ResultW
);
	mux5_1 (WriteBackW, ALUResultW, ReadDataW, PCPlus4W, ImmExtW, PCTargetW, ResultW);
endmodule 