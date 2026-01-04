;*************************************************************************
;
;       AKTIONSPROGRAMME DES LERNSYSTEMS
;
;*************************************************************************
;
; FUNKTION: FUEHRT DIE EINGEGEBENEN KOMMANDOS AUS
;
        DS      01F4H-$,0xFF    ; Anpassung an z80asm
        ORG     01F4H
;       GLOBAL  ZUSTAB KOMDAR ADRAUS DAAUS
;       GLOBAL  ANZDEC ADRANZ DASCH
;       GLOBAL  Z10EM4 FUNKAN RDYANZ ZIFANZ
;       GLOBAL  LDMA BS DS BL DL
;       EXTERNAL TASTB1 TASTU
;       EXTERNAL ANZB2 ANZB6
;       EXTERNAL ANZBER HR1 HR2 HR3 ANZB4
;       EXTERNAL RAMANF RAMEND BREAKP
;       EXTERNAL SYSP26 SYSP1 FSTACK
;       EXTERNAL HR4
;*************************************************************************
;
;       ZUSTANDSTABELLE
;
;*************************************************************************
;
;       FUNKTION: ENTHAELT ANSPRUNGADRESSEN FUER AUSZUFUEHRENDE
;       AKTIONEN IN ABHAENGIGKEIT VOM ZUSTAND DES
;       MONITORS UND DER EINGABE.
;       DIE ERSTE ANSPRUNGADRESSE EINES ZUSTANDES WIRD
;       BEI EINGABE VON 'EXEC' ANGESPRUNGEN, DIE ZWEITE
;       BEI BETAETIGUNG DER HEXADEZIMALTASTATUR.
;*************************************************************************
ZUSTAB: DW      RETURN          ; Z1:   KEIN KOMMANDO ANGEWAEHLT
        DW      RETURN
;*************************************************************************
        DW      Z2E             ; Z2:   KOMMANDO 'REGISTER' GEWAEHLT
        DW      Z2Z
        DW      Z3E             ; Z3:   REGISTERNAME EINGEGEBEN
        DW      Z3Z
        DW      Z4AE            ; Z4A:  MODIFIKATION DES HOEHERWERTIGEN
        DW      Z4AZ            ;       REGISTERS
        DW      Z4E             ; Z4:   MODIFIKATION DES NIEDERWERTIGEN
        DW      Z4Z             ;       REGISTERS
        DW      Z4CE            ; Z4C:  MODIFIKATION EINES WORTREGISTERS
        DW      Z4CZ
;*************************************************************************
        DW      Z5E             ; Z5:   KOMMANDO SPEICHERMODIFIKATION
        DW      Z5Z
        DW      Z6E             ; Z6:   SPEICHERADRESSE EINGEGEBEN
        DW      Z6Z
        DW      Z7E             ; Z7:   DATEN IM SPEICHER MODIFIZIERBAR
        DW      Z4Z
;*************************************************************************
        DW      Z8E             ; Z8:   KOMMANDO PROGRAMMSTART GEWAEHLT
        DW      Z5Z
        DW      Z9E             ; Z9:   EINGABE EINER NEUEN STARTADRESSE
        DW      Z6Z
        DW      Z10E            ; Z10:  EINGABE EINES PRUEFPUNKTES
        DW      Z6Z
;*************************************************************************
        DW      Z12E            ; Z12:  KOMMANDO SCHRITTBETRIEB GEWAEHLT
        DW      Z5Z
        DW      Z13E            ; Z13:  ADRESSE FUER SCHRITT EINGEBEN
        DW      Z6Z     
        DW      Z14E            ; Z14:  SCHRITT(E) WURDE(N) AUSGEFUEHRT
        DW      RETURN
;*************************************************************************
        DW      RETURN          ; Z16:  KOMMANDO FUNKTION WURDE ANGEWAEHLT
        DW      Z16Z
;*************************************************************************
        DW      RETURN          ; Z17:  MAGNETBANDEINGABE WURDE ANGEWAEHLT
        DW      Z5Z
        DW      Z18E            ; Z18:  EINGABE DER ANFANGSADRESSE
        DW      Z6Z
        DW      RETURN          ; Z19:  ANFANGSADRESSE UEBERNOMMEN
        DW      Z5Z
        DW      Z20E            ; Z20:  EINGABE DER ENDADRESSE
        DW      Z6Z
        DW      Z21AE           ; Z21A: ABFRAGE 'READY?'
        DW      RETURN
        DW      Z21E            ; Z21:  AUSFUEHRUNG UND FEHLERANZEIGE
        DW      RETURN
;*************************************************************************
        DW      RETURN          ; Z22:  MAGNETBANDAUSGABE GEWAEHLT
        DW      Z5Z
        DW      Z18E            ; Z23:  EINGABE DER ANFANGSADRESSE
        DW      Z6Z
        DW      RETURN          ; Z24:  ANFANGSADRESSE UEBERNOMMEN
        DW      Z5Z
        DW      Z20E            ; Z25:  EINGABE DER ENDADRESSE
        DW      Z6Z
        DW      Z25AE           ; Z25A: ABFRAGE 'READY?' UND AUSFUEHRUNG
        DW      RETURN
;*************************************************************************
        DW      RETURN          ; Z34:  KOMMANDO DATENTRANSPORT GEWAEHLT
        DW      Z5Z
        DW      Z35E            ; Z35:  EINGABE DER ZIELADRESSE
        DW      Z6Z
        DW      RETURN          ; Z36:  ZIELADRESSE WURDE UEBERNOMMEN
        DW      Z5Z
        DW      Z37E            ; Z37:  EINGABE DER QUELLADRESSE
        DW      Z6Z
        DW      RETURN          ; Z38:  QUELLRDRESSE WURDE UEBERNOMMEN
        DW      Z5Z
        DW      Z39E            ; Z39:  EINGABE DER LAENGE UND AUSFHRG.
        DW      Z6Z
