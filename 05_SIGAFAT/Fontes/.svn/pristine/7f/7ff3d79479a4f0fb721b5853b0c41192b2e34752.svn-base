#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------
//  Rotina que retorna .T. caso o usuário tenha permissão para excluir pedido de venda
//+--------------------------------------------------------------------------------------------------------
User Function M05A15()
    Local cGrpExc       := GetMv('AM_05A15  ',,'')
    Local lRet          := U_M00A01(cGrpExc)

    If !lRet
        MsgInfo('Usuário sem permissão para excluir pedido de venda.','Atenção')
    EndIf
Return lRet