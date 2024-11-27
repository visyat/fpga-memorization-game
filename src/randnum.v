module randnum (
    rst,
    randInt
);
    input rst;
    output reg [15:0] randInt;

    reg [15:0] storeRand;

    always @(*) begin
        if (rst) begin
            storeRand[3:0] = $urandom%9;
            storeRand[7:4] = $urandom%9;
            storeRand[11:8] = $urandom%9;
            storeRand[15:12] = $urandom%9;
        end
        randInt = storeRand;
    end
endmodule

module checkInput(
    userInt,
    randInt,
    correct
);
    input [15:0] userInt;
    input [15:0] randInt; 
    
    output reg correct;

    always @(*) begin
        if (userInt == randInt) begin
            correct <= 1;
        end else begin
            correct <= 0;
        end
    end
endmodule