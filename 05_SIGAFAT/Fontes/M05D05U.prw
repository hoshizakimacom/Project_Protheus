#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05D05U()
LOCAL _ASAYS := {}
LOCAL _ABUTTON := {}
LOCAL _CTITULO := FUNNAME()

LOCAL LSIMULACAO := MSGYESNO("DESEJA EXECUTAR EM MODO SIMULAÇÃO?","ATENÇÃO")
LOCAL _CARQLOG := ""

IF LSIMULACAO
    AADD(_ASAYS,OEMTOANSI("*** SIMULAÇÃO *** "))
ENDIF

AADD(_ASAYS,OEMTOANSI("ROTINA DE AJUSTE DE REGIÃO DE CLIENTES"))

AADD(_ABUTTON,{1, .T. ,{||MD05PROC(LSIMULACAO,@_CARQLOG),FECHABATCH()}})
AADD(_ABUTTON,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(_CTITULO,_ASAYS,_ABUTTON)

_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05PROC(LSIMULACAO,_CARQLOG)
LOCAL _ODLG := NIL
LOCAL _CTITLE := "AJUSTE DE REGIÇAO DE CLIENTES"
LOCAL _OARQLOG := NIL

_ODLG := MSDIALOG():NEW(0,0,300,900,_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )

TSAY():NEW(40,20,{||"ARQUIVO LOG:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OARQLOG := TGET():NEW(37,80,{ | U |IIF(PCOUNT()==0,_CARQLOG,_CARQLOG := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CARQLOG",,,)

TBUTTON():NEW(37,400,"SELEC. ARQUIVO",_ODLG,{||MD05ARQLOG(@_CARQLOG)},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(120,170,"CONFIRMAR",_ODLG,{||MD05OK(LSIMULACAO,@_CARQLOG)},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(120,220,"CANCELAR",_ODLG,{||_ODLG:END()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)

_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05ARQLOG(_CARQLOG)
LOCAL _CARQ := CGETFILE("*.TXT","INFORME DIRETORIO PARA ARQUIVO DE LOG",0,"", .F. ,NOR(48,8,128), .F. , .T. )

_CARQLOG := _CARQ+DTOS(DATE())+"_"+STRTRAN(TIME(),":","")+".TXT"
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05OK(LSIMULACAO,_CARQLOG)
LOCAL _NTOTAL := 0
LOCAL _NREG := 0
LOCAL _CLOG := "INICIO "+DTOC(DATE())+" "+TIME() + CRLF + CRLF
LOCAL _CMSG := ""
LOCAL _NERR := 0
LOCAL _NINC := 0
LOCAL _NATU := 0

SA1->(DBSETORDER(1))
SA1->(DBGOTOP())

SA1->(DBEVAL({||_NTOTAL++}))
SA1->(DBGOTOP())

WHILE !SA1->(EOF())
 
    FWMSGRUN(,{||MD05EXEC(@_CLOG,@_NERR,@_NINC,@_NATU,LSIMULACAO)},,I18N("ATUALIZANDO CLIENTE #1 DE #2 ...",{++_NREG,_NTOTAL}))

    SA1->(DBSKIP())
    ENDDO

_CMSG := MD05LOG(_CARQLOG,_CMSG,@_CLOG,_NERR,_NINC,_NATU)

AVISO("ATENÇÃO",I18N(_CMSG,{_NTOTAL,_CARQLOG}),{"OK"},3)

_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05LOG(_CARQLOG,_CMSG,_CLOG,_NERR,_NINC,_NATU)
LOCAL _NHANDLE := 0

_NHANDLE := FCREATE(_CARQLOG)

_CLOG := CHR(13)+CHR(10) + CRLF+I18N("REGIÕES INCLUÍDAS: #1",{_NINC}) + CRLF+I18N("REGIÕES ATUALIZADAS: #1",{_NATU}) + CRLF+I18N("REGIÕES NÃO ATUALIZADAS: #1",{_NERR}) + CRLF + CRLF+_CLOG
_CLOG += CHR(13)+CHR(10) + CRLF+"FIM "+DTOC(DATE())+" "+TIME() + CRLF + CRLF

IF _NHANDLE=- (1)
    _CMSG += " ERRO AO CRIAR ARQUIVO - FERROR "+STR(FERROR())
ELSE 
    _CMSG += " VERIFIQUE ARQUIVO DE LOG GERADO: " + CRLF + CRLF+"#2 " + CRLF
    FWRITE(_NHANDLE,_CLOG)
    FCLOSE(_NHANDLE)
ENDIF
RETURN _CMSG

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05EXEC(_CLOG,_NERR,_NINC,_NATU,LSIMULACAO)
LOCAL _CMSGLOG := ""
LOCAL CREG := ""
LOCAL CREGDES := ""
LOCAL CREGOLD := ""
LOCAL CREGDESOLD := ""

IF !(EMPTY(SA1->A1_EST))
    U_M05A30(SA1->A1_EST,@CREG,@CREGDES)
    
    CREGOLD := SA1->A1_REGIAO
    CREGDESOLD := SA1->A1_DSCREG
    
    IF ( ALLTRIM( UPPER(CREGDESOLD))<> ALLTRIM( UPPER(CREGDES))) .OR. ( ALLTRIM(CREGOLD)<> ALLTRIM(CREG))
        
        IF EMPTY(SA1->A1_REGIAO)
            _CMSGLOG := "INCLUIDO"
            ++_NINC
        ELSE 
            _CMSGLOG := "ATUALIZADO"
            ++_NATU
        ENDIF
        
        IF !(LSIMULACAO)
            RECLOCK("SA1", .F. )
            SA1->A1_REGIAO := CREG
            SA1->A1_DSCREG := CREGDES
            SA1->(MSUNLOCK())
        ENDIF
    ELSE 
        
        _CMSGLOG := "REGIAO JA CADASTRADA"
        ++_NERR
    ENDIF
ELSE 
    ++_NERR
    _CMSGLOG := "ESTADO NÃO PREENCHIDO"
ENDIF

MD05GETLOG(SA1->A1_COD,SA1->A1_LOJA,SA1->A1_EST,CREG,CREGDES,CREGOLD,CREGDESOLD,_CMSGLOG,@_CLOG)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05GETLOG(CCOD,CLOJA,CEST,CREG,CREGDES,CREGOLD,CREGDESOLD,_CMSGLOG,_CLOG)
_CLOG += CHR(13)+CHR(10)
_CLOG += " | CÓDIGO: "+CCOD
_CLOG += " | LOJA: "+CLOJA
_CLOG += " | ESTADO: "+CEST
_CLOG += " | REGIAO ANT.: "+CREGOLD
_CLOG += " | DESC ANT.: "+CREGDESOLD
_CLOG += " | REGIAO NOVA: "+CREG
_CLOG += " | DESC NOVA: "+PADR(CREGDES,TAMSX3("A1_DSCREG")[1])
_CLOG += " | STATUS: "+ ALLTRIM(_CMSGLOG)+" |"
RETURN 
