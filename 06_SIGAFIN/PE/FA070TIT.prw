#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION FA070TIT()

LOCAL LRET :=  .T. 

IF SE1->E1_PREFIXO=="PVA" .AND. SE1->E1_TIPO=="BOL" .AND. NVALREC+NDESCONT<SE1->E1_SALDO
    MSGinfo("BAIXA PARCIAL NÃO PERMITIDA ! BAIXA NÃO REALIZADA","ATENCAO!!!")
    LRET :=  .F. 
ENDIF

RETURN LRET

