module control_unit_test;

  reg [31:0] instr;
  reg [7:0] instr_type;  // single character for type: 'R', 'I', 'S', 'B'

  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [6:0] funct7;

  wire reg_write;
  wire mem_read;
  wire mem_write;
  wire mem_to_reg;
  wire branch;
  wire alu_src;
  wire [3:0] alu_ctl;
  wire [1:0] pc_src;
  wire [2:0] imm_type;
  wire [1:0] alu_op;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];

  // Main control unit
  control_unit dut_main (
      .opcode(opcode),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .branch(branch),
      .alu_src(alu_src),
      .pc_src(pc_src),
      .imm_type(imm_type),
      .alu_op(alu_op)
  );

  // ALU control unit
  alu_control dut_alu (
      .alu_op  (alu_op),
      .funct3  (funct3),
      .funct7  (funct7),
      .alu_ctrl(alu_ctl)
  );

  initial begin
    $display(
        "Type\tInstr\t\tRegWrite\tMemRead\tMemWrite\tMemToReg\tBranch\tALUSrc\tALUctl\tPCSrc\tImmType");

    /* R-type ADD */
    instr = 32'b0000000_00000_00000_000_00000_0110011;
    instr_type = "R";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    /* R-type SUB */
    instr = 32'b0100000_00000_00000_000_00000_0110011;
    instr_type = "R";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    /* LOAD */
    instr = 32'b000000000000_00000_010_00000_0000011;
    instr_type = "I";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    /* STORE */
    instr = 32'b0000000_00000_00000_010_00000_0100011;
    instr_type = "S";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    /* BRANCH (BEQ) */
    instr = 32'b0000000_00000_00000_000_00000_1100011;
    instr_type = "B";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    /* ADDI */
    instr = 32'b000000000000_00000_000_00000_0010011;
    instr_type = "I";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t%b\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl, pc_src, imm_type);

    $finish;
  end

endmodule
