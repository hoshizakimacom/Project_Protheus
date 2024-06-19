#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| Cadastro de item contabil por cliente no momento da aprovação do orçamento de vendas
//| Chamado do PE MT416FIM
//+-------------------------------------------------------------------------------------------------------------------
User Function M05A06()
    Local _aAreaCTD := CTD->(GetArea())
    Local _aAreaSA1 := SA1->(GetArea())
    Local _cItem    := '1' + AllTrim(SC5->C5_CLIENTE) + AllTrim(SC5->C5_LOJACLI)
    Local _nOpc     := 3    // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
    Local _aDados   := {}
    Local _cNome    := AllTrim(Posicione('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_NOME'))
    lMsErroAuto     := .F.

    CTD->(DbGoTop())
    CTD->(DbSetOrder(1))    // CTD_FILIAL+CTD_ITEM

    // Verifica se item contabil já existe. Se sim, atualiza. Se não, inclui
    If CTD->(DbSeek( xFilial('CTD') + _cItem ))
        _nOpc := 4
    EndIf

    // Carrega vetor com dados do item contabil
    AAdd(_aDados,   {'CTD_ITEM'     ,_cItem                     ,Nil})
    AAdd(_aDados,   {'CTD_CLASSE'   ,'2'                        ,Nil})  // 1=Sintetica;2=Analitica
    AAdd(_aDados,   {'CTD_DESC01'   ,_cNome                     ,Nil})  // Descrição da moeda 1
    AAdd(_aDados,   {'CTD_BLOQ'     ,'2'                        ,Nil})  // Bloqueado? 1=Sim;2=Nao
    AAdd(_aDados,   {'CTD_DTEXIS'   ,SToD('19800101')           ,Nil})  // Data inicio de existencia
    AAdd(_aDados,   {'CTD_DTEXSF'   ,SToD('20401231')           ,Nil})  // Data fim de existencia
    AAdd(_aDados,   {'CTD_CLOBRG'   ,'2'                        ,Nil})  // Nao - Classe Valor Obrigatório
    AAdd(_aDados,   {'CTD_ACCLVL'   ,'1'                        ,Nil})  // Sim - Aceita Classe de Valor


    MSExecAuto({|x,y| CTBA040(x,y)},_aDados,_nOpc)

    If lMsErroAuto
        MsgStop('Erro ao criar item contabil para o cliente.' + CRLF + CRLF + 'Favor tirar print do erro e abrir chamado para TI.')
        MostraErro()
     Else

        // Atualiza cadastro do cliente
        SA1->(DbGotop())
        SA1->(DbSetOrder(1))

        If SA1->(DbSeek( xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
            RecLock('SA1',.F.)
                SA1->A1_XITEMC  := _cItem
            SA1->(MsUnLock())
        EndIf
    EndIf

    RestArea(_aAreaSA1)
    RestArea(_aAreaCTD)
Return