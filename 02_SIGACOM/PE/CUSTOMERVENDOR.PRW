#include "protheus.ch"
#include "parmtype.ch"
 
User Function CUSTOMERVENDOR()
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    Private nLinha := 0
    Private nQtdLinhas := 0
    Private cMsg := ""
    Private _aAreaTu := GetArea()

    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
        
        If cIdPonto == "FORMCOMMITTTSPOS"
            U_M02A01()
        Endif        
        
 
//        If cIdPonto == "MODELPOS"
//            cMsg := "Chamada na valida��o total do modelo." + CRLF
//            cMsg += "ID " + cIdModel + CRLF
 
//            xRet := ApMsgYesNo(cMsg + "Continua?")
 
//        ElseIf cIdPonto == "FORMPOS"
//            cMsg := "Chamada na valida��o total do formul�rio." + CRLF
//            cMsg += "ID " + cIdModel + CRLF
 
//            If lIsGrid
//                cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//            Else
//                cMsg += "� um FORMFIELD" + CRLF
//            EndIf
 
//            xRet := ApMsgYesNo(cMsg + "Continua?")
 
//        ElseIf cIdPonto == "FORMLINEPRE"
//            If aParam[5] == "DELETE"
//                cMsg := "Chamada na pr� valida��o da linha do formul�rio. " + CRLF
//                cMsg += "Onde esta se tentando deletar a linha" + CRLF
//                cMsg += "ID " + cIdModel + CRLF
//                cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//                xRet := ApMsgYesNo(cMsg + " Continua?")
//            EndIf
 
//        ElseIf cIdPonto == "FORMLINEPOS"
//            cMsg := "Chamada na valida��o da linha do formul�rio." + CRLF
//            cMsg += "ID " + cIdModel + CRLF
//            cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//            cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//            xRet := ApMsgYesNo(cMsg + " Continua?")
 
//        ElseIf cIdPonto == "MODELCOMMITTTS"
//            ApMsgInfo("Chamada ap�s a grava��o total do modelo e dentro da transa��o.")
 
//        ElseIf cIdPonto == "MODELCOMMITNTTS"
//            ApMsgInfo("Chamada ap�s a grava��o total do modelo e fora da transa��o.")
 
//        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
//            ApMsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.")
 
//        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
//            ApMsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.")
 
//        ElseIf cIdPonto == "MODELCANCEL"
//            cMsg := "Deseja realmente sair?"
//            xRet := ApMsgYesNo(cMsg)
 
//        ElseIf cIdPonto == "BUTTONBAR"
//            xRet := {{"Salvar", "SALVAR", {||u_TSMT020()}}}
//        EndIf
    EndIf
    RestArea(_aAreaTu)
Return xRet
