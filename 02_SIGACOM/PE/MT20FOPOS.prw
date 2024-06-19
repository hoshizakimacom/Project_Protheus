#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| PE após gravação do fornecedor
//+-------------------------------------------------------------------------------------------------------------------
User Function MT20FOPOS()
    Local _aArea    := GetArea()

    // Rotina de inclusão/alteração de item contabil por fornecedor
    U_M02A01()

    RestArea(_aArea)
Return .T.