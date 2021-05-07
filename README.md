# Penrose Quantizer Firmware

This is the sourcecode for the Sonic Potions Penrose Quantizer eurorack module.
The project page with more information about the module can be found here:
http://www.sonic-potions.com/penrose

Penrose is a simple CV quantizer DIY kit for the eurorack format.  It takes an
incoming continuous CV voltage and converts it to the nearest note in a scale.
Active notes can be selected with the 12 buttons. You can use it to tune the
output of your analog sequencer, as a semi random melody generator, for fast
chiptune arpeggios and much more.

The code has multiple separate parts:

- The app directory contains the Quantizer AVR main program
- The drivers directory contains AVR peripheral drivers for use by the main
  program
- The Bootloader directory contains an audio bootloader for the AVR and a C++
  program to generate .wav files from AVR .hex files
- The root directory contains makefiles for building each part

## Changes in this fork

The bootloader has been left as is but the application has been heavily
refactored.

- Ported everything to c++.
- Moved to a sample-rate-based architecture instead of loop-based. The sample
  rate is 8 kHz, and the theoretical maximum is 12 kHz (limited by the ADC).
- Changed the quantizer behavior to find the nearest enabled note, instead of
  the nearest higher.
- Optimized drivers.
- Fixed a lot of bugs, some that caused crashing and some that only caused
  misbehavior.
- Replaced the build system with `boilermake`. All build artifacts now go into
  the 'build' directory.

## Building from source

Dependencies: `gcc-avr`, `avr-libc`, `python3`, `python3-intelhex`

After cloning the repository, be sure to grab the submodules as well by running
`git submodule update --init --recursive`

From the root directory, run `make merge` to generate a hex file containing
both the bootloader and application. The file is written to
build/artifact/penrose.hex.

Some other `make` targets are:

- `load` : program a chip with the merged hex file (requires `avrdude`)
- `wav`  : generate a wav file for use with the audio bootloader (requires `gcc`)
- `cog`  : regenerate lookup tables (requires Python 3 `cogapp` package)
- `check`: run unit tests (requires Google Test)

## License

The code is released under the GPL:

Copyright 2015 Julian Schmidt, Sonic Potions <julian@sonic-potions.com>
Web: www.sonic-potions.com/penrose

Copyright 2019 Tyler Coy

This file is part of the Penrose Quantizer Firmware.

The Penrose Quantizer Firmware is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

The Penrose Quantizer Firmware is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
License for more details.

You should have received a copy of the GNU General Public License
along with the Penrose Quantizer Firmware.  If not, see
<http://www.gnu.org/licenses/>.
