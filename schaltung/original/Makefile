SRC = $(wildcard *.kicad_sc)

default: pc880.pdf

all: pc880.pdf pc880-bw.pdf


pc880.pdf: $(SRC)
	kicad-cli sch export pdf -n -o $@ pc880.kicad_sch

pc880-bw.pdf: $(SRC)
	kicad-cli sch export pdf -n -b -o $@ pc880.kicad_sch


clean:
	rm -f *.pdf
