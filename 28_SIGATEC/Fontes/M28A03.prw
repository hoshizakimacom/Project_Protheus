#Include 'Protheus.ch'

Static _nQtdVen     := 0
Static _cNumSer     := ''
Static _cDescri     := ''
Static _cCodCli     := ''
Static _cCodLoja    := ''
Static _cEtapa      := ''
Static _cCliente    := ''
Static _cCodPro     := ''
Static _cNumNota    := ''
Static _cSerie      := ''
Static _cNumPed     := ''
Static _cItemPV     := ''
Static _cTpInstal   := ''
Static _cNumOrc     := ''
Static _cCodTab     := ''
Static _cNumOp      := ''
Static _cCodLocal   := ''
Static _cStatusCQ   := ''
Static _cUserCQ     := ''
Static _cNomeCli    := ''
Static _cGarant     := ''
Static _cEmisCQ     := CTOD("  /  /    ")
Static _dEmissao    := CTOD("  /  /    ")
Static _dEmisPV     := CTOD("  /  /    ")
Static _dDtEntreg   := CTOD("  /  /    ")
Static _dEmisOrc    := CTOD("  /  /    ")
Static _dEmisProd   := CTOD("  /  /    ")


//+------------------------------------------------------------------------------------------------------------------------
//  Consulta Rastreabilidade Numero de Série Macom
//+------------------------------------------------------------------------------------------------------------------------
User Function M28A03()
    Local _oDlg         := Nil
    Local _cTitle       := 'CONSULTA RASTREABILIDADE'
    Local _oEtapaAtu    := Nil
    Local _oProduto     := Nil
    Local _oItem        := Nil
    Local _oXItemP      := Nil
    Local _oQtdVen      := Nil
    Local _oCliente     := Nil
    Local _bConf        := {||( M05AOk())}
    Local _aSize        := FWGetDialogSize(oMainWnd)

    MA05ClrVar(.T.)

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME  From _aSize[1],_aSize[2] To _aSize[3],_aSize[4] Pixel

        // Cria o grupo
        @ 04,10 GROUP oGrp TO 56,540 LABEL "PRODUTO" PIXEL

        @015,020 Say  'Numero de Série:' Of _oDlg Pixel
        @012,090 Get _oProduto Var _cNumSer Size 80,011 Of _oDlg Pixel PICT "@!" 

        _oProduto:bLostFocus := _bConf

        //+---------------------------------------------------------------------+
        //|                           DADOS DO PRODUTO                          |
        //+---------------------------------------------------------------------+
        @015,200 Say  'Código:' Of _oDlg Pixel
        @012,270 Get _oItem Var _cCodPro Size 80,010 Of _oDlg Pixel WHEN .F.

        @015,400 Say  'Em Garantia ?' Of _oDlg Pixel
        @012,450 Get _oItem Var _cGarant Size 30,010 Of _oDlg Pixel WHEN .F.        

        @035,020 Say  'Descrição:' Of _oDlg Pixel
        @035,090 Get _oItem Var _cDescri Size 300,010 Of _oDlg Pixel WHEN .F.

    
        //+---------------------------------------------------------------------+
        //|                          DADOS DA NOTA FISCAL                       |
        //+---------------------------------------------------------------------+
        // Cria o grupo
        @ 63,10 GROUP oGrp TO 110,540 LABEL "NOTA FISCAL" PIXEL

        @075,020 Say 'Nota Fiscal:' Of _oDlg Pixel
        @072,090 Get _oEtapaAtu Var _cNumNota Size 40,010 Of _oDlg Pixel WHEN .F.

        @075,150 Say  'Serie:'  Of _oDlg Pixel
        @072,180 Get _oCliente Var _cSerie Size 20,010 Of _oDlg Pixel WHEN .F.

        @075,220 Say  'Cliente:'  Of _oDlg Pixel
        @072,250 Get _oXItemP Var _cCodCli Size 30,010 Of _oDlg Pixel WHEN .F.

        @075,290 Say  'Loja:'  Of _oDlg Pixel
        @072,320 Get _oQtdVen Var _cCodLoja Size 25,010 Of _oDlg Pixel WHEN .F.

        @075,380 Say  'Emissão:'  Of _oDlg Pixel
        @072,420 Get _oQtdVen Var _dEmissao Size 50,010 Of _oDlg Pixel WHEN .F.

        @095,020 Say  'Nome:'  Of _oDlg Pixel
        @092,090 Get _oQtdVen Var _cNomeCli Size 300,010 Of _oDlg Pixel WHEN .F.


        //+---------------------------------------------------------------------+
        //|                     DADOS DO PEDIDO DE VENDA                        |
        //+---------------------------------------------------------------------+
        // Cria o grupo
        @ 123,10 GROUP oGrp TO 168,540 LABEL "PEDIDO DE VENDA" PIXEL

        @135,020 Say  'Num. Pedido:'  Of _oDlg Pixel
        @132,090 Get _oQtdVen Var _cNumPed Size 30,010 Of _oDlg Pixel WHEN .F.    

        @135,150 Say  'Item:'  Of _oDlg Pixel
        @132,200 Get _oCliente Var _cItemPV Size 20,010 Of _oDlg Pixel WHEN .F.
    
        @135,250 Say  'Emissão:'  Of _oDlg Pixel
        @132,300 Get _oQtdVen Var _dEmisPV Size 50,010 Of _oDlg Pixel WHEN .F.

        @135,390 Say  'Tipo de Instalação:'  Of _oDlg Pixel
        @132,460 Get _oQtdVen Var _cTpInstal Size 60,010 Of _oDlg Pixel WHEN .F.

        @155,020 Say  'Data de Entrega:'  Of _oDlg Pixel
        @152,090 Get _oQtdVen Var _dDtEntreg Size 50,010 Of _oDlg Pixel WHEN .F.

        //+---------------------------------------------------------------------+
        //|                   DADOS DO ORÇAMENTO DE VENDA                       |
        //+---------------------------------------------------------------------+
        // Cria o grupo
        @ 183,10 GROUP oGrp TO 211,540 LABEL "ORÇAMENTO DE VENDA" PIXEL

        @195,020 Say  'Num. Orçamento:'  Of _oDlg Pixel
        @192,090 Get _oQtdVen Var _cNumOrc Size 50,010 Of _oDlg Pixel WHEN .F.

        @195,150 Say  'Emissão:'  Of _oDlg Pixel
        @192,200 Get _oQtdVen Var _dEmisOrc Size 50,010 Of _oDlg Pixel WHEN .F.

        //+---------------------------------------------------------------------+
        //|                   DADOS DA ORDEM DE PRODUÇÃO                        |
        //+---------------------------------------------------------------------+
        // Cria o grupo
        @ 223,10 GROUP oGrp TO 250,540 LABEL "PRODUÇÃO" PIXEL

        @235,020 Say  'Ordem de Produção:'  Of _oDlg Pixel
        @232,090 Get _oQtdVen Var _cNumOp Size 50,010 Of _oDlg Pixel WHEN .F.

        @235,150 Say  'Produzido Em:'  Of _oDlg Pixel
        @232,200 Get _oQtdVen Var _dEmisProd Size 50,010 Of _oDlg Pixel WHEN .F.

        @235,260 Say  'Armazem:'  Of _oDlg Pixel
        @232,310 Get _oCliente Var _cCodLocal Size 20,010 Of _oDlg Pixel WHEN .F.

        //+---------------------------------------------------------------------+
        //|                        DADOS DA QUALIDADE                           |
        //+---------------------------------------------------------------------+
        // Cria o grupo
        @ 263,10 GROUP oGrp TO 293,540 LABEL "QUALIDADE" PIXEL

        @275,020 Say  'Status Qualidade:'  Of _oDlg Pixel
        @272,090 Get _oQtdVen Var _cStatusCQ Size 50,010 Of _oDlg Pixel WHEN .F.

        @275,150 Say  'Usuário:'  Of _oDlg Pixel
        @272,200 Get _oQtdVen Var _cUserCQ Size 50,010 Of _oDlg Pixel WHEN .F.

        @275,260 Say  'Aprovação:'  Of _oDlg Pixel
        @272,310 Get _oCliente Var _cEmisCQ Size 50,010 Of _oDlg Pixel WHEN .F.

        //-------------------------------------------------------------------------

        @015,550 BUTTON "Limpar"    SIZE 040, 015 PIXEL OF _oDlg ACTION (MA05ClrVar(.T.))
        @035,550 BUTTON "Sair"      SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
        
