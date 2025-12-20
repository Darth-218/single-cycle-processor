module single_cycle_processor (
    input wire clock,
    input wire reset,
    output logic [31:0] out_pc,
    output logic [31:0] out_instruction,
    output logic out_reg_write,
    output logic [4:0] out_rd_address,
    output logic [31:0] out_write_data
);

  wire [63:0] pc;
  wire branch;
  wire [63:0] imm;

  wire [31:0] instruction;
  wire [6:0] opcode = instruction[6:0];
  wire [2:0] funct3 = instruction[14:12];
  wire [6:0] funct7 = instruction[31:25];

  wire [4:0] rs1_address, rs2_address, rd_address;
  wire [63:0] rs1_data, rs2_data, write_data;

  wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch;

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
      .write_data(write_data),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );

  immediate_generator IG (
      .instruction(instruction),
      .imm(imm)
  );

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
      .operation(alu_op),
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

  always @(*) begin
    out_pc <= pc;
    out_instruction <= instruction;
    out_reg_write <= reg_write;
    out_rd_address <= rd_address;
    out_write_data <= write_data;
  end

endmodule
