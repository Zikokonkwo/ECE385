mdoule collision_detection(  input wire [9:0] player_x,    // Player's x position
    input [9:0] player_y,    // Player's y position
    input [9:0] obstacle_x,  // Obstacle's x position
    input [9:0] obstacle_y,  // Obstacle's y position
    input [9:0] player_width,  // Player's width (e.g., 16)
    input [9:0] player_height, // Player's height (e.g., 16)
    input [9:0] obstacle_width, // Obstacle's width (e.g., 32)
    input [9:0] obstacle_height, // Obstacle's height (e.g., 32)
    output reg collision_detected);
endmodule
