#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M02A06_A()

LOCAL _CMASCARA := "TODOS OS ARQUIVOS|*.*"
LOCAL _CTITULO := "ESCOLHA O ARQUIVO"
LOCAL _NMASCPAD := 0
LOCAL _CDIRORI := "C:\"
LOCAL _CDIRDES :=  ALLTRIM(GETMV("AM_02A06_A", .T. ,""))
LOCAL _LSALVAR :=  .F. 
LOCAL _NOPCOES := 48
LOCAL _LARVORE :=  .F. 

LOCAL _LOK :=  .F. 
PRIVATE _AARQUIVO := {}

IF EMPTY(_CDIRDES)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_05A25_A.",{"OK"},3)
ELSE 
    _CDIRDES +=  ALLTRIM(SC7->(C7_FILIAL+C7_NUM))+"\"
    _CDIRORI := IIF(FINDFUNCTION("FWHASACCMODE") .AND. FINDFUNCTION("AVGETFILE") .AND. FWHASACCMODE(1),AVGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,_LARVORE,,,,,,),CGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,,))
    
    IF !(EMPTY(_CDIRORI))
        _AFILES := DIRECTORY(_CDIRORI,"D")
        
        MAKEDIR(_CDIRDES)
        
        IF !(_LOK := !(FILE(_CDIRDES+_AFILES[1][1])))
            
            IF IIF(FINDFUNCTION("APMSGYESNO"),MSGYESNO("ARQUIVO JÁ ANEXADO AO ORÇAMENTO." + CRLF+"DESEJA ATUALIZAR O ARQUIVO?","ATENÇÃO"),(CMSGYESNO := "MSGYESNO", &CMSGYESNO.("ARQUIVO JÁ ANEXADO AO ORÇAMENTO." + CRLF+"DESEJA ATUALIZAR O ARQUIVO?","ATENÇÃO")))
                
                IF !(_LOK := FERASE(_CDIRDES+_AFILES[1][1])<>- (1))
                    IIF(FINDFUNCTION("APMSGALERT"),MSGALERT("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),"ATENÇÃO"),MSGALERT("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),"ATENÇÃO"))
                ENDIF
            ENDIF
        ENDIF
        
        IF _LOK
            __COPYFILE(_CDIRORI,_CDIRDES+_AFILES[1][1])
            
            IF FILE(_CDIRDES+_AFILES[1][1])
                RECLOCK("SC7", .F. )
                SC7->C7_XANEXPC := I18N("ARQUIVO: #1    | DATA: #2    | USUÁRIO: #3 ",{ UPPER(_AFILES[1][1]),DTOC(DATE())+" "+TIME(), UPPER(USRRETNAME(RETCODUSR()))})
                SC7->(MSUNLOCK())
                
                IIF(FINDFUNCTION("APMSGINFO"),MSGINFO("ARQUIVO ANEXADO COM SUCESSO!","ATENÇÃO"),MSGINFO("ARQUIVO ANEXADO COM SUCESSO!","ATENÇÃO"))
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
USER FUNCTION M02A06_C()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_02A06_A", .T. ,""))

IF EMPTY(_CDIR)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_02A06_A.",{"OK"},3)
ELSE 
    _CDIR +=  ALLTRIM(SC7->(C7_FILIAL+C7_NUM))+"\"
    
    MAKEDIR(_CDIR)
    WINEXEC("EXPLORER.EXE "+_CDIR)
ENDIF
RETURN 
