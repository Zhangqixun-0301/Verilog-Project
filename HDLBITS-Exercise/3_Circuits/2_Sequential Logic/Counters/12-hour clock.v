//方法1 深度嵌套齿轮
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    always@(posedge clk)begin
        if(reset)begin
           hh<=8'h12;
           mm<=8'd0;
           ss<=8'd0;
           pm<=0;
        end
        
        else begin 
            if(ena) 
            begin
                if(ss[3:0]==4'd9)begin
                  ss[3:0]<=4'd0;
                    if(ss[7:4]==4'd5)begin
                        ss[7:4]<=4'd0;
                        if (mm[3:0]==4'd9)begin
                          mm[3:0]<=4'd0;
                            if(mm[7:4]==4'd5)begin
                                mm[7:4]<=4'd0;
                                if(hh==8'h11)begin
 									pm<=~pm;
                                	hh<=hh+8'h1;
                                end
                                else if (hh==8'h12)
                                     hh<=8'h1;
                                else if (hh==8'h09)
                                    hh<=8'h10;
                                else hh<=hh+8'h1;
                          end
                            else mm[7:4]<=mm[7:4]+4'd1;
                      end
                        else mm[3:0]<=mm[3:0]+4'd1;
                  end
                    else ss[7:4]<=ss[7:4]+4'd1;
                end  
                else ss[3:0]<=ss[3:0]+4'd1;
            end
            else ;
            
        end
    end
endmodule
