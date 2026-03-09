#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M02A08(NTIPO)

LOCAL AAREA := GETAREA()
LOCAL AAREASC7 := SC7->(GETAREA())
LOCAL ODLG
LOCAL DDTENT := CTOD("  /  /  ")
LOCAL NOPCA := 1
LOCAL NITENSTOT := 0
LOCAL NITENSALT := 0
LOCAL CPEDCOMPRA := SC7->C7_NUM
LOCAL DEMISSAO := SC7->C7_EMISSAO

IF (!(EMPTY(SC7->C7_RESIDUO))) .OR. (SC7->C7_QUJE=SC7->C7_QUANT)
    AVISO("ATENCAO !",OEMTOANSI("PEDIDO DE COMPRA J� ENCERRADO !!"),{"OK"})
    RETURN 
ENDIF

IF NTIPO==1
    DBSELECTAREA("SC7")
    DBSETORDER(1)
    DBSEEK(XFILIAL("SC7")+SC7->C7_NUM)
    WHILE !(EOF()) .AND. SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+CPEDCOMPRA
    
        IF SC7->C7_QUANT>SC7->C7_QUJE
            DDTENT := SC7->C7_DATPRF
            EXIT 
        ENDIF

        DBSKIP()
        ENDDO
ELSE 

    DDTENT := SC7->C7_DATPRF
ENDIF

IF EMPTY(DDTENT)
    AVISO("ATENCAO !",OEMTOANSI("PEDIDO DE COMPRA J� ENCERRADO !!"),{"OK"})
    RESTAREA(AAREASC7)
    RESTAREA(AAREA)
    RETURN 
ENDIF

ODLG := MSDIALOG():NEW(200,1,350,500,OEMTOANSI("ALTERA플O DA DATA DE ENTREGA DO PEDIDO : "+CPEDCOMPRA),,, .F. ,,,,,, .T. ,,, .F. )

