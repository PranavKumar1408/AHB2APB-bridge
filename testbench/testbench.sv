//------------------------------------------------------------------------------------------
// Title         : AHB2APB Bridge 
// File          : testbench.sv
// Description   : Testbench for AHB2APB bridge.
//------------------------------------------------------------------------------------------
`include "ahb_master.sv"

`timescale 1ns/1ns

module ahb2apb_tb();
  reg hclk,hresetn;
  wire[1:0] hresp;
  wire hwrite,hready_in,hreadyout;
  wire[1:0] htrans;
  wire[31:0] haddr,hwdata,hrdata;
  
  //Top Module is connected to AHB Master here, as the tasks in AHB Master are required.
  
  ahb_master ahb_master1(hclk,hresetn,hreadyout,hrdata,haddr,hwdata,hwrite,hready_in,htrans);
  top top1(hclk,hresetn,hwrite,hready_in,htrans,haddr,hwdata,hreadyout,hresp,hrdata);
  
  initial
    hclk=1'b0;
  always
    begin
      #40;
      hclk=~hclk;
    end
  
  
task reset();
begin
@(negedge hclk); //at first neg edge of clk 
hresetn=0;
@(negedge hclk); //at 2nd neg edge of clk 
hresetn=1;
end
endtask
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  
  initial
begin
  reset();
  //ahb_master1.single_write(); //task call 
  //ahb_master1.single_read();
  //ahb_master1.burst_4_incr_write;
  ahb_master1.burst_4_incr_read;

end
initial #1100 $finish;
endmodule
      
  
  
  