module main_control (
    input      [6:0] opcode,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       branch,
    output reg       alu_src,
    output reg [1:0] pc_src,      // 00=PC+4, 01=branch, 10=JAL/JALR
    output reg [2:0] imm_type,    // 000=I,001=S,010=B,011=U,100=J
    output reg [1:0] alu_op       // control signal for ALU control unit
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

  always @(*) begin
    // Default values
    reg_write  = 0;
    mem_read   = 0;
    mem_write  = 0;
    mem_to_reg = 0;
    branch     = 0;
    alu_src    = 0;
    pc_src     = 2'b00;
    imm_type   = 3'b000;
    alu_op     = 2'b00; // default ALU add

    case (opcode)
      // R-type
      OpRtype: begin
        reg_write = 1;
        alu_src   = 0;
        alu_op    = 2'b10; // R-type ALU operation
      end

      // I-type ALU
      OpItype: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b000;  // I-type immediate
        alu_op    = 2'b11;   // I-type ALU operation
      end

      // Load
      OpLoad: begin
        reg_write  = 1;
        mem_read   = 1;
        mem_to_reg = 1;
        alu_src    = 1;
        imm_type   = 3'b000;  // I-type
        alu_op     = 2'b00;   // address calculation
      end

      // Store
      OpStore: begin
        mem_write = 1;
        alu_src   = 1;
        imm_type  = 3'b001;  // S-type
        alu_op    = 2'b00;   // address calculation
      end

      // Branch
      OpBranch: begin
        branch   = 1;
        alu_src  = 0;
        pc_src   = 2'b01;
        imm_type = 3'b010;  // B-type
        alu_op   = 2'b01;   // for BEQ/BNE/BLT/etc
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
        alu_op    = 2'b00;  // add
      end

      // LUI
      OpLui: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b011;  // U-type
        alu_op    = 2'b00;   // add
      end

      // AUIPC
      OpAuipc: begin
        reg_write = 1;
        alu_src   = 1;
        imm_type  = 3'b011;  // U-type
        alu_op    = 2'b00;   // add
      end
    endcase
  end
endmodule