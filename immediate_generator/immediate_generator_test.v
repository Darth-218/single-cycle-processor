module immediate_generator_test;

  reg  [31:0] instr;
  wire [63:0] imm;

  // Instantiate DUT
  immediate_generator dut (
      .instruction(instr),
      .imm(imm)
  );

  initial begin
    $display("Time\tInstruction(hex)\tImmediate(decimal)");

    // -------------------------------------------------
    // Test 1: I-type (addi x1, x0, 10)
    // opcode = 0010011
    // imm[11:0] = 10
    instr = 32'b000000001010_00000_000_00001_0010011;
    #5;
    $display("%0t\t%h\t\t%0d (Expected: 10)", $time, instr, imm);

    // -------------------------------------------------
    // Test 2: I-type (addi x1, x0, -5)
    // imm = -5 (two's complement)
    instr = 32'b111111111011_00000_000_00001_0010011;
    #5;
    $display("%0t\t%h\t\t%0d (Expected: -5)", $time, instr, $signed(imm));

    // -------------------------------------------------
    // Test 3: S-type (sd x3, 16(x0))
    // imm = 16
    instr = 32'b0000000_00011_00000_011_10000_0100011;
    #5;
    $display("%0t\t%h\t\t%0d (Expected: 16)", $time, instr, imm);

    // -------------------------------------------------
    // Test 4: B-type (beq x1, x2, 8)
    // imm = 8
    instr = 32'b0000000_00010_00001_000_0100_0_1100011;
    #5;
    $display("%0t\t%h\t\t%0d (Expected: 8)", $time, instr, imm);

    // -------------------------------------------------
    // Test 5: Invalid opcode
    instr = 32'hFFFFFFFF;
    #5;
    $display("%0t\t%h\t\t%0d (Expected: 0)", $time, instr, imm);

    $finish;
  end

endmodule
