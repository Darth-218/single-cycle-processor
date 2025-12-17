module control_unit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemToReg,
    output reg       Branch,
    output reg       ALUSrc,
    output reg [3:0] ALUctl
);

  // TODO: Understand
  localparam logic [6:0]
    OpRtype  = 7'b0110011,
    OpLoad   = 7'b0000011,
    OpStore  = 7'b0100011,
    OpBranch = 7'b1100011,
    OpItype  = 7'b0010011;

  localparam logic [3:0]
    ALUand = 4'b0000,
    ALUor  = 4'b0001,
    ALUadd = 4'b0010,
    ALUsub = 4'b0110,
    ALUslt = 4'b0111;

  always @(*) begin
    /* defaults */
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    ALUSrc   = 1'b0;
    ALUctl   = ALUadd;

    case (opcode)

      OpRtype: begin
        RegWrite = 1'b1;
        case (funct3)
          3'b000:  ALUctl = (funct7 == 7'b0100000) ? ALUsub : ALUadd;
          3'b111:  ALUctl = ALUand;
          3'b110:  ALUctl = ALUor;
          3'b010:  ALUctl = ALUslt;
          default: ALUctl = ALUadd;
        endcase
      end

      OpLoad: begin
        RegWrite = 1'b1;
        MemRead  = 1'b1;
        MemToReg = 1'b1;
        ALUSrc   = 1'b1;
        ALUctl   = ALUadd;
      end

      OpStore: begin
        MemWrite = 1'b1;
        ALUSrc   = 1'b1;
        ALUctl   = ALUadd;
      end

      OpBranch: begin
        Branch = 1'b1;
        ALUctl = ALUsub;
      end

      OpItype: begin
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        case (funct3)
          3'b000:  ALUctl = ALUadd;
          3'b111:  ALUctl = ALUand;
          3'b110:  ALUctl = ALUor;
          3'b010:  ALUctl = ALUslt;
          default: ALUctl = ALUadd;
        endcase
      end

      default: begin
      end

    endcase
  end

endmodule

