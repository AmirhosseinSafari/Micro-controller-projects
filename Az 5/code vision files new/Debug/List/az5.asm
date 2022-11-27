
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _A=R4
	.DEF _A_msb=R5
	.DEF _B=R6
	.DEF _B_msb=R7
	.DEF _C=R8
	.DEF _C_msb=R9
	.DEF _operater=R10
	.DEF _operater_msb=R11
	.DEF _result=R12
	.DEF _result_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x2D,0x0,0x2B,0x0,0x3D,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _0x31
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x31+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x31+4
	.DW  _0x0*2+4

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/10/2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;int A;
;int B;
;int C;
;char nums[];
;int operater;
;char results[];
;int result;
;int counter = 0;
;
;void num_printer(int var){
; 0000 0029 void num_printer(int var){

	.CSEG
_num_printer:
; .FSTART _num_printer
; 0000 002A     itoa(var, nums);
	ST   -Y,R27
	ST   -Y,R26
;	var -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_nums)
	LDI  R27,HIGH(_nums)
	CALL _itoa
; 0000 002B     lcd_puts(nums);
	LDI  R26,LOW(_nums)
	LDI  R27,HIGH(_nums)
	CALL SUBOPT_0x0
; 0000 002C     delay_ms(1000);
; 0000 002D     counter += 2;
; 0000 002E     lcd_gotoxy(counter,0);
; 0000 002F }
	JMP  _0x20A0002
