
#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Ponto de Entrada responsável pela inclusão do usuário, dia e hora de liberação
// de pedidos de venda
// 
// *Autor: Wallace Manzini - 23/09/2026
//+------------------------------------------------------------------------------

User Function M440SC9I()
    Local aArea := GetArea()
    Local aAreaC9 := SC9->(GetArea())
    Local aAreaC6 := SC6->(GetArea())
    Local aAreaC5 := SC5->(GetArea())
     
    DbSelectArea('SC5')
    SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
     
    //Posiciona no pedido
    If SC5->(DbSeek(FWxFilial('SC5') + SC9->C9_PEDIDO))
            RecLock('SC9', .F.)
                C9_XHORALI := UsrFullName(RetCodUsr()) + ' | ' + DToC(Date()) + ' ' + Time()
            SC9->(MsUnlock())
        //EndIf
    EndIf
     
    RestArea(aAreaC5)
    RestArea(aAreaC6)
    RestArea(aAreaC9)
    RestArea(aArea)
Return
