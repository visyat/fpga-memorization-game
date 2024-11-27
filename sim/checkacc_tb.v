module randnum_tb;
    reg rst;
    wire [15:0] randInt;

    reg [15:0] userInt;
    wire correct;

    randnum randnum_mod(
        .rst(rst),
        .randInt(randInt)
    );
    checkInput check_mod(
        .userInt(userInt),
        .randInt(randInt),
        .correct(correct)
    );

    initial begin
        rst = 1;
        #5 rst = 0;

        forever begin
            userInt = randInt + 1;
            #10 userInt = randInt;
            #2;
        end
    end
endmodule