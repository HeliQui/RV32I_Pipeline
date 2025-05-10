`timescale 1ns/1ps
module testbench ();
	reg clk, reset;
	wire [31:0] ALUResultE_check, ReadDataM_check, ResultW_check, InstrF_check;
	
	rv32i_pipeline rvp (clk, reset, ALUResultE_check, ReadDataM_check, ResultW_check, InstrF_check);
	
	always #10 clk = ~clk;
	initial begin
		clk = 1;
		reset = 1;
		#1000 $finish;
	end
endmodule