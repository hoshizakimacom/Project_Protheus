#INCLUDE "protheus.ch"
STATIC _CPEDIDO := "", _CXITEMP := "", _COBSENG := "", _COBSCOM := "", _CETAPA := "", _CCLIENTE := "", _CITEM := "", _NQTDVEN := 0, _CETAPAATU := "", _NRECSC5 := 0, _CITEMATE := "  "

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A21()
LOCAL _ODLG := NIL
LOCAL _CTITLE := "APONTAMENTO TEC. COMERCIAL."
LOCAL _OETAPA := NIL
LOCAL _OETAPAATU := NIL
LOCAL _AETAPAS := {"","B - MEDIÇÃO","C - AG. APROV. ","D - A FAZER","E - TEC COM LIB"}
LOCAL _OOBSENG := NIL
LOCAL _OPEDIDO := NIL
LOCAL _OITEM := NIL
LOCAL _OITEMATE := NIL
LOCAL _OXITEMP := NIL
LOCAL _OQTDVEN := NIL
LOCAL _OCLIENTE := NIL
LOCAL _BCONF := {||M05AGETOBS()}
LOCAL _OSCR1 := NIL
LOCAL _ASIZE := FWGETDIALOGSIZE(OMAINWND)
PRIVATE _NRADIO := 0
PRIVATE CUSULIMP := GETMV("AM_LIMAPT",,"")
PRIVATE CUSUESTORN := GETMV("AM_ESTLIB",,"")
PRIVATE CUSERLIB := RETCODUSR()

MA05CLRVAR( .T. )

