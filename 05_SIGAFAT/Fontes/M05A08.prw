#Include 'Protheus.ch'
#include 'colors.ch'

//+---------------------------------------------------------------------------------------------------------
//|	Rotina responsável pela criação dos titulos de recebimento antecipado com prefixo PVA
//|	Chamada do PE MA410MNU
//+---------------------------------------------------------------------------------------------------------
User Function M05A08()
	Local _aArea		:= GetArea()
	Local _lOk			:= .F.
	Local _cRAPre		:= 'PVA'
	Local _cTitle 		:= 'Recebimento Antecipado'
	Local _cNaturez		:= ''
	Local _cCondPag		:= ''
	Local _cPicture		:= '@E 9,999,999.99'
	Local _cPicture2	:= '@E 999.999999'
	Local _nRecAnt		:= 0
	Local _nSE1			:= 0
	Local _nTotal		:= 0
	Local _nFrete		:= 0
	Local _nSeguro		:= 0
	Local _nDesp		:= 0
	Local _nFreteA		:= 0
	Local _nAcrFin		:= 0
	Local _oObs			:= Nil
	Local _oPedido		:= Nil

	//+------------------------------------
	// Valida informações do pedido/itens
	//+------------------------------------
	_lOk := MA08Valid(@_cNaturez)

	_cCondPag		:= SC5->C5_CONDPAG
	_nAcrFin		:= SC5->C5_ACRSFIN

	If _lOk
		FWMsgRun(, {|| MA08GetTot(SC5->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@_cCondPag) },,'Carregando totais do pedido...')


		_nSE1		:= MA08GetSE1(SC5->C5_NUM,_cRAPre)
		_nRecAnt	:= _nTotal - _nSE1
	EndIf

	Define MsDialog _oDlg Title _cTitle From 000,000  To 560,700 Pixel

		@ 010,021 Say 'Vlr. Rec. Antec.:' 	Of _oDlg Pixel
		@ 009,071 MsGet _nRecAnt 			Size 055,011 Valid MA08ValidT(_nRecAnt,_nTotal - _nSE1) Of _oDlg Picture '@E 999,999,999.99' Colors CLR_BLACK Pixel

		@ 028,022 Say 'Cod. Pag.:' 			Of _oDlg Pixel
		@ 027,071 MsGet _cCondPag 			Size 055,010 Valid IIF(MA08ValidC(_cCondPag),;
												MA08GetTot(SC5->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@_cCondPag),;
												) Of _oDlg Picture '@!' F3 'SE4' Pixel

		@ 050,015 Group _oPedido To 150,335 PROMPT 'Totais do Pedido'	OF _oDlg COLOR CLR_RED PIXEL

			@ 070,132 Say 'Vlr. Frete.' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 070,172 Say Transform(_nFrete,_cPicture) 					Of _oDlg Colors CLR_GRAY  Pixel

			@ 070,242 Say 'Vlr. Seguro' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 070,282 Say Transform(_nSeguro,_cPicture) 				Of _oDlg Colors CLR_GRAY  Pixel

			@ 083,022 Say 'Vlr. Despesa' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 083,062 Say Transform(_nDesp,_cPicture) 					Of _oDlg Colors CLR_GRAY  Pixel

			@ 083,132 Say 'Vlr. Frete Aut' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 083,172 Say Transform(_nFreteA,_cPicture) 				Of _oDlg Colors CLR_GRAY  Pixel

			@ 083,242 Say 'Acr. Financ.' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 083,282 Say Transform(_nAcrFin,_cPicture2) 				Of _oDlg Colors CLR_GRAY  Pixel

			@ 105,022 Say 'Total ' 										Of _oDlg Colors CLR_BLACK Pixel
			@ 105,100 Say Transform(_nTotal,_cPicture) 					Of _oDlg Colors CLR_GRAY  Pixel

			@ 118,022 Say 'Total Titulos Gerados' 						Of _oDlg Colors CLR_BLACK Pixel
			@ 118,100 Say Transform(_nSE1,_cPicture) 					Of _oDlg Colors CLR_GRAY  Pixel

			@ 131,022 Say 'Total Saldo' 								Of _oDlg Colors CLR_BLACK Pixel
			@ 131,100 Say Transform(_nTotal - _nSE1,_cPicture) 			Of _oDlg Colors CLR_GRAY  Pixel

			@170,015 Group _oObs To 250,335 Prompt 'Obs. Financeira' 	Of _oDlg Color CLR_RED Pixel
			@185,022 Say SC5->C5_XOBSFIN Size 300,057 					Of _oDlg Colors CLR_GRAY Pixel

		@260,140 BUTTON 'Confirmar' Size 040, 015 PIXEL Of _oDlg ACTION   FWMsgRun(, {|| (MA08Ok(SC5->(Recno()),_nRecAnt,_cCondPag,_cRAPre,_cNaturez),_oDlg:End()) },,'Aguarde...')
		@260,185 BUTTON 'Cancelar' 	Size 040, 015 PIXEL Of _oDlg ACTION (_oDlg:End())

	Activate MsDialog _oDlg  Centered

	RestArea(_aArea)
