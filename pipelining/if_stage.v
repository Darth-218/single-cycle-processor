module if_stage (
    input  wire [63:0] pc_current,
    input  wire [31:0] instruction,
    output wire [63:0] pc_plus4,
    output wire [31:0] if_instruction
);

    assign pc_plus4 = pc_current + 64'd4;
    assign if_instruction = instruction;

endmodule
