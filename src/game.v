`timescale 1ns / 1ps

module game (
    clk,
    rst,
    btnR,
    btnS,
    PS2Clk,
    PS2Data,
    an,
    seg
);
    input clk;
    input rst;
    input btnR;
    input btnS;

    input PS2Clk;
    input PS2Data;

    output reg [3:0] an;
    output reg [6:0] seg;

    wire [3:0] anWire;
    wire [6:0] segWire;

    wire fastClk;
    wire blinkClk;
    wire readClk;

    wire [15:0] randInt;

    wire [15:0] userInt;
    wire ready;

    wire correct;

    reg displayPhase;
    reg [29:0] displayDelay;

    clockdiv clockdiv_mod (
        .clk(clk),
        .rst(rst),
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .readClk(readClk)
    );
    randnum randnum_mod (
        .rst(rst),
        .randInt(randInt)
    );

    keyboard keyboard_mod(
        .clk(clk),
        .rst(rst),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data),
        .ready(ready),
        .userInt(userInt)
    );
    checkInput check_mod(
        .userInt(userInt),
        .randInt(randInt),
        .correct(correct)
    );
    display display_mod(
        .displayPhase(displayPhase),
        .correct(correct), 
        .randInt(randInt),
        .userInput(userInput),
        .inputReady(ready),
        .rst(rst), 
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .anodeActivate(anWire),
        .LED_out(segWire)
    );

    always @(*) begin
        an = anWire;
        seg = segWire
    end
    always @(posedge clk) begin
        if (rst) begin
            displayPhase = 1;
            displayDelay = 0;
        end else begin
          if (displayDelay == 500000000) begin
            displayPhase = 0;
          end else if (displayDelay < 500000000) begin
            displayDelay = displayDelay + 1;
          end
        end
    end

endmodule