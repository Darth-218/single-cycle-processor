`timescale 1ns / 1ps

module program_counter_test;

  reg         clock;
  reg         reset;
  reg  [ 1:0] pc_src;
  reg         zero;
  reg  [63:0] imm;
  reg  [63:0] alu_result;
  wire [63:0] pc_current;

  program_counter dut (
      .clock(clock),
      .reset(reset),
      .pc_src(pc_src),
      .zero(zero),
      .imm(imm),
      .alu_result(alu_result),
      .pc_current(pc_current)
  );

  /* 10ns clock */
  initial clock = 0;
  always #5 clock = ~clock;

  task check_pc;
    input [63:0] exp;
    begin
      #1;
      if (pc_current !== exp) begin
        $display("FAIL pc_src=%b zero=%b imm=%h alu=%h exp=%h got=%h", pc_src, zero, imm,
                 alu_result, exp, pc_current);
        $fatal;
      end
    end
  endtask

  initial begin
    $display("Starting program_counter tests...");

    /* -------------------------------------------------- */
    /* Reset */
    reset = 1;
    pc_src = 0;
    zero = 0;
    imm = 0;
    alu_result = 0;
    #2;
    check_pc(64'b0);

    @(posedge clock);
    reset  = 0;

    /* -------------------------------------------------- */
    /* PC + 4 */
    pc_src = 2'b00;
    @(posedge clock);
    check_pc(64'd4);

    @(posedge clock);
    check_pc(64'd8);

    /* -------------------------------------------------- */
    /* Branch not taken (zero = 0) */
    pc_src = 2'b01;
    zero   = 0;
    imm    = 64'd16;
    @(posedge clock);
    check_pc(64'd12);  // 8 + 4

    /* -------------------------------------------------- */
    /* Branch taken (zero = 1) */
    zero = 1;
    imm  = 64'd20;
    @(posedge clock);
    check_pc(64'd32);  // 12 + 20

    /* -------------------------------------------------- */
    /* Branch with zero immediate */
    imm = 64'd0;
    @(posedge clock);
    check_pc(64'd32);

    /* -------------------------------------------------- */
    /* Branch with negative immediate */
    imm = -64'sd8;
    @(posedge clock);
    check_pc(64'd24);

    /* -------------------------------------------------- */
    /* Jump via ALU (pc_src = 10) */
    pc_src     = 2'b10;
    alu_result = 64'h1000;
    zero       = 1;  // should not matter
    imm        = 64'hFF;  // should not matter
    @(posedge clock);
    check_pc(64'h1000);

    /* -------------------------------------------------- */
    /* Jump followed by sequential */
    pc_src = 2'b00;
    @(posedge clock);
    check_pc(64'h1004);

    /* -------------------------------------------------- */
    /* Reset overrides everything */
    reset = 1;
    #2;
    check_pc(64'b0);
    reset = 0;

    @(posedge clock);
    check_pc(64'd4);

    $display("All program_counter tests PASSED.");
    $finish;
  end

endmodule

