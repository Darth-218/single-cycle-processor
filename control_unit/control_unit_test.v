// Code your testbench here
// or browse Examples

module ControlUnit_tb;
  reg  [31:0] instr;
  wire [6:0]  opcode  = instr[6:0];
  wire [2:0]  funct3  = instr[14:12];
  wire [6:0]  funct7  = instr[31:25];

  wire RegWrite, MemRead, MemWrite, MemToReg, Branch, ALUSrc;
  wire [3:0] ALUctl;

  ControlUnit dut (
    .opcode,
    .funct3,
    .funct7,
    .RegWrite,
    .MemRead,
    .MemWrite,
    .MemToReg,
    .Branch,
    .ALUSrc,
    .ALUctl
  );

  initial begin
    
    
    // R-type ADD: opcode=0110011, funct3=000, funct7=0000000
    instr = 32'b0000000_00000_00000_000_00000_0110011;
    #1;
    $display("R-ADD: RegWrite=%b ALUSrc=%b ALUctl=%b", RegWrite, ALUSrc, ALUctl);
    if (!(RegWrite==1 && ALUSrc==0 && ALUctl==4'b0010)) $fatal(1,"R-ADD control mismatch"); // here we are checking whether the output will go as its expected if no it will display a message with number 1 wich it will give time to display the message before it ends

    
    
    // R-type SUB: funct7=0100000
    instr = 32'b0100000_00000_00000_000_00000_0110011;
    #1;
    $display("R-SUB: RegWrite=%b ALUSrc=%b ALUctl=%b", RegWrite, ALUSrc, ALUctl);
    if (!(RegWrite==1 && ALUSrc==0 && ALUctl==4'b0110)) $fatal(1,"R-SUB control mismatch");

    
    
    // LOAD : opcode=0000011, funct3 = 010
    instr = 32'b000000000000_00000_010_00000_0000011; 
    #1;
    $display("LOAD: RegWrite=%b MemRead=%b MemToReg=%b ALUSrc=%b ALUctl=%b",
             RegWrite, MemRead, MemToReg, ALUSrc, ALUctl);
    if (!(RegWrite==1 && MemRead==1 && MemToReg==1 && ALUSrc==1 && ALUctl==4'b0010))
      $fatal(1,"LOAD control mismatch");

    
    
    // STORE: opcode=0100011
    instr = 32'b0000000_00000_00000_010_00000_0100011;
    #1;
    $display("STORE: MemWrite=%b ALUSrc=%b ALUctl=%b", MemWrite, ALUSrc, ALUctl);
    if (!(MemWrite==1 && ALUSrc==1 && ALUctl==4'b0010)) $fatal(1,"STORE control mismatch");

    
    
    // BRANCH (BEQ): opcode=1100011, funct3=000
    instr = 32'b0000000_00000_00000_000_00000_1100011;
    #1;
    $display("BRANCH: Branch=%b ALUSrc=%b ALUctl=%b", Branch, ALUSrc, ALUctl);
    if (!(Branch==1 && ALUSrc==0 && ALUctl==4'b0110)) $fatal(1,"BRANCH control mismatch");

    
    
    // I-type ALU (ADDI): opcode=0010011, funct3=000
    instr = 32'b000000000000_00000_000_00000_0010011;
    #1;
    $display("ADDI: RegWrite=%b ALUSrc=%b ALUctl=%b", RegWrite, ALUSrc, ALUctl);
    if (!(RegWrite==1 && ALUSrc==1 && ALUctl==4'b0010)) $fatal(1,"ADDI control mismatch");

    
    
    $display("All control tests passed.");
    $finish;
  end
endmodule