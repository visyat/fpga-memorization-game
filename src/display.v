module display(
    displayPhase,
    correct, 
    randInt,
    userInput,
    inputReady,
    rst, 
    fastClk,
    blinkClk,
    anodeActivate,
    LED_out
);
    input displayPhase;
    input correct;

    input [15:0] randInt;
    input wire [15:0] userInput;
    input inputReady;
    
    input rst;
    input fastClk;
    input blinkClk;

    output reg [3:0] anodeActivate;
    output reg [6:0] LED_out;

    reg blinkState;

    reg [3:0] LED_BCD;
    wire [1:0] digitSelect;
    reg [1:0] digitCounter;

    always @(posedge fastClk or posedge rst) begin
        if (rst)
            digitCounter <= 2'b00;
        else
            digitCounter <= digitCounter + 1;
    end
    assign digitSelect = digitCounter;
    always @(posedge blinkClk or posedge rst) begin
        if(rst) begin
            blinkState <= 0; 
        end else if (displayPhase) begin
            blinkState <= ~blinkState;
        end else begin
            blinkState <= 0;
        end
    end
    
    always @(*) begin
        if (blinkState) begin
            anodeActivate = 4'b1111;
        end else if (displayPhase) begin
            case (digitSelect)
                2'b00: begin
                    anodeActivate = 4'b0111;
                    LED_BCD = randInt[15:12];
                end
                2'b01: begin
                    anodeActivate = 4'b1011;
                    LED_BCD = randInt[11:8];
                end
                2'b10: begin
                    anodeActivate = 4'b1101;
                    LED_BCD = randInt[7:4];
                end
                2'b11: begin
                    anodeActivate = 4'b1110;
                    LED_BCD = randInt[3:0];
                end
            endcase
        end else if (~displayPhase && ~inputReady) begin
            case (digitSelect)
                2'b00: begin
                    anodeActivate = 4'b0111;
                    LED_BCD = userInput[15:12];
                end
                2'b01: begin
                    anodeActivate = 4'b1011;
                    LED_BCD = userInput[11:8];
                end
                2'b10: begin
                    anodeActivate = 4'b1101;
                    LED_BCD = userInput[7:4];
                end
                2'b11: begin
                    anodeActivate = 4'b1110;
                    LED_BCD = userInput[3:0];
                end
            endcase
        end else begin
            if (correct) begin // print "YES"
                case (digitSelect)
                2'b00: begin
                    anodeActivate = 4'b0111;
                    LED_BCD = 4'b1010;
                end
                2'b01: begin
                    anodeActivate = 4'b1011;
                    LED_BCD = 4'b1011;
                end
                2'b10: begin
                    anodeActivate = 4'b1101;
                    LED_BCD = 4'b1100;
                end
                2'b11: begin
                    anodeActivate = 4'b1111;
                    LED_BCD = 4'b0000;
                end
            endcase
            end else begin // print "NO"
                case (digitSelect)
                2'b00: begin
                    anodeActivate = 4'b0111;
                    LED_BCD = 4'b1101;
                end
                2'b01: begin
                    anodeActivate = 4'b1011;
                    LED_BCD = 4'b1110;
                end
                2'b10: begin
                    anodeActivate = 4'b1111;
                    LED_BCD = 4'b0000;
                end
                2'b11: begin
                    anodeActivate = 4'b1111;
                    LED_BCD = 4'b0000;
                end
            endcase
            end
        end
    end
    always @(*) begin
        case(LED_BCD)
            4'b0000: LED_out = 7'b1000000; // "0"     
            4'b0001: LED_out = 7'b1111001; // "1" 
            4'b0010: LED_out = 7'b0100100; // "2" 
            4'b0011: LED_out = 7'b0110000; // "3" 
            4'b0100: LED_out = 7'b0011001; // "4" 
            4'b0101: LED_out = 7'b0010010; // "5" 
            4'b0110: LED_out = 7'b0000010; // "6" 
            4'b0111: LED_out = 7'b1111000; // "7" 
            4'b1000: LED_out = 7'b0000000; // "8"     
            4'b1001: LED_out = 7'b0010000; // "9"
            4'b1010: LED_out = 7'b0010001; // "Y"
            4'b1011: LED_out = 7'b0000110; // "E"
            4'b1100: LED_out = 7'b0010010; // "S"
            4'b1101: LED_out = 7'b1001000; // "N"
            4'b1110: LED_out = 7'b1000000; // "O"
            4'b1111: LED_out = 7'b1111111; // 
            default: LED_out = 7'b1111111;
        endcase
    end

endmodule