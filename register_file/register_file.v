module register_file (
    input  wire        clock,        // Clock signal
    input  wire        reg_write,    // Enables writing to a register
    input  wire [ 4:0] rs1_address,  // Read register 1 address
    input  wire [ 4:0] rs2_address,  // Read register 2 address
    input  wire [ 4:0] rd_address,   // Write register address
    input  wire [63:0] write_data,   // Data to write into rd
    output wire [63:0] rs1_data,     // Output of rs1
    output wire [63:0] rs2_data      // Output of rs2
);

  reg [63:0] registers[0:31];  // Creates 32 of 64bit registers

  assign registers[0] = 64'b0;

  assign rs1_data = (rs1_address == 0) ? 64'b0 : registers[rs1_address];
  assign rs2_data = (rs2_address == 0) ? 64'b0 : registers[rs2_address];

  always @(posedge clock) begin
    if (reg_write && rd_address != 0) begin
      registers[rd_address] <= write_data;
    end
  end

endmodule

