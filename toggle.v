`default_nettype none
module toggle(input wire clk, input wire btn, input wire ext_btn,
              output wire [5:0] led, output wire ext_led);
  // 1. Bring the raw button into the clock domain (two flip-flops)
  reg s1 = 1'b1, s2 = 1'b1;
  always @(posedge clk) begin
    s1 <= ext_btn;
    s2 <= s1;
  end

  // 2. Debounce: accept a new level only after ~10 ms with no change
  reg clean = 1'b1;
  reg [17:0] stable = 0;
  always @(posedge clk)
    if (s2 == clean) stable <= 0;
    else begin
      stable <= stable + 1;
      if (&stable) clean <= s2;   // 2^18 cycles at 27 MHz = ~9.7 ms
    end

  // 3. Changed raw signal (wire b = s2;) to "clean", debounced signal
  wire b = clean;

  // 4. On each press (1 -> 0): toggle the green LED, count presses
  reg prev = 1'b1, state = 1'b0;
  reg [5:0] presses = 0;
  always @(posedge clk) begin
    prev <= b;
    if (prev && !b) begin
      state   <= ~state;
      presses <= presses + 1;
    end
  end

  assign ext_led = state;
  assign led     = ~presses;   // onboard LEDs show the count in binary
endmodule
