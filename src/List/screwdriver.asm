
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny13A
;Program type             : Application
;Clock frequency          : 9,600000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 16 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Smart register allocation          : Off
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny13A
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 159
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
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
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _btn_mode_trig=R5
	.DEF _sec=R6
	.DEF _ms=R8
	.DEF _tick=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr

_0x3:
	.DB  0x0,0x3F,0x7F
_0x1C:
	.DB  0x1,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  _speed
	.DW  _0x3*2

	.DW  0x02
	.DW  0x04
	.DW  _0x1C*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10.11.2017
;Author  : Nikopol
;Company :
;Comments:
;
;
;Chip type               : ATtiny13A
;AVR Core Clock frequency: 9,600000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 16
;*****************************************************/
;#include <tiny13a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <delay.h>
;
;
;#define STATUS_LED_PIN      2
;#define STATUS_LED_PORT     PORTB
;#define STATUS_LED_ON       STATUS_LED_PORT |= (1<<STATUS_LED_PIN);
;#define STATUS_LED_OFF      STATUS_LED_PORT &= ~(1<<STATUS_LED_PIN);
;#define STATUS_LED_TOGLE    STATUS_LED_PORT ^= (1<<STATUS_LED_PIN);
;
;
;#define PWR_PIN             4
;#define PWR_PORT            PORTB
;#define PWR_OFF             PWR_PORT |= (1<<PWR_PIN);
;
;
;#define KEY_MODE_VAL        605
;#define KEY_FWD_VAL         344
;#define KEY_REV_VAL         186
;#define KEY_DELTA_VAL       50
;
;#define MODE_FAST           0
;#define MODE_MED            1
;#define MODE_SLOW           2
;#define MODE_COUNT          2
;
;#define TIME_TO_OFF         360 // sec
;
;unsigned char mode = MODE_MED;
;unsigned char btn_mode_trig = 0;
;unsigned char speed[3] = {0x00, 0x3F, 0x7F};     // speed = 0xFF - need speed;

	.DSEG
