VRLG  = iverilog
FLAGS = -g2012

all: pc alu cu rf dm ig im scp

pc: program_counter.vvp

program_counter.vvp:
	$(VRLG) $(FLAGS) \
	program_counter/program_counter.v \
	program_counter/program_counter_test.v \
	-o out/pc.vvp

alu: alu.vvp

alu.vvp:
	$(VRLG) $(FLAGS) \
	alu/alu.v \
	alu/alu_test.v \
	-o out/alu.vvp

cu: control_unit.vvp

control_unit.vvp:
	$(VRLG) $(FLAGS) \
	control_unit/control_unit.v \
	control_unit/control_unit_test.v \
	-o out/cu.vvp

rf: register_file.vvp

register_file.vvp:
	$(VRLG) $(FLAGS) \
	register_file/register_file.v \
	register_file/register_file_test.v \
	-o out/rf.vvp

dm: data_memory.vvp

data_memory.vvp:
	$(VRLG) $(FLAGS) \
	data_memory/data_memory.v \
	data_memory/data_memory_test.v \
	-o out/dm.vvp

ig: immediate_generator.vvp

immediate_generator.vvp:
	$(VRLG) $(FLAGS) \
	immediate_generator/immediate_generator.v \
	immediate_generator/immediate_generator_test.v \
	-o out/ig.vvp

im: instruction_memory.vvp

instruction_memory.vvp:
	$(VRLG) $(FLAGS) \
	instruction_memory/instruction_memory.v \
	instruction_memory/instruction_memory_test.v \
	-o out/im.vvp

scp: single_cycle_processor.vvp

single_cycle_processor.vvp:
	$(VRLG) $(FLAGS) \
	single_cycle_processor/single_cycle_processor.v \
	program_counter/program_counter.v \
	instruction_memory/instruction_memory.v \
	immediate_generator/immediate_generator.v \
	register_file/register_file.v \
	data_memory/data_memory.v \
	control_unit/control_unit.v \
	alu/alu.v \
	single_cycle_processor/single_cycle_processor_test.v \
	-o out/scp.vvp

clean:
	rm -rf *.vvp out/

