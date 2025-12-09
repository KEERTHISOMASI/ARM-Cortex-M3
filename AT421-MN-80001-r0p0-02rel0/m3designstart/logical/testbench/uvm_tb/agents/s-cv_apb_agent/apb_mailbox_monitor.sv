`ifndef APB_MAILBOX_MONITOR_SV
`define APB_MAILBOX_MONITOR_SV

`include "apb_slave_seq_item.sv"
`include "cmd_transaction.sv"

class apb_mailbox_monitor extends uvm_component;
  `uvm_component_utils(apb_mailbox_monitor)

  // Analysis port to send "Commands" to the Virtual Sequencer
  uvm_analysis_port #(cmd_transaction) cmd_port;

  // Connection to the raw APB interface monitor
  // This receives transactions from the standard apb_slave_monitor
  uvm_analysis_imp #(apb_slave_seq_item, apb_mailbox_monitor) apb_in;

  string print_buffer = "";  // Buffer to build strings char-by-char

  // Internal struct to hold multi-cycle register writes before EXEC trigger
  struct {
    logic [31:0] addr;
    logic [31:0] data;
    logic [31:0] ctrl;
  } cmd_cache;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cmd_port = new("cmd_port", this);
    apb_in   = new("apb_in", this);
  endfunction

  // This function is called whenever an APB transaction happens on APB7
  // It receives the transaction from the standard monitor via the analysis imp
  function void write(apb_slave_seq_item t);
    // We only care about WRITES
    if (t.rw != WRITE) return;

    // Decode based on Offset (Address lowest 8 bits)
    // Assuming the base address logic is handled by the connection
    // or this monitor is attached specifically to the APB7 interface.
    case (t.addr & 8'hFF)

      // --- 1. Handshake ---
      8'h00: begin
        `uvm_info("C_HANDSHAKE", $sformatf("Received Sync Code: 0x%04h", t.data), UVM_LOW)
        // Here you could trigger a UVM event to unblock a sequence
      end

      // --- 2. Printing ---
      8'h04: begin  // PRINT_CHAR
        byte char_code = t.data[7:0];
        if (char_code == 8'h0A) begin  // Newline (\n)
          `uvm_info("C_PRINT", print_buffer, UVM_LOW)
          print_buffer = "";
        end else begin
          print_buffer = {print_buffer, string'(char_code)};
        end
      end

      8'h08: begin  // PRINT_U32
        `uvm_info("C_PRINT", $sformatf("Value: 0x%08h (%0d)", t.data, t.data), UVM_LOW)
      end

      // --- 3. Command Trigger ---
      8'h10: this.cmd_cache.addr = t.data;
      8'h14: this.cmd_cache.data = t.data;
      8'h18: this.cmd_cache.ctrl = t.data;
      8'h1C: begin  // CMD_EXEC - The Trigger!
        cmd_transaction cmd = cmd_transaction::type_id::create("cmd");
        cmd.addr      = this.cmd_cache.addr;
        cmd.data      = this.cmd_cache.data;
        cmd.is_write  = this.cmd_cache.ctrl[0];
        cmd.master_id = this.cmd_cache.ctrl[1];

        `uvm_info("C_CMD", $sformatf(
                  "CPU requested ExtMaster%0d %s to 0x%h",
                  cmd.master_id,
                  cmd.is_write ? "WRITE" : "READ",
                  cmd.addr
                  ), UVM_MEDIUM)

        // Send this command to the Virtual Sequencer to execute!
        cmd_port.write(cmd);
      end

    endcase
  endfunction

endclass

`endif
