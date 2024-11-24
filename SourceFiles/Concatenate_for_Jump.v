module ConcatForJump(
    input [3:0] pcUpperBits,
    input [27:0] shiftedAddress,
    output reg [31:0] result
);

    always @(*) begin
        // Concatenate to form the full 32-bit address
        result = {pcUpperBits, shiftedAddress};
    end
endmodule
