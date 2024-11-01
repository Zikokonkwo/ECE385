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
		       input  logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[601];
		       output logic [3:0]  Red, Green, Blue,
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

	control_reg = slv_reg[600];
	char_sel = drawX % 32;
	register = slv_reg[drawX/32 + 20(drawY/16)];
	character = register[14:8] * 16;
	Inv = resister[15];
	sprite_addr = character + drawY % 16;


	assign byte_num = (drawX /8);
	assign register_col = (drawX/32);
	assign register_row = (drawY/16);

	assign register_num = (20) * (register_row) + register_col;

	//find the glyph coordinates
	assign glyph = byte_num % 4;
	assign byte_num = 4 * register_num;
	assign byte_row = byte_num / 80;
	assign byte_col = byte_num % 80;
	
	
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
		    assign addr_in = ((slv_regs[register_num][6:0])*16)+(drawY%16);
		    
		    if (data_out[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
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
		   // slv_regs[register_num][15:8]; 

		    assign invert = slv_regs[register_num][15] ;
		    assign addr_in = ((slv_regs[register_num][14:8])*16)+(drawY%16);
		    
		    if (data_out[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
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
            2: begin
		  //  slv_regs[register_num][23:16]; 


		    assign invert = slv_regs[register_num][23] ;
		    assign addr_in = ((slv_regs[register_num][22:16])*16)+(drawY%16);
		    
		    if (data_out[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
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
            3: begin
		  //  slv_regs[register_num][31:24]; 

		    assign invert = slv_regs[register_num][31] ;
		    assign addr_in = ((slv_regs[register_num][30:24])*16)+(drawY%16);
		    
		    if (data_out[drawX % 8])//if the specific bit in the 8 bit font data string we are drawing = 1 then draw FGD
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
            default: begin
		  Red = BKG_R;
		Blue = BKG_B;
		Green = BKG_G; 

		Red = FGD_R;
		 Blue = FGD_B;
		Green = FGD_G;
            end
        endcase


    
endmodule

