module alu(
    input wire [63:0] A, B,
    input wire [3:0] op,
    output reg [63:0] ALUOut,
    output reg  zero_flag
);
    always @(*) begin
        case(op)
            4'b0000: ALUOut = A + B;               // Addition
            4'b0001: ALUOut = A - B;               // Subtraction
            4'b0010: ALUOut = A & B;               // Bitwise AND
            4'b0011: ALUOut = A | B;               // Bitwise OR
            4'b0100: ALUOut = A ^ B;               // Bitwise XOR
            4'b0101: ALUOut = ~(A | B);            // Bitwise NOR
            4'b0110: ALUOut = A << 1;              // Logical left shift
            4'b0111: ALUOut = A >> 1;              // Logical right shift
            4'b1000: ALUOut = $signed(A) >>> 1;    // Arithmetic right shift
            4'b1001: ALUOut = (A < B) ? 64'b1 : 64'b0; // Set on less than
            4'b1010: ALUOut = B;                   // Pass B fix
            4'b1011: ALUOut = A;                   // Pass A
            4'b1100: ALUOut = ~A;                  // Bitwise NOT A
            4'b1101: ALUOut = ~B;                  // Bitwise NOT B fix
            4'b1110: ALUOut = A * B;               // Multiplication
            4'b1111: ALUOut = A / B;               // Division
            default: ALUOut = 64'b0;               // Default case
        endcase
        
        // Set zero_flag
        if (ALUOut == 64'b0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
    end
endmodule
