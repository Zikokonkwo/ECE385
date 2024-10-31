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


module  color_mapper ( input  logic [9:0] DrawX, DrawY,
		       input   logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[601];
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on;
	 
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
	  
    // int DistX, DistY, Size;
    // assign DistX = DrawX - BallX;
    // assign DistY = DrawY - BallY;
    // assign Size = Ball_size;
  
    // always_comb
    // begin:Ball_on_proc
    //     if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
    //         ball_on = 1'b1;
    //     else 
    //         ball_on = 1'b0;
    //  end 
       
    // always_comb
    // begin:RGB_Display
    //     if ((ball_on == 1'b1)) begin 
    //         Red = 4'hf;
    //         Green = 4'h7;
    //         Blue = 4'h0;
    //     end       
    //     else begin 
    //         Red = 4'hf - DrawX[9:6]; 
    //         Green = 4'hf - DrawX[9:6];
    //         Blue = 4'hf - DrawX[9:6];
    //     end      
    // end 

   //psuedocode:
	//Calculate glyph coordinates from pixel coordinates
	assign glyphX = drawX/ 8;
	assign glyphY = drawY/ 16;
	// Determine VRAM register address to access
	assign register_address = (glyphY * 20) + (glyphX / 4);
	 // Calculate byte offset within the register
    	assign byte_offset = glyphX % 4;

    	// Extract glyph byte from VRAM data at register_address
    	assign glyph_byte = (slv_regs[register_address] >> (byte_offset * 8)) & 8'hFF;

	//  Determine RGB values based on glyph_byte
    always_comb begin: RGB_Display
        if () begin 
            // Display Ball Color
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end else begin 
            // Display Color Based on Glyph Byte
            if (glyph_byte[DrawY % 16]) begin // Assuming glyph_byte bit pattern maps directly to pixels
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'hf;
            end else begin
                // Background Color (Gray Gradient)
                Red = 4'hf - DrawX[9:6];
                Green = 4'hf - DrawX[9:6];
                Blue = 4'hf - DrawX[9:6];
            end
        end
    end

    
endmodule

