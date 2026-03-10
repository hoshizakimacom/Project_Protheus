#INCLUDE "protheus.ch"
STATIC _CARQLOG := ""

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05D02U()
LOCAL _ASAYS := {}
LOCAL _ABUTTON := {}
LOCAL _CTITULO :=  SUBSTR(FUNNAME(),3,20)
PRIVATE _LSIMULACAO :=  .T. 

_LSIMULACAO := MSGYESNO("DESEJA EXECUTAR EM MODO SIMULAÇÃO?","ATENÇÃO")

IF _LSIMULACAO
    AADD(_ASAYS,OEMTOANSI("!!! SIMULAÇÃO !!! "))
ENDIF

AADD(_ASAYS,OEMTOANSI("ATUALIZAÇÃO DO GRUPO TRIBUTÁRIO DE ACORDO COM AS SEGUINTES REGRAS:"))
AADD(_ASAYS,OEMTOANSI(" REGRAS:"))
AADD(_ASAYS,OEMTOANSI(" - SE ORIGEM IGUAL A 1, ATUALIZAR UTILIZANDO YD_XGRIMP"))
AADD(_ASAYS,OEMTOANSI(" - SE ORIGEM IGUAL A 8 E TIPO PA, ATUALIZAR UTILIZANDO YD_XGRTRIB"))
AADD(_ASAYS,OEMTOANSI(" - SE ORIGEM IGUAL A 2,3 OU 8, ATUALIZAR UTILIZANDO YD_XGRREVE"))
AADD(_ASAYS,OEMTOANSI(" - DEMAIS ATUALIZAR UTILIZANDO YD_XGRTRIB"))

