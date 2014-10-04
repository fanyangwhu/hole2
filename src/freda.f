C
C
C --- FREDA --- ORIGINALLY WRITTEN BY SAM MOTHERWELL
C MODIFIED OVER THE YEARS BY ELEANOR DODSON YORK
C
      SUBROUTINE  FREDA(IMIN,IMAX,FL,NCHAR)
      CHARACTER*1 LE,FL(40,NCHAR),COL,INUM,IBLANK,IPLUS,IMINUS,IPOINT
      INTEGER ICHAR(40),IBEGIN(40)
      COMMON /FR1/  COL(80)
      COMMON /FR2/  FN(40),KN,KL
      DIMENSION NUM(10),INUM(10)
      DATA  NUM/1,2,3,4,5,6,7,8,9,0/
      DATA INUM/'1','2','3','4','5','6','7','8','9','0'/
      DATA IBLANK,IPLUS,IMINUS,IPOINT,LE/' ','+','-','.','e'/
C
      DO 1 KN=1,40
      FN(KN)=0.
      DO 1 KL=1,NCHAR
      FL(KN,KL)=IBLANK
1     CONTINUE
      KL=0
      KN=0
C
CXC  GET WORD LIMITS  EACH WORD SEPERATED BY SPACE.
      I1=IMIN-1
      J1=0
      DO 2 I=1,40
      ICHAR(I)=0
      IBEGIN(I)=0
2     CONTINUE
C
10    J1=J1+1
11    I1=I1+1
      IF(I1.GT.IMAX) J1=J1-1
      IF(I1.GT.IMAX) GO TO 20
      IF(COL(I1).EQ.IBLANK) GO TO 11
      ICHAR(J1)=1
      IBEGIN(J1)=I1
12    I1=I1+1
      IF(I1.GT.IMAX) GO TO 20
      IF(COL(I1).EQ.IBLANK) GO TO 10
      ICHAR(J1)=ICHAR(J1)+1
      GO TO 12
CC
CC
CC   UNSCRAMBLE J1 WORDS
20    KN=0
      KL=0
      DO 21 J=1,J1
      IF(ICHAR(J).EQ.0) GO TO 21
      IFIRST=IBEGIN(J)
      ILAST=IFIRST+ICHAR(J)-1
      IDIG=0
      NUMBE=0
      ILIT=0
      DO 22 I=IFIRST,ILAST
      JDIG=IDIG
      DO 23 K=1,10
      IF(COL(I).EQ.INUM(K)) IDIG=IDIG+1
23    CONTINUE
      IF(COL(I).EQ.IPOINT) IDIG=IDIG+1
      IF(COL(I).EQ.IPLUS) IDIG=IDIG+1
      IF(COL(I).EQ.IMINUS) IDIG=IDIG+1
      IF(IDIG.GT.JDIG) GO TO 22
      IF(COL(I).EQ.LE) NUMBE=I
      ILIT=1+ILIT
22    CONTINUE
      IF(NUMBE.GT.0.AND.ILIT.EQ.1.AND.IDIG.GT.0) GO TO 40
      IF(ILIT.GT.0)GO TO 30
C
CC   NUMERIC FILED
      KN=KN+1
      A=0.0
      IP=0
      NP=0
      S=1.
      DO 24 I=IFIRST,ILAST
      DO 25 K=1,10
      IF(COL(I).EQ.INUM(K)) GO TO 26
25    CONTINUE
      IF(COL(I).EQ.IPOINT) IP=1
      IF(COL(I).EQ.IPLUS) S=1.
      IF(COL(I).EQ.IMINUS) S=-1.
      GO TO 24
26    IF(K.EQ.10) K=0
      IF(IP.EQ.1) NP=NP+1
      A=10.*A + K
24    CONTINUE
      FNK=S*A/10.**NP
      IF(IP.EQ.0)THEN
        NFK=NINT(FNK)
        FN(KN)=NFK
      ELSE
        FN(KN)=FNK
      ENDIF
      GO TO 21
CC   NUMERIC E TYPE FIELD
40    KN=KN+1
      ILASE=NUMBE-1
      A=0.0
      IP=0
      NP=0
      S=1.
      DO 44 I=IFIRST,ILASE
      DO 45 K=1,10
      IF(COL(I).EQ.INUM(K)) GO TO 46
45    CONTINUE
      IF(COL(I).EQ.IPOINT) IP=1
      IF(COL(I).EQ.IPLUS) S=1.
      IF(COL(I).EQ.IMINUS) S=-1.
      GO TO 44
46    IF(K.EQ.10) K=0
      IF(IP.EQ.1) NP=NP+1
      A=10.*A + K
44    CONTINUE
      A1=S*A/10.**NP
      A=0.0
      IFIRSE=NUMBE+1
      IP=0
      NP=0
      S=1.
      DO 54 I=IFIRSE,ILAST
      DO 55 K=1,10
      IF(COL(I).EQ.INUM(K)) GO TO 56
55    CONTINUE
      IF(COL(I).EQ.IPLUS) S=1.
      IF(COL(I).EQ.IMINUS) S=-1.
      GO TO 54
56    IF(K.EQ.10) K=0
      A=10.*A + K
54    CONTINUE
      A=S*A
      FN(KN)=A1*10.**A
      GO TO 21
C
C
C  LITERAL FIELD(S)
30    KL=KL+1
      I2=1
      DO 32 I=IFIRST,ILAST
      FL(KL,I2)=COL(I)
      I2=I2+1
      IF(I.EQ.ILAST) GO TO 32
      IF(I2.GT.NCHAR) KL=KL+1
      IF(I2.GT.NCHAR)I2=1
32    CONTINUE
21    CONTINUE
      RETURN
      END