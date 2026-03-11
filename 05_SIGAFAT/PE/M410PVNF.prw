#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M410PVNF()
LOCAL LRET :=  .T. 
//LOCAL _LRET :=  .T. 
LOCAL AAREA := GETAREA()
LOCAL AAREAC5 := SC5->(GETAREA())
LOCAL AAREAC6 := SC6->(GETAREA())

IF SC5->C5_XSTSFIN=="1"
    MSGSTOP("O PEDIDO ENCONTRA-SE COM BLOQUEIO FINANCEIRO. SOLICITE A LIBERAÇÃO FINANCEIRA DO PEDIDO.","ATENÇÃO")
    LRET :=  .F. 
ENDIF

RESTAREA(AAREAC6)
RESTAREA(AAREAC5)
RESTAREA(AAREA)
RETURN LRET

