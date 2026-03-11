#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M09A010()
LOCAL _ASAYS := {}
LOCAL _ABUTTON := {}
LOCAL _CTITULO :=  SUBSTR(FUNNAME(),3,20)
PRIVATE _LSIMULACAO :=  .T. 

_LSIMULACAO := IIF(FINDFUNCTION("MSGINFO"),MSGINFO("DESEJA EXECUTAR EM MODO SIMULA플O?",),(CMSGYESNO := "MSGYESNO", &CMSGYESNO.("DESEJA EXECUTAR EM MODO SIMULA플O?",)))

IF _LSIMULACAO
    AADD(_ASAYS,OEMTOANSI("!!! SIMULA플O !!! "))
ENDIF

AADD(_ASAYS,OEMTOANSI("PROCESSAR TODOS OS PRODUTOS DE ACORDO COM O POSIPI E EX_NCM: "))
AADD(_ASAYS,OEMTOANSI(" - ACERTAR INFORMA플O DE GRUPO DE TRIBUTACAO (B1_GRTRIB)"))
AADD(_ASAYS,OEMTOANSI(" REGRAS:"))
AADD(_ASAYS,OEMTOANSI(" - SE ORIGEM IGUAL A 1, ATUALIZAR UTILIZANDO YD_GRPIMP"))
AADD(_ASAYS,OEMTOANSI(" - SE ORIGEM IGUAL A 2,3 OU 8, ATUALIZAR UTILIZANDO YD_GRPREVE"))
AADD(_ASAYS,OEMTOANSI(" - DEMAIS ATUALIZAR UTILIZANDO YD_GRPTRIB"))

AADD(_ABUTTON,{1, .T. ,{||PROCESSA({||M09010PROC()},"AGUARDE...","", .F. ),FECHABATCH()}})
AADD(_ABUTTON,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(_CTITULO,_ASAYS,_ABUTTON)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M09010PROC()

LOCAL _CALIAS := GETNEXTALIAS()
LOCAL _NREG := 0
LOCAL _NREGALT := 0

LOCAL _CLOG := ""
LOCAL _CARQ := CGETFILE("*.TXT","INFORME DIRETORIO",0,"", .T. ,NOR(48,8,128), .F. , .T. )

LOCAL _CMSG := "TOTAL DE PRODUTOS ALTERADOS: #1 ." + CRLF
LOCAL _NHANDLE := 0
LOCAL _CGRTRIB := ""

PRIVATE _NTOTAL := 0

IF !(EMPTY(_CARQ))
    _CARQ += STRTRAN(TIME(),":","")+".TXT"
    
_cQry := " SELECT B1_COD, "
_cQry += "        B1_ORIGEM, "
_cQry += "        B1_GRTRIB, "
_cQry += "        SB1.R_E_C_N_O_ AS B1_RECNO, "
_cQry += "        B1_POSIPI, "
_cQry += "        B1_EX_NCM, "
_cQry += "        B1_TIPO, "
_cQry += "        YD_TEC, "
_cQry += "        YD_XGRTRIB, "
_cQry += "        YD_XGRIMP, "
_cQry += "        YD_PER_IPI, "
_cQry += "        YD_XGRREVE "
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
        
        _NHANDLE := FCREATE(_CARQ)
        
        WHILE !(_CALIAS)->(EOF())
        
            INCPROC("ATUALIZANDO PRODUTO "+CVALTOCHAR(++_NREG)+" DE "+CVALTOCHAR(_NTOTAL)+".")
            _CLOG := ""
            SB1->(DBGOTO(_CALIAS->B1_RECNO))
            
            IF !SB1->(EOF())
                
                DO CASE 
                CASE _CALIAS->B1_ORIGEM=="1"
                _CGRTRIB := _CALIAS->YD_XGRIMP
                
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
                    FWRITE(_NHANDLE,_CLOG)
                ENDIF
            ENDIF
            (_CALIAS)->(DBSKIP())
            ENDDO
        
        IF _NHANDLE=- (1)
            _CMSG += " ERRO AO CRIAR ARQUIVO - FERROR "+STR(FERROR())
        ELSE 
            _CMSG += " VERIFIQUE ARQUIVO DE LOG GERADO: " + CRLF+"#2 " + CRLF
            
            FCLOSE(_NHANDLE)
        ENDIF
    ENDIF
    AVISO("ATEN플O",I18N(_CMSG,{_NREGALT,_CARQ}),{"OK"},3)
ENDIF
RETURN 
