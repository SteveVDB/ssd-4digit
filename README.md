# DIY seven-segment display

![DIY seven-segment display](/ssd_4digit.jpg)

## Hardware

* [schematic](/hardware/schematic): Contains the schematic with info and a BOM.
* [PCB](/hardware/pcb): Contains the PDF files to make the printed circuit
board.

## CAD

3D-models can be found [here](/cad). I've used gray PLA for the cover and white
PLA for the segments and the colon. To ensure that the segments and the colon
fit easily into the cover, you should scale them about 2% in the X- and
Y-direction.

## Demo

The [demo](/demo) folder includes a simple up/down counter (00:00 - 59:59) with
two selectable speeds: 1Hz and 10Hz. The code is written in VHDL, and uses this
[library](https://github.com/SteveVDB/VHDL).

See [video](https://www.youtube.com/watch?v=nK1kVYSnTY8) on YouTube.
