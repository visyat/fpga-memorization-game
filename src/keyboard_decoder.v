module keyboard_decoder (
    input clk,          // Master clock signal
    input [3:0] row,          // Row signals from the keyboard (active low)
    input rst,
    output reg [15:0] value,   // 16-bit value to store the last 4 pressed digits (4 * 4-bit values)
    output reg valueReady,
    output reg [3:0] col
);

    reg [1:0] selector = 0;   // Selector for scanning different rows (4 rows)
    reg [3:0] curr_value = 15;
    reg [31:0] collect_input_timer = 0;
    reg [3:0] LAG_timer = 0;
    always @(posedge clk) begin
        if (rst) begin
            value <= 16'hFFFF;
            valueReady <= 0;
            collect_input_timer <= 0;
            curr_value <= 15;
        end
        else if (!valueReady) begin
            collect_input_timer <= collect_input_timer + 1; 
            selector <= selector + 1;
            LAG_timer <= LAG_timer + 1;
            case(selector)
                2'b00: begin 
                    col <= 4'b0111;
                    if(LAG_timer == 4'b1111) begin
                        case(row)
                            4'b0111: curr_value <= 4'b0001; // 1
                            4'b1011: curr_value <= 4'b0100; // 4
                            4'b1101: curr_value <= 4'b0111; // 7
                            4'b1110: curr_value <= 4'b0000; // 0
                        endcase
                    end
                end
                2'b01: begin 
                    col <= 4'b1011;
                    if(LAG_timer == 4'b1111) begin
                        case(row)
                            4'b0111: curr_value <= 4'b0010; // 2
                            4'b1011: curr_value <= 4'b0101; // 5
                            4'b1101: curr_value <= 4'b1000; // 8
                        endcase
                    end
                end
                2'b10: begin 
                    col <= 4'b1101;
                    if(LAG_timer == 4'b1111) begin
                        case(row)
                            4'b0111: curr_value <= 4'b0011; // 3
                            4'b1011: curr_value <= 4'b0110; // 6
                            4'b1101: curr_value <= 4'b1001; // 9
                        endcase
                    end
                end
                default: col <= 4'b1111; // Default: all columns high
            endcase
        end

        if (collect_input_timer == 100000) begin
            if (curr_value != 15 && valueReady != 1) begin
                value <= {value[11:0], curr_value};
                curr_value <= 15;
                if (value[3:0] != 15 && value[7:4] != 15 && value[11:8] != 15 && value[15:12] != 15) begin
                    valueReady <= 1;
                end
            end
            collect_input_timer <= 0;
        end
    end
endmodule