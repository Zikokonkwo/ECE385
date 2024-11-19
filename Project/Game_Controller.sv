typedef enum logic [1:0] {LEVEL1, LEVEL2, LEVEL3, GAME_OVER} game_state_t;

module game_state_machine (
    input logic clk, reset, sprite_collision, finish_line_reached,
    output logic [1:0] current_level,
    output logic reset_level
);
    game_state_t state, next_state;

    // State Transition Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            state <= LEVEL1;
        else 
            state <= next_state;
    end

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
            end
            LEVEL2: begin
                if (sprite_collision) 
                    reset_level = 1;
                else if (finish_line_reached)
                    next_state = LEVEL3;
            end
            LEVEL3: begin
                if (sprite_collision) 
                    reset_level = 1;
                else if (finish_line_reached)
                    next_state = GAME_OVER;
            end
            GAME_OVER: begin
                // Handle Game Over logic (restart or idle)
                if (reset)
                    next_state = LEVEL1;
            end
        endcase
    end

    // Output current level
    assign current_level = state;
endmodule

