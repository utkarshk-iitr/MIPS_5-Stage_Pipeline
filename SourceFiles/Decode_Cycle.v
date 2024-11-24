module decode_cycle(
    input clk,
    input rst,
    input flush,
    input [31:0] instrD,        // Instruction
    input [31:0] pcD,           // Program Counter
    input [31:0] pcplus4D,      // Program Counter + 4 for branch/jump
    input regwriteW,            // Write-back control signal        
    input [31:0] resultW,       // Write-back result data
    input [4:0] rdW,
    output regwriteE, isimmediateE, memwriteE, isloadE, memreadE, branchE, jumpE,  // Control signals for execution
    output [4:0] alusignalE,
    output [31:0] op1E, op2E, immxE, jumpoffset, // Register values, extended immediate, and jump offset
    output [4:0] rdE, rs1E, rs2E,                // Register addresses
    output [31:0] pcE, pcplus4E                  // Program Counter and PC+4        
);

    // Declare intermediate wires and registers for storing control signals and data
    wire [1:0] aluopD;
    wire regdestD, regwriteD, isimmediateD, memreadD, memwriteD, isloadD, branchD, jumpD;
    wire [31:0] op1D, op2D, immxD;
    wire [4:0] rs1D, rs2D;
    wire [27:0] shiftedJumpOffset;  // Shifted jump offset
    wire [31:0] fullJumpOffset;     // Final jump offset after concatenation
    wire [4:0] alusignalD;

    reg regwriteD_r, isimmediateD_r, memwriteD_r, isloadD_r, memreadD_r, branchD_r, jumpD_r;
    reg [31:0] op1_r, op2_r, immx_r;
    reg [4:0] rd_r, rs1_r, rs2_r;
    reg [31:0] pc_r, pcplus4_r;
    reg [4:0] alusignal_r;
    reg [31:0] jumpoffset_r;

    // Control Unit instantiation
    Control_Unit control_unit(
        .opcode(instrD[31:26]),   // MIPS opcode field
        .IR(instrD),
        .AluOp(aluopD),
        .RegDest(regdestD),
        .RegWrite(regwriteD),
        .ALUSrc(isimmediateD),
        .MemRead(memreadD),
        .MemWrite(memwriteD),
        .MemToReg(isloadD),
        .Branch(branchD),
        .Jump(jumpD)
    );

    // Register File instantiation
    Reg_File register_file(
        .rst(rst),
        .isWB(regwriteW),
        .read_reg1(instrD[25:21]),   // RS1
        .read_reg2(instrD[20:16]),   // RS2
        .op1(op1D),
        .op2(op2D),
        .write_reg(rdW), // Write-back destination register
        .write_data(resultW)      // Write-back data
    );

    // Sign Extension module instantiation
    signExt sign_extender(
        .inData(instrD[15:0]),
        .outData(immxD)
    );

    // Shift left the jump immediate by 2 bits
    ShiftLeftForJump jump_shift(
        .inData(instrD[25:0]),
        .outData(shiftedJumpOffset)
    );

    // Concatenate PC upper bits and shifted offset for full jump address
    ConcatForJump jump_concat(
        .pcUpperBits(pcplus4D[31:28]),
        .shiftedAddress(shiftedJumpOffset),
        .result(fullJumpOffset)
    );

    // ALU Control instantiation
    ALUcontrol Alu_control(
        .funct(instrD[5:0]),
        .opcode(instrD[31:26]),
        .ALUop(aluopD),
        .ALUsignal(alusignalD)
    );

    // Pipeline registers: Store control and data signals at every clock cycle
    always @(posedge clk ) begin
        if (rst || flush) begin
            alusignal_r     <= 5'b00000;
            regwriteD_r <= 1'b0;
            isimmediateD_r <= 1'b0;
            memwriteD_r <= 1'b0;
            isloadD_r   <= 1'b0;
            memreadD_r  <= 1'b0;
            branchD_r   <= 1'b0;
            jumpD_r     <= 1'b0;
            op1_r       <= 32'b0;
            op2_r       <= 32'b0;
            immx_r      <= 32'b0;
            rd_r        <= 5'b00000;
            pc_r        <= 32'b0;
            pcplus4_r   <= 32'b0;
            rs1_r       <= 5'b0;
            rs2_r       <= 5'b0;
            jumpoffset_r <= 32'h00000000;

        end else begin
            alusignal_r     <= alusignalD;
            regwriteD_r <= regwriteD;
            isimmediateD_r <= isimmediateD;
            memwriteD_r <= memwriteD;
            isloadD_r   <= isloadD;
            memreadD_r  <= memreadD;
            branchD_r   <= branchD;
            jumpD_r     <= jumpD;
            op1_r       <= op1D;
            op2_r       <= op2D;
            immx_r      <= immxD;
            rd_r        <= (regdestD) ? instrD[15:11] : instrD[20:16]; // Destination reg based on RegDest
            pc_r        <= pcD;
            pcplus4_r   <= pcplus4D;
            rs1_r       <= instrD[25:21];
            rs2_r       <= instrD[20:16];
            jumpoffset_r <= fullJumpOffset;
            if (alusignalD == 5'b10100 || alusignalD == 5'b10101 || alusignalD == 5'b10110) begin
                op2_r <= instrD[10:6];
            end
        end
    end

    // Output assignments to pass values to the next stage
    assign alusignalE     = alusignal_r;
    assign regwriteE      = regwriteD_r;
    assign isimmediateE   = isimmediateD_r;
    assign memwriteE      = memwriteD_r;
    assign isloadE        = isloadD_r;
    assign memreadE       = memreadD_r;
    assign branchE        = branchD_r;
    assign jumpE          = jumpD_r;
    assign op1E           = op1_r;
    assign op2E           = op2_r;
    assign immxE          = immx_r;
    assign rdE            = rd_r;
    assign pcE            = pc_r;
    assign pcplus4E       = pcplus4_r;
    assign rs1E           = rs1_r;
    assign rs2E           = rs2_r;
    assign jumpoffset     = jumpoffset_r;  

endmodule