//      @055,550 BUTTON "Anexar"        SIZE 040, 015 PIXEL OF _oDlg ACTION (MA05Anexar())
//      @075,550 BUTTON "Vis. Anexo"    SIZE 040, 015 PIXEL OF _oDlg ACTION (M05AVisAne())
        
//		@095,550 BUTTON "Estornar"		SIZE 040, 015 PIXEL OF _oDlg ACTION (M05AEST(_cPedido,_cItem))
        
    Activate MsDialog _oDlg  Centered
Return


//+---------------------------------------------------------------------------------
//+---------------------------------------------------------------------------------
//+---------------------------------------------------------------------------------
//+---------------------------------------------------------------------------------]
//+---------------------------------------------------------------------------------
Static Function M05AOk()

    If M05AValid()
        _cCodPro   := Posicione("SB1",1,xFilial("SB1")+AllTrim(ZAB->ZAB_CODPRO),"B1_COD")
        _cDescri   := Posicione("SB1",1,xFilial("SB1")+AllTrim(ZAB->ZAB_CODPRO),"B1_DESC")
        _cNumNota  := ZAB->ZAB_NOTA
        _cNumPed   := ZAB->ZAB_NUMPV
        _cItemPV   := ZAB->ZAB_ITEMPV
        _cSerie    := Posicione("SF2",1,xFilial("SF2")+AllTrim(ZAB->ZAB_NOTA),"F2_SERIE")
        _cCodCli   := SF2->F2_CLIENTE
        _cCodLoja  := SF2->F2_LOJA
        _dEmissao  := SF2->F2_EMISSAO
        _cNomeCli  := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")
        _dEmisPV   := Posicione("SC5",1,xFilial("SC5")+AllTrim(ZAB_NUMPV),"C5_EMISSAO")
        _cTpInstal := SC5->C5_XTPINST
        _dDtEntreg := SC5->C5_FECENT
        _cNumOrc   := SC5->C5_XNUNORC
        _dEmisOrc  := Posicione('SCJ',1,xFilial('SCJ')+SC5->C5_XNUNORC,'CJ_EMISSAO')
        _cCodTab   := SCJ->CJ_TABELA
        _dEmisOrc  := SCJ->CJ_EMISSAO
        _cNumOp    := Posicione("SD3",18,xFilial('SD3')+_cNumSer,'D3_OP')
        _dEmisProd := SD3->D3_EMISSAO
        _cCodLocal := SD3->D3_LOCAL
        _cStatusCQ := Posicione("SD7",4,xFilial("SD7")+ZAB->ZAB_NUMSER,"D7_TIPO")
        _cUserCQ   := SD7->D7_USUARIO
        _cEmisCQ   := SD7->D7_DATA
        _cGarant   := IIF((_dEmissao + 365) > dDataBase , "Sim" , "Nao" )

        If _cTpInstal == '1'
            _cTpInstal := 'Sem Instalação' 
        ElseIf _cTpInstal == '2'
            _cTpInstal := 'Credenciada' 
        ElseIf _cTpInstal == '3'
            _cTpInstal := 'Macom' 
        ElseIf _cTpInstal == '4'
            _cTpInstal := 'Macom Rateio Produto' 
        EndIf

        If _cStatusCQ == 1
           _cStatusCQ := 'Não Implantado'
        Else 
            _cStatusCQ := 'Não Implantado'
        Endif

        If Empty(_cNumNota)
            _cNumNota  := "Nao Faturado"
            _cSerie    := ""
            _cCodCli   := ""
            _cCodLoja  := ""
            _cCodLoja  := ""
            _dEmissao  := ""
            _cNomeCli  := ""
        Endif

        IF Empty(_cNumPed)
            _cNumPed   := "N.Alocado"
            _cItemPV   := ""
            _dEmisPV   := ""   
            _cTpInstal := ""
            _dDtEntreg := ""
        Endif 

        //MA05ClrVar(.T.)
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function MA05ClrVar(_lPV)
    Default _lPV := .T.

    If _lPV
        _cNumSer         := Space(TamSX3('B1_COD')[1])
        _cDescri         := Space(TamSX3('B1_DESC')[1])
        _cCodPro         := Space(TamSX3('B1_COD')[1])
        _cNumNota        := Space(TamSX3('F2_DOC')[1])
        _cSerie          := Space(TamSX3('F2_SERIE')[1])
        _cCodCli         := Space(TamSX3('F2_CLIENTE')[1])
        _cCodLoja        := Space(TamSX3('F2_LOJA')[1])
        _dEmissao        := Space(TamSX3('F2_EMISSAO')[1])
        _cNumPed         := Space(TamSX3('C5_NUM')[1])
        _cItemPV         := Space(TamSX3('ZAB_ITEMPV')[1])
        _dEmisPV         := Space(TamSX3('C5_EMISSAO')[1])
        _cTpInstal       := Space(TamSX3('C5_XTPINST')[1])
        _dDtEntreg       := Space(TamSX3('C5_FECENT')[1])
        _cNumOrc         := Space(TamSX3('C5_XNUNORC')[1])
        _dEmisOrc        := Space(TamSX3('CJ_EMISSAO')[1])
        _cNumOp          := Space(TamSX3('D3_OP')[1])
        _dEmisProd       := Space(TamSX3('D3_EMISSAO')[1])
        _cCodLocal       := Space(TamSX3('D3_LOCAL')[1])
        _cStatusCQ       := Space(TamSX3('D7_TIPO')[1])
        _cUserCQ         := Space(TamSX3('D7_USUARIO')[1])
        _cEmisCQ         := Space(TamSX3('D7_DATA')[1])
        _cNomeCli        := Space(TamSX3('A1_NOME')[1])
        _cGarant         := Space(5)
    EndIf

    _cItem      := Space(TamSX3('C6_ITEM')[1])
    _cObsEng    := ''
    _cObsCom    := ''
    _cXItemP    := ''
    _nQtdVen    := ''
    _cEtapaAtu  := ''
Return

//+---------------------------------------------------------------------------------
Static Function M05AValid()
    Local _lRet  := .F.

    If !(_lRet := !Empty(_cNumSer))
        MsgInfo('É obrigatório informar o numero de série.' + CRLF + 'Verifique.')
    EndIf

    dbSelectArea("ZAB")
    dbSetOrder(1)

    If ! ZAB->(MsSeek(xFilial('ZAB')+_cNumSer))
        MsgInfo('Numero de série não encontrado.' + CRLF + 'Verifique.')
        _lRet := .F.
    EndIf

Return _lRet
//+---------------------------------------------------------------------------------
