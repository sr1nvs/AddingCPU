module Controller (
    input reset, clk, step,
    input [1:0] op_code,
    output reg rd_mem, wr_mem, ir_on_adr, pc_on_adr, dbus_on_data,
    data_on_dbus, ld_ir, ld_ac, ld_pc, inc_pc, clr_pc,
    pass, add, alu_on_dbus, idle
);
	
	 
    localparam [2:0] 
		Reset   = 3'b000,
		Idle    = 3'b001,
		Fetch   = 3'b010,
		Decode  = 3'b011,
		Execute = 3'b100;


    reg [2:0] present_state, next_state;
	
		

    always @(posedge clk) begin
        if (reset) present_state <= Reset;
        else       present_state <= next_state;
	 end

    always @(present_state or reset or step) begin : Combinational
        rd_mem       = 1'b0; 
        wr_mem       = 1'b0; 
        ir_on_adr    = 1'b0; 
        pc_on_adr    = 1'b0;
        dbus_on_data = 1'b0; 
        data_on_dbus = 1'b0; 
        ld_ir        = 1'b0;
        ld_ac        = 1'b0; 
        ld_pc        = 1'b0; 
        inc_pc       = 1'b0; 
        clr_pc       = 1'b0;
        pass         = 1'b0;
        add          = 1'b0; 
        alu_on_dbus  = 1'b0;
		  idle 			= 1'b0;

        case (present_state)
            Reset: begin
                next_state = reset ? Reset : Idle;
                clr_pc = 1;
            end
				
				Idle: begin
					idle = 1; // added idle state to cpu - for stepped execution
					next_state = step ? Fetch : Idle;
				end
				
            Fetch: begin
                next_state    = Decode;
                pc_on_adr     = 1; 
                rd_mem        = 1; 
                data_on_dbus  = 1;
                ld_ir         = 1; 
                inc_pc        = 1;
            end

            Decode: begin
                next_state = Execute;
            end

            Execute: begin
                case (op_code)
                    2'b00: begin // lda
                        ir_on_adr    = 1; 
                        rd_mem       = 1;
                        data_on_dbus = 1; 
                        ld_ac        = 1;
                    end
                    2'b01: begin // sta
                        pass         = 1;
                        ir_on_adr    = 1; 
                        alu_on_dbus  = 1;
                        dbus_on_data = 1; 
                        wr_mem       = 1;
                    end
                    2'b10: begin // jmp
                        ld_pc = 1;
                    end
                    2'b11: begin // add
                        add         = 1; 
                        alu_on_dbus = 1; 
                        ld_ac       = 1;
                    end
                endcase
					 next_state = Idle;
            end

            default: next_state = Reset;
        endcase
    end
endmodule
