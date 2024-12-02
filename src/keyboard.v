module keyboard(
    clk,
    rst,
    PS2Clk,
    PS2Data,
    ready,
    userInt
);
    input clk;
    input rst;
    input PS2Clk;
    input PS2Data;

    output reg ready;
    output reg [15:0] userInt;

    wire db_ps2clk;
    wire db_ps2data;

    reg [10:0] word;
    integer i; // index for word
    integer j; // index for userInt

    debouncer db_clk(
        .clk(clk),
        .ps2clk(PS2Clk),
        .db_ps2clk(db_ps2clk)
    );
    debouncer db_kdata(
        .clk(clk),
        .ps2data(PS2Data),
        .db_ps2data(db_ps2data)
    );

    reg prev_ps2clk;
    wire falling_edge;
    
    always @(posedge clk) begin
        prev_ps2clk <= db_ps2clk;
    end
    assign falling_edge = prev_ps2clk & ~db_ps2clk;

    always @(posedge clk) begin
        if (rst) begin
            word <= 11'b0;
            userInt <= 16'b0;
            ready <= 1'b0;
            i <= 0;
            j <= 0;
        end
        else begin
            if (falling_edge) begin
                word[i] <= db_ps2data;
                i <= i+1;
                if (i == 11) begin
                    i <= 0;
                    if (~word[0] && word[10]) begin  // has accurately interpreted a word with 0 start bit and 1 end bit
                        userInt[4*j+3:4*j] <= word_to_hex(word);
                        if (j < 3)
                            j <= j+1;
                        else begin
                            j <= 0;
                            ready <= 1'b1;
                        end
                    end
                end
            end
            else if (ready) begin
                ready <= 1'b0;
            end
        end
    end

    /*
    PS2 Data sent in 11 bits ...
        PS2Data[0]: 0 (start)
        PS2Data[1:8]: scan code
        PS2Data[9]: odd parity bit ==> # of ones in the data unit is odd
        PS2Data[10]: 1 (stop) 
    
    Full PS/2 word: 0 + Scan Code + Odd Parity Bit + 1
        1: 0 + 16 (00010110) + 0 + 1 = 00001011001
        2: 0 + 1E (00011110) + 1 + 1 = 00001111011
        3: 0 + 26 (00100110) + 0 + 1 = 00010011001
        4: 0 + 25 (00100101) + 0 + 1 = 00010010101
        5: 0 + 2E (00101110) + 1 + 1 = 00010111011
        6: 0 + 36 (00110110) + 1 + 1 = 00011011011
        7: 0 + 3D (00111101) + 0 + 1 = 00011110101
        8: 0 + 3E (00111110) + 0 + 1 = 00011111001
        9: 0 + 46 (01000110) + 0 + 1 = 00100011001
        0: 0 + 45 (01000101) + 0 + 1 = 00100010101
    */
    function word_to_hex;
    input [10:0] word;
    begin
        case (word)
            11'b00001011001: word_to_hex = 4'b0001;
            11'b00001111011: word_to_hex = 4'b0010;
            11'b00010011001: word_to_hex = 4'b0011;
            11'b00010010101: word_to_hex = 4'b0100;
            11'b00010111011: word_to_hex = 4'b0101;
            11'b00011011011: word_to_hex = 4'b0110;
            11'b00011110101: word_to_hex = 4'b0111;
            11'b00011111001: word_to_hex = 4'b1000;
            11'b00100011001: word_to_hex = 4'b1001;
            11'b00100010101: word_to_hex = 4'b0000;
        endcase
    end  
    endfunction

endmodule

module debouncer(
    clk,
    I,
    O
);
    input clk;
    input I;
    output reg O;

    reg [7:0] count;
    reg Iv=0;
    
    always@(posedge clk)
        if (I == Iv) begin
            if (count == 255)
                O <= I;
            else
                count <= count + 1'b1;
        end else begin
            count <= 'b0;
            Iv <= I;
        end
endmodule