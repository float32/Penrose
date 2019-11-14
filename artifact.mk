# Copyright 2019 Tyler Coy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

T_ZIP   := $(TARGET_DIR)/$(DIST_ZIP)
T_HEX   := $(TARGET_DIR)/$(MERGE_HEX)
APP_HEX := $(TARGET_DIR)/$(APP_ELF:.elf=.hex)
APP_WAV := $(TARGET_DIR)/$(APP_ELF:.elf=.wav)
BL_HEX  := $(TARGET_DIR)/$(BL_ELF:.elf=.hex)

DISTRIBUTABLES := $(APP_HEX) $(APP_WAV) $(BL_HEX) $(T_HEX)

PROGRAMMER ?= usbasp
PROGRAMMER_PORT ?= usb
AVRDUDE_OPTS += -c $(PROGRAMMER) -P $(PROGRAMMER_PORT)

.PHONY: wav
wav: $(APP_WAV)

.PHONY: merge
merge: $(T_HEX)

$(T_HEX): $(APP_HEX) $(BL_HEX)
	python3 merge-hex.py -o $@ -i $^

.PHONY: load
load: $(T_HEX)
	avrdude -B100 $(AVRDUDE_OPTS) -p atmega168 -U lfuse:w:0xff:m -U hfuse:w:0xd4:m -U efuse:w:0x02:m
	avrdude -B1 $(AVRDUDE_OPTS) -p atmega168 -U flash:w:$^:i
	avrdude -B1 $(AVRDUDE_OPTS) -p atmega168 -U lock:w:0x0F:m

.PHONY: dist
dist: $(T_ZIP)

$(T_ZIP): $(DISTRIBUTABLES)
	cd $(dir $@) && zip -q9 $(notdir $@ $^)

clean: clean_artifact
mostlyclean: clean_artifact

.PHONY: clean_artifact
clean_artifact:
	$(RM) $(DISTRIBUTABLES) $(T_ZIP)
