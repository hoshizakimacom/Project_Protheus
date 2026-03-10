#INCLUDE "protheus.ch"
STATIC _CARQORI := "", _CARQLOG := ""

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05D03D()
LOCAL _ASAYS := {}
LOCAL _ABUTTON := {}
LOCAL _CTITULO := FUNNAME()

AADD(_ASAYS,OEMTOANSI("ESTA ROTINA TEM COMO OBJETIVO DELETAR PRODUTOS A PARTIR DE UM ARQUIVO CSV."))
AADD(_ASAYS,OEMTOANSI(" "))

AADD(_ABUTTON,{1, .T. ,{||PROCESSA({||MD05PROC()}),FECHABATCH()}})
AADD(_ABUTTON,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(_CTITULO,_ASAYS,_ABUTTON)

_CARQORI := ""
_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05PROC()
LOCAL _ODLG := NIL
LOCAL _CTITLE := "EXCLUSÃO DE PRODUTOS"
LOCAL _OARQORI := NIL
LOCAL _OARQLOG := NIL

_ODLG := MSDIALOG():NEW(0,0,300,900,_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )

TSAY():NEW(20,20,{||"ARQUIVO ORIGEM *.CSV:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OARQORI := TGET():NEW(17,80,{ | U |IIF(PCOUNT()==0,_CARQORI,_CARQORI := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CARQORI",,,)

TBUTTON():NEW(17,400,"SELEC. ARQUIVO",_ODLG,{||MD05ARQORI()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TSAY():NEW(40,20,{||"ARQUIVO LOG:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OARQLOG := TGET():NEW(37,80,{ | U |IIF(PCOUNT()==0,_CARQLOG,_CARQLOG := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CARQLOG",,,)

TBUTTON():NEW(37,400,"SELEC. ARQUIVO",_ODLG,{||MD05ARQLOG()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(120,170,"CONFIRMAR",_ODLG,{||MD05OK()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(120,220,"CANCELAR",_ODLG,{||_ODLG:END()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)

_CARQORI := ""
_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05ARQORI()
_CARQORI := CGETFILE("CSV | *.CSV","SELECIONE ARQUIVO DE PRODUTOS",,"", .T. ,0+48+8)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05ARQLOG()
LOCAL _CARQ := CGETFILE("*.TXT","INFORME DIRETORIO PARA ARQUIVO DE LOG",0,"", .F. ,NOR(48,8,128), .F. , .T. )

_CARQLOG := _CARQ+DTOS(DATE())+"_"+STRTRAN(TIME(),":","")+".TXT"
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05OK()
LOCAL _LVALID :=  .T. 
LOCAL _AITENS := {}
LOCAL _AFIELD := {}
LOCAL _NTOTAL := 0
LOCAL _NITEM := 0
LOCAL _NREG := 0
LOCAL _CLOG := "INICIO "+DTOC(DATE())+" "+TIME() + CRLF + CRLF
LOCAL _CMSG := ""
LOCAL _NERR := 0
LOCAL _NINC := 0

_LVALID := MD05VLDARQ(@_AFIELD,@_AITENS,@_NTOTAL)

IF _LVALID

    FOR _NITEM := 1 TO  LEN(_AITENS)
        FWMSGRUN(,{||MD05EXEC(_AFIELD,_AITENS[_NITEM],@_CLOG,@_NERR,@_NINC)},,I18N("EXCLUINDO PRODUTO #1 DE #2 ...",{++_NREG,_NTOTAL}))
    NEXT

    _CMSG := MD05LOG(_CARQLOG,_CMSG,@_CLOG,_NERR,_NINC)

    AVISO("ATENÇÃO",I18N(_CMSG,{_NTOTAL,_CARQLOG}),{"OK"},3)

    _CARQORI := ""
    _CARQLOG := ""
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05LOG(_CARQLOG,_CMSG,_CLOG,_NERR,_NINC)
LOCAL _NHANDLE := 0

_NHANDLE := FCREATE(_CARQLOG)

_CLOG := CHR(13)+CHR(10) + CRLF+I18N("PRODUTOS EXCLUÍDOS: #1",{_NINC}) + CRLF+I18N("PRODUTOS NÃO EXCLUÍDOS (ERRO): #1",{_NERR}) + CRLF + CRLF+_CLOG
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
STATIC FUNCTION MD05EXEC(_AFIELD,_AITEM,_CLOG,_NERR,_NINC)
LOCAL _CCOD := ""
LOCAL _CTIPO := ""
LOCAL _CORIGEM := ""
LOCAL _CMSGLOG := ""
LOCAL NPOS := 0
LOCAL APROD := {}
LOCAL ACOMP := {}

APROD := M05DPROD(_AFIELD,_AITEM)
ACOMP := M05DCOMP(_AFIELD,_AITEM)

IF (NPOS := ASCAN(APROD,{|X| ALLTRIM(X[1])=="B1_COD"}))>0
    _CCOD := APROD[NPOS][2]
ENDIF

IF (NPOS := ASCAN(APROD,{|X| ALLTRIM(X[1])=="B1_TIPO"}))>0
    _CTIPO := APROD[NPOS][2]
ENDIF

IF (NPOS := ASCAN(APROD,{|X| ALLTRIM(X[1])=="B1_ORIGEM"}))>0
    _CORIGEM := APROD[NPOS][2]
ENDIF

MD05PUTSB1(APROD,ACOMP,@_CMSGLOG,@_NERR,@_NINC)

MD05GETLOG(_CCOD,_CTIPO,_CORIGEM,_CMSGLOG,@_CLOG)

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05VLDFLD(AFIELD)
LOCAL AAREASX3 := SX3->(GETAREA())
LOCAL LRET :=  .T. 
LOCAL NX := 0
LOCAL AAUXAFIELD := ACLONE(AFIELD)

AFIELD := {}

DBSELECTAREA("SX3")

FOR NX := 1 TO  LEN(AAUXAFIELD)
    SX3->(DBSETORDER(2))
    SX3->(DBGOTOP())

    CCAMPO := PADR( ALLTRIM(AAUXAFIELD[NX]),10)

    IF SX3->(DBSEEK(CCAMPO))
        AADD(AFIELD,{CCAMPO,GetSX3Cache(CCAMPO, "X3_TIPO")})
    ELSE 
        LERRO :=  .T. 
        EXIT 
    ENDIF
NEXT

IF !(LRET)
    MSGINFO(I18N("CAMPO #1 INFORMADO NO ARQUIVO ORIGEM NÃO EXISTE NA BASE DE DADOS." + CRLF+"VERIFIQUE",{ ALLTRIM(CCAMPO)}),"ATENÇÃO")
ENDIF

RESTAREA(AAREASX3)
RETURN LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05GETLOG(_CCOD,_CTIPO,_CORIGEM,_CMSGLOG,_CLOG)
_CLOG += CHR(13)+CHR(10)
_CLOG += " | CÓDIGO: "+_CCOD
_CLOG += " | TIPO: "+_CTIPO
_CLOG += " | ORIGEM: "+_CORIGEM
_CLOG += " | STATUS: "+ ALLTRIM(_CMSGLOG)+" |"
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05DPROD(AFIELD,AITEM)
LOCAL ARET := {}
LOCAL NX := 0

FOR NX := 1 TO  LEN(AFIELD)

    IF  SUBSTR(AFIELD[NX][1],1,2)=="B1"

        DO CASE 
        CASE AFIELD[NX][2]=="N"
        AADD(ARET,{AFIELD[NX][1], VAL(AITEM[NX]),NIL})
        
        CASE AFIELD[NX][2]=="C"
        AADD(ARET,{AFIELD[NX][1],AITEM[NX],NIL})
        
        CASE AFIELD[NX][2]=="L"
        AADD(ARET,{AFIELD[NX][1],IFF(AITEM[NX]==".T.", .T. , .F. ),NIL})
        
        CASE AFIELD[NX][2]=="D"
        AADD(ARET,{AFIELD[NX][1],STOD(AITEM[NX]),NIL})
        ENDCASE
    ENDIF
NEXT

ARET := FWVETBYDIC(ARET,"SB1")
RETURN ACLONE(ARET)

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION M05DCOMP(AFIELD,AITEM)
LOCAL ARET := {}
LOCAL NX := 0

FOR NX := 1 TO  LEN(AFIELD)
    
    IF  SUBSTR(AFIELD[NX][1],1,2)=="B5"
        
        DO CASE 
        CASE AFIELD[NX][2]=="N"
        AADD(ARET,{AFIELD[NX][1], VAL(AITEM[NX]),NIL})
        
        CASE AFIELD[NX][2]=="C"
        AADD(ARET,{AFIELD[NX][1],AITEM[NX],NIL})
        
        CASE AFIELD[NX][2]=="L"
        AADD(ARET,{AFIELD[NX][1],IFF(AITEM[NX]==".T.", .T. , .F. ),NIL})
        
        CASE AFIELD[NX][2]=="D"
        AADD(ARET,{AFIELD[NX][1],STOD(AITEM[NX]),NIL})
        ENDCASE
    ENDIF
NEXT

ARET := FWVETBYDIC(ARET,"SB5")
RETURN ACLONE(ARET)

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05PUTSB1(APROD,ACOMP,_CMSGLOG,_NERR,_NINC)

BEGIN TRANSACTION

LMSERROAUTO :=  .F. 

MSEXECAUTO({|X,Y|MATA010(X,Y)},APROD,5)

IF LMSERROAUTO
    ++_NERR
    _CMSGLOG := MD05GETERR()
ENDIF

IF LMSERROAUTO
    DISARMTRANSACTION()
ENDIF

END TRANSACTION


MSUNLOCKALL()
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05GETERR()
LOCAL _CRET := ""
LOCAL _CFILEERROR := NOMEAUTOLOG()
LOCAL _CMEMO := MEMOREAD(_CFILEERROR)
LOCAL _NY := 0
LOCAL _CAUX := ""
LOCAL _LTITULO :=  .T. 

FOR _NY := 1 TO MLCOUNT(_CMEMO)
    _CAUX :=  ALLTRIM(MEMOLINE(_CMEMO,,_NY))

    IF  LEN(_CAUX)>0 .AND. _LTITULO
        _CRET += _CAUX+" "
    ELSE 
        
        IF AT("< --",_CAUX)>0
            _CRET += " | "+_CAUX
        ENDIF
        _LTITULO :=  .F. 
    ENDIF
NEXT

FERASE(_CFILEERROR)
RETURN _CRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05VLDARQ(_AFIELD,_AITENS,_NTOTAL)
LOCAL _LRET :=  .T. 

IF !(_LRET := !((EMPTY(_CARQORI)) .OR. (EMPTY(_CARQLOG))))
    MSGINFO("ARQUIVO ORIGEM E ARQUIVO DE LOG SÃO OBRIGATÓRIOS." + CRLF+"VERIFIQUE.","ATENÇÃO!")
ENDIF

IF _LRET
    MD05ARQINF(@_AFIELD,@_AITENS,@_NTOTAL)
ENDIF

IF _LRET
    _LRET := MD05VLDFLD(@_AFIELD)
ENDIF

RETURN _LRET

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD05ARQINF(_AFIELD,_AITENS,_NTOTAL)
LOCAL _ALINHA := {}
LOCAL _CLINHA := ""
LOCAL _NARQ := FOPEN(_CARQORI,0)
LOCAL LFIELD :=  .T. 

FT_FUSE(_CARQORI)
FT_FGOTOP()

WHILE !(FT_FEOF())
 
    _CLINHA := FT_FREADLN()
    _ALINHA := {}
    _ALINHA := SEPARA(_CLINHA,";", .T. )
    
    IF  LEN(_ALINHA)>0
        
        IF LFIELD
            LFIELD :=  .F. 
            _AFIELD := ACLONE(_ALINHA)
        ELSE 
            
            AADD(_AITENS,_ALINHA)
        ENDIF
    ENDIF
    
    FT_FSKIP()
    ENDDO

_NTOTAL :=  LEN(_AITENS)

FT_FUSE()
FCLOSE(_NARQ)
RETURN 
