#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
// Retorna de usuário é representante
//+---------------------------------------------------------------------------------------------------------
User Function M05A29(cEst,cVend)
    Local aAreaSA3      := SA3->(GetArea())
    Local lRet          := .F.
    Local cCodUser      := RetCodUsr()

    Default cEst        := '  '

    SA3->(DbGoTop())
    SA3->(DbSetOrder(7))    // A3_FILIAL+A3_CODUSR

    If SA3->(DbSeek( xFilial('SA3') + cCodUser ))
        lRet       := .T.
        cEst       := SA3->A3_EST
        cVend      := SA3->A3_COD
    EndIf

    RestArea(aAreaSA3)
Return lRet