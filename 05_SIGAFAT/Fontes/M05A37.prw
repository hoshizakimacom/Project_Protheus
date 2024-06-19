#Include 'Protheus.ch'

Static _cPedido     := ''
Static _cXItemP     := ''
Static _cObsEng     := ''
Static _cObsCom     := ''
Static _cEtapa      := ''
Static _cUsuario    := ''
Static _cCliente    := ''
Static _cItem       := ''
Static _nQtdVen     := 0
Static _cEtapaAtu   := ''
Static _nRecSC5     := 0
Static _cItemAte    := Space(2)


//+------------------------------------------------------------------------------------------------------------------------
//  Apontamento de Etapa Engenharia
//+------------------------------------------------------------------------------------------------------------------------
//
User Function M05A37()
    Local _oDlg         := Nil
    Local _cTitle       := 'Apontamento do Departamento de Engenharia.'
    Local _oEtapa       := Nil
    Local _oUsuario     := Nil
    Local _oEtapaAtu    := Nil
    Local _aEtapas      := {'','2 - Eng. Liberado'}
    Local _aUsuario     := {'','Usuario 01','Usuario 02','Usuario 03','Usuario 04','Usuario 05',}
    Local _oObsEng      := Nil
    Local _oPedido      := Nil
    Local _oItem        := Nil
    Local _oItemAte     := NIL
    Local _oXItemP      := Nil
    Local _oQtdVen      := Nil
    Local _oCliente     := Nil
    Local _bConf        := {||( M05AGetObs())}
    Local _oScr1        := Nil
    Local _aSize        := FWGetDialogSize(oMainWnd)

    MA05ClrVar(.T.)

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME  From _aSize[1],_aSize[2] To _aSize[3],_aSize[4] Pixel
        @015,020 Say  'Pedido:' Of _oDlg Pixel
        @012,090 Get _oPedido Var _cPedido Size 100,011 Of _oDlg Pixel Valid (Empty(_cPedido) .Or. ExistCpo('SC5',_cPedido))

        _oPedido:bLostFocus := _bConf

        @032,020 Say  'Sequ�ncia:' Of _oDlg Pixel
        @029,090 Get _oItem Var _cItem Size 50,010 Of _oDlg Pixel Valid (Empty(_cItem) .Or. Empty(_cPedido) .Or. ExistCpo('SC6',_cPedido + _cItem))

        @032,160 Say  'At�:' Of _oDlg Pixel
        @029,200 Get _oItemAte Var _cItemAte Size 50,010 Of _oDlg Pixel Valid (Empty(_cItemAte) .Or. Empty(_cPedido) .Or. ExistCpo('SC6',_cPedido + _cItemAte))
       
        @032,280 Say  'Usuario:' Of _oDlg Pixel
        _oUsuario := TComboBox():New(029,310,{|u|if(PCount()>0,_cUsuario:=u,_cUsuario)},_aUsuario,80,13,_oDlg,,,,,,.T.,,,,,,,,,'_cUsuario')

        _oItem:bLostFocus := _bConf

        @045,020 Say  'Etapa:' Of _oDlg Pixel
        _oEtapa := TComboBox():New(045,090,{|u|if(PCount()>0,_cEtapa:=u,_cEtapa)},_aEtapas,100,40,_oDlg,,,,,,.T.,,,,,,,,,'_cEtapa')

        @075,020 Say 'Etapa Atual:' Of _oDlg Pixel
        @072,090 Get _oEtapaAtu Var _cEtapaAtu Size 300,010 Of _oDlg Pixel WHEN .F.

        @090,020 Say  'Cliente:'  Of _oDlg Pixel
        @087,090 Get _oCliente Var _cCliente Size 300,010 Of _oDlg Pixel WHEN .F.

        @105,020 Say  'Item:'  Of _oDlg Pixel
        @102,090 Get _oXItemP Var _cXItemP Size 100,010 Of _oDlg Pixel WHEN .F.

        @120,020 Say  'Quantidade'  Of _oDlg Pixel
        @117,090 Get _oQtdVen Var Transform(_nQtdVen,"@E 999,999.9999")    Size 100,010 Of _oDlg Pixel WHEN .F.
    
        @140,020 Say  'Descr. Pedido:' Of _oDlg Pixel
        _oScr1 := TScrollBox():New(_oDlg,140,090,060,300,.T.,.T.,.T.)
        @005,005 Say {||_cObsCom} Size 280,060 Of _oScr1 Pixel

        @210,020 Say  'Obs. Engenharia:' Of _oDlg Pixel
        @210,090 Get _oObsEng Var _cObsEng Memo Size 300,060 Of _oDlg Pixel

        @015,550 BUTTON "Confirmar"     SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(!Empty(_cPedido),(M05AOk()), ))
        @035,550 BUTTON "Cancelar"      SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
        
        @055,550 BUTTON "Anexar"        SIZE 040, 015 PIXEL OF _oDlg ACTION (MA05Anexar())
        @075,550 BUTTON "Vis. Anexo"    SIZE 040, 015 PIXEL OF _oDlg ACTION (M05AVisAne())
        
		@095,550 BUTTON "Estornar"		SIZE 040, 015 PIXEL OF _oDlg ACTION (M05AEST(_cPedido,_cItem))
        
		//@ 125, 550 RADIO oRadio VAR _nRadio 3D SIZE 70, 11 PROMPT "Teste1","Teste2","Teste3" of _oDlg PIXEL 

    Activate MsDialog _oDlg  Centered
