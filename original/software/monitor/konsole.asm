;*************************************************************************
;
;
;               LERNSYSTEMKONSOLE
;
;
;*************************************************************************
;
;
;FUNKTION: FUEHRT ABFRAGE DER TASTUTUR AUS UND VERZWEIGT IN ABHAENGIG-
;           KEIT VON DER EINGABE. DIE ANZEIGEEINHEIT WIRD STAENDIG AUFGE-
;          FRISCHT.
;EINGABEN: DATEN IN ANZBER
;AUSGABEN: PROGZU
;ZERSTOERT: AF,BC,DE,HL,TASTBI
;
;
;*************************************************************************
;       GLOBAL  TAST TASTU TASTB1 KONSOL KONTAS
;       EXTERNAL ZUSTAB HR3 KOMDAR
;       EXTERNAL ANZBER TASTBI PROGZU
        DS      00E4H-$,0xFF    ; Anpassung an z80asm
        ORG     00E4H
TAST:   CALL    TASTU           ; AUFRUF EINMALIGER ABFRAGE DER TASTATUR
        JR      Z,TAST          ; ZERO = KEINE EINGABE
        LD      HL,ZUSTAB       ; ANFANG DER ZUSTANDSTABELLE
        BIT     0,A
        JR      Z,TASTZ         ; ZIFFER EINGEGEBEN
        AND     0F0H
        CP      KODENT          ; ENTER?
        JR      NZ,TASTA
TASTC:  LD      D,00H
        LD      E,(IY+PROZ)     ; PROGRAMMZUSTAND LADEN
        SLA     E
        SLA     E               ; *4
        ADD     HL,DE           ; BERECHNUNG DER ANSPRUNGADRESSE
        LD      E,(HL)
        INC     HL
        LD      D,(HL)          ; ANSPRUNGADRESSE LADEN
        EX      DE,HL
        LD      DE,TAST         ; RUECKKEHRADRESSE VORBEREITEN
        PUSH    DE
        JP      (HL)            ; ANSPRUNG EINER 'AKTION'
TASTA:  CP      KODVR           ; TASTE 'BACK'?
        JR      NZ,TASTB
        LD      A,(PROGZU)
        CP      Z4              ; ZUSTAENDE IN DENEN 'BACK' ZULAESSIG
        JR      Z,TASTD         ; ERKENNEN
        CP      Z7
        JR      Z,TASTD
        CP      Z4A
        JR      Z,TASTD
        CP      Z4C
        JR      NZ,TAST
TASTD:  SET     3,(IY+1)        ; 'BACK' KENNZEICHNEN
        JR      TASTC
TASTB:  RRCA                    ; KOMMANDO-EINGABE ERFOLGT
        RRCA
        RRCA
        DEC     A
        DEC     A
TASTB1: LD      C,A             ; EINTRITT FUER F-KOMMANDOS
        LD      B,00H
        LD      HL,ANZKNA       ; ANZEIGE DES KOMMANDOS
        ADD     HL,BC
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        PUSH    BC
        CALL    KOMDAR          ; NAME KOMMANDO IN ANZEIGE
        POP     BC
        SRL     C
        LD      HL,KZUADR       ; ADRESSE FUER ZUSTAND BESTIMMEN
        ADD     HL,BC
        LD      E,(HL)
        LD      (IY+PROZ),E     ; NEUEN ZUSTAND ABSPEICHERN
        JR      TAST
TASTZ:  INC     HL              ; ZIFFER EINGEGEBEN
        INC     HL
        LD      A,C
        JR      TASTC
;*E
;*************************************************************************
;
;
;       UNTERPROGRAMM:TASTU
;
;
;*************************************************************************
;
;FUNKTION: FUEHRT EINE EINMALIGE ABFRAGE DER TASTATUR AUS UND FRISCHT
;          DABEI DIE ANZEIGE EINMAL AUF
;EINGABEN: ANZBER
;AUSGABEN: ZERO - ZEIGT AN, OB TASTE BETAETIGT WURDE
;          A - KODE DER TASTE
;           C - EINGEGEBENE ZIFFER IN HEX.DARSTELLUNG
;ZERSTOERT: F,B,DE,HL
TASTU:  LD      DE,ANZBER       ; ANFANGSWERT FUER EINGEABE
KONSOL: LD      HL,TASTBI       ; TABELLE MIT ABBILD DER TASTATUR
KONTAS: XOR     A               ; ANFANGSWERT FUER EINGABE
        LD      (HR3),A
