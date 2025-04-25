module AddingCPU_tb;
    reg reset, clk, en, step;
    wire [5:0] adr_bus;
    wire rd_mem, wr_mem;
    wire [7:0] data_bus;
	 wire idle;
    
    reg [7:0] memory [0:63];
    integer i;
    
    AddingCPU u1 (
        .reset(reset),
        .clk_in(clk),
		  .en (en),
        .adr_bus(adr_bus),
        .rd_mem(rd_mem),
        .wr_mem(wr_mem),
        .data_bus(data_bus),
		  .step (step),
		  .idle (idle)
    );
    
    always #10 clk = ~clk;
    
    initial begin
		  $readmemh ("memory.hex", memory);
        
		  en = 1;
        clk = 0;
        reset = 1;
        step = 0;
		  
        #20; reset = 0; #20;
        
		  repeat (5) begin
            @ (negedge clk) step = 1; #20; step = 0;
            wait (idle);
				display_status();
				$display ("\nEXECUTED OP %02b, OPERAND %02h \n", u1.op_code, u1.dp.ir_out[5:0]);
				#10;
        end
		  
        $display("\nMemory Contents (Address 0x00 to 0x0F):");
        for (i = 0; i <= 15; i = i + 1) begin
            $display("Address 0x%02h: 0x%02h", i, memory[i]);
        end
        $stop;
    end
    
    assign data_bus = rd_mem ? memory[adr_bus] : 8'hzz;
    
    always @(posedge clk) begin
        if (wr_mem) begin
            memory[adr_bus] <= data_bus;
            $display("\nMemory Write: Addr 0x%02h = 0x%02h\n", adr_bus, data_bus);
        end
    end
    
	 always @ (rd_mem) begin
		if (rd_mem) $display ("\nMemory Read: Addr 0x%02h, Data = 0x%02h\n", adr_bus, data_bus);
	 end
	 
	 
    task display_status; begin
        $display("Time=%0t: Reset = %b Step = %b State=%02b OpCode=%02b\nPC=%02h IR=%02h AC=%02h\nAdr Bus = %02h\tData Bus = %02h\n",
               $time, reset, step, u1.cu.present_state, u1.op_code, u1.dp.pc_out, u1.dp.ir_out, u1.dp.a_out, adr_bus, data_bus);
		end
	 endtask
    
endmodule
