module vga_display (
    input logic        clk,            // Clock signal
    input logic [9:0]  drawX,          // Current pixel X coordinate
    input logic [9:0]  drawY,          // Current pixel Y coordinate
    input logic [1:0]  level_sel,      // Selected level
    output logic [3:0] red,            // VGA Red
    output logic [3:0] green,          // VGA Green
    output logic [3:0] blue            // VGA Blue
);
    // Parameters
    parameter CELL_SIZE = 16; // Size of each grid cell in pixels

    // Level layout memory
    logic [6:0] read_addr;     // Address of the current row
    logic [9:0] row_data;      // Data for the current row
    level_layout_bram layout (
        .clk(clk),
        .read_addr(read_addr),
        .level_sel(level_sel),
        .row_data(row_data)
    );

    // Calculate grid coordinates
    logic [9:0] gridX, gridY;
    assign gridX = drawX / CELL_SIZE; // Grid column
    assign gridY = drawY / CELL_SIZE; // Grid row

    // Determine current cell data
    logic cell_data;
    always_comb begin
        read_addr = gridY;                       // Select row
        cell_data = row_data[9 - gridX];         // Select column bit
    end

    // Output pixel color based on cell data
    always_comb begin
        if (cell_data) begin
            red = 4'hF;   // Wall: red color
            green = 4'h0;
            blue = 4'h0;
        end else begin
            red = 4'h0;   // Background: black color
            green = 4'h0;
            blue = 4'h0;
        end
    end
endmodule
