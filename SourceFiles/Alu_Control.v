module ALUcontrol(funct, opcode, ALUop, ALUsignal);

    input [5:0] funct, opcode;
    input [1:0] ALUop;
    output reg [4:0] ALUsignal;

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
    parameter mfhi = 6'b011100;
    parameter mflo = 6'b011101;
    parameter dfhi = 6'b011110;
    parameter dflo = 6'b011111;
    parameter lsl = 6'b101100;
    parameter asr = 6'b101101;
    parameter lsr = 6'b101110;


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
                add: ALUsignal = 5'b00010;
                addu: ALUsignal = 5'b00010;
                sub: ALUsignal = 5'b00110;
                subu: ALUsignal = 5'b00110;
                mul: ALUsignal = 5'b01001;
                mulu: ALUsignal = 5'b01001;
                div: ALUsignal = 5'b01111;
                divu: ALUsignal = 5'b01111;
                slt: ALUsignal = 5'b00111;
                sltu: ALUsignal = 5'b00111;
                and1: ALUsignal = 5'b00000;
                or1: ALUsignal = 5'b00001;
                xor1: ALUsignal = 5'b01000;
                nor1: ALUsignal = 5'b01100;
                mfhi: ALUsignal = 5'b10000;
                mflo: ALUsignal = 5'b10001;
                dfhi: ALUsignal = 5'b10010;
                dflo: ALUsignal = 5'b10011;
                lsl: ALUsignal = 5'b10100;
                asr: ALUsignal = 5'b10101;
                lsr: ALUsignal = 5'b10110;
            endcase

            2'b00: ALUsignal = 5'b00010; // Default for addi, lw, sw

            2'b11: case (opcode)
                slti: ALUsignal = 5'b00111;
                sltiu: ALUsignal = 5'b00111;
                andi: ALUsignal = 5'b00000;
                ori: ALUsignal = 5'b00001;
                xori: ALUsignal = 5'b01000;
            endcase

            2'b01: case (opcode)
                beq: ALUsignal = 5'b00101;
                bne: ALUsignal = 5'b01010;
                blez: ALUsignal = 5'b01011;
                bgtz: ALUsignal = 5'b00011;
                bltz: ALUsignal = 5'b00100;
                bgez: ALUsignal = 5'b01101;
            endcase
        endcase
        end
endmodule
