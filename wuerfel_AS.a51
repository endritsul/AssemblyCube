;********************************************************************************
; P R O G R A M M	wuerfel 
;********************************************************************************
; Source-File:		wuerfel_AS.a51
; Autor:			Yves Bolis
; Datum:			07.05.2019
; Version:			1.0
; Beschreibung:		Programm soll Würfelzahlen zwischen 1 und 6 erzeugen und als 
;                   Würfelaugen an Port 2 anzeigen
; Eingaben:			1 Schalter P3.0 = 0 STOP / P3.0 = 1 WUERFELN
; Ausgaben:			6 LEDs (P2, P2.0 - 2.5)
;********************************************************************************

	$TITLE (wuerfel_LS)
	$NOLIST
	$NOMOD51
	$INCLUDE (C8051F020.h)	;hier werden alle Bezeichnungen definiert
	$LIST

;------ State INIT
INIT:

	ORG		0000h			;Startadresse
	
	MOV		WDTCN,#0DEh
	MOV		WDTCN,#0ADh		;disable Watchdog
	
	MOV		P2MDOUT,#0FFh	;P2 8 Ausgänge push/pull
	MOV		XBR2,#040h		;enable crossbar (Koppelfeld)

	JMP 	RESET

RESET:
	MOV		A, #00h			; Akku auf null
	MOV		P2, #00h		; P2 löschen
	JMP 	WUERFELN

WUERFELN:
	WUERFELN_LOOP:
	RL		A		; Wuerfelzahl eine Bitstelle nach links
	INC		A		; Wuerfelzahl vorderste Bitstelle auffuellen

	;alternativ zu RL geht auch
	;SETB	C
	;RLC 	A

	JNB		P3.0, STOP

	JB 		ACC.5, RESET

	JMP WUERFELN_LOOP

STOP:

	MOV		P2, A	; Wuerfelzahl anzeigen (P2 <- A)

	STOP_LOOP:

		JNB		P3.0, STOP
		JMP		STOP_LOOP

END