module MEM_WB_register (
	input RegWriteM, clk, reset,
	input [2:0] WriteBackM,
	input [31:0] ALUResultM, ReadDataM, PCTargetM, ImmExtM, PCPlus4M,
	input [4:0] RdM,
	
	output reg RegWriteW,
	output reg [2:0] WriteBackW,
	output reg [31:0] ALUResultW, ReadDataW, PCTargetW, ImmExtW, PCPlus4W,
	output reg [4:0] RdW
);

always @(posedge clk or negedge reset) begin
	if (~reset) begin
		RegWriteW <= 0;
		WriteBackW <= 3'd0; ALUResultW <= 32'd0; ReadDataW <= 32'd0; PCTargetW <= 32'd0; ImmExtW <= 32'd0; PCPlus4W <= 32'd0;
		RdW <= 5'd0;
	end
	else begin
		RegWriteW <= RegWriteM;
		WriteBackW <= WriteBackM;
		ALUResultW <= ALUResultM; ReadDataW <= ReadDataM; PCTargetW <= PCTargetM; ImmExtW <= ImmExtM; PCPlus4W <= PCPlus4M;
		RdW <= RdM;
	end
end
endmodule 
