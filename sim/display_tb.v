module randnum_tb;
    reg clk;
    wire fastClk;
    wire blinkClk;
    wire readClk;
    
    reg rst;
    wire [15:0] randInt;

    reg [15:0] userInt;
    reg ready;

    wire correct;
    reg displayPhase;

    wire an;
    wire seg;

    clockdv clockdiv_mod(
        .clk(clk),
        .rst(rst),
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .readClk(readClk)
    );
    randnum randnum_mod(
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
        rst <= 1;
        #10 rst <= 0;

        clk <= 0;
        displayPhase <= 1;

        forever begin
            #10 clk <= ~clk;
        end
    end
endmodule