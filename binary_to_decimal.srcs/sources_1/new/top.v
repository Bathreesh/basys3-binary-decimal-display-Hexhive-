module top(
    input        clk,          // W5  - 100MHz system clock
    input  [13:0] sw,          // 14 switches SW13..SW0
    output [3:0] an,           // 7-seg anodes
    output [6:0] seg           // 7-seg segments
);
    wire clk_display;
    wire [3:0] thousands, hundreds, tens, ones;

    // 1. Clock divider - generate display refresh clock
    clock_divider clk_div (
        .clk_100MHz (clk),
        .clk_display(clk_display)
    );

    // 2. Binary to BCD - convert switch value to decimal digits
    bin_to_bcd converter (
        .binary   (sw[12:0]),    // 13-bit input → 0 to 8191
        .thousands(thousands),
        .hundreds (hundreds),
        .tens     (tens),
        .ones     (ones)
    );

    // 3. Display controller - drive the 4-digit 7-segment display
    seg7_controller display (
        .clk_display(clk_display),
        .thousands  (thousands),
        .hundreds   (hundreds),
        .tens       (tens),
        .ones       (ones),
        .an         (an),
        .seg        (seg)
    );
endmodule