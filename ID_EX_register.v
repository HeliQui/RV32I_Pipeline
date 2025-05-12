module ID_EX_register (
	input MemReadD, MemWriteD, ALUSrcD, JumpD, RegWriteD, BranchD, MuxjalrD, Stall, clk, reset, flush, 
	input [3:0] ALUOpD,
	input [2:0] WriteBackD, funct3D,
	input [31:0] RD1D, RD2D, PCD, 
	input [4:0] RdD, Rs1D, Rs2D,
	input [31:0] ImmExtD, PCPlus4D,
	
	output reg MemReadE, MemWriteE, ALUSrcE, JumpE, RegWriteE, BranchE, MuxjalrE,
	output reg [3:0] ALUOpE,
	output reg [2:0] WriteBackE, funct3E,
	output reg [31:0] RD1E, RD2E, PCE, 
	output reg [4:0] RdE, Rs1E, Rs2E, 
	output reg [31:0] ImmExtE, PCPlus4E
);

	always @(posedge clk or negedge reset or posedge flush) begin
		if (~reset || flush) begin
			MemReadE <= 0; MemWriteE <= 0; ALUSrcE <= 0; JumpE <= 0; RegWriteE <= 0; BranchE <= 0; MuxjalrE <= 0;
			ALUOpE <= 4'b0000; WriteBackE <= 3'b000; RD1E <= 32'd0; RD2E <= 32'd0; PCE <= 32'd0;
			RdE <= 5'd0; ImmExtE <= 32'd0; PCPlus4E <= 32'd0; funct3E <= 3'b000; Rs1E <= 5'd0; Rs2E <= 5'd0;
		end
		else if(!Stall)begin
			MemReadE <= MemReadD;
			MemWriteE <= MemWriteD;
			ALUSrcE <=  ALUSrcD;
			JumpE <= JumpD;
			RegWriteE <= RegWriteD;
			BranchE <= BranchD;
			MuxjalrE <= MuxjalrD;
			ALUOpE <= ALUOpD;
			WriteBackE <= WriteBackD;
			RD1E <= RD1D; 
			RD2E <= RD2D;
			PCE <= PCD;
			RdE <= RdD;
			ImmExtE <= ImmExtD;
			PCPlus4E <= PCPlus4D;
			funct3E <= funct3D;
			Rs1E <= Rs1D; Rs2E <= Rs2D; 
		end
		else begin
			RegWriteE <= 0; MemWriteE <= 0;
			MemReadE <= MemReadE;
			ALUSrcE <=  ALUSrcE;
			JumpE <= JumpE;
			BranchE <= BranchE;
			MuxjalrE <= MuxjalrE;
			ALUOpE <= ALUOpE;
			WriteBackE <= WriteBackE;
			RD1E <= RD1E; 
			RD2E <= RD2E;
			PCE <= PCE;
			RdE <= RdE;
			ImmExtE <= ImmExtE;
			PCPlus4E <= PCPlus4E;
			funct3E <= funct3E;
			Rs1E <= Rs1E; Rs2E <= Rs2E; 
		end
	end
endmodule 


