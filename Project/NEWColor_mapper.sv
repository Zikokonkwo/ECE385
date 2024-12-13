
//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size, ObsX, ObsY, ObsX2, ObsY2,
                       input logic [3:0] foreground, background,
                       input logic [1:0] current_level,
                       output logic [3:0]  Red, Green, Blue, 
                       output logic finish_line_reached, reset_player, collision, collision2
                       );
    
    logic ball_on;
    ////
    logic obs_on;
     logic obs_on2;
    ////
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
    
    ///////
    int ObsDistX, ObsDistY;
    assign ObsDistX = DrawX - ObsX;
    assign ObsDistY = DrawY - ObsY;
    
//    int ObsDistX2, ObsDistY2;
//     assign ObsDistX2 = DrawX - ObsX2;
//    assign ObsDistY2 = DrawY - ObsY2;
    //////
  
  //COLLISION DETECTION
always_comb begin
        // Check for collision between the player and obstacle
        if ((BallX + Ball_size > ObsX - Ball_size) && (BallX - Ball_size < ObsX + Ball_size) && 
            (BallY + Ball_size > ObsY - Ball_size) && (BallY - Ball_size < ObsY + Ball_size)) begin
            collision = 1; // Collision occurred
        end 
	else begin
            collision = 0; // No collision
        end
         if ((BallX >= 580)) 
            finish_line_reached = 1;//removed collision = 0 below
            
            //

            //
            else  
            finish_line_reached = 0;
    end
//
  
   // 2 COLLISION DETECTION
//always_comb begin
//        // Check for collision between the player and obstacle
//        if ((BallX + Ball_size > ObsX2 - Ball_size) && (BallX - Ball_size < ObsX2 + Ball_size) && 
//            (BallY + Ball_size > ObsY2 - Ball_size) && (BallY - Ball_size < ObsY2 + Ball_size)) begin
//            collision2 = 1; // Collision occurred
//        end 
//	else begin
//            collision2 = 0; // No collision
//        end
//    end
//
  
  
  //
   // O L D    COLLISION DETECTION
//always_comb begin
//        // Check for collision between the player and obstacle
//        if ((BallX + Ball_size > ObsX) && (BallX < ObsX + Ball_size) && 
//            (BallY + Ball_size > ObsY) && (BallY < ObsY + Ball_size)) begin
//            collision = 1; // Collision occurred
//        end 
//	else begin
//            collision = 0; // No collision
//        end
//    end
//
  //
  
  logic [3:0] red, green, blue;
   always_comb begin
     red = 4'hF; // Default background color
     green = 4'h0; // Default foreground color
     blue = 4'h0;
	if(foreground == 3 && background == 3) 
		begin 
			red = 4'h5; 
    			green = 4'h3; 
			blue = 4'h3;
		end
	else if(foreground == 6 &&  background == 6)
		begin
			red = 4'h6; 
    			green = 4'h4; 
			blue = 4'h2
		end
	else if(foreground == 10 &&  background == 10)
		begin
			red = 4'hF; 
    			green = 4'h3; 
			blue = 4'h6
		end
   end
  
//  always_comb
//begin
//    $display("Ball Position: (%0d, %0d), Obstacle1 Position: (%0d, %0d), Obstacle2 Position: (%0d, %0d)",
//             BallX, BallY, ObsX, ObsY, ObsX2, ObsY2);
//end  
  
    always_comb
    begin:Ball_on_proc
        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
     
     ////
     //99999999999999999999999999999999999999999
     always_comb
    begin:Obs_on_proc
        if ( (ObsDistX*ObsDistX + ObsDistY*ObsDistY) <= (Size * Size) )
            obs_on = 1'b1;
        else 
            obs_on = 1'b0;
     end 
     //99999999999999999999999999999999999999999999999999999
     ////
     ////
//     always_comb
//    begin:Obs_on_proc2
//        if ( (ObsDistX2*ObsDistX2 + ObsDistY2*ObsDistY2) <= (Size * Size) )
//            obs_on2 = 1'b1;
//        else 
//            obs_on2 = 1'b0;
//     end 
     ////
       
//     always_comb
//     begin:RGB_Display
//         if ((ball_on == 1'b1)) begin 
//             Red = 4'h0;
//             Green = 4'hf;
//             Blue = 4'h0;
//        end
//             else if (obs_on == 1'b1) begin
// //             Red = background-(4'he);
// //            Green = background-(4'h1);
// //            Blue = background-(4'h1);

// //
//              Red = (background)-(4'he);
//             Green = (background)-(4'h1);
//             Blue = (background)-(4'h1);
// //
//         end 
//             else if ((DrawX <= 50) || (DrawX >= 590)) begin
//                          Red = 4'h0;
//                          Green = 4'h6;
//                          Blue = 4'h1;
//                       end
// //        else if ((obs_on2) == 1'b1) begin
// //             Red = 4'h0;
// //            Green = 4'h0;
// //            Blue = 4'h9;
// //        end 
        
//             else begin
// //                Red = 4'hf - DrawX[9:6] - DrawY[9:6]; 
// //             Green = 4'hf - DrawX[9:6] - DrawY[9:6];
// //             Blue = 4'hf - DrawX[9:6] - DrawY[9:6]; 
  
// //             Red = 4'h3 - DrawX[7:6] - DrawY[7:6]; 
// //             Green = 4'h4 - DrawX[7:6] - DrawY[7:6];
// //             Blue = 4'h6 - DrawX[7:6] - DrawY[7:6];  

// //             Red = background-(4'h3 - (DrawX&200)/2- (DrawY%100)/2); 
// //             Green = background-(4'h4 - (DrawX%300)/2 - (DrawY%200)/2);
// //             Blue = background-(4'h6 - (DrawX%200)/2 - (DrawY%100)/2);  
             
//              //
//              Red = (background)-(4'h3 - (DrawX&200)/(2*background)- (DrawY%100)/2); 
//              Green = (background)-(4'h4 - (DrawX%300)/(2*background) - (DrawY%200)/2);
//              Blue = (background)-(4'h6 - (DrawX%200)/(2*background) - (DrawY%100)/2); 
//              //     
//         end 
//     end
always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) begin 
            Red = 4'h0;
            Green = 4'hf;
            Blue = 4'h0;
       end
	 if (obs_on == 1'b1) begin //((obs_on || obs_on2) == 1'b1)
             Red = foreground-(4'hf);
            Green = foreground-(4'h1);
            Blue = foreground-(4'h1);
        end 
            else begin
//                Red = 4'hf - DrawX[9:6] - DrawY[9:6]; 
//             Green = 4'hf - DrawX[9:6] - DrawY[9:6];
//             Blue = 4'hf - DrawX[9:6] - DrawY[9:6]; 
  
//             Red = 4'h3 - DrawX[7:6] - DrawY[7:6]; 
//             Green = 4'h4 - DrawX[7:6] - DrawY[7:6];
//             Blue = 4'h6 - DrawX[7:6] - DrawY[7:6];  

	    Red = (red - (DrawX&200)/2- (DrawY&100)/2); 
	    Green = (green - (DrawX%300)/2 - (DrawY%200)/2);
	    Blue = (blue - (DrawX%200)/2 - (DrawY&100)/2);       
        end 
    end
endmodule
