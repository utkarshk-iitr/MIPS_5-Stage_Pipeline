module DMemBank (
  input wire memread,
  input wire memwrite,
  input wire [31:0] address,
  input wire [31:0] writedata,
  output reg [31:0] readdata
);

  reg [31:0] mem_bank [0:127];
  
  wire [6:0] addr_index = address[6:0];
  wire [31:0] o1;

  integer i;
  initial begin
    for (i = 0; i < 128; i = i + 1) begin
      mem_bank[i] = i * 100;
    end
  end

  always @(*) begin
    if (memread) begin
      readdata = mem_bank[addr_index]; 
    end 
    
    if (memwrite) begin
      mem_bank[addr_index] = writedata;
    end
  end

  assign o1 = mem_bank[11];
endmodule