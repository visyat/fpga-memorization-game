
module pmodkpd(
   // inputs
   J7, J8, J9, J10,
      slow_clk,
      // outputs
      J1, J2, J3, J4,
         outnum, pressed
      );
      output reg J1 = 0;
      output reg J2 = 1;
      output reg J3 = 1;
      output reg J4 = 1;
      input J7;
      input J8;
      input J9;
      input J10;
      input slow_clk;
      reg [1:0] colcycle = 0;
      output reg [3:0] outnum;
      output reg pressed;

      always @ (posedge slow_clk) begin
         case(colcycle)
            2'b00: begin J1 <= 1'b0; J2 <= 1'b1; J3 <= 1'b1; J4 <= 1'b1; end
            2'b01: begin J1 <= 1'b1; J2 <= 1'b0; J3 <= 1'b1; J4 <= 1'b1; end
            2'b10: begin J1 <= 1'b1; J2 <= 1'b1; J3 <= 1'b0; J4 <= 1'b1; end
            2'b11: begin J1 <= 1'b1; J2 <= 1'b1; J3 <= 1'b1; J4 <= 1'b0; end
         endcase
         colcycle <= colcycle + 1;
      end

      always @ (negedge slow_clk) begin
         if(J7 && J8 && J9 && J10) begin
            pressed <= 0;
         end else begin
            pressed <= 1;
            case({J1,J2,J3,J4,J7,J8,J9,J10})
               8'b11101110: begin outnum <= 4'h1; end // 1
               8'b11011110: begin outnum <= 4'h2; end // 2
               8'b10111110: begin outnum <= 4'h3; end // 3
               8'b01111110: begin outnum <= 4'hA; end // A
               8'b11101101: begin outnum <= 4'h4; end // 4
               8'b11011101: begin outnum <= 4'h5; end // 5
               8'b10111101: begin outnum <= 4'h6; end // 6
               8'b01111101: begin outnum <= 4'hB; end // B
               8'b11101011: begin outnum <= 4'h7; end // 7
               8'b11011011: begin outnum <= 4'h8; end // 8
               8'b10111011: begin outnum <= 4'h9; end // 9
               8'b01111011: begin outnum <= 4'hC; end // C
               8'b11100111: begin outnum <= 4'h0; end // 0
               8'b11010111: begin outnum <= 4'hF; end // F
               8'b10110111: begin outnum <= 4'hE; end // E
               8'b01110111: begin outnum <= 4'hD; end // D
               default: begin outnum <= 4'hA; end // none
            endcase
         end
      end
      endmodule
