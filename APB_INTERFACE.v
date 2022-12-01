module apb_interface (input pwrite,penable,input [2:0] pselx, input [31:0] paddr,pwdata,
output pwrite_out,penable_out,output [2:0] psel_out,output [31:0] paddr_out,pwdata_out,output reg [31:0] prdata);

assign pwrite_out=pwrite;
assign penable_out=penable;
assign psel_out=pselx;
assign pwdata_out=pwdata;
assign paddr_out=paddr;

always @(*)
begin
 if(!pwrite==1 &&penable)
 prdata=8'd25;
end

endmodule
