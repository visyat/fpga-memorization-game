`timescale 1ns / 1ps

module game (
    clk,
    rst,
    btnR,
    btnS,
    rows,
    cols,
    an,
    seg
);
    input [3:0] rows;
    output [3:0] cols;
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

    wire rst_db;
    wire displayPhase;

    rst_debouncer rst_db_mod (
        .rst(btnR), 
        .clk(clk),
        .rst_db(rst_db)
    );
    phaseChange phase_mod (
        .rst(btnR),
        .clk(clk),
        .displayPhase(displayPhase)
    );
    clockdiv clockdiv_mod (
        .clk(clk),
        .rst(btnR),
        .fastClk(fastClk),
        .blinkClk(blinkClk)
    );
    randnum randnum_mod(
        .clk(clk),
        .rst(rst_db),
        .randInt(randInt)
    );

    keyboard_decoder keyboard_decoder(
        .clk(clk),
        .rst(btnR),
        .row(rows),
        .valueReady(ready),
        .value(userInt),
        .col(cols)
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
        .rst(btnR), 
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .anodeActivate(anWire),
        .LED_out(segWire)
    );

    always @(*) begin
        an = anWire;
        seg = segWire;
    end

endmodule