module data_memory (
    input clock,
    input mem_write,
    input mem_read,
    input [63:0] address,
    input [63:0] write_data,
    output [63:0] read_data
);

  reg [63:0] memory[0:255];

  always @(posedge clock) begin
    if (mem_write) begin
      memory[address[9:2]] <= write_data;
    end
  end

  assign read_data = mem_read ? memory[address[9:2]] : 64'b0;

endmodule
