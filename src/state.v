module rst_debouncer (
    rst, 
    clk,
    rst_db
);
    input rst;
    input clk;
    output reg rst_db;

    reg delay = 0;
    reg [7:0] counter;

    always @(posedge clk) begin
        if (rst && ~delay) begin
            rst_db = 1;
            counter = 0;
        end else begin
            if (counter >= 135) begin
                rst_db = 0;
                delay = 0;
                counter = 0;
            end else begin
                counter = counter+1;
            end
        end
    end
endmodule

module phaseChange (
    rst,
    clk,
    displayPhase
);
    input rst;
    input clk;

    output reg displayPhase;
    reg [29:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            displayPhase = 1;
            counter = 0;
        end else begin
            if (counter >= 500000000) begin
                displayPhase = 0;
                counter = 0;
            end else begin
                counter = counter+1;
            end
        end
    end
endmodule