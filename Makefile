#####################################################################
 # Written by Javier Ignacio Peralta Saenz <javinachop@gmail.com>
 # Copyright (C) 2016
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
########################################################################
CC := iverilog
SIM := vvp
VIEWER := gtkwave
SYN := yosys




SRC_FLAG ?= -Isrc -Isrc/common -Isrc/dat -Isrc/register_set -Isrc/dma -Isrc/buffer -Isrc/cmd -Isrc/synthetized
TEST_FLAG ?= -Itests -Itests/dat -Itests/cmd -Itests/register_set -Itests/dma -Itest/buffer
FLAGS ?= -g2012 $(SRC_FLAG) $(TEST_FLAG)

LOG ?= tests/sim.log
SYN_DIR = src/synthetized
VCD_DIR = tests/vcd
VVP_DIR = tests/vvp

test: $(VCD_DIR)/register_set.vcd


# Register set
$(VVP_DIR)/register_set.vvp: tests/register_set/register_set-tb.v src/register_set/register_set.v $(SYN_DIR)/register_set_syn.v
	$(CC) $(FLAGS) -o $@ $<

$(VCD_DIR)/register_set.vcd: $(VVP_DIR)/register_set.vvp
	$(SIM) $< >> $(LOG)

$(SYN_DIR)/register_set_syn.v: src/register_set/register_set.v
	$(SYN) -s syn/register_set.ys
	(echo "\`include \"cmos_cells.v\""; cat src/synthetized/register_set.v) > $@
	rm $(SYN_DIR)/register_set.v



clean:
	rm -f $(VCD_DIR)/* $(VVP_DIR)/* $(LOG) $(SYN_DIR)/*


.PHONY: clean all syn test

.SECONDARY: $(OBJECTS)
