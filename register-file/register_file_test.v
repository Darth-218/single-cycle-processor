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

        // Read x5
        RegWrite = 0;
        rs1 = 5;
        #5;

        // Test 2: Write 25 to x3
        RegWrite = 1;
        rd = 3;
        writeData = 64'd25;
        #10;

        // Read x3 and x5
        RegWrite = 0;
        rs1 = 3;
        rs2 = 5;
        #5;

        // Test 3: Try to write to x0
        RegWrite = 1;
        rd = 0;
        writeData = 64'd99;
        #10;

        // Read x0
        RegWrite = 0;
        rs1 = 0;
        #5;

        $finish;
    end

endmodule

