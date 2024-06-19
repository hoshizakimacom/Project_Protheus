#Include 'Protheus.ch'

Static _nPeso		:= 0
Static _nVolume		:= 0
Static _nFrete		:= 0
Static _nRecSC5     := 0
Static _cPedido     := ''
Static _cCliente    := ''


//+------------------------------------------------------------------------------------------------------------------------
//  Apontamento Almoxarifado
//+------------------------------------------------------------------------------------------------------------------------
User Function M02A05()
    Local _oDlg         := Nil
    Local _cTitle       := 'Apontamento Almoxarifado.'
       
    Local _oPedido      := Nil
    Local _oPeso        := Nil
    Local _oVolume      := Nil
    Local _oFrete		:= Nil
    Local _oCliente     := Nil
    Local _bConf        := {||( M05AGetObs())}
    Local _aSize        := FWGetDialogSize(oMainWnd)
    Private _oScr1        := Nil

    MA05ClrVar(.T.)

    Define MsDialog _oDlg Title _cTitle Style DS_MODALFRAME  From _aSize[1],_aSize[2] To _aSize[3],_aSize[4] Pixel
        @015,020 Say  'Pedido:' Of _oDlg Pixel
        @012,090 Get _oPedido Var _cPedido Size 100,011 Of _oDlg Pixel Valid (Empty(_cPedido) .Or. ExistCpo('SC5',_cPedido))

        _oPedido:bLostFocus := _bConf

        @032,020 Say  'Peso:' Of _oDlg Pixel
        @029,090 Get _oPeso Var _nPeso Picture "@E 999,999.99" Size 100,010 Of _oDlg Pixel
        
        @049,020 Say  'Volume:' Of _oDlg Pixel
        @046,090 Get _oVolume Var _nVolume Picture "@E 999,999" Size 100,010 Of _oDlg Pixel 

        @066,020 Say 'Frete:' Of _oDlg Pixel
        @063,090 Get _oFrete Var _nFrete Picture "@E 999,999.99" Size 100,010 Of _oDlg Pixel 

        @090,020 Say  'Cliente:'  Of _oDlg Pixel
        @087,090 Get _oCliente Var _cCliente Size 300,010 Of _oDlg Pixel WHEN .F.

        @015,550 BUTTON "Confirmar"     SIZE 040, 015 PIXEL OF _oDlg ACTION (IIF(!Empty(_cPedido),(M05AOk()), ))
        @035,550 BUTTON "Cancelar"      SIZE 040, 015 PIXEL OF _oDlg ACTION (_oDlg:End())
        
    Activate MsDialog _oDlg  Centered
Return

//+---------------------------------------------------------------------------------
//+---------------------------------------------------------------------------------
//+---------------------------------------------------------------------------------
Static Function M05AGetObs()

    If !Empty(_cPedido)
        SC5->(DbSetOrder(1))
        SC5->(DbGoTop())

        If SC5->(DbSeek(xFilial('SC5') + _cPedido))
            _cCliente   := AllTrim(Posicione('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_NOME'))
            _nRecSC5     := SC5->(Recno())

            If !SC5->(DBRLock(_nRecSC5))
                 MsgStop(I18N('Pedido #1 não pode ser alterado pois encontra-se em manutenção por outro usuário.',{_cPedido}))
                 MA05ClrVar(.T.)
            EndIf
        Else
            MsgStop(I18N('Pedido #1 não localizado.',{_cPedido}))
            MA05ClrVar(.T.)
        EndIf
    EndIf

Return

//+---------------------------------------------------------------------------------]
//+---------------------------------------------------------------------------------
Static Function M05AOk()

    If M05AValid()
        SC5->(DbGoTop())
        SC5->(DbSetOrder(1))

        If SC5->(DbSeek(xFilial('SC5') + _cPedido))

	        RecLock('SC5',.F.)

			If Empty(SC5->C5_PBRUTO)
				SC5->C5_PBRUTO	:= _nPeso
			Endif
			
			If Empty(SC5->C5_VOLUME1)
        		SC5->C5_VOLUME1	:= _nVolume
        	Endif
        	
        	If Empty(SC5->C5_FRETE)
        		SC5->C5_FRETE	:= _nFrete
        	Endif 

            SC5->(MsUnLock())

            MsgInfo('Etapa apontada com sucesso!','OK')

            MA05ClrVar(.T.)
         Else
            MsgStop(I18N('Pedido #1 não localizado.',{_cPedido}))
        EndIf
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function MA05ClrVar(_lPV)
    Default _lPV := .T.

    If _lPV
        _cPedido    := Space(TamSX3('C6_NUM')[1])
        _nPeso      := 0
        _nVolume    := 0
		_nFrete		:= 0
		_cCliente   := ''

        If _nRecSC5 > 0
              SC5->(DBRUnlock(_nRecSC5))
        EndIf

        _nRecSC5      := 0
    EndIf

Return

//+---------------------------------------------------------------------------------
Static Function M05AValid()
    Local _lRet             := .F.

    If !(_lRet := !Empty(_cPedido))
        MsgInfo('É obrigatório informar Pedido, Sequência e Etapa.' + CRLF + 'Verifique.')
    EndIf
    
Return _lRet
//+---------------------------------------------------------------------------------
