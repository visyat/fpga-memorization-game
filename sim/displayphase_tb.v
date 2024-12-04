module displayphase_tb;
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
    end
    always @(*) begin
        #5 clk <= ~clk;
    end
endmodule