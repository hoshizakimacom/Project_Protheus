#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------------------------------------------
//  Rotina chamada para verificação de titulos vencidos do cliente/loja passados
//  Retorna .T. caso encontre titulos vencidos
//+-------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05A09(_cFilial,_cCliente,_cLoja)
    Local _lRet     := .F.
    Local _lBlqCred := .T.
    Local _cAlias   := GetNextAlias()
    
    Local _cCliLib  := GetMv('AM_05A0901',,'')
    Private _cMsg     := ''


    // Verifica se cliente está liberado - verificação somente por código
    If AllTrim(_cCliente) $ AllTrim(_cCliLib)
        _lBlqCred := .F.
    EndIf

    If _lBlqCred
        BeginSql Alias _cAlias
            Column E1_VENCREA as Date
            SELECT  E1_FILIAL,E1_PREFIXO, E1_NUM,E1_PARCELA,E1_TIPO,E1_VALOR,E1_SALDO,E1_VENCREA
                FROM SE1010 SE1
                WHERE   E1_SALDO > 0
                    AND E1_CLIENTE = %Exp:_cCliente% AND E1_LOJA = %Exp:_cLoja%  AND E1_FILIAL = %Exp:_cFilial% AND E1_VENCREA < %Exp:Date()% AND SE1.%NotDel%
                    AND E1_TIPO NOT IN ('RA','NCC')
        EndSql

        If (_cAlias)->(!EOF())
            _lRet := .T.
        EndIf

        (_cAlias)->(DbCloseArea())
    EndIf
Return _lRet

//+-------------------------------------------------------------------------------------------------------------------------------------------------------
// Rotina de bloqueio de Crédito
//+-------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05A09_A(_nTipo)

    Do Case
    Case _nTipo == 1 //   Orçamento

        If SCJ->CJ_XCRED  == '1'
            MsgInfo('Orçamento já bloqueado anteriormente.' + CRLF + 'Verifique.','Atenção')

        ElseIf SCJ->CJ_STATUS $ 'B|C|'  // A=Aberto;B=Aprovado;C=Cancelado;D=Noo Orþado
            MsgInfo('Somente orçamentos Em Aberto ou Não Orçados podem ser bloqueados.' + CRLF + 'Verifique.','Atenção')
        Else
            If MsgYesNo(I18N('Deseja bloquear o orcamento #1?',{SCJ->CJ_NUM}),'Atenção')
                RecLock('SCJ',.F.)
                    SCJ->CJ_XCRED := '1'
                SCJ->(MsUnLock())
            EndIf
        EndIf

    Case _nTipo == 2 // Pedido de Vendas

        If SC5->C5_XCRED == '1'
            MsgInfo('Pedido de Venda já bloqueado anteriormente.' + CRLF + 'Verifique.','Atenção')
        Else
            If MsgYesNo(I18N('Deseja bloquear o pedido de venda #1 ?',{SC5->C5_NUM}),'Atenção')
                RecLock('SC5',.F.)
                    SC5->C5_XCRED := '1'
                SC5->(MsUnLock())
            EndIf
        EndIf
    End
Return

//+-------------------------------------------------------------------------------------------------------------------------------------------------------
// Rotina de desbloqueio de Crédito
//+-------------------------------------------------------------------------------------------------------------------------------------------------------
User Function M05A09_B(_nTipo)

    Do Case
    Case _nTipo == 1 //   Orçamento
        If SCJ->CJ_XCRED  <> '1'
            MsgInfo('Somente orçamentos bloqueados por crédito podem ser desbloqueados.' + CRLF + 'Verifique.','Atenção')
        Else
            If MsgYesNo(I18N('Deseja desbloquear o orçamento #1 ?',{SCJ->CJ_NUM}),'Atenção')
                RecLock('SCJ',.F.)
                    SCJ->CJ_XCRED := '2'
                SCJ->(MsUnLock())
            EndIf
        EndIf

    Case _nTipo == 2 // Pedido de Vendas

        If SC5->C5_XCRED <> '1'
            MsgInfo('Somente pedidos bloqueados por crédito podem ser desbloqueados.' + CRLF + 'Verifique.','Atenção')
        Else
            If MsgYesNo(I18N('Deseja desbloquear o pedido #1 ?',{SC5->C5_NUM}),'Atenção')
                RecLock('SC5',.F.)
                    SC5->C5_XCRED := '2'
                SC5->(MsUnLock())
            EndIf
        EndIf
    End
Return

