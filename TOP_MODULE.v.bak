module top();

reg hclk,hresetn;
wire hreadyout,hwrite,hreadyin;
wire [31:0] hrdata,haddr,hwdata,paddr,pwdata,paddr_out,pwdata_out,prdata;
wire [1:0] hresp,htrans;
wire penable,pwrite,pwrite_out,penable_out;
wire [2:0] psel,psel_out;

ahb_master 
ahb(hclk,hresetn,hreadyout,hrdata,hresp,haddr,hwdata,hwrite,hreadyin,htrans);

bridge_top 
bridge(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,prdata,penable,pwrite,hreadyout,
psel,hresp,paddr,pwdata,hrdata);

apb_interface 
apb(pwrite,penable,psel,paddr,pwdata,pwrite_out,penable_out,psel_out,paddr_out,pwdata_out,prdata);

initial
begin
 hclk=1'b0;
 forever #10 hclk=~hclk;
end

task reset();
begin
 @(negedge hclk)
 hresetn=1'b0;
 @(negedge hclk)
 hresetn=1'b1;
end
endtask

initial
begin
 reset;
 ahb.single_write();
 //ahb.single_read();
end

endmodule
