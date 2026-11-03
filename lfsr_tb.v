`timescale 1ns/1ps
module tb;
  reg clk = 0;
  reg ext_btn = 1;
  integer i;
  integer errors = 0;
  wire [5:0] led;
  lfsr dut(.clk(clk), .ext_btn(ext_btn), .led(led));
  always #5 clk = ~clk;
  task press;
    begin
      ext_btn = 0;  repeat (300000) @(posedge clk);
      ext_btn = 1;  repeat (300000) @(posedge clk);
    end
  endtask
  initial begin
    // First check it matches set seed
    if (dut.state !== 8'b00110001) begin   // 00110001 is set starting seed (can change)
      $display("Fail: start state %b does not match seed", dut.state);
      errors = errors + 1;
    end

    // Check after one press; should land on predicted
    press;
    if (dut.state !== 8'b01100010) begin   // 01100010 = predicted value after one press (predicted will change if seed is changed)
      $display("Fail: first step gave %b, predicted 01100010", dut.state);
      errors = errors + 1;
    end else
      $display("First step good!");
      $display("press 1: %b", dut.state);

    // Presses 2 through 255 after first checks: can't be zero or original value before press 255
    for (i = 2; i <= 255; i = i + 1) begin
      press;
      if (dut.state === 8'b00000000) begin
        $display("Fail: hit zero at press %0d", i);
        errors = errors + 1;
      end
      if (dut.state === 8'b00110001 && i < 255) begin
        $display("Fail: back at starting seed too early, on press %0d", i);
        errors = errors + 1;
      end
      // $display("press %0d: %b", i, dut.state);  // Uncommenting this line will print state at every press[i].
    end

    // End: after press 255 it should be back to starting value
    if (dut.state !== 8'b00110001) begin
      $display("Fail: after 255 presses state is %b, not starting value", dut.state);
      errors = errors + 1;
    end
    if (errors == 0) $display("ALL PASS");
    else             $display("%0d fails", errors);
    $finish;
  end
endmodule
