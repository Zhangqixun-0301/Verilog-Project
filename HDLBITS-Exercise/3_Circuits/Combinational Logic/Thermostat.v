module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 
    always@(*) begin
        case (mode)
            1'b1 :begin
                if(too_cold==1) begin
                    heater=1;
                	aircon=0;
                end
                else begin
                	heater=0;
                    aircon=0;
                end
            end
            1'b0 :begin
                if(too_hot==1) begin
                    heater=0;
                    aircon=1;
                end
                else begin
                	heater=0;
                    aircon=0;
                end                
            end

        endcase
		fan=heater|aircon|fan_on;
        
    end
endmodule
