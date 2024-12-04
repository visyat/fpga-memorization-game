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
        clk <= 0;
        rst <= 1;
        #130 rst <= 0;
//        forever begin
//            rst = 0;
//            #10 rst = 1;
//            #1;
//        end
    end
    always #5 clk <= ~clk;
endmodule