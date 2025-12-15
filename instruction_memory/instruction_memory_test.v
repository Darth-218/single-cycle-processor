module instruction_memory_test;

  reg  [63:0] addr;
  wire [31:0] instr;

  // Instantiate the instruction memory module
  instruction_memory IMEM (
      .address(addr),  // Connect addr in testbench to module
      .instruction(instr)  // Connect instr output to wire
  );

  initial begin
    addr = 0;
    #10 addr = 4;
    #10 addr = 8;
    #10 $finish;
  end

  initial begin
    $monitor("Time=%0t | Addr=%0d | Instr=0x%h", $time, addr, instr);
  end

endmodule

