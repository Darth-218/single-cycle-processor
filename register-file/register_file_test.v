module tb_register_file;

    reg         clk;
    reg         RegWrite;
    reg  [4:0]  rs1;
    reg  [4:0]  rs2;
    reg  [4:0]  rd;
    reg  [63:0] writeData;

    wire [63:0] readData1;
    wire [63:0] readData2;

    register_file dut (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
      	$display("Time\tRegWrite\trd\trs1\trs2\twriteData\treadData1\treadData2");
        
      	// Initialize
        clk = 0;
        RegWrite = 0;
        rs1 = 0;
        rs2 = 0;
        rd  = 0;
        writeData = 0;

        #10;
		


        // Test 1: Write 10 to x5
        RegWrite = 1;
        rd = 5;
        writeData = 64'd10;
        #10;
		$display("%0t\t%b\t\t%0d\t%0d\t%0d\t%0d\t\t-\t\t-",
                 $time, RegWrite, rd, rs1, rs2, writeData);

        // Read x5
        RegWrite = 0;
        rs1 = 5;
        #5;
		$display("%0t\t%b\t\t-\t%0d\t-\t-\t\t%0d\t\t-  (Expected: 10)",
         		$time, RegWrite, rs1, readData1);

        // Test 2: Write 25 to x3
        RegWrite = 1;
        rd = 3;
        writeData = 64'd25;
        #10;
		$display("%0t\t%b\t\t%0d\t-\t-\t%0d\t\t-\t\t-",
         		$time, RegWrite, rd, writeData);

        // Read x3 and x5
        RegWrite = 0;
        rs1 = 3;
        rs2 = 5;
        #5;
		$display("%0t\t%b\t\t-\t%0d\t%0d\t-\t\t%0d\t\t%0d  (Expected: 25, 10)",
         		$time, RegWrite, rs1, rs2, readData1, readData2);

        // Test 3: Try to write to x0
        RegWrite = 1;
        rd = 0;
        writeData = 64'd99;
        #10;
		$display("%0t\t%b\t\t%0d\t-\t-\t%0d\t\t-\t\t-  (Write to x0 ignored)",
                 $time, RegWrite, rd, writeData);

        // Read x0
        RegWrite = 0;
        rs1 = 0;
        #5;
		$display("%0t\t%b\t\t-\t%0d\t-\t-\t\t%0d\t\t-  (Expected: 0)",
         $time, RegWrite, rs1, readData1);

        $finish;
    end

endmodule