;*************************************************************************
        DW      RETURN          ; Z40:  KOMMANDO FUELLEN GEWAEHLT
        DW      Z5Z
        DW      Z41E            ; Z41:  EINGABE DER ANFANGSADRESSE
        DW      Z6Z
        DW      RETURN          ; Z42:  ANFANGSADRESSE WURDE UEBERNOMMEN
        DW      Z5Z
        DW      Z43E            ; Z43:  EINGABE DER ENDADRESSE
        DW      Z6Z
        DW      RETURN          ; Z44:  ENDADRESSE WURDE UEBERNOMMEN
        DW      Z44Z
        DW      Z45E            ; Z45:  EINGABE DES DATENMUSTERS UND
        DW      Z4Z             ;       AUSFUEHRUNG
;*************************************************************************
        DW      RETURN          ; Z46:  KOMMANDO PORTEINGABE ANGEWAEHLT
        DW      Z5Z
        DW      Z47E            ; Z47:  EINGABE DER PORTADRESSE
        DW      Z47Z
        DW      Z48E            ; Z48:  DARSTELLUNG GELESENER DATEN
        DW      Z47Z
;*************************************************************************
        DW      RETURN          ; Z49:  KOMMANDO PORTEINGABE GEWAEHLT
        DW      Z5Z
        DW      Z50E            ; Z50:  EINGABE DER PORTADRESSE
        DW      Z47Z
        DW      RETURN          ; Z51:  PORTADRESSE WURDE UEBERNOMMEN
        DW      Z44Z
        DW      Z52E            ; Z52:  EINGABE DER. AUSGABEDATEN UND
        DW      Z4Z             ;       AUSFUEHRUNG
;*E
;*************************************************************************
;
; MACRO-DEFINITIONEN
;
;*************************************************************************
SBWC:   MACRO                   ; REGISTERPAARSUBTRAKTION OHNE CARRY
        AND     A
        SBC     HL,DE
        ENDM
WAIT:   MACRO PWAIT             ; ZEITSCHLEIFE
        LD      B,PWAIT
        DJNZ    $
        ENDM
SWAIT:  MACRO PSW
        LD      A,PSW
.SWSYM: DEC     A
        JR      NZ,.SWSYM
        ENDM
;*M OFF                         ; KEINE MACROEXPANSION IN DER LISTE
;*E
;*************************************************************************
;
; UNTERPROGRAMME
;
;*************************************************************************
;
; KOMMANDODARSTELLUNG
;
; FUNKTION: TRANSPORTIERT INHALT VON DE IN DEN ANZEIGEBEREICH (LINKS-
;           BUENDIG). WIRD ZUR ANZEIGE DER KOMMANDOART VERWENDET.
;           DER UEBRIGE ANZEIGEBEREICH WIRD GELOESCHT (AUF 00H GESETZT).
; ZERSTOERT: F,B,HL
KOMDAR: LD      HL,ANZBER       ; KOM. IN ANZ
FUNKAN: LD      (HL),D          ; FUNKTIONSANZEIGE
        INC     HL
        LD      (HL),E
        LD      B,6
KOMDA1: INC     HL
        LD      (HL),00H        ; REST DER ANZEIGE LOESCHEN
        DJNZ    KOMDA1
        RET
;*************************************************************************
;
; MAGNETBAND BEREIT
;
; FUNKTION: TRANSPORTIERT TEXT ' READY ?' IN ANZEIGEBEREICH
; ZERSTOERT: F,BC,DE,HL
;
MBREADY:LD      DE,ANZBER
RDYANZ: LD      HL,MBRTEX       ; ANZEIGE 'READY?'
TRANS:  LD      BC,8
        LDIR
        RET
MBRTEX:
        DB      00H
        DB      11H
        DB      73H
        DB      0F5H
        DB      97H
        DB      0D6H
        DB      00H
        DB      0B9H
;*************************************************************************
; DATENSCHIEBEN
;
; FUNKTION: VERSCHIEBT D3 BIS D0 IM ACCU IN DAS HILFSREGISTER HR1
; ZERSTOERT: HL
;
DASCH:  LD      HL,HR1
LDMA:   PUSH    AF              ; LADE MEMORY MIT A
        RLD
        INC     HL
        RLD
        POP     AF
        RET
;*************************************************************************
;
; ANZEIGE EINER ADRESSE
;
; FUNKTION: SCHIEBT DEN INHALT VON A IN DEN ADRESSBEREICH DER ANZEIGE
;           IN GEEIGNETEM KODE
; ZERSTOERT: AF,DE
;
ADRANZ: PUSH    HL
        LD      HL,ANZB2
ADRAN1: PUSH    BC
        LD      B,3
        JR      DAANZ1
;*************************************************************************
;
; ANZEIGE VON DATEN
;
; FUNKTION: SCHIEBT DEN INHALT VON A IN DEN DATENBEREICH DER ANZEIGE
; IN GEEIGNETEM KODE
; ZERSTOERT: AF,DE
;
DAANZ:  PUSH    HL
        LD      HL,ANZB6
DAANZ3: PUSH    BC
        LD      B,1
DAANZ1: LD      E,L
        LD      D,H
        INC     HL
        AND     0FH
        LD      C,A
