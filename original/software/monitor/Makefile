default: all

all: monitor.bin


monitor.asm: eintritt.asm konsole.asm aktionen.asm ram.asm lernsystemequ.asm

%.bin: %.asm
	z80asm -o $@ -l$*.lst -L$*.lbl $<


clean:
	rm -f monitor.bin
	rm -f monitor.lst
	rm -f monitor.lbl
