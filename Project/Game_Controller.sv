typedef enum logic [1:0] {LEVEL1, LEVEL2, LEVEL3, GAME_OVER} game_state_t;

module game_state_machine (
    input logic clk, reset, sprite_collision, finish_line_reached, BallX, BallY, sprite_location, finish_line,
    output logic [3:0] foreground, background,
    output logic [1:0] current_level, speed, obstacle_count,
    output logic reset_level
);
    game_state_t state, next_state;

    // State Transition Logic
    always_ff @(posedge clk or posedge reset) begin
	    if (reset | reset_level) 
            state <= LEVEL1;
	    else if (sprite_location = obstacle_location)
	    	sprite_collision = 1'b1; // sprite collided with obstacle and must reset
	    else if (sprite_location = finish_line)
			finish_line_reached = 1'b1; //sprite reached teh finish line and level advances
			    else
	  			 state <= next_state;
    end

//State control signals/////////////////////////

    always_comb
	begin 
		// Default controls signals
		speed = 2'b00; //clears obstacle speed until defined in each level
        	background = 4'b0000; // defaults the background color to use 0 as its color data reference
        	foreground= 4'b0000; // defaults the foreground color to use 0 as its color data reference
       	 	obstacle_count = 2'b00; // initializes the projectile count multiplier to 0

		case (state)
			LEVEL1 : 
				begin 
		                speed = 2'b01; //obstacle speed is initially slow
                        	background = 4'b0001; // sets the background color to use 1 as its color data reference
                        	foreground= 4'b0001; // sets the foreground color to use 1 as its color data reference
                        	obstacle_count = 2'b01: // obstacle count multiplier is initially 1
            
				end
			LEVEL2 : 
				begin 
		                speed = 2'b10; //obstacle speed is twice the initial speed
                        	background = 4'b0010; // sets the background color to use 2 as its color data reference
                        	foreground= 4'b0010; // sets the foreground color to use 2 as its color data reference
                        	obstacle_count = 2'b10: // obstacle count multiplier is 2
                        
				end
			LEVEL3 : 
				begin 
		                speed = 2'b11; //obstacle speed is three times the initial speed 
                        	background = 4'b0100; // sets the background color to use 4 as its color data reference
                        	foreground= 4'b0100; // sets the foreground color to use 4 as its color data reference
                        	obstacle_count = 2'b11: // obstacle count multiplier is 3
                        
				end
			GAME_OVER : 
				begin 
                        	speed = 2'b00; // halts obstacles when game ends
                        	background = 4'b1000; // sets the background color to use 8 as its color data reference
                        	foreground= 4'b1000; // sets the foreground color to use 8 as its color data reference
                    		obstacle_count = 2'b00: // clear obstacle count multiplier when game ends
                        
				end
        endcase
    end

/////////////////////////
    
    // Next State Logic
    always_comb begin
        next_state = state; // Default to current state
        reset_level = 0;    // Default no reset

        case (state)
            LEVEL1: begin
                if (sprite_collision) 
                    reset_level = 1; // Reset the level
                else if (finish_line_reached)
                    next_state = LEVEL2; // Progress to Level 2
		    else
			    next_state = LEVEL1;
            end
            LEVEL2: begin
                if (sprite_collision) 
                    reset_level = 1;
                else if (finish_line_reached)
                    next_state = LEVEL3;
		   	 else
			     next_state = LEVEL2;
            end
            LEVEL3: begin
                if (sprite_collision) 
                    reset_level = 1;
                else if (finish_line_reached)
                    next_state = GAME_OVER;
		       else
			     next_state = LEVEL3;
            end
            GAME_OVER: begin
                // Handle Game Over logic (restart or idle)
                if (reset)
                    next_state = LEVEL1;
		       else
			     next_state = GAME_OVER;
            end
        endcase
    end

    // Output current level
    assign current_level = state;
endmodule

