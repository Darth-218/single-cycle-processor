// Code your design here

module ControlUnit (
  input  [6:0] opcode, 
  input  [2:0] funct3, // supposed to be in between [14:12] in the 32 bits
  input  [6:0] funct7, // supposed to be in between [31:25] in the 32 bits
  output reg       RegWrite,
  output reg       MemRead,
  output reg       MemWrite,
  output reg       MemToReg,
  output reg       Branch,
  output reg       ALUSrc,
  output reg [3:0] ALUctl
);

  localparam [6:0] // here we are the opcodes 
    OP_RTYPE   = 7'b0110011,
    OP_LOAD    = 7'b0000011,
    OP_STORE   = 7'b0100011,
    OP_BRANCH  = 7'b1100011,
    OP_ITYPEALU= 7'b0010011;

  localparam [3:0] // here are the ALUctl ops
    ALU_AND = 4'b0000,
    ALU_OR  = 4'b0001,
    ALU_ADD = 4'b0010,
    ALU_SUB = 4'b0110,
    ALU_SLT = 4'b0111,
    ALU_NOR = 4'b1100;

  always @(*) begin // this is the default stage 
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    ALUSrc   = 1'b0;
    ALUctl   = ALU_ADD;

    case (opcode) 
      OP_RTYPE: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b0; // here its zero because we are going to use register not imeddiate value.
        case (funct3)
          3'b000: ALUctl = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD; // in ADD and SUB they have the same 000 bits in func3 so we did a bolean to check in fumc7 if its 0100000 which is SUB then its SUB else its ADD
          3'b111: ALUctl = ALU_AND;
          3'b110: ALUctl = ALU_OR;
          3'b010: ALUctl = ALU_SLT;
          default: ALUctl = ALU_ADD;
        endcase
      end

      OP_LOAD: begin
        RegWrite = 1'b1;
        MemRead  = 1'b1;
        MemToReg = 1'b1;
        ALUSrc   = 1'b1;
        ALUctl   = ALU_ADD;
      end

      OP_STORE: begin
        MemWrite = 1'b1;
        ALUSrc   = 1'b1;
        ALUctl   = ALU_ADD;
      end

      OP_BRANCH: begin
        Branch   = 1'b1;
        ALUSrc   = 1'b0; 
        ALUctl   = ALU_SUB; 
      end

      OP_ITYPEALU: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b1; // its 1 because its using immediate value bec. its I type
        case (funct3)
          3'b000: ALUctl = ALU_ADD;
          3'b111: ALUctl = ALU_AND;
          3'b110: ALUctl = ALU_OR;
          3'b010: ALUctl = ALU_SLT;
          default: ALUctl = ALU_ADD;
        endcase
      end

      default: begin
      end
    endcase
  end

endmodule