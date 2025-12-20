`timescale 1ns / 1ps
module single_cycle_processor_test;

  // Clock and reset
  reg clk;
  reg reset;
  reg [31:0] out_pc;
  reg [31:0] out_instruction;
  reg out_reg_write;
  reg [4:0] out_rd_address;
  reg [31:0] out_write_data;

  // Instantiate CPU
  single_cycle_processor uut (
      .clock(clk),
      .reset(reset),
      .out_pc(out_pc),
      .out_instruction(out_instruction),
      .out_reg_write(out_reg_write),
      .out_rd_address(out_rd_address),
      .out_write_data(out_write_data)
  );

  // =========================
  // Clock generation (100 MHz)
  // =========================
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // =========================
  // Reset sequence
  // =========================
  initial begin
    reset = 1;
    #20;
    reset = 0;
  end

  // =========================
  // Simulation control
  // =========================
  initial begin
    $display("===== CPU TEST START =====");
    #500;
    $display("===== CPU TEST END =====");
    $finish;
  end

  // =========================
  // Execution tracing
  // =========================
  always @(posedge clk) begin
    if (!reset) begin
      $display("t=%0t | PC=%b | INSTR=%b", $time, uut.PC.pc_current, uut.IM.instruction);
    end
  end

  // =========================
  // Register write monitoring
  // =========================
  always @(posedge clk) begin
    if (!reset && uut.CU.reg_write) begin
      $display("  REG WRITE: x%0d = %h", uut.RF.rd_address, uut.RF.write_data);
    end
  end

endmodule
