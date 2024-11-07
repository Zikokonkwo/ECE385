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


module  color_mapper ( input  logic [9:0] drawX, drawY,
		       input  logic [31:0] slv_regs[600:0],
		       output logic [3:0]  Red, Green, Blue
		     );

    logic ball_on;
    logic [10:0] sprite_addr;
    logic [7:0] font_data; 

    logic invert;
    logic [2:0] FGD_R, FGD_G, FGD_B, BKG_R, BKG_G, BKG_B;

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

		
font_rom font(
	.addr(sprite_addr),
	.data(font_data)
);

	// Calculate VRAM and glyph coordinates
    logic [8:0] register_num;
    logic [7:0] char_sel, character;
    logic glyphLine;
//    logic [3:0] FGD_R, FGD_G, FGD_B;
//    logic [3:0] BKG_R, BKG_G, BKG_B;
    
    // Set control register and character select based on inputs
    assign control_reg = slv_regs[600];
    assign char_sel = drawX % 32;

    // Determine register, character, inversion, and sprite address
    assign register_num = (drawX / 32) + (20 * (drawY / 16));
    assign character =  slv_regs[register_num][14:8] * 16;
    assign invert =  slv_regs[register_num][15];
//assign invert = 1;
    assign sprite_addr = character + (drawY % 16);
logic byte_num, glyph;
    // Extract foreground and background colors from control register
    
//    assign FGD_R = slv_regs[600][24:21];
//    assign FGD_G = slv_regs[600][20:17];
//    assign FGD_B = slv_regs[600][16:13];
    
//    assign BKG_R = slv_regs[600][12:9];
//    assign BKG_G = slv_regs[600][8:5];
//    assign BKG_B = slv_regs[600][4:1];
	assign reg_addr = (drawX/32) + (drawY/16) * 20;
	assign char_num = (dtawx%32)/8;
	assign control_reg = slv_reg[reg_addr][8*char_num +:];
	assign sprite_addr = sprite_code[6:0]*16 + drawY%16;
	
	font_rom font(.addr(sprite_addr), .data(sprite_data));

	assign pixel_data = sprite_data[7-drawX%8];

	always_comb
begin
    // Check if inversion is enabled
    if (invert)  // assuming 'invert' is a signal or flag indicating if inversion is enabled
    begin
        // Inverted case: Swap foreground and background colors
        if (pixel_data ^ sprite_code[7] == 1)  // Check for background (0 in font data)
        begin
            Red   = control_reg[12:9];   // Background color
            Green = control_reg[8:5];
            Blue  = control_reg[4:1];
        end
        else  // Foreground (1 in font data)
        begin
            Red   = control_reg[24:21];  // Foreground color
            Green = control_reg[20:17];
            Blue  = control_reg[16:13];
        end
    end
    else  // Non-inverted case: Regular foreground/background
    begin
        // Normal case: Use the standard foreground and background colors
        if (pixel_data ^ sprite_code[7] == 1)  // Background
        begin
            Red   = control_reg[24:21];   // Foreground color
            Green = control_reg[20:17];
            Blue  = control_reg[16:13];
        end
        else  // Foreground
        begin
            Red   = control_reg[12:9];    // Background color
            Green = control_reg[8:5];
            Blue  = control_reg[4:1];
        end
    end
