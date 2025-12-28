module control_unit (
    input      [6:0] opcode,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       alu_src,     // 0=rs2, 1=imm
    output reg [1:0] pc_src,      // 00=PC+4, 01=branch, 10=JAL/JALR
    output reg [2:0] imm_type,    // I,S,B,U,J
    output reg [1:0] alu_op
);

  localparam [6:0]
    OP_R     = 7'b0110011,
    OP_I     = 7'b0010011,
    OP_LOAD  = 7'b0000011,
    OP_STORE = 7'b0100011,
    OP_BRANCH= 7'b1100011,
    OP_JAL   = 7'b1101111,
    OP_JALR  = 7'b1100111,
    OP_LUI   = 7'b0110111,
    OP_AUIPC = 7'b0010111;

  always @(*) begin
    reg_write  = 0;
    mem_read   = 0;
    mem_write  = 0;
    mem_to_reg = 0;
    alu_src    = 0;
    pc_src     = 2'b00;
    imm_type   = 3'b000;
    alu_op     = 2'b00;

    case (opcode)

      OP_R: begin
        reg_write = 1;
        alu_op    = 2'b10;
      end

      OP_I: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b000;
        alu_op    = 2'b11;
      end

      OP_LOAD: begin
        reg_write  = 1;
        mem_read   = 1;
        mem_to_reg = 1;
        alu_src    = 1;
        imm_type   = 3'b000;
        alu_op     = 2'b00;
      end

      OP_STORE: begin
        mem_write = 1;
        alu_src   = 1;
        imm_type  = 3'b001;
        alu_op    = 2'b00;
      end

      OP_BRANCH: begin
        pc_src   = 2'b01;
        imm_type = 3'b010;
        alu_op   = 2'b01;
      end

      OP_JAL: begin
        reg_write = 1;
        pc_src    = 2'b10;
        imm_type  = 3'b100;
      end

      OP_JALR: begin
        reg_write = 1;
        alu_src   = 1;
        pc_src    = 2'b10;
        imm_type  = 3'b000;
        alu_op    = 2'b00;
      end

      OP_LUI: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b011;
        alu_op    = 2'b00;   // ALU passes imm
      end

      OP_AUIPC: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b011;
        alu_op    = 2'b00;
      end

    endcase
  end
endmodule

