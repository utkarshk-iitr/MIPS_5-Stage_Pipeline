module PC (clk,rst,input1,out);
    input clk,rst;
    input [31:0] input1;
    output  reg [31:0] out;
    always @(posedge clk)
    begin
        if(rst==1'b1) begin
            out<={32{1'b0}};
        end else begin
            out<= input1;
        end
    end
endmodule