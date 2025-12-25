module control_unit (
    input      [6:0] opcode,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       branch,
    output reg       alu_src,
    output reg [3:0] alu_ctl,
    output reg [1:0] pc_src,      // 00=PC+4, 01=branch, 10=JAL/JALR
    output reg [2:0] imm_type     // 000=I,001=S,010=B,011=U,100=J
);

  // Opcodes
  localparam [6:0]
    OpRtype  = 7'b0110011,
    OpItype  = 7'b0010011,
    OpLoad   = 7'b0000011,
    OpStore  = 7'b0100011,
    OpBranch = 7'b1100011,
    OpJal    = 7'b1101111,
    OpJalr   = 7'b1100111,
    OpLui    = 7'b0110111,
    OpAuipc  = 7'b0010111;

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
    // Default values
    reg_write  = 0;
    mem_read   = 0;
    mem_write  = 0;
    mem_to_reg = 0;
    branch     = 0;
    alu_src    = 0;
    alu_ctl    = AluAdd;
    pc_src     = 2'b00;
    imm_type   = 3'b000;

    case (opcode)
      // R-type
      OpRtype: begin
        reg_write = 1;
        alu_src   = 0;
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

      // I-type ALU
      OpItype: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b000;  // I-type immediate
        case (funct3)
          3'b000:  alu_ctl = AluAdd;  // ADDI
          3'b111:  alu_ctl = AluAnd;  // ANDI
          3'b110:  alu_ctl = AluOr;  // ORI
          3'b100:  alu_ctl = AluXor;  // XORI
          3'b001:  alu_ctl = AluSll;  // SLLI
          3'b101:  alu_ctl = (funct7 == 7'b0100000) ? AluSra : AluSrl;  // SRLI/SRAI
          3'b010:  alu_ctl = AluSlt;  // SLTI
          3'b011:  alu_ctl = AluSltu;  // SLTIU
          default: alu_ctl = AluAdd;
        endcase
      end

      // Load
      OpLoad: begin
        reg_write = 1;
        mem_read = 1;
        mem_to_reg = 1;
        alu_src = 1;
        alu_ctl = AluAdd;  // address calculation
        imm_type = 3'b000;  // I-type
      end

      // Store
      OpStore: begin
        mem_write = 1;
        alu_src   = 1;
        alu_ctl   = AluAdd;  // address calculation
        imm_type  = 3'b001;  // S-type
      end

      // Branch
      OpBranch: begin
        branch   = 1;
        alu_src  = 0;
        alu_ctl  = AluSub;  // for BEQ/BNE/BLT/etc
        pc_src   = 2'b01;
        imm_type = 3'b010;  // B-type
      end

      // JAL
      OpJal: begin
        reg_write = 1;
        pc_src    = 2'b10;
        imm_type  = 3'b100; // J-type
      end

      // JALR
      OpJalr: begin
        reg_write = 1;
        alu_src   = 1;
        pc_src    = 2'b10;
        imm_type  = 3'b000; // I-type
        alu_ctl   = AluAdd;
      end

      // LUI
      OpLui: begin
        reg_write = 1;
        alu_src   = 1;
        alu_ctl   = AluAdd;
        imm_type  = 3'b011;  // U-type
      end

      // AUIPC
      OpAuipc: begin
        reg_write = 1;
        alu_src   = 1;
        alu_ctl   = AluAdd;
        imm_type  = 3'b011;  // U-type
      end

      default: begin
        reg_write  = 0;
        mem_read   = 0;
        mem_write  = 0;
        mem_to_reg = 0;
        branch     = 0;
        alu_src    = 0;
        alu_ctl    = AluAdd;
        pc_src     = 2'b00;
        imm_type   = 3'b000;
      end
    endcase
  end

endmodule