DAANZ2: LD      A,(HL)
        RES     BIA,A           ; PUNKT LOESCHEN
        LD      (DE),A
        INC     DE
        INC     HL
        DJNZ    DAANZ2
        LD      HL,ANZDEC
        ADD     HL,BC
        LD      A,(HL)
        LD      (DE),A
        POP     BC
        POP     HL
        RET
;*************************************************************************
;
; ANZEIGE EINER ZIFFER DURCH EINSCHIEBEN
; ZERSTOERT AF,DE
;
ZIFANZ: PUSH    HL
        PUSH    BC
        JR      DAANZ1
;*************************************************************************
;
; ANZEIGE VON DATEN IM ANZEIGEBEREICH 4,5
;
; FUNKTION: SCHIEBT DATEN AUS A IN DEN ANZEIGEBEREICH
; ZERSTOERT: AF,DE
;
HDAANZ: PUSH    HL
        LD      HL,ANZB4
        JR      DAANZ3
;*************************************************************************
;
; ANZEIGE VON WORTEN IM DATENBEREICH
;
; FUNKTION: SCHIEBT DEN INHALT VON A IN DIE STELLEN 5 BIS 7 DES ANZEIGE-
;           BEREICHES
; ZERSTOERT: AF,DE
;
LDAANZ: PUSH    HL
        LD      HL,ANZB4
        JR      ADRAN1
;*************************************************************************
;
; ANZEIGEKODETABELLE
;
; FUNKTION: ENTHAELT IN AUFSTEIGENDER REIHENFOLGE DIE SIEBENSEGMENTKODES
;           FUR DIE HEXADEZIMALZIFFFRN 0 BIS F
;
ANZDEC: DB      0EFH
        DB      8CH
        DB      0BBH
        DB      0BEH
        DB      0DCH
        DB      7EH
        DB      7FH
        DB      0ACH
        DB      0FFH
        DB      0FEH
        DB      0FDH
        DB      5FH
        DB      6BH
        DB      9FH
        DB      7BH
        DB      79H
;*************************************************************************
;
; VERSCHIEBEN DES INHALTS VON HL HACH A
;
; FUNCTION: VERSCHIEBT DIE BITS D15 - D12 VON HL NACH A
; ZERSTOERT: A,HL
;
SHIHLA: PUSH    BC
        XOR     A
        LD      B,4
SHIHL1: RL      L
        RL      H
        RLA
        DJNZ    SHIHL1
        POP     BC
        RET
;*************************************************************************
;
; AUSGAGE EINES WORTES AUF DIE ANZEIGE
;
; FUNCTION: BRINGT DEN INHALT VON HL IN SIEBENSEGMENTKODE IN DEN ADRESS-
;           BEREICH DES ANZEIGEBEBEREICHES
; ZERSTOERT: AF,BC,DE,HL
;
ADRAUS: LD      B,4
ADRAU1: CALL    SHIHLA
        CALL    ADRANZ
        DJNZ    ADRAU1
        RET
;*************************************************************************
;
; AUSGABE EINES BYTES
;
; FUNKTION: BRINGT DEN INHALT VON H IN SIEBENSEGMENTKODE IN DEN DATEN-
;           BEREICH DES ANZEIGEBEREICHES
; ZERSTOERT: AF,BC,DE,HL
;
DAAUS:  LD      B,2
DAAUS1: CALL    SHIHLA
        CALL    DAANZ
        DJNZ    DAAUS1
        RET
;*************************************************************************
;
; AUSGABE EINES WORTES
;
; FUNKTION: BRINGT DEN INHALT VON HL IN SIEBENSEGMENTKODE IN DEN BEREICH
;           5 BIS 7 DES ANZEIGEBEREICHES
; ZERSTOERT: AF,BC,DE,HL
;
LDAAUS: LD      B,4
LDAAU1: CALL    SHIHLA
        CALL    LDAANZ
        DJNZ    LDAAU1
        RET
;*************************************************************************
;
; TRANSPORT EINES REGISTERPAARES AUS DEM STACK
;
; FUNKTION: LIEST REGISTERPAAR AUS DEM STACK UND TRANSPORTIERT ES NACH HR1
;           UND IN SIEBENSEGMENTKODE IN DEN ANZEIGEBEREICH 4 BIS 7
;           DER ZEIGER DES REGISTERPARRES STEHT IN HR2
; ZERSTOERT: AF,BC,DE,HL
;
RINANZ: CALL    GREPOI          ; REGISTERPOINTER BILDEN
        LD      D,(HL)
        DEC     HL
        LD      E,(HL)
        EX      DE,HL
        LD      (HR1),HL
        CALL    LDAAUS
        RET
;*************************************************************************
;
; TRANSPORT EINES REGISTERPAARES IN DEN STACK
;
; FUNKTION: TRANSPORTIERT EIN RGISTERPRAR AUS HR1 IN DEN STACK.
;           DER ZEIGER ('NAME') DES REGISTERPAARES BEFINDET SICH IN HR2.
; ZERSTOERT: F,DE,HL
;
RISTA:  CALL    GREPOI          ; REGISTERPOINTER BILDEN
        LD      DE,(HR1)
        LD      (HL),D
        DEC     HL
        LD      (HL),E
        RET
GREPOI: LD      E,(IY+H2)
        SLA     E
        LD      D,00H
        LD      HL,SYSP1
        SBWC
        RET
