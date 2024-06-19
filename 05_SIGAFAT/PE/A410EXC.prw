#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------
//  PE chamado no programa de exclus�o de Pedidos de Venda
//+--------------------------------------------------------------------------------------------------------
User Function A410EXC()
    Local aArea         := GetArea()
    Local lRet          := .T.


    // Valida se usu�rio tem permiss�o para excluir pedido de venda
    lRet    := U_M05A15()


    RestArea(aArea)

Return lRet