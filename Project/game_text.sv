module game_text(
    input clk,
    input [3:0] fail_dig0, fail_dig1, level_dig0, level_dig1,
    input [9:0] drawX, drawY,
    output text_on,
  output reg [11:0] text_rgb
);

//signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr, char_addr_s, char_addr_l, char_addr_r, char_addr_o;
    reg [3:0] row_addr;
    wire [3:0] row_addr_s, row_addr_l, row_addr_r, row_addr_o;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_s, bit_addr_l, bit_addr_r, bit_addr_o;
    wire [7:0] ascii_word;
    wire ascii_bit, score_on, logo_on, rule_on, over_on;
    wire [7:0] rule_rom_addr;

//Display Fail and Level Region
    assign fail_on  = (drawY >= 32) && (drawY < 64) && (drawX[9:4] < 16);
    assign row_addr_s = drawY[4:1];
   assign bit_addr_s = drawX[3:1];
   always @* begin
    case (x[7:4])
        4'h0 : char_addr_s = 7'h46;     // F (Fail)
        4'h1 : char_addr_s = 7'h41;     // A
        4'h2 : char_addr_s = 7'h49;     // I
        4'h3 : char_addr_s = 7'h4c;     // L
        4'h4 : char_addr_s = 7'h3A;     // :
        4'h5 : char_addr_s = {3'b011, fail_dig1};    // tens digit of fail count
        4'h6 : char_addr_s = {3'b011, fail_dig0};    // ones digit of fail count
        4'h7 : char_addr_s = 7'h00;     // Space (padding or unused)
        4'h8 : char_addr_s = 7'h4c;     // L (Level)
        4'h9 : char_addr_s = 7'h45;     // E
        4'hA : char_addr_s = 7'h56;     // V
        4'hB : char_addr_s = 7'h45;     // E
        4'hC : char_addr_s = 7'h4c;     // L
        4'hD : char_addr_s = 7'h3A;     // :
        4'hE : char_addr_s = {3'b011, level_dig1};   // tens digit of level
        4'hF : char_addr_s = {3'b011, level_dig0};   // ones digit of level
        default : char_addr_s = 7'h00; // Default case (blank/space)
    endcase
end

//Display Game Start Region
 always @* begin
        text_rgb = 12'h0FF;     // aqua background
        
        if(score_on) begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if(ascii_bit)
                text_rgb = 12'hF00; // red
        end
 end
    
 assign text_on = {score_on, logo_on, rule_on, over_on};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
  
endmodule
