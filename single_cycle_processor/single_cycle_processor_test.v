`timescale 1ns / 1ps

module single_cycle_processor_test;

  // Clock and reset
  reg         clock;
  reg         reset;

  // DUT outputs
  wire [31:0] out_pc;
  wire [31:0] out_instruction;
  wire        out_reg_write;
  wire [ 4:0] out_rd_address;
  wire [31:0] out_write_data;

  // Instantiate DUT
  single_cycle_processor dut (
      .clock(clock),
      .reset(reset),
      .out_pc(out_pc),
      .out_instruction(out_instruction),
      .out_reg_write(out_reg_write),
      .out_rd_address(out_rd_address),
      .out_write_data(out_write_data)
  );

  // Clock generation: 10 ns period
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Test sequence
  initial begin
    // Initialize
    reset = 1;

    // Hold reset for a few cycles
    repeat (2) @(posedge clock);
    reset = 0;

    // Run processor for N cycles
    repeat (20) @(posedge clock);

    $display("Simulation finished.");
    $finish;
  end

  // Monitor architectural state every cycle
  always @(posedge clock) begin
    if (!reset) begin
      $display("PC=0x%08h | INST=0x%08h | REG_WRITE=%b | RD=%0d | WD=0x%08h", out_pc,
               out_instruction, out_reg_write, out_rd_address, out_write_data);
    end
  end

  // Optional waveform dump
  initial begin
    $dumpfile("single_cycle_processor.vcd");
    $dumpvars(0, single_cycle_processor_test);
  end

endmodule



