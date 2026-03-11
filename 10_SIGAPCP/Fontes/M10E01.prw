#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M10E01()
LOCAL _ODLG := NIL
LOCAL _NOPCA := 0
LOCAL _CTITULO := "ETIQUETA DE IDENTIFICAÇÃO"

LOCAL _CPEDIDO := SPACE(TAMSX3("C5_NUM")[1])
LOCAL _CITEM := SPACE(TAMSX3("C6_ITEM")[1])
LOCAL _CSERIE := SPACE(TAMSX3("B1_SERIE")[1])
PUBLIC _CPEDIDO := ""
PUBLIC _CSERIE := ""

CHKFILE("ZA0")

_ODLG := MSDIALOG():NEW(0,0,185,280,_CTITULO,,, .F. ,128,,,,, .T. ,,, .F. )

TGROUP():NEW(2,2,70,140,,_ODLG,,, .T. ,)

TSAY():NEW(10,10,{||"PEDIDO"},_ODLG,,, .F. , .F. , .F. , .T. ,,,55,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(10,50,{ | U |IIF(PCOUNT()==0,_CPEDIDO,_CPEDIDO := U)},_ODLG,80,11,,,,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,"SC5","_CPEDIDO",,,,)

TSAY():NEW(30,10,{||"SEQ."},_ODLG,,, .F. , .F. , .F. , .T. ,,,55,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(30,50,{ | U |IIF(PCOUNT()==0,_CITEM,_CITEM := U)},_ODLG,80,11,,,,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,,"_CITEM",,,,)

TSAY():NEW(50,10,{||"NUM. SÉRIE"},_ODLG,,, .F. , .F. , .F. , .T. ,,,55,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(50,50,{ | U |IIF(PCOUNT()==0,_CSERIE,_CSERIE := U)},_ODLG,80,11,,,,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,,"_CSERIE",,,,)

SBUTTON():NEW(75,40,1,{||_NOPCA := 1, M10EMAIN(@_CPEDIDO,@_CITEM,@_CSERIE)},_ODLG, .T. ,,)
SBUTTON():NEW(75,80,2,{||_NOPCA := 2, _ODLG:END()},_ODLG, .T. ,,)

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EMAIN(_CPEDIDO,_CITEM,_CSERIE)
LOCAL _ADESCR := {}
LOCAL _CPROD := ""
LOCAL _CCLIENTE := ""
LOCAL _CFANTASIA := ""
LOCAL _CXITEMP := ""
LOCAL _CNUM := ""
LOCAL _CHORA := ""
LOCAL _LIMPOK :=  .F. 

BEGIN TRANSACTION

IF M10EVALOBR(@_CPEDIDO,@_CITEM,_CSERIE)

    M10EGETINF(_CPEDIDO,_CITEM,@_CPROD,@_ADESCR,@_CCLIENTE,@_CFANTASIA,@_CXITEMP,@_CSERIE,@_CNUM,@_CHORA)

    IF M10ECONFIR(_CPEDIDO,_CXITEMP,_CITEM,_CSERIE,_CPROD,_ADESCR,_CCLIENTE,_CFANTASIA)

        IF _LIMPOK := M10ESTATUS(_CPEDIDO,_CITEM,_CSERIE,_CHORA,_CPROD)

            M10EPRINT(_CPEDIDO,_CITEM,_CPROD,_ADESCR,_CCLIENTE,_CFANTASIA,_CXITEMP,_CSERIE,_CNUM,_CHORA)

            _CPEDIDO := SPACE(TAMSX3("C5_NUM")[1])
            _CITEM := SPACE(TAMSX3("C6_ITEM")[1])
            _CSERIE := SPACE(TAMSX3("B1_SERIE")[1])
        ENDIF
    ENDIF
ENDIF
END TRANSACTION
MSUNLOCKALL()

IF _LIMPOK
    MSGINFO("ETIQUETA IMPRESSA COM SUCESSO.",)
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EVALOBR(_CPEDIDO,_CITEM,_CSERIE)
LOCAL _LRET :=  .T. 

_CPEDIDO :=  STRZERO( VAL(_CPEDIDO),TAMSX3("C5_NUM")[1])
_CITEM :=  UPPER(IIF( LEN( ALLTRIM(_CITEM))<TAMSX3("C6_ITEM")[1], STRZERO( VAL(_CITEM),TAMSX3("C6_ITEM")[1]),_CITEM))

IF !(_LRET := !(EMPTY(_CPEDIDO)))
    MSGINFO("PEDIDO É OBRIGATÓRIO.",)
ENDIF

IF _LRET .AND. !(_LRET := !(EMPTY(_CITEM)))
    MSGINFO("SEQUENCIA É OBRIGATÓRIA.",)
ENDIF

IF _LRET .AND. !(_LRET := !(EMPTY(_CSERIE)))
    MSGINFO("NÚMERO DE SÉRIE É OBRIGATÓRIO.",)
ENDIF

IF _LRET
    SC5->(DBGOTOP())
    SC5->(DBSETORDER(1))

    IF _LRET := SC5->(DBSEEK(XFILIAL("SC5")+_CPEDIDO))
        SC6->(DBGOTOP())
        SC6->(DBSETORDER(1))

        IF !(_LRET := SC6->(DBSEEK(XFILIAL("SC6")+SC5->C5_NUM+_CITEM)))
            MSGINFO("PEDIDO E SEQUENCIA NÃO ENCONTRADOS.",)
        ENDIF
    ELSE 
        MSGINFO("PEDIDO NÃO ENCONTRADO.",)
    ENDIF
ENDIF

RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ECONFIR(_CPEDIDO,_CXITEMP,_CITEM,_CSERIE,_CPROD,_ADESCR,_CCLIENTE,_CFANTASIA)
LOCAL _LRET :=  .T. 
LOCAL _NX := 1
LOCAL _CDESCR := ""

FOR _NX := 1 TO  LEN(_ADESCR)
    _CDESCR += _ADESCR[_NX]
NEXT

_LRET := MSGYESNO("CONFIRMA IMPRESSÃO DA ETIQUETA ABAIXO?" + CRLF + CRLF+"PRODUTO.....: "+_CPROD+" - "+_CDESCR + CRLF + CRLF+"CLIENTE.....: "+_CCLIENTE + CRLF,)

RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ESTATUS(_CPEDIDO,_CITEM,_CSERIE,_CHORA,_CPROD)
LOCAL _LOK :=  .T. 
LOCAL _LREIMP :=  .F. 
LOCAL _NZA0RECNO := 0

_LOK := M10EGETREI(_CSERIE,_CPEDIDO,_CITEM,@_LREIMP,@_NZA0RECNO)

IF _LOK .AND. !(_LREIMP)
    _LOK := M10EVALREA(_CPEDIDO,_CITEM,_CSERIE,_CHORA)
ENDIF

IF _LOK
    M10ESETETA(IIF(_LREIMP,"I","A"),_CPEDIDO,_CITEM,_CSERIE,_CHORA,_CPROD,_NZA0RECNO)
ENDIF
RETURN _LOK

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EGETREI(_CSERIE,_CPEDIDO,_CITEM,_LREIMP,_NZA0RECNO)
LOCAL _LRET :=  .T. 
LOCAL _CALIAS := GETNEXTALIAS()
LOCAL _CREALOC := "S"

_NZA0RECNO := 0

_cQry := " SELECT ZA0.R_E_C_N_O_ AS ZA0_RECNO "
_cQry += " FROM "+RETSQLNAME("ZA0")+" ZA0 "
_cQry += " WHERE ZA0.D_E_L_E_T_= ' ' "
_cQry += "   AND ZA0_FILIAL = '"+XFILIAL("ZA0")+"' "
_cQry += "   AND ZA0_SERIE = "+___SQLGETVALUE(_CSERIE)+" "
_cQry += "   AND ZA0_REALOC <> "+___SQLGETVALUE(_CREALOC)+" "
_cQry += "   AND ZA0_PV = "+___SQLGETVALUE(_CPEDIDO)+" "
_cQry += "   AND ZA0_ITEMPV = "+___SQLGETVALUE(_CITEM)+" "
_cQry += " ORDER BY ZA0.R_E_C_N_O_ DESC "
__EXECSQL(_CALIAS,_cQry,{}, .F. )

IF !(_CALIAS)->(EOF())
    
    IF _LRET := MSGYESNO("ETIQUETA JÁ IMPRESSA PARA ESTE PEDIDO,SEQ. E SÉRIE." + CRLF+"DESEJA REIMPRIMIR?",)
        _LREIMP :=  .T. 
        _NZA0RECNO := _CALIAS->ZA0_RECNO
    ENDIF
ENDIF

(_CALIAS)->(DBCLOSEAREA())
RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EVALREA(_CPEDIDO,_CITEM,_CSERIE,_CHORA)
LOCAL _LRET :=  .T. 
LOCAL _NOPC := 0
LOCAL _ODLG := NIL
LOCAL _CTITLE := "CONFIRMAÇÃO DO NÚMERO DE SÉRIE"
LOCAL _AZA0 := {}
LOCAL _LREALOC := M10EGETZA0(_CSERIE,@_AZA0)
LOCAL _OETAPA := NIL
LOCAL _AETAPAS := {}
LOCAL _CETAPA := {}
LOCAL _NRECNO := 0
_CPEDIDO := SPACE(TAMSX3("C6_NUM")[1]+TAMSX3("C6_ITEM")[1])

IF _LREALOC
    _AETAPAS := _AZA0[1]
    _CETAPA := _AETAPAS[1]

    _ODLG := MSDIALOG():NEW(0,0,320,520,_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )
    TSAY():NEW(15,20,{||I18N("SÉRIE #1 JÁ IMPRESSA ANTERIORMENTE.",{ ALLTRIM(_CSERIE)})},_ODLG,,, .F. , .F. , .F. , .T. ,128,,,, .F. , .F. , .F. , .F. , .F. , .F. )

    TSAY():NEW(35,20,{||"INFORME AÇÃO DESEJADA:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )

    TSAY():NEW(45,30,{||"-> REALOCAR: ALTERA STATUS DA SÉRIE SELECIONADA PARA REALOCADA"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
    TSAY():NEW(55,30,{||"-> ALOCAR: ALTERA STATUS DESTA SÉRIE PARA EXPEDIÇÃO"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
    TSAY():NEW(65,30,{||"-> CANCELAR: CANCELA OPERAÇÃO"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )

    TSAY():NEW(85,20,{||"PEDIDO | SEQ | PRODUTO"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )

    _OETAPA := TCOMBOBOX():NEW(85,90,{|U|IIF(PCOUNT()>0,_CETAPA := U,_CETAPA)},_AETAPAS,150,20,_ODLG,,,,,, .T. ,,,,,,,,,"_CETAPA")

    TBUTTON():NEW(130,70,"REALOCAR",_ODLG,{||_NOPC := 1, _LRET :=  .F. , _ODLG:END()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )
    TBUTTON():NEW(130,115,"ALOCAR",_ODLG,{||_NOPC := 2, _LRET :=  .T. , _ODLG:END()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )
    TBUTTON():NEW(130,160,"CANCELAR",_ODLG,{||_LRET :=  .F. , _ODLG:END()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

    _ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)

    IF _NOPC==1
        
        IF EMPTY(_CETAPA)
            MSGINFO("PARA REALOCAÇÃO É OBRIGATÓRIO INFORMAR A SÉRIE A SER REALOCADA.",)
        ELSE 
            _NRECNO := _AZA0[2][ VAL( SUBSTR(_CETAPA,1,AT("-",_CETAPA)-1))+1]

            IF VALTYPE(_NRECNO)=="N"

                IF !(ZA0)->(EOF())
                    M10ESETETA("R",ZA0->ZA0_PV,ZA0->ZA0_ITEMPV,"",_CHORA,"",_NRECNO)
                    _LRET :=  .T. 
                ELSE 

                    MSGINFO("ERRO AO REALOCAR SÉRIE.",)
                ENDIF
            ELSE 

                MSGINFO("ERRO AO REALOCAR SÉRIE.",)
            ENDIF
        ENDIF
    ENDIF
ENDIF

RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EGETZA0(_CSERIE,_AZA0)

LOCAL _CALIAS := GETNEXTALIAS()
LOCAL _NNUM := 0
LOCAL _AAUX1 := {" "}
LOCAL _AAUX2 := {0}
LOCAL _CREALOC := "S"
LOCAL _LRET :=  .F. 
_CSERIE := PADR(_CSERIE,TAMSX3("ZA0_SERIE")[1],"")

_AZA0 := {}

_cQry := " SELECT ZA0_PV, "
_cQry += "        ZA0_ITEMPV, "
_cQry += "        ZA0_PROD, "
_cQry += "        ZA0.R_E_C_N_O_ AS ZA0_RECNO "
_cQry += " FROM "+RETSQLNAME("ZA0")+" ZA0 "
_cQry += " WHERE ZA0.D_E_L_E_T_= ' ' "
_cQry += "   AND ZA0_FILIAL = '"+XFILIAL("ZA0")+"' "
_cQry += "   AND ZA0_SERIE = "+___SQLGETVALUE(_CSERIE)+" "
_cQry += "   AND ZA0_REALOC <> "+___SQLGETVALUE(_CREALOC)+" "
_cQry += " ORDER BY ZA0_PV, "
_cQry += "          ZA0_ITEMPV, "
_cQry += "          ZA0_PROD "
__EXECSQL(_CALIAS,_cQry,{}, .F. )

IF !(_CALIAS)->(EOF())
    _LRET :=  .T. 

    WHILE !(_CALIAS)->(EOF())
    
        AADD(_AAUX1,CVALTOCHAR(++_NNUM)+" - PEDIDO: "+_CALIAS->ZA0_PV+" | SEQ.: "+_CALIAS->ZA0_ITEMPV+" | PRODUTO: "+_CALIAS->ZA0_PROD)
        AADD(_AAUX2,_CALIAS->ZA0_RECNO)

        (_CALIAS)->(DBSKIP())
        ENDDO

    AADD(_AZA0,ACLONE(_AAUX1))
    AADD(_AZA0,ACLONE(_AAUX2))
ENDIF

(_CALIAS)->(DBCLOSEAREA())
RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ESETETA(_CTIPO,_CPEDIDO,_CITEM,_CSERIE,_CHORA,_CPROD,_NRECNO)

(ZA0)->(DBGOTOP())
(ZA0)->(DBGOTO(_NRECNO))

DO CASE 
 CASE _CTIPO=="A"
RECLOCK("ZA0", .T. )
ZA0->ZA0_FILIAL := XFILIAL("ZA0")
ZA0->ZA0_PV := _CPEDIDO
ZA0->ZA0_ITEMPV := _CITEM
ZA0->ZA0_SERIE := _CSERIE
ZA0->ZA0_PROD := _CPROD
ZA0->ZA0_QTDIMP := 1
ZA0->ZA0_DATA := DDATABASE
ZA0->ZA0_HORA := _CHORA
ZA0->ZA0_USER :=  ALLTRIM(USRRETNAME(RETCODUSR()))
ZA0->ZA0_REALOC := "N"
(ZA0)->(MSUNLOCK())

M10ESETSC6(_CPEDIDO,_CITEM,"9")

CASE _CTIPO=="R"
RECLOCK("ZA0", .F. )
ZA0->ZA0_REALOC := "S"
ZA0->ZA0_USREAL :=  ALLTRIM(USRRETNAME(RETCODUSR()))
ZA0->ZA0_DTREAL := DDATABASE
ZA0->ZA0_HRREAL := _CHORA
(ZA0)->(MSUNLOCK())

M10ESETSC6(_CPEDIDO,_CITEM,"F",_CHORA)
CASE _CTIPO=="I"
RECLOCK("ZA0", .F. )
ZA0->ZA0_QTDIMP := ZA0->ZA0_QTDIMP+1
ZA0->ZA0_DATA := DDATABASE
ZA0->ZA0_HORA := _CHORA
ZA0->ZA0_USER :=  ALLTRIM(USRRETNAME(RETCODUSR()))
ZA0->ZA0_REALOC := "N"
(ZA0)->(MSUNLOCK())
ENDCASE
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ESETSC6(_CPEDIDO,_CITEM,_CETAPA,_CHORA)

_CHORA := IIF(VALTYPE(_CHORA)=="U","",_CHORA)

SC6->(DBGOTOP())
SC6->(DBSETORDER(1))

IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CITEM))
    RECLOCK("SC6", .F. )
    SC6->C6_XETAPA := _CETAPA

    IF _CETAPA=="F"
        SC6->C6_XREADT := DDATABASE
        SC6->C6_XREAHR := _CHORA
        SC6->C6_XREAUS :=  ALLTRIM(USRRETNAME(RETCODUSR()))
    ENDIF

    SC6->(MSUNLOCK())
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EPRINT(_CPEDIDO,_CITEM,_CPROD,_ADESCR,_CCLIENTE,_CFANTASIA,_CXITEMP,_CSERIE,_CNUM,_CHORA)
LOCAL _OPRINTER := NIL
LOCAL _NX := 0
LOCAL _NROW := 60
LOCAL _OFONTG1 := TFONT():NEW("ARIAL",,30, .T. , .T. )
LOCAL _OFONTG2 := TFONT():NEW("ARIAL",,28, .T. , .T. )
LOCAL _OFONTM1 := TFONT():NEW("ARIAL",,15, .T. , .T. )
LOCAL _OFONTP2 := TFONT():NEW("ARIAL",,13)
LOCAL _OFONTP1 := TFONT():NEW("ARIAL",,12)
LOCAL _NCOLINI := 40
LOCAL _NCOL02 := _NCOLINI+120
LOCAL _NCOL03 := _NCOL02+600
LOCAL _NCOL04 := _NCOL03+120
LOCAL _NNEXTLIN := 60
PRIVATE _NALIN := 10- LEN(_CXITEMP)

_OPRINTER := FWMSPRINTER():NEW("M10E001"+STRTRAN(TIME(),":",""),2, .T. ,, .T. ,,,,,,,,2)

_OPRINTER:SETRESOLUTION(78)
_OPRINTER:SETDEVICE(2)
_OPRINTER:STARTPAGE()

_OPRINTER:SAYBITMAP(_NROW-10,_NCOLINI+40,GETSRVPROFSTRING("STARTPATH","")+"M10E001.BMP",(60) * (3.5),(17) * (3.5))
_OPRINTER:SAY(_NROW+20,_NCOL03,"HOSHIZAKI MACOM LTDA",_OFONTP1)

_NROW += (_NNEXTLIN) * (1.7)

_OPRINTER:SAY(_NROW,_NCOLINI,"EQUIP.:",_OFONTP2)

FOR _NX := 1 TO 2
    _OPRINTER:SAY(_NROW,_NCOL02,_ADESCR[_NX],_OFONTM1)
    _NROW += _NNEXTLIN-10
NEXT

_NROW -= 10
_OPRINTER:LINE(_NROW,_NCOLINI,_NROW,_OPRINTER:NPAGEWIDTH,0,"-4")

_NROW += _NNEXTLIN-10

_OPRINTER:SAY(_NROW,_NCOLINI,"CÓD.:",_OFONTP2)
_OPRINTER:SAY(_NROW,_NCOL02,_CPROD,_OFONTM1)

_OPRINTER:SAY(_NROW,_NCOL03,"SÉRIE:",_OFONTP2)
_OPRINTER:SAY(_NROW,_NCOL04,IIF(EMPTY(_CSERIE),"***",_CSERIE),_OFONTM1)

_OPRINTER:FWMSBAR("CODE128",7.5,6,_CPROD,_OPRINTER, .F. ,,,,0.6,,,, .F. ,0.5,0.5,)

_NROW += (_NNEXTLIN) * (2.5)

_OPRINTER:SAY(_NROW,_NCOL03,"ITEM:",_OFONTP2)
_OPRINTER:SAY(_NROW,_NCOL04, ALLTRIM(_CXITEMP),_OFONTM1)

_NROW += (_NNEXTLIN) * (0.8)

_OPRINTER:SAY(_NROW,_NCOLINI,"PEDIDO:",_OFONTP2)
_OPRINTER:SAY(_NROW,_NCOL02,_CPEDIDO,_OFONTG1)

_OPRINTER:SAY(_NROW+5,_NCOL03,"SEQ:",_OFONTP2)
_OPRINTER:SAY(_NROW+5,_NCOL04,_CITEM,_OFONTM1)

_NROW += (_NNEXTLIN) * (0.8)

_NROW -= 10
_OPRINTER:LINE(_NROW,_NCOLINI,_NROW,_OPRINTER:NPAGEWIDTH,0,"-3")
_NROW += _NNEXTLIN-10

_OPRINTER:SAY(_NROW,_NCOLINI,"CLIENTE:",_OFONTP2)
_OPRINTER:SAY(_NROW,_NCOL02,_CCLIENTE,_OFONTM1)

_NROW += (_NNEXTLIN) * (0.75)
_OPRINTER:SAY(_NROW,_NCOL02,_CFANTASIA,_OFONTM1)

_NROW += (_NNEXTLIN) * (0.5)

_OPRINTER:SAY(_NROW+_NNEXTLIN,630,_CXITEMP,_OFONTG2)

_NROW += (_NNEXTLIN) * (0.3)

_OPRINTER:SAY(_NROW,_NCOL02+30,DTOC(DDATABASE)+" "+_CHORA,_OFONTP1)

_NROW += (_NNEXTLIN) * (0.8)
_OPRINTER:SAY(_NROW,_NCOLINI+25,_CNUM,_OFONTP1)

_OPRINTER:FWMSBAR("CODE128",17.5,1,_CNUM,_OPRINTER, .F. ,,,,0.7,,,, .F. ,0.5,0.5,)

_OPRINTER:SETDEVICE(2)
_OPRINTER:CPRINTER := "ZEBRA"

_OPRINTER:ENDPAGE()
_OPRINTER:PRINT()

FREEOBJ(_OPRINTER)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10EGETINF(_CPEDIDO,_CITEM,_CPROD,_ADESCR,_CCLIENTE,_CFANTASIA,_CXITEMP,_CSERIE,_CNUM,_CHORA)
LOCAL _CDESCR := ""
_CHORA := TIME()
_CCLIENTE := POSICIONE("SA1",1,XFILIAL("SA1")+(SC5)->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")
_CFANTASIA := POSICIONE("SA1",1,XFILIAL("SA1")+(SC5)->(C5_CLIENTE+C5_LOJACLI),"A1_NREDUZ")

_CXITEMP :=  SUBSTR( ALLTRIM(SC6->C6_XITEMP),1,10)
_CNUM :=  ALLTRIM(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM+_CSERIE)
_CPROD :=  ALLTRIM(SC6->C6_PRODUTO)
_CDESCR := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_DESC")
_ADESCR := M10ESEP(_CDESCR)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ESEP(_CVALOR)
LOCAL _ARET := {}
LOCAL _NX := 0
LOCAL _NQUANT := 0
LOCAL _NORIQT := 40
LOCAL _CLINHA := ""
LOCAL _LEMPTY :=  .T. 

WHILE _NX< LEN( ALLTRIM(_CVALOR))
 
    _NQUANT := _NORIQT

    WHILE  SUBSTR( ALLTRIM(_CVALOR),_NQUANT,1)<>" "
    
        _NQUANT--
        ENDDO

    _CLINHA :=  SUBSTR( ALLTRIM(_CVALOR),_NX,_NQUANT)

    AADD(_ARET,M10ENOCAR(_CLINHA))

    _LEMPTY :=  .F. 
    _NX += _NQUANT
    ENDDO

RETURN ACLONE(_ARET)

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M10ENOCAR(_CVAR)
_CVAR := STRTRAN(_CVAR,CHR(13)+CHR(10)," ")
_CVAR := STRTRAN(_CVAR,CHR(13)," ")
_CVAR := STRTRAN(_CVAR,CHR(10)," ")
_CVAR := STRTRAN(_CVAR,CHR(9)," ")
RETURN _CVAR

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05EMAIL(_CPEDIDO,_CITEM,_CPRODUTO,_CSERIE,_CDATA)
PRIVATE _CSERVER :=  ALLTRIM(GETMV("MV_RELSERV"))
PRIVATE _CACCOUNT :=  ALLTRIM(GETMV("MV_RELACNT"))
PRIVATE _CPASSWORD :=  ALLTRIM(GETMV("MV_RELPSW"))
PRIVATE _LAUTENTICA := GETMV("MV_RELAUTH")
PRIVATE _CCABEC := ""
PRIVATE _CTITULO := "PRODUTO REALOCADO. SÉRIE: "+_CSERIE
PRIVATE _CDE := "SCHEDULE@CYBERPOLOS.COM.BR"

CPARA := "FBALTHAZAR@MARCHON.COM.BR"
CCO := "GMAGALHAES@MARCHON.COM.BR;ALESSANDRO.TAKI@POLOSIT.COM.BR"
CASSUNTO := _CTITULO
CANEXO := ""

_CCABEC := "<HTML>"
_CCABEC += "<BODY>"
_CCABEC += '<P><FONT FACE="ARIAL" SIZE="2"><BR>'
_CCABEC += "PRODUTO REALOCADO ATRAVÉS DA IMPRESSÃO DE ETIQUETA (EXPEDIÇÃO)<BR></P><BR></P>"
_CCABEC += "FILIAL: "+XFILIAL("ZA0")+"<BR></P>"
_CCABEC += "PEDIDO: "+_CPEDIDO+"<BR></P>"
_CCABEC += "SEQ.: "+_CITEM+"<BR></P>"
_CCABEC += "PRODUTO: "+_CPRODUTO+"<BR></P>"
_CCABEC += "USUÁRIO: "+_CUSER+"<BR></P>"
_CCABEC += "DATA: "+_CDATA+"<BR></P>"
_CCABEC += "<BR><BR><BR>"
_CCABEC += "</BODY>"
_CCABEC += "</HTML>"

IF ( .F. ) 
 LOK := CALLPROC("MAILSMTPON",CSERVER,CACCOUNT,CPASSWORD,,,)
 ELSE
 LOK := MAILSMTPON(CSERVER,CACCOUNT,CPASSWORD,,,)
 ENDIF

IF LAUTENTICA
    
    IF !(MAILAUTH(CACCOUNT,CPASSWORD))
        
        IF ( .F. ) 
        CALLPROC("MAILSMTPOFF")
        ELSE
        MAILSMTPOFF()
        ENDIF
    ELSE 
        
        IF ( .F. ) 
        LENVIADO := CALLPROC("MAILSEND",_CACCOUNT,{_CPARA},{},{CCO},CASSUNTO,_CCABEC,{CANEXO}, .F. ,,)
        ELSE
        LENVIADO := MAILSEND(_CACCOUNT,{_CPARA},{},{CCO},CASSUNTO,_CCABEC,{CANEXO}, .F. ,,)
        ENDIF
        
        IF !(LENVIADO)
            CMENSAGEM := ""
            
            IF ( .F. ) 
            CMENSAGEM := CALLPROC("MAILGETERR")
            ELSE
            CMENSAGEM := MAILGETERR()
            ENDIF
            CONOUT(CMENSAGEM)
        ENDIF
        
        IF ( .F. ) 
        LDISCONECTOU := CALLPROC("MAILSMTPOFF")
        ELSE
        LDISCONECTOU := MAILSMTPOFF()
        ENDIF
    ENDIF
ENDIF
RETURN 
