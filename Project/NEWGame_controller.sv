typedef enum logic [1:0] {LEVEL1, LEVEL2, LEVEL3, GAME_OVER} game_state_t;

module game_state_machine (
    input logic clk, reset, ObsX, ObsY, Ball_size, finish_line_reached, collision,
    output logic [3:0] foreground, background,
    output logic [1:0] current_level, speed, obstacle_count,
    output logic reset_level, reset_player, speedX, speedY
//    output logic [9:0] BallX, BallY
);
    game_state_t state, next_state;


logic sprite_collision;



    // State Transition Logic
    always_ff @(posedge clk or posedge reset) begin
	    if (reset || reset_level) begin
            state <= LEVEL1;
            
//            BallX <= 20;//ADDED
//            BallY <= 240;//ADDED
 
//	    else if ((BallX + Ball_size > ObsX - Ball_size) && (BallX - Ball_size < ObsX + Ball_size) && 
//            (BallY + Ball_size > ObsY - Ball_size) && (BallY - Ball_size < ObsY + Ball_size)) 
//	    	sprite_collision <= 1'b1; // sprite collided with obstacle and must reset
	    	
	   
//         end else if (reset_player) begin
//                     BallX <= 20;//ADDED
//                     BallY <= 240;//ADDED
         
//         end
         end else
	  			 state <= next_state;
    end
//State control signals/////////////////////////

    always_comb
	begin 
		// Default controls signals
		speedX = 2'b01; //clears obstacle speed until defined in each level
		speedY = 2'b01; //obstacle speed is twice the initial speed
        	background = 4'b0101; // defaults the background color to use 0 as its color data reference
        	foreground= 4'b0001; // defaults the foreground color to use 0 as its color data reference
       	 	obstacle_count = 2'b00; // initializes the projectile count multiplier to 0

		case (state)
			LEVEL1 : 
				begin 
		                speedX = 2'b10; //obstacle speed is initially slow
		                speedY = 2'b01; //obstacle speed is twice the initial speed
                        	background = 4'b0011; // sets the background color to use 1 as its color data reference
                        	foreground= 4'b0010; // sets the foreground color to use 1 as its color data reference
                        	obstacle_count = 2'b01; // obstacle count multiplier is initially 1
            
				end
			LEVEL2 : 
				begin //000000000000000000  MADE COLOR SAME AS LEVEL BEOFER TO CEHCK 00000000000000000000000000000000000000000000000000
		                speedX = 2'b01; //obstacle speed is twice the initial speed
		                 speedY = 2'b11; //obstacle speed is twice the initial speed
                        	background = 4'b0101; // sets the background color to use 2 as its color data reference
                        	foreground= 4'b0100; // sets the foreground color to use 2 as its color data reference
                        	obstacle_count = 2'b10; // obstacle count multiplier is 2
                        
				end
			LEVEL3 : 
				begin 
		                speedX = 2'b11; //obstacle speed is three times the initial speed 
		                speedY = 2'b11; //obstacle speed is twice the initial speed
                        	background = 4'b1110; // sets the background color to use 4 as its color data reference
                        	foreground= 4'b1000; // sets the foreground color to use 4 as its color data reference
                        	obstacle_count = 2'b11; // obstacle count multiplier is 3
                        
				end
			GAME_OVER : 
				begin 
                        	speedX = 2'b00; // halts obstacles when game ends
                        	speedY = 2'b00; //obstacle speed is twice the initial speed
                        	background = 4'b0000; // sets the background color to use 8 as its color data reference
                        	foreground= 4'b0000; // sets the foreground color to use 8 as its color data reference
                    		obstacle_count = 2'b00; // clear obstacle count multiplier when game ends
                        
				end
        endcase
    end

/////////////////////////
    
    // Next State Logic
    always_comb begin
       
        next_state = state; // Default to current state 



//     reset_level = 0;    // Default no reset  //move this into each else statement fo the levels????????????????????????????




        case (state)
            LEVEL1: begin
                if (collision) begin
                    reset_level = 1;
                    next_state = LEVEL1;
                     // Reset the level
                end else if (finish_line_reached)begin
                    reset_player = 1;
                    next_state = LEVEL2; // Progress to Level 2
                    
                    end
		    else
			    next_state = LEVEL1;
			    reset_player = 0;
            end
            LEVEL2: begin
                if (collision) begin
                    reset_level = 1;
                    next_state = LEVEL1;
                end else if (finish_line_reached)begin
                  reset_player = 1;
                    next_state = LEVEL3;
                  
		   	end else
			     next_state = LEVEL2;
			     reset_player = 0;
            end
            LEVEL3: begin
                if (collision) begin
                    reset_level = 1;
                    next_state = LEVEL1;
                end else if (finish_line_reached)
                    next_state = GAME_OVER;
		       else
			     next_state = LEVEL3;
			     reset_player = 0;
            end
            GAME_OVER: begin
                // Handle Game Over logic (restart or idle)
                if (reset)
                    next_state = LEVEL1;
		       else
			     next_state = GAME_OVER;
			     reset_player = 0;
            end
        endcase
    end

    // Output current level
    assign current_level = state;
endmodule

