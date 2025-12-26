module alu_control (
    input      [1:0] alu_op,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [3:0] alu_ctl
);

  // ALU operations
  localparam [3:0]
    AluAdd  = 4'b0010,
    AluSub  = 4'b0110,
    AluAnd  = 4'b0000,
    AluOr   = 4'b0001,
    AluXor  = 4'b0011,
    AluSll  = 4'b0100,
    AluSrl  = 4'b0101,
    AluSra  = 4'b1001,
    AluSlt  = 4'b0111,
    AluSltu = 4'b1000;

  always @(*) begin
    case (alu_op)
      2'b00: alu_ctl = AluAdd; // default add (load/store/auipc/lui/jalr)
      2'b01: alu_ctl = AluSub; // branch comparison
      2'b10: begin // R-type
        case (funct3)
          3'b000:  alu_ctl = (funct7 == 7'b0100000) ? AluSub : AluAdd;
          3'b111:  alu_ctl = AluAnd;
          3'b110:  alu_ctl = AluOr;
          3'b100:  alu_ctl = AluXor;
          3'b001:  alu_ctl = AluSll;
          3'b101:  alu_ctl = (funct7 == 7'b0100000) ? AluSra : AluSrl;
          3'b010:  alu_ctl = AluSlt;
          3'b011:  alu_ctl = AluSltu;
          default: alu_ctl = AluAdd;
        endcase
      end
      2'b11: begin // I-type ALU
        case (funct3)
          3'b000:  alu_ctl = AluAdd;  // ADDI
          3'b111:  alu_ctl = AluAnd;  // ANDI
          3'b110:  alu_ctl = AluOr;   // ORI
          3'b100:  alu_ctl = AluXor;  // XORI
          3'b001:  alu_ctl = AluSll;  // SLLI
          3'b101:  alu_ctl = (funct7 == 7'b0100000) ? AluSra : AluSrl;  // SRLI/SRAI
          3'b010:  alu_ctl = AluSlt;  // SLTI
          3'b011:  alu_ctl = AluSltu; // SLTIU
          default: alu_ctl = AluAdd;
        endcase
      end
      default: alu_ctl = AluAdd;
    endcase
  end
endmodule