module bin_to_bcd(
    input  [12:0] binary,       // 13-bit input (0 to 8191)
    output reg [3:0] thousands, // BCD digit 3
    output reg [3:0] hundreds,  // BCD digit 2
    output reg [3:0] tens,      // BCD digit 1
    output reg [3:0] ones       // BCD digit 0
);
    integer i;
    reg [3:0] t, h, te, o;

    always @(*) begin
        // Initialize all BCD digits to 0
        t  = 4'd0;
        h  = 4'd0;
        te = 4'd0;
        o  = 4'd0;

        // Double Dabble: shift 13 bits one by one
        for (i = 12; i >= 0; i = i - 1) begin
            // Add 3 if any BCD digit >= 5
            if (t  >= 5) t  = t  + 3;
            if (h  >= 5) h  = h  + 3;
            if (te >= 5) te = te + 3;
            if (o  >= 5) o  = o  + 3;

            // Shift left by 1
            t  = {t[2:0],  h[3]};
            h  = {h[2:0],  te[3]};
            te = {te[2:0], o[3]};
            o  = {o[2:0],  binary[i]};
        end

        thousands = t;
        hundreds  = h;
        tens      = te;
        ones      = o;
    end
endmodule