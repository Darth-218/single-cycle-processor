module single_cycle_processor (
    input wire clock,
    input wire reset
);

  wire [63:0] pc;
  wire [63:0] branch_target;
  wire [63:0] imm;
  wire [63:0] imm_ext;

  wire [31:0] instruction;
  wire [ 6:0] opcode = instruction[6:0];
  wire [ 2:0] funct3 = instruction[14:12];
  wire [ 6:0] funct7 = instruction[31:25];

  wire [4:0] rs1_address, rs2_address, rd_address;
  wire [63:0] rs1_data, rs2_data, write_data;

  wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch;

  wire [2:0] alu_op;
  wire [63:0] alu_out;
  wire zero;

  program_counter PC (
      .clock(clock),
      .reset(reset),
      .branch(branch_target),
      .imm(imm),
      .pc_current(pc)
  );

  instruction_memory IM (
      .address(pc),
      .instruction(instruction)
  );

  register_file RF (
      .clock(clock),
      .reg_write(reg_write),
      .rs1_address(rs1_address),
      .rs2_address(rs2_address),
      .rd_address(rd_address),
      .write_data(write_data),
      .rs1_data(rs1_addr),
      .rs2_data(rs2_addr)
  );

  // immediate_generator IG (
  //     .imm(imm),
  //     .extended_imm(imm_ext)
  // );

  control_unit CU (
      .opcode(instruction[6:0]),
      .funct3(instruction[14:12]),
      .funct7(instruction[31:25]),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .branch(branch),
      .alu_src(alu_src),
      .alu_ctl(alu_ctl)
  );

  alu ALU (
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .op(alu_op),
      .alu_out(alu_out),
      .zero(zero)
  );

  data_memory DM (
      .clock(clock),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .address(rs2_data),
      .write_data(write_data),
      .read_data(write_data)
  );

endmodule
