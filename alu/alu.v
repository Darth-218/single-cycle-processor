module alu (
    input      [63:0] rs1_data,
    input      [63:0] rs2_data,
    input      [ 3:0] alu_ctl,
    output reg [63:0] alu_out,
    output reg        zero
);

  always @(*) begin
    case (alu_ctl)
      4'b0010: alu_out = rs1_data + rs2_data;  // ADD / ADDI
      4'b0110: alu_out = rs1_data - rs2_data;  // SUB
      4'b0000: alu_out = rs1_data & rs2_data;  // AND / ANDI
      4'b0001: alu_out = rs1_data | rs2_data;  // OR / ORI
      4'b0011: alu_out = rs1_data ^ rs2_data;  // XOR / XORI
      4'b0100: alu_out = rs1_data << rs2_data[5:0];  // SLL / SLLI
      4'b0101: alu_out = rs1_data >> rs2_data[5:0];  // SRL / SRLI
      4'b1001: alu_out = $signed(rs1_data) >>> rs2_data[5:0];  // SRA / SRAI
      4'b0111: alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 64'b1 : 64'b0;  // SLT / SLTI
      4'b1000: alu_out = (rs1_data < rs2_data) ? 64'b1 : 64'b0;  // SLTU / SLTIU
      default: alu_out = 64'b0;
    endcase

    zero = (alu_out == 64'b0) ? 1'b1 : 1'b0;
  end

endmodule

