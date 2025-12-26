class ahb_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(ahb_virtual_sequencer)

  ahb_sequencer dma_seqr;   // DMA AHB sequencer
  ahb_sequencer spi_seqr;   // SPI AHB sequencer (optional)

  virtual ahb_if ahb_vif;   // contains HCLK, HRESETn

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
