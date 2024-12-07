module bram(
  input logic        clk,          // Clock signal
    input logic [6:0]  read_addr,    // Address to read (row index within a level)
    input logic [1:0]  level_sel,    // Selected level (e.g., 2 bits for 4 levels)
    output logic [9:0] row_data      // Output: 10-bit row data (each bit = 1 cell)
);
  // Define BRAM storage for multiple levels
    logic [9:0] bram [0:399]; // 4 levels, 100 rows each (400 rows total)

    // Initialize BRAM with level data
    initial begin
        $readmemh("level_data.mem", bram); // Load level layouts from external file
    end

    // Calculate row address based on selected level
    logic [8:0] absolute_addr; // Address within the entire memory
    always_comb begin
        absolute_addr = level_sel * 100 + read_addr; // Each level is 100 rows
    end

    // Read logic
    always_ff @(posedge clk) begin
        row_data <= bram[absolute_addr]; // Output the row data
    end
endmodule
