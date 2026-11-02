`default_nettype none
module blink(input wire clk,input wire btn,
             output wire [5:0] led, output wire ext_led);
  reg [24:0] count = 0;

  always @(posedge clk)
    if (!btn)			// When onboard button pressed, LEDs stop blinking
      count <= count + 1;

  assign led = ~count[23:18];
  assign ext_led = count[23];
endmodule
