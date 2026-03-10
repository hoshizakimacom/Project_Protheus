#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M02V01()

LOCAL LRET :=  .T. 

IF READVAR()=="M->C7_DATPRF"
    
    IF (DTOS(&(READVAR()))<DTOS(DA120EMIS)) .OR. (DTOS(&(READVAR()))<DTOS(DDATABASE))
        LRET :=  .F. 
        HELP(" ",1,"INCONSISTENCIA",,"A DATA DE ENTREGA NÃO PODE SER INFERIOR A DATA DE EMISSAO OU DATABASE.",4)
    ENDIF
ENDIF

RETURN LRET

