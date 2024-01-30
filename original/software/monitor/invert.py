#!/bin/env python3

import argparse

parser = argparse.ArgumentParser(
    description = 'ROM-Abbilder invertieren'
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

args = parser.parse_args()


rom = args.input.read()
rom = bytes([ b ^ 0xff for b in rom ])
args.output.write(rom)
