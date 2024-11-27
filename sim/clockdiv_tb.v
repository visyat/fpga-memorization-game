module clockdiv_tb;
    reg clk;
    reg rst;

    wire fastClk;
    wire blinkClk;
    wire readClk;

    clockdv clockdiv_mod(
        .clk(clk),
        .rst(rst),
        .fastClk(fastClk),
        .blinkClk(blinkClk),
        .readClk(readClk)
    );

    initial begin
        rst <= 1;
        clk <= 0;

        #10 rst <= 0;
        forever begin
            #10 clk <= ~clk;
        end
    end

endmodule