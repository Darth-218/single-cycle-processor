module PC_Logic (
    input clk,
    input reset,
    input Branch,
    input Zero,
    input [63:0] imm,
    output reg [63:0] pc_current
);

wire [63:0] pc_plus4;
wire [63:0] pc_branch;
wire branch_taken;
wire [63:0] pc_next;

assign pc_plus4 = pc_current + 64'd4;
assign pc_branch = pc_current + imm;
assign branch_taken = Branch & Zero;
assign pc_next = branch_taken ? pc_branch : pc_plus4;

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_current <= 64'b0;
    else
        pc_current <= pc_next;
end

endmodule