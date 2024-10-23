//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS 
);
    

	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;

    typedef enum logic [1:0] {IDLE, UP, DOWN, LEFT, RIGHT} motion_t;
    motion_t current_direction, next_direction;

    // Internal signals for motion and position updates
//    logic [9:0] Ball_X_Motion, Ball_X_Motion_next;
//    logic [9:0] Ball_Y_Motion, Ball_Y_Motion_next;
//    logic [9:0] Ball_X_next, Ball_Y_next;

    always_comb begin
        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = Ball_X_Motion;
        next_direction = current_direction;  // Default to current direction

        // Direction control based on key press (no diagonal allowed)
        case (current_direction)
            IDLE: begin
		if (keycode == 8'h26) next_direction = UP;    // Up arrow key
		else if (keycode == 8'h22) next_direction = DOWN;  // Down arrow key
		else if (keycode == 8'h04) next_direction = LEFT;  // Left arrow key
		else if (keycode == 8'h07) next_direction = RIGHT; // Right arrow key
            end

            UP: Ball_Y_Motion_next = -Ball_Y_Step;   // Move up
            DOWN: Ball_Y_Motion_next = Ball_Y_Step;  // Move down
            LEFT: Ball_X_Motion_next = -Ball_X_Step; // Move left
            RIGHT: Ball_X_Motion_next = Ball_X_Step; // Move right
        endcase
	

        //modify to control ball motion with the keycode
        // if (keycode == 8'h1A)
        //     Ball_Y_Motion_next = -10'd1;


        if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        end
        else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((BallX + BallS ) >= Ball_X_Max) //right edge --> bounce
	begin
		Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);  // set to -1 via 2's complement.
	end
	else if ((BallX - BallS ) <= Ball_X_Max) //left edge --> bounce
	begin
		Ball_X_Motion_next = Ball_X_Step;
	end
	    

    end

    assign BallS = 16;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd1; //Ball_X_Step;
            
			BallY <= Ball_Y_Center;
			BallX <= Ball_X_Center;
        end
        else 
        begin 

			Ball_Y_Motion <= Ball_Y_Motion_next; 
			Ball_X_Motion <= Ball_X_Motion_next; 

            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
			
		end  
    end


    
      
endmodule