Return

//+---------------------------------------------------------------------------------------------------------
//|
//+---------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela inclusão do titulo a receber
//+--------------------------------------------------------------------------------------------
Static Function MA08PutSE1(_cE1Num,_nValor,_dData,_cParc,_cRAPre,_cNaturez,_cErro,_cMsg)
	Local _aVet		:= {}
	Local _cPicture	:= '@E 9,999,999.99'
	Local _cXBNDES	:= ""
	
//	If SE4->(FieldPos('E4_XBNDES')) > 0
//		_cXBNDES	:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_XBNDES")
//	Endif
	
	lMsErroAuto := .F.

	AAdd(_aVet	,{'E1_PREFIXO'		,_cRAPre						,Nil})
	AAdd(_aVet	,{'E1_NUM'			,_cE1Num						,Nil})
	AAdd(_aVet	,{'E1_PARCELA'		,_cParc							,Nil})
	AAdd(_aVet	,{'E1_TIPO'			,'BOL'							,Nil})
	AAdd(_aVet	,{'E1_NATUREZ'		,_cNaturez						,Nil})
	AAdd(_aVet	,{'E1_CLIENTE'		,SC5->C5_CLIENTE				,Nil})
	AAdd(_aVet	,{'E1_LOJA'			,SC5->C5_LOJACLI				,Nil})
	AAdd(_aVet	,{'E1_EMISSAO'		,dDataBase						,Nil})
	AAdd(_aVet	,{'E1_VENCTO'		,_dData							,Nil})
	AAdd(_aVet	,{'E1_VENCREA'		,_dData							,Nil})
	AAdd(_aVet	,{'E1_VALOR'		,_nValor						,Nil})
	AAdd(_aVet	,{'E1_VEND1'		,SC5->C5_VEND1					,Nil})
	AAdd(_aVet	,{'E1_PEDIDO'		,SC5->C5_NUM					,Nil})
	AAdd(_aVet	,{'E1_COMIS1'		,SC5->C5_COMIS1					,Nil})
	AAdd(_aVet	,{'E1_VEND2'		,SC5->C5_VEND2					,Nil})
	AAdd(_aVet	,{'E1_COMIS2'		,SC5->C5_COMIS2					,Nil})
	AAdd(_aVet	,{'E1_VEND3'		,SC5->C5_VEND3					,Nil})
	AAdd(_aVet	,{'E1_COMIS3'		,SC5->C5_COMIS3					,Nil})	
	AAdd(_aVet	,{'E1_VEND4'		,SC5->C5_VEND4					,Nil})
	AAdd(_aVet	,{'E1_COMIS4'		,SC5->C5_COMIS4					,Nil})
	AAdd(_aVet	,{'E1_VEND5'		,SC5->C5_VEND5					,Nil})
	AAdd(_aVet	,{'E1_COMIS5'		,SC5->C5_COMIS5					,Nil})		

