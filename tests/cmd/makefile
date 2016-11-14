DIRS = ../../bin/tests/cmd ../vcd
IVERILOG = iverilog
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

all:
	@cd ../.. &&  $(foreach dir,$(wildcard test*.v),  $(IVERILOG) -o bin/$(subst .v,,$(dir)) tests/cmd/$(dir); ) 
	

clean:	
	@rm -R bin
	@rm -R tests/vcd