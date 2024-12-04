module enterphase_tb;
    reg clk;
    wire fastClk;
    wire blinkClk;
    
    reg rst;
    wire [15:0] randInt;

    reg [15:0] userInt;
    reg ready;

    wire correct;
    reg displayPhase;

    wire [3:0] an;
    wire [6:0] seg;

    clockdiv clockdiv_mod(
        .clk(clk),
        .rst(rst),
        .fastClk(fastClk),
        .blinkClk(blinkClk)
    );
    randnum randnum_mod(
        .clk(clk),
        .rst(rst),
        .randInt(randInt)
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
        .rst(rst), 
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .anodeActivate(an),
        .LED_out(seg)
    );

    initial begin
        clk <= 0;
        rst <= 1;
        #130 rst <= 0;

        displayPhase <= 0;
        ready <= 0;
//        userInt <= randInt;
        userInt <= 16'hFF12;
    end
    always #5 clk <= ~clk;
endmodule