//	If SE1->(FieldPos('E1_TITPED')) > 0
//		AAdd(_aVet	,{'E1_TITPED'	,_cRAPre + SC5->C5_NUM			,Nil})
//	EndIf

	If SE1->(FieldPos('E1_XSALDO')) > 0
		AAdd(_aVet	,{'E1_XSALDO'	,0								,Nil})
	EndIf

	If SE1->(FieldPos('E1_XBNDES')) > 0
		AAdd(_aVet	,{'E1_XBNDES'	,_cXBNDES						,Nil})
	EndIf

	_aVet	:= FwVetByDic(_aVet,'SE1')

	MsExecAuto( { |x,y| FINA040(x,y)} , _aVet, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

	If lMsErroAuto
		_cErro := MA010GetEr()
		RollBackSxe()
	Else
		ConfirmSx8()
	EndIf

	_cMsg += '   ' + _cRAPre + '  ' + _cE1Num + '  ' + _cParc + '    R$ ' + Transform(_nValor,_cPicture) + CRLF
Return !lMsErroAuto

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela definição dos valores e datas das parcelas a serem geradas
//+--------------------------------------------------------------------------------------------
Static Function MA08Ok(_nRecnoSC5,_nRecAnt,_cCondPag,_cRAPre,_cNaturez)

	Local _lErro		:= .F.
	Local _aDuplic	:= {}
	Local _nX			:= 0
	Local _nValor		:= 0
	Local _cParc		:= 'A'
	Local _cErro		:= ''
	Local _cMsg		:= ''
	Local _cE1Num		:= GetSx8Num('SE1','E1_NUM')
	Local _dData		:= CToD('  /  /  ')

	_aDuplic := Condicao(_nRecAnt,_cCondPag)

	BeginTran()
		SE1->(DbGoTop())
		SE1->(DbSetOrder(1))

		While SE1->(DbSeek( xFilial('SE1') + _cRAPre + _cE1Num ))
			ConfirmSx8()
			_cE1Num		:= GetSx8Num('SE1','E1_NUM')
		EndDo

		For _nX := 1 To Len(_aDuplic)

			// Posiciona SC5 - na gravação da segunda parcela ele está desposicionado  
			SC5->(dbGoto(_nRecnoSC5))

			_nValor 	:= _aDuplic[_nX][2]
			_dData 		:= _aDuplic[_nX][1]
			_cParc		:= IIF(Len(_aDuplic) > 1,_cParc,' ')

			_lErro 		:= !MA08PutSE1(_cE1Num,_nValor,_dData,_cParc,_cRAPre,_cNaturez,@_cErro,@_cMsg)
			_cParc		:= Soma1(_cParc)

			If _lErro ; Exit ; EndIf
		Next

	If _lErro
		DisarmTransaction()
		MsUnlockAll()

		MsgInfo(I18N('Erro ao incluir recebimento antecipado: ' + CRLF + CRLF + ' #1',{_cErro}),'Atenção')
	Else
		EndTran()
		MsUnlockAll()
		Aviso('Atenção','Recebimento(s) gerados(s): ' + CRLF + CRLF + _cMsg,{'OK'},3)
	EndIf
Return

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela validação do total informado pelo usuário
//+--------------------------------------------------------------------------------------------
Static Function MA08ValidT(_nRecAnt,_nPedSaldo)
	Local _lRet	:= .T.

	If !(_lRet := _nRecAnt > 0)
		MsgStop('Informe valor do recebimento antecipado.')
	EndIf

	If _lRet .And. !(_lRet := _nRecAnt <= _nPedSaldo)
		MsgStop('Recebimento antecipado não pode ser maior que o valor do saldo total.')
	EndIf
Return _lRet

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela validação da condição de pagamento informada pelo usuário
//+--------------------------------------------------------------------------------------------
Static Function MA08ValidC(_cCondPag,_nTotal)
	Local _lRet 		:= .T.
	Local aArea		:= GetArea()

	SE4->(DbSetOrder(1))
	SE4->(DbGoTop())

	If !Empty(_cCondPag) .And.  !(_lRet := SE4->(DbSeek(xFilial("SE4") + _cCondPag)) )
		Alert('Condição de pagamento não encontrada.')
	EndIf

	RestArea(aArea)
Return _lRet

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela validação dos dados do pedido utilizados para gerar o reb. antecipado
//+--------------------------------------------------------------------------------------------
Static Function MA08Valid(_cNaturez)
	Local _lRet			:= .T.
	Local _nValor		:= 0
	Local _cCFBlq		:= AllTrim(SuperGetMV('AM_05A0801',,''))
	Private _nX			:= 0

	_lRet	:= SC5->(!EOF())

	If !_lRet
		MsgInfo('É obrigatório estar posicionado em um registro para gerar recebimento antecipado.','Atenção')
	EndIf

	If _lRet .And. !(_lRet := !Empty(SC5->C5_CLIENTE))
		MsgInfo('Informe o cliente antes de incluir o recebimento antecipado.','Atenção')
	EndIf

	//+------------------------------------
	// Valida Natureza
	//+------------------------------------
	If _lRet
		_cNaturez 	:=	Posicione('SA1',1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI ,'A1_NATUREZ')

		SED->(DbGoTop())
		SED->(DbSetOrder(1))

		If !(_lRet := (SED->(DbSeek( xFilial('SED') + _cNaturez))))
			MsgInfo('Verifique Natureza informada no cadastro do cliente antes de incluir o recebimento antecipado.','Atenção')
		EndIf
	EndIf

	//+------------------------------------
	// 	Valida CFOP para nao gerar
	//	recebimento para os CFOP informados
	//	no parâmetro
	//+------------------------------------
	If _lRet
		SC6->(DbGoTop())
		SC6->(DbSetOrder(1))

		If SC6->(DbSeek( xFilial('SC6') + SC5->C5_NUM ))
			While SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM ) ==  SC5->(C5_FILIAL + C5_NUM)

				If !(_lRet := !(SC6->C6_CF $ _cCFBlq))
					MsgInfo(I18N('CFOP do item #1 não permite incluir recebimento antecipado.' ;
								+ CRLF + 'Parâmetro #2.',{AllTrim(SC6->C6_ITEM),'MV_X06A002'}),'Atenção')
					Exit
				EndIf

				_nValor += SC6->C6_VALOR

				SC6->(DbSkip())
			EndDo
		EndIf
	EndIf

	//+------------------------------------
	// Verificacao de itens/quantidade
	//+------------------------------------
	If _lRet .And. !(_lRet := (_nValor> 0))
		MsgInfo('Não é possível gerar recebimento antecipado para pedido sem Valor Bruto.' ;
					+ CRLF + 'Verifique quantidade dos itens.','Atenção')
	EndIf
