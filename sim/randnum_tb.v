module randnum_tb;
    reg rst;
    wire [15:0] randInt;

    randnum randnum_mod(
        .rst(rst),
        .randInt(randInt)
    );

    initial begin
        forever begin
            rst = 0;
            #10 rst = 1;
            #1;
        end
    end
endmodule