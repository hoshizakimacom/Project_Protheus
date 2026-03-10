#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A40()

LOCAL CRET := ""
LOCAL NVLBRUTO := CK_XVLUBRU
LOCAL NIMPOSTO := CK_XVLTIPI+CK_XVLTPS2+CK_XVLTCF2+CK_XVLTICM+CK_XVLTSOL
LOCAL NCUSTOMD := POSICIONE("SB2",1,XFILIAL("SB2")+SCK->CK_PRODUTO,"B2_CMFIM1")

IF !(EMPTY(SCK->CK_TPPROD))
    CRET := ((NVLBRUTO-NIMPOSTO-NCUSTOMD) / (NVLBRUTO-NIMPOSTO)) * (100)
ELSE 
    CRET := 0
ENDIF

RETURN CRET
