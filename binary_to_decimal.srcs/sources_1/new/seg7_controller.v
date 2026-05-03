module seg7_controller(
    input        clk_display,
    input  [3:0] thousands,
    input  [3:0] hundreds,
    input  [3:0] tens,
    input  [3:0] ones,
    output reg [3:0] an,   // anodes  (active LOW)
    output reg [6:0] seg   // segments(active LOW) gfedcba
);
    reg [1:0] sel = 0;
    reg [3:0] digit;

    // Rotate digit selector
    always @(posedge clk_display)
        sel <= sel + 1;

    // Pick which digit to drive
    always @(*) begin
        case (sel)
            2'b00: begin an = 4'b1110; digit = ones;      end
            2'b01: begin an = 4'b1101; digit = tens;      end
            2'b10: begin an = 4'b1011; digit = hundreds;  end
            2'b11: begin an = 4'b0111; digit = thousands; end
        endcase
    end

    // 7-segment decoder — decimal digits 0-9 only
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // blank
        endcase
    end
endmodule