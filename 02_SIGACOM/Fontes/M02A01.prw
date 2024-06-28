#Include 'Protheus.ch'

//+-------------------------------------------------------------------------------------------------------------------
//| Cadastro de item contabil por fornecedor
//| Chamado do PE MT20FOPOS
//+-------------------------------------------------------------------------------------------------------------------
User Function M02A01()
    Local _aAreaTu  := GetArea()
    Local _aAreaCTD := CTD->(GetArea())
    Local _aAreaSA2 := SA2->(GetArea())
    Local _cItem    := '2' + AllTrim(SA2->A2_COD) + AllTrim(SA2->A2_LOJA)
    Local _nOpc     := 3    // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
    Local _aDados   := {}
    Local _cNome    := Alltrim(SA2->A2_NOME)
    Private _lErro    := .F.

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
        MsgStop('Erro ao criar item contabil para o fornecedor.' + CRLF + CRLF + 'Favor tirar print do erro e abrir chamado para TI.')
        MostraErro()
    Else
        RecLock('SA2',.F.)
        SA2->A2_XITEMC  := _cItem
        SA2->(MsUnLock())
    EndIf

    RestArea(_aAreaSA2)
    RestArea(_aAreaCTD)
    RestArea(_aAreaTu)
Return
