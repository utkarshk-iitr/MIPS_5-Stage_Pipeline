module forwarding(
    input rst, 
    input regwriteM, 
    input regwriteW, 
    input [4:0] rdM, 
    input [4:0] rdW, 
    input [4:0] rs1E, 
    input [4:0] rs2E, 
    output [1:0] forwardaE, 
    output [1:0] forwardbE
);

  // Compute forwardaE using assign statements
  assign forwardaE = (rst == 1'b1) ? 2'b00 : 
                     (regwriteM == 1'b1 && rdM != 5'b00000 && rdM == rs1E) ? 2'b10 : 
                     (regwriteW == 1'b1 && rdW != 5'b00000 && rdW == rs1E) ? 2'b01 : 
                     2'b00;

  // Compute forwardbE using assign statements
  assign forwardbE = (rst == 1'b1) ? 2'b00 : 
                     (regwriteM == 1'b1 && rdM != 5'b00000 && rdM == rs2E) ? 2'b10 : 
                     (regwriteW == 1'b1 && rdW != 5'b00000 && rdW == rs2E) ? 2'b01 : 
                     2'b00;

endmodule