;*************************************************************************
;
; AUSGABE EINES REGISTERNAMENS
;
; FUNKTION: SCHREIBT DEN NAMFN EINES REGISTERPAARES IN GEEIGNETEM KODE
;           IN DEN ANZEIGEBEREICH 2,3
;           ZEIGER STEHT IN HR2
; ZERSTOERT: F,BC,DE,HL
;
RNANZ:  LD      HL,ANZRNA       ; REG.NAME AUSGEBEN
        LD      D,00H
        LD      E,(IY+H2)
        SLA     E
        ADD     HL,DE
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      (IY+2),B
        LD      (IY+3),C
        RET
;*************************************************************************
;
; TABELLE DER REGISTERNAMEN
;
; FUNKTION: EHHAELT IN AUFSTEIGENDER REIHENFOLGE DIE SIEBENSEGMENT- 
;           REPRAESENTATIONEN DER REGISTERNAMEN: AF, BC, DE, HL, AF'
;           BC', DE', HL', IX, IY, I.EI, SP, PC
;
ANZRNA: DW      0F571H
        DW      5763H
        DW      9773H
        DW      0D543H
        DW      0FD79H
        DW      5F6BH
        DW      9F7BH
        DW      0DD4BH
        DW      8473H
        DW      84D5H
        DW      84D6H
        DW      76F1H
        DW      0F163H
;*E
;*************************************************************************
;
;       AKTIONSPROGRAMME
;
;*************************************************************************
;
;
;
;
;*************************************************************************
;
; LEERE AKTION - FUEHRT NICHTS AUS
;
RETURN: RET
;*************************************************************************
;
; EINGABE EINES REGISTERPAARNAMENS DURCH DIE HAXEDEZIMALTASTATUR
;
Z2Z:    LD      (IY+PROZ),Z3
;*************************************************************************
;
; KORREKTUR DES REGISTERPAARNAMENS DURCH ERNEUTE EINGABE
;
Z3Z:    CP      13
        JR      C,Z3ZM1
        XOR     A
Z3ZM1:  LD      (IY+H2),A
        CALL    RNANZ
        RET
;*************************************************************************
;
; EINGABE NEUER DATEN FUER DAS NIEDERWERTIGE REGISTER
;
Z4Z:    PUSH    AF
        LD      HL,HR1
        RLD
        POP     AF
        CALL    DAANZ
        RET
;*************************************************************************
;
; EINGABE NEUER DATEN FUER DAS HOEHERWERTIGE REGISTER
;
Z4AZ:   PUSH    AF
        LD      HL,HR1
        INC     HL
        RLD
        POP     AF
        CALL    HDAANZ
        RET
;*************************************************************************
;
; EINGABE NEUER DATEN FUER EIN REGISTERPAAR (IX, IY, SP, PC)
;
Z4CZ:   CALL    DASCH
        CALL    LDAANZ
        RET
;*************************************************************************
;
; UEBERGANG ZUR DARSTELLUNG DES INHALTS VON AF, DA KEIN NAME EINGEGEBEN
; WURDE
;
Z2E:    LD      (IY+H2),00H
Z2EM1:  CALL    RNANZ
;*************************************************************************
;
; UEBERGANG ZUR DARSTELLUNG DES INHALTES DES SPEZIFIZIERTEN REGISTERPAARES
;
Z3E:    LD      A,(IY+H2)
        CP      9
        JP      NC,Z4AEM4
        JP      LSROM2
NX:     LD      HL,NAMES
        LD      DE,ANZBER
        CALL    TRANS
NX1:    CALL    TASTU
        JR      NX1
NAMES:  DW      05F7EH
        DB      00H
        DW      0DDCFH
        DB      00H
        DW      05BFDH
        DS      0400H-$         ; Ergänzung des Original-Codes für
                                ; ROM-Aufteilung
        ORG     1000H
LSROM2:                         ; BEGINN DES 2. ROMS
Z3EM1:  CALL    RINANZ
        RES     BIA,(IY+7)
        SET     BIA,(IY+5)
        LD      (IY+PROZ),Z4A
        RET
;*************************************************************************
;
; UEBERGANG ZUR MODIFIKATION DES NIEDERWERTIGEN REGISTERS, ABSPEICHERN DES
; EVENTUELL VERAENDERTEN INHALTS
;
Z4AE:   CALL    RISTA
        BIT     BIA,(IY+1)
        JR      NZ,Z4AEM1
Z4AEM3: LD      (IY+PROZ),Z4
        CALL    RINANZ
        RET
Z4AEM1: RES     BIA,(IY+1)
        LD      A,(IY+H2)
        SUB     1
        JR      C,Z4AEM2
        LD      (IY+H2),A
Z4AEM5: CALL    RNANZ
        JR      Z4AEM3
Z4AEM2: LD      (IY+H2),12
Z4AEM4: CALL    RNANZ
        CALL    RINANZ
        LD      (IY+PROZ),Z4C
        RET
;*************************************************************************
;
; UEBERGANG ZUR MODIFIKATION DES HOEHERWERTIGEN REGISTERS, ABSPEICHERN
; DES EVENTUELL MODIFIZIERTEN REGISTERINHALTES
;
Z4E:    CALL    RISTA
        BIT     BIA,(IY+1)
        JR      NZ,Z4EM1
        INC     (IY+H2)
        JP      Z2EM1
Z4EM1:  RES     BIA,(IY+1)
        JR      Z3EM1
;*************************************************************************
;
; UEBERGANG ZUR MODIFIKATION DES NAECHSTEN REGISTERPAARES, ABSPEICHERN
; DES MOMENTANEN INHALTES
;
Z4CE:   CALL    RISTA
        BIT     BIA,(IY+1)
        JR      NZ,Z4CEM1
        LD      A,(IY+H2)
        INC     A
        CP      13
        JP      NC,Z2E
        LD      (IY+H2),A
        JR      Z4AEM4
