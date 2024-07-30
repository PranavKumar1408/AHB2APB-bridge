//------------------------------------------------------------------------------------------
// Title         : APB Slave
// File          : apb_slave.sv
// Description   : APB Slave, which outputs data from peripheral devices on read(prdata).
//------------------------------------------------------------------------------------------
`timescale 1ns/1ns
module apb_slave(
  input pwrite,penable,input [2:0] psel, input [31:0] pwdata,paddr,	
  output reg [31:0] pr_data
);
  
  always@(*)
    begin
      if(pwrite==0 && penable==1)
        pr_data=($random)%256;//random 1 byte value
      else
        pr_data=0;
    end
endmodule
  