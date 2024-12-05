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
    output reg valueReady
);
    wire pressed;
    wire [3:0] number;
    reg [31:0] collect_input_timer;
    reg [3:0] curr_val;
    reg [1:0] count;
    reg tempValueReady;

    initial begin
        value <= 16'hFFFF;
        valueReady <= 0;
        collect_input_timer <= 0;
        curr_val <= 15;
        count <= 0;
        tempValueReady <= 0;
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
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            value <= 16'hFFFF;
            valueReady <= 0;
            collect_input_timer <= 0;
            tempValueReady <= 0;
            curr_val <= 15;
            count <= 0;
        end
        else begin
            if (tempValueReady == 1) begin
                collect_input_timer <= collect_input_timer + 1;
                if (collect_input_timer >= 30) begin
                    valueReady <= 1;
                end
            end
            else if (pressed && number <= 9 && number >= 0 && tempValueReady != 1) begin
                curr_val <= number;
                collect_input_timer <= 0;
            end
            else if (collect_input_timer >= 110 && curr_val != 4'b1111 && tempValueReady != 1) begin
                 value <= {value[11:0], curr_val};
                  if (count == 3) begin
                    tempValueReady <= 1;
                  end
                  count <= count + 1;
                  curr_val <= 4'b1111;
                  collect_input_timer <= 0;
            end
            else if (collect_input_timer >= 111) begin
                collect_input_timer <= 0;
            end else begin
                collect_input_timer <= collect_input_timer + 1;
            end
        end
    end
    
endmodule