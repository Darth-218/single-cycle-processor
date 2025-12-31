`timescale 1ns / 1ps

module alu_test;

  reg  [63:0] rs1_data;
  reg  [63:0] rs2_data;
  reg  [ 3:0] alu_ctrl;
  wire [63:0] result;
  wire        zero;

  alu dut (
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .alu_ctrl(alu_ctrl),
      .result(result),
      .zero(zero)
  );

  task check;
    input [63:0] exp;
    begin
      #1;
      if (result !== exp) begin
        $display("FAIL ctrl=%b rs1=%h rs2=%h exp=%h got=%h", alu_ctrl, rs1_data, rs2_data, exp,
                 result);
        $fatal;
      end
      if (zero !== (exp == 64'b0)) begin
        $display("ZERO FLAG FAIL ctrl=%b result=%h zero=%b", alu_ctrl, result, zero);
        $fatal;
      end
    end
  endtask

  initial begin
    $display("Starting ALU tests...");

    /* ADD */
    alu_ctrl = 4'b0000;
    rs1_data = 64'd0;
    rs2_data = 64'd0;
    check(64'd0);
    rs1_data = 64'hFFFFFFFFFFFFFFFF;
    rs2_data = 64'd1;
    check(64'd0);
    rs1_data = 64'd5;
    rs2_data = 64'd10;
    check(64'd15);

    /* SUB */
    alu_ctrl = 4'b0001;
    rs1_data = 64'd10;
    rs2_data = 64'd10;
    check(64'd0);
    rs1_data = 64'd0;
    rs2_data = 64'd1;
    check(64'hFFFFFFFFFFFFFFFF);
    rs1_data = 64'd20;
    rs2_data = 64'd5;
    check(64'd15);

    /* AND */
    alu_ctrl = 4'b0010;
    rs1_data = 64'hFFFF0000FFFF0000;
    rs2_data = 64'h0F0F0F0F0F0F0F0F;
    check(64'h0F0F00000F0F0000);

    /* OR */
    alu_ctrl = 4'b0011;
    check(64'hFFFF0F0FFFFF0F0F);

    /* XOR */
    alu_ctrl = 4'b0100;
    check(64'hF0F00F0FF0F00F0F);

    /* SLT */
    alu_ctrl = 4'b0101;
    rs1_data = -64'sd1;
    rs2_data = 64'sd1;
    check(64'd1);
    rs1_data = 64'sd5;
    rs2_data = 64'sd5;
    check(64'd0);
    rs1_data = 64'sd10;
    rs2_data = -64'sd1;
    check(64'd0);

    /* SLL */
    alu_ctrl = 4'b0110;
    rs1_data = 64'h1;
    rs2_data = 64'd0;
    check(64'h1);
    rs1_data = 64'h1;
    rs2_data = 64'd63;
    check(64'h8000000000000000);

    /* SRL */
    alu_ctrl = 4'b0111;
    rs1_data = 64'h8000000000000000;
    rs2_data = 64'd63;
    check(64'h1);

    /* SRA */
    alu_ctrl = 4'b1000;
    rs1_data = -64'sd1;
    rs2_data = 64'd4;
    check(64'hFFFFFFFFFFFFFFFF);
    rs1_data = -64'sd8;
    rs2_data = 64'd2;
    check(-64'sd2);

    /* SLTU */
    alu_ctrl = 4'b1001;
    rs1_data = 64'hFFFFFFFFFFFFFFFF;
    rs2_data = 64'h0;
    check(64'd0);
    rs1_data = 64'h1;
    rs2_data = 64'h2;
    check(64'd1);

    /* DEFAULT */
    alu_ctrl = 4'b1111;
    rs1_data = 64'h1234;
    rs2_data = 64'h5678;
    check(64'd0);

    $display("All ALU tests PASSED.");
    $finish;
  end

endmodule

