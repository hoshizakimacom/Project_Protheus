#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| PE ap�s grava��o do fornecedor
//+-------------------------------------------------------------------------------------------------------------------
User Function MT20FOPOS()
    Local _aArea    := GetArea()

    // Rotina de inclus�o/altera��o de item contabil por fornecedor
    U_M02A01()

    RestArea(_aArea)
Return .T.