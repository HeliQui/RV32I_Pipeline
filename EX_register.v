module EX_register (
    input clk,rst_n,
    input StallE,
    input memWrite_D, 
    input memRead_D, 
    input regWrite_D,   // tín hiệu vào RF  
    input [1:0] write_back_D,
    input [3:0] alu_ctrl_D, 
    input alu_srcB_D,
    input jumpReg_D, jump_D, // tín hiệu điều khiển mux4 bên module EX
    input [2:0] branch_D, // tín hiệu xác định loại rẽ nhánh.
    input branch0_D, // quyết định có rẽ nhánh hay không
    input [31:0] pc_D,
    input [31:0] pc4_D,
    input [31:0] imm_extended_D,
    input [31:0]  RD1_D,
    input [31:0]  RD2_D,
    input [4:0]  rs1_D,
    input [4:0]  rs2_D,
    input [4:0]  rd_D,
    input [2:0]  mode_D, 


    output reg  memWrite_E,
    output reg  memRead_E,
    output reg  regWrite_E,
    output reg  [1:0] write_back_E, 
    output reg  [3:0] alu_ctrl_E,
    output reg  alu_srcB_E,
    output reg  jumpReg_E, jump_E,
    output reg  [2:0] branch_E,
    output reg branch0_E,
    output reg  [31:0] pc_E,
    output reg  [31:0] pc4_E,
    output reg  [31:0] imm_extended_E,
    output reg  [31:0] RD1_E,
    output reg  [31:0] RD2_E,
    output reg  [4:0] rs1_E,
    output reg  [4:0] rs2_E,
    output reg  [4:0] rd_E,
    output reg  [2:0] mode_E
);
    always @(posedge clk) begin
        if (!rst_n) begin 
            memWrite_E <= 0;
	    memRead_E <= 0;
            regWrite_E <= 0;
            write_back_E <= 0;
            alu_ctrl_E <= 0;
            alu_srcB_E <= 0;
            jumpReg_E <= 0;
	    jump_E <= 0;
            branch_E <= 0; // lệnh beq
	    branch0_E <= 0;
            pc_E <= 0;
            pc4_E <= 0;
            imm_extended_E <= 0;
            RD1_E <= 0;
            RD2_E <= 0;
            rs1_E <= 0;
            rs2_E <= 0;
            rd_E <= 0;   
	    mode_E <= 0;
        end
        else if (StallE) begin
            memWrite_E <= memWrite_E;
	    memRead_E <= memRead_E;
            regWrite_E <= regWrite_E;
            write_back_E <= write_back_E;
            alu_ctrl_E <= alu_ctrl_E;
            alu_srcB_E <= alu_srcB_E;
            jumpReg_E <= jumpReg_E;
	    jump_E <= jump_E;
            branch_E <= branch_E;
	    branch0_E <= branch0_E;
            pc_E <= pc_E;
            pc4_E <= pc4_E;
            imm_extended_E <= imm_extended_E;
            RD1_E <= RD1_E;
            RD2_E <= RD2_E;
            rs1_E <= rs1_E;
            rs2_E <= rs2_E;
            rd_E  <= rd_E;   
            mode_E <= mode_E;  
        end
        else begin
            memWrite_E <= memWrite_D;
	    memRead_E <= memRead_D;
            regWrite_E <= regWrite_D;
            write_back_E <= write_back_D;
            alu_ctrl_E <= alu_ctrl_D;
            alu_srcB_E <= alu_srcB_D;
            jumpReg_E <= jumpReg_D;
	    jump_E <= jump_D;
            branch_E <= branch_D; 
	    branch0_E <= branch0_D;
            pc_E <= pc_D;
            pc4_E <= pc4_D;
            imm_extended_E <= imm_extended_D;
            RD1_E <= RD1_D;
            RD2_E <= RD2_D;
            rs1_E <= rs1_D;
            rs2_E <= rs2_D;
            rd_E  <= rd_D; 
	    mode_E <= mode_D;
        end
    end
endmodule
