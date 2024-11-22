module Flush(
    input clk,
    input rst,
    input flush,
    input [31:0] pcD,           
    input [31:0] pcplus4D,      
    input [31:0] op1D, op2D, immxD, jumpoffset,
    input [3:0] alusignalD,
    input [4:0] rdD, rs1D, rs2D,
    input regwriteD, isimmediateD, memwriteD, isloadD, memreadD, branchD, jumpD,
    output reg [3:0] alusignalDCH,
    output reg [31:0] op1DCH, op2DCH, immxDCH, jumpoffsetCH,
    output reg [4:0] rdDCH, rs1DCH, rs2DCH,
    output reg regwriteDCH, isimmediateDCH, memwriteDCH, isloadDCH, memreadDCH, branchDCH, jumpDCH,
    output reg [31:0] pcDCH, pcplus4DCH
);

    always @(*) begin
        if (flush) begin
            alusignalDCH = 4'b0000;
            op1DCH = 32'h00000000;
            op2DCH = 32'h00000000;
            immxDCH = 32'h00000000;
            jumpoffsetCH = 32'h00000000;
            regwriteDCH = 1'b0;
            isimmediateDCH = 1'b0;
            memwriteDCH = 1'b0;
            isloadDCH = 1'b0;
            memreadDCH = 1'b0;
            branchDCH = 1'b0;
            jumpDCH = 1'b0;
            pcDCH = 32'h00000000;
            pcplus4DCH = 32'h00000004;
            rdDCH = 5'b00000;
            rs1DCH = 5'b00000;
            rs2DCH = 5'b00000;
        end else begin
            alusignalDCH = alusignalD;
            op1DCH = op1D;
            op2DCH = op2D;
            immxDCH = immxD;
            jumpoffsetCH = jumpoffset;
            regwriteDCH = regwriteD;
            isimmediateDCH = isimmediateD;
            memwriteDCH = memwriteD;
            isloadDCH = isloadD;
            memreadDCH = memreadD;
            branchDCH = branchD;
            jumpDCH = jumpD;
            pcDCH = pcD;
            pcplus4DCH = pcplus4D;
            rdDCH = rdD;
            rs1DCH = rs1D;
            rs2DCH = rs2D;
        end
    end
endmodule
