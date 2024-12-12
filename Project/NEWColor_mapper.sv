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
                       output logic [3:0]  Red, Green, Blue, collision, collision2,
                       output logic finish_line_reached, reset_player
                       );
    
    logic ball_on;
    ////
    logic obs_on;
     logic obs_on2;
    ////

////////////////////////////////////////////SQUARE
parameter X_MIN = 39;                  // left border of display area
parameter X_MAX = 599;                  // right border of display area
parameter Y_MAX = 479;                  // bottom border of display area
parameter Y_MIN = 0;                  // top border of display area
 parameter SQUARE_SIZE = 16;             // width of square sides in pixels
parameter SQUARE_VELOCITY_POS = 2;      // set position change value for positive direction
parameter SQUARE_VELOCITY_NEG = -2;     // set position change value for negative direction  

wire refresh_tick;
assign refresh_tick = ((DrawY == 481) && (DrawX == 0)) ? 1 : 0;

 // square boundaries and position
    wire [9:0] sq_x_l, sq_x_r;              // square left and right boundary
    wire [9:0] sq_y_t, sq_y_b;              // square top and bottom boundary
    
    reg [9:0] sq_x_reg, sq_y_reg;           // regs to track left, top position
    wire [9:0] sq_x_next, sq_y_next;        // buffer wires
    
    reg [9:0] x_delta_reg, y_delta_reg;     // track square speed
    reg [9:0] x_delta_next, y_delta_next;   // buffer regs    
    
    // register control
    always @(posedge clk or posedge reset)
        if(reset) begin
            sq_x_reg <= 0;
            sq_y_reg <= 0;
            x_delta_reg <= 10'h002;
            y_delta_reg <= 10'h002;
        end
        else begin
            sq_x_reg <= sq_x_next;
            sq_y_reg <= sq_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
        end
    
    // square boundaries
    assign sq_x_l = sq_x_reg;                   // left boundary
    assign sq_y_t = sq_y_reg;                   // top boundary
    assign sq_x_r = sq_x_l + SQUARE_SIZE - 1;   // right boundary
    assign sq_y_b = sq_y_t + SQUARE_SIZE - 1;   // bottom boundary
    
    // square status signal
    wire sq_on;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) &&
                   (sq_y_t <= y) && (y <= sq_y_b);
                   
    // new square position
    assign sq_x_next = (refresh_tick) ? sq_x_reg + x_delta_reg : sq_x_reg;
    assign sq_y_next = (refresh_tick) ? sq_y_reg + y_delta_reg : sq_y_reg;
    
    // new square velocity 
    always @* begin
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
        if(sq_y_t < 1)                              // collide with top display edge
            y_delta_next = SQUARE_VELOCITY_POS;     // change y direction(move down)
        else if(sq_y_b > Y_MAX)                     // collide with bottom display edge
            y_delta_next = SQUARE_VELOCITY_NEG;     // change y direction(move up)
        else if(sq_x_l < 1)                         // collide with left display edge
            x_delta_next = SQUARE_VELOCITY_POS;     // change x direction(move right)
        else if(sq_x_r > X_MAX)                     // collide with right display edge
            x_delta_next = SQUARE_VELOCITY_NEG;     // change x direction(move left)
    end
    

    



	
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
    
    int ObsDistX2, ObsDistY2;
     assign ObsDistX2 = DrawX - ObsX2;
    assign ObsDistY2 = DrawY - ObsY2;
    //////
  
  //COLLISION DETECTION
always_comb begin
        // Check for collision between the player and obstacle
        if ((BallX + Ball_size > ObsX - Ball_size) && (BallX - Ball_size < ObsX + Ball_size) && 
            (BallY + Ball_size > ObsY - Ball_size) && (BallY - Ball_size < ObsY + Ball_size)) begin
            collision = 1; // Collision occurred
        end 
        else if (BallX >= 320)
            finish_line_reached = 1;
	else begin
            collision = 0; // No collision
        end
    end
//
  
   // 2 COLLISION DETECTION
always_comb begin
        // Check for collision between the player and obstacle
        if ((BallX + Ball_size > ObsX2 - Ball_size) && (BallX - Ball_size < ObsX2 + Ball_size) && 
            (BallY + Ball_size > ObsY2 - Ball_size) && (BallY - Ball_size < ObsY2 + Ball_size)) begin
            collision2 = 1; // Collision occurred
        end 
	else begin
            collision2 = 0; // No collision
        end
    end
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
     always_comb
    begin:Obs_on_proc2
        if ( (ObsDistX2*ObsDistX2 + ObsDistY2*ObsDistY2) <= (Size * Size) )
            obs_on2 = 1'b1;
        else 
            obs_on2 = 1'b0;
     end 
     ////
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) begin 
            Red = 4'h0;
            Green = 4'hf;
            Blue = 4'h0;
       end
	if(sq_on) 
		begin
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

             Red = background-(4'h3 - (DrawX&200)/2- (DrawY&100)/2); 
             Green = background-(4'h4 - (DrawX%300)/2 - (DrawY%200)/2);
             Blue = background-(4'h6 - (DrawX%200)/2 - (DrawY&100)/2);       
        end 
    end
endmodule
