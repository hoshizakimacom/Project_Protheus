#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------
//| Chamado do PE antes da exclus�o do Or�amento de venda.
//+----------------------------------------------------------------------------------------------------------------------------
User Function MT415EXC()
    Local _lRet := .F.

    MsgStop(I18N('N�o � poss�vel excluir o or�amento #1.' + CRLF + 'Utilize a op��o de cancelamento.',{SCJ->CJ_NUM}))

Return _lRet