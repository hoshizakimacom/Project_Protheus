#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| PE ap�s o termino da efetiva��o do Or�amento de Venda
//+-------------------------------------------------------------------------------------------------------------------
User Function MT416FIM()
    Local _aArea    := GetArea()

    //+----------------------------------------------------------
    //| Cadastro de item contabil por cliente no momento
    //| da aprova��o do or�amento de vendas
    //+----------------------------------------------------------
    U_M05A06()

    RestArea(_aArea)
Return
