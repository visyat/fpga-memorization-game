`timescale 1ns / 1ps

module clockdiv (
    clk,
    rst,
    fastClk,
    blinkClk,
    readClk
);
    input clk;
    input rst; 

    output reg fastClk;
    output reg blinkClk;

    reg [31:0] fastCounter;
    reg [31:0] blinkCounter;
    reg [31:0] readCounter;

    always @(posedge clk) begin
        //Fast ==> 50-700 Hz 
        if (rst) begin
            fastCounter <= 0;
            fastClk <= 0;
        end
        else if (fastCounter == 200000) begin // 250 Hz 
            fastCounter <= 0;
            fastClk <= ~fastClk;
        end 
        else begin
            fastCounter <= fastCounter + 1;
        end

        //Blink ==> 2 Hz
        if (rst) begin
            blinkCounter <= 0;
            blinkClk <= 0;
        end
        else if (blinkCounter == 25000000) begin
            blinkCounter <= 0;
            blinkClk <= ~blinkClk;
        end 
        else begin
            blinkCounter <= blinkCounter + 1;
        end

        if (rst) begin
            readCounter <= 0;
            readClk <= 0;
        end
        else if (readCounter == 100000) begin
            readCounter <= 0;
            readClk <= ~readClk;
        end 
        else begin
            readCounter <= readCounter + 1;
        end
    end
endmodule