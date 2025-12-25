module instruction_memory (
    input  [63:0] address,
    output [31:0] instruction
);

  reg [31:0] memory[0:255];

  initial begin
    $readmemb("instructions.mem", memory);
  end

  assign instruction = memory[address[9:2]];
endmodule
