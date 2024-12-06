mdoule collision_detection(  input wire [9:0] player_x,    // Player's x position
    input [9:0] player_y,    // Player's y position
    input [9:0] obstacle_x,  // Obstacle's x position
    input [9:0] obstacle_y,  // Obstacle's y position
    input [9:0] player_width,  // Player's width 
    input [9:0] player_height, // Player's height 
    input [9:0] obstacle_width, // Obstacle's width 
    input [9:0] obstacle_height, // Obstacle's height 
    output reg collision_detected);
endmodule
