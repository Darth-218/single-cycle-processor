module data_memory (
    input clock,
    input memwrite,
    input memread,
    input [64:0] address,
    input [64:0] writedata,
    output reg [64:0] readdata
);

  reg [31:0] memory[255];

  always @(posedge clock) begin
    if (memwrite) begin
      memory[address[9:2]] <= writedata;
    end
    if (memread) begin
      readdata <= memory[address[9:2]];
    end
  end
endmodule