Z4CEM1: RES     BIA,(IY+1)
        LD      A,(IY+H2)
        DEC     A
        CP      9
        LD      (IY+H2),A
        JR      NC,Z4AEM4
        JR      Z4AEM5
;*E
;*************************************************************************
;
; UEBERNAHME DER ADRESSE RAMANFANG IN DAS ADRESSREGISTER, DA KEINE ADRESSE
; EINGEGEBEN WURDE.
; DARSTELLUNG DES INHALTES DER SPEICHERADRESSE
;
Z5E:    LD      HL,RAMANF
Z5EM1:  LD      (HR2),HL
        PUSH    HL
        CALL    ADRAUS
        POP     HL
        RES     BIA,(IY+5)
        LD      H,(HL)
        LD      (IY+H1),H
        CALL    DAAUS
        LD      (IY+PROZ),Z7
        RET
;*************************************************************************
;
; EINGABE DER ERSTEN ZIFFER EINER SPEICHERADRESSE
;
Z5Z:    INC     (IY+PROZ)
Z5ZM1:  LD      HL,00H
        LD      (HR1),HL
;*************************************************************************
;
; EINGABE EINER ZIFFER EINER SPEICHERADRESSE
;
Z6Z:    CALL    DASCH
        CALL    ADRANZ
        RET
;*************************************************************************
;
; UEBERNAHME DER EINGEGEBENEN SPEICHERADRESSE UND DARSTELLUNG DES INHALTES
; DER ADRESSE
;
Z6E:    LD      HL,(HR1)
        JR      Z5EM1
;*************************************************************************
;
; UEBERGANG ZUR DARSTELLUNG DER NAECHSTEN ADRESSE, ABSPEICHERN DER
; VORHER EVENTUELL MODIFIZIERTEN DATEN
;
Z7E:    LD      HL,(HR2)        ; ADRESSE
        LD      E,(IY+H1)       ; DATEN
        LD      (HL),E
        BIT     BIA,(IY+1)      ; INKREMENTIEREN ODER DEKREMENTIEREN?
        JR      NZ,Z7EM1
        INC     HL
        JR      Z7EM2
Z7EM1:  DEC     HL
        RES     BIA,(IY+1)
Z7EM2:  JR      Z5EM1
;*E
;*************************************************************************
;
; UEBERGANG ZUR (ANZEIGE UND) EINGABE EINES PRUEFPUNKTES
;
Z8E:    LD      DE,ANZBRE
        CALL    KOMDAR
        LD      HL,(BREAKP)
        LD      (HR1),HL
        LD      A,L
        OR      H
        JR      Z,Z8EM1         ; KEINE DARSTELLUNG BEI 0000
        CALL    ADRAUS
Z8EM1:  LD      (IY+PROZ),Z10
        RET
;*************************************************************************
;
; UEBERGANG ZUR PRUEFPUNKTEINGABE NACH ERFOLGTER ADRESSEINGABE
;
Z9E:    LD      HL,(HR1)
        LD      (SYSP26),HL
        JR      Z8E
;*************************************************************************
;
; UEBERNAHME DES PRUEFPUNKTES UND ANSPRUNG DES ANWENDERPROGRAMMES
;
Z10E:   LD      HL,(HR1)
        LD      (BREAKP),HL
        LD      A,(HL)
        LD      (HR4),A         ; KODE RETTEN
        LD      (HL),0EFH
        LD      (IY+PROZ),Z1
        LD      (IY+NMIZ),10H
        POP     HL              ; STACKPOINTER KORRIGIEREN
;*E
;*************************************************************************
;
; WIEDERHERSTELLUNG DER REGISTERINHALTE DES PROZESSORS UND DIREKTER
; AUFRUF DES ANWENDERPROGRAMMS
;
Z10EM1: IN      A,(PIOD2)
        RES     BIE,A
        OUT     (PIOD2),A       ; NMI-FF LOESCH.
        POP     DE              ; PC
        POP     HL              ; SP
        LD      (HR2),DE
        LD      (HR3),HL
        POP     IY
        POP     IX
        POP     AF              ; I EI
        LD      I,A
        LD      H,0C3H          ; KODE FUER 'JP'
        JP      C,Z10EM2        ; INTERRUPTS GESTATTET
        LD      L,0F3H          ; KODE FUER 'DI'
        JR      Z10EM3
Z10EM2: LD      L,0FBH          ; KODE FUER 'EI'
        JR      Z10EM3
Z10EM3: LD      (HR1),HL
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EX      AF,AF'
        EXX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        LD      SP,(HR3)
        JP      HR1
;*E
;*************************************************************************
;
; AUSFUEHRUNG EINES SCHRITTES NACH EINGABE EINER ADRESSE
;
Z13E:   LD      HL,(HR1)
        LD      (SYSP26),HL     ; PC
;*************************************************************************
;
; AUSFUEHRUNG EINES SCHRTTES OHNE AENDERUNG DES BEFEHLSZAEHLERS
;
Z12E:   LD      (IY+PROZ),Z14
;*************************************************************************
;
; FORTSETZUNG DES SCHRITTBETRIEBES
;
Z14E:   LD      (IY+NMIZ),03H
        LD      HL,(SYSP26)     ; PC
        LD      A,(HL)
        AND     0C7H
        CP      0C7H
        RET     Z
        POP     HL
;*************************************************************************
;
; START DES ZAEHLERS ZUR AUSFUEHRUNG EINES BEFEHLES
;
Z10EM4: LD      A,05H
        OUT     (CTC),A
        LD      A,ZK2
        OUT     (CTC),A
        BIT     0,A
        JR      Z10EM1
