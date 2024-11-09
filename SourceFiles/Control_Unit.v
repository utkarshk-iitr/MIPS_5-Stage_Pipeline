module Control_Unit(
    input [5:0] opcode,
    input [31:0] IR,
    output reg [1:0] AluOp,
    output reg RegDest,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg Branch,
    output reg Jump
);

    parameter addi  = 6'b001000;
    parameter addiu = 6'b001001;
    parameter slti  = 6'b001010;
    parameter sltiu = 6'b001011;
    parameter andi  = 6'b001100;
    parameter ori   = 6'b001101;
    parameter xori  = 6'b001110;
    parameter lw    = 6'b100011;
    parameter sw    = 6'b101011;
    parameter beq   = 6'b000100;
    parameter bne   = 6'b000101;
    parameter blez  = 6'b000110;
    parameter bgtz  = 6'b000111;
    parameter bltz  = 6'b000001;
    parameter bgez  = 6'b000011;  
    parameter Rtype = 6'b000000;
    parameter j     = 6'b000010;

    always @(*) begin
        if (IR == 32'h00000000) begin
            AluOp    <= 2'b00;  
            RegDest  <= 1'b0;
            RegWrite <= 1'b0;
            ALUSrc   <= 1'b0;
            MemRead  <= 1'b0;
            MemWrite <= 1'b0;
            MemToReg <= 1'b0;
            Branch   <= 1'b0;
            Jump     <= 1'b0;
        end else begin
            case (opcode)
                Rtype: begin
                    AluOp    <= 2'b10;
                    RegDest  <= 1'b1;
                    RegWrite <= 1'b1;
                    ALUSrc   <= 1'b0;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
                lw: begin
                    AluOp    <= 2'b00;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b1;
                    ALUSrc   <= 1'b1;
                    MemRead  <= 1'b1;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b1;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
                sw: begin
                    AluOp    <= 2'b00;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b0;
                    ALUSrc   <= 1'b1;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b1;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
                addi, addiu: begin
                    AluOp    <= 2'b00;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b1;
                    ALUSrc   <= 1'b1;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
                slti, sltiu, andi, ori, xori: begin
                    AluOp    <= 2'b11;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b1;
                    ALUSrc   <= 1'b1;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
                beq, bne, blez, bgtz, bltz, bgez: begin
                    AluOp    <= 2'b01;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b0;
                    ALUSrc   <= 1'b0;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b1;
                    Jump     <= 1'b0;
                end
                j: begin
                    AluOp    <= 2'b00;  
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b0;
                    ALUSrc   <= 1'b0;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b1;
                end
                default: begin
                    AluOp    <= 2'b00;
                    RegDest  <= 1'b0;
                    RegWrite <= 1'b0;
                    ALUSrc   <= 1'b0;
                    MemRead  <= 1'b0;
                    MemWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch   <= 1'b0;
                    Jump     <= 1'b0;
                end
            endcase
        end
    end
endmodule
