module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       branch,
    output reg       alu_src,
    output reg [3:0] alu_ctl
);

  localparam logic [6:0]
        OpRtype  = 7'b0110011,
        OpLoad   = 7'b0000011,
        OpStore  = 7'b0100011,
        OpBranch = 7'b1100011,
        OpItype  = 7'b0010011;

  localparam logic [3:0]
        ALUAnd = 4'b0000,
        ALUOr  = 4'b0001,
        ALUAdd = 4'b0010,
        ALUSub = 4'b0110,
        ALUSlt = 4'b0111;

  always @(*) begin
    // Defaults
    reg_write = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    mem_to_reg = 1'b0;
    branch    = 1'b0;
    alu_src   = 1'b0;
    alu_ctl   = ALUAdd;

    case (opcode)
      // R-type instructions
      OpRtype: begin
        reg_write = 1'b1;
        case (funct3)
          3'b000:  alu_ctl = (funct7 == 7'b0100000) ? ALUSub : ALUAdd;
          3'b111:  alu_ctl = ALUAnd;
          3'b110:  alu_ctl = ALUOr;
          3'b010:  alu_ctl = ALUSlt;
          default: alu_ctl = ALUAdd;
        endcase
      end

      // Load instructions
      OpLoad: begin
        reg_write = 1'b1;
        mem_read = 1'b1;
        mem_to_reg = 1'b1;
        alu_src = 1'b1;
        alu_ctl = ALUAdd;
      end

      // Store instructions
      OpStore: begin
        mem_write = 1'b1;
        alu_src   = 1'b1;
        alu_ctl   = ALUAdd;
      end

      // Branch instructions
      OpBranch: begin
        branch  = 1'b1;
        alu_ctl = ALUSub;
      end

      // I-type arithmetic instructions
      OpItype: begin
        reg_write = 1'b1;
        alu_src   = 1'b1;
        case (funct3)
          3'b000:  alu_ctl = ALUAdd;
          3'b111:  alu_ctl = ALUAnd;
          3'b110:  alu_ctl = ALUOr;
          3'b010:  alu_ctl = ALUSlt;
          default: alu_ctl = ALUAdd;
        endcase
      end

      default: begin
      end
    endcase
  end

endmodule

