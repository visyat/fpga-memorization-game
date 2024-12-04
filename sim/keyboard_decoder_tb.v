`timescale 1ns / 1ps

module tb_keyboard_decoder;

    reg clk;
    reg rst;
    reg [3:0] row;
    wire [15:0] value;
    wire valueReady;
    wire [3:0] col;

    always #1 clk = ~clk;

    keyboard_decoder keyboard_decoder (
        .clk(clk),
        .row(row),
        .rst(rst),
        .value(value),
        .valueReady(valueReady),
        .col(col)
    );

    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;  // Reset is active initially
        row = 4'b1111; // No key pressed (all rows inactive)


        #20;
        rst = 0; //turn off reset

        #40;

        // Simulate 0
        row = 4'b0111; // Key pressed in row 0
        #80;

        row = 4'b1111; //change the value to no key press
        #100;

        if (valueReady) begin
            $display("Value ready: %h", value);
        end else begin
            $display("Value not ready yet: %h", value);
        end

        // Simulate 4
        row = 4'b1011;
        #80;

        row = 4'b1111; //change the value to no key press
        #100;

        if (valueReady) begin
            $display("Value ready: %h", value);
        end else begin
            $display("Value not ready yet: %h", value);
        end

        // simulate 7
        row = 4'b1101;
        #80;

        row = 4'b1111; //change the value to no key press
        #100;

        if (valueReady) begin
            $display("Value ready: %h", value);
        end else begin
            $display("Value not ready yet: %h", value);
        end

        // simulate 0
        row = 4'b1110;
        #80;

        row = 4'b1111;
        #100;

        if (valueReady) begin
            $display("Value ready: %h", value);
        end else begin
            $display("Value not ready yet");
        end

        #100;
        $finish;
    end

endmodule