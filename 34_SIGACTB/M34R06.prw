#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M34R06()

LOCAL OREPORT

IF FINDFUNCTION("TREPINUSE") .AND. TREPINUSE()

    OREPORT := REPORTDEF()
    OREPORT:PRINTDIALOG()
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION REPORTDEF()

LOCAL OREPORT
LOCAL OVENPROD
LOCAL CALIASQRY := GETNEXTALIAS()

OREPORT := TREPORT():NEW("M34R06","APURAÇÃO CUSTOS","M34R06",{|OREPORT|REPORTPRINT(OREPORT,CALIASQRY,OVENPROD)},"ESTE RELATORIO EMITE A RELAÇAO DE PRODUTOS DO TIPO PA "+" "+"DA MATRIZ E FILIAL APURANDO SEU CUSTO DE MÃO DE OBRA E INSUMOS.")
OREPORT:SETTOTALINLINE( .F. )

PERGUNTE(OREPORT:UPARAM, .F. )

OVENPROD := TRSECTION():NEW(OREPORT,"APURAÇÃO CUSTOS",{"SB1","SG1"},,,)

OVENPROD:SETTOTALINLINE( .F. )
OVENPROD:OREPORT:CFONTBODY := "VERDANA"
OVENPROD:OREPORT:NFONTBODY := 10

TRCELL():NEW(OVENPROD,"FILIAL",,"FILIAL",PESQPICT("SB1","B1_FILIAL"),TAMSX3("B1_FILIAL")[1],,{||CXFILIAL})
TRCELL():NEW(OVENPROD,"CODIGO",,"CÓDIGO DO PRODUTO",PESQPICT("SB1","B1_COD"),TAMSX3("B1_COD")[1],,{||CCODPRO})
TRCELL():NEW(OVENPROD,"TIPO",,"TIPO",PESQPICT("SB1","B1_TIPO"),TAMSX3("B1_TIPO")[1],,{||CTPPROD})
TRCELL():NEW(OVENPROD,"LOCAL",,"ARMAZEM PADRAO",PESQPICT("SB1","B1_LOCPAD"),TAMSX3("B1_LOCPAD")[1],,{||CLOCPAD})
TRCELL():NEW(OVENPROD,"DESCRICAO",,"DESCRIÇÃO",PESQPICT("SB1","B1_DESC"),TAMSX3("B1_DESC")[1],,{||CDESC})
TRCELL():NEW(OVENPROD,"INSUMOS",,"INSUMOS",PESQPICT("SB1","B1_CUSTD"),TAMSX3("B1_CUSTD")[1],,{||NCUSTINS})
TRCELL():NEW(OVENPROD,"MAODEOBRA",,"MÃO DE OBRA",PESQPICT("SB1","B1_CUSTD"),TAMSX3("B1_CUSTD")[1],,{||NCUSTMO})
TRCELL():NEW(OVENPROD,"QTMAODEOBR",,"QTD MÃO DE OBRA",PESQPICT("SB2","B2_QATU"),TAMSX3("B2_QATU")[1],,{||NQTDMO})
TRCELL():NEW(OVENPROD,"CUSTAND",,"CUSTO STANDARD",PESQPICT("SB1","B1_CUSTD"),TAMSX3("B2_VATU1")[1],,{||NCUSTSTD})

TRCELL():NEW(OVENPROD,"CUMEDIO",,"CUSTO MEDIO",PESQPICT("SB2","B2_CMFIM1"),TAMSX3("B2_CMFIM1")[1],,{||NCUSTME1})

RETURN OREPORT

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION REPORTPRINT(OREPORT,CALIASQRY,OVENPROD)

LOCAL AMODINF := {}
LOCAL DDTULTFECH := MV_PAR01-1

DBSELECTAREA("SB1")
DBSETORDER(1)

OREPORT:SECTION(1):BEGINQUERY()

