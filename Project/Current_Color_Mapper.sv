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

module color_mapper (
    input logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size, ObsX, ObsY, ObsX2, ObsY2,
    input logic [3:0] foreground, background,
    input logic [1:0] current_level,
    input logic frame_clk, reset,
    output logic [3:0] Red, Green, Blue,
    output logic finish_line_reached, reset_player, collision, collision2
);

    parameter [9:0] SQ_X_Min=49;       // Leftmost point on the X axis
    parameter [9:0] SQ_X_Max=589;     // Rightmost point on the X axis
    parameter [9:0] SQ_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] SQ_Y_Max=479;     // Bottommost point on the Y axis
    
    logic ball_on, obs_on, obs_on2, square_on;
    logic [9:0] SquareX, SquareY; // Position of the square
    logic [9:0] SquareSize = 10'd20; // Size of the square

    ////
	 logic collision0, collision1;
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
    
    always_comb begin
        // Check for collision between the player and obstacle
        if ((BallX + Ball_size > ObsX - Ball_size) && (BallX - Ball_size < ObsX + Ball_size) && 
            (BallY + Ball_size > ObsY - Ball_size) && (BallY - Ball_size < ObsY + Ball_size)) begin
            collision0 = 1; // Collision occurred
        end 
	if (!((BallX + Ball_size > ObsX - Ball_size) && (BallX - Ball_size < ObsX + Ball_size) && 
            (BallY + Ball_size > ObsY - Ball_size) && (BallY - Ball_size < ObsY + Ball_size))) begin
            collision0 = 0; // No collision
        end
         if ((BallX >= 580)) 
            finish_line_reached = 1;//removed collision = 0 below
//          
            
            //

            //
            if (BallX <= 579)
            finish_line_reached = 0;
    end
//
    

    // Initialize square position
    always_ff @(posedge frame_clk) begin
        if (reset) begin
            SquareX <= 10'd300; // Fixed X position
            SquareY <= 10'd200; // Fixed Y position
        end
    end

    // Determine if pixel is part of the square
    always_comb begin
        if ((current_level == 2'b00) &&
            (DrawX >= SquareX && DrawX < SquareX + SquareSize) &&
            (DrawY >= SquareY && DrawY < SquareY + SquareSize)) begin
            square_on = 1'b1;
        end else begin
            square_on = 1'b0;
        end
    end

    // Ball-on logic
    always_comb begin: Ball_on_proc
        if (((DrawX - BallX) * (DrawX - BallX) + (DrawY - BallY) * (DrawY - BallY)) <= (Ball_size * Ball_size))
            ball_on = 1'b1;
        else
            ball_on = 1'b0;
    end

    // Obstacle-on logic
    always_comb begin: Obs_on_proc
        if (((DrawX - ObsX) * (DrawX - ObsX) + (DrawY - ObsY) * (DrawY - ObsY)) <= (Ball_size * Ball_size))
            obs_on = 1'b1;
        else
            obs_on = 1'b0;
    end

    // Collision detection logic between ball and square
    always_comb begin: Collision_detection
        if ((BallX + Ball_size) >= SquareX && (BallX - Ball_size) < (SquareX + SquareSize) &&
            (BallY + Ball_size) >= SquareY && (BallY - Ball_size) < (SquareY + SquareSize)) begin
            collision1 = 1'b1;
        end else begin
            collision1 = 1'b0;
        end
    end
    always_comb begin
        if(collision0 == 1 || collision1 == 1)
            begin
                collision = 1;
            end
    end
    // RGB Display logic
    always_comb begin: RGB_Display
        if (ball_on == 1'b1) begin
            Red = 4'h0;
            Green = 4'hF;
            Blue = 4'h0;
        end else if (obs_on == 1'b1) begin
            Red = (background / 2) - 4'hE;
            Green = background - 4'h1;
            Blue = background - 4'h1;
        end else if (square_on == 1'b1) begin
            Red = 4'hF;
            Green = 4'h0;
            Blue = 4'h0;
        end else if ((DrawX <= 10'd50) || (DrawX >= 10'd590)) begin
            Red = 4'h0;
            Green = 4'h6;
            Blue = 4'h1;
        end else begin
            Red = (background) - (4'h3 - (DrawX & 10'd200) / (2 * background) - (DrawY % 10'd100) / 2);
            Green = (background) - (4'h4 - (DrawX % 10'd300) / (2 * background) - (DrawY % 10'd200) / 2);
            Blue = (background) - (4'h6 - (DrawX % 10'd200) / (2 * background) - (DrawY % 10'd100) / 2);
        end
    end
endmodule
