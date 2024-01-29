;*************************************************************************
;
; REFERENZEN FUER I/O-ADRESSEN, VARIABLENADRESSEN, KODIERUNGEN
;
;*************************************************************************
PIOD1:  EQU     080H            ; PIO DATENDRESSE SEGMENTE ANZEIGE
PIOC1:  EQU     PIOD1+1         ; PIO STEUERADRESSE SEGMENTE ANZEIGE
PIOD2:  EQU     082H            ; PIO DATENADRESSE SYSTEMTEIL
PIOC2:  EQU     PIOD2+1         ; PIO STEUERADRESSE SYSTEMTEIL
CTC:    EQU     088H            ; CTC ADRESSE SYSTEMKANAL
PIODIG: EQU     0FCH            ; ADRESSE TREIBER DIGITS
PROZ:   EQU     8               ; RELATIVE ADRESSE FUER PROGZU
NMIZ:   EQU     9               ; RELATIVE ADRESSE FUER NMIZUS
BREAK:  EQU     10              ; RELATIVE ADRESSE FUER BREAKP
H1:     EQU     12              ; RELATIVE ADRESSE FUER HR1
H2:     EQU     14              ; RELATIVE ADRESSE FUER HR2
H3:     EQU     16              ; RELATIVE ADRESSE FUER HR3
H4:     EQU     18              ; RELATIVE ADRESSE FUER HR4
H5:     EQU     19              ; RELATIVE ADRESSE FUER HR5
Z1:     EQU     0               ; KODES FUER DIE MONITORZUSTAENDE
Z2:     EQU     1+Z1
Z3:     EQU     1+Z2
Z4A:    EQU     1+Z3
Z4:     EQU     1+Z4A
Z4C:    EQU     1+Z4
Z5:     EQU     1+Z4C
Z6:     EQU     1+Z5
Z7:     EQU     1+Z6
Z8:     EQU     1+Z7
Z9:     EQU     1+Z8
Z10:    EQU     1+Z9
Z12:    EQU     1+Z10
Z13:    EQU     1+Z12
Z14:    EQU     1+Z13
Z16:    EQU     1+Z14
Z17:    EQU     1+Z16
Z18:    EQU     1+Z17
Z19:    EQU     1+Z18
Z20:    EQU     1+Z19
Z21A:   EQU     1+Z20
Z21:    EQU     1+Z21A
Z22:    EQU     1+Z21
Z23:    EQU     1+Z22
Z24:    EQU     1+Z23
Z25:    EQU     1+Z24
Z25A:   EQU     1+Z25
Z34:    EQU     1+Z25A
Z35:    EQU     1+Z34
Z36:    EQU     1+Z35
Z37:    EQU     1+Z36
Z38:    EQU     1+Z37
Z39:    EQU     1+Z38
Z40:    EQU     1+Z39
Z41:    EQU     1+Z40
Z42:    EQU     1+Z41
Z43:    EQU     1+Z42
Z44:    EQU     1+Z43
Z45:    EQU     1+Z44
Z46:    EQU     1+Z45
Z47:    EQU     1+Z46
Z48:    EQU     1+Z47
Z49:    EQU     1+Z48
Z50:    EQU     1+Z49
Z51:    EQU     1+Z50
Z52:    EQU     1+Z51
Z53:    EQU     1+Z52
Z54:    EQU     1+Z53
BIA:    EQU     3               ; DEZIMALPUNKT-BIT DER ANZEIGE
BIB:    EQU     0               ; PIO-BIT FUER FERNSCHREIBERANSCHLUSS
BIC:    EQU     2               ; PIO-BIT FUER AUSGABE AUF MAGNETBAND
BID:    EQU     1               ; PIO-BIT FUER EINGABE VOM MAGNETBAND
BIE:    EQU     6               ; PIO-BIT ZUR STEUERUNG VON SCON
