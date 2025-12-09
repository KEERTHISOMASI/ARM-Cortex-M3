`ifndef APB_SLAVE_MODEL_SV
`define APB_SLAVE_MODEL_SV

class apb_slave_model;

  rand bit [31:0] regs[];
  typedef struct packed {
    bit privileged_ok;
    bit nonsecure_ok;
  } perm_t;

  perm_t perms[];

  function new(int num_regs = 8);
    regs  = new[num_regs];
    perms = new[num_regs];

    foreach (regs[i]) begin
      regs[i] = 32'hABCD_0000 + i;
      perms[i].privileged_ok = 1;
      perms[i].nonsecure_ok  = 1;
    end
    // Make register 3 secure-only for test
    perms[3].nonsecure_ok = 0;
  endfunction

  function bit addr_to_index(logic [31:0] addr, output int idx);
    idx = addr >> 2;
    return (idx >= 0 && idx < regs.size());
  endfunction

  function bit check_pprot(int idx, logic [2:0] pprot);
    bit is_priv     = pprot[0];
    bit is_nonsec   = pprot[1];

    if (is_nonsec && !perms[idx].nonsecure_ok)
      return 0;

    if (!is_priv && !perms[idx].privileged_ok)
      return 0;

    return 1;
  endfunction

endclass

`endif

