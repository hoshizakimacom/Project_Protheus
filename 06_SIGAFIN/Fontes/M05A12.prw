#Include 'Protheus.ch'

Static _cPedido1	:= ''
Static _cPedido2	:= ''
Static _cRAPre		:= ''

//+-----------------------------------------------------------------------------------
// Rotina respons�vel pela compensa��o de recebimento antecipado utilizando
// titulos a receber
// Chamada do PE MA410MNU
//+-----------------------------------------------------------------------------------
User Function M05A12(nTipo)
	Private _aArea			:= GetArea()
	Private _aOnlyFld1		:= {}
	Private _aOnlyFld2		:= {}
	Private _aFields1			:= {}
	Private _aFields2			:= {}

	Private _cAlias1			:= ''
	Private _cAlias2			:= ''
	Private _cArq1			:= ''
	Private _cArq2			:= ''
	Private _cMsg1			:= ''
	Private _cMsg2			:= ''
	Private _cPicture			:= '@E 9,999,999,999,999.99'
	Private _cTitle			:= 'Compensa��o de Cliente - '

	Private _nValor1			:= 0
	Private _nValor2			:= 0
	Private _nSaldo1			:= 0
	Private _nSaldo2			:= 0
	Private _nSaldoC1			:= 0
	Private _nSaldoC2			:= 0
	Private _nAtraso1         := 0
	Private _nAtraso2         := 0

	Private _oMark1			:= Nil
	Private _oMark2			:= Nil
	Private _oLayer 			:= Nil
	Private _oDlg				:= Nil
	Private _oPainel1			:= Nil
	Private _oPainel2			:= Nil
	Private _aSize			:= FWGetDialogSize(oMainWnd)
	Private _lReOpen			:= .F.
	Private oTFont           := TFont():New('Courier new',,-10,.F.)
    Private oDlgCli           := Nil
    Private lOk               := .F.
    Private cCliente			:= Space(TamSX3('A1_COD')[1])
    Private cLoja				:= Space(TamSX3('A1_LOJA')[1])

	Private _aStru			:= {}
	Private _cPictureC	:= '@!'
	Private _cPictureN	:= '@E 9,999,999,999,999.99'
	Private aRotina  		:= {}

    Default cCliente        := Space(TamSX3('A1_COD')[1])
    Default cLoja           := Space(TamSX3('A1_LOJA')[1])
    Default nTipo           := 1

	_cRAPre		:= AllTrim(GetMv('MV_X06A001',.F.,'PVA'))



    // Verifica se foi informado cliente e loja, caso nao tenha, exibe janela
    If nTipo > 1
        If Empty(cCliente) .Or. Empty(cLoja)
            Define MsDialog oDlgCli Title 'Compensa��o de Cliente' Style DS_MODALFRAME From 000,000 To 180,400 Pixel

                @020,020 Say  'Cliente:' Of oDlgCli Pixel
                @017,050 MsGet cCliente            Size 100,010 Of oDlgCli F3 'SA1' Pixel

                @040,020 Say  'Loja:' Of oDlgCli Pixel
                @037,050 MsGet cLoja            Size 100,010 Of oDlgCli  Pixel

                @070,055 BUTTON "Confirmar"     SIZE 040, 012 PIXEL OF oDlgCli ACTION ( lOk := .T.,oDlgCli:End() )
                @070,105 BUTTON "Cancelar"      SIZE 040, 012 PIXEL OF oDlgCli ACTION (oDlgCli:End())

            Activate MsDialog oDlgCli Centered
        Else
            lOk := .T.
        EndIf
    Else
        lOk := .T.
        cCliente    := SC5->C5_CLIENTE
        cLoja       := SC5->C5_LOJACLI
    EndIf


    If lOk
    	// Cria tabela tempor�ria
    	_aStru		:= M05AStru()
    	_cAlias1 	:= M05ATrab(_aStru,@_cArq1)									//| Cria tabela tempor�ria
    	_cAlias2 	:= M05ATrab(_aStru,@_cArq2)									//| Cria tabela tempor�ria

    	// Campos exibidos na tela
    	_aFields1	:= M05AGetFld(.T.)
    	_aFields2	:= M05AGetFld(.F.)

    	_aOnlyFld1	:= M05AGetOFl(_aStru,.T.)
    	_aOnlyFld2	:= M05AGetOFl(_aStru,.F.)

    	// Carrega tabela tempor�rio com titulos do
    	//	pedido / cliente-loja
    	M05ATab1In(_cAlias1,@_nValor1,@_nSaldo1,@_nSaldoC1,@_nAtraso1,cCliente,cLoja)					//|	Carrega Tabela Tempor�ria
    	M05ATab2In(_cAlias2,@_nValor2,@_nSaldo2,@_nSaldoC2,@_nAtraso2,cCliente,cLoja)					//|	Carrega Tabela Tempor�ria

    	DEFINE MSDIALOG _oDlg TITLE _cTitle + cCliente + ' - ' + cLoja FROM _aSize[1],_aSize[2] TO _aSize[3],_aSize[4] OF oMainWnd PIXEL
    		_oLayer 		:= FWLayer():new()
    		_oLayer:init(_oDlg,.T.)

    		_oLayer:addLine('PANEL1'	,50 	, .F. )
    		_oLayer:addLine('PANEL2'	,50 	, .T. )

    		// Tela 1 - Recebimento Antecipado
    		_oPainel1 	:= _oLayer:getLinePanel( 'PANEL1' )
    		_oMark1		:= FWMarkBrowse():New()

    		_cMsg1 := ' | VLR: ' + Transform(_nValor1,_cPicture) + '                  | SLD A REC.: ' + Transform(_nSaldo1,_cPicture) + '                  | SLD A COMP.: ' + Transform(_nSaldoC1,_cPicture) + '                  | SLD COMP.: ' + Transform(_nValor1 - _nSaldo1 - _nSaldoC1 ,_cPicture)  + '                  | VLR ATRASO: ' + Transform(_nAtraso1,_cPicture)
    		_cMsg2 := ' | VLR: ' + Transform(_nValor2,_cPicture) + '                  | SLD A REC.: ' + Transform(_nSaldo2,_cPicture) + '                  | VLR REC.: ' + Transform(_nValor2 - _nSaldo2,_cPicture) + '                  | VLR ATRASO: ' + Transform(_nAtraso2,_cPicture)

    		_oMark1:SetTemporary(.T.)
    		_oMark1:SetFontBrowse(oTFont)
    		_oMark1:SetAlias(_cAlias1)
    		_oMark1:SetDescription(_cMsg1 )
    		_oMark1:SetFields(_aFields1)
    		_oMark1:SetOnlyFields( _aOnlyFld1 )
    		_oMark1:SetFieldMark( 'E1_OK' )
    		_oMark1:AddLegend( 'E1_SALDO > 0 .AND. E1_VENCREA < Date()  '                                    ,'BR_CINZA'         ,'T�tulo vencido'  )
    		//_oMark1:AddLegend( 'E1_XSALDO >  0 '						                                    ,'BR_VERDE'  		,'T�tulo com saldo a compensar'  )
    		//_oMark1:AddLegend( 'E1_XSALDO <= 0 '						                                    ,'BR_VERMELHO'  	,'T�tulo sem saldo a compensar'  )
    		_oMark1:AddLegend( 'E1_SALDO >  0 '						                                    ,'BR_VERDE'  		,'T�tulo com saldo a compensar'  )
    		_oMark1:AddLegend( 'E1_SALDO <= 0 '						                                    ,'BR_VERMELHO'  	,'T�tulo sem saldo a compensar'  )

    		_oMark1:SetMenuDef('')
    		_oMark1:Activate(_oPainel1)

    		// Tela 2 - Duplicatas
    		_oPainel2 		:= _oLayer:getLinePanel( 'PANEL2' )
    		_oMark2			:= FWMarkBrowse():New()

    		_oMark2:SetTemporary(.T.)
    		_oMark2:SetAlias(_cAlias2)
    		_oMark2:SetDescription(_cMsg2)
    		_oMark2:SetFields(_aFields2)
    		_oMark2:SetOnlyFields( _aOnlyFld2 )
    		_oMark2:SetFieldMark( 'E1_OK' )
    		_oMark2:AddLegend( 'E1_SALDO > 0 .AND. E1_VENCREA < Date()  '                                      ,'BR_CINZA'       ,'T�tulo vencido'  )
    		_oMark2:AddLegend( 'E1_SALDO > 0 .AND. E1_SALDO == E1_VALOR '	                                  ,'BR_VERDE' 		,'Em Aberto'  )
    		_oMark2:AddLegend( 'E1_SALDO > 0 .AND. E1_SALDO <> E1_VALOR '	                                  ,'BR_AZUL'  		,'Parcialmente baixado'  )
    		_oMark2:AddLegend( 'E1_SALDO <= 0 '								                                  ,'BR_VERMELHO'  	,'Baixado'  )

    		_oMark2:SetMenuDef('')

    		_oMark2:AddButton('&Compensar'	, {||Processa({|| IIF(M05AComp(_cAlias1,_cAlias2,_oMark1,_oMark2),(_lReOpen := .T. ,_oDlg:End()),),'Aguarde...'}) },, 4)
    		_oMark2:AddButton('&Excluir'	, {|| IIF(M05AExcl(_cAlias2,_oMark2),(_lReOpen := .T. ,_oDlg:End()),) },, 4)
    		_oMark2:AddButton('&Sair'		, {||_lReOpen := .F.,_oDlg:End() },, 4)

    		_oMark2:Activate(_oPainel2)

    	ACTIVATE MSDIALOG _oDlg CENTERED

    	RestArea(_aArea)

    	_cPedido1	:= ''
    	_cPedido2	:= ''
    	_cRAPre		:= ''

    	// Excluir arquivos de trabalho
    	M05ADelTra(_cAlias1,_cArq1)
    	M05ADelTra(_cAlias2,_cArq2)
   EndIf
