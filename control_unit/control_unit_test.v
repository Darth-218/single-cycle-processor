`timescale 1ns / 1ps

module control_and_alu_control_test;

  /* ---------------- Control Unit ---------------- */
  reg  [6:0] opcode;
  wire       reg_write;
  wire       mem_read;
  wire       mem_write;
  wire       mem_to_reg;
  wire       alu_src;
  wire [1:0] pc_src;
  wire [2:0] imm_type;
  wire [1:0] alu_op;

  control_unit cu (
      .opcode(opcode),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .alu_src(alu_src),
      .pc_src(pc_src),
      .imm_type(imm_type),
      .alu_op(alu_op)
  );

  /* ---------------- ALU Control ---------------- */
  reg  [2:0] funct3;
  reg  [6:0] funct7;
  wire [3:0] alu_ctrl;

  alu_control ac (
      .alu_op  (alu_op),
      .funct3  (funct3),
      .funct7  (funct7),
      .alu_ctrl(alu_ctrl)
  );

  task check;
    input cond;
    input [127:0] msg;
    begin
      if (!cond) begin
        $display("FAIL: %s", msg);
        $fatal;
      end
    end
  endtask

  initial begin
    $display("Starting control_unit + alu_control tests...");

    /* ---------------- R-type ---------------- */
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #1;
    check(reg_write && alu_op == 2'b10, "R-type control");
    check(alu_ctrl == 4'b0000, "ADD");

    funct7 = 7'b0100000;
    #1;
    check(alu_ctrl == 4'b0001, "SUB");

    funct3 = 3'b111;
    #1;
    check(alu_ctrl == 4'b0010, "AND");
    funct3 = 3'b110;
    #1;
    check(alu_ctrl == 4'b0011, "OR");
    funct3 = 3'b100;
    #1;
    check(alu_ctrl == 4'b0100, "XOR");
    funct3 = 3'b010;
    #1;
    check(alu_ctrl == 4'b0101, "SLT");
    funct3 = 3'b011;
    #1;
    check(alu_ctrl == 4'b1001, "SLTU");
    funct3 = 3'b001;
    #1;
    check(alu_ctrl == 4'b0110, "SLL");
    funct3 = 3'b101;
    funct7 = 7'b0000000;
    #1;
    check(alu_ctrl == 4'b0111, "SRL");
    funct7 = 7'b0100000;
    #1;
    check(alu_ctrl == 4'b1000, "SRA");

    /* ---------------- I-type ---------------- */
    opcode = 7'b0010011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #1;
    check(reg_write && alu_src && alu_op == 2'b11, "I-type control");
    check(alu_ctrl == 4'b0000, "ADDI");

    funct3 = 3'b111;
    #1;
    check(alu_ctrl == 4'b0010, "ANDI");
    funct3 = 3'b110;
    #1;
    check(alu_ctrl == 4'b0011, "ORI");
    funct3 = 3'b100;
    #1;
    check(alu_ctrl == 4'b0100, "XORI");
    funct3 = 3'b010;
    #1;
    check(alu_ctrl == 4'b0101, "SLTI");
    funct3 = 3'b011;
    #1;
    check(alu_ctrl == 4'b1001, "SLTIU");
    funct3 = 3'b001;
    #1;
    check(alu_ctrl == 4'b0110, "SLLI");
    funct3 = 3'b101;
    funct7 = 7'b0000000;
    #1;
    check(alu_ctrl == 4'b0111, "SRLI");
    funct7 = 7'b0100000;
    #1;
    check(alu_ctrl == 4'b1000, "SRAI");

    /* ---------------- LOAD ---------------- */
    opcode = 7'b0000011;
    #1;
    check(reg_write && mem_read && mem_to_reg && alu_src && alu_op == 2'b00, "LOAD control");

    /* ---------------- STORE ---------------- */
    opcode = 7'b0100011;
    #1;
    check(mem_write && alu_src && alu_op == 2'b00 && !reg_write, "STORE control");

    /* ---------------- BRANCH ---------------- */
    opcode = 7'b1100011;
    funct3 = 3'b000;
    #1;
    check(pc_src == 2'b01 && alu_op == 2'b01, "BRANCH control");
    check(alu_ctrl == 4'b0001, "BEQ/BNE");

    funct3 = 3'b100;
    #1;
    check(alu_ctrl == 4'b0101, "BLT/BGE");
    funct3 = 3'b110;
    #1;
    check(alu_ctrl == 4'b1001, "BLTU/BGEU");

    /* ---------------- JAL ---------------- */
    opcode = 7'b1101111;
    #1;
    check(reg_write && pc_src == 2'b10 && imm_type == 3'b100, "JAL control");

    /* ---------------- JALR ---------------- */
    opcode = 7'b1100111;
    #1;
    check(reg_write && alu_src && pc_src == 2'b10 && alu_op == 2'b00, "JALR control");

    /* ---------------- LUI ---------------- */
    opcode = 7'b0110111;
    #1;
    check(reg_write && alu_src && imm_type == 3'b011, "LUI control");

    /* ---------------- AUIPC ---------------- */
    opcode = 7'b0010111;
    #1;
    check(reg_write && alu_src && imm_type == 3'b011, "AUIPC control");

    /* ---------------- Default opcode ---------------- */
    opcode = 7'b1111111;
    #1;
    check(!reg_write && !mem_read && !mem_write && pc_src == 2'b00, "default control");

    $display("All control_unit + alu_control tests PASSED.");
    $finish;
  end

endmodule