Return _lRet

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pela captura da mensagem de erro na execução automática
//+--------------------------------------------------------------------------------------------
Static Function MA010GetEr()
	Local _lTitulo		:= .T.
	Local _cRet			:= ''
	Local _cAux			:= ''
	Local _cFileError 	:= NomeAutoLog()
	Local _cMemo 			:= MemoRead( _cFileError )
	Local _nY				:= 0

	For _nY := 1 To MLCount(_cMemo)
		_cAux := AllTrim(MemoLine(_cMemo,,_nY))

		If Len(_cAux) > 0 .And. _lTitulo
			_cRet += _cAux + " "
		Else
			If At("< --", _cAux) > 0
				_cRet += " | " + _cAux
			EndIf
			_lTitulo	:= .F.
		EndIf
	Next _nY

	Ferase(_cFileError)
Return _cRet

//+--------------------------------------------------------------------------------------------
//|	Rotina responsável pelo retorno do total de títulos de recebimento antecipados do pedido
//+--------------------------------------------------------------------------------------------
Static Function MA08GetSE1(_cPedido,_cRAPre)
	Local _nRet	:= 0
	Local _cAlias	:= GetNextAlias()

	BeginSql Alias _cAlias
		SELECT SUM(E1_VALOR) AS TOTAL
		FROM %Table:SE1% SE1
		Where SE1.%NotDel%
			AND E1_FILIAL = %xFilial:SE1%
			AND E1_PEDIDO = %Exp:_cPedido%
			AND E1_PREFIXO = %Exp:_cRAPre%
//			AND E1_TITPED = %Exp:_cRAPre% + %Exp:_cPedido%
	EndSql

	If (_cAlias)->(!EOF())
		_nRet	:= (_cAlias)->TOTAL
	EndIf

	(_cAlias)->(DbCloseArea())
Return _nRet

