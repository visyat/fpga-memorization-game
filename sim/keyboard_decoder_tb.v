`timescale 1ns / 1ps

module tb_keyboard_decoder;


    reg clk;
    reg [3:0] row;
    reg rst;

    // Outputs
    wire [15:0] value;
    wire valueReady;
    wire [3:0] col;

    keyboard_decoder uut (
        .clk(clk),
        .row(row),
        .rst(rst),
        .value(value),
        .valueReady(valueReady),
        .col(col)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Task to simulate row signal input
    task simulate_row_input;
        input [3:0] input_row;
        begin
            row = input_row;
            #160;
            row = 4'b1111; 
            #160; 
        end
    endtask

    initial begin
        // Initialize inputs
        row = 4'b1111;
        rst = 1;

        // Apply reset
        #20;
        rst = 0;

        // Simulate key presses
        simulate_row_input(4'b0111); // Simulate pressing '1'
        simulate_row_input(4'b1011); // Simulate pressing '5'
        simulate_row_input(4'b1101); // Simulate pressing '9'
        simulate_row_input(4'b1110); // Simulate pressing '0'
        simulate_row_input(4'b1011); // Simulate pressing '5'

        // Wait to allow valueReady to be asserted
        #1000;

        // Apply reset again
        rst = 1;
        #20;
        rst = 0;

        simulate_row_input(4'b0111); // Simulate pressing '1'
        simulate_row_input(4'b1011); // Simulate pressing '4'
        simulate_row_input(4'b1101); // Simulate pressing '7'

        #1000;

        $stop;
    end
endmodule