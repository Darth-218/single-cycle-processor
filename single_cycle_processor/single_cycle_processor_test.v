`timescale 1ns / 1ps

module single_cycle_processor_test;

  reg clock;
  reg reset;

  single_cycle_processor cpu (
      .clock(clock),
      .reset(reset)
  );

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial begin
    reset = 1;
    repeat (20) @(posedge clock);
    reset = 0;

    forever begin
      @(posedge clock);
      if (cpu.IM.instruction == 32'h00000000) begin
        $display("Halt instruction reached.");
        $finish;
      end
    end
  end

  initial begin
    $dumpfile("single_cycle_processor.vcd");
    $dumpvars(0, single_cycle_processor_test);
  end

endmodule