ZK2:    EQU     21
;*E
;*************************************************************************
;
; DEFINITION EINER FUNKTION BEIM KOMMANDO 'FUNKT' DURCH DIE HEXRDEZIMAL-
; TASTATUR
;
Z16Z:   CP      6
        JR      NC,Z16ZM1
        ADD     A,8
        RLCA
        POP     HL
        JP      TASTB1
Z16ZM1: SUB     6
        CP      6       ; ENTSCHEIDUNG IN WELCHEM ROMBEREICH
        JR      NC,Z16ZM2
        LD      H,20H
        JR      Z16ZM3
Z16ZM2: SUB     6
        LD      H,30H
Z16ZM3: LD      C,A
        SLA     A
        ADD     A,C
        LD      L,A
;*************************************************************************
;
; ANSPRUNG EINES VORGEWAEHLTEN KOMMANDOS (FU 6 BIS FU F)
;
        LD      A,(HL)
        CP      0C3H
        RET     NZ
        LD      (IY+PROZ),Z1
        JP      (HL)
;*E
;*************************************************************************
;
; UEBERGANG ZUR EINGABE DER ENDADRESSE FUR DIE MAGNETBANDEINGABE NACH ER-
; FOLGTER EINGABE DER ANFANGSADRESSE
;
Z18E:   LD      DE,ANZMSE
Z18EM1: LD      HL,(HR1)
        LD      (HR2),HL        ; ANFANGSADRESSE
Z18EM2: INC     (IY+PROZ)
        CALL    KOMDAR
        RET
;*************************************************************************
;
; UEBERNAHME DER EINGEGEBENEN ENDRESSE UND AUSGABE DER FRAGE 'READY ?'
; AN DEN BEDIENER
;
Z20E:   INC     (IY+PROZ)
        CALL    MBREADY
        RET
;*************************************************************************
;
; AUSFUEHRUNG DES KOMMANDOS 'MAGNETBANDEINGABE' NACH ERFOLGTER EINGABE DER
; ENDADRESSE
;
Z21AE:  PUSH    IY
        CALL    DL              ; MBEINGABE
        LD      (HR2),IY        ; FEHLERSCHREIBZEIGER
        POP     IY
        LD      HL,FSTACK
        LD      (HR4),HL
        LD      (IY+PROZ),Z21
        LD      DE,ANZLFE
        CALL    KOMDAR
;*************************************************************************
;
; AUSGABE DES NAECHSTEN LESEFEHLERS BZW. DER FERTIGMELDUNG
;
Z21E:   LD      HL,(HR4)
        LD      DE,(HR2)
        PUSH    HL
        SBWC
        POP     HL
        JP      Z,Z39EM2        ; ENDE
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      (HR4),HL
        EX      DE,HL
        CALL    ADRAUS
        RET
;*************************************************************************
;
; AUSFUEHRUNG DES KOMMANDOS 'MAGNETBANDAUSGABE' HACH ERFOLGTER
; EINGABE VON ANFANGS- UND ENDADRESSE
;
Z25AE:  PUSH    IY
        CALL    DS              ; AUSFUEHRUNG MBOUT
        POP     IY
        JP      Z39EM2
;*E
;*************************************************************************
;
; UNTERPROGRAMM FUER DIE MAGNETBANDEINGASBE
;
; FUNKTION: DAS PROGRAMM VERSUCHT, VOM MAGNETBANDGERAET DATEN ZU LESEN
;           UND IM RAM ABZUSPEICHERN. DIE ANFANGSADRESSE BEFINDET SICH IN
;           HR2 UND DIE ENDADRESSE IN HR1. AUF DER ADRESSE FSTACK BEGIN-
;           NEND WIRD EINE FEHLERLISTE ERZEUGT. IN IY BEFINDET SICH DAS
;           ENDE DER LISTE.
;           DAS PROGRAMM KEHRT NICHT ZURUECK, WENN VOM MAGNETBAND NICHT
;           GENUEGEND DATEN EMPFANGEN WERDEN.
; ZERSTOERT: AF,BC,DE,HL,IX,IY
;
NTA:    EQU     768             ; ANZAHL DER RECHNERTAKTE PRO DATENBIT
DL:     LD      IY,FSTACK
        LD      HL,(HR2)
DLM0:   CALL    BL
        JR      Z,DLM1          ; KEIN FEHLER
        LD      DE,32
        SBWC
        LD      (IY+0),L
        INC     IY
        LD      (IY+0),H
        INC     IY
        ADD     HL,DE
        PUSH    HL
        PUSH    IY
        POP     HL
        LD      DE,RAMEND
        SBWC
        POP     HL
        RET     NC
DLM1:   EX      DE,HL
        LD      HL,(HR1)        ; ENDADRESSE
        SBWC
        EX      DE,HL
        RET     M
        JR      DLM0
;*************************************************************************
;
; UNTERPROGRAMM ZUM FINDEN EINER FLANKE IM LESESIGNAL
; EXIT: 36 TAKTE
;
FIFLA:  IN      A,(PIOD2)
        XOR     B
        BIT     BID,A
        JR      Z,FIFLA
        RET
;*************************************************************************
;
; UNTERPROGRAMM ZUR EINABE EINES BITS
; ENTRY: 28 TAKTE, EXIT: 51 TAKTE
;
BITIN:  IN      A,(PIOD2)
        XOR     B
        BIT     BID,A
        PUSH    AF
        XOR     B
        LD      B,A
        POP     AF
        RET                     ; I=28/A=53
