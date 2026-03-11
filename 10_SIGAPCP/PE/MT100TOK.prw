#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION MT100TOK()
LOCAL LRET :=  .T. 
LOCAL NPOSPED := ASCAN(AHEADER,{|X| ALLTRIM(X[2])=="D1_PEDIDO"})
LOCAL CUSERS := GETMV("AM_MT100OK")
LOCAL I

IF ((!(FWISINCALLSTACK("U_GATI001"))) .OR. (IIF(TYPE("L103AUTO")=="U", .T. ,!(L103AUTO)))) 
 
ENDIF
cUserLogado := RETCODUSR()
FOR I := 1 TO  LEN(ACOLS)
    
    IF ACOLS[I][ LEN(AHEADER)+1]
        LOOP 
    ENDIF
    
    DBSELECTAREA("SC7")
    DBSETORDER(1)
    
    IF DBSEEK(XFILIAL("SC7")+ACOLS[I][NPOSPED])
        
        IF !(PADR(CCONDICAO,TAMSX3("C7_COND")[1])==SC7->C7_COND) .AND. !((cUserLogado) $ (CUSERS))
            AVISO("ATENÇÃO !","A CONDIÇÃO DE PAGAMENTO DO PEDIDO DE COMPRA NÃO PODE SER ALTERADA! CONDIÇÃO:"+SC7->C7_COND,{"OK"})
            LRET :=  .F. 
            EXIT 
        ENDIF
    ENDIF
NEXT

IF (LRET) 
 
 ENDIF

RETURN LRET