Return


//+---------------------------------------------------------------------------------
Static Function MA05Anexar()
    Local _cMascara     := 'Todos os arquivos|*.*'
    Local _cTitulo      := 'Escolha o arquivo'
    Local _nMascpad     := 0
    Local _cDirOri      := 'C:\'
    Local _cDirDes      := AllTrim(GetMv('AM_05A21_A',.T.,''))
    Local _lSalvar      := .F. /*.F. = Salva || .T. = Abre*/
    Local _nOpcoes      := GETF_LOCALHARD
    Local _lArvore      := .F. /*.T. = apresenta o �rvore do servidor || .F. = n�o apresenta*/
    Local _lOk          := .F.

    If !Empty(_cPedido) .And. !Empty(_cItem)
        SC6->(DbSetOrder(1))
        SC6->(DbGoTop())

        If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
            If Empty(_cDirDes)
                MsgInfo(I18N('� obrigat�rio informar o diret�rio de armazenamento no par�metro AM_05A21_A.'))
            Else
                _cDirDes    += AllTrim( SC6->C6_FILIAL + SC6->C6_NUM +  SC6->C6_ITEM + SC6->C6_PRODUTO) + '\'
                _cDirOri    := cGetFile( _cMascara, _cTitulo, _nMascpad, _cDirOri, _lSalvar, _nOpcoes, _lArvore)

                If !Empty(_cDirOri)
                    _aFiles := Directory(_cDirOri, "D")

                    If !(_lOk := !File(_cDirDes + _aFiles[1][1]))
                        If MsgYesNo('Arquivo j� anexado para esta sequ�ncia do pedido de venda.' + CRLF + 'Deseja atualizar?')
                            If !(_lOk := FErase(_cDirDes + _aFiles[1][1]) <> -1)
                                MsgInfo('Erro ao apagar arquivo: ' + STR(FERROR()))
                            EndIf
                        EndIf
                    EndIf

                    If _lOk
                        MakeDir(_cDirDes)
                        __CopyFile(_cDirOri,_cDirDes + _aFiles[1][1])

                        If File(_cDirDes + _aFiles[1][1])
                            MsgInfo('Arquivo anexado com sucesso!')
                        Else
                            MsgInfo('Erro ao anexar arquivo.')
                        EndIf
                    EndIf
                Else
                    MsgInfo('Arquivo n�o informado!')
                EndIf
            EndIf

        Else
            MsgInfo(I18N('Pedido #1 e sequ�ncia #2 n�o localizados para anexar arquivo.',{_cPedido,_cItem}))
        EndIf
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M05AVisAne()
        Local _cDir     := AllTrim(GetMv('AM_05A21_A',.T.,''))

    If !Empty(_cPedido) .And. !Empty(_cItem)
        SC6->(DbSetOrder(1))
        SC6->(DbGoTop())

        If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
            If Empty(_cDir)
                MsgInfo('� obrigat�rio informar o diret�rio de armazenamento no par�metro AM_05A21_A.')
            Else
                _cDir   += AllTrim( SC6->C6_FILIAL + SC6->C6_NUM +  SC6->C6_ITEM + SC6->C6_PRODUTO) + '\'

                If ExistDir(_cDir)
                    WinExec('explorer.exe ' + _cDir)
                Else
                    MsgInfo(I18N('N�o foram encontrados anexos para o pedido #1 e sequencia #2 .',{_cPedido,_cItem}))
                EndIf
            EndIf
        Else
            MsgInfo(I18N('Pedido #1 e sequ�ncia #2 n�o localizados para anexar arquivo.',{_cPedido,_cItem}))
        EndIf
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M05AGetObs()

    If !Empty(_cPedido)
        SC5->(DbSetOrder(1))
        SC5->(DbGoTop())

        If SC5->(DbSeek(xFilial('SC5') + _cPedido))
            _cCliente   := AllTrim(Posicione('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_NOME'))
            _nRecSC5     := SC5->(Recno())

            If !SC5->(DBRLock(_nRecSC5))
                 MsgStop(I18N('Pedido #1 n�o pode ser alterado pois encontra-se em manuten��o por outro usu�rio.',{_cPedido}))
                 MA05ClrVar(.T.)
            EndIf
        Else
            MsgStop(I18N('Pedido #1 n�o localizado.',{_cPedido}))
            MA05ClrVar(.T.)
        EndIf
    Else
        MA05ClrVar(.T.)
    EndIf

    If !Empty(_cItem)
        If !Empty(_cPedido)
            SC6->(DbSetOrder(1))
            SC6->(DbGoTop())

            If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
                _cObsEng    := SC6->C6_XOBSENG
                _cObsCom    := Posicione('SB1',1,xFilial('SB1') + SC6->C6_PRODUTO, 'B1_DESC')

                _cXItemP    := SC6->C6_XITEMP
                _nQtdVen    := SC6->C6_QTDVEN
                _cEtapaAtu  := MA05GetEt()
            Else
                MsgStop(I18N('Pedido #1 e Sequencia #2 n�o localizados.',{_cPedido,_cItem}))
                MA05ClrVar(.F.)
            EndIf
        EndIf
    Else
        MA05ClrVar(.F.)
    EndIf
