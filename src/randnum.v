module random_num_gen(
    clk,
    rst,
    num1,
    num2,
    num3,
    num4
);
    input clk;
    input rst;
    
    output reg [3:0] num1;
    output reg [3:0] num2;
    output reg [3:0] num3;
    output reg [3:0] num4;
    
    reg [5:0] data;  
    reg start = 1;
    wire feedback = data[5] ^ data[4] ^ data[3] ^ data[2];
    
    wire [3:0] raw_num1 = {2'b00, data[1:0]};
    wire [3:0] raw_num2 = {2'b00, data[3:2]};
    wire [3:0] raw_num3 = {2'b00, data[5:4]};
    wire [3:0] raw_num4 = {2'b00, (data[5:4]^data[3:2])};
    
    always @(posedge clk or posedge rst) begin
        if (rst && start) begin
            data <= 6'b1;
            num1 <= 4'd0;
            num2 <= 4'd1;
            num3 <= 4'd2;
            num4 <= 4'd3;
            start = 0;
        end else begin
            data <= {data[4:0], feedback};
            
            if (raw_num1 <= 4'd9) num1 <= raw_num1;
            if (raw_num2 <= 4'd9) num2 <= raw_num2;
            if (raw_num3 <= 4'd9) num3 <= raw_num3;
            if (raw_num4 <= 4'd9) num4 <= raw_num4;
        end
    end
endmodule

module randnum (
    clk,
    rst,
    randInt
);
    input rst;
    output reg [15:0] randInt;

    wire [3:0] num1;
    wire [3:0] num2;
    wire [3:0] num3;
    wire [3:0] num4;
    random_num_gen rand_gen_mod(
        .clk(clk),
        .rst(rst),
        .num1(num1),
        .num2(num2),
        .num3(num3),
        .num4(num4)
    );
    reg [15:0] storeRand;
    always @(*) begin
        if (rst) begin
            storeRand[3:0] = num1;
            storeRand[7:4] = num2;
            storeRand[11:8] = num3;
            storeRand[15:12] = num4;
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