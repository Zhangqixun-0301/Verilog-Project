//方法1 深度嵌套"Nested IFs"
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
                                else if (hh==8'h09) //在16进制中10会自动转化为A，需要手动修改成10，后续数字会变成11.
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



//方法2 展平逻辑
module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // =========================================================
    // 1. 进位条件预计算 (将控制逻辑从 always 块中抽离出来)
    // =========================================================
    // 只有当 ena 有效，且低位已经达到最大值时，高位才允许动作
    
    // 秒的十位进位：秒的个位是 9
    wire adv_ss_tens = ena && (ss[3:0] == 4'd9);
    
    // 分的个位进位：秒满 59 
    wire adv_mm_ones = ena && (ss == 8'h59);
    
    // 分的十位进位：秒满 59，且分的个位是 9
    wire adv_mm_tens = adv_mm_ones && (mm[3:0] == 4'd9);
    
    // 小时进位：秒满 59，且分满 59
    wire adv_hh      = ena && (ss == 8'h59) && (mm == 8'h59);


    // =========================================================
    // 2. 展平的时序逻辑 (互不嵌套，各自安好)
    // =========================================================
    always @(posedge clk) begin
        if (reset) begin
            // 🌟 统一复位到 12:00:00 AM
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else begin
            
            // ---------------------------
            // 【秒 ss】的处理逻辑
            // ---------------------------
            // 1. 秒的个位
            if (ena) begin
                if (ss[3:0] == 4'd9) ss[3:0] <= 4'd0;
                else                 ss[3:0] <= ss[3:0] + 1'b1;
            end
            
            // 2. 秒的十位
            if (adv_ss_tens) begin
                if (ss[7:4] == 4'd5) ss[7:4] <= 4'd0;
                else                 ss[7:4] <= ss[7:4] + 1'b1;
            end
            
            // ---------------------------
            // 【分 mm】的处理逻辑
            // ---------------------------
            // 3. 分的个位
            if (adv_mm_ones) begin
                if (mm[3:0] == 4'd9) mm[3:0] <= 4'd0;
                else                 mm[3:0] <= mm[3:0] + 1'b1;
            end
            
            // 4. 分的十位
            if (adv_mm_tens) begin
                if (mm[7:4] == 4'd5) mm[7:4] <= 4'd0;
                else                 mm[7:4] <= mm[7:4] + 1'b1;
            end
            
            // ---------------------------
            // 【时 hh】与 【PM】的处理逻辑
            // ---------------------------
            if (adv_hh) begin
                
                // AM/PM 翻转 (11 变 12 的瞬间翻转)
                if (hh == 8'h11) begin
                    pm <= ~pm;
                end
                
                // 小时跳变逻辑
                if (hh == 8'h12) begin
                    hh <= 8'h01;       // 12 -> 1
                end 
                else if (hh == 8'h09) begin
                    hh <= 8'h10;       // 09 -> 10
                end 
                else begin
                    hh[3:0] <= hh[3:0] + 1'b1; // 其他情况个位加 1
                end
                
            end
            
        end
    end

endmodule
