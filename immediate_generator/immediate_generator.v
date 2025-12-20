module immediate_generator (
    input  wire [31:0] instruction,
    output reg  [63:0] imm
);

  wire [6:0] opcode;
  assign opcode = instruction[6:0];

  always @(*) begin
    case (opcode)

      // I-type: addi, andi, ori, xori, ld
      7'b0010011, 7'b0000011: begin
        imm = {{52{instruction[31]}}, instruction[31:20]};
      end

      // S-type: sd
      7'b0100011: begin
        imm = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end

      // B-type: beq
      7'b1100011: begin
        imm = {
          {51{instruction[31]}},
          instruction[31],
          instruction[7],
          instruction[30:25],
          instruction[11:8],
          1'b0
        };
      end

      default: begin
        imm = 64'b0;
      end
    endcase
  end

endmodule
