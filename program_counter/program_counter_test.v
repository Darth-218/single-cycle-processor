module program_counter_test;

  reg         clock;
  reg         reset;
  reg         branch;
  reg         zero;
  reg  [63:0] imm;
  wire [63:0] pc_current;

  program_counter dut (
      .clock(clock),
      .reset(reset),
      .branch(branch),
      .zero(zero),
      .imm(imm),
      .pc_current(pc_current)
  );

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial begin
    $display("Time\tAddress\tBranch\tImmediate\tZero");

    reset  = 1;
    branch = 0;
    zero   = 0;
    imm    = 64'd0;

    #12;
    reset = 0;

    repeat (3) begin
      @(posedge clock);
      #1;
      $display("%0t\t%0d\t%0d\t%0d\t\t%0d", $time, pc_current, branch, imm, zero);
    end

    imm    = 64'd16;
    branch = 1;
    zero   = 0;

    @(posedge clock);
    #1;
    $display("%0t\t%0d\t%0d\t%0d\t\t%0d\t(branch not taken)", $time, pc_current, branch, imm, zero);

    zero = 1;

    @(posedge clock);
    #1;
    $display("%0t\t%0d\t%0d\t%0d\t\t%0d\t(branch taken)", $time, pc_current, branch, imm, zero);
    $finish;
  end

  always @(posedge clock) begin
    if (!reset && branch && zero) begin
      if (pc_current !== (dut.pc_current)) $display("ERROR: Branch PC mismatch");
    end
  end

endmodule

