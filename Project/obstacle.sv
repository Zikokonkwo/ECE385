// //NEW
// module obstacle 
// ( 
//     input  logic        Reset, 
//     input  logic        frame_clk,
//     input  logic [9:0]  position_x,
//     input  logic [9:0]  position_y,
    
//     output logic [9:0]  OBSX, 
//     output logic [9:0]  OBSY, 
//     output logic [9:0]  OBS_size 
// );

//     parameter [9:0] Obs_X_Max = 639;  // Right boundary
//     parameter [9:0] Obs_X_Min = 0;    // Left boundary
//     parameter [9:0] Obs_Y = 240;      // Fixed Y position
//     parameter [9:0] Obs_Step = 2;     // Step size

//     logic [9:0] Obs_X_Motion;

//     // Default obstacle size
//     assign OBS_size = 16;  

//     always_ff @(posedge frame_clk or posedge Reset) begin
//         if (Reset) begin
//             OBSX <= position_x;
//             Obs_X_Motion <= Obs_Step;
//         end else begin
//             // Bounce logic
//             if ((OBSX + Obs_Step) >= Obs_X_Max) begin
//                 Obs_X_Motion <= -Obs_Step;  // Reverse direction
//             end else if ((OBSX - Obs_Step) <= Obs_X_Min) begin
//                 Obs_X_Motion <= Obs_Step;
//             end

//             OBSX <= OBSX + Obs_X_Motion;
//             OBSY <= position_y;  // Fixed position for this implementation
//         end
//     end

// endmodule






























OLD
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


module  obstacle 
 ( 
    input  logic        Reset, 
    input  logic        frame_clk,
	 input logic 	[9:0] position_x,
	 input logic 	[9:0] position_y,
	
 

   output logic [9:0]  OBSX, 
   output logic [9:0]  OBSY, 
   output logic [9:0]  OBS_size 
);
    

	 
parameter [9:0] OBS_X_Center=320;  // Center position on the X axis
parameter [9:0] OBS_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] OBS_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] OBS_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] OBS_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] OBS_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] OBS_X_Step=1;      // Step size on the X axis
    parameter [9:0] OBS_Y_Step=1;      // Step size on the Y axis

    logic [9:0] OBS_X_Motion;
    logic [9:0] OBS_X_Motion_next;
    logic [9:0] OBS_Y_Motion;
    logic [9:0] OBS_Y_Motion_next;

    logic [9:0] OBS_X_next;
    logic [9:0] OBS_Y_next;

    // typedef enum logic [1:0] {IDLE, UP, DOWN, LEFT, RIGHT} motion_t;
    // motion_t current_direction, next_direction;

    // Internal signals for motion and position updates
//    logic [9:0] OBS_X_Motion, OBS_X_Motion_next;
//    logic [9:0] OBS_Y_Motion, OBS_Y_Motion_next;
//    logic [9:0] OBS_X_next, OBS_Y_next;

    always_comb begin
        OBS_Y_Motion_next = OBS_Y_Motion; // set default motion to be same as prev clock cycle 
        OBS_X_Motion_next = OBS_X_Motion;

        //modify to control OBS motion with the keycode
	// if (keycode == 8'h1A) //go up
	// begin
 //            	OBS_Y_Motion_next = -10'd1;
	//     	OBS_X_Motion_next = 0;
	// end
	    
	// else if(keycode == 8'h16) //go down
	// begin
	//     	OBS_Y_Motion_next = 10'd1;
	//     	OBS_X_Motion_next = 0;
	// end 
	//     else if(keycode == 8'h04) //move left
	// begin
	// 	OBS_Y_Motion_next = 0;
	// 	OBS_X_Motion_next = -10'd1;
	// end 
	//     else if(keycode == 8'h07) //move right
	// begin
	// 	OBS_Y_Motion_next = 0;
	//     	OBS_X_Motion_next = 10'd1;
	// end 

	    if ( (OBSY + OBS_size) >= OBS_Y_Max )  // OBS is at the bottom edge, BOUNCE!
        begin
            OBS_Y_Motion_next = (~ (OBS_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        end
	    else if ( (OBSY - OBS_size) <= OBS_Y_Min )  // OBS is at the top edge, BOUNCE!
        begin
            OBS_Y_Motion_next = OBS_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	    if ((OBSX + OBS_size ) >= OBS_X_Max) //right edge --> bounce
	begin
		OBS_X_Motion_next = (~ (OBS_X_Step) + 1'b1);  // set to -1 via 2's complement.
	end
	    else if ((OBSX - OBS_size ) <= OBS_X_Min) //left edge --> bounce
	begin
		OBS_X_Motion_next = OBS_X_Step;
	end
	    

    end

    assign OBS_size = 16;  // default OBS size
    assign OBS_X_next = (OBSX + OBS_X_Motion_next);
    assign OBS_Y_next = (OBSY + OBS_Y_Motion_next);
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
           OBS_Y_Motion <= 10'd0; //OBS_Y_Step;
	   OBS_X_Motion <= 10'd1; //OBS_X_Step;
            
	  OBSY <= OBS_Y_Center;
	  OBSX <= OBS_X_Center;
        end
        else 
        begin 

	   OBS_Y_Motion <= OBS_Y_Motion_next; 
	   OBS_X_Motion <= OBS_X_Motion_next; 

            OBSY <= OBS_Y_next;  // Update OBS position
            OBSX <= OBS_X_next;
			
		end  
    end


    
      
endmodule