//+----------------------------------------------------------------------------------------
//|	Rotina responsável pelo cálculo do total do pedido
//+----------------------------------------------------------------------------------------
Static Function MA08GetTot(_nRecnoSC5,_nTotal,_nFrete,_nSeguro,_nDesp,_nFreteA,_nAcrFin,_cCondPag)
	Local _aAreaSC5		:= SC5->(GetArea())
	Local _aArea		:= GetArea()

	Local aRelImp    	:= MaFisRelImp("MT100",{"SF2","SD2"})
	Local aFisGet    	:= Nil
	Local aFisGetSC5 	:= Nil
	Local cCliEnt	 	:= ""
	Local cNfOri     	:= Nil
	Local cSeriOri   	:= Nil
	Local nDesconto  	:= 0
	Local nRecnoSD1  	:= Nil
	Local nFrete	 	:= 0
	Local nSeguro	 	:= 0
	Local nFretAut		:= 0
	Local nDespesa		:= 0
	Local nDescCab		:= 0
	Local nPDesCab		:= 0
	Local nY         	:= 0
	Local nValMerc   	:= 0
	Local nPrcLista  	:= 0
	Local nAcresFin  	:= 0

	MA08FisIni(@aFisGet,@aFisGetSC5)

	cCliEnt 	:= IIf(!Empty(SC5->(FieldGet(FieldPos("C5_CLIENT")))),SC5->C5_CLIENT,SC5->C5_CLIENTE)
	_nAcrFin	:= Posicione('SE4',1,xFilial('SE4') + _cCondPag ,'E4_ACRSFIN')

	MaFisIni(	cCliEnt,;									// 1-Codigo Cliente/Fornecedor
				SC5->C5_LOJACLI,;							// 2-Loja do Cliente/Fornecedor
				If(SC5->C5_TIPO$'DB',"F","C"),;			// 3-C:Cliente , F:Fornecedor
				SC5->C5_TIPO,;							// 4-Tipo da NF
				SC5->C5_TIPOCLI,;							// 5-Tipo do Cliente/Fornecedor
				aRelImp,;									// 6-Relacao de Impostos que suportados no arquivo
				,;						   					// 7-Tipo de complemento
				,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
				"SB1",;									// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				"MATA461")									// 10-Nome da rotina que esta utilizando a funcao

	nFrete		:= SC5->C5_FRETE
	nSeguro		:= SC5->C5_SEGURO
	nFretAut	:= SC5->C5_FRETAUT
	nDespesa	:= SC5->C5_DESPESA
	nDescCab	:= SC5->C5_DESCONT
	nPDesCab	:= SC5->C5_PDESCAB
	aItemPed	:= {}
	nPesBru		:= 0

	DbSelectArea('SC5')

	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&(aFisGetSC5[ny][2]))
			If aFisGetSC5[ny][1] == "NF_SUFRAMA"
				MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
			Else
				MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
			Endif
		EndIf
	Next nY

	SC6->(DbGoTop())
	SC6->(DbSetOrder(1))

	If SC6->(DbSeek( SC5->C5_FILIAL + SC5->C5_NUM ))

		//+------------------------------------
		// Percorre itens do pedido
		//+------------------------------------
		While SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM ) == SC5->C5_FILIAL + SC5->C5_NUM
			cNfOri     := Nil
			cSeriOri   := Nil
			nRecnoSD1  := Nil
			nDesconto  := 0

			//+------------------------------------
			// Verifica se Possui NF Origem
			//+------------------------------------
			If !Empty(SC6->C6_NFORI)
				DbSelectArea("SD1")
				SD1->(dbSetOrder(1))
				SD1->(dbSeek(xFilial("SC6")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_ITEMORI))

				cNfOri     := SC6->C6_NFORI
				cSeriOri   := SC6->C6_SERIORI
				nRecnoSD1  := SD1->(RECNO())
			EndIf

			DbSelectArea('SC6')

			//+------------------------------------
			//Calcula o preco de lista
			//+------------------------------------
			nValMerc  := SC6->C6_VALOR
			nPrcLista := SC6->C6_PRUNIT

			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/SC6->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
			EndIf

			nAcresFin := A410Arred(SC6->C6_PRCVEN*_nAcrFin/100,"D2_PRCVEN")
			nValMerc  += A410Arred(SC6->C6_QTDVEN*nAcresFin,"D2_TOTAL")
			nDesconto := a410Arred(nPrcLista*SC6->C6_QTDVEN,"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,SC6->C6_VALDESC,nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresFin
			nValMerc  += nDesconto

			MaFisAdd(	SC6->C6_PRODUTO				,;	// 1-Codigo do Produto ( Obrigatorio )
						SC6->C6_TES					,;	// 2-Codigo do TES ( Opcional )
						SC6->C6_QTDVEN				,;	// 3-Quantidade ( Obrigatorio )
						nPrcLista						,;	// 4-Preco Unitario ( Obrigatorio )
						nDesconto						,;	// 5-Valor do Desconto ( Opcional )
						cNfOri							,;	// 6-Numero da NF Original ( Devolucao/Benef )
						cSeriOri						,;	// 7-Serie da NF Original ( Devolucao/Benef )
						nRecnoSD1						,;	// 8-RecNo da NF Original no arq SD1/SD2
						0								,;	// 9-Valor do Frete do Item ( Opcional )
						0								,;	// 10-Valor da Despesa do item ( Opcional )
						0								,;	// 11-Valor do Seguro do item ( Opcional )
						0								,;	// 12-Valor do Frete Autonomo ( Opcional )
						nValMerc						,;	// 13-Valor da Mercadoria ( Obrigatorio )
						0								,;	// 14-Valor da Embalagem ( Opiconal )
						0								,;	// 15-RecNo do SB1
						0								)	// 16-RecNo do SF4

			aadd(aItemPed,	{	SC6->C6_ITEM					,;
									SC6->C6_PRODUTO				,;
									SC6->C6_DESCRI				,;
									SC6->C6_TES					,;
									SC6->C6_CF					,;
									SC6->C6_UM					,;
									SC6->C6_QTDVEN				,;
									SC6->C6_PRCVEN				,;
									SC6->C6_NOTA				,;
									SC6->C6_SERIE				,;
									SC6->C6_CLI					,;
									SC6->C6_LOJA				,;
									SC6->C6_VALOR				,;
									SC6->C6_ENTREG				,;
									SC6->C6_DESCONT				,;
									SC6->C6_LOCAL				,;
									SC6->C6_QTDEMP				,;
									SC6->C6_QTDLIB				,;
									SC6->C6_QTDENT				,;
								})

			//+------------------------------------
			//Forca os valores de impostos que foram
			//	informados no SC6.
			//+------------------------------------
			DbSelectArea('SC6')
			For nY := 1 to Len(aFisGet)
				If !Empty(&(aFisGet[ny][2]))
					MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
				EndIf
			Next nY

			//+------------------------------------
			//Calculo do ISS
			//+------------------------------------
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
			If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
				EndIf
			EndIf

			//+------------------------------------
			//Altera peso para calcular frete
			//+------------------------------------
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			MaFisAlt("IT_PESO",SC6->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
			MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
			MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))

			SC6->(DbSkip())
		EndDo
	EndIf

	MaFisAlt("NF_FRETE"   ,nFrete)
	MaFisAlt("NF_SEGURO"  ,nSeguro)
	MaFisAlt("NF_AUTONOMO",nFretAut)
	MaFisAlt("NF_DESPESA" ,nDespesa)

	If nDescCab > 0
		MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nDescCab+MaFisRet(,"NF_DESCONTO")))
	EndIf

	If nPDesCab > 0
		MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*nPDesCab/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
	EndIf

	_nTotal 	:= MaFisRet(,"NF_TOTAL")
	_nFrete		:= MaFisRet(,"NF_FRETE")
	_nSeguro	:= MaFisRet(,"NF_SEGURO")
	_nDesp		:= MaFisRet(,"NF_DESPESA")
	_nFreteA	:= MaFisRet(,"NF_AUTONOMO")

	MaFisEnd()

	RestArea(_aArea)
	RestArea(_aAreaSC5)
