#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------
//  PE na efetivação do orçmaneto
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
    // Verifique se o cliente é genérico de representante
    //+-------------------------------------------------------
    If _lRet
        _lRet := Posicione('SA1',1,xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ,'A1_XREP') <> '1' // 1=Sim;2=Nao

        If ! _lRet
            MsgInfo('Não é permitido Efetivar orçamento com cliente genérico para representantes.' + CRLF + CRLF + 'Verifique','Atenção')
        EndIf
    EndIf

    RestArea(_aAreaSA1)
    RestArea(_aArea)
Return _lRet