Return IIF(lOk,IIf(_lReOpen,U_M05A12(nTipo),.T.),.T.)

//+----------------------------------------------------------------------------------------
Static Function M05ADelTra(_cAlias,_cArq)
	If Select(_cAlias) > 0
		(_cAlias)->(DbCloseArea())
	EndIf

	FErase( _cArq + GetDbExtension() )
	FErase( _cArq + OrdBagExt())
Return

//+----------------------------------------------------------------------------------------
Static Function M05AComp(_cAlias1,_cAlias2,_oMark1,_oMark2)
	Local _lRet		:= .T.
	Local _nRecno1	:= 0
	Local _nRecno2	:= 0
	Local _nValRec	:= 0
	Local _cMsg		:= ''
	Local _cPicture	:= '@E 9,999,999,999,999.99'

	ProcRegua(3)
	IncProc('validando t�tulos...')

	_lRet := M05AValid(_cAlias1,_cAlias2,_oMark1,_oMark2,@_nRecno1,@_nRecno2,@_cMsg)

	// Baixa a NF por compensa��o
	If _lRet
		BeginTran()

		IncProc('Compensando t�tulo...')
		_lRet := M05ABaixa(_cAlias1,_cAlias2,_nRecno1,_nRecno2,@_nValRec)

		IncProc('Atualizando saldo...')
		If _lRet
			_lRet 		:= M05ASetRA(_nRecno1,-_nValRec)

			If _lRet
				_lRet 	:= M05ASetNF(_nRecno2,_cAlias1)
			EndIf
		EndIf

		If _lRet
			EndTran()
		Else
			DisarmTransaction()
		EndIf

		MsUnlockAll()
	EndIf

	If _lRet
		Aviso('Aten��o','Valor da compensa��o: ' + Transform(_nValRec,_cPicture) + CRLF + _cMsg,{'OK'},3)
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05ABaixa(_cAlias1,_cAlias2,_nRecno1,_nRecno2,_nValRec)
	Local _nOpc			:= 3 // 3 - Baixa de T�tulo, 5 - Cancelamento de baixa, 6 - Exclus�o de Baixa
	Local _aArray		:= {}
	Local _lRet			:= .T.

	_nValRec := 0

	// Posiciona nos registros
	M05AGoTo(_cAlias1,_nRecno1)
	M05AGoTo(_cAlias2,_nRecno2)

	//If (_cAlias1)->E1_XSALDO >=  (_cAlias2)->E1_SALDO
		_nValRec := (_cAlias2)->E1_SALDO
	//Else
	//	_nValRec := (_cAlias1)->E1_XSALDO
	//EndIf

	SE1->(DbGoTo(_nRecno2))

	_nValRec -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	AAdd(_aArray	,{'E1_PREFIXO'	,(_cAlias2)->E1_PREFIXO		,Nil})
	AAdd(_aArray	,{'E1_NUM'			,(_cAlias2)->E1_NUM		,Nil})
	AAdd(_aArray	,{'E1_PARCELA'	,(_cAlias2)->E1_PARCELA		,Nil})
	AAdd(_aArray	,{'E1_TIPO'		,(_cAlias2)->E1_TIPO		,Nil})
	AAdd(_aArray	,{'E1_CLIENTE'	,(_cAlias2)->E1_CLIENTE		,Nil})
	AAdd(_aArray	,{'E1_LOJA'		,(_cAlias2)->E1_LOJA		,Nil})
	AAdd(_aArray	,{'AUTMOTBX'		,'CMP'					,Nil})
	AAdd(_aArray	,{'AUTDTBAIXA'	,dDataBase					,Nil})
	AAdd(_aArray	,{'AUTDTCREDITO'	,dDataBase				,Nil})
	AAdd(_aArray	,{'AUTHIST'		,'Baixa por Compensacao'	,Nil})
	AAdd(_aArray	,{'AUTJUROS'		,0						,Nil})
	AAdd(_aArray	,{'AUTVALREC'		,_nValRec				,Nil})

	lMsErroAuto := .F.

	MSExecAuto({|x,y| Fina070(x,y)},_aArray,_nOpc)

	If lMsErroAuto
		_lRet := .F.
	   MostraErro()
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05ASetNF(_nRecno,_cAlias)
	Local _lRet	:= .F.

	SE1->(DbGoTo(_nRecno))

	If (_lRet := SE5->(!EOF()))
		RecLock('SE5',.F.)
			SE5->E5_DOCUMEN := (_cAlias)->E1_PREFIXO + (_cAlias)->E1_NUM + (_cAlias)->E1_PARCELA + (_cAlias)->E1_TIPO
		SE5->(MsUnLock())
	EndIf

	If !_lRet
		MsgInfo('Erro ao atualizar hist�rico compensado.' + CRLF + CRLF + 'Opera��o cancelada.','Aten��o')
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05ASetRA(_nRecno,_nVal)
	Local _lRet	:= .F.

	SE1->(DbGoTop())
	SE1->(DbGoTo(_nRecno))

	If SE1->(!EOF())
		//RecLock('SE1',.F.)
		//	SE1->E1_XSALDO	:= SE1->E1_XSALDO + _nVal
		//SE1->(MsUnlock())

		_lRet := .T.
	EndIf

	If !_lRet
		MsgInfo('Erro ao atualizar saldo a compensar.' + CRLF + CRLF + 'Opera��o cancelada.',"Aten��o")
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05AGoTo(_cAlias,_nRecno)

	(_cAlias)->(DbGoTop())

	While (_cAlias)->(!EOF())
		If _nRecno == (_cAlias)->E1_RECNO
			Exit
		EndIf

		(_cAlias)->(DbSkip())
	EndDo