;*************************************************************************
;
; UNTERPROGRAMM ZUR EINGABE EINES DATENBLOCKS VON 32 BYTE UND 2 BYTE
; PRUEFSUMME
;
BL:     CALL    BITIN
        CALL    FIFLA
        LD      C,7
BLM1:   LD      DE,(BLN11 << 8) | BLN9
        SWAIT   BLN1
        CALL    BITIN
BLMX:   CALL    BITIN
        JR      NZ,BL           ; VERAENDERUNG ERKANNT
        DEC     D
        JR      NZ,BLMX
        DEC     C
        JR      Z,BLM4          ; SYNC.FELD ERKANNT
BLM2:   IN      A,(PIOD2)
        XOR     B
        BIT     BID,A
        JR      NZ,BLM1         ; FLANKE ERKANNT
        DEC     E
        JR      NZ,BLM2         ; WARTEN
        JR      BL              ; TIME OUT
; 7 NULLEN SIND ERKANNT WORDEN
BLM4:   CALL    FIFLA
        SWAIT   BLN3
        CALL    BITIN
        JR      NZ,BLM4         ; AUF 1 WARTEN
        CALL    FIFLA
        SWAIT   BLN4
        CALL    WL
        LD      C,16
        PUSH    DE
        POP     IX              ; CRC ANFANGSWERT
        SWAIT   BLN10
BLM5:   CALL    WL
        ADD     IX,DE
        PUSH    BC
        LD      C,L
        LD      B,H
        LD      HL,(HR1)        ; ENDADRESSE
        XOR     A
        SBC     HL,BC
        LD      L,C
        LD      H,B
        POP     BC
        JR      C,BLM6
        LD      (HL),E
        INC     HL
        LD      (HL),D
        JR      BLM7
BLM6:   SWAIT   BLN5
        INC     HL
BLM7:   INC     HL
        DEC     C
        JR      Z,BLM8
        SWAIT   BLN6
        JR      BLM5
BLM8:   SWAIT   BLN7
        CALL    WL              ; PRUEFSUMME LESEN
        EX      DE,HL
        PUSH    IX
        POP     BC
        XOR     A
        SBC     HL,BC
        EX      DE,HL
        RET
;*************************************************************************
;
; ZEITKONSTANTEN FUER BL
;
BLN1:   EQU     (NTA/4-67)/16
BLN3:   EQU     ((3*NTA)/2-58)/16
BLN4:   EQU     ((3*NTA)/4-92)/16
BLN5:   EQU     1
BLN6:   EQU     ((3*NTA)/4-284)/16
BLN7:   EQU     ((3*NTA)/4-277)/16
BLN9:   EQU     (NTA)/46
BLN10:  EQU     ((3*NTA)/4-160)/16
BLN11:  EQU     ((5*NTA)/4)/104
;*************************************************************************
;
; UNTERPROGRAMM ZUM EINLESEN EINES WORTES (2 BYTE)
; ENTRY: 63 TAKTE, EXIT: 72 TAKTE
;
WL:     PUSH    HL              ; I=64 A=83
        LD      L,16
WLM0:   CALL    BITIN
        JR      NZ,WLM1
        XOR     A
        JR      WLM2
WLM1:   SCF
WLM2:   RR      D
        RR      E
        CALL    FIFLA
        DEC     L
        JR      Z,WLM3
        SWAIT   WLN1
        JR      WLM0
WLM3:   POP     HL
        RET
;*************************************************************************
;
; ZEITKONSTANTEN FUER WL
;
WLN1:   EQU     ((3*NTA)/4-81)/16
;*E
;*************************************************************************
;
; UNTERPROGRAMM ZUR AUSGABE EINES DATENBEREICHES AUF DAS MAGNETBAND
; DIE ANFANGSADRESSE BEFINDET SICH IN HR2, DIE ENDADRESSE IN HR1.
;
; ZERSTOERT: AF,BC,DE,HL,IX
;
DS:     LD      HL,(HR2)        ; ANFANGSADRESSE
        CALL    BSA             ; ANFANGSBLOCK
DS1:    EX      DE,HL
        LD      HL,(HR1)        ; ENDE
        SBWC
        EX      DE,HL
        RET     M
        CALL    BS
        JR      DS1
FLOUT:  IN      A,(PIOD2)
        XOR     MASK            ; E=46,O=10
        OUT     (PIOD2),A
        RET
;*************************************************************************
;
; UNTERPROGRAMM ZUR AUSGABE EINES BLOCKES
; ENTRY: 108 TAKTE, EXIT:25 TAKTE
;
BSA:    LD      DE,2000
        JR      BSX
BS:     LD      DE,14
BSX:    WAIT    (2*NTA-77)/13
        CALL    FLOUT
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,BSX
        LD      C,2
BSM0:   WAIT    BSN5
        CALL    FLOUT
        DEC     C
        LD      DE,0000H
        JR      NZ,BSM0
        PUSH    DE
        POP     IX
        WAIT    BSN0
        CALL    WS
        WAIT    BSN1
        LD      C,16
BSM1:   LD      E,(HL)
        INC     HL
        LD      D,(HL)
        ADD     IX,DE
        INC     HL
        PUSH    BC
        CALL    WS
        POP     BC
        DEC     C
        JR      Z,BSM2
        WAIT    BSN2
        JR      BSM1
BSN0:   EQU (NTA/2-148)/13
BSN1:   EQU (NTA/2-178)/13
BSN2:   EQU (NTA/2-202)/13
BSN3:   EQU (NTA/2-170)/13
BSN5:   EQU (NTA-79)/13
BSM2:   PUSH    IX
        POP     DE
        WAIT    BSN3
        CALL    WS
        RET
