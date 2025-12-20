module alu_test;

  reg  [63:0] rs1;
  reg  [63:0] rs2;
  reg  [ 3:0] operation;
  wire [63:0] alu_out;
  wire        zero;

  reg  [63:0] expected;

  // Instantiate the ALU
  alu dut (
      .rs1_data(rs1),
      .rs2_data(rs2),
      .alu_ctl(operation),
      .alu_out(alu_out),
      .zero(zero)
  );

  initial begin
    $display("Time\tRS1\t\t\tRS2\t\t\tOP\tALU_OUT\t\t\tExpected\t\tZERO");

    // Test ADD
    rs1       = 64'b0000_0000_0000_1010;  // 10
    rs2       = 64'b0000_0000_0001_0100;  // 20
    operation = 4'b0010;  // ADD
    expected  = 64'b0000_0000_0001_1110;  // 30
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test SUB
    rs1       = 64'b0000_0000_0001_0100;  // 20
    rs2       = 64'b0000_0000_0000_1010;  // 10
    operation = 4'b0110;  // SUB
    expected  = 64'b0000_0000_0000_1010;  // 10
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test AND
    rs1       = 64'b0000_0000_0000_1100;  // 12
    rs2       = 64'b0000_0000_0000_1010;  // 10
    operation = 4'b0000;  // AND
    expected  = 64'b0000_0000_0000_1000;  // 8
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test OR
    rs1       = 64'b0000_0000_0000_1100;  // 12
    rs2       = 64'b0000_0000_0000_0101;  // 5
    operation = 4'b0001;  // OR
    expected  = 64'b0000_0000_0000_1101;  // 13
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test XOR
    rs1       = 64'b0000_0000_0000_1100;  // 12
    rs2       = 64'b0000_0000_0000_1010;  // 10
    operation = 4'b0011;  // XOR
    expected  = 64'b0000_0000_0000_0110;  // 6
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test SLL
    rs1       = 64'b0000_0000_0000_0011;  // 3
    rs2       = 64'b0000_0000_0000_0001;  // 1
    operation = 4'b0100;  // SLL
    expected  = 64'b0000_0000_0000_0110;  // 6
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test SRL
    rs1       = 64'b0000_0000_0000_1000;  // 8
    rs2       = 64'b0000_0000_0000_0001;  // 1
    operation = 4'b0101;  // SRL
    expected  = 64'b0000_0000_0000_0100;  // 4
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    // Test SRA
    rs1       = 64'b1111_1111_1111_1000;  // -8
    rs2       = 64'b0000_0000_0000_0001;  // 1
    operation = 4'b1001;  // SRA
    expected  = 64'b1111_1111_1111_1100;  // -4
    #1;
    $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h", $time, rs1, rs2, operation, alu_out, expected, zero);

    $display("ALU test complete.");
    $finish;
  end

endmodule

