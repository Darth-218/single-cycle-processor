`timescale 1ns / 1ps

module single_cycle_processor_test;

  reg clock;
  reg reset;

  // Instantiate DUT
  single_cycle_processor dut (
      .clock(clock),
      .reset(reset),
  );

  // Clock generation: 10 ns period
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Test sequence
  initial begin
    reset = 1;
    repeat (2) @(posedge clock);
    reset = 0;

    // Run until a halt instruction is detected
    forever begin
      @(posedge clock);
      if (out_instruction == 32'h00000000) begin
        $display("Halt instruction reached at PC=0x%08h", out_pc);
        $finish;
      end
    end
  end

  // Waveform dump
  initial begin
    $dumpfile("single_cycle_processor.vcd");
    $dumpvars(0, single_cycle_processor_test);
  end

endmodule







