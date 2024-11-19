module sprite_control (
    input logic clk, reset,
    input logic [7:0] key_code,  // USB keyboard scancode
    output logic [9:0] sprite_x, sprite_y
);
    localparam UP = 8'h75, DOWN = 8'h72, LEFT = 8'h6B, RIGHT = 8'h74;

    // Initial sprite position
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sprite_x <= 10'd320; // Center X
            sprite_y <= 10'd240; // Center Y
        end else begin
            case (key_code)
                UP:    sprite_y <= sprite_y - 1; // Move up
                DOWN:  sprite_y <= sprite_y + 1; // Move down
                LEFT:  sprite_x <= sprite_x - 1; // Move left
                RIGHT: sprite_x <= sprite_x + 1; // Move right
                default: ; // No movement
            endcase
        end
    end
endmodule

