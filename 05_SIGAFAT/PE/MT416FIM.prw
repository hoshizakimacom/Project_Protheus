#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| PE após o termino da efetivação do Orçamento de Venda
//+-------------------------------------------------------------------------------------------------------------------
User Function MT416FIM()
    Local _aArea    := GetArea()

    //+----------------------------------------------------------
    //| Cadastro de item contabil por cliente no momento
    //| da aprovação do orçamento de vendas
    //+----------------------------------------------------------
    U_M05A06()

    RestArea(_aArea)
Return