;unsigned int sec, ms, tick;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003A {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003B     tick ++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 10,11,30,31
; 0000 003C     if (tick == 5) {
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x4
; 0000 003D         tick = 0;
	CLR  R10
	CLR  R11
; 0000 003E         ms ++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 8,9,30,31
; 0000 003F         switch (mode){
	MOV  R30,R4
	LDI  R31,0
; 0000 0040             case MODE_FAST:STATUS_LED_ON; break;
	SBIW R30,0
	BRNE _0x8
	SBI  0x18,2
	RJMP _0x7
; 0000 0041             case MODE_MED: if(ms % 200 == 0) {STATUS_LED_TOGLE;} break;
_0x8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9
	__GETW2R 8,9
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL __MODW21U
	SBIW R30,0
	BRNE _0xA
	RCALL SUBOPT_0x0
_0xA:
	RJMP _0x7
; 0000 0042             case MODE_SLOW: if(ms % 500 == 0) {STATUS_LED_TOGLE;} break;
_0x9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7
	__GETW2R 8,9
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL __MODW21U
	SBIW R30,0
	BRNE _0xC
	RCALL SUBOPT_0x0
_0xC:
; 0000 0043         }
_0x7:
; 0000 0044     }
; 0000 0045     if (ms >= 1000) {
_0x4:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0xD
; 0000 0046         sec ++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 6,7,30,31
; 0000 0047         ms = 0;
	CLR  R8
	CLR  R9
; 0000 0048     }
; 0000 0049     if (sec >= TIME_TO_OFF ){
_0xD:
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xE
; 0000 004A         PWR_OFF;
	SBI  0x18,4
; 0000 004B     }
; 0000 004C }
_0xE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;#define FIRST_ADC_INPUT 3
;#define LAST_ADC_INPUT 3
;unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
;#define ADC_VREF_TYPE 0x40
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0056 {
_adc_isr:
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0057 static unsigned char input_index=0;
; 0000 0058 // Read the AD conversion result
; 0000 0059 adc_data[input_index]=ADCW;
	LDS  R30,_input_index_S0000001000
	LDI  R26,LOW(_adc_data)
	LSL  R30
	ADD  R26,R30
	IN   R30,0x4
	IN   R31,0x4+1
	ST   X+,R30
	ST   X,R31
; 0000 005A // Select next ADC input
; 0000 005B if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
	LDS  R26,_input_index_S0000001000
	SUBI R26,-LOW(1)
	STS  _input_index_S0000001000,R26
	CPI  R26,LOW(0x1)
	BRLO _0xF
; 0000 005C    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S0000001000,R30
; 0000 005D ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
_0xF:
	LDS  R30,_input_index_S0000001000
	SUBI R30,-LOW(67)
	OUT  0x7,R30
; 0000 005E // Delay needed for the stabilization of the ADC input voltage
; 0000 005F delay_us(10);
	__DELAY_USB 32
; 0000 0060 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 0065 {
_main:
; 0000 0066 // Declare your local variables here
; 0000 0067 
; 0000 0068 // Crystal Oscillator division factor: 1
; 0000 0069 #pragma optsize-
; 0000 006A CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 006B CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 006C #ifdef _OPTIMIZE_SIZE_
; 0000 006D #pragma optsize+
; 0000 006E #endif
; 0000 006F 
; 0000 0070 // Input/Output Ports initialization
; 0000 0071 // Port B initialization
; 0000 0072 // Func5=In Func4=Out Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0073 // State5=T State4=0 State3=T State2=0 State1=0 State0=0
; 0000 0074 PORTB=0x00;
	OUT  0x18,R30
; 0000 0075 DDRB=0x17;
	LDI  R30,LOW(23)
	OUT  0x17,R30
; 0000 0076 
; 0000 0077 // Timer/Counter 0 initialization
; 0000 0078 // Clock source: System Clock
; 0000 0079 // Clock value: 1200,000 kHz
; 0000 007A // Mode: Fast PWM top=0xFF
; 0000 007B // OC0A output: Inverted PWM
; 0000 007C // OC0B output: Inverted PWM
; 0000 007D TCCR0A=0xF3;
	LDI  R30,LOW(243)
	OUT  0x2F,R30
; 0000 007E TCCR0B=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 007F TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0080 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0081 OCR0B=0x00;
	OUT  0x29,R30
; 0000 0082 
; 0000 0083 // External Interrupt(s) initialization
; 0000 0084 // INT0: Off
; 0000 0085 // Interrupt on any change on pins PCINT0-5: Off
; 0000 0086 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0087 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0088 
; 0000 0089 // Timer/Counter 0 Interrupt(s) initialization
; 0000 008A TIMSK0=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 008B 
; 0000 008C // Analog Comparator initialization
; 0000 008D // Analog Comparator: Off
; 0000 008E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 008F ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0090 DIDR0=0x00;
	OUT  0x14,R30
; 0000 0091 
; 0000 0092 // ADC initialization
; 0000 0093 // ADC Clock frequency: 600,000 kHz
; 0000 0094 // ADC Bandgap Voltage Reference: On
; 0000 0095 // ADC Auto Trigger Source: Timer0 Overflow
; 0000 0096 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: Off
; 0000 0097 DIDR0&=0x03;
	IN   R30,0x14
	ANDI R30,LOW(0x3)
	OUT  0x14,R30
; 0000 0098 DIDR0|=0x08;
	SBI  0x14,3
; 0000 0099 ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(67)
	OUT  0x7,R30
; 0000 009A ADCSRA=0xAC;
	LDI  R30,LOW(172)
	OUT  0x6,R30
; 0000 009B ADCSRB&=0xF8;
	IN   R30,0x3
	ANDI R30,LOW(0xF8)
	OUT  0x3,R30
; 0000 009C ADCSRB|=0x04;
	SBI  0x3,2
; 0000 009D 
; 0000 009E sec = 0;
	CLR  R6
	CLR  R7
; 0000 009F ms = 0;
	CLR  R8
	CLR  R9
; 0000 00A0 tick = 0;
	CLR  R10
	CLR  R11
; 0000 00A1 // Global enable interrupts
; 0000 00A2 #asm("sei")
	sei
; 0000 00A3 
; 0000 00A4 while (1)
_0x10:
; 0000 00A5       {
; 0000 00A6         if (abs(adc_data[0] - KEY_MODE_VAL) <=  KEY_DELTA_VAL) {
	RCALL SUBOPT_0x1
	SUBI R26,LOW(605)
	SBCI R27,HIGH(605)
	RCALL _abs
	SBIW R30,51
	BRSH _0x13
; 0000 00A7             if (!btn_mode_trig) {
	TST  R5
	BRNE _0x14
; 0000 00A8                 // press "mode" key detected
; 0000 00A9                 mode ++;
	INC  R4
; 0000 00AA                 if (mode > MODE_COUNT) {
	LDI  R30,LOW(2)
	CP   R30,R4
	BRSH _0x15
; 0000 00AB                     mode = 0;
	CLR  R4
; 0000 00AC                 }
; 0000 00AD             }
_0x15:
; 0000 00AE             btn_mode_trig = 1;
_0x14:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00AF         } else {
	RJMP _0x16
_0x13:
; 0000 00B0             btn_mode_trig = 0;
	CLR  R5
; 0000 00B1         }
_0x16:
; 0000 00B2 
; 0000 00B3         if (abs(adc_data[0] - KEY_FWD_VAL) <=  KEY_DELTA_VAL) {
	RCALL SUBOPT_0x1
	SUBI R26,LOW(344)
	SBCI R27,HIGH(344)
	RCALL _abs
	SBIW R30,51
	BRSH _0x17
; 0000 00B4             STATUS_LED_OFF;
	RCALL SUBOPT_0x2
; 0000 00B5              OCR0A = speed[mode];
	OUT  0x36,R30
; 0000 00B6             sec = 0;
	CLR  R6
	CLR  R7
; 0000 00B7         } else if (abs(adc_data[0] - KEY_REV_VAL) <=  KEY_DELTA_VAL) {
	RJMP _0x18
_0x17:
	RCALL SUBOPT_0x1
	SUBI R26,LOW(186)
	SBCI R27,HIGH(186)
	RCALL _abs
	SBIW R30,51
	BRSH _0x19
; 0000 00B8             STATUS_LED_OFF;
	RCALL SUBOPT_0x2
; 0000 00B9             OCR0B = speed[mode];
	OUT  0x29,R30
; 0000 00BA             sec = 0;
	CLR  R6
	CLR  R7
; 0000 00BB         } else {
	RJMP _0x1A
_0x19:
; 0000 00BC             // off all
; 0000 00BD             OCR0A=0xFF;
	LDI  R30,LOW(255)
	OUT  0x36,R30
; 0000 00BE             OCR0B=0xFF;
	OUT  0x29,R30
; 0000 00BF             //STATUS_LED_OFF;
; 0000 00C0         }
_0x1A:
_0x18:
; 0000 00C1 
; 0000 00C2       }
	RJMP _0x10
; 0000 00C3 }
_0x1B:
	RJMP _0x1B

	.CSEG
_abs:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_speed:
	.BYTE 0x3
_adc_data:
	.BYTE 0x2
_input_index_S0000001000:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R30,0x18
	LDI  R26,LOW(4)
	EOR  R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CBI  0x18,2
	LDI  R26,LOW(_speed)
	ADD  R26,R4
	LD   R30,X
	RET


	.CSEG
__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__MODW21U:
	RCALL __DIVW21U
	MOV  R30,R26
	MOV  R31,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
