#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------
//  PE na efetiva��o do or�maneto
//+----------------------------------------------------------------------------------
User Function MT415EFT()
    Local _aAreaSA1     := SA1->(GetArea())
    Local _aArea        := GetArea()
    Local _lRet         := .T.

    //+-------------------------------------------------------
    // Verifique se o cliente possui titulos em atraso
    //+-------------------------------------------------------
    _lRet := U_M05A26_A()

    //+-------------------------------------------------------
    // Verifique se o cliente � gen�rico de representante
    //+-------------------------------------------------------
    If _lRet
        _lRet := Posicione('SA1',1,xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ,'A1_XREP') <> '1' // 1=Sim;2=Nao

        If ! _lRet
            MsgInfo('N�o � permitido Efetivar or�amento com cliente gen�rico para representantes.' + CRLF + CRLF + 'Verifique','Aten��o')
        EndIf
    EndIf

    RestArea(_aAreaSA1)
    RestArea(_aArea)
Return _lRet

