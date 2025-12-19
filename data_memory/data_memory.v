module data_memory (
    input clock,
    input mem_write,
    input mem_read,
    input [64:0] address,
    input [64:0] write_data,
    output reg [64:0] read_data
);

  reg [31:0] memory[255];

  always @(posedge clock) begin
    if (mem_write) begin
      memory[address[9:2]] <= write_data;
    end
    if (mem_read) begin
      read_data <= memory[address[9:2]];
    end
  end
endmodule
