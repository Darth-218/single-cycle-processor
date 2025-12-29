module pipelined_processor (
    input wire clock,
    input wire reset
);

  wire [31:0] instruction;

  program_counter PC (
      .clock(clock),
      .reset(reset),
      .pc_current(pc)
  );

  instruction_memory IM (
      .address(pc),
      .instruction(instruction)
  );

  wire [63:0] if_id_pc;
  wire [31:0] if_id_instruction;

  if_id_reg IF_ID (
      .clock(clock),
      .reset(reset),
      .pc_in(pc),
      .instruction_in(instruction),
      .pc_out(if_id_pc),
      .instruction_out(if_id_instruction)
  );


  wire [6:0] opcode = if_id_instruction[6:0];
  wire [4:0] rs1 = if_id_instruction[19:15];
  wire [4:0] rs2 = if_id_instruction[24:20];
  wire [4:0] rd = if_id_instruction[11:7];

  wire [63:0] rs1_data, rs2_data;
  wire [63:0] imm;

  wire reg_write, mem_read, mem_write, mem_to_reg;
  wire branch, alu_src;
  wire [3:0] alu_ctl;
  wire [2:0] imm_type;

  register_file RF (
      .clock(clock),
      .reg_write(mem_wb_reg_write),
      .rs1_address(rs1),
      .rs2_address(rs2),
      .rd_address(mem_wb_rd),
      .write_data(wb_data),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );

  control_unit CU (
      .opcode(opcode),
      .funct3(if_id_instruction[14:12]),
      .funct7(if_id_instruction[31:25]),
      .reg_write(reg_write),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_to_reg(mem_to_reg),
      .branch(branch),
      .alu_src(alu_src),
      .alu_ctl(alu_ctl),
      .imm_type(imm_type)
  );

  immediate_generator IG (
      .instruction(if_id_instruction),
      .imm(imm)
  );

  wire [63:0] id_ex_rs1, id_ex_rs2, id_ex_imm;
  wire [4:0]  id_ex_rd;
  wire id_ex_reg_write, id_ex_mem_read;
  wire id_ex_mem_write, id_ex_mem_to_reg;
  wire id_ex_alu_src;
  wire [3:0]  id_ex_alu_ctl;

  id_ex_reg ID_EX (
      .clock(clock),
      .reset(reset),

      .rs1_in(rs1_data),
      .rs2_in(rs2_data),
      .imm_in(imm),
      .rd_in(rd),

      .reg_write_in(reg_write),
      .mem_read_in(mem_read),
      .mem_write_in(mem_write),
      .mem_to_reg_in(mem_to_reg),
      .alu_src_in(alu_src),
      .alu_ctl_in(alu_ctl),

      .rs1_out(id_ex_rs1),
      .rs2_out(id_ex_rs2),
      .imm_out(id_ex_imm),
      .rd_out(id_ex_rd),

      .reg_write_out(id_ex_reg_write),
      .mem_read_out(id_ex_mem_read),
      .mem_write_out(id_ex_mem_write),
      .mem_to_reg_out(id_ex_mem_to_reg),
      .alu_src_out(id_ex_alu_src),
      .alu_ctl_out(id_ex_alu_ctl)
  );

  wire [63:0] alu_in2;
  wire [63:0] alu_result;
  wire zero;

  assign alu_in2 = (id_ex_alu_src) ? id_ex_imm : id_ex_rs2;

  alu ALU (
      .rs1_data(id_ex_rs1),
      .rs2_data(alu_in2),
      .alu_ctl(id_ex_alu_ctl),
      .alu_out(alu_result),
      .zero(zero)
  );


  wire [63:0] ex_mem_alu, ex_mem_rs2;
  wire [4:0] ex_mem_rd;
  wire ex_mem_reg_write, ex_mem_mem_read;
  wire ex_mem_mem_write, ex_mem_mem_to_reg;

  ex_mem_reg EX_MEM (
      .clock(clock),
      .reset(reset),

      .alu_result_in(alu_result),
      .rs2_in(id_ex_rs2),
      .rd_in(id_ex_rd),

      .reg_write_in(id_ex_reg_write),
      .mem_read_in(id_ex_mem_read),
      .mem_write_in(id_ex_mem_write),
      .mem_to_reg_in(id_ex_mem_to_reg),

      .alu_result_out(ex_mem_alu),
      .rs2_out(ex_mem_rs2),
      .rd_out(ex_mem_rd),

      .reg_write_out(ex_mem_reg_write),
      .mem_read_out(ex_mem_mem_read),
      .mem_write_out(ex_mem_mem_write),
      .mem_to_reg_out(ex_mem_mem_to_reg)
  );

  wire [63:0] mem_data;

  data_memory DM (
      .clock(clock),
      .mem_write(ex_mem_mem_write),
      .mem_read(ex_mem_mem_read),
      .address(ex_mem_alu),
      .write_data(ex_mem_rs2),
      .read_data(mem_data)
  );

  wire [63:0] mem_wb_mem, mem_wb_alu;
  wire [4:0]  mem_wb_rd;
  wire        mem_wb_reg_write, mem_wb_mem_to_reg;

  mem_wb_reg MEM_WB (
      .clock(clock),
      .reset(reset),

      .mem_data_in(mem_data),
      .alu_result_in(ex_mem_alu),
      .rd_in(ex_mem_rd),

      .reg_write_in(ex_mem_reg_write),
      .mem_to_reg_in(ex_mem_mem_to_reg),

      .mem_data_out(mem_wb_mem),
      .alu_result_out(mem_wb_alu),
      .rd_out(mem_wb_rd),

      .reg_write_out(mem_wb_reg_write),
      .mem_to_reg_out(mem_wb_mem_to_reg)
  );

  wire [63:0] wb_data;

  assign wb_data = (mem_wb_mem_to_reg) ? mem_wb_mem : mem_wb_alu;

endmodule
