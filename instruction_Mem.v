module instruction_Mem (
    input [31:0] addr,
	 output reg [31:0] inst
);
   reg [31:0] i_mem [63:0]; 
	
	initial begin
		$readmemb ("hex_file.hex", i_mem);
   end
	 
	always @(*) begin
		inst = i_mem[addr[31:2]];
	end
	 
endmodule
