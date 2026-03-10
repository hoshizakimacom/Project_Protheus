#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A41()

LOCAL CRET := ""
LOCAL NVLBRUTO := SC6->C6_XVLTBRU
LOCAL NIMPOSTO := SC6->C6_XVLTIPI+SC6->C6_XVLTPS2+SC6->C6_XVLTICM+SC6->C6_XVLTSOL

IF !(EMPTY(SC6->C6_TPPROD))
    CRET := NVLBRUTO-NIMPOSTO
ELSE 
    CRET := 0
ENDIF

RETURN CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A41A()

LOCAL CRET := ""
LOCAL NVLBRUTO := SC6->C6_XVLTBRU
LOCAL NFRETE := SC5->C5_FRETE
LOCAL NVLINST := SC5->C5_XVLRINS
LOCAL NACRSPED := SC5->C5_XACRESC
LOCAL NCONDPAG := POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"E4_ACRSFIN")

IF !(EMPTY(SC6->C6_TPPROD))
    CRET := NVLBRUTO+NFRETE+NVLINST+(NVLBRUTO) / (NACRSPED)+(NVLBRUTO) / (NCONDPAG)
ELSE 
    
    CRET := 0
ENDIF

RETURN CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A41B()

LOCAL CRET := ""
LOCAL NVLTABELA := SC6->C6_XVLUTAB
LOCAL NQUANT := SC6->C6_QTDVEN

IF !(EMPTY(SC6->C6_TPPROD))
    CRET := (NVLTABELA) * (NQUANT)
ELSE 
    CRET := 0
ENDIF

RETURN CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A41C()

LOCAL CRET := ""
LOCAL NVLBRUTO := SC6->C6_XVLTBRU
LOCAL NIMPOSTO := SC6->C6_XVLTIPI+SC6->C6_XVLTPS2+SC6->C6_XVLTICM+SC6->C6_XVLTSOL
LOCAL NVLTABELA := SC6->C6_XVLUTAB
LOCAL NQUANT := SC6->C6_QTDVEN

IF !(EMPTY(SC6->C6_TPPROD))
    CRET := (NVLBRUTO-NIMPOSTO) / ((NVLTABELA) * (NQUANT))-1
ELSE 
    CRET := 0
ENDIF

RETURN CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A41D()

LOCAL CRET := ""
LOCAL NCOMIS1 := SC5->C5_COMIS1
LOCAL NCOMIS2 := SC5->C5_COMIS2
LOCAL NCOMIS3 := SC5->C5_COMIS3
LOCAL NCOMIS4 := SC5->C5_COMIS4
LOCAL NCOMIS5 := SC5->C5_COMIS5
LOCAL NVLBRUTO := SC6->C6_XVLTBRU
LOCAL NIMPOSTO := SC6->C6_XVLTIPI+SC6->C6_XVLTPS2+SC6->C6_XVLTICM+SC6->C6_XVLTSOL

IF !(EMPTY(SC6->C6_TPPROD))
    CRET := (NCOMIS1+NCOMIS2+NCOMIS3+NCOMIS4+NCOMIS5) * (NVLBRUTO-NIMPOSTO)
ELSE 
    CRET := 0
ENDIF

RETURN CRET
