module ALU(a, b, alusignal, result, hi, lo);

    input signed [31:0] a, b;
    input [3:0] alusignal;
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
            4'b0010: result = a + b;              // Addition
            4'b0110: result = a - b;              // Subtraction
            4'b1001: begin                        // Multiplication
                hi = p[63:32];                    // Upper 32 bits
                lo = p[31:0];                     // Lower 32 bits
            end
            4'b1111: begin                        // Division
                if (b != 0) begin                 // Check for division by zero
                    hi = a % b;                   // Remainder
                    lo = a / b;                   // Quotient
                end else begin
                    hi = 32'b0;
                    lo = 32'b0;                   // Division by zero case
                end
            end
            4'b0111: result = (a < b) ? 1 : 0;    // Set less than
            4'b0000: result = a & b;              // Bitwise AND
            4'b0001: result = a | b;              // Bitwise OR
            4'b1100: result = ~(a ^ b);           // Bitwise NOR
            4'b1000: result = a ^ b;              // Bitwise XOR
            4'b0100: result = (a < 0) ? 1 : 0;    // Check if `a` is negative
            4'b0011: result = (a > 0) ? 1 : 0;    // Check if `a` is positive
            4'b0101: result = (a == b) ? 1 : 0;   // Equality
            4'b1010: result = (a == b) ? 0 : 1;   // Inequality
            4'b1011: result = (a <= b) ? 1 : 0;   // Less than or equal
            4'b1101: result = (a >= 0) ? 1 : 0;   // Greater than or equal to zero
        endcase
    end

endmodule