Return

//+----------------------------------------------------------------------------------------
Static Function M05AValid(_cAlias1,_cAlias2,_oMark1,_oMark2,_nRecno1,_nRecno2,_cMsg)
	Local _lRet			:= .T.
	Local _cPedido1		:= ''
	Local _cPedido2		:= ''

	_cMsg				:= ''

	// Valida registro marcado na markbrowse 1 - Adiantamento
	// Valida se RA tem saldo
	If _lRet
		_lRet := M05AMark1(_cAlias1,_oMark1,@_nRecno1,@_cPedido1,@_cMsg)
	EndIf

	// Valida registro marcado na markbrowse 2 - NF
	If _lRet
		_lRet := M05AMark1(_cAlias2,_oMark2,@_nRecno2,@_cPedido2,@_cMsg)
	EndIf

	// Valida se pedidos s�o iguais
	If _lRet .And. !(_lRet := _cPedido1 == _cPedido2)
		MsgStop('Pedidos devem ser iguais.' + CRLF + 'Verifique.')
	EndIf

	If _lRet .And. !(_lRet := ( (_cAlias2)->E1_PORCJUR == 0 .And. (_cAlias2)->E1_VALJUR == 0))
		MsgStop('Taza Perman. e Porc Juros devem ser iguais a zero.' + CRLF + 'Verifique.')
	EndIf

	If _lRet .And. !(_lRet := ( AllTrim((_cAlias1)->E1_PREFIXO) == _cRAPre))
		MsgStop(I18N('Somente t�tulos com Prefixo #1 podem ser compensados.' + CRLF + 'Verifique.',{_cRAPre}))
	EndIf

Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05AMark1(_cAlias,_oMark,_nRecno,_cPedido,_cMsg)
	Local _lRet		:= .T.
	Local _lMark	:= .F.
	Local _lSaldo	:= .T.
	Local _cMark	:= _oMark:Mark()
	Local _nRec		:= (_cAlias)->(Recno())
	Local _aArea	:= GetArea()

	// Verifica se apenas um registro de cada tela foi marcado
	(_cAlias)->(DbGoTop())

	While (_cAlias)->(!EOF())

		If _oMark:IsInvert()
			If _cMark <> (_cAlias)->E1_OK
				If _lMark
					_lRet		:= .F.
					Exit
				Else
					_lMark 		:= .T.
					_nRecno 	:= (_cAlias)->E1_RECNO
					_cPedido	:= (_cAlias)->E1_PEDIDO

					_cMsg		+= 	CRLF + 'Prefixo: ' + (_cAlias)->E1_PREFIXO + ;
									CRLF + 'Tipo: ' + (_cAlias)->E1_TIPO + ;
									CRLF + 'Numero:  ' + (_cAlias)->E1_NUM + ' ' + (_cAlias)->E1_PARCELA  + CRLF;


					//If (_cAlias)->E1_PREFIXO == _cRAPre .And. !(_lSaldo := _lRet := (_cAlias)->E1_XSALDO > 0)
					If (_cAlias)->E1_PREFIXO == _cRAPre .And. !(_lSaldo := _lRet := (_cAlias)->E1_SALDO > 0)
						MsgStop('Recebimento n�o possui saldo a compensar.' + CRLF + 'Verifique.')
						Exit
					EndIf
				EndIf
			EndIf
		Else
			If _cMark == (_cAlias)->E1_OK
				If _lMark
					_lRet		:= .F.
					Exit
				Else
					_lMark 		:= .T.
					_nRecno 	:= (_cAlias)->E1_RECNO
					_cPedido	:= (_cAlias)->E1_PEDIDO
					_cMsg		+= 	CRLF + 'Prefixo: ' + (_cAlias)->E1_PREFIXO + ;
									CRLF + 'Tipo: ' + (_cAlias)->E1_TIPO + ;
									CRLF + 'Numero:  ' + (_cAlias)->E1_NUM + ' ' + (_cAlias)->E1_PARCELA  + CRLF;

					//If (_cAlias)->E1_PREFIXO == _cRAPre .And. !(_lSaldo := _lRet := (_cAlias)->E1_XSALDO > 0)
					If (_cAlias)->E1_PREFIXO == _cRAPre .And. !(_lSaldo := _lRet := (_cAlias)->E1_SALDO > 0)
						MsgStop('Recebimento n�o possui saldo a compensar.' + CRLF + 'Verifique.')
						Exit
					EndIf
				EndIf
			EndIf
		EndIf

		(_cAlias)->(DbSkip())
	EndDo

	If !_lRet .And. _lMark .And. _lSaldo
		MsgStop('Apenas um registro deve ser marcado.' + CRLF + 'Verifique.')
	EndIf

	If !_lMark
		_lRet := .F.
		MsgStop('� obrigat�rio marcar um registro.')
	EndIf

	_oMark:GoTo(_nRec,.F.)

	RestArea(_aArea)
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05ATab1In(_cAlias1,_nValor1,_nSaldo1,_nSaldoC1,_nAtraso1,cCliente,cLoja)
	Local _aRet			:= {}
	Local _aAux			:= {}
	Local _cAliasSE1	:= GetNextAlias()
	Private _dBaixa		:= CToD('  /  /  ')

	BeginSql Alias _cAliasSE1
		Column E1_EMISSAO as Date
		Column E1_VENCTO as Date
		Column E1_VENCREA as Date
		Column E1_BAIXA as Date
		Column E1_XDTFAT as Date
		Column E1_EMIS1 as Date
		SELECT		 E1_FILIAL		,E1_PREFIXO		,E1_NUM		,E1_PARCELA		,E1_TIPO
					,E1_VALOR		,E1_SALDO			,E1_XSALDO		,E1_PEDIDO			,E1_EMISSAO
					,E1_VENCTO		,E1_VENCREA		,E1_BAIXA		,E1_CLIENTE		,E1_LOJA
					,E1_NOMCLI		,E1_SITUACA		,E1_STATUS		,R_E_C_N_O_ AS E1_RECNO
					,E1_XDTFAT		,E1_VALJUR			,E1_PORCJUR	,E1_DESCONT		,E1_EMIS1
					,E1_JUROS
		FROM %Table:SE1% SE1
		WHERE E1_CLIENTE = %Exp:cCliente%  AND E1_LOJA = %Exp:cLoja%
			AND 	( E1_PREFIXO = %Exp:_cRAPre% OR E1_TIPO = 'RA ' OR E1_TIPO = 'NCC' OR E1_TIPO = 'CRA')
			AND SE1.%NotDel%
		ORDER BY  E1_FILIAL,E1_PEDIDO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO
	EndSql

	While (_cAliasSE1)->(!EOF())
		_aAux 			:= {}
		_nValor1 		+= (_cAliasSE1)->E1_VALOR

        If (_cAliasSE1)->E1_SALDO > 0 .And. (_cAliasSE1)->E1_VENCREA < Date()
            _nAtraso1    += (_cAliasSE1)->E1_SALDO
        EndIf


		RecLock(_cAlias1,.T.)
			(_cAlias1)->E1_RECNO	:= (_cAliasSE1)->E1_RECNO
			(_cAlias1)->E1_FILIAL	:= (_cAliasSE1)->E1_FILIAL
			(_cAlias1)->E1_PEDIDO	:= (_cAliasSE1)->E1_PEDIDO
			(_cAlias1)->E1_CLIENTE	:= (_cAliasSE1)->E1_CLIENTE
			(_cAlias1)->E1_LOJA		:= (_cAliasSE1)->E1_LOJA
			(_cAlias1)->E1_NOMCLI	:= (_cAliasSE1)->E1_NOMCLI

			(_cAlias1)->E1_PREFIXO	:= (_cAliasSE1)->E1_PREFIXO
			(_cAlias1)->E1_NUM		:= (_cAliasSE1)->E1_NUM
			(_cAlias1)->E1_PARCELA	:= (_cAliasSE1)->E1_PARCELA
			(_cAlias1)->E1_TIPO		:= (_cAliasSE1)->E1_TIPO

			(_cAlias1)->E1_VALOR	:= (_cAliasSE1)->E1_VALOR

			If AllTrim((_cAliasSE1)->E1_PREFIXO) <> _cRAPre .And. AllTrim((_cAliasSE1)->E1_TIPO) $ '|RA|NCC|CRA'
				(_cAlias1)->E1_SALDO	:= 0
				(_cAlias1)->E1_XSALDO	:= (_cAliasSE1)->E1_SALDO
				_nSaldoC1               += (_cAliasSE1)->E1_SALDO
			Else
				(_cAlias1)->E1_SALDO	:= (_cAliasSE1)->E1_SALDO
				(_cAlias1)->E1_XSALDO	:= 0 //(_cAliasSE1)->E1_XSALDO
				_nSaldoC1               += (_cAliasSE1)->E1_XSALDO
				_nSaldo1                += (_cAliasSE1)->E1_SALDO
			EndIf

			(_cAlias1)->E1_VALJUR	:= (_cAliasSE1)->E1_VALJUR
			(_cAlias1)->E1_PORCJUR	:= (_cAliasSE1)->E1_PORCJUR
			(_cAlias1)->E1_DESCONT	:= (_cAliasSE1)->E1_DESCONT

			(_cAlias1)->E1_EMISSAO	:= (_cAliasSE1)->E1_EMISSAO
			(_cAlias1)->E1_VENCTO	:= (_cAliasSE1)->E1_VENCTO
			(_cAlias1)->E1_VENCREA	:= (_cAliasSE1)->E1_VENCREA
			(_cAlias1)->E1_BAIXA	:= (_cAliasSE1)->E1_BAIXA
			(_cAlias1)->E1_SITUACA	:= (_cAliasSE1)->E1_SITUACA
			(_cAlias1)->E1_STATUS	:= (_cAliasSE1)->E1_STATUS
			(_cAlias1)->E1_XDTFAT	:= (_cAliasSE1)->E1_XDTFAT
			(_cAlias1)->E1_EMIS1	:= (_cAliasSE1)->E1_EMIS1
			(_cAlias1)->E1_JUROS	:= (_cAliasSE1)->E1_JUROS
		(_cAlias1)->(MsUnLock())

		(_cAliasSE1)->(DbSkip())
	EndDo

	(_cAliasSE1)->(DbCloseArea())
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------
Static Function M05ATab2In(_cAlias2,_nValor2,_nSaldo2,_nSaldoC2,_nAtraso2,cCliente,cLoja)
	Local _aRet			:= {}
	Local _aAux			:= {}
	Local _cAliasSE1	:= GetNextAlias()

	BeginSql Alias _cAliasSE1
		Column E1_EMISSAO as Date
		Column E1_VENCTO as Date
		Column E1_VENCREA as Date
		Column E1_BAIXA as Date
		Column E1_XDTFAT as Date
		Column E1_EMIS1 as Date
		SELECT		 E1_FILIAL		,E1_PREFIXO		,E1_NUM		,E1_PARCELA		,E1_TIPO
					,E1_VALOR		,E1_SALDO			,E1_XSALDO		,E1_PEDIDO			,E1_EMISSAO
					,E1_VENCTO		,E1_VENCREA		,E1_BAIXA		,E1_CLIENTE		,E1_LOJA
					,E1_NOMCLI		,E1_SITUACA		,E1_STATUS		,R_E_C_N_O_ AS E1_RECNO
					,E1_XDTFAT		,E1_VALJUR			,E1_PORCJUR	,E1_DESCONT		,E1_EMIS1
					,E1_JUROS
		FROM %Table:SE1% SE1
		WHERE E1_CLIENTE = %Exp:cCliente%  AND E1_LOJA = %Exp:cLoja%
			AND 	E1_TIPO = 'NF'
			AND SE1.%NotDel%
		ORDER BY  E1_FILIAL,E1_PEDIDO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO
	EndSql

	While (_cAliasSE1)->(!EOF())
		_aAux 			:= {}
		_nValor2 		+= (_cAliasSE1)->E1_VALOR
		_nSaldo2 		+= (_cAliasSE1)->E1_SALDO
		_nSaldoC2	 	+= (_cAliasSE1)->E1_XSALDO

		If (_cAliasSE1)->E1_SALDO > 0 .And. (_cAliasSE1)->E1_VENCREA < Date()
            _nAtraso2    += (_cAliasSE1)->E1_SALDO
        EndIf

		RecLock(_cAlias2,.T.)
			(_cAlias2)->E1_RECNO	:= (_cAliasSE1)->E1_RECNO
			(_cAlias2)->E1_FILIAL	:= (_cAliasSE1)->E1_FILIAL
			(_cAlias2)->E1_PEDIDO	:= (_cAliasSE1)->E1_PEDIDO
			(_cAlias2)->E1_CLIENTE	:= (_cAliasSE1)->E1_CLIENTE
			(_cAlias2)->E1_LOJA		:= (_cAliasSE1)->E1_LOJA
			(_cAlias2)->E1_NOMCLI	:= (_cAliasSE1)->E1_NOMCLI

			(_cAlias2)->E1_PREFIXO	:= (_cAliasSE1)->E1_PREFIXO
			(_cAlias2)->E1_NUM		:= (_cAliasSE1)->E1_NUM
			(_cAlias2)->E1_PARCELA	:= (_cAliasSE1)->E1_PARCELA
			(_cAlias2)->E1_TIPO		:= (_cAliasSE1)->E1_TIPO

			(_cAlias2)->E1_VALOR	:= (_cAliasSE1)->E1_VALOR
			(_cAlias2)->E1_SALDO	:= (_cAliasSE1)->E1_SALDO
			(_cAlias2)->E1_XSALDO	:= (_cAliasSE1)->E1_SALDO //(_cAliasSE1)->E1_XSALDO

			(_cAlias2)->E1_VALJUR	:= (_cAliasSE1)->E1_VALJUR
			(_cAlias2)->E1_PORCJUR	:= (_cAliasSE1)->E1_PORCJUR
			(_cAlias2)->E1_DESCONT	:= (_cAliasSE1)->E1_DESCONT

			(_cAlias2)->E1_EMISSAO	:= (_cAliasSE1)->E1_EMISSAO
			(_cAlias2)->E1_VENCTO	:= (_cAliasSE1)->E1_VENCTO
			(_cAlias2)->E1_VENCREA	:= (_cAliasSE1)->E1_VENCREA
			(_cAlias2)->E1_BAIXA	:= (_cAliasSE1)->E1_BAIXA
			(_cAlias2)->E1_SITUACA	:= (_cAliasSE1)->E1_SITUACA
			(_cAlias2)->E1_STATUS	:= (_cAliasSE1)->E1_STATUS
			(_cAlias2)->E1_XDTFAT	:= (_cAliasSE1)->E1_XDTFAT
			(_cAlias2)->E1_EMIS1	:= (_cAliasSE1)->E1_EMIS1
			(_cAlias2)->E1_JUROS	:= (_cAliasSE1)->E1_JUROS
		(_cAlias2)->(MsUnLock())

		(_cAliasSE1)->(DbSkip())
	EndDo

	(_cAliasSE1)->(DbCloseArea())
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------
Static Function M05AGetOFl(_aStru,_lSaldo)
	Local _aRet	:= {}
	Local _nX	:= 0

	For _nX := 1 To Len(_aStru)
		If _aStru[_nX][1] == 'E1_XSALDO'
			If _lSaldo
				AAdd(_aRet,_aStru[_nX][1])
			EndIf
		Else
			AAdd(_aRet,_aStru[_nX][1])
		EndIf
	Next
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------
Static Function M05AStru()
	
	AAdd(_aStru	,{'E1_OK'			,'C'	,2								,0								,''})
	AAdd(_aStru	,{'E1_RECNO'		,'N'	,19								,0								,''})
	AAdd(_aStru	,{'E1_FILIAL'		,'C'	,TamSX3('E1_FILIAL')[1]			,TamSX3('E1_FILIAL')[2]			,''})
	AAdd(_aStru	,{'E1_PEDIDO'		,'C'	,TamSX3('E1_PEDIDO')[1]			,TamSX3('E1_PEDIDO')[2]			,_cPictureC})


	AAdd(_aStru	,{'E1_PREFIXO'		,'C'	,TamSX3('E1_PREFIXO')[1]		,TamSX3('E1_PREFIXO')[2]		,_cPictureC})
	AAdd(_aStru	,{'E1_NUM'			,'C'	,TamSX3('E1_NUM')[1]			,TamSX3('E1_NUM')[2]			,_cPictureC})
	AAdd(_aStru	,{'E1_PARCELA'		,'C'	,TamSX3('E1_PARCELA')[1]		,TamSX3('E1_PARCELA')[2]		,_cPictureC})
	AAdd(_aStru	,{'E1_TIPO'			,'C'	,TamSX3('E1_TIPO')[1]			,TamSX3('E1_TIPO')[2]			,_cPictureC})

	AAdd(_aStru	,{'E1_VALOR'		,'N'	,TamSX3('E1_VALOR')[1]			,TamSX3('E1_VALOR')[2]			,_cPictureN})
	AAdd(_aStru	,{'E1_SALDO'		,'N'	,TamSX3('E1_SALDO')[1]			,TamSX3('E1_SALDO')[2]			,_cPictureN})
	AAdd(_aStru	,{'E1_XSALDO'		,'N'	,TamSX3('E1_XSALDO')[1]			,TamSX3('E1_XSALDO')[2]			,_cPictureN})

	AAdd(_aStru	,{'E1_VALJUR'		,'N'	,TamSX3('E1_VALJUR')[1]			,TamSX3('E1_VALJUR')[2]			,_cPictureN})
	AAdd(_aStru	,{'E1_PORCJUR'		,'N'	,TamSX3('E1_PORCJUR')[1]		,TamSX3('E1_PORCJUR')[2]		,_cPictureN})
	AAdd(_aStru	,{'E1_JUROS'		,'N'	,TamSX3('E1_JUROS')[1]		    ,TamSX3('E1_JUROS')[2]		    ,_cPictureN})
	AAdd(_aStru	,{'E1_DESCONT'		,'N'	,TamSX3('E1_DESCONT')[1]		,TamSX3('E1_DESCONT')[2]		,_cPictureN})

	AAdd(_aStru	,{'E1_CLIENTE'		,'C'	,TamSX3('E1_CLIENTE')[1]		,TamSX3('E1_CLIENTE')[2]		,_cPictureC})
	AAdd(_aStru	,{'E1_LOJA'			,'C'	,TamSX3('E1_LOJA')[1]			,TamSX3('E1_LOJA')[2]			,_cPictureC})
	AAdd(_aStru	,{'E1_NOMCLI'		,'C'	,TamSX3('E1_NOMCLI')[1]			,TamSX3('E1_NOMCLI')[2]			,_cPictureC})

	AAdd(_aStru	,{'E1_EMISSAO'		,'D'	,TamSX3('E1_EMISSAO')[1]		,TamSX3('E1_EMISSAO')[2]		,''})
	AAdd(_aStru	,{'E1_XDTFAT'		,'D'	,TamSX3('E1_XDTFAT')[1]			,TamSX3('E1_XDTFAT')[2]			,''})
	AAdd(_aStru	,{'E1_EMIS1'		,'D'	,TamSX3('E1_EMIS1')[1]			,TamSX3('E1_EMIS1')[2]			,''})
	AAdd(_aStru	,{'E1_VENCTO'		,'D'	,TamSX3('E1_VENCTO')[1]			,TamSX3('E1_VENCTO')[2]			,''})
	AAdd(_aStru	,{'E1_VENCREA'		,'D'	,TamSX3('E1_VENCREA')[1]		,TamSX3('E1_VENCREA')[2]		,''})
	AAdd(_aStru	,{'E1_BAIXA'		,'D'	,TamSX3('E1_BAIXA')[1]			,TamSX3('E1_BAIXA')[2]			,''})
	AAdd(_aStru	,{'E1_SITUACA'		,'C'	,TamSX3('E1_SITUACA')[1]		,TamSX3('E1_SITUACA')[2]		,'!'})
	AAdd(_aStru	,{'E1_STATUS'		,'C'	,TamSX3('E1_STATUS')[1]			,TamSX3('E1_STATUS')[2]			,'!'})
