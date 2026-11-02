module off(input clk, input btn, output [5:0] led);
  localparam [5:0] ALL_OFF = {6{1'b1}};  //Onboard LEDs: 1 = dark
  assign led = ALL_OFF;
endmodule
