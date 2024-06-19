#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------
//| Retorna variável publica de controle de acesso por representantes
//+--------------------------------------------------------------------------------------------
User Function M05C01(_cAlias)
    Local _cFiltro      := ''

    If type('__lRepres') <> 'L'
        __lRepres := .T.
        MsgInfo('M05C01: Erro inesperado ao inicializar tela de Orçamentos (Representantes).' + CRLF + CRLF + 'Abra um chamado e anexe um prit desta mensagem.','Atenção')
    EndIf

    If __lRepres
        Do Case
        Case _cAlias == 'SA1'
            _cFiltro    := IIf(__lRepres,"@A1_XREP = '1'","@A1_XREP IN ('1','2',' ')")

        Case _cAlias == 'SE4'
            _cFiltro    := IIf(__lRepres,"@E4_XREP = '1'","@E4_XREP IN ('1','2',' ')")

        Case _cAlias == 'DA0'
            _cFiltro    := IIf(__lRepres,"@DA0_XREP = '1'","@DA0_XREP IN ('1','2',' ')")

        Case _cAlias == 'SB1'
            _cFiltro    := IIf(__lRepres,"@B1_XREP = '1'","@B1_XREP IN ('1','2',' ')")

        EndCase
    EndIf

    If type('__lComerc') <> 'L'
        __lComerc := .T.
        MsgInfo('M05C01: Erro inesperado ao inicializar tela de Orçamentos (Comercial).' + CRLF + CRLF + 'Abra um chamado e anexe um prit desta mensagem.','Atenção')
    EndIf

    If __lComerc .And. _cAlias == 'SB1'
        _cFiltro    := IIf(__lComerc,"@B1_TIPO IN ('PA','ME')","@B1_XREP <> '  '")
    EndIf

Return _cFiltro