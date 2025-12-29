module ex_mem_reg (
    input wire clock,
    input wire reset,

    // Inputs from EX
    input wire [63:0] alu_result_in,
    input wire [63:0] rs2_data_in,
    input wire [63:0] branch_target_in,
    input wire branch_taken_in,
    input wire zero_in,
    input wire [4:0] rd_in,

    // Control inputs
    input wire reg_write_in,
    input wire mem_read_in,
    input wire mem_write_in,
    input wire mem_to_reg_in,
    input wire branch_in,

    // Outputs to MEM
    output reg [63:0] alu_result_out,
    output reg [63:0] rs2_data_out,
    output reg [63:0] branch_target_out,
    output reg branch_taken_out,
    output reg zero_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg branch_out
);

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            alu_result_out   <= 0;
            rs2_data_out     <= 0;
            branch_target_out<= 0;
            branch_taken_out <= 0;
            zero_out         <= 0;
            rd_out           <= 0;
            reg_write_out    <= 0;
            mem_read_out     <= 0;
            mem_write_out    <= 0;
            mem_to_reg_out   <= 0;
            branch_out       <= 0;
        end else begin
            alu_result_out   <= alu_result_in;
            rs2_data_out     <= rs2_data_in;
            branch_target_out<= branch_target_in;
            branch_taken_out <= branch_taken_in;
            zero_out         <= zero_in;
            rd_out           <= rd_in;
            reg_write_out    <= reg_write_in;
            mem_read_out     <= mem_read_in;
            mem_write_out    <= mem_write_in;
            mem_to_reg_out   <= mem_to_reg_in;
            branch_out       <= branch_in;
        end
    end
endmodule