_ODLG := MSDIALOG():NEW(_ASIZE[1],_ASIZE[2],_ASIZE[3],_ASIZE[4],_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )
TSAY():NEW(15,20,{||"PEDIDO:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OPEDIDO := TGET():NEW(12,90,{ | U |IIF(PCOUNT()==0,_CPEDIDO,_CPEDIDO := U)},_ODLG,100,11,,{||(EMPTY(_CPEDIDO)) .OR. (EXISTCPO("SC5",_CPEDIDO))},,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,,"_CPEDIDO",,,)

_OPEDIDO:BLOSTFOCUS := _BCONF

TSAY():NEW(32,20,{||"SEQUÊNCIA:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OITEM := TGET():NEW(29,90,{ | U |IIF(PCOUNT()==0,_CITEM,_CITEM := U)},_ODLG,50,10,,{||(EMPTY(_CITEM)) .OR. ((EMPTY(_CPEDIDO)) .OR. (EXISTCPO("SC6",_CPEDIDO+_CITEM)))},,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,,"_CITEM",,,)

TSAY():NEW(32,160,{||"ATÉ:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OITEMATE := TGET():NEW(29,200,{ | U |IIF(PCOUNT()==0,_CITEMATE,_CITEMATE := U)},_ODLG,50,10,,{||(EMPTY(_CITEMATE)) .OR. ((EMPTY(_CPEDIDO)) .OR. (EXISTCPO("SC6",_CPEDIDO+_CITEMATE)))},,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,,"_CITEMATE",,,)

_OITEM:BLOSTFOCUS := _BCONF

TSAY():NEW(45,20,{||"ETAPA:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OETAPA := TCOMBOBOX():NEW(45,90,{|U|IIF(PCOUNT()>0,_CETAPA := U,_CETAPA)},_AETAPAS,100,40,_ODLG,,,,,, .T. ,,,,,,,,,"_CETAPA")

TSAY():NEW(75,20,{||"ETAPA ATUAL:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OETAPAATU := TGET():NEW(72,90,{ | U |IIF(PCOUNT()==0,_CETAPAATU,_CETAPAATU := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CETAPAATU",,,)

TSAY():NEW(90,20,{||"CLIENTE:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OCLIENTE := TGET():NEW(87,90,{ | U |IIF(PCOUNT()==0,_CCLIENTE,_CCLIENTE := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CCLIENTE",,,)

TSAY():NEW(105,20,{||"ITEM:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OXITEMP := TGET():NEW(102,90,{ | U |IIF(PCOUNT()==0,_CXITEMP,_CXITEMP := U)},_ODLG,100,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CXITEMP",,,)

TSAY():NEW(120,20,{||"QUANTIDADE"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OQTDVEN := TGET():NEW(117,90,{ | U |IIF(PCOUNT()==0,TRANSFORM(_NQTDVEN,"@E 999,999.9999"),TRANSFORM(_NQTDVEN,"@E 999,999.9999") := U)},_ODLG,100,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,'TRANSFORM(_NQTDVEN,"@E 999,999.9999")',,,)

TSAY():NEW(140,20,{||"DESCR. PEDIDO:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OSCR1 := TSCROLLBOX():NEW(_ODLG,140,90,60,300, .T. , .T. , .T. )
TSAY():NEW(5,5,{||_COBSCOM},_OSCR1,,, .F. , .F. , .F. , .T. ,,,280,60, .F. , .F. , .F. , .F. , .F. , .F. )

TSAY():NEW(210,20,{||"OBS. ENGENHARIA:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OOBSENG := TMULTIGET():NEW(210,90,{ | U |IIF(PCOUNT()==0,_COBSENG,_COBSENG := U)},_ODLG,300,60,, .F. ,,,, .T. ,, .F. ,, .F. , .F. , .F. ,,, .F. ,,)

TBUTTON():NEW(15,550,"CONFIRMAR",_ODLG,{||IIF(!(EMPTY(_CPEDIDO)),M05AOK(),)},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(35,550,"CANCELAR",_ODLG,{||_ODLG:END()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(55,550,"ANEXAR",_ODLG,{||MA05ANEXAR()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(75,550,"VIS. ANEXO",_ODLG,{||M05AVISANE()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(95,550,"ESTORNAR/LIMPAR APONTAMENTO",_ODLG,{||M05AEST(_CPEDIDO,_CITEM)},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MA05ANEXAR()
LOCAL _CMASCARA := "TODOS OS ARQUIVOS|*.*"
LOCAL _CTITULO := "ESCOLHA O ARQUIVO"
LOCAL _NMASCPAD := 0
LOCAL _CDIRORI := "C:\"
LOCAL _CDIRDES :=  ALLTRIM(GETMV("AM_05A21_A", .T. ,""))
LOCAL _LSALVAR :=  .F. 
LOCAL _NOPCOES := 48
LOCAL _LARVORE :=  .F. 
LOCAL _LOK :=  .F. 
PRIVATE _AARQUIVO := {}

IF !(EMPTY(_CPEDIDO)) .AND. !(EMPTY(_CITEM))
    SC6->(DBSETORDER(1))
    SC6->(DBGOTOP())

    IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CITEM))
        
        IF EMPTY(_CDIRDES)
            MSGINFO(I18N("É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A21_A."),)
        ELSE 
            _CDIRDES +=  ALLTRIM(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)+"\"
            _CDIRORI := CGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,_LARVORE)

            IF !(EMPTY(_CDIRORI))
                _AFILES := DIRECTORY(_CDIRORI,"D")

                IF !(_LOK := !(FILE(_CDIRDES+_AFILES[1][1])))
                    
                    IF MSGYESNO("ARQUIVO JÁ ANEXADO PARA ESTA SEQUÊNCIA DO PEDIDO DE VENDA." + CRLF+"DESEJA ATUALIZAR?",)
                        
                        IF !(_LOK := FERASE(_CDIRDES+_AFILES[1][1])<>- (1))
                            MSGINFO("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),)
                        ENDIF
                    ENDIF
                ENDIF

                IF _LOK
                    MAKEDIR(_CDIRDES)
                    __COPYFILE(_CDIRORI,_CDIRDES+_AFILES[1][1])

                    IF FILE(_CDIRDES+_AFILES[1][1])
                        MSGINFO("ARQUIVO ANEXADO COM SUCESSO!",)
                    ELSE 
                        MSGINFO("ERRO AO ANEXAR ARQUIVO.",)
                    ENDIF
                ENDIF
            ELSE 
                MSGINFO("ARQUIVO NÃO INFORMADO!",)
            ENDIF
        ENDIF
    ELSE 

        MSGINFO(I18N("PEDIDO #1 E SEQUÊNCIA #2 NÃO LOCALIZADOS PARA ANEXAR ARQUIVO.",{_CPEDIDO,_CITEM}),)
    ENDIF
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AVISANE()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_05A21_A", .T. ,""))

IF !(EMPTY(_CPEDIDO)) .AND. !(EMPTY(_CITEM))
    SC6->(DBSETORDER(1))
    SC6->(DBGOTOP())

    IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CITEM))
        
        IF EMPTY(_CDIR)
            MSGINFO("É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A21_A.",)
        ELSE 
            _CDIR +=  ALLTRIM(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)+"\"

            IF EXISTDIR(_CDIR)
                WINEXEC("EXPLORER.EXE "+_CDIR)
            ELSE 
                MSGINFO(I18N("NÃO FORAM ENCONTRADOS ANEXOS PARA O PEDIDO #1 E SEQUENCIA #2 .",{_CPEDIDO,_CITEM}),)
            ENDIF
        ENDIF
    ELSE 
        MSGINFO(I18N("PEDIDO #1 E SEQUÊNCIA #2 NÃO LOCALIZADOS PARA ANEXAR ARQUIVO.",{_CPEDIDO,_CITEM}),)
    ENDIF
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AGETOBS()

IF !(EMPTY(_CPEDIDO))
    SC5->(DBSETORDER(1))
    SC5->(DBGOTOP())

    IF SC5->(DBSEEK(XFILIAL("SC5")+_CPEDIDO))
        _CCLIENTE :=  ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"))
        _NRECSC5 := SC5->(RECNO())

        IF !(SC5->(DBRLOCK(_NRECSC5)))
            MSGSTOP(I18N("PEDIDO #1 NÃO PODE SER ALTERADO POIS ENCONTRA-SE EM MANUTENÇÃO POR OUTRO USUÁRIO.",{_CPEDIDO}),)
            MA05CLRVAR( .T. )
        ENDIF
    ELSE 
        MSGSTOP(I18N("PEDIDO #1 NÃO LOCALIZADO.",{_CPEDIDO}),)
        MA05CLRVAR( .T. )
    ENDIF
ELSE 
    MA05CLRVAR( .T. )
ENDIF

IF !(EMPTY(_CITEM))
    
    IF !(EMPTY(_CPEDIDO))
        SC6->(DBSETORDER(1))
        SC6->(DBGOTOP())

        IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CITEM))
            _COBSENG := SC6->C6_XOBSENG
            _COBSCOM := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_DESC")

            _CXITEMP := SC6->C6_XITEMP
            _NQTDVEN := SC6->C6_QTDVEN
            _CETAPAATU := MA05GETET()
        ELSE 
            MSGSTOP(I18N("PEDIDO #1 E SEQUENCIA #2 NÃO LOCALIZADOS.",{_CPEDIDO,_CITEM}),)
            MA05CLRVAR( .F. )
        ENDIF
    ENDIF
ELSE 
    MA05CLRVAR( .F. )
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MA05GETET()
LOCAL _CRET := ""

_CRET := POSICIONE("ZA3",1,XFILIAL("ZA3")+SC6->C6_XETAPA,"ZA3_DESCRI")

RETURN _CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AOK()
LOCAL _CXETAPA := ""
LOCAL _CCPDATA := ""
LOCAL _CCPHORA := ""
LOCAL _CCPUSER := ""
LOCAL NITEMDE := 0
LOCAL NITEMATE := 0
LOCAL NIX := 0
LOCAL CITEM := ""

IF M05AVALID()
    SC6->(DBGOTOP())
    SC6->(DBSETORDER(1))

    IF !(EMPTY(_CITEM)) .AND. !(EMPTY(_CITEMATE))

        NITEMDE :=  VAL(_CITEM)
        NITEMATE :=  VAL(_CITEMATE)
        cUserLogado := USRRETNAME(RETCODUSR())
        FOR NIX := NITEMDE TO NITEMATE 

            CITEM :=  STRZERO(NIX,2)

            IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+CITEM))

                DO CASE 
                CASE  SUBSTR(_CETAPA,1,1)=="B"
                _CXETAPA := "B"
                _CCPDATA := "C6_XMEDDT"
                _CCPHORA := "C6_XMEDHR"
                _CCPUSER := "C6_XMEDUS"
                
                CASE  SUBSTR(_CETAPA,1,1)=="C"
                _CXETAPA := "C"
                _CCPDATA := "C6_XAINDT"
                _CCPHORA := "C6_XAINHR"
                _CCPUSER := "C6_XAINUS"
                
                CASE  SUBSTR(_CETAPA,1,1)=="D"
                _CXETAPA := "D"
                _CCPDATA := "C6_XCANDT"
                _CCPHORA := "C6_XCANHR"
                _CCPUSER := "C6_XCANUS"
                
                CASE  SUBSTR(_CETAPA,1,1)=="E"
                _CXETAPA := "E"
                _CCPDATA := "C6_XGOPDT"
                _CCPHORA := "C6_XGOPHR"
                _CCPUSER := "C6_XGOPUS"
                ENDCASE

                IF !(EMPTY(_CETAPA))
                    RECLOCK("SC6", .F. )
                    SC6->C6_XETAPA := _CXETAPA
                    SC6->(&(_CCPDATA)) := DDATABASE
                    SC6->(&(_CCPHORA)) := TIME()
                    SC6->(&(_CCPUSER)) :=  UPPER(cUserLogado)
                    SC6->C6_XOBSENG := _COBSENG
                    SC6->(MSUNLOCK())

                    MSGINFO("ETAPA APONTADA COM SUCESSO!","OK")

                    MA05CLRVAR( .F. )
                ENDIF
            ELSE 

                MSGSTOP(I18N("PEDIDO #1 E SEQUENCIA #2 NÃO LOCALIZADOS.",{_CPEDIDO,CITEM}),)
            ENDIF
        NEXT

    ELSEIF !(EMPTY(_CITEM))

        IF SC6->(DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CITEM))

            DO CASE 
            CASE  SUBSTR(_CETAPA,1,1)=="B"
            _CXETAPA := "B"
            _CCPDATA := "C6_XMEDDT"
            _CCPHORA := "C6_XMEDHR"
            _CCPUSER := "C6_XMEDUS"
            
            CASE  SUBSTR(_CETAPA,1,1)=="C"
            _CXETAPA := "C"
            _CCPDATA := "C6_XAINDT"
 _CCPHORA := "C6_XAINHR"
            _CCPUSER := "C6_XAINUS"
            
            CASE  SUBSTR(_CETAPA,1,1)=="D"
            _CXETAPA := "D"
            _CCPDATA := "C6_XCANDT"
            _CCPHORA := "C6_XCANHR"
            _CCPUSER := "C6_XCANUS"
            
            CASE  SUBSTR(_CETAPA,1,1)=="E"
            _CXETAPA := "E"
            _CCPDATA := "C6_XGOPDT"
            _CCPHORA := "C6_XGOPHR"
            _CCPUSER := "C6_XGOPUS"
            ENDCASE

            IF !(EMPTY(_CETAPA))
                RECLOCK("SC6", .F. )
                SC6->C6_XETAPA := _CXETAPA
                SC6->(&(_CCPDATA)) := DDATABASE
                SC6->(&(_CCPHORA)) := TIME()
                SC6->(&(_CCPUSER)) :=  UPPER(USRRETNAME(RETCODUSR()))
                SC6->C6_XOBSENG := _COBSENG
                SC6->(MSUNLOCK())

                MSGINFO("ETAPA APONTADA COM SUCESSO!","OK")

                MA05CLRVAR( .F. )
ENDIF
        ELSE 

            MSGSTOP(I18N("PEDIDO #1 E SEQUENCIA #2 NÃO LOCALIZADOS.",{_CPEDIDO,_CITEM}),)
        ENDIF
    ENDIF
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MA05CLRVAR(_LPV)
_LPV := IIF(_LPV==NIL, .T. ,_LPV)

IF _LPV
    _CPEDIDO := SPACE(TAMSX3("C6_NUM")[1])
    _CETAPA := ""
    _CCLIENTE := ""

    IF _NRECSC5>0
        SC5->(DBRUNLOCK(_NRECSC5))
    ENDIF

    _NRECSC5 := 0
ENDIF

_CITEM := SPACE(TAMSX3("C6_ITEM")[1])
_CITEMATE := SPACE(TAMSX3("C6_ITEM")[1])
_COBSENG := ""
_COBSCOM := ""
_CXITEMP := ""
_NQTDVEN := ""
_CETAPAATU := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AVALID()
LOCAL _LRET :=  .F. 
LOCAL _CATUDES := ""
PRIVATE _CPEDCANCEL :=  ALLTRIM(GETMV("AM_05A21_B", .T. ,""))

IF !(_LRET := !(EMPTY(_CPEDIDO)) .AND. !(EMPTY(_CITEM)) .AND. !(EMPTY(_CETAPA)))
    MSGINFO("É OBRIGATÓRIO INFORMAR PEDIDO, SEQUÊNCIA E ETAPA." + CRLF+"VERIFIQUE.",)
ENDIF

IF _LRET
    _LRET := U_M05A22( SUBSTR(_CETAPA,1,1),_CPEDIDO,_CITEM,@_CATUDES)

    IF !(_LRET)
        MSGINFO(I18N("APONTAMENTO NÃO PERMITIDO." + CRLF + CRLF+"MOTIVO: ITEM JÁ SE ENCONTRA NA ETAPA #1 .",{ ALLTRIM(_CATUDES)}),)
    ENDIF
ENDIF

RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AEST(_CPEDIDO,_CITEM)
LOCAL KX1 := 0
_NOPC := 0
CUSERLIB :=  ALLTRIM(RETCODUSR())

NTAM1 :=  LEN(CUSULIMP)
CTEXTO := ""
NNUMX1 := 0
CATUALI1 := "N"
FOR KX1 := 1 TO NTAM1 
    NNUMX1 := IIF(KX1<2,NNUMX1+1,NNUMX1+7)
    CTEXTO :=  SUBSTR(CUSULIMP,NNUMX1,6)
    
    IF  SUBSTR(CUSERLIB,1,6)= SUBSTR(CTEXTO,1,6)
        CATUALI1 := "S"
        EXIT 
    ENDIF
NEXT

IF CATUALI1=="S"
    M05AST2()
    RETURN 
ENDIF

DBSELECTAREA("SC2")
DBSETORDER(1)
IF ( ALLTRIM(CUSERLIB)) $ (CUSUESTORN)
    
    IF SC2->(MSSEEK(XFILIAL("SC2")+_CPEDIDO+_CITEM))
        MSGSTOP("PARA O PEDIDO : "+_CPEDIDO+" E ITEM: "+_CITEM+", JÁ EXITE ORDEM DE PRODUÇÃO" + CRLF+"FAVOR SOLICITAR AO PCP, QUE EXCLUA A OP, E TENTAR NOVAMENTE","ATENÇÃO")
    ELSE 
        
        DO CASE 
            CASE EMPTY(_CPEDIDO)
                MSGALERT("INFORME O NUMERO DO PEDIDO!","ATENÇÃO !!")
            
            CASE EMPTY(_CITEM)
                MSGALERT("INFORME O ITEM DO PEDIDO!","ATENÇÃO !!")
    
            CASE EMPTY(_CETAPA) .AND.  ALLTRIM( UPPER(_CETAPAATU))== ALLTRIM("TEC COM LIB")
                RECLOCK("SC6", .F. )
                SC6->C6_XETAPA := " "
                SC6->C6_XMEDDT := DDATABASE
                SC6->C6_XMEDHR := TIME()
                SC6->C6_XMEDUS :=  UPPER(USRRETNAME(RETCODUSR()))
                SC6->C6_XGOPDT := CTOD("")
                SC6->(MSUNLOCK())
                _CETAPAATU := " "
                
                MSGINFO("ESTORNO EFETUADO COM SUCESSO !","SUCESSO")
            
            CASE _CETAPAATU<>"TEC COM LIB "
                MSGALERT("SÓ É POSSÍVEL EFETUAR O ESTORNO DA ETAPA (TEC.COM.LIB.)","ATENÇÃO!")
        ENDCASE
    ENDIF
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05AST2()
IF ( ALLTRIM(CUSERLIB)) $ (CUSULIMP)
    
    IF !(EMPTY(_CITEM)) .AND. !(EMPTY(_CPEDIDO))
        
        IF SC2->(MSSEEK(XFILIAL("SC2")+_CPEDIDO+_CITEM))
            MSGSTOP("PARA O PEDIDO : "+_CPEDIDO+" E ITEM: "+_CITEM+", JÁ EXITE ORDEM DE PRODUÇÃO" + CRLF+"FAVOR SOLICITAR AO PCP, QUE EXCLUA A OP, E TENTAR NOVAMENTE","ATENÇÃO")
        ELSE 
            
            IF RECLOCK("SC6", .F. )
                SC6->C6_XETAPA := " "
                SC6->C6_XMEDDT := DDATABASE
                SC6->C6_XMEDHR := TIME()
                SC6->C6_XMEDUS :=  UPPER(USRRETNAME(RETCODUSR()))
                SC6->C6_XGOPDT := CTOD("")
                SC6->(MSUNLOCK())
            ENDIF
            
            MSGINFO("ESTORNO EFETUADO COM SUCESSO !","SUCESSO")
        ENDIF
    ELSE 
        
        IF EMPTY(_CITEM)
            
            MSGALERT("INFORME O ITEM DO PEDIDO!","ATENÇÃO !!")
        ELSE 
            
            IF EMPTY(_CPEDIDO)
                
                MSGALERT("INFORME O NUMERO DO PEDIDO!","ATENÇÃO !!")
            ENDIF
        ENDIF
    ENDIF
ENDIF

RETURN 
