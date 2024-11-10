module forwarding(
    input rst, 
    input regwriteM, 
    input regwrite, 
    input isloadW,
    input [4:0] rdM, 
    input [4:0] rd, 
    input [4:0] rs1E, 
    input [4:0] rs2E, 
    output [1:0] forwardaE, 
    output [1:0] forwardbE
);
  // Compute forwardaE using assign statements
  assign forwardaE = (rst == 1'b1) ? 2'b00 : 
                      (regwrite == 1'b1 && rd != 5'b00000 && rd == rs1E && isloadW == 1'b0) ? 2'b01 :
                      (regwriteM == 1'b1 && rdM != 5'b00000 && rdM == rs1E) ? 2'b10 : 
                     (regwrite == 1'b1 && rd != 5'b00000 && rd == rs1E && isloadW == 1'b1) ? 2'b11 : 
                     2'b00;

  // Compute forwardbE using assign statements
  assign forwardbE = (rst == 1'b1) ? 2'b00 : 
                      (regwrite == 1'b1 && rd != 5'b00000 && rd == rs2E && isloadW == 1'b0) ? 2'b01 :
                      (regwriteM == 1'b1 && rdM != 5'b00000 && rdM == rs2E) ? 2'b10 : 
                     (regwrite == 1'b1 && rd != 5'b00000 && rd == rs2E && isloadW == 1'b1) ? 2'b11 : 
                     2'b00;

endmodule
