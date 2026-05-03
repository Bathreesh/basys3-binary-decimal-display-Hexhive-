module clock_divider(
    input  clk_100MHz,
    output reg clk_display
);
    reg [16:0] count = 0;

    always @(posedge clk_100MHz) begin
        if (count == 49_999) begin
            count       <= 0;
            clk_display <= ~clk_display;
        end else begin
            count <= count + 1;
        end
    end
endmodule