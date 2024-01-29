;*************************************************************************
;
;       PROGRAMM: U880-MONITOR
;
;       COPYRIGHT (C) 1982
;       VEB KOMBINAT POLYTECHNIK UND PRAEZISIONSGERAETE
;       DDR-9023 KARL-MARX-STADT
;       MELANCHTHONSTRASSE 4-8
;
;*************************************************************************
;
;
; INHALT
; ======
;
; DIESES PROGRAMM LAEUFT AUF DEM U880-LERNSYSTEM POLY-COMPUTER 880 DES
; VEB POLYTECHNIK UND STELLT DEM NUTZER EINEN KLEINEN MONITOR ZUR UNTER-
; STUETZUNG DER PROGRAMMERSTELLUNG ZUR VERFUEGUNG. DAS PROGRAMM ERMOEG-
; LICHT ES, UEBER DIE TASTATUR DES LERNSYSTEMS DEN SPEICHER- ODER DEN
; REGISTERINHALT ZU UEBERPRUEFEN UND ZU VERAENDERN, EIN PROGRAMM IN DEN
; RAM ZU LADEN UND DIESES AUSZUFUEHREN. DIE PROGRAMMTESTUNG WIRD DURCH
; EINZELSCHRITTBETRIEB UND BELIEBIG VIELE SOFTWAREPRUEFPUNKTE UNTER-
; STUETZT. DATEN KOENNEN AUF EIN MAGNETBANDGERAET AUSGEGEBEN UND VON
; DIESEM EINGELESEN WERDEN. IM RAM KOENNEN BEREICHE VERSCHOBEN UND MIT
; EINEM DATENMUSTER GEFUELLT WERDEN. DER MONITOR GESTATTET DEN ZUGRIFF
; ZU ALLEN EIN- UND AUSGABEPORTS. DER NUTZER DES SYSTEMS KANN UNTERPRO-
; GRAMME ZUR ANSTEUERUNG DER TASTATUR UND DER ANZEIGEEINHEIT DES LERN-
; SYSTEMS VERWENDEN, DIE IM MONITORPROGRAMM ENTHALTEN SIND.
; DIE VERWENDUNG VON UNTERBRECHUNGEN IST IN ALLEN 3 BETRIEBSARTEN DES
; U880 MOEGLICH. NMI IST FUER SYSTEMFUNKTIONEN RESERVIERT.
;
;
; PROGRAMMORGANISATION
; ====================
;
; DAS GESAMTE MONITORPROGRAMM BESTEHT AUS 4 MODULEN. DAS EINTRITTSPRO-
; GRAMM BEHANDELT ALLE SINNVOLLEN EINTRITTE IN DAS MONITORPROGRAMM VON
; ANWENDERPROGRAMMEN (EINZELSCHRITTBETRIEB, PRUEFPUNKT) ODER NACH RESET.
; DAS KONSOLPROGRAMM ERKENNT DIE BETAETIGUNG VON TASTEN UND RUFT ENT-
; SPRECHENDE BEARBEITUNGSPROGRAMME AUF. WAEHREND DES WARTENS AUF EINE
; EINGABE WIRD DIE ANZEIGEEINHEIT STAENDIG AUFGEFRISCHT. IM AKTIONSPRO-
; GRAMM SIND ALLE ROUTINEN ENTHALTEN, DIE DIE EIGENTLICHE REALISIERUNG
; DER FUNKTIONEN BEWIRKEN. DAS RAMPROGRAMM ENTHAELT DEFINITIONEN, DIE
; SPEICHERPLAETZE FUER DIE ARBEIT DES MONITORS RESERVIEREN.
; DAS MONITORPROGRAMM BELEGT 2K BYTE ROM AUF DEN ADRESSEN 0-3FFH UND
; 1000H-13FFH. DIESE AUFTEILUNG GESTATTET DIE VERWENDUNG EINES EIN-
; FACHEREN ADRESSDEKODERS. WEITERHIN WIRD DURCH DEN MONITOR DER RAMBE-
; REICH 43A0H-43FFH BELEGT. ZUSAETZLICH ZU DEN AUFGEZAEHLTEN PROGRAMMEN
; EXISTIERT EINE QUELLDATEI, DIE EINE ANZAHL VON WERTZUWEISUNGEN ENT-
; HAELT UND DIE VON ALLEN PROGRAMMEN ALS REFERENZ BENUTZT WIRD.
;
;*E
;*************************************************************************
;
;       EINTRITTSPROGRAMM
;
;*************************************************************************
;
;       FUNKTION: BEARBEITET ALLE EINTRITTE IN DAS
;                 MONITORPROGRAMM
;       EINGABEN: NMIZUS
;       AUSGABEN: NMIZUS,PROGZU,VERZWEIGT ZU KONSOL-
;                 PROGRAMM
;       EXTERNAL USERSP SYSTSP ANZBER USSP2
;       EXTERNAL BREAKP RAMANF
;       EXTERNAL HR1 NMIZUS TRST KOMDAR
;       EXTERNAL ADRAUS DAAUS
;       EXTERNAL HR4 SYSP24 SYSP26
;       EXTERNAL Z10EM4
;*************************************************************************
;
;       RESET-EINTRITTSPUNKT
;
;*************************************************************************
        ORG     0000H
        LD      SP,USSP2        ; SP FUER ANWENDER
        LD      BC,PZAHL        ; RAM INITIALISIEREN
        LD      HL,IWERTE       ; WERT-TABELLE
        LD      DE,ANZBER       ; RAM-BEREICH
        LDIR                    ; RAMINITIALISIERUNG
        LD      A,0FH           ; KODE FUER OUTPUTMODE
        OUT     (PIOC1),A       ; PIO1 PROGRAMMIEREN (SEGMENTANSTEUERUNG)
        LD      BC,300H | PIOC2
        OTIR                    ; PIO2 PROGRAMMIEREN (BITMODE)
        LD      A,01H           ; ANFANGSDATEN PIO2
        OUT     (PIOD2),A       ; DATENAUSGABE
