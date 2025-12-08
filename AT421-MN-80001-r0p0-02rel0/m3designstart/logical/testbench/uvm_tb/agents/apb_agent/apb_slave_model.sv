`ifndef APB_SLAVE_MODEL_SV
`define APB_SLAVE_MODEL_SV

typedef struct packed {
  byte pid0, pid1, pid2, pid3;
  byte pid4, pid5, pid6, pid7;
  byte cid0, cid1, cid2, cid3;
} pidcid_t;

class apb_slave_model;

  // Full 4KB window of 32-bit words = 1024 entries
  bit [31:0] regs[];
  pidcid_t ids;

  function new(int num_regs = 1024);
    regs = new[num_regs];
    foreach (regs[i]) regs[i] = '0;
  endfunction

  function void set_ids(pidcid_t new_ids);
    ids = new_ids;
  endfunction

  // Check PID/CID space by OFFSET (12-bit)
  function bit is_pidcid_addr(logic [11:0] addr, output byte b);
    case (addr)
      12'hFD0: b = ids.pid4;
      12'hFD4: b = ids.pid5;
      12'hFD8: b = ids.pid6;
      12'hFDC: b = ids.pid7;

      12'hFE0: b = ids.pid0;
      12'hFE4: b = ids.pid1;
      12'hFE8: b = ids.pid2;
      12'hFEC: b = ids.pid3;

      12'hFF0: b = ids.cid0;
      12'hFF4: b = ids.cid1;
      12'hFF8: b = ids.cid2;
      12'hFFC: b = ids.cid3;

      default: return 0;
    endcase
    return 1;
  endfunction

endclass

`endif

