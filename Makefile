VRLG  = iverilog
FLAGS = -g2012
OUT   = out

# -------------------------------------------------
# Default target
# -------------------------------------------------
all: test

# -------------------------------------------------
# Create output directory
# -------------------------------------------------
$(OUT):
	mkdir -p $(OUT)

# -------------------------------------------------
# Program Counter
# -------------------------------------------------
pc: $(OUT)/pc.vvp
	vvp $(OUT)/pc.vvp

$(OUT)/pc.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	program_counter/program_counter.v \
	program_counter/program_counter_test.v \
	-o $(OUT)/pc.vvp

# -------------------------------------------------
# ALU
# -------------------------------------------------
alu: $(OUT)/alu.vvp
	vvp $(OUT)/alu.vvp

$(OUT)/alu.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	alu/alu.v \
	alu/alu_test.v \
	-o $(OUT)/alu.vvp

# -------------------------------------------------
# Control Unit + ALU Control
# -------------------------------------------------
cu: $(OUT)/cu.vvp
	vvp $(OUT)/cu.vvp

$(OUT)/cu.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	control_unit/control_unit.v \
	control_unit/control_unit_test.v \
	alu_control/alu_control.v \
	alu_control/alu_control_test.v \
	-o $(OUT)/cu.vvp

# -------------------------------------------------
# Register File
# -------------------------------------------------
rf: $(OUT)/rf.vvp
	vvp $(OUT)/rf.vvp

$(OUT)/rf.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	register_file/register_file.v \
	register_file/register_file_test.v \
	-o $(OUT)/rf.vvp

# -------------------------------------------------
# Data Memory
# -------------------------------------------------
dm: $(OUT)/dm.vvp
	vvp $(OUT)/dm.vvp

$(OUT)/dm.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	data_memory/data_memory.v \
	data_memory/data_memory_test.v \
	-o $(OUT)/dm.vvp

# -------------------------------------------------
# Immediate Generator
# -------------------------------------------------
ig: $(OUT)/ig.vvp
	vvp $(OUT)/ig.vvp

$(OUT)/ig.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	immediate_generator/immediate_generator.v \
	immediate_generator/immediate_generator_test.v \
	-o $(OUT)/ig.vvp

# -------------------------------------------------
# Instruction Memory
# -------------------------------------------------
im: $(OUT)/im.vvp
	vvp $(OUT)/im.vvp

$(OUT)/im.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	instruction_memory/instruction_memory.v \
	instruction_memory/instruction_memory_test.v \
	-o $(OUT)/im.vvp

# -------------------------------------------------
# Single-Cycle Processor (integration test)
# -------------------------------------------------
scp: $(OUT)/scp.vvp
	vvp $(OUT)/scp.vvp

$(OUT)/scp.vvp: | $(OUT)
	$(VRLG) $(FLAGS) \
	single_cycle_processor/single_cycle_processor.v \
	single_cycle_processor/single_cycle_processor_test.v \
	program_counter/program_counter.v \
	instruction_memory/instruction_memory.v \
	immediate_generator/immediate_generator.v \
	register_file/register_file.v \
	data_memory/data_memory.v \
	control_unit/control_unit.v \
	alu_control/alu_control.v \
	alu/alu.v \
	-o $(OUT)/scp.vvp

# -------------------------------------------------
# Run ALL tests
# -------------------------------------------------
test: pc alu cu rf dm ig im scp

# -------------------------------------------------
# Clean
# -------------------------------------------------
clean:
	rm -rf $(OUT)