MONRM1: LD      A,05H           ; KODE FUER CTC (TIMER)
        OUT     (CTC),A         ; CTC STARTEN
        LD      A,5             ; ZAEHLKONSTANTE
        OUT     (CTC),A
        POP     AF
        JR      $               ; WARTEN
;*************************************************************************
;
;       EINTRITT        FUER RESTART 5
;
;*************************************************************************
        DS      28H-$,0xFF      ; Anpassung an z80asm
        ORG     28H
        PUSH    AF
        LD      A,01H
        LD      (NMIZUS),A      ; URSACHE EINTRITT MERK.
        JR      MONRM1
;*************************************************************************
;
;       EINTRITT        FUER RESTART 6
;
;*************************************************************************
        DS      30H-$,0xFF      ; Anpassung an z80asm
        ORG     30H
        PUSH    AF
        LD      A,02H           ; URSACHE=PR.PUNKT
        LD      (NMIZUS),A
        JR      MONRM1
;*************************************************************************
;
;       EINTRITTSPUNKT FUER INTERRUPTMODE 0 UND 1
;
;*************************************************************************
        DS      38H-$,0xFF      ; Anpassung an z80asm
        ORG     38H
        JP      RAMANF
;*************************************************************************
NMIM1:  LD      (HR1),SP        ; SP ABSPEICHERN
        LD      SP,SYSTSP       ; SYSTEMSTACKPOINTER
        PUSH    AF              ; ERSTER REGISTERSATZ
        PUSH    BC
        PUSH    DE
        PUSH    HL
        EX      AF,AF'          ; ZWEITER REGISTERSATZ
        EXX
        PUSH    AF              ; REGISTER ABSPEICHERN
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      A,I             ; INTERRUPTREG. UND EI
        LD      B,A
        LD      C,01H
        JP      PE,NMIM2
        LD      C,00H           ; EI=0