TAST10: LD      B,80H           ; AUSGABE FUER DIGITTREIBER
TAST11: LD      A,(DE)          ; AUSGABEWERT
TASTX:  OUT     (PIOD1),A       ; SEGMENTE
        LD      A,B
        OUT     (PIODIG),A      ; DIGITS
        INC     DE
        PUSH    DE
        IN      A,(PIOD2)       ; TASTATUR ABFRAGEN
        AND     0B0H            ; MASKE FUER EINGABEBITS DER TASTEN
        LD      E,(HL)          ; ABBILDWERT HOLEN
        LD      C,4             ; ZAEHLER
TASTX1: RLA
        LD      D,A
        JR      C,TASTX4        ; TASTE IST GEDRUECKT
        LD      A,E
        RRCA
        RRCA
        LD      E,A
        AND     03H
        JR      Z,TASTX2
        DEC     E               ; ENTPRELLZAEHLER DECREMENTIEREN
TASTX3: JR      TASTX2
TASTX4: LD      A,E             ; TASTE GEDRUECKT
        RRCA
        RRCA
        LD      E,A
        AND     03H
        JR      NZ,TASTX6       ; KEINE NEUE TASTE
        LD      A,C
        PUSH    BC
TASTX7: ADD     A,10H           ; KODE ERRECHNEN
        RRC     B
        BIT     6,B
        JR      Z,TASTX7        ; BERECHNUNG TASTENWERT
        LD      (HR3),A         ; KODE ABSPEICHERN
        POP     BC
TASTX6: LD      A,E
        OR      03H             ; TASTE IST GEDRUECKT ERKEN
        LD      E,A
TASTX2: LD      A,D
        DEC     C               ; ZYKLUSZAEHLER
        JR      NZ,TASTX1       ; SCHLEIFE SCHLIESSEN
        LD      A,E
        LD      (HL),A          ; TASTABBILD SPEICHERN
        INC     HL
        POP     DE
        LD      A,ZEIT
ZEIT:   EQU     40
TASTX5: DEC     A               ; WARTESCHLEIFE FUER ANZEIGE EINER DIGIT
        JR      NZ,TASTX5
        LD      A,00H
        OUT     (PIODIG),A      ; DIGITS ABSCHALTEN
        RRC     B               ; NAECHSTES DIGIT ANWAEHLEN
        JR      NC,TAST11
        LD      A,(HR3)
        PUSH    AF              ; ZYKLUS FERTIG
        BIT     1,A             ; ZIFFERNBEREICH FESTSTELLEN
        JR      NZ,TAST30
        LD      B,4
        DB      0FEH            ; KODE 'CP'
TAST30: LD      B,00H
        AND     0F0H            ; HEX.KODE FUER ZIFFER BERECHNUNG
        LD      DE,ZITAB
        DEC     DE
TAST32: INC     DE
        SUB     10H
        JR      NZ,TAST32
        LD      A,(DE)          ; KODE AUS TABELLE LADEN
        ADD     A,B
        LD      C,A             ; HEX.KODE IN C UEBERGEBEN
        POP     AF
TAST33: AND     A               ; TEST OB EINGABE ERFOLGTE
        RET
;*E
;*************************************************************************
;
; DEFINITIONEN
;
;*************************************************************************
KODENT: EQU     40H             ; KODE BEI EINGABE VON 'EXEC'
KODVR:  EQU     50H             ; KODE BEI EINGABE VON 'BACK'
ZITAB:  DB      0AH             ; TABELLE VON HEX.KODES FUER ZIFFERN
        DB      00H
        DB      2H
        DB      3H
        DB      1H
        DB      8H
        DB      9H
        DB      0BH
KZUADR: DB      Z5              ; TABELLE FUER ZUSTAENDE BEI KOMMANDOAUFRUF
        DB      Z8
        DB      Z1
        DB      Z1
        DB      Z1
        DB      Z2
        DB      Z16
        DB      Z12
        DB      Z46
        DB      Z49
        DB      Z34
        DB      Z40
        DB      Z17
        DB      Z22
ANZKNA: DW      0E5E5H          ; TABELLE FUER NAMEN DER KOMMANDOS
        DW      6717H
        DW      0000H
        DW      0000H
        DW      0000H
        DW      1167H
        DW      71C7H
        DW      7653H
        DW      0F184H
        DW      0F1E7H
        DW      0E573H
        DW      7143H
        DW      0E584H
        DW      0E5E7H
;*INCLUDE LERNSYSTEMEQU.S
        END
