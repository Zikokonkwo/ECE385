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
		       input  logic [7:0] font_data,
		       input   logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[601];
                       output logic [3:0]  Red, Green, Blue
		      output [10:0]	sprit_addr);
    
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
	// assign glyphX = drawX/ 8;
	// assign glyphY = drawY/ 16;
	// // Determine VRAM register address to access
	// assign register_address = (glyphY * 20) + (glyphX / 4);
	//  // Calculate byte offset within the register
 //    	assign byte_offset = glyphX % 4;

 //    	// Extract glyph byte from VRAM data at register_address
 //    	assign glyph_byte = (slv_regs[register_address] >> (byte_offset * 8)) & 8'hFF;


	assign byte_num = (drawX /8);
	assign register_col = (drawX/32);
	assign register_row = (drawY/16);

	assign register_num = (20) * (register_row) + register_col;

	//find the glyph coordinates
	assign glyph = byte_num % 4;
	assign byte_num = 4 * register_num;
	assign byte_row = byte_num / 80;
	assign byte_col = byte_num % 80;
	
	logic invert, glyphLine;
	logic [2:0] FGD_RGB, BKG_RGB;
	
	assign FGD_R = slv_regs[600][24:21];
	assign FGD_G = slv_regs[600][20:17];
	assign FGD_B = slv_regs[600][16:13];
	
	assign BKG_R = slv_regs[600][12:9];
	assign BKG_G = slv_regs[600][16:13];
	assign BKG_B = slv_regs[600][12:9];
	
/////////////////////////////////////////////////
 		if (invert){
			assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
			assign FGD_G = slv_regs[600][8:5];
			assign FGD_B = slv_regs[600][4:1]; 

			assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
			assign BKG_G = slv_regs[600][20:17];
			assign BKG_B = slv_regs[600][16:13]; 
			
			    else
				    assign BKG_R = slv_regs[600][24:21];
				    assign BKG_G = slv_regs[600][20:17];
				    assign BKG_B = slv_regs[600][16:13]; 

				    assign FGD_R = slv_regs[600][12:9];
				    assign FGD_G = slv_regs[600][8:5];
				    assign FGD_B = slv_regs[600][4:1];
	
		    }
///////////////////////////////////////////////////
	case (byte_num)
            0: begin
	            assign invert = slv_regs[register_num][7] ;
		    assign glyphLine = font_data[((slv_regs[register_num][6:0])*16)+(drawY%16)];
		    
		    if (glyphLine[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
		    {
			    Red = FGD_R;
			    Blue = FGD_B;
			    Green = FGD_G;

			    else 
			    	  Red = BKG_R;
			          Blue = BKG_B;
			   	  Green = BKG_G;
		    } 
		    
            end
            1: begin
		    slv_regs[register_num][15:8]; 
            end
            2: begin
		    slv_regs[register_num][23:16]; 
            end
            3: begin
		    slv_regs[register_num][31:24]; 
            end
            default: begin
		    slv_regs[register_num][0]; 
            end
        endcase

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

