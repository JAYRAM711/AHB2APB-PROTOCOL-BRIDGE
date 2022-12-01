module ahb_slave_interface(input hclk,hresetn,hwrite,hready_in, input [1:0] htrans,input [31:0] haddr,hwdata, 
output reg valid,hwritereg,hwritereg_1, output [1:0] hresp,output reg [2:0] temp_selx,
output reg [31:0] haddr_1,haddr_2,hwdata_1,hwdata_2, output [31:0] hrdata,input [31:0] prdata);

always @(posedge hclk)
begin 
 if(!hresetn)
 begin
 haddr_1<=0;
 haddr_2<=0;
 end
 else 
 begin
 haddr_1<=haddr;
 haddr_2<=haddr_1;
 end
end

always @(posedge hclk)
begin 
 if(!hresetn)
 begin
 hwdata_1<=0;
 hwdata_2<=0;
 end
 else 
 begin
 hwdata_1<=hwdata;
 hwdata_2<=hwdata_1;
 end
end

always @(posedge hclk)
begin 
 if(!hresetn)
 begin
 hwritereg<=0;
 hwritereg_1<=0;
 end
 else 
 begin
 hwritereg<=hwrite;
 hwritereg_1<=hwritereg;
 end
end

always @(*)
begin
 valid=1'b0;
 if(hready_in==1 && haddr>=32'h0000_0000 && haddr<32'h8c00_0000 && 
htrans==2'b10||htrans==2'b11)
 valid=1;
 else
 valid=0;
end

always @(*)
begin
temp_selx=3'b000;
if ( haddr>=32'h0000_0000 && haddr<32'h8400_0000)
 temp_selx=3'b001;
if ( haddr>=32'h8400_0000 && haddr<32'h8800_0000)
 temp_selx=3'b010;
if ( haddr>=32'h8800_0000 && haddr<=32'h8c00_0000)
 temp_selx=3'b000;
 
end
assign hrdata=prdata;
assign hresp=2'b0;
endmodule
