`timescale 1ns / 1ps

module game (
    clk,
    rst,
    btnR,
    btnS,
    an,
    seg
);
    input clk;
    input rst;
    input btnR;
    input btnS;

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

    // parse keyboard data 
        // 1. debouncers for keyboard buttons
        // 2. load characters into some module 
    /*
    module userInputLoader(
        ...
        .userInt(userInt),
        .ready(ready)
    );
    */

    checkInput check_mod(
        .userInt(userInt),
        .randInt(randInt),
        .correct(correct)
    );
    display display_mod(
        .displayPhase(displayPhase), // PENDING
        .correct(correct), 
        .randInt(randInt),
        .userInput(userInput), // PENDING
        .inputReady(ready), // PENDING
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
          end
        end
    end

endmodule