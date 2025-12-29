module ex_stage (
    input wire [63:0] rs1_data,
    input wire [63:0] rs2_data,
    input wire [63:0] imm,
    input wire [63:0] pc_plus4,
    input wire alu_src,
    input wire [3:0] alu_ctl,
    input wire branch,

    output wire [63:0] alu_result,
    output wire zero,
    output wire [63:0] branch_target,
    output wire branch_taken,
    output wire [63:0] rs2_forward
);

    // ALU input mux
    wire [63:0] alu_in2;
    assign alu_in2 = (alu_src) ? imm : rs2_data;

    // ALU
    alu ALU (
        .a(rs1_data),
        .b(alu_in2),
        .alu_ctl(alu_ctl),
        .result(alu_result),
        .zero(zero)
    );

    // Branch target calculation
    assign branch_target = pc_plus4 + (imm << 1);

    // Branch decision (BEQ-style)
    assign branch_taken = branch & zero;

    // Forward rs2 for stores
    assign rs2_forward = rs2_data;

endmodule
