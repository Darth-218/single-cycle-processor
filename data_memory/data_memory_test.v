module data_memory_test;

  reg clk;
  reg we;
  reg re;
  reg [31:0] addr;
  reg [31:0] wdata;
  wire [31:0] rdata;

  data_memory DMEM (
      .clock(clk),
      .memwrite(we),
      .memread(re),
      .address(addr),
      .writedata(wdata),
      .readdata(rdata)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("Starting Data Memory Test");

    we = 1;
    re = 0;

    addr = 0;
    wdata = 32'hAAAA_BBBB;
    #10 addr = 4;
    wdata = 32'h1234_5678;
    #10 addr = 8;
    wdata = 32'hDEAD_BEEF;

    we = 0;
    re = 1;

    wdata = 32'h0;
    addr = 0;
    #10 addr = 4;
    #10 addr = 8;

    #10 $finish;
  end

  initial begin
    $monitor("Time: %0t\nAddress: %0d\nMemWrite: %b\nMemRead: %b\nData: 0x%h\nRData: 0x%h\n",
             $time, addr, we, re, wdata, rdata);
  end

endmodule

