module AddingCPU (
    input reset,
    input clk_in,
	 input en,
	 input step,
	 output idle,
    output [5:0] adr_bus,
    output rd_mem,
    output wr_mem,
    inout [7:0] data_bus
);
	
	 wire clk; assign clk = clk_in & en; // gated clock
	 
    wire ir_on_adr, pc_on_adr, dbus_on_data, data_on_dbus;
    wire ld_ir, ld_ac, ld_pc, inc_pc, clr_pc;
    wire pass, add, alu_on_dbus;
    wire [1:0] op_code;

    Controller cu (
        .reset(reset),
        .clk(clk),
		  .step (step),
        .op_code(op_code),
        .rd_mem(rd_mem),
        .wr_mem(wr_mem),
        .ir_on_adr(ir_on_adr),
        .pc_on_adr(pc_on_adr),
        .dbus_on_data(dbus_on_data),
        .data_on_dbus(data_on_dbus),
        .ld_ir(ld_ir),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .clr_pc(clr_pc),
        .pass(pass),
        .add(add),
        .alu_on_dbus(alu_on_dbus),
		  .idle (idle)
    );

    DataPath dp (
        .ir_on_adr(ir_on_adr),
        .pc_on_adr(pc_on_adr),
        .dbus_on_data(dbus_on_data),
        .data_on_dbus(data_on_dbus),
        .ld_ir(ld_ir),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .clr_pc(clr_pc),
        .pass(pass),
        .add(add),
        .alu_on_dbus(alu_on_dbus),
        .clk (clk),
        .adr_bus(adr_bus),
        .op_code(op_code),
        .data_bus(data_bus)
    );

endmodule
