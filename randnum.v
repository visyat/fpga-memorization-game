module randnum (
    rst,
    randInt
);
    input rst;
    output reg [13:0] randInt;

    reg [13:0] storeRand;

    always (*) begin
        if (rst) begin
            storeRand = $urandom%9999;
        end
        randInt = storeRand;
    end
endmodule

module checkInput(
    userInt,
    randInt,
    correct
);
    input [13:0] userInt;
    input [13:0] randInt; 
    
    output reg correct;

    always(*) begin
        if (userInt == randInt) begin
            correct <= 1;
        end else begin
            correct <= 0;
        end
    end
endmodule