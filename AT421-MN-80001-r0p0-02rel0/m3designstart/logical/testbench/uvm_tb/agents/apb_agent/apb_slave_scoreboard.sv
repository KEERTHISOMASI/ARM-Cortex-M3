`ifndef APB_SLAVE_SCOREBOARD_SV
`define APB_SLAVE_SCOREBOARD_SV

class apb_slave_scoreboard extends uvm_component;
  `uvm_component_utils(apb_slave_scoreboard)

  // analysis imp to connect monitor port -> scoreboard
  uvm_analysis_imp#(apb_slave_seq_item, apb_slave_scoreboard) sb_ap;

  pidcid_t expected_ids;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    sb_ap = new("sb_ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // expected_ids should be set by test via config_db if PID checks are wanted
    if (!uvm_config_db#(pidcid_t)::get(this, "", "expected_ids", expected_ids)) begin
      // not fatal: scoreboard can still operate without PID checks
    end
  endfunction

  // This is the analysis write callback
  function void write(apb_slave_seq_item tr);
    int a = tr.addr;
    byte exp, obs;
    bit pidcid = 1;

    case (a)
      12'hFD0: exp = expected_ids.pid4;
      12'hFD4: exp = expected_ids.pid5;
      12'hFD8: exp = expected_ids.pid6;
      12'hFDC: exp = expected_ids.pid7;

      12'hFE0: exp = expected_ids.pid0;
      12'hFE4: exp = expected_ids.pid1;
      12'hFE8: exp = expected_ids.pid2;
      12'hFEC: exp = expected_ids.pid3;

      12'hFF0: exp = expected_ids.cid0;
      12'hFF4: exp = expected_ids.cid1;
      12'hFF8: exp = expected_ids.cid2;
      12'hFFC: exp = expected_ids.cid3;

      default: pidcid = 0;
    endcase

    if (pidcid && tr.rw == READ) begin
      obs = tr.data[7:0];
      if (obs !== exp)
        `uvm_error("PIDCID", $sformatf("Mismatch at %0h: obs %02x exp %02x", a, obs, exp));
      else
        `uvm_info("PIDCID", $sformatf("OK @%0h == %02x", a, obs), UVM_LOW);
    end
  endfunction

endclass

`endif