Return

//+---------------------------------------------------------------------------------]
Static Function MA05GetEt()
    Local _cRet := ''

    _cRet := Posicione("ZA3",1,XFILIAL("ZA3") + SC6->C6_XETAPA,"ZA3_DESCRI")

Return _cRet

//+---------------------------------------------------------------------------------
Static Function M05AOk()
    Local _cXEtapa  := ''
    Local _cCpData  := ''
    Local _cCpHora  := ''
    Local _cCpUser  := ''
    Local nItemDe   := 0
    Local nItemAte  := 0
    Local nIX       := 0
    Local cItem     := ""
    //Local aRetItem  := {}
    //Local aRetErro  := {}

    //If M05AValid() comentado por claudio ambrosini
        SC6->(DbGoTop())
        SC6->(DbSetOrder(1))

        if !empty(_cItem) .and. !empty(_cItemAte)

            nItemDe     := val(_cItem)
            nItemAte    := val(_cItemAte)

            For nIX := nItemDe To nItemAte
                cItem       := strzero(nIX,2)

                //aAdd(aRetItem, {_cPedido,cItem})
                If M05AValid(cItem) //ADD POR CLAUDIO AMBROSINI PARA VALIDAR CADA ITEM QUE PASSAR NO LOOP (COMENTADO LINHA 242) - INCLUSAO DE PARAMETRO "ITEM"
                
                    If SC6->(DbSeek(xFilial('SC6') + _cPedido + cItem))
                        DO CASE
                            CASE  SubStr(_cEtapa,1,1) == '1' //add por claudio ambrosini em 29092022
                                    _cXEtapa    := '1'  // 'Entrada Engenharia
                                    _cCpData    := 'C6_XENTENG' // 
                                    _cCpHora    := 'C6_XHREENG' // 
                                    _cCpUser    := 'C6_XUSENEN' // 
                            CASE  SubStr(_cEtapa,1,1) == '2' //add por claudio ambrosini em 29092022
                                    _cXEtapa    := '2'  // 'Lib Dep Engenharia
                                    _cCpData    := 'C6_XDTLIEN' // 
                                    _cCpHora    := 'C6_XHRLIBE' // 
                                    _cCpUser    := 'C6_XUSUENG' // 
                        ENDCASE                        

                        If !Empty(_cEtapa)
                            RecLock('SC6',.F.)
                                SC6->C6_XETAPA  	:= _cXEtapa
                                SC6->&(_cCpData)    := dDataBase
                                SC6->&(_cCpHora)    := Time()
                                If  !Empty(_cUsuario)
                                    SC6->&(_cCpUser)    := Upper(_cUsuario)
                                Else
                                    SC6->&(_cCpUser)    := Upper(UsrRetName(RetCodUsr()))
                                EndIf
                                SC6->C6_XOBSENG 	:= _cObsEng
                            SC6->(MsUnLock())

                            //MsgInfo('Etapa apontada com sucesso!','OK') // Contado por Claudio Ambrosini em 19/10/22 para sair do loop add na linha 298

                            MA05ClrVar(.F.)
                        EndIf

                    Else
                        //aAdd(aRetErro, {_cPedido,cItem})
                        MsgStop(I18N('Pedido #1 e Sequencia #2 n�o localizados.',{_cPedido,cItem}))
                    EndIf

                EndIf //add claudio ambrosini

            next nIX

            MsgInfo('Etapa(s) permitida(s) apontada(s) com sucesso!','OK')  // add por claudio ambrosini em 19/10/22     
        
        elseif !empty(_cItem)

            If SC6->(DbSeek(xFilial('SC6') + _cPedido + _cItem))
                    DO CASE
                         CASE  SubStr(_cEtapa,1,1) == '1' //add por claudio ambrosini em 29092022
                                _cXEtapa    := '1'  // 'Entrada Engenharia
                                _cCpData    := 'C6_XENTENG' // 
                                _cCpHora    := 'C6_XHREENG' // 
                                _cCpUser    := 'C6_XUSENEN' // 
                        CASE  SubStr(_cEtapa,1,1) == '2' //add por claudio ambrosini em 29092022
                                _cXEtapa    := '2'  // 'Lib Dep Engenharia
                                _cCpData    := 'C6_XDTLIEN' // 
                                _cCpHora    := 'C6_XHRLIBE' // 
                                _cCpUser    := 'C6_XUSUENG' // 
                    ENDCASE                        

                If !Empty(_cEtapa)
                    RecLock('SC6',.F.)
                        SC6->C6_XETAPA  	:= _cXEtapa
                        SC6->&(_cCpData)    := dDataBase
                        SC6->&(_cCpHora)    := Time()
                        If  !Empty(_cUsuario)
                            SC6->&(_cCpUser)    := Upper(_cUsuario)
                        Else
                            SC6->&(_cCpUser)    := Upper(UsrRetName(RetCodUsr()))
                        EndIf
                        SC6->C6_XOBSENG 	:= _cObsEng
                    SC6->(MsUnLock())

                    MsgInfo('Etapa apontada com sucesso!','OK')

                    MA05ClrVar(.F.)
                EndIf

            Else
                MsgStop(I18N('Pedido #1 e Sequencia #2 n�o localizados.',{_cPedido,_cItem}))
            EndIf

        endif

    //EndIf comentado por claudio ambrosini
    
