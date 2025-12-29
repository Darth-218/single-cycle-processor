module id_stage (
    input  wire clock,
    input  wire [31:0] instruction,
    input  wire [63:0] pc_plus4,
    output wire [63:0] rs1_data,
    output wire [63:0] rs2_data,
    output wire [63:0] imm,
    output wire [4:0]  rd,


    output wire reg_write,
    output wire mem_read,
    output wire mem_write,
    output wire mem_to_reg,
    output wire branch,
    output wire alu_src,
    output wire [3:0] alu_ctl
);


    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    assign rd = instruction[11:7];

    // Register File
    register_file RF (
        .clock(clock),
        .reg_write(1'b0),
        .rs1_address(rs1),
        .rs2_address(rs2),
        .rd_address(5'b0),
        .write_data(64'b0),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Control Unit
    control_unit CU (
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

    // Immediate Generator
    immediate_generator IG (
        .instruction(instruction),
        .imm(imm)
    );
