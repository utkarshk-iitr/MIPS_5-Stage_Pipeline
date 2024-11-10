`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "ExecuteCycle.v"
`include "Memory_Cycle.v"
`include "Writeback_Cycle.v"
`include "Mux.v"
`include "PC.v"
`include "IM.v"
`include "Adder.v"
`include "Register_File.v"
`include "Sign_Extension.v"
`include "Control_Unit.v"
`include "Shift_Left_32Bit.v" 
`include "Concatenate_forJump.v"
`include "AluControl.v"
`include "Shift_Left.v"
`include "Alu.v"
`include "Data_Memory.v"
`include "Hazard.v"


module TopPipeline(
    input clk,
    input rst
);

    // Interconnecting wires
    wire [31:0] pcplus4D, instrD, pcD, pcE,pcplus4E, op1E, op2E, immxE, jumpoffset, aluresultM, branchtargetE;
    wire [31:0] pcplus4M, writedataM, pcplus4W, aluresultW, readdataW, resultW,readDataM;
    wire [4:0] rdW, rs1E, rs2E, rdE, rdM,rd;
    wire isbranchtakenE, regwriteE, isimmediateE, memwriteE, isloadE, memreadE, branchE, jumpE, regwriteM;
    wire memwriteM, isloadM, memreadM, regwriteW, isloadW,regwrite;
    wire [3:0] alusignalE;
    wire [1:0] forwardaE,forwardbE;

    // Instantiate Fetch stage
    Fetch fetch(
        .clk(clk),
        .rst(rst),
        .isbranchtakenE(isbranchtakenE),
        .branchtargetE(branchtargetE),
        .pcplus4D(pcplus4D),
        .instrD(instrD),
        .pcD(pcD)
    );

    // Instantiate Decode stage
    decode_cycle decode(
        .clk(clk),
        .rst(rst),
        .instrD(instrD),
        .pcD(pcD),
        .pcplus4D(pcplus4D),
        .regwriteW(regwriteW),
        .resultW(resultW),
        .rdW(rdW),
        .regwriteE(regwriteE),
        .isimmediateE(isimmediateE),
        .memwriteE(memwriteE),
        .isloadE(isloadE),
        .memreadE(memreadE),
        .branchE(branchE),
        .jumpE(jumpE),
        .alusignalE(alusignalE),
        .op1E(op1E),
        .op2E(op2E),
        .immxE(immxE),
        .jumpoffset(jumpoffset),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .pcE(pcE),
        .pcplus4E(pcplus4E)
    );

    // Instantiate Execute stage
    Execute execute(
        .clk(clk),
        .rst(rst),
        .regwriteE(regwriteE),
        .isimmediateE(isimmediateE),
        .memwriteE(memwriteE),
        .isloadE(isloadE),
        .memreadE(memreadE),
        .branchE(branchE),
        .jumpE(jumpE),
        .op1E(op1E),
        .op2E(op2E),
        .immxE(immxE),
        .jumpoffset(jumpoffset),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .pcE(pcE),
        .resultW(resultW),
        .readdataW(readdataW),
        .forwardaE(forwardaE),
        .forwardbE(forwardbE),
        .aluresultW(aluresultW),
        .pcplus4E(pcplus4E),
        .alusignalE(alusignalE),
        .isbranchtakenE(isbranchtakenE),
        .regwriteM(regwriteM),
        .memwriteM(memwriteM),
        .isloadM(isloadM),
        .memreadM(memreadM),
        .rdM(rdM),
        .pcplus4M(pcplus4M),
        .aluresultM(aluresultM),
        .branchtargetE(branchtargetE),
        .writedataM(writedataM)
    );

    // Instantiate Memory stage
    memory_cycle memory(
        .clock(clk),
        .rst(rst),
        .memreadM(memreadM),
        .memwriteM(memwriteM),
        .regwriteM(regwriteM),
        .isloadM(isloadM),
        .aluresultM(aluresultM),
        .rdM(rdM),
        .pcplus4M(pcplus4M),
        .writedataM(writedataM),
        .regwrite(regwrite),
        .isloadW(isloadW),
        .pcplus4W(pcplus4W),
        .aluresultW(aluresultW),
        .readdataW(readdataW),
        .rd(rd)
    );

    // Instantiate Writeback stage
    writeback_cycle writeback(
        .clk(clk),
        .rst(rst),
        .isloadW(isloadW),
        .rd(rd),
        .regwrite(regwrite),
        .pcplus4W(pcplus4W),
        .aluresultW(aluresultW),
        .readdataW(readdataW),
        .resultW(resultW),
        .regwriteW(regwriteW),
        .rdW(rdW)
    );

    //Instantiate Hazard module
    forwarding hazard(
        .rst(rst), 
        .regwriteM(regwriteM), 
        .regwrite(regwrite), 
        .rdM(rdM), 
        .rd(rd), 
        .rs1E(rs1E), 
        .rs2E(rs2E), 
        .isloadW(isloadW),
        .forwardaE(forwardaE), 
        .forwardbE(forwardbE)
    );

endmodule