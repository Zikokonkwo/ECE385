

//////////////// N O T E S ///////////////////
//CURRENT Results: single overlapping obstacle that comes from off screen as before
/////////////////////////////////////////////


module  ball 
( 
    input  logic        Reset, 
    //
    input  logic        collision,//added
     input  logic        collision2,//added
    //
    input  logic        frame_clk, reset_player, reset_level,
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
    parameter [9:0] Ball_X_Step=5;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=5;      // Step size on the Y axis
    
    
    /////
    parameter [9:0] Obs_X_Center=320;  // Center position on the X axis
    parameter [9:0] Obs_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Obs_X_Min=39;       // Leftmost point on the X axis
    parameter [9:0] Obs_X_Max=599;     // Rightmost point on the X axis
    parameter [9:0] Obs_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Obs_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Obs_X_Step=8;      // Step size on the X axis
    parameter [9:0] Obs_Y_Step=8;      // Step size on the Y axis
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
//    logic [9:0] Obs_X2_Motion;
//    logic [9:0] Obs_X2_Motion_next;
//    logic [9:0] Obs_Y2_Motion;
//    logic [9:0] Obs_Y2_Motion_next;

//    logic [9:0] Obs_X2_next;
//    logic [9:0] Obs_Y2_next;
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

        
        //
//              Obs_Y2_Motion_next = Obs_Y2_Motion;
//        Obs_X2_Motion_next = Obs_X2_Motion;//added


      ///
      
	if ((keycode == 8'h1A) && (BallY - (BallS+10)) >= 0) //go up
	begin
            	Ball_Y_Motion_next = -10'd5;
	    	Ball_X_Motion_next = 0;
	    	//
//	    	     ObsY <= 350;
//			ObsX <= 150;
//            //
//            ObsY2 <= 240;
//            ObsX2 <= 320;
	    	//causes failed implimentation 
	end
	    

	    
	else if((keycode == 8'h16) && ((BallY + (10+BallS)) <= 479)) //go down
	begin
	    	Ball_Y_Motion_next = 10'd5;
	    	Ball_X_Motion_next = 0;
	end 
	    else if((keycode == 8'h04) && ((BallX - (10+BallS)) >= 0)) //move left
	begin
		Ball_Y_Motion_next = 0;
		Ball_X_Motion_next = -10'd5;
	end 
	    else if((keycode == 8'h07) && ((BallX + 10+BallS) <= 639)) //move right
	begin
		Ball_Y_Motion_next = 0;
	    	Ball_X_Motion_next = 10'd5;
	end 

///

///


        if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'd1);  // set to -1 via 2's complement.
        end
        else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((BallX + BallS ) >= Ball_X_Max) //right edge --> bounce
	begin
		Ball_X_Motion_next = (~ (Ball_X_Step) + 1'd1);  // set to -1 via 2's complement.
	end
	else if ((BallX - BallS ) <= Ball_X_Min) //left edge --> bounce
	begin
		Ball_X_Motion_next = Ball_X_Step;
	end
	    
	    
	    
//// OBS 1
if ( (ObsY + BallS) >= Obs_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Obs_Y_Motion_next = (~ (Obs_Y_Step) + 1'd1);  // set to -1 via 2's complement.
        end
        else if ( (ObsY - BallS) <= Obs_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Obs_Y_Motion_next = Obs_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((ObsX + BallS ) >= Obs_X_Max) //right edge --> bounce
	begin
		Obs_X_Motion_next = (~ (Obs_X_Step) + 1'd1);  // set to -1 via 2's complement.
	end
	else if ((ObsX - BallS ) <= Obs_X_Min) //left edge --> bounce
	begin
		Obs_X_Motion_next = Obs_X_Step;
	end
	
//// OBS 2
//if ( (ObsY2 + BallS) >= Obs_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//        begin
//            Obs_Y2_Motion_next = (~ (Obs_Y_Step) + 1'd1);  // set to -1 via 2's complement.
//        end
//        else if ( (ObsY2 - BallS) <= Obs_Y_Min )  // Ball is at the top edge, BOUNCE!
//        begin
//            Obs_Y2_Motion_next = Obs_Y_Step;
//        end  
//       //fill in the rest of the motion equations here to bounce left and right
//	if ((ObsX2 + BallS ) >= Obs_X_Max) //right edge --> bounce
//	begin
//		Obs_X2_Motion_next = (~ (Obs_X_Step) + 1'd1);  // set to -1 via 2's complement.
//	end
//	else if ((ObsX2 - BallS ) <= Obs_X_Min) //left edge --> bounce
//	begin
//		Obs_X2_Motion_next = Obs_X_Step;
//	end
	    

////





    end

    assign BallS = 16;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
    ///77777777777777777777777777777777777777777777777777
//    assign Obs_X_next = (ObsX + Obs_X_Motion_next);
//    assign Obs_Y_next = (ObsY + Obs_Y_Motion_next);
//    //
//      assign Obs_X2_next = (ObsX2 + Obs_X2_Motion_next);
//    assign Obs_Y2_next = (ObsY2 + Obs_Y2_Motion_next);


  assign Obs_X_next = (ObsX + Obs_X_Motion_next);
    assign Obs_Y_next = (ObsY + Obs_Y_Motion_next);
    //
//      assign Obs_X2_next = (ObsX2 + Obs_X2_Motion_next);
//    assign Obs_Y2_next = (ObsY2 + Obs_Y2_Motion_next);
    ///77777777777777777777777777777777777777777777777777777
   
   always_ff @(posedge frame_clk) begin
    if (Reset || collision || collision2 || reset_player || reset_level)
    begin 
        
        // Reset ball and obstacles
        Obs_Y_Motion <= 10'd0;
        Obs_X_Motion <= 10'd0;//MAKE 0
        ObsY <= 400;
        ObsX <= 50;
        //
        Ball_Y_Motion <= 10'd0; 
        Ball_X_Motion <= 10'd0;
        BallY <= 240;
        BallX <= 20;
        end
        else if ((reset_player) == 1'b1)begin
        Ball_Y_Motion <= 10'd0; 
        Ball_X_Motion <= 10'd0;
        BallY <= 240;
        BallX <= 30;
            end 
        
        



//        Obs_Y2_Motion <= 10'd0; // MAKE 0
//        Obs_X2_Motion <= 10'd0;

//        ObsY2 <= 350;
//        ObsX2 <= 150;
   
	
    else if (keycode != 8'h0) 
    begin
        // Ball moves based on key input
        Ball_Y_Motion <= Ball_Y_Motion_next; 
        Ball_X_Motion <= Ball_X_Motion_next;
        BallY <= Ball_Y_next;
        BallX <= Ball_X_next;
    end
    
    // Obstacles move independently
    Obs_Y_Motion <= Obs_Y_Motion_next;
    Obs_X_Motion <= Obs_X_Motion_next;
    ObsY <= Obs_Y_next;
    ObsX <= Obs_X_next;

//    Obs_Y2_Motion <= Obs_Y2_Motion_next;
//    Obs_X2_Motion <= Obs_X2_Motion_next;
//    ObsY2 <= Obs_Y2_next;
//    ObsX2 <= Obs_X2_next;
    
    
    //
       
    //
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
 
  
      


//IDEA
	//if(level == 1)
		//instatiate 4 obstacles
		//move in the vertical direction
		//hard code where these balls should start and speed
		// obstacle obs1(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX),
		// 	.OBSY(ObsY),
		// 	.OBS_size(obs1_size),
		//	.OBS_speed(speed)
		// );
		// obstacle obs2(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// obstacle obs3(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// obstacle obs3(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
	// if(level == 2)
		//instatiate 8 obstacles
		//move 4 verticle direction and other 4 in the horizontal direction
		//hard code where these balls should start and speed
		// lvl2_obstacle obs1(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX),
		// 	.OBSY(ObsY),
		// 	.OBS_size(obs1_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs2(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs3(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs4(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// lvl2_obstacle obs5(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX),
		// 	.OBSY(ObsY),
		// 	.OBS_size(obs1_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs6(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs7(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl2_obstacle obs8(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
	// if(level == 3)
		// instantiate 10 obstacles
		//move 4 verticle direction and  4 in the horizontal direction and 2 in the diagonal direction
		//hard code where these balls should start and speed
		// lvl3_obstacle obs1(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX),
		// 	.OBSY(ObsY),
		// 	.OBS_size(obs1_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs2(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs3(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs4(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// lvl3_obstacle obs5(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX),
		// 	.OBSY(ObsY),
		// 	.OBS_size(obs1_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs6(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs7(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs8(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// lvl3_obstacle obs9(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
		// );
		// lvl3_obstacle obs10(
		// 	.Reset(Reset),
		// 	.frame_clk(frame_clk),
		// 	.position_x(320),
		// 	.position_y(240),
		// 	.OBSX(ObsX2),
		// 	.OBSY(ObsY2),
		// 	.OBS_size(obs2_size),
		//	.OBS_speed(speed)
    

  
      
endmodule
