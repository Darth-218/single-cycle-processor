module program_counter (
    input  wire        clock,
    input  wire        reset,
    input  wire        branch,
    input  wire        zero,
    input  wire [63:0] imm,
    output reg  [63:0] pc_current
);

  wire [63:0] pc_plus4;
  wire [63:0] pc_branch;
  wire        branch_taken;

  assign pc_plus4     = pc_current + 64'd4;
  assign pc_branch    = pc_current + (imm << 1);
  assign branch_taken = branch && zero;

  always @(posedge clock or posedge reset) begin
    if (reset) pc_current <= 64'b0;
    else pc_current <= branch_taken ? pc_branch : pc_plus4;
  end

endmodule

