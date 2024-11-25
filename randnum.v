module randnum (
    rst,
    randInt
);
    input rst;
    output reg [13:0] randInt;

    always (*) begin
        if (rst) begin
            randInt = $urandom%9999;
        end
    end

endmodule