Return

//+---------------------------------------------------------------------------------
Static Function MA05ClrVar(_lPV)
    Default _lPV := .T.

    If _lPV
        _cPedido         := Space(TamSX3('C6_NUM')[1])
        _cEtapa          := ''
        _cCliente        := ''

        If _nRecSC5 > 0
              SC5->(DBRUnlock(_nRecSC5))
        EndIf

        _nRecSC5      := 0
    EndIf

    _cItem      := Space(TamSX3('C6_ITEM')[1])
    _cItemAte   := Space(TamSX3('C6_ITEM')[1])
    _cObsEng    := ''
    _cObsCom    := ''
    _cXItemP    := ''
    _nQtdVen    := ''
    _cEtapaAtu  := ''
Return

//+---------------------------------------------------------------------------------
Static Function M05AValid(_cItem) //ADD ITEM COMO PARAMETRO POR CLAUDIO AMBROSINI 
    Local _lRet             := .F.
    //Local _cPedCancel       := AllTrim(GetMv('AM_05A21_B',.T.,''))//Contem o pedido e item com permissao para cancelamento 
    Local _cAtuDes          := ''

    If !(_lRet := !Empty(_cPedido) .And. !Empty(_cItem) .And. !Empty(_cEtapa))
        MsgInfo('� obrigat�rio informar Pedido, Sequ�ncia e Etapa.' + CRLF + 'Verifique.')
    Else
        /*If SubStr(_cEtapa,1,1) == 'D' // Cancelado
            If !(_lRet := AllTrim(_cPedido + _cItem) == _cPedCancel)
                MsgInfo('Para cancelamento � necess�rio autoriza��o pr�via da Diretoria.')
            EndIf
        EndIf*/
    EndIf

    // Valida ordem de etapa
    If _lRet
        _lRet := U_M05A22(SubStr(_cEtapa,1,1) ,_cPedido,_cItem,@_cAtuDes)

        If ! _lRet
            MsgInfo(I18N('Apontamento n�o permitido.' + CRLF + CRLF + 'Motivo: Item ' + ' ' +_cItem + ' ' + 'j� encontra-se na etapa #1 .',{AllTrim(_cAtuDes)})) //ADD INFORMACOES DE ITEM NA MENSAGEM POR CLAUDIO AMBROSINI
        EndIf
    EndIf

