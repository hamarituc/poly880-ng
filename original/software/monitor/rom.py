#!/bin/env python3

import argparse

parser = argparse.ArgumentParser(
    description = 'ROM-Abbilder extrahieren und Prüfsumme berechnen'
)

parser.add_argument(
    '-i', '--input',
    required = True,
    type = argparse.FileType('rb'),
    metavar = "Datei",
    help = "Eingabedatei"
)

parser.add_argument(
    '-o', '--output',
    required = True,
    type = argparse.FileType('wb'),
    metavar = "Datei",
    help = "Ausgabedatei"
)

parser.add_argument(
    '-O', '--offset',
    required = True,
    type = str,
    metavar = "Offset",
    help = "Offset ab Dateianfang"
)

parser.add_argument(
    '-S', '--size',
    required = True,
    type = str,
    metavar = "Größe",
    help = "ROM-Größe"
)

parser.add_argument(
    '-I', '--id',
    type = str,
    metavar = "ID",
    help = "Kennzahl (letztes Byte)"
)

args = parser.parse_args()


off = int(args.offset, 0)
size = int(args.size, 0)
rom = bytearray(args.input.read()[off : off + size])

s = sum(rom[0:-4])

rom[-4] = (s % 256) ^ 0xff
s = s // 256
rom[-3] = (s % 256) ^ 0xff
s = s // 256
rom[-2] = (s % 256) ^ 0xff
if args.id is not None:
    rom[-1] = int(args.id, 0)

args.output.write(rom)
