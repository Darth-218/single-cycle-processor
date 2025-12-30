`timescale 1ns / 1ps

module data_memory_test;

  reg         clock;
  reg         mem_write;
  reg         mem_read;
  reg  [63:0] address;
  reg  [63:0] write_data;
  wire [63:0] read_data;

  data_memory dut (
      .clock(clock),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .address(address),
      .write_data(write_data),
      .read_data(read_data)
  );

  /* clock: 10ns period */
  initial clock = 0;
  always #5 clock = ~clock;

  task check_read;
    input [63:0] exp;
    begin
      #1;
      if (read_data !== exp) begin
        $display("FAIL addr=%h exp=%h got=%h", address, exp, read_data);
        $fatal;
      end
    end
  endtask

  task write_word;
    input [63:0] addr;
    input [63:0] data;
    begin
      address    = addr;
      write_data = data;
      mem_write  = 1;
      mem_read   = 0;
      @(posedge clock);
      mem_write = 0;
    end
  endtask

  initial begin
    $display("Starting data_memory tests...");

    mem_write  = 0;
    mem_read   = 0;
    address    = 0;
    write_data = 0;

    /* -------------------------------------------------- */
    /* Write then read (basic) */
    write_word(64'h0, 64'hDEADBEEFCAFEBABE);
    mem_read = 1;
    check_read(64'hDEADBEEFCAFEBABE);

    /* -------------------------------------------------- */
    /* Lowest address */
    write_word(64'h0, 64'h1111);
    mem_read = 1;
    check_read(64'h1111);

    /* -------------------------------------------------- */
    /* Highest address (255) */
    write_word(64'h3FC, 64'h2222);  // 255 << 2
    address  = 64'h3FC;
    mem_read = 1;
    check_read(64'h2222);

    /* -------------------------------------------------- */
    /* Overwrite existing data */
    write_word(64'h3FC, 64'h3333);
    mem_read = 1;
    check_read(64'h3333);

    /* -------------------------------------------------- */
    /* Read disabled */
    mem_read = 0;
    #1;
    if (read_data !== 64'b0) begin
      $display("FAIL read disabled exp=0 got=%h", read_data);
      $fatal;
    end

    /* -------------------------------------------------- */
    /* Write disabled */
    address    = 64'h40;
    write_data = 64'hAAAA;
    mem_write  = 0;
    @(posedge clock);

    mem_read = 1;
    check_read(64'b0);  // never written

    /* -------------------------------------------------- */
    /* Multiple addresses */
    write_word(64'h10, 64'h100);
    write_word(64'h20, 64'h200);
    write_word(64'h30, 64'h300);

    address  = 64'h10;
    mem_read = 1;
    check_read(64'h100);
    address  = 64'h20;
    mem_read = 1;
    check_read(64'h200);
    address  = 64'h30;
    mem_read = 1;
    check_read(64'h300);

    /* -------------------------------------------------- */
    /* Back-to-back writes */
    write_word(64'h80, 64'hAAAA);
    write_word(64'h80, 64'hBBBB);
    mem_read = 1;
    address  = 64'h80;
    check_read(64'hBBBB);

    /* -------------------------------------------------- */
    /* Read during write (old value until clock edge) */
    write_word(64'hC0, 64'h1111);
    address    = 64'hC0;
    write_data = 64'h2222;
    mem_write  = 1;
    mem_read   = 1;
    #1;
    check_read(64'h1111);  // old data
    @(posedge clock);
    mem_write = 0;
    check_read(64'h2222);

    /* -------------------------------------------------- */
    /* All-ones data */
    write_word(64'h100, 64'hFFFFFFFFFFFFFFFF);
    mem_read = 1;
    address  = 64'h100;
    check_read(64'hFFFFFFFFFFFFFFFF);

    /* -------------------------------------------------- */
    /* Zero data */
    write_word(64'h140, 64'h0);
    mem_read = 1;
    address  = 64'h140;
    check_read(64'h0);

    $display("All data_memory tests PASSED.");
    $finish;
  end

endmodule