Return _lRet
//+---------------------------------------------------------------------------------
Static Function M05AEST(_cPedido,_cItem)
	_nOpc	:= 0
    cUserLib := RetCodUsr()

	dbSelectArea("SC2")
	dbSetOrder(1)

    if cUserLib $ '000075|000484'

        if !Empty(_cItem) .and. !Empty(_cPedido)

            if RecLock('SC6',.F.)
                SC6->C6_XETAPA		:= " "
                SC6->C6_XMEDDT		:= dDataBase
                SC6->C6_XMEDHR		:= Time()
                SC6->C6_XMEDUS		:= Upper(UsrRetName(RetCodUsr()))

                SC6->(MsUnLock())
            ENDIF

            MsgInfo( "Estorno efetuado com sucesso !" , "SUCESSO" )

        else

            if Empty(_cItem)

                MsgAlert( "Informe o item do pedido!" , "ATEN��O !!" )

            else

                if Empty(_cPedido)
                
                    MsgAlert( "Informe o numero do pedido!" , "ATEN��O !!" )

                endif

            ENDIF

        ENDIF

    else
        If SC2->(MsSeek(xFilial("SC2")+_cPedido+_cItem))
            MsgStop( "J� existe ordem de produ��o gerada para o Pedido / Item !" , "ATEN��O !!" )
        Else
            Do Case
                Case Empty(_cPedido)
                    MsgAlert( "Informe o numero do pedido!" , "ATEN��O !!" )
                Case Empty(_cItem)
                    MsgAlert( "Informe o item do pedido!" , "ATEN��O !!" )
                Case Empty(_cEtapa) .And. _cEtapaAtu == "Tec Com Lib "
                    RecLock('SC6',.F.)
                    SC6->C6_XETAPA		:= " "
                    SC6->C6_XMEDDT		:= dDataBase
                    SC6->C6_XMEDHR		:= Time()
                    SC6->C6_XMEDUS		:= Upper(UsrRetName(RetCodUsr()))
                    SC6->(MsUnLock())
                    _cEtapaAtu := " "
                    MsgInfo( "Estorno efetuado com sucesso !" , "SUCESSO" )
                Case _cEtapaAtu <> "Tec Com Lib "
                    MSGALERT( "S� � poss�vel efetuar o estorno da etapa (Tec.Com.Lib.)" , "ATEN��O !!" )
            EndCase
        Endif
    ENDIF

Return
