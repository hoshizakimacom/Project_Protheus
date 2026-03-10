#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} M04A08
Cadastro de DADOS ADICIONAIS DE USUÁRIO
 
@author RENAN
@since 01/10/2024
@version P12 
/*/
//-------------------------------------------------------------------
User Function M04A08()

ProtheusMVC("PA0", "PA0MASTER" /*cModelID*/)

Return(nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Definicao do Menu
@author Renan
@since 01/10/2024
@version 1.0
@return aRotina (vetor com botoes da EnchoiceBar)
/*/
//-------------------------------------------------------------------
Static Function MenuDef()  

Local aRotina := {} //Array utilizado para controlar opcao selecionada

ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.PROTHEUSMVC" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.PROTHEUSMVC" OPERATION MODEL_OPERATION_INSERT ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.PROTHEUSMVC" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.PROTHEUSMVC" OPERATION MODEL_OPERATION_DELETE ACCESS 0
ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.PROTHEUSMVC" OPERATION 9                      ACCESS 0

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} PA0MASTER
Ponto de Entrada MVC para a rotina M04A08 - DADOS ADICIONAIS DE USUARIOS
@author Renan
@since 01/10/2024
@version 1.0
@return aRotina (vetor com botoes da EnchoiceBar)
/*/
//-------------------------------------------------------------------
User Function PA0MASTER
    Local aParam   := PARAMIXB 
    Local xRet     := .T.      
    Local oObj     := NIL      
    Local cIdPonto := "" 

    If (!aParam == NIL)
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]

        // VALIDAÇÃO ANTES DA ATIVAÇÃO DO MODELO
        If (cIdPonto == "MODELVLDACTIVE")
            // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE -> BLOCO DE CÓDIGO -> X3_WHEN := .F.
            //If oObj:GetOperation() <> 3 
            //    oObj:GetModel("PA0MASTER"):GetStruct():SetProperty("PA0_CODUSR", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
            //EndIf
            //oObj:GetModel("PA0MASTER"):SetFldNoCopy( { 'PA0_CODUSR', 'PA0_NOMUSR' } )
        ElseIf (cIdPonto == "FORMPRE")
        EndIf
    EndIf
Return (xRet) 
