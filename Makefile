VRLG = iverilog

SRC = \
    single_cycle_processor/single_cycle_processor.v \
    program_counter/program_counter.v \
    instruction_memory/instruction_memory.v \
    register_file/register_file.v \
    data_memory/data_memory.v \
    control_unit/control_unit.v \
    alu/alu.v \

OUT = scp

$(OUT): $(SRC)
	$(VRLG) -o $(OUT) $(SRC)

clean:
	rm -f $(OUT) *.vvp

