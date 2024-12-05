`timescale 1ns / 1ps

module game (
    clk,
    rst,
    btnR,
    btnS,
    J1,
    J2,
    J3,
    J4,
    J7,
    J8,
    J9,
    J10,
    an,
    seg
);
    input J7;
    input J8;
    input J9;
    input J10;
    output J1;
    output J2;
    output J3;
    output J4;
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
        .rst(rst_db),
        .clk(clk),
        .displayPhase(displayPhase)
    );
    clockdiv clockdiv_mod (
        .clk(clk),
        .rst(rst_db),
        .fastClk(fastClk),
        .blinkClk(blinkClk)
    );
    randnum randnum_mod(
        .clk(clk),
        .rst(rst_db),
        .randInt(randInt)
    );

    keyboard_decoder keyboard_decoder(
        .clk(fastClk),
        .J7(J7),
        .J8(J8),
        .J9(J9),
        .J10(J10),
        .rst(rst_db),
        .J1(J1),
        .J2(J2),
        .J3(J3),
        .J4(J4),
        .value(userInt),
        .valueReady(ready)
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
        .userInput(userInt),
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