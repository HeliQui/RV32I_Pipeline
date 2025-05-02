module ID_EX_register (
	input MemReadD, MemWriteD, ALUSrcD, JumpD, RegWriteD, BranchD, MuxjalrD, clk, reset,
	input [3:0] ALUOpD,
	input [2:0] ImmControlD, WriteBackD,
	input [31:0] RD1D, RD2D, PCD, RdD, ImmExtD, PCPlus4D,
	
	output reg MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE,
	output reg [3:0] ALUOpE,
	output reg [2:0] ImmControlE, WriteBackE,
	output reg [31:0] RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E
);

	always @(posedge clk or negedge reset) begin
		if (~reset) begin
			MemReadE <= 0; MemWriteE <= 0; ALUSrcE <= 0; JumpE <= 0; RegWriteE <= 0; BranchE <= 0; MuxjalrE <= 0;
			ALUOpE <= 4'b0000; ImmControlE <= 3'b000; WriteBackE <= 3'b000; RD1E <= 32'd0; RD2E <= 32'd0; PCE <= 32'd0;
			RdE <= 32'd0; ImmExtE <= 32'd0; PCPlus4E <= 32'd0;
		end
		else begin
			MemReadE <= MemReadD;
			MemWriteE <= MemWriteD;
			ALUSrcE <=  ALUSrcD;
			JumpE <= JumpD;
			RegWriteE <= RegWriteD;
			BranchE <= BranchD;
			MuxjalrE <= MuxjalrD;
			ALUOpE <= ALUOpD;
			ImmControlE <= ImmControlD;
			WriteBackE <= WriteBackD;
			RD1E <= RD1D; 
			RD2E <= RD2D;
			PCE <= PCD;
			RdE <= RdD;
			ImmExtE <= ImmExtD;
			PCPlus4E <= PCPlus4D;
		end
	end
endmodule 
