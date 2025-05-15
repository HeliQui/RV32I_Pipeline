module IF_ID_register (
	input clk, stall, rst, flush, 
	input [31:0] instF, PCF,
	output reg [31:0] instD, PCD
);

	always @(posedge clk or negedge rst or posedge flush) begin
		if(!rst || flush) begin
			instD <= 0;
			PCD <= 0;
		end
		else if(stall) begin 
			instD <= instD;
			PCD <= PCD;
		end
		else begin
			instD <= instF;
			PCD <= PCF;
		end
	end
endmodule 
