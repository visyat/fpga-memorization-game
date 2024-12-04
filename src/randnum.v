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
    
  	reg start = 1;
  	
  	reg [4:0] data1;
  	wire feedback1 = data1[4] ^ data1[1];

  	reg [4:0] data2;
  	wire feedback2 = data2[3] ^ data2[1];
  
  	reg [4:0] data3;
 	wire feedback3 = data3[3] ^ data3[2];
  
  	reg [4:0] data4;
  	wire feedback4 = data4[4] ^ data4[2];

  	always @(posedge clk)
      if (rst && start) begin
        data1 <= 4'b1111;
        data2 <= 4'b1110;
        data3 <= 4'b1101;
        data4 <= 4'b1100;
        
        start = 0;
      end else begin
        data1 <= {data1[3:0], feedback1};
        data2 <= {data2[3:0], feedback2};
        data3 <= {data3[3:0], feedback3};
        data4 <= {data4[3:0], feedback4};
        
        if (data1 <= 4'd9) begin
          num1 <= data1;
        end
        if (data2 <= 4'd9) begin
          num2 <= data2;
        end
        if (data3 <= 4'd9) begin
          num3 <= data3;
        end
        if (data4 <= 4'd9) begin
          num4 <= data4;
        end
      end
endmodule

module randnum (
    clk,
    rst,
    randInt
);
  	input clk;
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
    always @(posedge clk) begin
        if (rst) begin
            storeRand = {num4,num3,num2,num1};
        end
        randInt <= storeRand;
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