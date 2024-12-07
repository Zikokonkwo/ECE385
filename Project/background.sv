module DrawBackground (
    input wire [9:0] DrawX,   // VGA pixel X coordinate
    input wire [9:0] DrawY,   // VGA pixel Y coordinate
    input wire [7:0] level [0:99], // Memory holding the level layout
    output reg [3:0] Red,     // VGA Red color
    output reg [3:0] Green,   // VGA Green color
    output reg [3:0] Blue     // VGA Blue color
);

    // Parameters for level size and screen size
    parameter LEVEL_WIDTH = 10;
    parameter LEVEL_HEIGHT = 10;
    parameter CELL_WIDTH = 40; // Width of each cell in pixels
    parameter CELL_HEIGHT = 30; // Height of each cell in pixels
    
    // Calculate the current cell based on VGA coordinates
    integer grid_x, grid_y;
    always @(*) begin
        // Determine the grid cell based on pixel coordinates
        grid_x = DrawX / CELL_WIDTH;
        grid_y = DrawY / CELL_HEIGHT;
        
        // Calculate the index of the current cell in the level grid
        integer index = grid_y * LEVEL_WIDTH + grid_x;

        // Check if the current cell is a wall (represented by 1)
        if (level[index] == 1) begin
            // Wall: set color to red (for example)
            Red = 4'b1111;    // Full Red
            Green = 4'b0000;  // No Green
            Blue = 4'b0000;   // No Blue
        end else begin
            // Empty space: set color to black (or background color)
            Red = 4'b0000;    // No Red
            Green = 4'b0000;  // No Green
            Blue = 4'b0000;   // No Blue
        end
    end
endmodule