Return

//+----------------------------------------------------------------------------------------
//|	Rotina responsável pela inicialização das referencias utilizadas no calculo do total
//+----------------------------------------------------------------------------------------
Static Function MA08FisIni(aFisGet,aFisGetSC5)
	Local _aAreaSX3		:= SX3->(GetArea())
	Local cValid      	:= ''
	Local cReferencia 	:= ''
	Local nPosIni     	:= 0
	Local nLen        	:= 0

	If aFisGet == Nil
		aFisGet	:= {}

		DbSelectArea('SX3')

		SX3->(DbGoTop())
		SX3->(dbSetOrder(1))
		SX3->(DbSeek('SC6'))

		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == 'SC6'
			cValid := UPPER(SX3->X3_VALID) + UPPER(SX3->X3_VLDUSER)

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				AAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni		:= AT('MAFISREF("',cValid) + 10
				cReferencia	:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				AAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			SX3->(DbSkip())
		EndDo

		ASort(aFisGet,,,{|x,y| x[3]<y[3]})
	EndIf

	If aFisGetSC5 == Nil
		aFisGetSC5	:= {}

		DbSelectArea('SX3')
		SX3->(DbGoTop())
		SX3->(dbSetOrder(1))
		SX3->(DbSeek('SC5'))

		While SX3->(!EOF()).And. SX3->X3_ARQUIVO == 'SC5'
			cValid := UPPER(SX3->X3_VALID) + UPPER(SX3->X3_VLDUSER)

			If 'MAFISGET("'$cValid
				nPosIni 		:= AT('MAFISGET("',cValid)+10
				nLen			:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
				cReferencia 	:= Substr(cValid,nPosIni,nLen)

				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			If 'MAFISREF("'$cValid
				nPosIni			:= AT('MAFISREF("',cValid) + 10
				cReferencia		:= Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)

				aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
			EndIf

			SX3->(DbSkip())
		EndDo

		ASort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
	EndIf

	MaFisEnd()
	RestArea(_aAreaSX3)
Return
