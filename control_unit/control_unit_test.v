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

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];

  control_unit dut (
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .branch(branch),
      .alu_src(alu_src),
      .alu_ctl(alu_ctl)
  );

  initial begin
    $display(
        "Type\tInstr\t\t\t\t\tRegWrite\tMemRead\t\tMemWrite\tMemToReg\tBranch\t\tALUSrc\t\tALUctl");

    /* R-type ADD */
    instr = 32'b0000000_00000_00000_000_00000_0110011;
    instr_type = "R";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);

    /* R-type SUB */
    instr = 32'b0100000_00000_00000_000_00000_0110011;
    instr_type = "R";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);

    /* LOAD */
    instr = 32'b000000000000_00000_010_00000_0000011;
    instr_type = "I";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);

    /* STORE */
    instr = 32'b0000000_00000_00000_010_00000_0100011;
    instr_type = "S";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);

    /* BRANCH (BEQ) */
    instr = 32'b0000000_00000_00000_000_00000_1100011;
    instr_type = "B";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);

    /* ADDI */
    instr = 32'b000000000000_00000_000_00000_0010011;
    instr_type = "I";
    #1;
    $display("%c\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b\t\t%b", instr_type, instr, reg_write,
             mem_read, mem_write, mem_to_reg, branch, alu_src, alu_ctl);
    $finish;
  end

endmodule

