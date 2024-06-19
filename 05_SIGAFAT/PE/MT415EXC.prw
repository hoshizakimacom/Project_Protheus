#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------
//| Chamado do PE antes da exclusão do Orçamento de venda.
//+----------------------------------------------------------------------------------------------------------------------------
User Function MT415EXC()
    Local _lRet := .F.

    MsgStop(I18N('Não é possível excluir o orçamento #1.' + CRLF + 'Utilize a opção de cancelamento.',{SCJ->CJ_NUM}))

Return _lRet