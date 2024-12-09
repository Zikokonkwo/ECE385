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
    //
    input  logic        collision,//added
     input  logic        collision2,//added
    //
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  BallX, ObsX,  ObsX2,
    output logic [9:0]  BallY, ObsY, ObsY2,
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
    
    
    /////
    parameter [9:0] Obs_X_Center=320;  // Center position on the X axis
    parameter [9:0] Obs_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Obs_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Obs_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Obs_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Obs_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Obs_X_Step=2;      // Step size on the X axis
    parameter [9:0] Obs_Y_Step=2;      // Step size on the Y axis
    /////
    
    



    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    
    
    ////
    logic [9:0] Obs_X_Motion;
    logic [9:0] Obs_X_Motion_next;
    logic [9:0] Obs_Y_Motion;
    logic [9:0] Obs_Y_Motion_next;

    logic [9:0] Obs_X_next;
    logic [9:0] Obs_Y_next;
    ////
    logic [9:0] Obs_X2_Motion;
    logic [9:0] Obs_X2_Motion_next;
    logic [9:0] Obs_Y2_Motion;
    logic [9:0] Obs_Y2_Motion_next;

    logic [9:0] Obs_X2_next;
    logic [9:0] Obs_Y2_next;
    //
    
    

    // typedef enum logic [1:0] {IDLE, UP, DOWN, LEFT, RIGHT} motion_t;
    // motion_t current_direction, next_direction;

    // Internal signals for motion and position updates
//    logic [9:0] Ball_X_Motion, Ball_X_Motion_next;
//    logic [9:0] Ball_Y_Motion, Ball_Y_Motion_next;
//    logic [9:0] Ball_X_next, Ball_Y_next;





    always_comb begin
        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = Ball_X_Motion;
        ///
        Obs_Y_Motion_next = Obs_Y_Motion;
        Obs_X_Motion_next = Obs_X_Motion;
        
        ///
              Obs_Y2_Motion_next = Obs_Y2_Motion;
        Obs_X2_Motion_next = Obs_X2_Motion;//added
      ///
      
	if (keycode == 8'h1A) //go up
	begin
            	Ball_Y_Motion_next = -10'd1;
	    	Ball_X_Motion_next = 0;
	    	//
//	    	     ObsY <= 350;
//			ObsX <= 150;
//            //
//            ObsY2 <= 240;
//            ObsX2 <= 320;
	    	//causes failed implimentation 
	end
	    
	else if(keycode == 8'h16) //go down
	begin
	    	Ball_Y_Motion_next = 10'd1;
	    	Ball_X_Motion_next = 0;
	end 
	    else if(keycode == 8'h04) //move left
	begin
		Ball_Y_Motion_next = 0;
		Ball_X_Motion_next = -10'd1;
	end 
	    else if(keycode == 8'h07) //move right
	begin
		Ball_Y_Motion_next = 0;
	    	Ball_X_Motion_next = 10'd1;
	end 

///

///


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
	else if ((BallX - BallS ) <= Ball_X_Min) //left edge --> bounce
	begin
		Ball_X_Motion_next = Ball_X_Step;
	end
	    
	    
	    
//// OBS 1
if ( (ObsY + BallS) >= Obs_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Obs_Y_Motion_next = (~ (Obs_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        end
        else if ( (ObsY - BallS) <= Obs_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Obs_Y_Motion_next = Obs_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((ObsX + BallS ) >= Obs_X_Max) //right edge --> bounce
	begin
		Obs_X_Motion_next = (~ (Obs_X_Step) + 1'b1);  // set to -1 via 2's complement.
	end
	else if ((ObsX - BallS ) <= Obs_X_Min) //left edge --> bounce
	begin
		Obs_X_Motion_next = Obs_X_Step;
	end
	    

////



//// OBS 2
if ( (ObsY2 + BallS) >= Obs_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Obs_Y2_Motion_next = (~ (Obs_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        end
        else if ( (ObsY2 - BallS) <= Obs_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Obs_Y2_Motion_next = Obs_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((ObsX2 + BallS ) >= Obs_X_Max) //right edge --> bounce
	begin
		Obs_X2_Motion_next = (~ (Obs_X_Step) + 1'b1);  // set to -1 via 2's complement.
	end
	else if ((ObsX2 - BallS ) <= Obs_X_Min) //left edge --> bounce
	begin
		Obs_X2_Motion_next = Obs_X_Step;
	end
	    

////





    end

    assign BallS = 16;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
    ///77777777777777777777777777777777777777777777777777
    assign Obs_X_next = (ObsX + Obs_X_Motion_next);
    assign Obs_Y_next = (ObsY + Obs_Y_Motion_next);
    //
      assign Obs_X2_next = (ObsX2 + Obs_X2_Motion_next);
    assign Obs_Y2_next = (ObsY2 + Obs_Y2_Motion_next);
    ///77777777777777777777777777777777777777777777777777777
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset || collision || collision2)//changed to have "OR collision"
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;//was 1 (now 0 to keep player still)
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
            
            
            ////
            Obs_Y_Motion <= 10'd0; //Ball_Y_Step;//was 1 (now 0 to keep player still)
			Obs_X_Motion <= 10'd1; //Ball_X_Step;//was 0
            ////
               Obs_Y2_Motion <= 10'd1; //Ball_Y_Step;//was 1 (now 0 to keep player still)
			Obs_X2_Motion <= 10'd0; //Ball_X_Step;//was 0
            ////added
                          
			
            BallY <= 240;//
            BallX <= 30;//new starting position of the player
          
          
            //
//          ObsY <= Obs_Y_Center;
//			ObsX <= Obs_X_Center;
            ObsY <= 350;
			ObsX <= 150;
            //
            ObsY2 <= 240;
            ObsX2 <= 320;
            //
            
        end
        else if (keycode == 8'h0)
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;//was 1 (now 0 to keep player still)
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			end
        else 
        begin 

			Ball_Y_Motion <= Ball_Y_Motion_next; 
			Ball_X_Motion <= Ball_X_Motion_next; 

            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
			
		end  
		//default
		//999999999999999999999
	    Obs_Y_Motion <= Obs_Y_Motion_next; 
		Obs_X_Motion <= Obs_X_Motion_next; 
		//
		     
        ObsY <= Obs_Y_next;  // Update ball position
        ObsX <= Obs_X_next;

		
		
		    Obs_Y2_Motion <= Obs_Y2_Motion_next; 
		Obs_X2_Motion <= Obs_X2_Motion_next; 
		
		ObsX2 <= Obs_X2_next;  // Update ball position//changed
        ObsY2 <= Obs_Y2_next;
        
        
		//999999999999999999999999999999999
		
		
		
    end
    
// always_ff @(posedge frame_clk)
//    begin
//            if (collision || collision2 || Reset) begin
//                ObsY <= 350;
//			ObsX <= 150;
//            //
//            ObsY2 <= 240;
//            ObsX2 <= 320;

//            end
//   end
 
  
      
endmodule
