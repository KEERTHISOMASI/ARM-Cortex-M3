################################################################################
# Unified Makefile for ARM Execution TB + UVM Testbench (with Log Saving)
################################################################################

# -------------------------------
# Simulator Selection
# -------------------------------
SIMULATOR ?= mti        # mti (Modelsim/Questa), vcs (Synopsys)
MODE      ?= exec       # exec = ARM execution TB, uvm = UVM TB
TESTNAME  ?= hello      # C Test (exec mode)
TEST      ?= iot_test_base   # UVM test (uvm mode)

# -------------------------------
# Directory Paths
# -------------------------------
ROOT_DIR      := $(CURDIR)
SOC_DIR       := $(ROOT_DIR)/../verilog
UVM_DIR       := $(ROOT_DIR)/../uvm_tb
TESTCODE_DIR  := $(ROOT_DIR)/../testcodes
CSSOC_BIN_DIR := $(ROOT_DIR)/../integration_cssoc/validation/bin

# -------------------------------
# Exec TB Files
# -------------------------------
EXEC_VC       := iot_top.vc
EXEC_CM_VC    := tbench_cm.vc

# -------------------------------
# UVM Files (auto-discover)
# -------------------------------
UVM_SVFILES := $(shell find $(UVM_DIR) -type f -name "*.sv")

# -------------------------------
# Simulator Commands
# -------------------------------
ifeq ($(SIMULATOR),mti)
    VLOG = vlog -sv +acc=blnr +define+UVM_NO_DEPRECATED +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
    VSIM = vsim -quiet -gui

    COMPILE_EXEC = \
        vlib work; \
        vlog -f $(EXEC_VC) +acc=blnr | tee exec_compile.log;

    COMPILE_UVM = \
        vlib work; \
        $(VLOG) $(UVM_SVFILES) +incdir+$(UVM_DIR) | tee uvm_compile.log;

    RUN_EXEC = \
        $(VSIM) tb_m3ds_iot_top -do "run -all; quit" | tee exec_run.log

    RUN_UVM = \
        $(VSIM) tb_top -do "run -all; quit" | tee uvm_run.log
endif


ifeq ($(SIMULATOR),vcs)
    VLOG = vcs -sverilog -debug_access+all

    COMPILE_EXEC = \
        $(VLOG) -f $(EXEC_VC) -o simv_exec | tee exec_compile.log;

    COMPILE_UVM = \
        $(VLOG) $(UVM_SVFILES) +incdir+$(UVM_DIR) -o simv_uvm | tee uvm_compile.log;

    RUN_EXEC = ./simv_exec +TESTNAME=$(TESTNAME) | tee exec_run.log
    RUN_UVM  = ./simv_uvm +UVM_TESTNAME=$(TEST) | tee uvm_run.log
endif

################################################################################
# Flash Image Preparation (EXEC Mode)
################################################################################
prepare_flash:
	@if [ ! -f $(TESTCODE_DIR)/$(TESTNAME)/$(TESTNAME).bin ]; then \
	    echo "ERROR: Firmware $(TESTNAME).bin not found!"; exit 1; fi

	@echo "Preparing flash image..."
	od -v -A n -t x8 --width=16 \
	    $(TESTCODE_DIR)/$(TESTNAME)/$(TESTNAME).bin \
	    | awk '{print $$2$$1}' > flash_main.ini

################################################################################
# HELP
################################################################################
help:
	@echo ""
	@echo "======================================================"
	@echo "         ARM IoT System Makefile (EXEC + UVM)"
	@echo "======================================================"
	@echo ""
	@echo " Run Execution Testbench (C firmware tests):"
	@echo "     make exec TESTNAME=<name>"
	@echo ""
	@echo " Run UVM Testbench:"
	@echo "     make uvm TEST=<uvm_test_name>"
	@echo ""
	@echo " Clean:"
	@echo "     make clean"
	@echo ""
	@echo " Logs generated:"
	@echo "     exec_compile.log, exec_run.log"
	@echo "     uvm_compile.log, uvm_run.log"
	@echo ""

################################################################################
# EXECUTION TESTBENCH FLOW
################################################################################

exec: MODE = exec
exec: prepare_flash
	@echo "===== COMPILING EXECUTION TB ====="
	$(COMPILE_EXEC)
	@echo "===== RUNNING EXEC TEST: $(TESTNAME) ====="
	$(RUN_EXEC)

################################################################################
# UVM TESTBENCH FLOW
################################################################################

uvm: MODE = uvm
uvm:
	@echo "===== COMPILING UVM TESTBENCH ====="
	$(COMPILE_UVM)
	@echo "===== RUNNING UVM TEST: $(TEST) ====="
	$(RUN_UVM)

################################################################################
# CLEAN-UP
################################################################################

clean:
	rm -rf work simv_exec simv_uvm csrc *.log *.vcd *.wlf transcript \
           *.ini *.hex *.vpd *.fsdb *.err exec_compile.log exec_run.log \
           uvm_compile.log uvm_run.log

################################################################################
# END OF MAKEFILE
################################################################################