AADD(_ABUTTON,{1, .T. ,{||PROCESSA({||MD05OK()},"AGUARDE...","", .F. ),FECHABATCH()}})
AADD(_ABUTTON,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(_CTITULO,_ASAYS,_ABUTTON)

_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05OK()
LOCAL _ODLG := NIL
LOCAL _CTITLE := "ATUALIZAÇÃO DE GRUPO TRIBUTÁRIO"
LOCAL _OARQLOG := NIL
PRIVATE _OARQORI := NIL

IF _LSIMULACAO
    _CTITLE += OEMTOANSI(" *** SIMULAÇÃO *** ")
ENDIF

_ODLG := MSDIALOG():NEW(0,0,300,900,_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )

TSAY():NEW(40,20,{||"ARQUIVO LOG:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OARQLOG := TGET():NEW(37,80,{ | U |IIF(PCOUNT()==0,_CARQLOG,_CARQLOG := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CARQLOG",,,)

TBUTTON():NEW(37,400,"SELEC. ARQUIVO",_ODLG,{||MD05ARQLOG()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(120,170,"CONFIRMAR",_ODLG,{||MD05CONF()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(120,220,"CANCELAR",_ODLG,{||_ODLG:END()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)

_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05CONF()
LOCAL _CALIAS := GETNEXTALIAS()
LOCAL _NREG := 0
LOCAL _NREGALT := 0

LOCAL _CLOG := ""
LOCAL _CMSG := "TOTAL DE PRODUTOS ALTERADOS: #1 ." + CRLF
LOCAL _NHANDLE := 0
LOCAL _CGRTRIB := ""

PRIVATE _NTOTAL := 0

IF !(EMPTY(_CARQLOG))

_cQry := " SELECT B1_COD, "
_cQry += "        B1_ORIGEM, "
_cQry += "        B1_GRTRIB, "
_cQry += "        SB1.R_E_C_N_O_ AS B1_RECNO, "
_cQry += "        B1_POSIPI, "
_cQry += "        B1_EX_NCM, "
_cQry += "        B1_TIPO, "
_cQry += "        YD_XGRREVE, "
_cQry += "        YD_TEC, "
_cQry += "        YD_XGRTRIB, "
_cQry += "        YD_XGRIMP, "
_cQry += "        YD_PER_IPI "
_cQry += " FROM "+RETSQLNAME("SB1")+" SB1 "
_cQry += " INNER JOIN "+RETSQLNAME("SYD")+" SYD ON SYD.D_E_L_E_T_= ' ' "
_cQry += " AND YD_FILIAL = '"+XFILIAL("SYD")+"' "
_cQry += " AND B1_POSIPI = YD_TEC "
_cQry += " AND B1_EX_NCM = YD_EX_NCM "
_cQry += " WHERE SB1.D_E_L_E_T_= ' ' "
_cQry += "   AND B1_FILIAL = '"+XFILIAL("SB1")+"' "
_cQry += "   AND B1_ORIGEM <> '' "
_cQry += " ORDER BY B1_COD "
__EXECSQL(_CALIAS,_cQry,{}, .F. )

    _NTOTAL := 0
    DBEVAL({||_NTOTAL := _NTOTAL+1}, .F. )
    PROCREGUA(_NTOTAL)

    (_CALIAS)->(DBGOTOP())

    IF !(_CALIAS)->(EOF())
        WHILE !(_CALIAS)->(EOF())
        
            INCPROC("ATUALIZANDO PRODUTO "+CVALTOCHAR(++_NREG)+" DE "+CVALTOCHAR(_NTOTAL)+".")

            SB1->(DBGOTO(_CALIAS->B1_RECNO))

            IF !SB1->(EOF())

                DO CASE 
                CASE _CALIAS->B1_ORIGEM=="1"
                _CGRTRIB := _CALIAS->YD_XGRIMP

                CASE _CALIAS->B1_ORIGEM=="8" .AND. _CALIAS->B1_TIPO=="PA"
                _CGRTRIB := _CALIAS->YD_XGRTRIB

                CASE (_CALIAS->B1_ORIGEM) $ ("2|3|8")
                _CGRTRIB := _CALIAS->YD_XGRREVE
                OTHERWISE

                _CGRTRIB := _CALIAS->YD_XGRTRIB
                ENDCASE

                IF  ALLTRIM(_CALIAS->B1_GRTRIB)<> ALLTRIM(_CGRTRIB)
                    _NREGALT++
                    
                    IF !(_LSIMULACAO)
                        RECLOCK("SB1", .F. )
                        SB1->B1_GRTRIB := _CGRTRIB
                        SB1->(MSUNLOCK())
                    ENDIF

                    _CLOG += "PRODUTO: "+SB1->B1_COD+" TIPO: "+SB1->B1_TIPO+" ORIGEM: "+SB1->B1_ORIGEM+" NCM: "+_CALIAS->B1_POSIPI+" EX NCM: "+_CALIAS->B1_EX_NCM+" GRP. TRIB.: "+_CALIAS->B1_GRTRIB+" GRP. TRIB. NOVO: "+_CGRTRIB + CRLF
                ENDIF
            ENDIF

            (_CALIAS)->(DBSKIP())
            ENDDO

        _NHANDLE := FCREATE(_CARQLOG)

        IF _NHANDLE=- (1)
            _CMSG += " ERRO AO CRIAR ARQUIVO - FERROR "+STR(FERROR())
        ELSE 
            _CMSG += " VERIFIQUE ARQUIVO DE LOG GERADO: " + CRLF+"#2 " + CRLF
            FWRITE(_NHANDLE,_CLOG)
            FCLOSE(_NHANDLE)
        ENDIF
    ENDIF

    AVISO("ATENÇÃO",I18N(_CMSG,{_NREGALT,_CARQLOG}),{"OK"},3)
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05ARQLOG()
LOCAL _CARQ := CGETFILE("*.TXT","INFORME DIRETORIO PARA ARQUIVO DE LOG",0,"", .F. ,NOR(48,8,128), .F. , .T. )

_CARQLOG := _CARQ+DTOS(DATE())+"_"+STRTRAN(TIME(),":","")+".TXT"
RETURN 