; .FEND
;
;void main(void)
; 0000 0032 {
_main:
; .FSTART _main
; 0000 0033 // Declare your local variables here
; 0000 0034 
; 0000 0035 // Input/Output Ports initialization
; 0000 0036 // Port A initialization
; 0000 0037 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0038 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0039 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003A PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 003B 
; 0000 003C // Port B initialization
; 0000 003D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003E DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 003F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0040 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0041 
; 0000 0042 // Port C initialization
; 0000 0043 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0044 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0045 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0046 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0047 
; 0000 0048 // Port D initialization
; 0000 0049 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004A DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 004B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004C PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 004D 
; 0000 004E // Timer/Counter 0 initialization
; 0000 004F // Clock source: System Clock
; 0000 0050 // Clock value: Timer 0 Stopped
; 0000 0051 // Mode: Normal top=0xFF
; 0000 0052 // OC0 output: Disconnected
; 0000 0053 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0054 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0055 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0056 
; 0000 0057 // Timer/Counter 1 initialization
; 0000 0058 // Clock source: System Clock
; 0000 0059 // Clock value: Timer1 Stopped
; 0000 005A // Mode: Normal top=0xFFFF
; 0000 005B // OC1A output: Disconnected
; 0000 005C // OC1B output: Disconnected
; 0000 005D // Noise Canceler: Off
; 0000 005E // Input Capture on Falling Edge
; 0000 005F // Timer1 Overflow Interrupt: Off
; 0000 0060 // Input Capture Interrupt: Off
; 0000 0061 // Compare A Match Interrupt: Off
; 0000 0062 // Compare B Match Interrupt: Off
; 0000 0063 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0064 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0065 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0066 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0067 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0068 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0069 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 006A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 006B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 006C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 006D 
; 0000 006E // Timer/Counter 2 initialization
; 0000 006F // Clock source: System Clock
; 0000 0070 // Clock value: Timer2 Stopped
; 0000 0071 // Mode: Normal top=0xFF
; 0000 0072 // OC2 output: Disconnected
; 0000 0073 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0074 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0075 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0076 OCR2=0x00;
	OUT  0x23,R30
; 0000 0077 
; 0000 0078 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0079 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 007A 
; 0000 007B // External Interrupt(s) initialization
; 0000 007C // INT0: Off
; 0000 007D // INT1: Off
; 0000 007E // INT2: Off
; 0000 007F MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0080 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0081 
; 0000 0082 // USART initialization
; 0000 0083 // USART disabled
; 0000 0084 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0085 
; 0000 0086 // Analog Comparator initialization
; 0000 0087 // Analog Comparator: Off
; 0000 0088 // The Analog Comparator's positive input is
; 0000 0089 // connected to the AIN0 pin
; 0000 008A // The Analog Comparator's negative input is
; 0000 008B // connected to the AIN1 pin
; 0000 008C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 008D SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 008E 
; 0000 008F // ADC initialization
; 0000 0090 // ADC disabled
; 0000 0091 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0092 
; 0000 0093 // SPI initialization
; 0000 0094 // SPI disabled
; 0000 0095 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0096 
; 0000 0097 // TWI initialization
; 0000 0098 // TWI disabled
; 0000 0099 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 009A 
; 0000 009B // Alphanumeric LCD initialization
; 0000 009C // Connections are specified in the
; 0000 009D // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 009E // RS - PORTC Bit 0
; 0000 009F // RD - PORTC Bit 1
; 0000 00A0 // EN - PORTC Bit 2
; 0000 00A1 // D4 - PORTC Bit 4
; 0000 00A2 // D5 - PORTC Bit 5
; 0000 00A3 // D6 - PORTC Bit 6
; 0000 00A4 // D7 - PORTC Bit 7
; 0000 00A5 // Characters/line: 8
; 0000 00A6 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00A7 lcd_clear();
	CALL _lcd_clear
; 0000 00A8 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 00A9 
; 0000 00AA DDRB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00AB DDRA = 0b00001111;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 00AC 
; 0000 00AD A = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 00AE B = -1;
	MOVW R6,R30
; 0000 00AF C = -1;
	MOVW R8,R30
; 0000 00B0 result = 0;
	CLR  R12
	CLR  R13
; 0000 00B1 operater = 1; // operater = 1 ==> + | operater = 0 ==> -
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 00B2 
; 0000 00B3 while (1)
_0x3:
; 0000 00B4       {
; 0000 00B5       // Place your code here
; 0000 00B6       //Line 1
; 0000 00B7       PORTA = 0b00000001;
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 00B8       if(PINB.1 == 1){
	SBIS 0x16,1
	RJMP _0x6
; 0000 00B9         if(A == -1) {A = 9; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x7
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x5B
; 0000 00BA         else if(B == -1){ B = 9; num_printer(B); }
_0x7:
	CALL SUBOPT_0x3
	BRNE _0x9
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x5B
; 0000 00BB         else if(C == -1){ C = 9; num_printer(C); }
_0x9:
	CALL SUBOPT_0x4
	BRNE _0xB
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x5B
; 0000 00BC         else{ num_printer(9); }
_0xB:
	LDI  R26,LOW(9)
	LDI  R27,0
_0x5B:
	RCALL _num_printer
; 0000 00BD       }
; 0000 00BE       delay_ms(10);
_0x6:
	CALL SUBOPT_0x5
; 0000 00BF 
; 0000 00C0       if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0xD
; 0000 00C1         if(A == -1) {A = 8; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0xE
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x5C
; 0000 00C2         else if(B == -1){ B = 8; num_printer(B); }
_0xE:
	CALL SUBOPT_0x3
	BRNE _0x10
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x5C
; 0000 00C3         else if(C == -1){ C = 8; num_printer(C); }
_0x10:
	CALL SUBOPT_0x4
	BRNE _0x12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x5C
; 0000 00C4         else{ num_printer(8); }
_0x12:
	LDI  R26,LOW(8)
	LDI  R27,0
_0x5C:
	RCALL _num_printer
; 0000 00C5       }
; 0000 00C6       delay_ms(10);
_0xD:
	CALL SUBOPT_0x5
; 0000 00C7 
; 0000 00C8       if(PINB.3 == 1){
	SBIS 0x16,3
	RJMP _0x14
; 0000 00C9         if(A == -1) {A = 7; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x15
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x5D
; 0000 00CA         else if(B == -1){ B = 7; num_printer(B); }
_0x15:
	CALL SUBOPT_0x3
	BRNE _0x17
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x5D
; 0000 00CB         else if(C == -1){ C = 7; num_printer(C); }
_0x17:
	CALL SUBOPT_0x4
	BRNE _0x19
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x5D
; 0000 00CC         else{ num_printer(7); }
_0x19:
	LDI  R26,LOW(7)
	LDI  R27,0
_0x5D:
	RCALL _num_printer
; 0000 00CD       }
; 0000 00CE       delay_ms(10);
_0x14:
	CALL SUBOPT_0x5
; 0000 00CF 
; 0000 00D0       //Line 2
; 0000 00D1       PORTA = 0b00000010;
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 00D2       if(PINB.1 == 1){
	SBIS 0x16,1
	RJMP _0x1B
; 0000 00D3         if(A == -1) {A = 6; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x1C
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x5E
; 0000 00D4         else if(B == -1){ B = 6; num_printer(B); }
_0x1C:
	CALL SUBOPT_0x3
	BRNE _0x1E
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x5E
; 0000 00D5         else if(C == -1){ C = 6; num_printer(C); }
_0x1E:
	CALL SUBOPT_0x4
	BRNE _0x20
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x5E
; 0000 00D6         else{ num_printer(6); }
_0x20:
	LDI  R26,LOW(6)
	LDI  R27,0
_0x5E:
	RCALL _num_printer
; 0000 00D7       }
; 0000 00D8       delay_ms(10);
_0x1B:
	CALL SUBOPT_0x5
; 0000 00D9 
; 0000 00DA       if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0x22
; 0000 00DB         if(A == -1) {A = 5; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x23
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x5F
; 0000 00DC         else if(B == -1){ B = 5; num_printer(B); }
_0x23:
	CALL SUBOPT_0x3
	BRNE _0x25
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x5F
; 0000 00DD         else if(C == -1){ C = 5; num_printer(C); }
_0x25:
	CALL SUBOPT_0x4
	BRNE _0x27
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x5F
; 0000 00DE         else{ num_printer(5); }
_0x27:
	LDI  R26,LOW(5)
	LDI  R27,0
_0x5F:
	RCALL _num_printer
; 0000 00DF       }
; 0000 00E0       delay_ms(10);
_0x22:
	CALL SUBOPT_0x5
; 0000 00E1 
; 0000 00E2       if(PINB.3 == 1){
	SBIS 0x16,3
	RJMP _0x29
; 0000 00E3         if(A == -1) {A = 4; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x2A
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x60
; 0000 00E4         else if(B == -1){ B = 4; num_printer(B); }
_0x2A:
	CALL SUBOPT_0x3
	BRNE _0x2C
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x60
; 0000 00E5         else if(C == -1){ C = 4; num_printer(C); }
_0x2C:
	CALL SUBOPT_0x4
	BRNE _0x2E
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x60
; 0000 00E6         else{ num_printer(4); }
_0x2E:
	LDI  R26,LOW(4)
	LDI  R27,0
_0x60:
	RCALL _num_printer
; 0000 00E7       }
; 0000 00E8       delay_ms(10);
_0x29:
	CALL SUBOPT_0x5
; 0000 00E9 
; 0000 00EA       //Line 3
; 0000 00EB       PORTA = 0b00000100;
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 00EC       if(PINB.0 == 1){ operater = 0; lcd_puts("-"); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); }
	SBIS 0x16,0
	RJMP _0x30
	CLR  R10
	CLR  R11
	__POINTW2MN _0x31,0
	CALL SUBOPT_0x0
; 0000 00ED       delay_ms(10);
_0x30:
	CALL SUBOPT_0x5
; 0000 00EE 
; 0000 00EF       if(PINB.1 == 1){
	SBIS 0x16,1
	RJMP _0x32
; 0000 00F0         if(A == -1) {A = 3; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x33
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x61
; 0000 00F1         else if(B == -1){ B = 3; num_printer(B); }
_0x33:
	CALL SUBOPT_0x3
	BRNE _0x35
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x61
; 0000 00F2         else if(C == -1){ C = 3; num_printer(C); }
_0x35:
	CALL SUBOPT_0x4
	BRNE _0x37
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x61
; 0000 00F3         else{ num_printer(3); }
_0x37:
	LDI  R26,LOW(3)
	LDI  R27,0
_0x61:
	RCALL _num_printer
; 0000 00F4       }
; 0000 00F5       delay_ms(10);
_0x32:
	CALL SUBOPT_0x5
; 0000 00F6 
; 0000 00F7       if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0x39
; 0000 00F8         if(A == -1) {A = 2; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x3A
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x62
; 0000 00F9         else if(B == -1){ B = 2; num_printer(B); }
_0x3A:
	CALL SUBOPT_0x3
	BRNE _0x3C
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x62
; 0000 00FA         else if(C == -1){ C = 2; num_printer(C); }
_0x3C:
	CALL SUBOPT_0x4
	BRNE _0x3E
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x62
; 0000 00FB         else{ num_printer(2); }
_0x3E:
	LDI  R26,LOW(2)
	LDI  R27,0
_0x62:
	RCALL _num_printer
; 0000 00FC       }
; 0000 00FD       delay_ms(10);
_0x39:
	CALL SUBOPT_0x5
; 0000 00FE 
; 0000 00FF       if(PINB.3 == 1){
	SBIS 0x16,3
	RJMP _0x40
; 0000 0100         if(A == -1) {A = 1; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x41
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	MOVW R26,R4
	RJMP _0x63
; 0000 0101         else if(B == -1){ B = 1; num_printer(B); }
_0x41:
	CALL SUBOPT_0x3
	BRNE _0x43
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
	MOVW R26,R6
	RJMP _0x63
; 0000 0102         else if(C == -1){ C = 1; num_printer(C); }
_0x43:
	CALL SUBOPT_0x4
	BRNE _0x45
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
	MOVW R26,R8
	RJMP _0x63
; 0000 0103         else{ num_printer(1); }
_0x45:
	LDI  R26,LOW(1)
	LDI  R27,0
_0x63:
	RCALL _num_printer
; 0000 0104       }
; 0000 0105       delay_ms(10);
_0x40:
	CALL SUBOPT_0x5
; 0000 0106 
; 0000 0107       //Line 4
; 0000 0108       PORTA = 0b00001000;
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 0109       if(PINB.0 == 1){ operater = 1; lcd_puts("+"); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); }
	SBIS 0x16,0
	RJMP _0x47
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	__POINTW2MN _0x31,2
	CALL SUBOPT_0x0
; 0000 010A       delay_ms(10);
_0x47:
	CALL SUBOPT_0x5
; 0000 010B 
; 0000 010C       if(PINB.1 == 1){
	SBIS 0x16,1
	RJMP _0x48
; 0000 010D         lcd_puts("="); counter += 2; lcd_gotoxy(counter,0);
	__POINTW2MN _0x31,4
	CALL _lcd_puts
	LDS  R30,_counter
	LDS  R31,_counter+1
	ADIW R30,2
	STS  _counter,R30
	STS  _counter+1,R31
	LDS  R30,_counter
	CALL SUBOPT_0x1
; 0000 010E         //if((A == -1) && (B == -1)){ result = 0; itoa(result, results); lcd_puts(results); delay_ms(1000); counter += 2 ...
; 0000 010F         //if((A == -1) || (B == -1)){ lcd_gotoxy(0,0); lcd_clear(); result = A + B + 1; itoa(result, results); lcd_puts( ...
; 0000 0110 
; 0000 0111         if( operater == 1 ){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x49
; 0000 0112             if( C == -1 ){
	CALL SUBOPT_0x4
	BRNE _0x4A
; 0000 0113                 result = A + B;
	MOVW R30,R6
	ADD  R30,R4
	ADC  R31,R5
	RJMP _0x64
; 0000 0114             }
; 0000 0115             else{
_0x4A:
; 0000 0116                 result = (A * 10 + B) + C;
	CALL SUBOPT_0x6
	ADD  R30,R8
	ADC  R31,R9
_0x64:
	MOVW R12,R30
; 0000 0117             }
; 0000 0118 
; 0000 0119             itoa(result, results);
	CALL SUBOPT_0x7
; 0000 011A             lcd_puts(results);
; 0000 011B             delay_ms(1000);
; 0000 011C             counter += 2;
; 0000 011D             lcd_gotoxy(counter,0);}
; 0000 011E 
; 0000 011F 
; 0000 0120          if( operater == 0 ){
_0x49:
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x4C
; 0000 0121 
; 0000 0122             if( C == -1 ){
	CALL SUBOPT_0x4
	BRNE _0x4D
; 0000 0123                 result = A - B;
	MOVW R30,R4
	SUB  R30,R6
	SBC  R31,R7
	RJMP _0x65
; 0000 0124             }
; 0000 0125             else{
_0x4D:
; 0000 0126                 result = (A * 10 + B) - C;
	CALL SUBOPT_0x6
	SUB  R30,R8
	SBC  R31,R9
_0x65:
	MOVW R12,R30
; 0000 0127             }
; 0000 0128 
; 0000 0129             itoa(result, results);
	CALL SUBOPT_0x7
; 0000 012A             lcd_puts(results);
; 0000 012B             delay_ms(1000);
; 0000 012C             counter += 2;
; 0000 012D             lcd_gotoxy(counter,0);}
; 0000 012E 
; 0000 012F         }
_0x4C:
; 0000 0130       delay_ms(10);
_0x48:
	CALL SUBOPT_0x5
; 0000 0131 
; 0000 0132       if(PINB.2 == 1){
	SBIS 0x16,2
	RJMP _0x4F
; 0000 0133         if(A == -1) {A = 0; num_printer(A); }
	CALL SUBOPT_0x2
	BRNE _0x50
	CLR  R4
	CLR  R5
	MOVW R26,R4
	RJMP _0x66
; 0000 0134         else if(B == -1){ B = 0; num_printer(B); }
_0x50:
	CALL SUBOPT_0x3
	BRNE _0x52
	CLR  R6
	CLR  R7
	MOVW R26,R6
	RJMP _0x66
; 0000 0135         else if(C == -1){ C = 0; num_printer(C); }
_0x52:
	CALL SUBOPT_0x4
	BRNE _0x54
	CLR  R8
	CLR  R9
	MOVW R26,R8
	RJMP _0x66
; 0000 0136         else{ num_printer(0); }
_0x54:
	LDI  R26,LOW(0)
	LDI  R27,0
_0x66:
	RCALL _num_printer
; 0000 0137       }
; 0000 0138       delay_ms(10);
_0x4F:
	CALL SUBOPT_0x5
; 0000 0139 
; 0000 013A       if(PINB.3 == 1){
	SBIS 0x16,3
	RJMP _0x56
; 0000 013B         if(A != -1){ A = -1; }
	CALL SUBOPT_0x2
	BREQ _0x57
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 013C         if(B != -1){ B = -1; }
_0x57:
	CALL SUBOPT_0x3
	BREQ _0x58
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R6,R30
; 0000 013D         if(C != -1){ C = -1; }
_0x58:
	CALL SUBOPT_0x4
	BREQ _0x59
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
; 0000 013E         lcd_clear();
_0x59:
	CALL _lcd_clear
; 0000 013F         counter = 0;
	LDI  R30,LOW(0)
	STS  _counter,R30
	STS  _counter+1,R30
; 0000 0140         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0141       }
; 0000 0142       delay_ms(10);
_0x56:
	CALL SUBOPT_0x5
; 0000 0143 
; 0000 0144       }
	RJMP _0x3
; 0000 0145 
; 0000 0146 }
_0x5A:
	RJMP _0x5A
; .FEND

	.DSEG
_0x31:
	.BYTE 0x6

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 2
	SBI  0x15,2
	__DELAY_USB 2
	CBI  0x15,2
	__DELAY_USB 2
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 17
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20A0002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x8
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20A0001
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_nums:
	.BYTE 0x1
_results:
	.BYTE 0x1
_counter:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x0:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	LDS  R30,_counter
	LDS  R31,_counter+1
	ADIW R30,2
	STS  _counter,R30
	STS  _counter+1,R31
	LDS  R30,_counter
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R6
	ADC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ST   -Y,R13
	ST   -Y,R12
	LDI  R26,LOW(_results)
	LDI  R27,HIGH(_results)
	CALL _itoa
	LDI  R26,LOW(_results)
	LDI  R27,HIGH(_results)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
