module alu (
    input      [63:0] rs1_data,
    input      [63:0] rs2_data,
    input      [ 3:0] alu_ctrl,
    output reg [63:0] result,
    output reg        zero
);

  always @(*) begin
    case (alu_ctrl)
      4'b0000: result = rs1_data + rs2_data;  // ADD
      4'b0001: result = rs1_data - rs2_data;  // SUB
      4'b0010: result = rs1_data & rs2_data;  // AND
      4'b0011: result = rs1_data | rs2_data;  // OR
      4'b0100: result = rs1_data ^ rs2_data;  // XOR
      4'b0101: result = ($signed(rs1_data) < $signed(rs2_data));  // SLT
      4'b0110: result = rs1_data << rs2_data[5:0];  // SLL
      4'b0111: result = rs1_data >> rs2_data[5:0];  // SRL
      4'b1000: result = $signed(rs1_data) >>> rs2_data[5:0];  // SRA
      4'b1001: result = (rs1_data < rs2_data);  // SLTU
      default: result = 64'b0;
    endcase

    zero = (result == 64'b0);
  end
endmodule

