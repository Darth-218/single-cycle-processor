module program_counter (
    // TODO: Change input names
    input clock,
    input reset,
    input [63:0] branch,
    input zero,
    input [63:0] imm,
    output reg [63:0] pc_current
);

  wire [63:0] pc_plus4;
  wire [63:0] pc_branch;
  wire branch_taken;
  wire [63:0] pc_next;

  assign pc_plus4 = pc_current + 64'd4;
  assign pc_branch = pc_current + imm;
  assign branch_taken = branch & zero;
  assign pc_next = branch_taken ? pc_branch : pc_plus4;

  always @(posedge clock or posedge reset) begin
    if (reset) pc_current <= 64'b0;
    else pc_current <= pc_next;
  end

endmodule

