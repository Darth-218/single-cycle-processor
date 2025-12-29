module id_ex_reg (
    input wire clock,
    input wire reset,

    // Data inputs
    input wire [63:0] rs1_data_in,
    input wire [63:0] rs2_data_in,
    input wire [63:0] imm_in,
    input wire [63:0] pc_plus4_in,
    input wire [4:0] rd_in,

    // Control inputs
    input wire reg_write_in,
    input wire mem_read_in,
    input wire mem_write_in,
    input wire mem_to_reg_in,
    input wire branch_in,
    input wire alu_src_in,
    input wire [3:0] alu_ctl_in,

    // Outputs to EX stage
    output reg [63:0] rs1_data_out,
    output reg [63:0] rs2_data_out,
    output reg [63:0] imm_out,
    output reg [63:0] pc_plus4_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg branch_out,
    output reg alu_src_out,
    output reg [3:0] alu_ctl_out
);

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            rs1_data_out   <= 0;
            rs2_data_out   <= 0;
            imm_out        <= 0;
            pc_plus4_out   <= 0;
            rd_out         <= 0;
            reg_write_out  <= 0;
            mem_read_out   <= 0;
            mem_write_out  <= 0;
            mem_to_reg_out <= 0;
            branch_out     <= 0;
            alu_src_out    <= 0;
            alu_ctl_out    <= 0;
        end else begin
            rs1_data_out   <= rs1_data_in;
            rs2_data_out   <= rs2_data_in;
            imm_out        <= imm_in;
            pc_plus4_out   <= pc_plus4_in;
            rd_out         <= rd_in;
            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            branch_out     <= branch_in;
            alu_src_out    <= alu_src_in;
            alu_ctl_out    <= alu_ctl_in;
        end
    end
endmodule
