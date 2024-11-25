`timescale 1ns / 1ps

module game (
    clk, 
    PS2Clk,
    PS2Data,
    btnS,
    btnR,
    an,
    seg
);
    input clk;
    input PS2Clk;
    input PS2Data;
    input btnS;
    input btnR; 

    reg manualRst;
    assign btnR = manualRst;

    output reg [3:0] an;
    output reg [6:0] seg;

    wire [3:0] anWire;
    wire [6:0] segWire;

    wire [31:0] keyInput;

    // state registers 
    reg gameOn; 
    reg displayPhase;
    reg enterPhase;

    wire fastClk;
    wire blinkClk;

    wire [15:0] randInt;
    wire correct;

    clockdiv clockdivMod (
        .clk(clk),
        .rst(btnR),
        .fastClk(fastClk),
        .blinkClk(blinkClk)
    );
    randnum randMod (
        .rst(btnR),
        .randInt(randInt)
    );
    //insert modules

    checkInput checkMod (
        .userInput(),
        .randInt(randInt),
        .correct(correct)
    );
    display displayMod (
        .displayPhase(displayPhase),
        .correct(correct), 
        .randInt(randInt),
        .userInput(),
        .inputReady(),
        .rst(btnR), 
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .anodeActivate(anWire),
        .LED_out(segWire)
    );

    // Remaining Modules: 
    // 1. Random Number Gen + Storage/Memory
    // 2. Recieving/debouncing Keyboard Data
    // 3. Wait until 4 integers have been inputed 
    // 3. Display 
    always(*) begin
        if (rst) begin
            displayPhase <= 0;
            #10 displayPhase <= 1;
        end
        if (inputReady) begin
            #10 manualRst = 1;
            #5 manualRst = 0;
        end

        an = anWire;
        seg = segWire;
    end
    
endmodule