end

    
    
    
    assign FGD_R = 4'b0011;
    assign FGD_G = 4'b0000;
    assign FGD_B = 4'b1100;
    
    assign BKG_R = 4'b1100;
    assign BKG_G = 4'b0000;
    assign BKG_B = 4'b0011;

    // Determine glyph line based on font data and inversion
    assign glyphLine = font_data[sprite_addr];

    // Assign RGB based on glyph line and inversion
        always_comb begin
        if (font_data[3'b111 - drawX[2:0]] ^ invert) begin
            // If invert is active, assign background colors to foreground and vice versa
 	    Red   = FGD_R;
            Green = FGD_G;
            Blue  = FGD_B;
        end else begin
            // Draw background color
            Red   = BKG_R;
            Green = BKG_G;
            Blue  = BKG_B;
        end
    end


//case (glyph) 
//0: begin
// assign character =  slv_regs[register_num][6:0] * 16;
//    assign invert =  slv_regs[register_num][7];
//end

//1: begin
// assign character =  slv_regs[register_num][14:8] * 16;
//    assign invert =  slv_regs[register_num][15];
//end

//2: begin
// assign character =  slv_regs[register_num][22:16] * 16;
//    assign invert =  slv_regs[register_num][23];
//end

//3: begin
// assign character =  slv_regs[register_num][30:24] * 16;
//    assign invert =  slv_regs[register_num][31];
//end

//endcase
 







	assign byte_num = (drawX /8);
// 	logic byte_num;
// 	assign register_col = (drawX/32);
// 	assign register_row = (drawY/16);

// 	assign register_num = (20) * (register_row) + register_col;

// 	//find the glyph coordinates
 	assign glyph = byte_num % 4;/////////////////////////////////////////
// //	assign byte_num = 4 * register_num;
// 	assign byte_row = byte_num / 80;
// 	assign byte_col = byte_num % 80;
	
	
// 	assign FGD_R = slv_regs[600][24:21];
// 	assign FGD_G = slv_regs[600][20:17];
// 	assign FGD_B = slv_regs[600][16:13];
	
// 	assign BKG_R = slv_regs[600][12:9];
// 	assign BKG_G = slv_regs[600][16:13];
// 	assign BKG_B = slv_regs[600][12:9];
	
// 		if (invert) begin
//			assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
//			assign FGD_G = slv_regs[600][8:5];
//			assign FGD_B = slv_regs[600][4:1]; 

//			assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
//			assign BKG_G = slv_regs[600][20:17];
//			assign BKG_B = slv_regs[600][16:13]; 
//			end
//			    else begin
//				    assign BKG_R = slv_regs[600][24:21];
//				    assign BKG_G = slv_regs[600][20:17];
//				    assign BKG_B = slv_regs[600][16:13]; 

//				    assign FGD_R = slv_regs[600][12:9];
//				    assign FGD_G = slv_regs[600][8:5];
//				    assign FGD_B = slv_regs[600][4:1];
	
	// 	    end
	// case (byte_num)
 //            0: begin
 //            assign byte_num = (drawX /8);
	//             assign invert = slv_regs[register_num][7] ;
	            
	//             if (invert) begin
	// 		assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
	// 		assign FGD_G = slv_regs[600][8:5];
	// 		assign FGD_B = slv_regs[600][4:1]; 

	// 		assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
	// 		assign BKG_G = slv_regs[600][20:17];
	// 		assign BKG_B = slv_regs[600][16:13]; 
	// 		end
	// 		    else begin
	// 			    assign BKG_R = slv_regs[600][24:21];
	// 			    assign BKG_G = slv_regs[600][20:17];
	// 			    assign BKG_B = slv_regs[600][16:13]; 

	// 			    assign FGD_R = slv_regs[600][12:9];
	// 			    assign FGD_G = slv_regs[600][8:5];
	// 			    assign FGD_B = slv_regs[600][4:1];
	            
	// 	    assign addr_in = ((slv_regs[register_num][6:0])*16)+(drawY%16);
		    
	// 	    if (font_data[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
	// 	    begin
	// 		    assign Red = FGD_R;
	// 		    assign Blue = FGD_B;
	// 		    assign Green = FGD_G;
 //            end
	// 		    else begin
	// 		    	  assign Red = BKG_R;
	// 		          assign Blue = BKG_B;
	// 		   	  assign Green = BKG_G;
	// 	      end
		    
 //            end
 //            1: begin
	// 	   // slv_regs[register_num][15:8]; 

	// 	    assign invert = slv_regs[register_num][15] ;
		    
	// 	    if (invert) begin
	// 		assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
	// 		assign FGD_G = slv_regs[600][8:5];
	// 		assign FGD_B = slv_regs[600][4:1]; 

	// 		assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
	// 		assign BKG_G = slv_regs[600][20:17];
	// 		assign BKG_B = slv_regs[600][16:13]; 
	// 		end
	// 		    else begin
	// 			    assign BKG_R = slv_regs[600][24:21];
	// 			    assign BKG_G = slv_regs[600][20:17];
	// 			    assign BKG_B = slv_regs[600][16:13]; 

	// 			    assign FGD_R = slv_regs[600][12:9];
	// 			    assign FGD_G = slv_regs[600][8:5];
	// 			    assign FGD_B = slv_regs[600][4:1];
		    
	// 	    assign addr_in = ((slv_regs[register_num][14:8])*16)+(drawY%16);
		    
	// 	    if (font_data[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
	// 	    begin
	// 		    assign Red = FGD_R;
	// 		    assign Blue = FGD_B;
	// 		    assign Green = FGD_G;
 //            end
	// 		    else begin
	// 		    	  assign Red = BKG_R;
	// 		          assign Blue = BKG_B;
	// 		   	  assign Green = BKG_G;
	// 	    end
		    
 //            end
 //            2: begin
	// 	  //  slv_regs[register_num][23:16]; 


	// 	    assign invert = slv_regs[register_num][23] ;
		    
	// 	    if (invert) begin
	// 		assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
	// 		assign FGD_G = slv_regs[600][8:5];
	// 		assign FGD_B = slv_regs[600][4:1]; 

	// 		assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
	// 		assign BKG_G = slv_regs[600][20:17];
	// 		assign BKG_B = slv_regs[600][16:13]; 
	// 		end
	// 		    else begin
	// 			    assign BKG_R = slv_regs[600][24:21];
	// 			    assign BKG_G = slv_regs[600][20:17];
	// 			    assign BKG_B = slv_regs[600][16:13]; 

	// 			    assign FGD_R = slv_regs[600][12:9];
	// 			    assign FGD_G = slv_regs[600][8:5];
	// 			    assign FGD_B = slv_regs[600][4:1];
		    
	// 	    assign addr_in = ((slv_regs[register_num][22:16])*16)+(drawY%16);
		    
	// 	    if (font_data[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
	// 	    begin
	// 		    assign Red = FGD_R;
	// 		    assign Blue = FGD_B;
	// 		    assign Green = FGD_G;
 //            end 
	// 		    else begin
	// 		    	  assign Red = BKG_R;
	// 		          assign Blue = BKG_B;
	// 		   	  assign Green = BKG_G;
	// 	    end
		    
            
		    
 //            end
 //            3: begin
	// 	  //  slv_regs[register_num][31:24]; 

	// 	    assign invert = slv_regs[register_num][31] ;
		    
	// 	    if (invert) begin
	// 		assign FGD_R = slv_regs[600][12:9];//FOREGROUND IS NOW BACKGROUND
	// 		assign FGD_G = slv_regs[600][8:5];
	// 		assign FGD_B = slv_regs[600][4:1]; 

	// 		assign BKG_R = slv_regs[600][24:21]; //BACKGROUND IS NOw FOREGROUND
	// 		assign BKG_G = slv_regs[600][20:17];
	// 		assign BKG_B = slv_regs[600][16:13]; 
	// 		end
	// 		    else begin
	// 			    assign BKG_R = slv_regs[600][24:21];
	// 			    assign BKG_G = slv_regs[600][20:17];
	// 			    assign BKG_B = slv_regs[600][16:13]; 

	// 			    assign FGD_R = slv_regs[600][12:9];
	// 			    assign FGD_G = slv_regs[600][8:5];
	// 			    assign FGD_B = slv_regs[600][4:1];
		    
	// 	    assign addr_in = ((slv_regs[register_num][30:24])*16)+(drawY%16);
		    
	// 	    if (font_data[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
	// 	    begin
	// 		    assign Red = FGD_R;
	// 		    assign Blue = FGD_B;
	// 		    assign Green = FGD_G;
 //            end
	// 		    else begin
	// 		    	  assign Red = BKG_R;
	// 		          assign Blue = BKG_B;
	// 		   	  assign Green = BKG_G;
	// 	    end
		    
 //            end
 //            default: begin
	// 	 assign Red = BKG_R;
	// 	assign Blue = BKG_B;
	// 	assign Green = BKG_G; 

	// 	assign Red = FGD_R;
	// 	assign Blue = FGD_B;
	// 	assign Green = FGD_G;
 //            end
 //        endcase


    
endmodule
