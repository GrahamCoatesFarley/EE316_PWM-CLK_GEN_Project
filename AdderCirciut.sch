*version 9.1 952658048
u 167
U? 10
R? 13
V? 6
? 6
@libraries
@analysis
.AC 0 1 0
+0 101
+1 1
+2 1.00K
.DC 0 0 0 0 1 1
.TRAN 1 0 0 0
+0 0ns
+1 20ms
.STEP 0 0 0
+ 0 V1
+ 4 0
+ 5 100us
+ 6 1us
.OP 0 
@targets
@attributes
@translators
a 0 u 13 0 0 0 hln 100 PCBOARDS=PCB
a 0 u 13 0 0 0 hln 100 PSPICE=PSPICE
a 0 u 13 0 0 0 hln 100 XILINX=XILINX
@setup
unconnectedPins 0
connectViaLabel 0
connectViaLocalLabels 0
NoStim4ExtIFPortsWarnings 1
AutoGenStim4ExtIFPorts 1
@index
pageloc 1 0 5608 
@status
n 0 123:01:18:14:44:03;1676749443 e 
s 0 123:01:18:14:44:03;1676749443 e 
*page 1 0 970 720 iA
@ports
port 10 GND_EARTH 150 200 h
port 11 GND_EARTH 200 280 h
port 7 GND_EARTH 340 270 h
port 12 GND_EARTH 760 310 h
port 130 GND_EARTH 580 290 h
port 163 GND_EARTH 480 300 h
@parts
part 3 R 230 180 h
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 a 0:13 0 0 0 hln 100 PKGREF=R1
a 0 ap 9 0 15 0 hln 100 REFDES=R1
part 4 R 230 220 h
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 a 0:13 0 0 0 hln 100 PKGREF=R2
a 0 ap 9 0 15 0 hln 100 REFDES=R2
part 9 VDC 200 220 h
a 0 sp 0 0 22 37 hln 100 PART=VDC
a 0 a 0:13 0 0 0 hln 100 PKGREF=V2
a 1 ap 9 0 24 7 hcn 100 REFDES=V2
a 1 u 13 0 -11 18 hcn 100 DC=1.67V
part 63 VSIN 210 180 d
a 1 u 0 0 0 0 hcn 100 FREQ=60
a 1 u 0 0 0 0 hcn 100 VAMPL=1.67
a 1 u 0 0 0 0 hcn 100 VOFF=1.67
a 1 u 0 0 0 0 hcn 100 DC=0
a 0 a 0:13 0 0 0 hln 100 PKGREF=V4
a 1 ap 9 0 20 10 hcn 100 REFDES=V4
part 101 OPAMP 610 240 U
a 0 sp 11 0 50 60 hln 100 PART=OPAMP
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=
a 0 a 0:13 0 0 0 hln 100 PKGREF=U9
a 0 ap 9 0 14 0 hln 100 REFDES=U9
part 6 R 760 290 v
a 0 x 0:13 0 0 0 hln 100 PKGREF=R6
a 0 xp 9 0 15 0 hln 100 REFDES=R6
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 u 13 0 15 45 hln 100 VALUE=1meg
part 136 R 630 160 h
a 0 x 0:13 0 0 0 hln 100 PKGREF=R5
a 0 xp 9 0 15 0 hln 100 REFDES=R5
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
part 88 OPAMP 370 220 U
a 0 sp 11 0 50 60 hln 100 PART=OPAMP
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=
a 0 a 0:13 0 0 0 hln 100 PKGREF=U8
a 0 ap 9 0 14 0 hln 100 REFDES=U8
part 89 R 390 140 h
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 u 13 0 15 25 hln 100 VALUE=1k
a 0 x 0:13 0 0 0 hln 100 PKGREF=R3
a 0 xp 9 0 15 0 hln 100 REFDES=R3
part 142 R 500 200 h
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 x 0:13 0 0 0 hln 100 PKGREF=R4
a 0 xp 9 0 15 0 hln 100 REFDES=R4
part 162 VDC 480 240 h
a 0 sp 0 0 22 37 hln 100 PART=VDC
a 1 u 13 0 -11 18 hcn 100 DC=1.67V
a 0 a 0:13 0 0 0 hln 100 PKGREF=V5
a 1 ap 9 0 24 7 hcn 100 REFDES=V5
part 161 R 510 240 h
a 0 sp 0 0 0 10 hlb 100 PART=R
a 0 s 0:13 0 0 0 hln 100 PKGTYPE=RC05
a 0 s 0:13 0 0 0 hln 100 GATE=
a 0 a 0:13 0 0 0 hln 100 PKGREF=R12
a 0 ap 9 0 15 0 hln 100 REFDES=R12
part 1 titleblk 970 720 h
a 1 s 13 0 350 10 hcn 100 PAGESIZE=A
a 1 s 13 0 180 60 hcn 100 PAGETITLE=
a 1 s 13 0 300 95 hrn 100 PAGENO=1
a 1 s 13 0 340 95 hrn 100 PAGECOUNT=1
part 57 nodeMarker 220 180 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=R1:2
a 0 a 0 0 4 22 hlb 100 LABEL=2
part 56 nodeMarker 760 220 h
a 0 s 0 0 0 0 hln 100 PROBEVAR=R4:2
a 0 a 0 0 4 22 hlb 100 LABEL=1
@conn
w 47
a 0 up 0:33 0 0 0 hln 100 V=
s 200 220 230 220 46
a 0 up 33 0 215 219 hct 100 V=
w 45
a 0 up 0:33 0 0 0 hln 100 V=
s 200 260 200 280 52
a 0 up 33 0 202 270 hlt 100 V=
w 14
s 150 200 150 180 13
s 150 180 170 180 15
w 18
a 0 up 0:33 0 0 0 hln 100 V=
s 210 180 220 180 17
a 0 up 33 0 220 179 hct 100 V=
s 220 180 230 180 59
w 41
a 0 up 0:33 0 0 0 hln 100 V=
s 370 220 340 220 69
s 340 220 340 270 71
a 0 up 33 0 342 245 hlt 100 V=
w 39
a 0 up 0:33 0 0 0 hln 100 V=
s 760 290 760 310 38
a 0 up 33 0 762 300 hlt 100 V=
w 127
a 0 up 0:33 0 0 0 hln 100 V=
s 610 240 580 240 126
s 580 240 580 290 128
a 0 up 33 0 582 265 hlt 100 V=
w 116
a 0 up 0:33 0 0 0 hln 100 V=
s 720 160 720 220 117
a 0 up 33 0 722 190 hlt 100 V=
s 720 220 690 220 119
s 760 220 760 250 36
s 760 220 720 220 123
s 670 160 720 160 139
w 158
a 0 up 0:33 0 0 0 hln 100 V=
s 480 240 510 240 157
a 0 up 33 0 495 239 hct 100 V=
w 160
a 0 up 0:33 0 0 0 hln 100 V=
s 480 280 480 300 159
a 0 up 33 0 482 290 hlt 100 V=
w 135
a 0 up 0:33 0 0 0 hln 100 V=
s 570 200 570 160 110
s 570 200 610 200 112
s 570 160 630 160 137
a 0 up 33 0 600 159 hct 100 V=
s 540 200 550 200 145
s 550 200 570 200 166
s 550 240 550 200 164
w 66
a 0 up 0:33 0 0 0 hln 100 V=
s 470 200 450 200 97
s 470 200 470 140 95
a 0 up 33 0 472 170 hlt 100 V=
s 470 140 430 140 98
s 470 200 500 200 143
w 156
a 0 up 0:33 0 0 0 hln 100 V=
s 310 220 310 180 23
s 270 220 310 220 21
s 270 180 310 180 19
s 310 180 360 180 25
a 0 up 33 0 340 179 hct 100 V=
s 360 180 370 180 94
s 360 140 360 180 92
s 360 140 390 140 90
@junction
j 150 200
+ s 10
+ w 14
j 230 180
+ p 3 1
+ w 18
j 270 180
+ p 3 2
+ w 156
j 310 180
+ w 156
+ w 156
j 220 180
+ p 57 pin1
+ w 18
j 170 180
+ p 63 -
+ w 14
j 210 180
+ p 63 +
+ w 18
j 370 220
+ p 88 +
+ w 41
j 370 180
+ p 88 -
+ w 156
j 340 270
+ s 7
+ w 41
j 390 140
+ p 89 1
+ w 156
j 360 180
+ w 156
+ w 156
j 760 310
+ s 12
+ w 39
j 690 220
+ p 101 OUT
+ w 116
j 760 250
+ p 6 2
+ w 116
j 720 220
+ w 116
+ w 116
j 760 290
+ p 6 1
+ w 39
j 760 220
+ p 56 pin1
+ w 116
j 610 240
+ p 101 +
+ w 127
j 580 290
+ s 130
+ w 127
j 610 200
+ p 101 -
+ w 135
j 630 160
+ p 136 1
+ w 135
j 670 160
+ p 136 2
+ w 116
j 470 200
+ w 66
+ w 66
j 540 200
+ p 142 2
+ w 135
j 570 200
+ w 135
+ w 135
j 450 200
+ p 88 OUT
+ w 66
j 430 140
+ p 89 2
+ w 66
j 500 200
+ p 142 1
+ w 66
j 200 220
+ p 9 +
+ w 47
j 200 260
+ p 9 -
+ w 45
j 270 220
+ p 4 2
+ w 156
j 230 220
+ p 4 1
+ w 47
j 200 280
+ s 11
+ w 45
j 510 240
+ p 161 1
+ w 158
j 480 240
+ p 162 +
+ w 158
j 480 280
+ p 162 -
+ w 160
j 480 300
+ s 163
+ w 160
j 550 240
+ p 161 2
+ w 135
j 550 200
+ w 135
+ w 135
@attributes
a 0 s 0:13 0 0 0 hln 100 PAGETITLE=
a 0 s 0:13 0 0 0 hln 100 PAGENO=1
a 0 s 0:13 0 0 0 hln 100 PAGESIZE=A
a 0 s 0:13 0 0 0 hln 100 PAGECOUNT=1
@graphics
