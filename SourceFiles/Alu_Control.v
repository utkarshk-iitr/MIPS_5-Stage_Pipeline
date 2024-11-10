module ALUcontrol(funct, opcode, ALUop, ALUsignal);

    input [5:0] funct, opcode;
    input [1:0] ALUop;
    output reg [3:0] ALUsignal;

    // Defining parameters
    parameter add = 6'b100000;
    parameter addu = 6'b100001;
    parameter sub = 6'b100010;
    parameter subu = 6'b100011;
    parameter mul = 6'b011000;
    parameter mulu = 6'b011001;
    parameter div = 6'b011010;
    parameter divu = 6'b011011;
    parameter slt = 6'b101010;
    parameter sltu = 6'b101011;
    parameter and1 = 6'b100100;
    parameter or1 = 6'b100101;
    parameter nor1 = 6'b100111;
    parameter xor1 = 6'b101000;

    parameter addi = 6'b001000;
    parameter addiu = 6'b001001;
    parameter slti = 6'b001010;
    parameter sltiu = 6'b001011;
    parameter andi = 6'b001100;
    parameter ori = 6'b001101;
    parameter xori = 6'b001110;
    parameter lw = 6'b100011;
    parameter sw = 6'b101011;
    parameter beq = 6'b000100;
    parameter bne = 6'b000101;
    parameter blez = 6'b000110;
    parameter bgtz = 6'b000111;
    parameter bltz = 6'b000001;
    parameter bgez = 6'b000011;

    always @(*) begin

        case (ALUop)
            2'b10: case (funct)
                add: ALUsignal = 4'b0010;
                addu: ALUsignal = 4'b0010;
                sub: ALUsignal = 4'b0110;
                subu: ALUsignal = 4'b0110;
                mul: ALUsignal = 4'b1001;
                mulu: ALUsignal = 4'b1001;
                div: ALUsignal = 4'b1111;
                divu: ALUsignal = 4'b1111;
                slt: ALUsignal = 4'b0111;
                sltu: ALUsignal = 4'b0111;
                and1: ALUsignal = 4'b0000;
                or1: ALUsignal = 4'b0001;
                xor1: ALUsignal = 4'b1000;
                nor1: ALUsignal = 4'b1100;
            endcase

            2'b00: ALUsignal = 4'b0010; // Default for addi, lw, sw

            2'b11: case (opcode)
                slti: ALUsignal = 4'b0111;
                sltiu: ALUsignal = 4'b0111;
                andi: ALUsignal = 4'b0000;
                ori: ALUsignal = 4'b0001;
                xori: ALUsignal = 4'b1000;
            endcase

            2'b01: case (opcode)
                beq: ALUsignal = 4'b0101;
                bne: ALUsignal = 4'b1010;
                blez: ALUsignal = 4'b1011;
                bgtz: ALUsignal = 4'b0011;
                bltz: ALUsignal = 4'b0100;
                bgez: ALUsignal = 4'b1101;
            endcase
        endcase
        end
endmodule
