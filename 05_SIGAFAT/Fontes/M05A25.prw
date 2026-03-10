#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A25_A()
LOCAL _CMASCARA := "TODOS OS ARQUIVOS|*.*"
LOCAL _CTITULO := "ESCOLHA O ARQUIVO"
LOCAL _NMASCPAD := 0
LOCAL _CDIRORI := "C:\"
LOCAL _CDIRDES :=  ALLTRIM(GETMV("AM_05A25_A", .T. ,""))
LOCAL _LSALVAR :=  .F. 
LOCAL _NOPCOES := 48
LOCAL _LARVORE :=  .F. 

LOCAL _LOK :=  .F. 
PRIVATE _AARQUIVO := {}

IF EMPTY(_CDIRDES)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_A.",{"OK"},3)
ELSE 
    _CDIRDES +=  ALLTRIM(SCJ->(CJ_FILIAL+CJ_NUM))+"\"
    _CDIRORI := IIF(FINDFUNCTION("FWHASACCMODE") .AND. FINDFUNCTION("AVGETFILE") .AND. FWHASACCMODE(1),AVGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,_LARVORE,,,,,,),CGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,,))

    IF !(EMPTY(_CDIRORI))
        _AFILES := DIRECTORY(_CDIRORI,"D")

        MAKEDIR(_CDIRDES)

        IF !(_LOK := !(FILE(_CDIRDES+_AFILES[1][1])))
            
            IF MSGYESNO("ARQUIVO JÁ ANEXADO AO ORÇAMENTO." + CRLF+"DESEJA ATUALIZAR O ARQUIVO?","ATENÇÃO")
                
                IF !(_LOK := FERASE(_CDIRDES+_AFILES[1][1])<>- (1))
                    MSGALERT("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),"ATENÇÃO")
                ENDIF
            ENDIF
        ENDIF

        IF _LOK
            __COPYFILE(_CDIRORI,_CDIRDES+_AFILES[1][1])

            IF FILE(_CDIRDES+_AFILES[1][1])
                RECLOCK("SCJ", .F. )
                SCJ->CJ_XANEXO := I18N("ARQUIVO: #1    | DATA: #2    | USUÁRIO: #3 ",{ UPPER(_AFILES[1][1]),DTOC(DATE())+" "+TIME(), UPPER(USRRETNAME(RETCODUSR()))})
                SCJ->(MSUNLOCK())

                MSGINFO("ARQUIVO ANEXADO COM SUCESSO!","ATENÇÃO")
            ELSE 
                ALERT("ERRO AO ANEXAR ARQUIVO.","ATENÇÃO")
            ENDIF
        ENDIF
    ELSE 

        ALERT("ARQUIVO NÃO INFORMADO!")
    ENDIF
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A25_B()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_05A25_A", .T. ,""))

IF EMPTY(_CDIR)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_A.",{"OK"},3)
ELSE 
    _CDIR +=  ALLTRIM(SCJ->(CJ_FILIAL+CJ_NUM))+"\"

    MAKEDIR(_CDIR)
    WINEXEC("EXPLORER.EXE "+_CDIR)
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A25_C()
LOCAL _CMASCARA := "TODOS OS ARQUIVOS|*.*"
LOCAL _CTITULO := "ESCOLHA O ARQUIVO"
LOCAL _NMASCPAD := 0
LOCAL _CDIRORI := "C:\"
LOCAL _CDIRDES :=  ALLTRIM(GETMV("AM_05A25_B", .T. ,""))
LOCAL _LSALVAR :=  .F. 
LOCAL _NOPCOES := 48
LOCAL _LARVORE :=  .F. 
PRIVATE _AARQUIVO := {}
PRIVATE _LOK :=  .F. 

IF EMPTY(_CDIRDES)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_B.",{"OK"},3)
ELSE 
    _CDIRDES +=  ALLTRIM(SC5->(C5_FILIAL+C5_NUM))+"\"
    _CDIRORI := IIF(FINDFUNCTION("FWHASACCMODE") .AND. FINDFUNCTION("AVGETFILE") .AND. FWHASACCMODE(1),AVGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,_LARVORE,,,,,,),CGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,,))
    
    IF !(EMPTY(_CDIRORI))
        _AFILES := DIRECTORY(_CDIRORI,"D")
        
        MAKEDIR(_CDIRDES)
        
        IF !(_LOK := !(FILE(_CDIRDES+_AFILES[1][1])))
            
            IF MSGYESNO("ARQUIVO JÁ ANEXADO AO ORÇAMENTO." + CRLF+"DESEJA ATUALIZAR O ARQUIVO?","ATENÇÃO")
                
                IF !(_LOK := FERASE(_CDIRDES+_AFILES[1][1])<>- (1))
                    MSGALERT("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),"ATENÇÃO")
                ENDIF
            ENDIF
        ENDIF
        
        IF _LOK
            __COPYFILE(_CDIRORI,_CDIRDES+_AFILES[1][1])
            
            IF FILE(_CDIRDES+_AFILES[1][1])
                
                RECLOCK("SC5", .F. )
                SC5->C5_XANEXOP := I18N("ARQUIVO: #1    | DATA: #2    | USUÁRIO: #3 ",{ UPPER(_AFILES[1][1]),DTOC(DATE())+" "+TIME(), UPPER(USRRETNAME(RETCODUSR()))})
                SC5->(MSUNLOCK())
                
                MSGINFO("ARQUIVO ANEXADO COM SUCESSO!","ATENÇÃO")
            ELSE 
                ALERT("ERRO AO ANEXAR ARQUIVO.")
            ENDIF
        ENDIF
    ELSE 
        
        ALERT("ARQUIVO NÃO INFORMADO!")
    ENDIF
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A25_D()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_05A25_B", .T. ,""))
PRIVATE _ADIR := {}

IF EMPTY(_CDIR)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_B.",{"OK"},3)
ELSE 
    _CDIR +=  ALLTRIM(SC5->(C5_FILIAL+C5_NUM))+"\"
    
    MAKEDIR(_CDIR)
    WINEXEC("EXPLORER.EXE "+_CDIR)
ENDIF
RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M05A25_E()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_05A25_A", .T. ,""))
PRIVATE _ADIR := {}

IF EMPTY(_CDIR)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_A.",{"OK"},3)
ELSE 
    _CDIR +=  ALLTRIM(SC5->(C5_FILIAL+C5_XNUNORC))+"\"
    
    MAKEDIR(_CDIR)
    WINEXEC("EXPLORER.EXE "+_CDIR)
ENDIF
RETURN 
