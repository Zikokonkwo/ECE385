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
    input logic clk, reset,
    output logic [3:0] Red, Green, Blue,
    output logic finish_line_reached, reset_player, collision, collision2
);

    logic ball_on, obs_on, obs_on2, square_on;
    logic [9:0] SquareX, SquareY; // Position of the bouncing square
    logic signed [9:0] Square_X_Motion, Square_Y_Motion; // Motion step for the square
    logic [9:0] SquareSize = 10'd20; // Size of the square

    // Initialize square direction and position
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            SquareX <= 10'd300;
            SquareY <= 10'd200;
            Square_X_Motion <= 10'd1; // Initial motion in X
            Square_Y_Motion <= 10'd1; // Initial motion in Y
        end else begin
            // Update square position based on motion
            SquareX <= SquareX + Square_X_Motion;
            SquareY <= SquareY + Square_Y_Motion;

            // Bounce logic for the square
            if ((SquareY + SquareSize) >= 10'd430) begin
                Square_Y_Motion <= -Square_Y_Motion; // Bottom edge
            end else if (SquareY <= 10'd50) begin
                Square_Y_Motion <= -Square_Y_Motion; // Top edge
            end

            if ((SquareX + SquareSize) >= 10'd590) begin
                Square_X_Motion <= -Square_X_Motion; // Right edge
            end else if (SquareX <= 10'd50) begin
                Square_X_Motion <= -Square_X_Motion; // Left edge
            end
        end
    end

    // Determine if pixel is part of the square
    always_comb begin
        if ((current_level == 2'b10) &&
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