TSAY():NEW(40,30,{||OEMTOANSI("DATA ENTREGA : ")},ODLG,,, .F. , .F. , .F. , .T. ,,,50,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(40,80,{ | U |IIF(PCOUNT()==0,DDTENT,DDTENT := U)},ODLG,50,10,,{||DDTENT>=DEMISSAO},,,, .F. ,, .T. ,, .F. ,{|| .T. }, .F. , .F. ,, .F. , .F. ,,"DDTENT",,,,)

ODLG:ACTIVATE(ODLG:BLCLICKED,ODLG:BMOVED,ODLG:BPAINTED, .T. ,,,{|SELF|ENCHOICEBAR(ODLG,{||NOPCA := 1,ODLG:END()},{||NOPCA := 0,ODLG:END()})},ODLG:BRCLICKED,)

IF NOPCA==1

    NITENSTOT := 0
    NITENSALT := 0
    
    IF NTIPO==1
        DBSELECTAREA("SC7")
        DBSETORDER(1)
        DBSEEK(XFILIAL("SC7")+CPEDCOMPRA)
        WHILE !(EOF()) .AND. SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+CPEDCOMPRA
        
            NITENSTOT++
            
            IF SC7->C7_QUANT>SC7->C7_QUJE
                RECLOCK("SC7", .F. )
                
                IF EMPTY(SC7->C7_XENTORI)
  SC7->C7_XENTORI := SC7->C7_DATPRF
                ENDIF
                SC7->C7_DATPRF := DDTENT
                MSUNLOCK()
                NITENSALT++
            ENDIF
            DBSKIP()
            ENDDO
    ELSE 
        
        RECLOCK("SC7", .F. )
        
        IF EMPTY(SC7->C7_XENTORI)
            SC7->C7_XENTORI := SC7->C7_DATPRF
        ENDIF
        SC7->C7_DATPRF := DDTENT
        MSUNLOCK()
        NITENSALT++
        NITENSTOT++
    ENDIF
    
    AVISO("ATENCAO !",OEMTOANSI("ALTERADOS ITEM(S) : "+ STRZERO(NITENSALT,4)+" DE "+ STRZERO(NITENSTOT,4)),{"OK"})
ENDIF

RESTAREA(AAREASC7)
RESTAREA(AAREA)

RETURN  .T. 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M02A081()

LOCAL AAREA := GETAREA()
LOCAL AAREASC7 := SC7->(GETAREA())
LOCAL ODLG
LOCAL DDTENV := CTOD("  /  /  ")
LOCAL NOPCA := 1
LOCAL NITENSTOT := 0
LOCAL NITENSALT := 0
LOCAL CPEDCOMPRA := SC7->C7_NUM
LOCAL DEMISSAO := SC7->C7_EMISSAO

DBSELECTAREA("SC7")
DBSETORDER(1)
DBSEEK(XFILIAL("SC7")+SC7->C7_NUM)

DDTENV := DDATABASE

ODLG := MSDIALOG():NEW(200,1,350,500,OEMTOANSI("ALTERA플O DA DATA DE ENVIO DO PEDIDO : "+CPEDCOMPRA),,, .F. ,,,,,, .T. ,,, .F. )

TSAY():NEW(40,30,{||OEMTOANSI("DATA ENVIO : ")},ODLG,,, .F. , .F. , .F. , .T. ,,,50,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(40,80,{ | U |IIF(PCOUNT()==0,DDTENV,DDTENV := U)},ODLG,50,10,,{||(DDTENV>=DEMISSAO) .OR. (EMPTY(DDTENV))},,,, .F. ,, .T. ,, .F. ,{|| .T. }, .F. , .F. ,, .F. , .F. ,,"DDTENV",,,,)

ODLG:ACTIVATE(ODLG:BLCLICKED,ODLG:BMOVED,ODLG:BPAINTED, .T. ,,,{|SELF|ENCHOICEBAR(ODLG,{||NOPCA := 1,ODLG:END()},{||NOPCA := 0,ODLG:END()})},ODLG:BRCLICKED,)

IF NOPCA==1
    
    NITENSTOT := 0
    NITENSALT := 0
    
    DBSELECTAREA("SC7")
    DBSETORDER(1)
    DBSEEK(XFILIAL("SC7")+CPEDCOMPRA)
    WHILE !(EOF()) .AND. SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+CPEDCOMPRA
    
        NITENSTOT++
        RECLOCK("SC7", .F. )
        SC7->C7_XENVFOR := DDTENV
        MSUNLOCK()
        NITENSALT++
        
        DBSKIP()
        ENDDO
    
    AVISO("ATENCAO !",OEMTOANSI("ALTERADOS ITEM(S) : "+ STRZERO(NITENSALT,4)+" DE "+ STRZERO(NITENSTOT,4)),{"OK"})
ENDIF

RESTAREA(AAREASC7)
RESTAREA(AAREA)

RETURN  .T. 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M02A082(NTIPO)

LOCAL AAREA := GETAREA()
LOCAL AAREASC7 := SC7->(GETAREA())
LOCAL ODLG
LOCAL COBSINT
LOCAL NOPCA := 1
LOCAL CPEDCOMPRA := SC7->C7_NUM

COBSINT := SC7->C7_XOBSINT

ODLG := MSDIALOG():NEW(200,1,350,800,OEMTOANSI("ALTERA플O DA OBSERVA플O INTERNA DO PEDIDO/ITEM : "+CPEDCOMPRA),,, .F. ,,,,,, .T. ,,, .F. )

TSAY():NEW(40,20,{||OEMTOANSI("OBS INTERNA: ")},ODLG,,, .F. , .F. , .F. , .T. ,,,50,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(40,70,{ | U |IIF(PCOUNT()==0,COBSINT,COBSINT := U)},ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .T. }, .F. , .F. ,, .F. , .F. ,,"COBSINT",,,,)

ODLG:ACTIVATE(ODLG:BLCLICKED,ODLG:BMOVED,ODLG:BPAINTED, .T. ,,,{|SELF|ENCHOICEBAR(ODLG,{||NOPCA := 1,ODLG:END()},{||NOPCA := 0,ODLG:END()})},ODLG:BRCLICKED,)

IF NTIPO==1
    
    IF NOPCA==1
        DBSELECTAREA("SC7")
        DBSETORDER(1)
        DBSEEK(XFILIAL("SC7")+CPEDCOMPRA)
        WHILE !(EOF()) .AND. SC7->C7_FILIAL+SC7->C7_NUM==XFILIAL("SC7")+CPEDCOMPRA
        
            RECLOCK("SC7", .F. )
            SC7->C7_XOBSINT := COBSINT
            MSUNLOCK()
            DBSKIP()
            ENDDO
        
        SC7->(DBCLOSEAREA())
        
        AVISO("ATENCAO !",OEMTOANSI("OBSERVA플O INTERNA DO ITEM ALTERADO !"),{"OK"})
    ENDIF
ENDIF
IF NOPCA==1
    
    RECLOCK("SC7", .F. )
    SC7->C7_XOBSINT := COBSINT
    MSUNLOCK()
    
    AVISO("ATENCAO !",OEMTOANSI("OBSERVA플O INTERNA DO ITEM ALTERADO !"),{"OK"})
ENDIF

RESTAREA(AAREASC7)
RESTAREA(AAREA)

RETURN  .T. 