;*************************************************************************
;
; AUSGABE EINES WORTES
; ENTRY: 97 TAKTE, EXIT: 25 TAKTE
;
WS:     LD      C,16
WSM0:   SRL     D
        RR      E
        JR      NC,WSM1
        WAIT    WSN1
        NOP
        JR      WSM3
WSM1:   CALL    FLOUT
WSM3:   WAIT    WSN2
WSM2:   CALL    FLOUT
        DEC     C
        RET     Z
        WAIT    WSN3
        JR      WSM0
;*************************************************************************
;
; ZEITKONSTANTEN FUER WS
;
WSN1:   EQU     3
WSN2:   EQU     (NTA/2-50)/13
WSN3:   EQU     (NTA/2-99)/13
MASK:   EQU     04H
;*E
;*************************************************************************
;
; UEBERGANG ZUR EINGABE DER QUELLADRESSE NACH ERFOLGTER EINGABE DER
; ZIELADRESSE BEIM MOVE-KOMMANDO
;
Z35E:   LD      DE,ANZMSO
        JP      Z18EM1
;*************************************************************************
;
; UEBERGANG ZUR EINGABE DER LAENGE NACH ERFOLGTER EINGABE DER QUELLADRESSE
; BEIM MOVE-KOMMANDO
;
Z37E:   LD      DE,ANZMLE
Z37EM1: LD      HL,(HR1)
        LD      (HR4),HL        ; SOURCE
        JP      Z18EM2
;*************************************************************************
;
; UEBERGANG ZUR AUSFUEHRUNG DES MOVE-KOMMANDOS
;
Z39E:   LD      DE,(HR2)        ; ZIEL
        LD      HL,(HR4)
        LD      BC,(HR1)        ; LAENGE
        PUSH    HL
        SBWC
        POP     HL
        JR      C,Z39EM1
        LDIR
        JR      Z39EM2
Z39EM1: ADD     HL,BC
        DEC     HL
        EX      DE,HL
        ADD     HL,BC
        DEC     HL
        EX      DE,HL
        LDDR
Z39EM2: LD      DE,ANZFIN
        CALL    KOMDAR
        LD      (IY+PROZ),Z1
        RET
;*E
;*************************************************************************
;
; UEBERGANG ZUR EINGABE DER LAENGE DES ZU FUELLENDEN SPEICHERBEREICHS
;
Z41E:   LD      DE,ANZFIL
        JP      Z18EM1
;*************************************************************************
;
; UEBERGANG ZUR EINGABE DER EINZUSCHREIBENDEN DATEN
;
Z43E:   LD      DE,ANZFID
        JR      Z37EM1          ; LAENGE IN HR4
;*************************************************************************
;
; EINGABE DER ERSTEN ZIFFER DER BEIM KOMMANDO 'FILL' EINZUSCHREIBENDEN
; DATEN
;
Z44Z:   INC     (IY+PROZ)
        LD      HL,00H
        LD      (HR1),HL
        JP      Z4Z
;*************************************************************************
;
; AUSFUEHRUNG DER FUELLOPERATION
;
Z45E:   LD      BC,(HR4)        ; LAENGE
        LD      HL,(HR2)
        LD      DE,(HR2)        ; ZIEL
        LD      HL,HR1          ; DATENZEIGER
Z45EM1: LDI
        DEC     HL
        JP      PE,Z45EM1
        JR      Z39EM2
;*E
;*************************************************************************
;
; EINGABE EINER ZIFFER FUER EINE PORTADRESSE
;
Z47Z:   CALL    DASCH           ; PORT IN
        CALL    ADRANZ
        LD      (IY+3),00H
        RET
;*************************************************************************
;
; UEBERGANG ZUM PORTLESEN
;
Z47E:   INC     (IY+PROZ)
;*************************************************************************
;
; PORTLESEN AUSFUEHREN
;
Z48E:   LD      C,(IY+H1)
        IN      H,(C)
        CALL    DAAUS
        RES     BIA,(IY+7)
        RET
;*************************************************************************
;
; UEBERGANG ZUR EINGABE VON ZU EINEM PORT AUSZUGEBENDEN DATEN
;
Z50E:   INC     (IY+PROZ)
        LD      A,(IY+H1)
        LD      (IY+H2),A
        RES     BIA,(IY+5)
Z50EM1: SET     BIA,(IY+7)
        RET
;*************************************************************************
;
; AUSFUEHRUNG DER AUSGABE VON DATEN ZU EINEM PORT
;
Z52E:   LD      C,(IY+H2)
        LD      A,(IY+H1)
        OUT     (C),A
        DEC     (IY+PROZ)
        LD      HL,00H
        LD      (HR1),HL
        LD      (ANZB6),HL
        JR      Z50EM1
;*E
;*************************************************************************
;
; KODES FUER DIE ANZEIGE VON ZUSTAENDEN IN SIEBENSEGMENTDARSTELLUNG
;
;*************************************************************************
;ANUSBR         EQU     0C757H
ANZBRE: EQU     5741H
FSTAEND:EQU     1000H
ANZLFE: EQU     7311H
ANZFIN: EQU     7100H
ANZMSE: EQU     73F5H
ANZFSA: EQU     73F5H
ANZMSO: EQU     7617H
ANZMLE: EQU     4373H
ANZFIL: EQU     4373H
ANZFID: EQU     97F5H
;*INCLUDE LERNSYSTEMEQU.S
