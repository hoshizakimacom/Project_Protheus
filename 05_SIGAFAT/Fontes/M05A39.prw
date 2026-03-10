#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A39()

LOCAL CRET := ""
LOCAL NVLBRUTO := CK_XVLUBRU
LOCAL NIMPOSTO := CK_XVLTIPI+CK_XVLTPS2+CK_XVLTCF2+CK_XVLTICM+CK_XVLTSOL
LOCAL NCUSTOSD := POSICIONE("SB1",1,XFILIAL("SB1")+SCK->CK_PRODUTO,"B1_CUSTD")

IF !(EMPTY(SCK->CK_TPPROD))
    CRET := ((NVLBRUTO-NIMPOSTO-NCUSTOSD) / (NVLBRUTO-NIMPOSTO)) * (100)
ELSE 
    CRET := 0
ENDIF

RETURN CRET

