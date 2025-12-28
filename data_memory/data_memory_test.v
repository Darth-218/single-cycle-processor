module data_memory_test;

  reg         clk;
  reg         we;
  reg         re;
  reg  [63:0] addr;
  reg  [63:0] wdata;
  wire [63:0] rdata;

  reg  [63:0] expected;

  data_memory DM (
      .clock(clk),
      .mem_write(we),
      .mem_read(re),
      .address(addr),
      .write_data(wdata),
      .read_data(rdata)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("Time\tAddr\tWE\tRE\tWData\t\t\tRData\t\t\tExpected");

    we = 1;
    re = 0;

    addr = 0;
    wdata = 64'hAAAA_BBBB_CCCC_DDDD;
    expected = wdata;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    addr = 4;
    wdata = 64'h1234_5678_9ABC_DEF0;
    expected = wdata;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    addr = 8;
    wdata = 64'hDEAD_BEEF_0000_1111;
    expected = wdata;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    we = 0;
    re = 1;

    addr = 0;
    expected = 64'hAAAA_BBBB_CCCC_DDDD;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    addr = 4;
    expected = 64'h1234_5678_9ABC_DEF0;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    addr = 8;
    expected = 64'hDEAD_BEEF_0000_1111;
    #10;
    $display("%0t\t%0d\t%h\t%h\t%h\t%h\t%h", $time, addr, we, re, wdata, rdata, expected);

    $finish;
  end

endmodule

