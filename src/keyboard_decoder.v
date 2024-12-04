module keyboard_decoder (
    input clk,          // Master clock signal
    input J7,
    input J8,
    input J9,
    input J10,
    input rst,
    output J1,
    output J2,
    output J3,
    output J4,
    output reg [15:0] value,   // 16-bit value to store the last 4 pressed digits (4 * 4-bit values)
    output reg valueReady,
);
    reg pressed;
    reg number;

    initial begin
        value <= 16'b1111111111111111;
        valueReady <= 0;
    end

    pmodkpd pmodkpd(
        .J7(J7),
        .J8(J8),
        .J9(J9),
        .J10(J10),
        .slow_clk(clk),
        .J1(J1),
        .J2(J2),
        .J3(J3),
        .J4(J4),
        .outnum(number),
        .pressed(pressed)
    );
    always @ (posedge clk) begin
        if(rst) begin
            value <= 16'b1111111111111111;
            valueReady <= 0;
        end
    end
    always @ (negedge pressed) begin

        else begin
            if (number <= 9 && number >= 0) begin
                value <= {value[11:0], number};
                if (value[3:0] != 15 && value[7:4] != 15 && value[11:8] != 15 && value[15:12] != 15) begin
                    valueReady <= 1;
                end
            end
        end
    end
endmodule