module immediate_generator (
    input  wire [31:0] instruction,
    input  wire [ 2:0] imm_type,
    output reg  [63:0] imm
);

  always @(*) begin
    case (imm_type)
      3'b000: imm = {{52{instruction[31]}}, instruction[31:20]};  // I-type
      3'b001: imm = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]};  // S-type
      3'b010:
      imm = {
        {51{instruction[31]}},
        instruction[31],
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
      };  // B-type
      3'b011: imm = {{32{instruction[31]}}, instruction[31:12], 12'b0};  // U-type
      3'b100:
      imm = {
        {43{instruction[31]}},
        instruction[31],
        instruction[19:12],
        instruction[20],
        instruction[30:21],
        1'b0
      };  // J-type
      default: imm = 64'b0;
    endcase
  end

endmodule