Return AClone(_aStru)

//+----------------------------------------------------------------------------------------
Static Function M05ATrab(_aStru,_cArq)
	Local _cAlias	:= GetNextAlias()

	_cArq := CriaTrab(_aStru,.F.)+GetDBExtension()

	DbCreate(_cArq,_aStru)
	dbUseArea(.T.,__LocalDriver,_cArq,_cAlias,.F.)
Return _cAlias

//+----------------------------------------------------------------------------------------
Static Function M05AGetFld(_lSaldo)
	Local _aRet			:= {}
	Local _cPictureC	:= '@!'
	Local _cPictureN	:= '@E 9,999,999,999,999.99'

	aAdd(_aRet,{'Filial'	 			,'E1_FILIAL'		,'C'	,TamSX3('E1_FILIAL')[1]		,TamSX3('E1_FILIAL')[2]		,''})
	aAdd(_aRet,{'Pedido'	 			,'E1_PEDIDO'		,'C'	,TamSX3('E1_PEDIDO')[1]		,TamSX3('E1_PEDIDO')[2] 	,_cPictureC})

	aAdd(_aRet,{'Prefixo'	 			,'E1_PREFIXO'		,'C'	,TamSX3('E1_PREFIXO')[1]	,TamSX3('E1_PREFIXO')[2]	,_cPictureC})
	aAdd(_aRet,{'N�mero'	 			,'E1_NUM'			,'C'	,TamSX3('E1_NUM')[1]		,TamSX3('E1_NUM')[2]		,_cPictureC})
	aAdd(_aRet,{'Parcela'	 			,'E1_PARCELA'		,'C'	,TamSX3('E1_PARCELA')[1]	,TamSX3('E1_PARCELA')[2]	,_cPictureC})
	aAdd(_aRet,{'Tipo'	 				,'E1_TIPO'			,'C'	,TamSX3('E1_TIPO')[1]		,TamSX3('E1_TIPO')[2]		,_cPictureC})
	aAdd(_aRet,{'Valor'	 				,'E1_VALOR'			,'N'	,TamSX3('E1_VALOR')[1]		,TamSX3('E1_VALOR')[2]		,_cPictureN})

	aAdd(_aRet,{'Saldo (receber)'		,'E1_SALDO'			,'N'	,TamSX3('E1_SALDO')[1]		,TamSX3('E1_SALDO')[2]		,_cPictureN})

	If _lSaldo
		aAdd(_aRet,{'Saldo (compensar)'	,'E1_XSALDO'		,'N'	,TamSX3('E1_XSALDO')[1]		,TamSX3('E1_XSALDO')[2]		,_cPictureN})
	EndIf

	aAdd(_aRet,{'Tx Perman.'			,'E1_VALJUR'		,'N'	,TamSX3('E1_VALJUR')[1]		,TamSX3('E1_VALJUR')[2]		,''})
	aAdd(_aRet,{'Porc Juros'			,'E1_PORCJUR'		,'N'	,TamSX3('E1_PORCJUR')[1]	,TamSX3('E1_PORCJUR')[2]	,''})
	aAdd(_aRet,{'Desconto'				,'E1_DESCONT'		,'N'	,TamSX3('E1_DESCONT')[1]	,TamSX3('E1_DESCONT')[2]	,''})
	aAdd(_aRet,{'Juros'				    ,'E1_JUROS'		    ,'N'	,TamSX3('E1_JUROS')[1]	    ,TamSX3('E1_JUROS')[2]	    ,''})

	aAdd(_aRet,{'Cliente'	 			,'E1_CLIENTE'		,'C'	,TamSX3('E1_CLIENTE')[1]	,TamSX3('E1_CLIENTE')[2]	,_cPictureC})
	aAdd(_aRet,{'Loja'	 				,'E1_LOJA'			,'C'	,TamSX3('E1_LOJA')[1]		,TamSX3('E1_LOJA')[2]		,_cPictureC})
	aAdd(_aRet,{'Nome'	 				,'E1_NOMCLI'		,'C'	,TamSX3('E1_NOMCLI')[1]		,TamSX3('E1_NOMCLI')[2]		,_cPictureC})

	aAdd(_aRet,{'Emiss�o'				,'E1_EMISSAO'		,'D'	,TamSX3('E1_EMISSAO')[1]	,TamSX3('E1_EMISSAO')[2]	,''})
	aAdd(_aRet,{'Dt Fat.'				,'E1_XDTFAT'		,'D'	,TamSX3('E1_XDTFAT')[1]		,TamSX3('E1_XDTFAT')[2]		,''})
	aAdd(_aRet,{'Dt Contab.'			,'E1_EMIS1'			,'D'	,TamSX3('E1_EMIS1')[1]		,TamSX3('E1_EMIS1')[2]		,''})
	aAdd(_aRet,{'Vencimento'			,'E1_VENCTO'		,'D'	,TamSX3('E1_VENCTO')[1]		,TamSX3('E1_VENCTO')[2]		,''})
	aAdd(_aRet,{'Venc. Real'			,'E1_VENCREA'		,'D'	,TamSX3('E1_VENCREA')[1]	,TamSX3('E1_VENCREA')[2]	,''})
	aAdd(_aRet,{'Baixa'					,'E1_BAIXA'			,'D'	,TamSX3('E1_BAIXA')[1]		,TamSX3('E1_BAIXA')[2]		,''})
	aAdd(_aRet,{'Situa��o'				,'E1_SITUACA'		,'C'	,TamSX3('E1_SITUACA')[1]	,TamSX3('E1_SITUACA')[2]	,'!'})
	aAdd(_aRet,{'Status'				,'E1_STATUS'		,'C'	,TamSX3('E1_STATUS')[1]		,TamSX3('E1_STATUS')[2]		,'!'})
	aAdd(_aRet,{'Recno'					,'E1_RECNO'			,'N'	,14							,0							,''})
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	AAdd(aRotina,{ "Pesquisar" , 'PesqBrw'       	 , 0 , 1, 0, .T. } )
Return AClone(aRotina)

