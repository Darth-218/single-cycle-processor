module instruction_memory_test;

  reg  [63:0] addr;
  wire [31:0] instr;

  instruction_memory IM (
      .address(addr),
      .instruction(instr)
  );

  initial begin
    $display("Time\tAddress\tInstruction");
    addr = 0;
    #10 addr = 4;
    #10 addr = 8;
    #10 addr = 12;
    #10 $finish;
  end

  initial begin
    $monitor("%0t\t%0d\t%b", $time, addr, instr);
  end

endmodule

