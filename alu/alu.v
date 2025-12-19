module alu (
    // TODO: Change input names
    input wire [63:0] rs1_data,
    rs2_data,
    input wire [3:0] op,
    output reg [63:0] alu_out,
    output reg zero
);
  always @(*) begin
    case (op)
      4'b0000: alu_out = rs1_data + rs2_data;  // Addition
      4'b0001: alu_out = rs1_data - rs2_data;  // Subtraction
      4'b0010: alu_out = rs1_data & rs2_data;  // Bitwise AND
      4'b0011: alu_out = rs1_data | rs2_data;  // Bitwise OR
      4'b0100: alu_out = rs1_data ^ rs2_data;  // Bitwise XOR
      4'b0101: alu_out = ~(rs1_data | rs2_data);  // Bitwise NOR
      4'b0110: alu_out = rs1_data << 1;  // Logical left shift
      4'b0111: alu_out = rs1_data >> 1;  // Logical right shift
      4'b1000: alu_out = $signed(rs1_data) >>> 1;  // Arithmetic right shift
      4'b1001: alu_out = (rs1_data < rs2_data) ? 64'b1 : 64'b0;  // Set on less than
      4'b1010: alu_out = rs2_data;  // Pass B fix
      4'b1011: alu_out = rs1_data;  // Pass A
      4'b1100: alu_out = ~rs1_data;  // rs2_dataitwise NOT A
      4'b1101: alu_out = ~rs2_data;  // Bitwise NOT B fix
      4'b1110: alu_out = rs1_data * rs2_data;  // Multiplication
      4'b1111: alu_out = rs1_data / rs2_data;  // Division
      default: alu_out = 64'b0;  // Default case
    endcase

    // Set zero_flag
    if (alu_out == 64'b0) zero = 1'b1;
    else zero = 1'b0;
  end
endmodule