//+----------------------------------------------------------------------------------------
Static Function M05AExcl(_cAlias2,_oMark)
	Local _lRet		:= .T.
	Local _cPedido	:= ''
	Local _cMsg		:= ''
	Local _cPicture	:= '@E 9,999,999,999,999.99'
	Local _nRecnoRA	:= 0
	Local _nRecno2	:= 0
	Local _nRecnoB	:= 0
	Local _nValRec	:= 0

	// Valida registro marcado na markbrowse 2 - NF
	If _lRet
		_lRet := M05AMark1(_cAlias2,_oMark,@_nRecno2,@_cPedido,@_cMsg)
	EndIf

	// Seleciona Baixas
	If _lRet
		_lRet := M05AGetBai(_cAlias2,_nRecno2,@_nRecnoB,@_nRecnoRA)
	EndIf

	If _lRet
		BeginTran()

		FWMsgRun(, {|| _lRet := M05AExclui(_nRecno2,_nRecnoB,@_nValRec)},,'Excluindo compensa��o...')

		If _lRet
			FWMsgRun(, {|| _lRet := M05ASetRA(_nRecnoRA,+_nValRec)},,'Atualizando saldo...')
		EndIf

		If _lRet
			EndTran()
		Else
			DisarmTransaction()
		EndIf

		MsUnlockAll()
	EndIf

	If _lRet
		Aviso('Aten��o','Valor da exclus�o: ' + Transform(_nValRec,_cPicture) + CRLF + _cMsg,{'OK'},3)
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05AGetBai(_cAlias2,_nRecno2,_nRecnoB,_nRecnoRA)
	Local _lRet			:= .T.
	Local _cListBox		:= ''
	Local _aBaixas		:= {}
	Local _aBaixaSel	:= {}
	Local _oDlgEx		:= Nil
	Local _nOpbaixa,_nX	:= 0
	Local _aSize			:= FWGetDialogSize(oMainWnd)
	Private _cPicture		:= '@E 9,999,999,999,999.99'

	_aBaixas := M05ASelSE5(_nRecno2)

	_lRet := Len(_aBaixas) > 0

	If !_lRet
		MsgStop('N�o foram encontradas baixas para este t�tulo.' + CRLF + 'Verifique.')
	Else

		If Len(_aBaixas) > 0
			For _nX := 1 To Len(_aBaixas)
				AAdd(_aBaixaSel,_aBaixas[_nX][1])
			Next

			_cListBox := _aBaixaSel[1]

			DEFINE MSDIALOG _oDlgEx FROM _aSize[1], _aSize[2] TO 028, 100 TITLE "Escolha A Baixa"

			@  002.5, 2 LISTBOX _cListBox ITEMS _aBaixaSel SIZE 360 , 153 Font _oDlgEx:oFont
			DEFINE SBUTTON FROM 010,017 TYPE 1 ACTION (_nOpbaixa := 1,_oDlgEx:End()) ENABLE OF _oDlgEx
			DEFINE SBUTTON FROM 010,055 TYPE 2 ACTION _oDlgEx:End() ENABLE OF _oDlgEx

			ACTIVATE MSDIALOG _oDlgEx CENTERED
		EndIf

		If (_lRet := (_nOpbaixa == 1))
			For _nX := 1 To Len(_aBaixas)
				If _aBaixas[_nX][1] == _cListBox
					_nRecnoB 	:= _aBaixas[_nX][2]
					_nRecnoRA	:= _aBaixas[_nX][3]
					Exit
				EndIf
			Next

			// Valida baixa de comissao
			_lRet := F070VenBx(_aBaixas,_nX)
		Else
			MsgStop('Nenhuma baixa foi selecionada.')
		EndIf
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------
Static Function M05ASelSE5(_nRecno2)
	Local _aRet			:= {}
	Local _cAlias		:= GetNextAlias()
	Local _cPicture		:= '@E 9,999,999,999,999.99'
	Local _cPrefixo		:= ''
	Local _cNumero		:= ''
	Local _cParcela		:= ''
	Local _cTipo		:= ''

	SE1->(DbGoTo(_nRecno2))

	_cPrefixo	:= SE1->E1_PREFIXO
	_cNumero	:= SE1->E1_NUM
	_cParcela	:= SE1->E1_PARCELA
	_cTipo		:= SE1->E1_TIPO

	BeginSql Alias _cAlias
		Column E5_DATA as Date
		SELECT  E5_PREFIXO
				,E5_NUMERO
				,E5_PARCELA
				,E5_TIPO
				,E5_CLIFOR
				,E5_LOJA
				,E5_DATA
				,E5_VALOR
				,E5_DOCUMEN
				,E5_SEQ
				,SE5.R_E_C_N_O_ AS E5_RECNO
				,SE1.R_E_C_N_O_ AS E1_RECNO
		FROM %Table:SE5% SE5
		INNER JOIN SE1010 SE1 ON
					E1_FILIAL = %xFilial:SE1%
				AND SE1.%NotDel%
				AND	E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO = E5_DOCUMEN
		WHERE E5_FILIAL = %xFilial:SE5%
			AND SE5.%NotDel%
			AND E5_PREFIXO = %Exp:_cPrefixo%
			AND E5_NUMERO  = %Exp:_cNumero%
			AND E5_PARCELA = %Exp:_cParcela%
			AND E5_TIPO    = %Exp:_cTipo%
			AND E5_DOCUMEN <> ''
	EndSql

	While (_cAlias)->(!EOF())
		AAdd(_aRet ,{	 DToC((_cAlias)->E5_DATA) + ' ' + (_cAlias)->E5_PREFIXO + ' ' + (_cAlias)->E5_NUMERO + ' ' + (_cAlias)->E5_PARCELA + ' ' + (_cAlias)->E5_TIPO + ' ' + Transform((_cAlias)->E5_VALOR,_cPicture) + ' ' + (_cAlias)->E5_SEQ + ' ' + (_cAlias)->E5_DOCUMEN ;
						,(_cAlias)->E5_RECNO;
						,(_cAlias)->E1_RECNO})
		(_cAlias)->(DbSkip())
	EndDo

	(_cAlias)->(DbCloseArea())
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------
Static Function M05AExclui(_nRecno2,_nRecnoB,_nValRec)
	Local _nOpc			:= 6  // 3 - Baixa de T�tulo, 5 - Cancelamento de baixa, 6 - Exclus�o de Baixa
	Local _aArray		:= {}
	Local _lRet			:= .T.
	Local _nOpBaixa		:= 1

	Pergunte('FIN070',.F.)

	// Posiciona nos registros
	SE1->(DbSetOrder(1))
	SE1->(DbGoTo(_nRecno2))

	SE5->(DbSetOrder(1))
	SE5->(DbGoTo(_nRecnoB))

	_nValRec 	:= SE5->E5_VALOR
	_nOpBaixa 	:= Val(SE5->E5_SEQ)

	AAdd(_aArray	,{'E1_PREFIXO'		,SE1->E1_PREFIXO		,Nil})
	AAdd(_aArray	,{'E1_NUM'			,SE1->E1_NUM			,Nil})
	AAdd(_aArray	,{'E1_PARCELA'		,SE1->E1_PARCELA		,Nil})
	AAdd(_aArray	,{'E1_TIPO'			,SE1->E1_TIPO			,Nil})
	AAdd(_aArray	,{'E1_CLIENTE'		,SE1->E1_CLIENTE		,Nil})
	AAdd(_aArray	,{'E1_LOJA'			,SE1->E1_LOJA			,Nil})
	AAdd(_aArray	,{'AUTMOTBX'		,SE5->E5_MOTBX			,Nil})

	lMsErroAuto := .F.

	MSExecAuto({|x,y,w,z| Fina070(x,y,w,z)},_aArray,_nOpc,.F.,_nOpBaixa)

	If lMsErroAuto
		_lRet := .F.
	   MostraErro()
	EndIf
Return _lRet
//+----------------------------------------------------------------------------------------
