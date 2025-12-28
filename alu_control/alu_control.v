module alu_control (
    input      [1:0] alu_op,
    input      [2:0] funct3,
    input            funct7,
    output reg [3:0] alu_ctrl
);

  always @(*) begin
    case (alu_op)

      // ADD (loads, stores, jumps)
      2'b00: alu_ctrl = 4'b0000;

      // Branch
      2'b01: begin
        case (funct3)
          3'b000:  alu_ctrl = 4'b0001;  // BEQ
          3'b001:  alu_ctrl = 4'b0001;  // BNE
          3'b100:  alu_ctrl = 4'b0101;  // BLT
          3'b101:  alu_ctrl = 4'b0101;  // BGE
          3'b110:  alu_ctrl = 4'b1001;  // BLTU
          3'b111:  alu_ctrl = 4'b1001;  // BGEU
          default: alu_ctrl = 4'b0000;
        endcase
      end

      // R-type
      2'b10: begin
        case (funct3)
          3'b000:  alu_ctrl = funct7 ? 4'b0001 : 4'b0000;
          3'b111:  alu_ctrl = 4'b0010;
          3'b110:  alu_ctrl = 4'b0011;
          3'b100:  alu_ctrl = 4'b0100;
          3'b010:  alu_ctrl = 4'b0101;
          3'b011:  alu_ctrl = 4'b1001;
          3'b001:  alu_ctrl = 4'b0110;
          3'b101:  alu_ctrl = funct7 ? 4'b1000 : 4'b0111;
          default: alu_ctrl = 4'b0000;
        endcase
      end

      // I-type
      2'b11: begin
        case (funct3)
          3'b000:  alu_ctrl = 4'b0000;
          3'b111:  alu_ctrl = 4'b0010;
          3'b110:  alu_ctrl = 4'b0011;
          3'b100:  alu_ctrl = 4'b0100;
          3'b010:  alu_ctrl = 4'b0101;
          3'b011:  alu_ctrl = 4'b1001;
          3'b001:  alu_ctrl = 4'b0110;
          3'b101:  alu_ctrl = funct7 ? 4'b1000 : 4'b0111;
          default: alu_ctrl = 4'b0000;
        endcase
      end

      default: alu_ctrl = 4'b0000;
    endcase
  end
endmodule

