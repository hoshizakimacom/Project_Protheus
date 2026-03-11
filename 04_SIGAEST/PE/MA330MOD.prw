#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION MA330MOD()

PRIVATE LCUSUNIF := GETMV("MV_CUSFIL", .F. )

MSGSTOP("MA330MOD - INICIO")

DBSELECTAREA("ZAH")
DBSETORDER(1)
DBSEEK(XFILIAL("ZAH")+LEFT(DTOS(DDATABASE),6), .F. )
WHILE !(EOF()) .AND. ZAH->ZAH_FILIAL+ZAH->ZAH_ANOMES==XFILIAL("ZAH")+LEFT(DTOS(DDATABASE),6)
 
    CCODATU := ZAH->ZAH_CODMOD
    CLOCEST := "01"

    NQTDMOD := 0
    MCSTMOD := ZAH->ZAH_VALOR

    CQRY := " SELECT D3_COD CODMOD, SUM(D3_QUANT) QTD_REQ_OP "
    CQRY += " FROM "+RETSQLNAME("SD3")+" SD3 "
    CQRY += " WHERE D3_FILIAL = '"+XFILIAL("SD3")+"'"
    CQRY += " AND D3_EMISSAO BETWEEN '"+DTOS(FIRSTDAY(DDATABASE))+"' AND '"+DTOS(LASTDAY(DDATABASE))+"'"
    CQRY += " AND D3_COD = '"+CCODATU+"'"
    CQRY += " AND D3_OP <>  ' '   "
    CQRY += " AND D3_CF IN ('RE0','RE1') "
    CQRY += " AND SD3.D_E_L_E_T_ = ''"
    CQRY += " GROUP BY D3_COD "

    IF SELECT("TRB_SD3")>0
        DBSELECTAREA("TRB_SD3")
        DBCLOSEAREA()
    ENDIF
    DBUSEAREA( .T. ,"TOPCONN",TCGENQRY(,,CQRY),"TRB_SD3", .F. , .T. )

    DBSELECTAREA("TRB_SD3")
    (TRB_SD3)->(DBGOTOP())

    WHILE !(TRB_SD3)->(EOF())
    
        NQTDMOD += TRB_SD3->QTD_REQ_OP
        DBSKIP()
        ENDDO

    IF SELECT("TRB_SD3")>0
        DBSELECTAREA("TRB_SD3")
        DBCLOSEAREA()
    ENDIF

    DBSELECTAREA("SB2")
    DBSETORDER(1)
    DBSEEK(XFILIAL("SB2")+CCODATU+"99", .F. )

    WHILE !(EOF()) .AND. SB2->B2_FILIAL+SB2->B2_COD==XFILIAL("SB2")+CCODATU
    
        IF SB2->B2_LOCAL<>"99"
            DNSKIP()
            LOOP 
        ENDIF

        DBSELECTAREA("SB2")
        RECLOCK("SB2", .F. )
        SB2->B2_VFIM1 := MCSTMOD
        SB2->B2_QFIM := NQTDMOD
        SB2->B2_CM1 := (MCSTMOD) / (ABS(NQTDMOD))
        SB2->B2_CMFIM1 := (MCSTMOD) / (ABS(NQTDMOD))
        MSUNLOCK()

        TTFIMCOMMO({SB2->B2_VFIM1,SB2->B2_VFIM2,SB2->B2_VFIM3,SB2->B2_VFIM4,SB2->B2_VFIM5})
        TTFIMQTDMO()

        DBSELECTAREA("SB2")
        DBSKIP()
        ENDDO

    DBSELECTAREA("ZAH")
    DBSKIP()
    ENDDO

MSGSTOP("MA330MOD - FIM")

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION TTFIMCOMMO(ACUSTO)

LOCAL NV,NX,AVFIM := ARRAY(5),ACM := ARRAY(5),NMULTIPLIC := 1
LOCAL BBLOCO := { |NV,NX| RTRIM(NV)+STR(NX,1)}
LOCAL NDEC := SET(3,8)
LOCAL AAREA := GETAREA()
IF LCUSUNIF=="F"
    
    DBSELECTAREA("TRT")
    
    IF !(DBSEEK(CFILANT+SB2->B2_COD))
        CRIATRT(CFILANT,SB2->B2_COD)
    ENDIF
    RECLOCK("TRT", .F. )
    
    IF ACUSTO<>NIL
        
        FOR NX := 1 TO 5
            AVFIM[NX] := &(EVAL(BBLOCO,"TRT->TRB_VFIM",NX))+ACUSTO[NX]
        NEXT
    ENDIF
    TRB_VFIM1 := AVFIM[1]
    TRB_VFIM2 := AVFIM[2]
    TRB_VFIM3 := AVFIM[3]
    TRB_VFIM4 := AVFIM[4]
    TRB_VFIM5 := AVFIM[5]
    MSUNLOCK()
ENDIF
SET(3,NDEC)
RESTAREA(AAREA)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION TTFIMQTDMO()
LOCAL NV,NX,AVFIM := ARRAY(5),ACM := ARRAY(5),NMULTIPLIC := 1
LOCAL BBLOCO := { |NV,NX| RTRIM(NV)+STR(NX,1)}
LOCAL NDEC := SET(3,8)
LOCAL AAREA := GETAREA()

IF LCUSUNIF=="F"
    
    DBSELECTAREA("TRT")
    
    IF !(DBSEEK(CFILANT+SB2->B2_COD))
        CRIATRT(CFILANT,SB2->B2_COD)
    ENDIF
    RECLOCK("TRT", .F. )
    TRB_QFIM := TRB_QFIM+SB2->B2_QFIM
    ACM[1] := TRB_CM1
    ACM[2] := TRB_CM2
    ACM[3] := TRB_CM3
    ACM[4] := TRB_CM4
    ACM[5] := TRB_CM5
    FOR NX := 1 TO 5
        
        AVFIM[NX] := &(EVAL(BBLOCO,"TRT->TRB_VFIM",NX))
        ACM[NX] := (AVFIM[NX]) / (ABS(TRB_QFIM))
    NEXT
    TRB_CM1 := ACM[1]
    TRB_CM2 := ACM[2]
    TRB_CM3 := ACM[3]
    TRB_CM4 := ACM[4]
    TRB_CM5 := ACM[5]
    MSUNLOCK()
ENDIF
SET(3,NDEC)
RESTAREA(AAREA)

RETURN 
