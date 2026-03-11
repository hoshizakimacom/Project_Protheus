#INCLUDE "protheus.ch"
STATIC _CARQORI := "", _CARQLOG := ""

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M34D01()
LOCAL _ASAYS := {}
LOCAL _ABUTTON := {}
LOCAL _CTITULO := FUNNAME()

AADD(_ASAYS,OEMTOANSI("ESTA ROTINA TEM COMO OBJETIVO CRIAR ITEM CONTÁBIL PARA OS CLIENTES QUE AINDA NÃO POSSUEM."))
AADD(_ASAYS,OEMTOANSI(" "))

AADD(_ABUTTON,{1, .T. ,{||PROCESSA({||MD34PROC()}),FECHABATCH()}})
AADD(_ABUTTON,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(_CTITULO,_ASAYS,_ABUTTON)

_CARQORI := ""
_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34PROC()
LOCAL _ODLG := NIL
LOCAL _CTITLE := "IMPORTAÇÃO CLIENTES + ITEM CONTABIL"
LOCAL _OARQLOG := NIL
PRIVATE _OARQORI := NIL

_ODLG := MSDIALOG():NEW(0,0,300,900,_CTITLE,,, .F. ,128,,,,, .T. ,,, .F. )

TSAY():NEW(40,20,{||"ARQUIVO LOG:"},_ODLG,,, .F. , .F. , .F. , .T. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
_OARQLOG := TGET():NEW(37,80,{ | U |IIF(PCOUNT()==0,_CARQLOG,_CARQLOG := U)},_ODLG,300,10,,,,,, .F. ,, .T. ,, .F. ,{|| .F. }, .F. , .F. ,, .F. , .F. ,,"_CARQLOG",,,)

TBUTTON():NEW(37,400,"SELEC. ARQUIVO",_ODLG,{||MD34ARQLOG()},40,15,,, .F. , .T. , .F. ,, .F. ,,, .F. )

TBUTTON():NEW(120,170,"CONFIRMAR",_ODLG,{||MD34OK()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )
TBUTTON():NEW(120,220,"CANCELAR",_ODLG,{||_ODLG:END()},40,12,,, .F. , .T. , .F. ,, .F. ,,, .F. )

_ODLG:ACTIVATE(_ODLG:BLCLICKED,_ODLG:BMOVED,_ODLG:BPAINTED, .T. ,,,,_ODLG:BRCLICKED,)

_CARQORI := ""
_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34ARQLOG()
LOCAL _CARQ := CGETFILE("*.TXT","INFORME DIRETORIO PARA ARQUIVO DE LOG",0,"", .F. ,NOR(48,8,128), .F. , .T. )

_CARQLOG := _CARQ+DTOS(DATE())+"_"+STRTRAN(TIME(),":","")+".TXT"
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34OK()

LOCAL _NREG := 0
LOCAL _CLOG := "INICIO "+DTOC(DATE())+" "+TIME() + CRLF + CRLF
LOCAL _CMSG := ""
LOCAL _NERR := 0
LOCAL _NINC := 0
LOCAL _CALIAS := GETNEXTALIAS()
PRIVATE _LVALID :=  .T. 
PRIVATE _AITENS := {}
PRIVATE _AFIELD := {}
PRIVATE _NTOTAL := 0
PRIVATE _NITEM := 0

MD34SELECT(_CALIAS,@_NTOTAL)

WHILE !(_CALIAS)->(EOF())
 
    FWMSGRUN(,{||MD34EXEC(_CALIAS,@_CLOG,@_NERR,@_NINC)},,I18N("IMPORTANTO ITEM CONTÁBIL #1 DE #2 ...",{++_NREG,_NTOTAL}))

    (_CALIAS)->(DBSKIP())
    ENDDO

_CMSG := MD34LOG(_CARQLOG,_CMSG,@_CLOG,_NERR,_NINC)

AVISO("ATENÇÃO",I18N(_CMSG,{_NTOTAL,_CARQLOG}),{"OK"},3)

_CARQORI := ""
_CARQLOG := ""
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34SELECT(_CALIAS,_NTOTAL)

_cQry := " SELECT A1_COD, "
_cQry += "        A1_LOJA, "
_cQry += "        A1_XITEMC, "
_cQry += "        A1_NOME, "
_cQry += "        R_E_C_N_O_ AS SA1_RECNO "
_cQry += " FROM "+RETSQLNAME("SA1")+" SA1 "
_cQry += " WHERE SA1.D_E_L_E_T_= ' ' "
_cQry += "   AND A1_XITEMC = ' ' "
__EXECSQL(_CALIAS,_cQry,{}, .F. )

(_CALIAS)->(DBEVAL({||_NTOTAL++}))
(_CALIAS)->(DBGOTOP())
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34LOG(_CARQLOG,_CMSG,_CLOG,_NERR,_NINC)
LOCAL _NHANDLE := 0

_NHANDLE := FCREATE(_CARQLOG)

_CLOG := CHR(13)+CHR(10) + CRLF+I18N("CLIENTES INCLUÍDOS: #1",{_NINC}) + CRLF+I18N("CLIENTES NÃO INCLUÍDOS (ERRO): #1",{_NERR}) + CRLF + CRLF+_CLOG
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
STATIC FUNCTION MD34EXEC(_CALIAS,_CLOG,_NERR,_NINC)
LOCAL CITEMC := "1"+ ALLTRIM(_CALIAS->A1_COD)+ ALLTRIM(_CALIAS->A1_LOJA)
LOCAL _CMSGLOG := ""
LOCAL _ADADOS := {}
LOCAL CNOME :=  ALLTRIM(_CALIAS->A1_NOME)

LMSERROAUTO :=  .F. 

CTD->(DBSETORDER(1))
CTD->(DBGOTOP())

IF !(CTD->(DBSEEK(XFILIAL("CTD")+CITEMC)))
    
    AADD(_ADADOS,{"CTD_ITEM",CITEMC,NIL})
    AADD(_ADADOS,{"CTD_CLASSE","2",NIL})
    AADD(_ADADOS,{"CTD_DESC01",CNOME,NIL})
    AADD(_ADADOS,{"CTD_BLOQ","2",NIL})
    AADD(_ADADOS,{"CTD_DTEXIS",STOD("19800101"),NIL})
    AADD(_ADADOS,{"CTD_DTEXSF",STOD("20401231"),NIL})
    AADD(_ADADOS,{"CTD_CLOBRG","2",NIL})
    AADD(_ADADOS,{"CTD_ACCLVL","1",NIL})
    
    MSEXECAUTO({|X,Y|CTBA040(X,Y)},_ADADOS,3)
ENDIF

IF !(LMSERROAUTO)
    
    SA1->(DBGOTO(_CALIAS->SA1_RECNO))
    
    IF !SA1->(EOF())
        RECLOCK("SA1", .F. )
        SA1->A1_XITEMC := CITEMC
        SA1->(MSUNLOCK())
    ENDIF
    
    _CMSGLOG := "INCLUÍDO"
ELSE 
    
    ++_NERR
    _CMSGLOG := MD34GETERR()
ENDIF

MD34GETLOG(_CALIAS->A1_COD,_CALIAS->A1_LOJA,CITEMC,_CMSGLOG,@_CLOG)
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34GETLOG(CCOD,CLOJA,CITEMC,_CMSGLOG,_CLOG)
_CLOG += CHR(13)+CHR(10)
_CLOG += " | CÓDIGO: "+CCOD
_CLOG += " | LOJA: "+CLOJA
_CLOG += " | ITEM CONTABIL: "+CITEMC
_CLOG += " | STATUS: "+ ALLTRIM(_CMSGLOG)+" |"
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION MD34GETERR()
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
STATIC FUNCTION MD34ITEMC(CCOD,CLOJA,CITEMC,_CMSGLOG)

RETURN 
