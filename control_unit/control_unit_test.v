module control_unit_test;

  reg [31:0] instr;

  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [6:0] funct7;

  wire RegWrite;
  wire MemRead;
  wire MemWrite;
  wire MemToReg;
  wire Branch;
  wire ALUSrc;
  wire [3:0] ALUctl;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];

  control_unit dut (
      .opcode  (opcode),
      .funct3  (funct3),
      .funct7  (funct7),
      .RegWrite(RegWrite),
      .MemRead (MemRead),
      .MemWrite(MemWrite),
      .MemToReg(MemToReg),
      .Branch  (Branch),
      .ALUSrc  (ALUSrc),
      .ALUctl  (ALUctl)
  );

  initial begin
    /* R-type ADD */
    instr = 32'b0000000_00000_00000_000_00000_0110011;
    #1;
    if (!(RegWrite == 1'b1 && ALUSrc == 1'b0 && ALUctl == 4'b0010)) begin
      $display("ERROR: R-ADD control mismatch");
      $stop;
    end

    /* R-type SUB */
    instr = 32'b0100000_00000_00000_000_00000_0110011;
    #1;
    if (!(RegWrite == 1'b1 && ALUSrc == 1'b0 && ALUctl == 4'b0110)) begin
      $display("ERROR: R-SUB control mismatch");
      $stop;
    end

    /* LOAD */
    instr = 32'b000000000000_00000_010_00000_0000011;
    #1;
    if (!(RegWrite == 1'b1 && MemRead == 1'b1 &&
          MemToReg == 1'b1 && ALUSrc == 1'b1 &&
          ALUctl == 4'b0010)) begin
      $display("ERROR: LOAD control mismatch");
      $stop;
    end

    /* STORE */
    instr = 32'b0000000_00000_00000_010_00000_0100011;
    #1;
    if (!(MemWrite == 1'b1 && ALUSrc == 1'b1 && ALUctl == 4'b0010)) begin
      $display("ERROR: STORE control mismatch");
      $stop;
    end

    /* BRANCH (BEQ) */
    instr = 32'b0000000_00000_00000_000_00000_1100011;
    #1;
    if (!(Branch == 1'b1 && ALUSrc == 1'b0 && ALUctl == 4'b0110)) begin
      $display("ERROR: BRANCH control mismatch");
      $stop;
    end

    /* ADDI */
    instr = 32'b000000000000_00000_000_00000_0010011;
    #1;
    if (!(RegWrite == 1'b1 && ALUSrc == 1'b1 && ALUctl == 4'b0010)) begin
      $display("ERROR: ADDI control mismatch");
      $stop;
    end

    $display("All control tests passed.");
    $finish;
  end

endmodule

