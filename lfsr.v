`default_nettype none

// Reusing code from toggle.v for similar program

module lfsr(input wire clk, input wire ext_btn, output wire [5:0] led);
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

  // 4. On each press (1 -> 0): shift LFSR one step (feedback = XOR of taps)
  reg prev = 1'b1;
  reg [7:0] state = 8'b00110001;  // randomly picked starting value (can't be zero)
  // Chosen polynomial: x^8 + x^6 + x^5 + x^4 + 1
  wire feedback = state[7] ^ state[5] ^ state [4] ^ state[3];
  always @(posedge clk) begin
    prev <= b;
    if (prev && !b) begin
      state <= {state[6:0], feedback};  // shift left
    end
  end

  assign led = ~state[5:0];
endmodule

