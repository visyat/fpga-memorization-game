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

    clockdiv clockdivMod (
        .clk(clk),
        .rst(btnR),
        .fastClk(fastClk),
        .blinkClk(blinkClk)
    );

    // Remaining Modules: 
    // 1. Random Number Gen + Storage/Memory
    // 2. Recieving/debouncing Keyboard Data
    // 3. Display 
    

endmodule