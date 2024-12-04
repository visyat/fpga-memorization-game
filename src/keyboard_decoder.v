module keyboard_decoder (
    input clk,          // Master clock signal
    input [3:0] row,          // Row signals from the keyboard (active low)
    input rst,
    output reg [15:0] value,   // 16-bit value to store the last 4 pressed digits (4 * 4-bit values)
    output reg valueReady
);

    reg [1:0] selector = 0;   // Selector for scanning different rows (4 rows)
    reg [3:0] curr_value = 15;
    reg [31:0] collect_input_timer = 0;
    always @(posedge clk) begin
        if (rst) begin
            value <= 16'hFFFF;
            valueReady <= 0;
            collect_input_timer <= 0;
            curr_value <= 15;
        end
        if (!valueReady) begin
            collect_input_timer <= collect_input_timer + 1; 
            selector <= selector + 1;
            case(selector)
                2'b00: begin 
                    case(row)
                        4'b0111: curr_value <= 4'b0001; // 1
                        4'b1011: curr_value <= 4'b0100; // 4
                        4'b1101: curr_value <= 4'b0111; // 7
                        4'b1110: curr_value <= 4'b0000; // 0
                    endcase
                end
                2'b01: begin 
                    case(row)
                        4'b0111: curr_value <= 4'b0010; // 2
                        4'b1011: curr_value <= 4'b0101; // 5
                        4'b1101: curr_value <= 4'b1000; // 8
                    endcase
                end
                2'b10: begin 
                    case(row)
                        4'b0111: curr_value <= 4'b0011; // 3
                        4'b1011: curr_value <= 4'b0110; // 6
                        4'b1101: curr_value <= 4'b1001; // 9
                    endcase
                end
            endcase
        end

        if (collect_input_timer == 100000) begin
            if (curr_value != 15) begin
                value <= {value[11:0], curr_value};
                curr_value <= 15;
            end
            if (value[0] != 15 && value[1] != 15 && value[2] != 15 && value[3] != 15) begin
                valueReady <= 1;
            end
        end
    end
endmodule