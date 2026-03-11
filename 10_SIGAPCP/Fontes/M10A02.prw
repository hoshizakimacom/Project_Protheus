#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M10A02A()
LOCAL _CMASCARA := "TODOS OS ARQUIVOS|*.*"
LOCAL _CTITULO := "ESCOLHA O ARQUIVO"
LOCAL _NMASCPAD := 0
LOCAL _CDIRORI := "C:\"
LOCAL _CDIRDES :=  ALLTRIM(GETMV("AM_10A02_A", .T. ,""))
LOCAL _LSALVAR :=  .F. 
LOCAL _NOPCOES := 48
LOCAL _LARVORE :=  .F. 
LOCAL _LOK :=  .F. 
PRIVATE _AARQUIVO := {}

IF EMPTY(_CDIRDES)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_10A02_A.",{"OK"},3)
ELSE 
    _CDIRDES +=  ALLTRIM(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))+"\"
    _CDIRORI := CGETFILE(_CMASCARA,_CTITULO,_NMASCPAD,_CDIRORI,_LSALVAR,_NOPCOES,_LARVORE)

    IF !(EMPTY(_CDIRORI))
        _AFILES := DIRECTORY(_CDIRORI,"D")

        MAKEDIR(_CDIRDES)

        IF !(_LOK := !(FILE(_CDIRDES+_AFILES[1][1])))
            
            IF MSGYESNO("ARQUIVO JÁ ANEXADO A ESTA OP." + CRLF+"DESEJA ATUALIZAR O ARQUIVO?",)
                
                IF !(_LOK := FERASE(_CDIRDES+_AFILES[1][1])<>- (1))
                    MSGALERT("ERRO AO APAGAR ARQUIVO: "+STR(FERROR()),)
                ENDIF
            ENDIF
        ENDIF

        IF _LOK
            __COPYFILE(_CDIRORI,_CDIRDES+_AFILES[1][1])

            IF FILE(_CDIRDES+_AFILES[1][1])
                MSGINFO("ARQUIVO ANEXADO COM SUCESSO!",)
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
USER FUNCTION M10A02B()
LOCAL _CDIR :=  ALLTRIM(GETMV("AM_10A02_A", .T. ,""))

IF EMPTY(_CDIR)
    AVISO("ATENÇÃO","É OBRIGATÓRIO INFORMAR O DIRETÓRIO DE ARMAZENAMENTO NO PARÂMETRO AM_10A02_A.",{"OK"},3)
ELSE 
    _CDIR +=  ALLTRIM(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))+"\"

    MAKEDIR(_CDIR)
    WINEXEC("EXPLORER.EXE "+_CDIR)
ENDIF
RETURN 

