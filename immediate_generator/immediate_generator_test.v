`timescale 1ns / 1ps

module immediate_generator_test;

  reg  [31:0] instruction;
  reg  [ 2:0] imm_type;
  wire [63:0] imm;

  immediate_generator dut (
      .instruction(instruction),
      .imm_type(imm_type),
      .imm(imm)
  );

  task check;
    input [63:0] exp;
    input [127:0] msg;
    begin
      #1;
      if (imm !== exp) begin
        $display("FAIL: %s", msg);
        $display("  instruction = %h", instruction);
        $display("  imm_type    = %b", imm_type);
        $display("  exp         = %h", exp);
        $display("  got         = %h", imm);
        $fatal;
      end
    end
  endtask

  initial begin
    $display("Starting immediate_generator tests...");

    /* -------------------------------------------------- */
    /* I-type positive */
    imm_type    = 3'b000;
    instruction = 32'h00001013; // imm = 1
    check(64'd1, "I-type positive");

    /* I-type negative */
    instruction = 32'hFFF01013;  // imm = -1
    check(-64'sd1, "I-type negative");

    /* -------------------------------------------------- */
    /* S-type positive */
    imm_type    = 3'b001;
    instruction = 32'b0000000_00010_00001_010_00101_0100011; // imm = 5
    check(64'd5, "S-type positive");

    /* S-type negative */
    instruction = 32'b1111111_00010_00001_010_11011_0100011;  // imm = -5
    check(-64'sd5, "S-type negative");

    /* -------------------------------------------------- */
    /* B-type positive */
    imm_type    = 3'b010;
    instruction = 32'b0_000001_00010_00001_000_0010_0_1100011; // imm = +4
    check(64'd4, "B-type positive");

    /* B-type negative */
    instruction = 32'b1_111110_00010_00001_000_1110_1_1100011;  // imm = -4
    check(-64'sd4, "B-type negative");

    /* -------------------------------------------------- */
    /* U-type positive */
    imm_type    = 3'b011;
    instruction = 32'h00012037; // imm = 0x00012000
    check(64'h0000000000012000, "U-type positive");

    /* U-type negative */
    instruction = 32'hFFF12037;  // sign bit set
    check(64'hFFFFFFFFFFF12000, "U-type negative");

    /* -------------------------------------------------- */
    /* J-type positive */
    imm_type    = 3'b100;
    instruction = 32'b0_0000001000_0_0000000001_1101111; // imm = +2048
    check(64'd2048, "J-type positive");

    /* J-type negative */
    instruction = 32'b1_1111110111_1_1111111111_1101111;  // imm = -2048
    check(-64'sd2048, "J-type negative");

    /* -------------------------------------------------- */
    /* Default */
    imm_type    = 3'b111;
    instruction = 32'hFFFFFFFF;
    check(64'b0, "default case");

    $display("All immediate_generator tests PASSED.");
    $finish;
  end

endmodule

