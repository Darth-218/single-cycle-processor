`timescale 1ns / 1ps

module instruction_memory_test;

  reg  [63:0] address;
  wire [31:0] instruction;

  instruction_memory dut (
      .address(address),
      .instruction(instruction)
  );

  task check;
    input [31:0] exp;
    input [127:0] msg;
    begin
      #1;
      if (instruction !== exp) begin
        $display("FAIL: %s", msg);
        $display("  address     = %h", address);
        $display("  exp         = %b", exp);
        $display("  got         = %b", instruction);
        $fatal;
      end
    end
  endtask

  initial begin
    $display("Starting instruction_memory tests...");

    /* -------------------------------------------------- */
    /* Address 0 */
    address = 64'h0;
    check(32'b00000000000000000000000000010011, "fetch instruction 0");

    /* -------------------------------------------------- */
    /* Word-aligned addresses */
    address = 64'h4;
    check(32'b00000000000100000000000000010011, "fetch instruction 1");

    address = 64'h8;
    check(32'b00000000001000000000000000010011, "fetch instruction 2");

    address = 64'hC;
    check(32'b00000000001100000000000000010011, "fetch instruction 3");

    /* -------------------------------------------------- */
    /* Unaligned address (should ignore [1:0]) */
    address = 64'h5;
    check(32'b00000000000100000000000000010011, "unaligned address handled");

    /* -------------------------------------------------- */
    /* Highest valid address (255 << 2) */
    address = 64'h3FC;
    #1;
    if (^instruction === 1'bX) begin
      $display("WARNING: highest address uninitialized (expected if mem file shorter)");
    end else begin
      $display("Highest address contains: %b", instruction);
    end

    /* -------------------------------------------------- */
    /* Stability check */
    address = 64'h0;
    #1;
    if (instruction !== 32'b00000000000000000000000000010011) $fatal("instruction unstable");

    #5;
    if (instruction !== 32'b00000000000000000000000000010011)
      $fatal("instruction changed without address change");

    $display("All instruction_memory tests PASSED.");
    $finish;
  end

endmodule

