module alu_test;
    reg [3:0]  ALUctl;
    reg [63:0] A;
    reg [63:0] B;
    wire [63:0] ALUOut;
    wire  Zero;

    // Using named port connections for clarity and safety
    alu dut (A, B, ALUctl, ALUOut, Zero);

    initial begin
        $display("Testing 64-bit Simple ALU");
        $display("===========================================");
      
        // Test 1: ADD operation
        ALUctl = 4'b0000;
        A = 64'h0000_0000_0000_0001;
        B = 64'h0000_0000_0000_0002;
        #1;
        $display("Test 1 - ADD: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000003 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 2: SUB operation
        ALUctl = 4'b0001;
        A = 64'h0000_0000_0000_0005;
        B = 64'h0000_0000_0000_0002;
        #1;
        $display("Test 2 - SUB: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000003 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 3: AND operation
        ALUctl = 4'b0010;
        A = 64'h0000_0000_0000_000F;
        B = 64'h0000_0000_0000_0003;
        #1;
        $display("Test 3 - AND: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000003 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 4: OR operation
        ALUctl = 4'b0011;
        A = 64'h0000_0000_0000_0001;
        B = 64'h0000_0000_0000_0002;
        #1;
        $display("Test 4 - OR:  A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000003 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 5: XOR operation
        ALUctl = 4'b0100;
        A = 64'h0000_0000_0000_0007;
        B = 64'h0000_0000_0000_0005;
        #1;
        $display("Test 5 - XOR: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000002 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 6: NOR operation
        ALUctl = 4'b0101;
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0000;
        #1;
        $display("Test 6 - NOR: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=FFFFFFFFFFFFFFFF Zero=0)", A, B, ALUOut, Zero);
        
        // Test 7: Left shift
        ALUctl = 4'b0110;
        A = 64'h0000_0000_0000_0001;
        B = 64'h0000_0000_0000_0000;
        #1;
        $display("Test 7 - LSHIFT: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000002 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 8: Right shift logical
        ALUctl = 4'b0111;
        A = 64'h0000_0000_0000_0004;
        B = 64'h0000_0000_0000_0000;
        #1;
        $display("Test 8 - RSHIFT LOGICAL: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000002 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 9: Set on less than (true)
        ALUctl = 4'b1001;
        A = 64'h0000_0000_0000_0001;
        B = 64'h0000_0000_0000_0002;
        #1;
        $display("Test 9 - SLT (true): A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000001 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 10: Set on less than (false)
        ALUctl = 4'b1001;
        A = 64'h0000_0000_0000_0005;
        B = 64'h0000_0000_0000_0002;
        #1;
        $display("Test 10 - SLT (false): A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000000 Zero=1)", A, B, ALUOut, Zero);
        
        // Test 11: Pass B
        ALUctl = 4'b1010;
        A = 64'h0000_0000_0000_1111;
        B = 64'h0000_0000_0000_2222;
        #1;
        $display("Test 11 - PASS B: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000002222 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 12: Pass A
        ALUctl = 4'b1011;
        A = 64'h0000_0000_0000_3333;
        B = 64'h0000_0000_0000_4444;
        #1;
        $display("Test 12 - PASS A: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000003333 Zero=0)", A, B, ALUOut, Zero);
        
        // Test 13: NOT A
        ALUctl = 4'b1100;
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0000;
        #1;
        $display("Test 13 - NOT A: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=FFFFFFFFFFFFFFFF Zero=0)", A, B, ALUOut, Zero);
        
        // Test 14: NOT B
        ALUctl = 4'b1101;
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0000;
        #1;
        $display("Test 14 - NOT B: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=FFFFFFFFFFFFFFFF Zero=0)", A, B, ALUOut, Zero);
        
        // Test 15: Multiplication
        ALUctl = 4'b1110;
        A = 64'h0000_0000_0000_0003;
        B = 64'h0000_0000_0000_0004;
        #1;
        $display("Test 15 - MULT: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=000000000000000C Zero=0)", A, B, ALUOut, Zero);
        
        // Test 16: Division
        ALUctl = 4'b1111;
        A = 64'h0000_0000_0000_000C;
        B = 64'h0000_0000_0000_0003;
        #1;
        $display("Test 16 - DIV: A=%h B=%h ALUOut=%h Zero=%b (expected: ALUOut=0000000000000004 Zero=0)", A, B, ALUOut, Zero);
        
        $display("===========================================");
        $display("Testing completed.");
        $finish;
    end
endmodule