mdoule collision_detection(  input wire [9:0] player_x,    // Player's x position
    input [9:0] player_y,    // Player's y position
    input [9:0] obstacle_x,  // Obstacle's x position
    input [9:0] obstacle_y,  // Obstacle's y position
    input [9:0] player_width,  // Player's width 
    input [9:0] player_height, // Player's height 
    input [9:0] obstacle_width, // Obstacle's width 
    input [9:0] obstacle_height, // Obstacle's height 
    output collision_detected);

always_comb begin
        // Check for collision between the player and obstacle
        if ((player_x + player_width > obstacle_x) && (player_x < obstacle_x + obstacle_width) &&
            (player_y + player_height > obstacle_y) && (player_y < obstacle_y + obstacle_height)) begin
            collision_detected = 1; // Collision occurred
        end 
	else begin
            collision_detected = 0; // No collision
        end
    end



 // if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
 //        begin
 //            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
 //        end
 //        else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
 //        begin
 //            Ball_Y_Motion_next = Ball_Y_Step;
 //        end  
 //       //fill in the rest of the motion equations here to bounce left and right
	// if ((BallX + BallS ) >= Ball_X_Max) //right edge --> bounce
	// begin
	// 	Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);  // set to -1 via 2's complement.
	// end
	//     else if ((BallX - BallS ) <= Ball_X_Min) //left edge --> bounce
	// begin
	// 	Ball_X_Motion_next = Ball_X_Step;
	// end
endmodule
