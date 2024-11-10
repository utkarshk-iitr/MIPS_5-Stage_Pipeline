module Reg_File(
    
    input isWB,
    input rst,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] op1,
    output [31:0] op2
);

    reg [31:0] reg_array [31:0];
    wire [31:0] o1, o6, o5;
    integer i;

    initial begin
    for (i = 0; i < 32; i = i + 1) begin
      reg_array[i] = 0;
    end
        reg_array[0] = 32'h00000000;
        reg_array[1] = 4;
        reg_array[2] = 5;
        reg_array[3] = 7;
        reg_array[5] = 1;
        reg_array[4] = 8;
    end

    always @(*) begin
        if (isWB & write_reg!=5'h00) begin
            reg_array[write_reg] <= write_data;
        end
    end

    assign op1 = (rst==1'b1) ? 32'd0 : reg_array[read_reg1];
    assign op2 = (rst==1'b1) ? 32'd0 : reg_array[read_reg2];
    assign o1 = reg_array[1];
    assign o6 = reg_array[6];
    assign o5 = reg_array[5];

endmodule
