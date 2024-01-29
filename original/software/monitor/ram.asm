;*************************************************************************
;
;       L.S.RAM
;
;*************************************************************************
;
; FUNKTION: ORGANISIERT DEN RAMBEREICH DES MONITORS
;
;
        DS      1400H-$         ; Ergänzung des Original-Codes für
                                ; ROM-Aufteilung
        ORG     4000H
;       GLOBAL RAMANF RAMEND USERSP SYSTSP
;       GLOBAL ANZBER TASTBI PROGZU NMIZUS
;       GLOBAL BREAKP HR1 HR2 HR3 FSTACK
;       GLOBAL SYSP24 SYSP26 USSP2
;       GLOBAL SYSP1 ANZB4 ANZB6 ANZB2
;       GLOBAL HR4 HR5

RAMANF:                         ; ANFANG DES RAMBEREICHES
        ORG     $+3A0H          ; RESERVIERUNG VON SPEICHERPLATZ FUER ANWENDER
USERSP:                         ; ANWENDERSTACK
        ORG     $+52            ; RESERVIERUNG FUER SYSTEMSTACK
SYSTSP:                         ; SYSTEMSTACK
TASTBI: DS      8               ; ABBILD DER TASTATUR <2 BIT PRO TASTE>
ANZBER: DS      8               ; AKTUELLE WERTE FUER AUFFRISCHEN DER ANZEIGE
PROGZU: DS      1               ; ZUSTAND DES PROGRAMMS
NMIZUS: DS      1               ; ZUSTAND BEI EINTRITT IN MONITOR
BREAKP: DS      2               ; MERKZELLE FUER BREAKPOINTADRESSE
HR1:    DS      2               ; HILFSREGISTER 1 BIS 4
HR2:    DS      2
HR3:    DS      2
HR4:    DS      1
HR5:    DS      1
FSTACK: DS      16              ; FEHLERSTAPEL FUER MAGNETBANDLESEFEHLER
RAMEND: EQU     RAMANF+400H
SYSP24: EQU     SYSTSP-24
SYSP26: EQU     SYSTSP-26
SYSP1:  EQU     SYSTSP-1
ANZB2:  EQU     ANZBER+2
ANZB4:  EQU     ANZBER+4
ANZB6:  EQU     ANZBER+6
USSP2:  EQU     USERSP+2
;*INCLUDE LERNSYSTEMEQU.S
        END
