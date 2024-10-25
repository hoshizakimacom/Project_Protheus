#Include "Protheus.ch"

/*/{Protheus.doc} F070BXLT
PE para validaÃ§Ã£o do contas a receber
@type method
@author Renan Camargo
@since 18/10/2024
/*/
User Function F070BXLT()

Local aArea := GetArea()
Local cTipo := FwFieldGet("E1_TIPO")
Local lRet     := .T.

If !IsInCallStack("ClassTituloCRA")

    // Validaçaõ de campo E1_TIPO 
    If cTipo == "CRA"
        MsgStop("Não é permitido inclusão de tipo de título 'CRA' manualmente !", "Aviso")
        RlRet := .F.
      EndIf
EndIf

RestArea(aArea)

Return lRet 
