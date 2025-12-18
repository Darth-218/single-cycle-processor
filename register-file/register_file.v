
module register_file (
    input  wire        clk,        // Clock signal
    input  wire        RegWrite,   // Enables writing to a register
    input  wire [4:0]  rs1,        // Read register 1 address
    input  wire [4:0]  rs2,        // Read register 2 address
    input  wire [4:0]  rd,         // Write register address
    input  wire [63:0] writeData,  // Data to write into rd
    output wire [63:0] readData1,  // Output of rs1
    output wire [63:0] readData2   // Output of rs2
);

    reg [63:0] register [31:0];        // Creates 32 of 64bit registers
    
    // Read
    assign readData1 = (rs1 == 0) ? 64'b0 : registers[rs1];
    assign readData2 = (rs2 == 0) ? 64'b0 : registers[rs2];
    
    // Write
    always @(posedge clk) begin
    if (RegWrite && rd != 0) begin
        registers[rd] <= writeData;
    end
end

endmodule

