module single_cycle_processor (
    input wire clock,
    input wire reset
);

  wire [63:0] pc;
  wire [1:0] pc_src;
  wire branch;
  wire [63:0] imm;
  wire [2:0] imm_type;

  wire [31:0] instruction;
  wire [6:0] opcode = instruction[6:0];
  wire [2:0] funct3 = instruction[14:12];
  wire funct7 = instruction[30];

  wire [4:0] rs1_address = instruction[19:15];
  wire [4:0] rs2_address = instruction[24:20];
  wire [4:0] rd_address = instruction[11:7];

  wire [63:0] rs1_data, rs2_data;

  wire reg_write, mem_read, mem_write, mem_to_reg, alu_src;

  wire [3:0] alu_op;
  wire [3:0] alu_ctl;
  wire [63:0] alu_out;
  wire zero;

  program_counter PC (
      .clock(clock),
      .reset(reset),
      .branch(branch),
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
      .write_data(alu_out),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );

  immediate_generator IG (
      .instruction(instruction),
      .imm(imm)
  );

  control_unit CU (
      .opcode(instruction[6:0]),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .branch(branch),
      .alu_src(alu_src),
      .alu_op(alu_op),
      .pc_src(pc_src),
      .imm_type(imm_type)
  );

  alu_control AC (
      .alu_op  (alu_op),
      .alu_ctrl(alu_ctl),
      .funct3  (funct3),
      .funct7  (funct7)
  );

  alu ALU (
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .alu_ctrl(alu_ctl),
      .result(alu_out),
      .zero(zero)
  );

  data_memory DM (
      .clock(clock),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .address(rd_data),
      .write_data(alu_out),
      .read_data(alu_out)
  );

endmodule
