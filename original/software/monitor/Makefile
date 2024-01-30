default: monitor.bin

all: monitor.bin monitor_0000.bin monitor_1000.bin monitor_0000i.bin monitor_1000i.bin


monitor.asm: eintritt.asm konsole.asm aktionen.asm ram.asm lernsystemequ.asm

%.bin: %.asm
	z80asm -o $@ -l$*.lst -L$*.lbl $<

monitor_0000.bin: monitor.bin
	./rom.py -o $@ -i $< -O 0x0000 -S 0x0400 -I 0x21

monitor_1000.bin: monitor.bin
	./rom.py -o $@ -i $< -O 0x0400 -S 0x0400 -I 0x22

%i.bin: %.bin
	./invert.py -o $@ -i $<


clean:
	rm -f *.bin
	rm -f monitor.lst
	rm -f monitor.lbl
