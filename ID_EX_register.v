module ID_EX_register (
	input MemReadD, MemWriteD, ALUSrcD, JumpD, RegWriteD, BranchD, MuxjalrD, Stall, clk, reset,
	input [3:0] ALUOpD,
	input [2:0] ImmControlD, WriteBackD, funct3D,
	input [31:0] RD1D, RD2D, PCD, 
	input [4:0] RdD, Rs1D, Rs2D,
	input [31:0] ImmExtD, PCPlus4D,
	
	output reg MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE,
	output reg [3:0] ALUOpE,
	output reg [2:0] ImmControlE, WriteBackE, funct3E,
	output reg [31:0] RD1E, RD2E, PCE, 
	output reg [4:0] RdE, Rs1E, Rs2E, 
	output reg [31:0] ImmExtE, PCPlus4E
);

	always @(posedge clk or negedge reset) begin
		if (~reset) begin
			MemReadE <= 0; MemWriteE <= 0; ALUSrcE <= 0; JumpE <= 0; RegWriteE <= 0; BranchE <= 0; MuxjalrE <= 0;
			ALUOpE <= 4'b0000; ImmControlE <= 3'b000; WriteBackE <= 3'b000; RD1E <= 32'd0; RD2E <= 32'd0; PCE <= 32'd0;
			RdE <= 5'd0; ImmExtE <= 32'd0; PCPlus4E <= 32'd0; funct3E <= 3'b000; Rs1E <= 5'd0; Rs2E <= 5'd0;
		end
		else begin
			if (Stall) begin RegWriteE <= 0; MemWriteE <= 0; end
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
			funct3E <= funct3D;
			Rs1E <= Rs1D; Rs2E <= Rs2D; end
		end
	end
endmodule 
