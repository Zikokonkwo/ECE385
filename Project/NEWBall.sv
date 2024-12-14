

//////////////// N O T E S ///////////////////
//CURRENT Results: single overlapping obstacle that comes from off screen as before
/////////////////////////////////////////////


module  ball 
( 
    input  logic        Reset, speedX, speedY,
    //
    input  logic        collision,//added
     input  logic        collision2,//added
    //
    input  logic        frame_clk, reset_player, reset_level, finish_line_reached,
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
    parameter [9:0] Ball_X_Step=3;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=3;      // Step size on the Y axis
    
    
    /////
    parameter [9:0] Obs_X_Center=320;  // Center position on the X axis
    parameter [9:0] Obs_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Obs_X_Min=49;       // Leftmost point on the X axis
    parameter [9:0] Obs_X_Max=589;     // Rightmost point on the X axis
    parameter [9:0] Obs_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Obs_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Obs_X_Step=4;      // Step size on the X axis
    parameter [9:0] Obs_Y_Step=4;      // Step size on the Y axis
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
        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle  //// removed0000000000000000000000000000000000000000
        Ball_X_Motion_next = Ball_X_Motion;
        ///
        Obs_Y_Motion_next = Obs_Y_Motion;
        Obs_X_Motion_next = Obs_X_Motion;
        
        //added66666
//if (finish_line_reached) begin
//BallX <= 30;
//BallY <= 240;
//end
        
        //
//              Obs_Y2_Motion_next = Obs_Y2_Motion;
//        Obs_X2_Motion_next = Obs_X2_Motion;//added


//      ///
//      if (finish_line_reached)begin
//      BallX <= 30;
//      BallY <= 240;//added666666
//      end
//      ///
      
      
      
	if (keycode == 8'h1A) //go up
	begin
            	Ball_Y_Motion_next = -10'd3;
	    	Ball_X_Motion_next = 0;
	end
	    
	else if(keycode == 8'h16) //go down
	begin
	    	Ball_Y_Motion_next = 10'd3;
	    	Ball_X_Motion_next = 0;
	end 
	    else if(keycode == 8'h04) //move left
	begin
		Ball_Y_Motion_next = 0;
		Ball_X_Motion_next = -10'd3;
	end 
	    else if(keycode == 8'h07) //move right
	begin
		Ball_Y_Motion_next = 0;
	    	Ball_X_Motion_next = 10'd3;
	end 

        if ( (BallY + BallS + 5) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!//removed000000000000000000000000000000000000000000000000000000000000000
        begin
            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'd1);  // set to -1 via 2's complement.
        end
        else if ( (BallY - BallS - 5) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end  
       //fill in the rest of the motion equations here to bounce left and right
	if ((BallX + BallS + 5) >= Ball_X_Max) //right edge --> bounce
	begin
		Ball_X_Motion_next = (~ (Ball_X_Step) + 1'd1);  // set to -1 via 2's complement.
	end
	else if ((BallX - BallS - 5) <= Ball_X_Min) //left edge --> bounce
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
    if (Reset || collision || reset_level || finish_line_reached || reset_player || speedX)//addedRECENT speedx
    begin 
        
        // Reset ball and obstacles
        Obs_Y_Motion <= 10'd0;
        Obs_X_Motion <= 10'd0;//MAKE 0
        ObsY <= 400;
        ObsX <= 50;
        //
        Ball_Y_Motion <= 10'd0; //removed000000000000000000000000000000000000000000000000000000000000000
        Ball_X_Motion <= 10'd0;
        BallY <= 240;
        BallX <= 30;
        end
//        else if (reset_player || finish_line_reached)begin
//        BallY <= 240;
//        BallX <= 30;
//            end //removed666666
        
        



//        Obs_Y2_Motion <= 10'd0; // MAKE 0
//        Obs_X2_Motion <= 10'd0;

//        ObsY2 <= 350;
//        ObsX2 <= 150;
   
	//added RECENT999
	if (speedX) begin
	BallY <= 240;
	BallX <= 30;
	end
	
	
	
    else if (keycode != 8'h0) 
    begin
        // Ball moves based on key input
        Ball_Y_Motion <= Ball_Y_Motion_next; 
        Ball_X_Motion <= Ball_X_Motion_next;//removed000000000000000000000000000000000000000000000000000000000000000
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