_cQry := " SELECT B1_FILIAL, "
_cQry += "        B1_COD, "
_cQry += "        B1_DESC, "
_cQry += "        B1_TIPO, "
_cQry += "        B1_CUSTD, "
_cQry += "        B1_MSBLQL, "
_cQry += "        B1_LOCPAD "
_cQry += " FROM "+RETSQLNAME("SB1")+" SB1 "
_cQry += " WHERE SB1.B1_TIPO IN ('PA', "
_cQry += "                       'PI') "
_cQry += "   AND SB1.B1_FILIAL = '"+XFILIAL("SB1")+"' "
_cQry += "   AND SB1.B1_MSBLQL <> '1' "
_cQry += "   AND SB1.D_E_L_E_T_= ' ' "
_cQry += "   AND ( "
_cQry += "          (SELECT COUNT(*) "
_cQry += "           FROM "+RETSQLNAME("SD1")+" SD1 (NOLOCK) "
_cQry += "           WHERE D1_FILIAL = '"+XFILIAL("SD1")+"' "
_cQry += "             AND D1_COD = B1_COD "
_cQry += "             AND D1_DTDIGIT BETWEEN "+___SQLGETVALUE(MV_PAR01)+" AND "+___SQLGETVALUE(MV_PAR02)+" "
_cQry += "             AND SD1.D_E_L_E_T_ = '' ) > 0 "
_cQry += "        OR "
_cQry += "          (SELECT COUNT(*) "
_cQry += "           FROM "+RETSQLNAME("SD2")+" SD2 (NOLOCK) "
_cQry += "           WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' "
_cQry += "             AND D2_COD = B1_COD "
_cQry += "             AND D2_EMISSAO BETWEEN "+___SQLGETVALUE(MV_PAR01)+" AND "+___SQLGETVALUE(MV_PAR02)+" "
_cQry += "             AND SD2.D_E_L_E_T_ = '') > 0 "
_cQry += "        OR "
_cQry += "          (SELECT COUNT(*) "
_cQry += "           FROM "+RETSQLNAME("SD3")+" SD3 (NOLOCK) "
_cQry += "           WHERE D3_FILIAL = '"+XFILIAL("SD3")+"' "
_cQry += "             AND D3_EMISSAO BETWEEN "+___SQLGETVALUE(MV_PAR01)+" AND "+___SQLGETVALUE(MV_PAR02)+" "
_cQry += "             AND D3_COD = B1_COD "
_cQry += "             AND D3_ESTORNO = ' ' "
_cQry += "             AND SD3.D_E_L_E_T_ = '') > 0 "
_cQry += "        OR "
_cQry += "          (SELECT COUNT(*) "
_cQry += "           FROM "+RETSQLNAME("SB9")+" SB9 (NOLOCK) "
_cQry += "           WHERE B9_FILIAL = '"+XFILIAL("SB9")+"' "
_cQry += "             AND B9_DATA = "+___SQLGETVALUE(DDTULTFECH)+" "
_cQry += "             AND B9_COD = B1_COD "
_cQry += "             AND B9_QINI <> 0 "
_cQry += "             AND (B9_QINI <> 0 "
_cQry += "                  OR B9_VINI1 <> 0) "
_cQry += "             AND SB9.D_E_L_E_T_ = '') > 0) "
_cQry += " ORDER BY SB1.B1_COD "
__EXECSQL(CALIASQRY,_cQry,{}, .F. )

OREPORT:SECTION(1):ENDQUERY()

DBSELECTAREA("SB1")
DBSETORDER(1)

DBSELECTAREA("SG1")
DBSETORDER(1)

DBSELECTAREA(CALIASQRY)
DBGOTOP()
OREPORT:SETMETER((CALIASQRY)->(LASTREC()))
OREPORT:SECTION(1):INIT()

WHILE !(OREPORT:CANCEL) .AND. !((CALIASQRY)->(EOF))
 
    IF CALIASQRY->B1_MSBLQL=="1"
        (CALIASQRY)->(DBSKIP())
        LOOP 
    ENDIF
    
    NCUSTSTD := POSICIONE("SB1",1,XFILIAL("SB1")+ ALLTRIM(CALIASQRY->B1_COD),"B1_CUSTD")
    CLOCPAD := SB1->B1_LOCPAD
    
    NCUSTME1 := POSICIONE("SB2",1,XFILIAL("SB2")+ ALLTRIM(CALIASQRY->B1_COD+CALIASQRY->B1_LOCPAD),"B2_CMFIM1")
    
    AMODINF := U_M34R6MOD(CALIASQRY->B1_COD)
    
    IF VALTYPE(AMODINF)=="A"
        CXFILIAL := AMODINF[1]
    ELSE 
        CXFILIAL := "SEM ESTRUTURA"
    ENDIF
    
    CCODPRO := CALIASQRY->B1_COD
    CDESC := CALIASQRY->B1_DESC
    CTPPROD := CALIASQRY->B1_TIPO
    NCUSTMO := AMODINF[2]
    NQTDMO := AMODINF[3]
    
    NCUSTME1 := NCUSTME1
    
    NCUSTINS := NCUSTSTD-NCUSTMO
    
    OREPORT:INCMETER()
    OREPORT:SECTION(1):PRINTLINE()
    
    (CALIASQRY)->(DBSKIP())
    ENDDO

DBSELECTAREA(CALIASQRY)

OREPORT:SETLANDSCAPE()
OREPORT:SECTION(1):FINISH()

(CALIASQRY)->(DBCLOSEAREA())

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M34R6MOD(_CCODPRO)

LOCAL _AESTRU := {}
LOCAL _CTPPROD := ""
LOCAL _CRETFIL := ""
LOCAL _NX := 0
LOCAL _NVALMO := 0
LOCAL _NQTDMO := 0

PRIVATE NESTRU := 0

DBSELECTAREA("SG1")
DBSETORDER(1)

SG1->(MSSEEK(XFILIAL("SG1")+ ALLTRIM(_CCODPRO)))

_AESTRU := ESTRUT(_CCODPRO,1)

IF !(EMPTY(_AESTRU))
    FOR _NX := 1 TO  LEN(_AESTRU)
        _CTPPROD := POSICIONE("SB1",1,XFILIAL("SB1")+ ALLTRIM(_AESTRU[_NX][2]),"B1_TIPO")
        _CTPCOMP := POSICIONE("SB1",1,XFILIAL("SB1")+ ALLTRIM(_AESTRU[_NX][3]),"B1_TIPO")
        
        IF (_CTPPROD=="MO") .OR. (_CTPCOMP=="MO")
            _NVALMO += (_AESTRU[_NX][4]) * (SB1->B1_CUSTD)
            _NQTDMO += _AESTRU[_NX][4]
        ENDIF
    NEXT
    _CRETFIL := "01"
ELSE 
    _CRETFIL := "SEM ESTRUTURA"
ENDIF

RETURN {_CRETFIL,_NVALMO,_NQTDMO}
