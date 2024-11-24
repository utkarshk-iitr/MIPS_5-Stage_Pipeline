module ALU(a, b, alusignal, result, hi, lo);

    input signed [31:0] a, b;
    input [4:0] alusignal;
    output reg [31:0] result;
    output reg [31:0] hi, lo;

    wire [63:0] p;

    // Multiplication result assigned to `p`
    assign p = a * b;

    initial begin
        result = 32'b0;
        hi = 32'b0;
        lo = 32'b0;
    end

    // Combinational logic block
    always @(*) begin
        // Default values to avoid latches
        result = 32'b0;

        case (alusignal)
            5'b10100: result = a << b;        //Logical shift left
            5'b10110: result = a >> b;        //Logical shift right
            5'b10101: result = a >>> b;        //Arithmetic shift right
            5'b00010: result = a + b;              // Addition
            5'b00110: result = a - b;              // Subtraction
            5'b01001: begin                        // Multiplication
                hi = p[63:32];                    // Upper 32 bits
                lo = p[31:0];                     // Lower 32 bits
            end
            5'b01111: begin                        // Division
                if (b != 0) begin                 // Check for division by zero
                    hi = a % b;                   // Remainder
                    lo = a / b;                   // Quotient
                end else begin
                    hi = 32'b0;
                    lo = 32'b0;                   // Division by zero case
                end
            end
            5'b10000: result = hi;
            5'b10001: result = lo;
            5'b10010: result = hi;
            5'b10011: result = lo;
            5'b00111: result = (a < b) ? 1 : 0;    // Set less than
            5'b00000: result = a & b;              // Bitwise AND
            5'b00001: result = a | b;              // Bitwise OR
            5'b01100: result = ~(a ^ b);           // Bitwise NOR
            5'b01000: result = a ^ b;              // Bitwise XOR
            5'b00100: result = (a < 0) ? 1 : 0;    // Check if `a` is negative
            5'b00011: result = (a > 0) ? 1 : 0;    // Check if `a` is positive
            5'b00101: result = (a == b) ? 1 : 0;   // Equality
            5'b01010: result = (a == b) ? 0 : 1;   // Inequality
            5'b01011: result = (a <= b) ? 1 : 0;   // Less than or equal
            5'b01101: result = (a >= 0) ? 1 : 0;   // Greater than or equal to zero
        endcase
    end

endmodule
