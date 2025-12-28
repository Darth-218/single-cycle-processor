module program_counter (
    input  wire        clock,
    input  wire        reset,
    input  wire [1:0]  pc_src,
    input  wire        zero,
    input  wire [63:0] imm,
    input  wire [63:0] alu_result,
    output reg  [63:0] pc_current
);

  wire [63:0] pc_plus4;
  wire [63:0] pc_branch;
  wire [63:0] pc_next;
  wire        branch_taken;

  assign pc_plus4     = pc_current + 64'd4;
  assign pc_branch    = pc_current + imm;
  assign branch_taken = (pc_src == 2'b01) && zero;

  assign pc_next = (pc_src == 2'b01 && branch_taken) ? pc_branch :
                   (pc_src == 2'b10) ? alu_result :
                   pc_plus4;

  always @(posedge clock or posedge reset) begin
    if (reset) pc_current <= 64'b0;
    else pc_current <= pc_next;
  end

endmodule

