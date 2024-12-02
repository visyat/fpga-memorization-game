module randnum_tb;
    reg clk;
    reg rst;
    wire [15:0] randInt;

    randnum randnum_mod(
        .clk(clk),
        .rst(rst),
        .randInt(randInt)
    );
    initial begin
        rst <= 1;
        #10 rst <= 0;

        clk <= 0;
    end
    always @(*) begin
        #5 clk <= ~clk;
    end
    always @(*) begin
        rst = 0;
        #10 rst = 1;
        #1;
    end
endmodule