NMIM2:  PUSH    BC              ; I UND EI ABSPEICHERN
        PUSH    IX
        PUSH    IY
        LD      HL,(HR1)        ; SP HOLEN
        LD      E,(HL)          ; PC VOM STACK HOLEN
        INC     HL
        LD      D,(HL)
        INC     HL
        PUSH    HL              ; SP ABSPEICHERN
        PUSH    DE              ; PC ABSPEICHERN
        JR      NMIM3
;*************************************************************************
;
;       EINTRITT        BEI NMI
;
;*************************************************************************
        DS      66H-$,0xFF      ; Anpassung an z80asm
        ORG     66H
        JR      NMIM1
;*************************************************************************
NMIM3:  LD      A,03H
        OUT     (CTC),A         ; CTC STOPPEN
        LD      IY,ANZBER       ; STAENDIGER ZEIGER
        LD      A,41H           ; SCON AUF HOCH
        OUT     (PIOD2),A       ; FF1 LOESCHEN
        LD      HL,(BREAKP)
        LD      A,(HR4)         ; BEFEHLSKODE
        LD      (HL),A
        LD      A,(NMIZUS)      ; EINTRITTSURSACHE
        DEC     A
        JR      Z,BRSYST        ; SYSTEMPRUEFPUNKT
        DEC     A
        JR      Z,BRUSER        ; ANWENDERPRUEFPUNKT
        DEC     A
        JR      Z,NORST         ; EINZELSCHRITT
        DEC     A
        JR      Z,BREST         ; SCHRITT NACH PRUEFP.
        DEC     A
        JR      Z,JPTRST        ; RESET
MONINT: LD      DE,ANMON        ; MONITORTASTE
        JR      BRUSM1
BRSYST: CALL    SPPCKO          ; KORREKTUR SP UND PC
        DEC     DE              ; PC STELLEN
        LD      (SYSP26),DE     ; PC ABSPEICHERN
        LD      (IY+NMIZ),4     ; ZUSTAND MERKEN
        JP      Z10EM4          ; ANSPRUNG STEP
BRUSER: CALL    SPPCKO          ; ANWENDERPRUEFPUNKT
        LD      DE,ANUSBR
BRUSM1: CALL    KOMDAR          ; DATEN NACH ANZ.BEREICH
NORST:  LD      HL,(SYSP26)     ; PC
        PUSH    HL
        CALL    ADRAUS          ; ADR. IN ANZEIGE
        POP     HL
        RES     BIA,(IY+5)
        LD      H,(HL)          ; DATEN IN ANZEIGE
        CALL    DAAUS
        RES     BIA,(IY+7)
JPTRST: JP      TAST            ; TASTATUR ANSPRINGEN
BREST:  LD      DE,ANBREA       ; KODE FUER BREAK
        JR      BRUSM1
;*************************************************************************
;
;       FUNKTION: KORRIGIERT SP UND PC
;       EINGABE: KEINE
;       AUSGABE: SYSP-24
;                 SYSP-26
;       ZERSTOERT: DE,HL
;
;*************************************************************************
SPPCKO: LD      HL,(SYSP24)     ; SP LADEN
        LD      E,(HL)          ; PC HOLEN
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      (SYSP24),HL     ; SP ABSPEICHERN
        LD      (SYSP26),DE     ; PC ABSPEICHERN
        RET
;*E
;*************************************************************************
;
; DEFINITIONEN
;
;*************************************************************************
ANBREA: EQU     5711H
ANMON:  EQU     0E557H
ANUSBR: EQU     0C757H
IOBITS: EQU     10111011B
IWERTE: DB      0F1H            ; ANFANGSWERTE FUER ANZEIGE
        DB      0E7H
        DB      43H
        DB      0D6H
        DB      10H
        DB      0F7H
        DB      0F7H
        DB      0E7H
        DB      Z1              ; ANFANGSZUSTAND DES MONITORS
        DB      5               ; NMI-ZUSTAND:=RESET
        DW      0000H           ; BREAKPOINT GELOESCHT
PZAHL:  EQU     12
        DB      0CFH
        DB      IOBITS
        DB      07H
;INCLUDE LERNSYSTEMEQU.S
        END
