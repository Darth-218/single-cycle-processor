`timescale 1ns / 1ps

module register_file_test;

  reg         clock;
  reg         reg_write;
  reg  [ 4:0] rs1_address;
  reg  [ 4:0] rs2_address;
  reg  [ 4:0] rd_address;
  reg  [63:0] write_data;
  wire [63:0] rs1_data;
  wire [63:0] rs2_data;

  register_file dut (
      .clock(clock),
      .reg_write(reg_write),
      .rs1_address(rs1_address),
      .rs2_address(rs2_address),
      .rd_address(rd_address),
      .write_data(write_data),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );

  /* 10ns clock */
  initial clock = 0;
  always #5 clock = ~clock;

  task check; /* Compares actual vs expected */
    input [63:0] got;
    input [63:0] exp;
    input [127:0] msg;
    begin
      #1; // Wait 1 time unit for signals to stabilize
      if (got !== exp) begin
        $display("FAIL: %s | exp=%h got=%h", msg, exp, got);
        $fatal; // Stop simulation on failure
      end
    end
  endtask

  task write_reg;
    input [4:0] addr;
    input [63:0] data;
    begin
      rd_address = addr;
      write_data = data;
      reg_write  = 1;
      @(posedge clock);
      reg_write = 0;
    end
  endtask

  initial begin
    $display("Starting register_file tests...");

    /* defaults */
    reg_write   = 0;
    rs1_address = 0;
    rs2_address = 0;
    rd_address  = 0;
    write_data  = 0;

    /* -------------------------------------------------- */
    /* x0 always reads zero */
    rs1_address = 0;
    rs2_address = 0;
    check(rs1_data, 64'b0, "x0 rs1 read");
    check(rs2_data, 64'b0, "x0 rs2 read");

    /* -------------------------------------------------- */
    /* Write to x0 ignored */
    write_reg(5'd0, 64'hDEADBEEF);
    check(rs1_data, 64'b0, "x0 write ignored");

    /* -------------------------------------------------- */
    /* Write and read normal register */
    write_reg(5'd5, 64'h1111);
    rs1_address = 5'd5;
    check(rs1_data, 64'h1111, "write/read x5");

    /* -------------------------------------------------- */
    /* Write disabled */
    rd_address = 5'd6;
    write_data = 64'h2222;
    reg_write  = 0;
    @(posedge clock);

    rs1_address = 5'd6;
    check(rs1_data, 64'b0, "write disabled");

    /* -------------------------------------------------- */
    /* Overwrite register */
    write_reg(5'd5, 64'h3333);
    rs1_address = 5'd5;
    check(rs1_data, 64'h3333, "overwrite x5");

    /* -------------------------------------------------- */
    /* Two read ports */
    write_reg(5'd10, 64'hAAAA);
    write_reg(5'd11, 64'hBBBB);

    rs1_address = 5'd10;
    rs2_address = 5'd11;
    check(rs1_data, 64'hAAAA, "rs1 read");
    check(rs2_data, 64'hBBBB, "rs2 read");

    /* -------------------------------------------------- */
    /* Same register on both ports */
    rs1_address = 5'd10;
    rs2_address = 5'd10;
    check(rs1_data, 64'hAAAA, "same reg rs1");
    check(rs2_data, 64'hAAAA, "same reg rs2");

    /* -------------------------------------------------- */
    /* Highest register (x31) */
    write_reg(5'd31, 64'hFFFFFFFFFFFFFFFF);
    rs1_address = 5'd31;
    check(rs1_data, 64'hFFFFFFFFFFFFFFFF, "x31 read");

    /* -------------------------------------------------- */
    /* x0 forced back to zero every clock */
    @(posedge clock);
    rs1_address = 0;
    check(rs1_data, 64'b0, "x0 forced zero");

    $display("All register_file tests PASSED.");
    $finish;
  end

endmodule

