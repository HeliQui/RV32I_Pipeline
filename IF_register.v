module IF_register (
	input clk, stall, rst,
	input [31:0] instF, PCF, PCPlus4F,
	output reg [31:0] instD, PCD, PCPlus4D
);

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			instD <= 0;
			PCD <= 0;
			PCPlus4D <= 0;
		end
		else if(stall) begin 
			instD <= instD;
			PCD <= PCD;
			PCPlus4D <= PCPlus4D;
		end
		else begin
			instD <= instF;
			PCD <= PCF;
			PCPlus4D <= PCPlus4F;
		end
	end
endmodule 