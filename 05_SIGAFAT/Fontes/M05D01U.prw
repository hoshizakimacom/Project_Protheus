#Include "Totvs.ch"
#Include "Ap5mail.ch"

/*/{Protheus.doc} M05D01U
Importação da Tabela de Preços via CSV

@type function
@author	Jorge Heitor T. de Oliveira
@since 12/06/2023
@version P12
@database MSSQL

@history Fonte reescrito para correta cobertura de código, tratando todos os itens do arquivo CSV como potenciais de validação para continuidade da rotina

/*/
User Function M05D01U()
	Local aSay				as array
	Local cTitulo			as character
	Local aBotoes			as array
	Local lSimulacao		as logical
	Local cArquivoOrigem	as character
	Local cLogArquivo		as character
	Local cNomeArquivo		as character

	aSay := {}
	cTitulo := FunName() + " - Importa tabela de preço"
	aBotoes := {}
	lSimulacao := MsgYesNo('Deseja executar em modo SIMULAÇÃO?')
	cArquivoOrigem := ""
	cLogArquivo := ""
	cNomeArquivo := ""

	If lSimulacao
		AADD(aSay,OemToAnsi('*** SIMULAÇÃO *** '))

	EndIf

	AADD(aSay,OemToAnsi("Rotina de atualização de tabela de preços/produtos informados no arquivo CSV"))
	AADD(aSay,OemToAnsi(" "))
	AADD(aSay,OemToAnsi("Importante! "))
	AADD(aSay,OemToAnsi(" - Os números devem utilizar ponto [.] como separador de casa decimal"))
	AADD(aSay,OemToAnsi(" - Os campos dever ser separados por ponto e vírgula [;]"))
	AADD(aSay,OemToAnsi(" - A tabela/produto informados devem estar cadastrados no Protheus"))

	aAdd( aBotoes, { 1, .T., {|| Processa({|| M05D01OK(lSimulacao,@cArquivoOrigem,@cLogArquivo,@cNomeArquivo)}),FechaBatch() }} )
	aAdd( aBotoes, { 2, .T., {|| FechaBatch() }} )

	FormBatch(cTitulo, aSay, aBotoes)

Return

/*
	Rotina de processamento dos dados, após confirmação do usuário
*/
Static Function M05D01OK(lSimulacao, cArquivoOrigem, cLogArquivo,cNomeArquivo)
	Local oTela				as object
	Local oArquivoOrigem	as object
	Local oLogArquivo		as object
	Local cTitulo			as character

	cTitulo := 'Importação de Itens da Tabela de Preço'

	If lSimulacao
		cTitulo += OemToAnsi(' *** SIMULAÇÃO *** ')
	EndIf

	cArquivoOrigem := Space(200)
	cLogArquivo := Space(200)

	Define MsDialog oTela Title cTitulo Style DS_MODALFRAME From 000,000 To 300,900 Pixel

	@020,020 Say  'Arquivo Origem *.CSV:' Of oTela Pixel
	@017,080 Get oArquivoOrigem Var cArquivoOrigem Size 300,010 Of oTela Pixel WHEN .F.

	@017,400 BUTTON "Selec. Arquivo" 	SIZE 040, 015 PIXEL OF oTela ACTION ( selecionaArquivo(1,@cArquivoOrigem,Nil) )

	@040,020 Say  'Arquivo Log:' Of oTela Pixel
	@037,080 Get oLogArquivo Var cLogArquivo Size 300,010 Of oTela Pixel WHEN .F.

	@037,400 BUTTON "Selec. Arquivo" 	SIZE 040, 015 PIXEL OF oTela ACTION ( selecionaArquivo(2,Nil,@cLogArquivo,@cNomeArquivo))

	@120,170 BUTTON "Confirmar" 	SIZE 040, 012 PIXEL OF oTela ACTION (Confirmar(lSimulacao, @cArquivoOrigem, @cLogArquivo,@oTela,@cNomeArquivo))
	@120,220 BUTTON "Cancelar" 		SIZE 040, 012 PIXEL OF oTela ACTION (oTela:End())

	Activate MsDialog oTela Centered

	cArquivoOrigem		:= ''
	cLogArquivo			:= ''

Return

/*
	Valida e confirma processamento
*/
Static Function Confirmar(lSimulacao, cArquivoOrigem, cLogArquivo,oTela,cNomeArquivo)
	If validaArquivos(cArquivoOrigem,cLogArquivo)
		processaDados(lSimulacao, @cArquivoOrigem, @cLogArquivo,@cNomeArquivo)
		oTela:End()

	EndIf

Return

/*
	Processamento da importação com os arquivos selecionados
*/
Static Function processaDados(lSimulacao, cArquivoOrigem, cLogArquivo, cNomeArquivo)
	Local aRegistros				as array
	Local nTotal 					as numeric
	Local cMailMensagem				as character
	Local nRegistros				as numeric
	Local lEnviou					as logical
	Local lRetry					as logical
	Local cLog						as character
	Local cError					as character
	Local cMensagemProcessamento	as character
	Local nIncluidosRegistros		as numeric
	Local nRegistrosAlterados		as numeric
	Local cHTMLLOG					as character

	aRegistros := {}
	nTotal := 0
	cMailMensagem := ""
	nRegistros := 0
	lEnviou := .F.
	lRetry := .T.
	cLog := 'Inicio ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF
	cError := ""
	cMensagemProcessamento := ""
	nIncluidosRegistros := 0
	nRegistrosAlterados := 0
	cHTMLLOG := ""

	Begin Sequence

		If !carregaDados(cArquivoOrigem, @aRegistros, @nTotal)
			cMensagem := "Falha ao carregar os dados do arquivo CSV em memória."
			Break

		EndIf

		cMailMensagem := cabecalhoEmail() //_cMsgMail

		//Processa todo Array de Registros
		FWMsgRun(, {||atualizaTabelas(aRegistros,@cLog,@nRegistrosAlterados,@nIncluidosRegistros,@cMailMensagem,lSimulacao) },,I18N('Importando item #1 de #2 ...',{++nRegistros,nTotal}))

		cMensagemProcessamento := geraLog(cLogArquivo,cMensagemProcessamento,@cLog,nRegistrosAlterados,nIncluidosRegistros)

		If ! lSimulacao 
			While ! lEnviou .And. lRetry
				FWMsgRun(, {|| lEnviou := enviaEmail(cMailMensagem,@cError,@cHTMLLOG)},,'Gerando log...')

				If ! lEnviou .And. lRetry
					lRetry := MsgYesNo("Ocorreu um erro ao enviar o e-mail:" + CRLF + CRLF + " [" + AllTrim(cError) + "] "  + ;
								CRLF + CRLF + "Esta operação não impedirá a inclusão dos dados, porém é importante para a existência do Log de importação." + ;
								CRLF + "Caso opte por não prosseguir, será gerado o LOG de processamento localmente." + ;
								CRLF + CRLF + "Tentar novamente? ","processaDados")

				EndIf

			End

			If ! lEnviou .And. !lRetry
				gravaLogLocal(cHTMLLOG,cNomeArquivo)

			EndIf

		EndIf

	End Sequence

Return

/*
	Obtem e retorna conteudo do LOG gerado
*/
Static Function geraLog(cLogArquivo,cMensagemProcessamento,cLog,nRegistrosAlterados,nIncluidosRegistros)
	Local nHandle		:= 0

	nHandle	:= FCREATE(cLogArquivo)

	cLog := CRLF + CRLF + I18N('Registros Incluídos: #1',{nIncluidosRegistros})  +  CRLF + I18N('Registros Atualizados: #1',{nRegistrosAlterados}) + CRLF + CRLF + cLog
	cLog += CRLF + CRLF + 'Fim ' + DToC(Date()) + ' ' + Time() + CRLF + CRLF

	 If nHandle = -1
	 	cMensagemProcessamento 	+= " Erro ao criar arquivo - ferror " + Str(Ferror())
    Else
        cMensagemProcessamento += ' Verifique arquivo de log gerado: ' + CRLF + '#2 ' + CRLF
        FWrite(nHandle, cLog)
        FClose(nHandle)
    EndIf
Return cMensagemProcessamento

/*
	Valida informações e processa Todo o array aRegistros, efetuando log de todos os itens (processados ou não)
*/
Static Function atualizaTabelas(aRegistros,cLog,nRegistrosAlterados,nIncluidosRegistros,cMailMensagem, lSimulacao)
	Local nRegistro				as numeric
	Local cProduto				as character
	Local cItem					as character
	Local cLogMensagem			as character
	Local nPrecoVenda			as numeric
	Local dDataVigencia			as date
	Local nAntigoPrecoVenda		as numeric
	Local cTabelaDePreco		as character

	For nRegistro := 2 To Len(aRegistros) //Primeira linha é cabeçalho
		cTabelaDePreco := PadR(AllTrim(aRegistros[nRegistro][1]),TamSX3("DA0_CODTAB")[1])
		cProduto := PadR(AllTrim(aRegistros[nRegistro][2]),TamSX3("DA1_CODPRO")[1])
		cItem := Space(TamSX3("DA1_ITEM")[1])
		cLogMensagem := ""
		nPrecoVenda := Val(aRegistros[nRegistro][3])
		dDataVigencia := CtoD(aRegistros[nRegistro][4])
		nAntigoPrecoVenda := 0
		
		//Processa Registro
		Begin Sequence
			If ! existeTabelaDePreco(cTabelaDePreco,@cLogMensagem)
				Break

			EndIf

			If ! existeProduto(cProduto,@cLogMensagem)
				Break

			EndIf

			incluiRegistroTabelaDePreco(;
											cTabelaDePreco,;
											cProduto,;
											nPrecoVenda,;
											@nAntigoPrecoVenda,;
											@cItem,;
											@cLogMensagem,;
											@nRegistrosAlterados,;
											@nIncluidosRegistros,;
											dDataVigencia,;
											lSimulacao;
										)

		End Sequence

		gravaLog(;
					cTabelaDePreco,;
					cProduto,;
					nPrecoVenda,;
					nAntigoPrecoVenda,;
					cItem,;
					cLogMensagem,;
					@cLog,;
					@cMailMensagem,;
					dDataVigencia;
				)

	Next nRegistro

Return

/*
	Verifrica se a tabela de preço informada existe
*/
Static Function existeTabelaDePreco(cTabelaDePreco,cLogMensagem)
	Local lReturn		as logical
	
	DA0->(DbSetOrder(1))
	DA0->(DbGoTop())

	lReturn := .F.

	Begin Sequence

		If ! DA0->(DbSeek( xFilial('DA0') + cTabelaDePreco ))
			cLogMensagem := I18N('Tabela #1 não encontrada',{cTabelaDePreco})
			Break
		
		EndIf

		lReturn := .T.

	End Sequence

Return lReturn

/*
	Verifrica se o produto existe
*/
Static Function existeProduto(cProduto,cLogMensagem)
	Local lReturn		as logical
	
	SB1->(DbSetOrder(1))
	SB1->(DbGotop())

	lReturn := .F.

	Begin Sequence

		If ! SB1->(DbSeek( xFilial('SB1') + cProduto ))
			cLogMensagem := I18N('Produto #1 invalido',{cProduto})
			Break
		
		EndIf

		lReturn := .T.

	End Sequence

Return lReturn




/*
	Executa inclusão dos registros de Item da Tabela de Preço (DA1)
*/
Static Function incluiRegistroTabelaDePreco(;
												cTabelaDePreco,;
												cProduto,;
												nPrecoVenda,;
												nAntigoPrecoVenda,;
												cItem,;
												cLogMensagem,;
												nRegistrosAlterados,;
												nIncluidosRegistros,;
												dDataVigencia,;
												lSimulacao;
											)
	Local nRegistroDA1 		as numeric

	//Alteração
	If existeRegistroTabelaDePreco(cTabelaDePreco,cProduto,@cItem,@nRegistroDA1)//_nRecDA1 > 0
		DA1->(DbGoTop())
		DA1->(DbGoTo(nRegistroDA1))

		nAntigoPrecoVenda := DA1->DA1_PRCVEN

		If !lSimulacao .and. (RetCodUsr() $ GETMV("MV_XIMPTAB") .Or. FwIsAdmin())//"000010|000013|000019|000222|000289|000291|000294|000014"
			RecLock('DA1',.F.)
				DA1->DA1_PRCVEN	:= nPrecoVenda
				DA1->DA1_DATVIG	:= dDataVigencia
			DA1->(MsUnLock())

			cLogMensagem := ' Alteracao efetuada'

		else
			cLogMensagem := ' Alteracao nao permitida'

		EndIf
		
		++nRegistrosAlterados

	Else //Inclusão
		cItem := proximoItemDA1(cTabelaDePreco)
		nAntigoPrecoVenda := 0

		If !lSimulacao
			RecLock('DA1',.T.)
				DA1->DA1_FILIAL		:= xFilial('DA1')
				DA1->DA1_ITEM		:= cItem
				DA1->DA1_CODTAB		:= cTabelaDePreco
				DA1->DA1_CODPRO		:= cProduto
				DA1->DA1_GRUPO		:= Posicione('SB1',1,xFilial('SB1') + cProduto,'B1_GRUPO')
				DA1->DA1_PRCVEN		:= nPrecoVenda
				DA1->DA1_ATIVO		:= '1'
				DA1->DA1_TPOPER		:= '4'
				DA1->DA1_QTDLOT		:= 999999.99
				DA1->DA1_MOEDA		:= 1
				DA1->DA1_DATVIG		:= dDataVigencia
			DA1->(MsUnLock())

		EndIf

		cLogMensagem := ' Incluído'
		++nIncluidosRegistros

	EndIf

Return

/*
	Retorna o código do próximo item da Tabela de Preço para inclusão 
*/
Static Function proximoItemDA1(cTabelaDePreco)
	Local cReturn		as character
	Local cAliasDA1		as character

	cReturn := ""
	cAliasDA1 := GetNextAlias()

	BeginSql Alias cAliasDA1
		SELECT
			MAX(DA1_ITEM) AS DA1_ITEM
		FROM
			%Table:DA1% DA1
		WHERE
			DA1.%NotDel%
			AND DA1_FILIAL = %xFilial:DA1%
			AND DA1_CODTAB = %Exp:cTabelaDePreco%
	EndSql

	dbSelectArea(cAliasDA1)
	If (cAliasDA1)->(!EOF())
		cReturn := Soma1((cAliasDA1)->DA1_ITEM)

	EndIf

	(cAliasDA1)->(DbCloseArea())

Return cReturn

/*
	Verifica se já existe registro para Tabela de Preço + Produto
*/
Static Function existeRegistroTabelaDePreco(cTabelaDePreco,cProduto,cItem,nRegistroDA1)
	Local cAliasDA1			as character
	Local lExiste			as logical

	cAliasDA1 := GetNextAlias()
	lExiste := .F.

	BeginSql Alias cAliasDA1

		SELECT
			DA1.R_E_C_N_O_ AS DA1_RECNO
			,DA1_ITEM
			,DA1_CODTAB
			,DA1_CODPRO
			,DA1_DATVIG
		FROM 
			%Table:DA1% DA1
		WHERE 
			DA1.%NotDel%
			AND DA1_FILIAL = %xFilial:DA1%
			AND DA1_CODTAB = %Exp:cTabelaDePreco%
			AND DA1_CODPRO = %Exp:cProduto%
			AND DA1_ATIVO =  '1'
		ORDER BY DA1_DATVIG DESC

	EndSql

	dbSelectArea(cAliasDA1)
	If (cAliasDA1)->(!EOF())
		nRegistroDA1 := (cAliasDA1)->DA1_RECNO
		cItem := (cAliasDA1)->DA1_ITEM
		lExiste := .T.

	EndIf

	(cAliasDA1)->(DbCloseArea())

Return lExiste

/*
	Acrescenta informações ao LOG atual
*/
Static Function gravaLog(;
							cTabelaDePreco,;
							cProduto,;
							nPrecoVenda,;
							nAntigoPrecoVenda,;
							cItem,;
							cLogMensagem,;
							cLog,;
							cMailMensagem,;
							dDataVigencia;
						)
	Local cAntigoPrecoVenda			as character
	Local cNovoPrecoDeVenda			as character

	cAntigoPrecoVenda := Transform(nAntigoPrecoVenda , '@E 9,999,999.999999')
	cNovoPrecoDeVenda := Transform(nPrecoVenda, '@E 9,999,999.999999')

	cLog += CRLF
	cLog += ' | Tabela: '  		+ cTabelaDePreco
	cLog += ' | Item: '  			+ cItem
	cLog += ' | Produto: ' 		+ cProduto
	cLog += ' | Prc Venda: '	 	+ cAntigoPrecoVenda
	cLog += ' | Prc Venda Novo: ' 	+ cNovoPrecoDeVenda
	cLog += ' | Data de Vigência: '+ DTOC(dDataVigencia)
	cLog += ' | STATUS: ' 			+ cLogMensagem + ' |'

	novoItemEmail(cTabelaDePreco,cItem,cProduto,cAntigoPrecoVenda,cNovoPrecoDeVenda,cLogMensagem,@cMailMensagem,dDataVigencia)

Return

/*
	Efetua leitura do arquivo CSV selecionado e carrega seus valores em um Array
*/
Static Function carregaDados(cArquivoOrigem, aRegistros,nTotal)
	Local aLinha			as array
	Local cConteudo			as character
	Local lReturn			as logical

	lReturn := .F.

	Begin Sequence

		If FT_FUSE(cArquivoOrigem) < 0 //Caso não consiga abrir o arquivo
			cMensagem := "Falha ao abrir o arquivo CSV em memória."
			Break

		EndIf 

		FT_FGOTOP()

		While !FT_FEOF()
			cConteudo 	:= FT_FREADLN()
			aLinha		:= {}
			aLinha		:= Separa(cConteudo,";",.F.)

			If Len(aLinha) > 0
				AAdd(aRegistros,aLinha)

			EndIf

			FT_FSKIP()

		EndDo

		nTotal := Len(aRegistros) -1

		FT_FUSE()

		lReturn := .T.

		Recover
			MsgStop(cMensagem)

	End Sequence

Return lReturn

/*
	Valida preenchimento/carregamento dos arquivos de Origem de Log
*/
Static Function validaArquivos(cArquivoOrigem,cLogArquivo)
	Local lReturn	as logical

	Begin Sequence
		If Empty(cArquivoOrigem)
			Break

		EndIf

		If Empty(cLogArquivo)
			Break

		EndIf

		lReturn := .T.

		Recover
			MsgInfo('Arquivo Origem e Arquivo de Log são obrigatórios.' + CRLF + 'Verifique.')

	End Sequence

Return lReturn

/*
	Seleciona Arquivo de Origem / Arquivo de Log
*/
Static Function selecionaArquivo(nTipo,cArquivoOrigem,cLogArquivo, cNomeArquivo)

	If nTipo == 1 //Arquivo de Origem
		cArquivoOrigem 	:= cGetFile("CSV | *.csv","Selecione arquivo de Produtos",,"",.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY )

	Elseif nTipo == 2 //Arquivo de Log
		cLogArquivo := cGetFile('*.TXT'	,'Informe diretorio para arquivo de log'	,0,'',.F.,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T. )
		cNomeArquivo := "LOG_IMPORTACAO_PRECO_" + DToS(Date()) + '_' + (StrTran(Time(),':',''))
		cLogArquivo += cNomeArquivo + '.TXT'

	EndIf

Return

/*
	Monta cabeçalho de tabela HTML no corpo do e-mail a ser enviado no término do processamento
*/
Static Function cabecalhoEmail()
	Local cCabecalho		as character

	cCabecalho := ""

	cCabecalho += '<tr>'

	cCabecalho += '<td width=80 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'TABELA'
	cCabecalho += '</td>'

	cCabecalho += '<td width=80 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'ITEM'
	cCabecalho += '</td>'

	cCabecalho += '<td width=150 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'PRODUTO'
	cCabecalho += '</td>'

	cCabecalho += '<td width=100 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'TIPO'
	cCabecalho += '</td>'

	cCabecalho += '<td width=300 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'DESCRICAO'
	cCabecalho += '</td>'

	cCabecalho += '<td width=125 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'PREÇO ANTIGO'
	cCabecalho += '</td>'

	cCabecalho += '<td width=125 align="middle" align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'PREÇO NOVO'
	cCabecalho += '</td>'

	cCabecalho += '<td width=125 align="middle" align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'DATA DE VIGÊNCIA'
	cCabecalho += '</td>'

	cCabecalho += '<td width=250 align="middle" style="border-top:solid #BBBBBB 1.0pt;border-left:solid #D5D5D5 1.0pt;border-bottom:none;border-right:solid #F2F2F2 1.0pt;background:#DEDEDE;padding:6.0pt 6.0pt 6.0pt 6.0pt">'
	cCabecalho += 'STATUS'
	cCabecalho += '</td>'

	cCabecalho += '</tr>'

Return cCabecalho

/*
	Adiciona um novo item ao corpo do e-mail a ser enviado
*/
Static Function novoItemEmail(cTabelaDePreco,cItem,cProduto,cAntigoPrecoVenda,cNovoPrecoDeVenda,cLogMensagem,cMailMensagem,dDataVigencia)
	Local cTipoProduto			as character
	Local cDescricaoProduto		as character 

	cTipoProduto := Posicione('SB1',1,xFilial('SB1') + PadR(cProduto,TamSX3('B1_COD')[1]),'B1_TIPO' )
	cDescricaoProduto := Posicione('SB1',1,xFilial('SB1') + PadR(cProduto,TamSX3('B1_COD')[1]),'B1_DESC' )

	cMailMensagem += '<tr>'

	cMailMensagem += '<td  width=80 align="middle" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cTabelaDePreco
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=80 align="middle" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cItem
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=150 style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cProduto
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=100 align="middle" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cTipoProduto
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=300 style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cDescricaoProduto
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=125 align="right" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cAntigoPrecoVenda
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=125 align="right" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cNovoPrecoDeVenda
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=125 align="right" style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += DTOC(dDataVigencia)
	cMailMensagem += '</td>'

	cMailMensagem += '<td  width=250 style="border-top:solid #DEDEDE 1.0pt;border-left:solid #DEDEDE 1.0pt;border-bottom:solid #DEDEDE 1.0pt;border-right:solid #DEDEDE 1.0pt">'
	cMailMensagem += cLogMensagem
	cMailMensagem += '</td>'

	cMailMensagem += '</tr>' + CRLF

Return

/*
	Rotina para envio de e-mail
*/
Static Function enviaEmail(cMailMensagem,cError,cHTMLLOG)
	Local lDisconnect				as logical
	Local cDataProcessamento		as character
	Local cHoraProcessamento		as character
	Local cServer					as character
	Local cAccount					as character
	Local cPassword					as character
	Local lAuth						as logical
	Local oProcess					as object
	Local oHtml						as object
	Local cBody						as character
	Local cPara						as character
	Local cUsuario					as character
	Local cProcesso					as character
	Local cAssunto					as character
	Local lConnected				as logical
	Local lReturn					as logical

	lDisconnect			:= .T.
	cDataProcessamento	:= DToC(Date())
	cHoraProcessamento	:= Time()
	cServer				:= ALLTRIM(GetMv('MV_RELSERV',,''))		//|	Nome do servidor de envio de e-mail
	cAccount			:= ALLTRIM(GetMv('MV_RELACNT',,''))		//|	Conta a ser utilizada no envio de e-mail
	cPassword			:= ALLTRIM(GetMv('MV_RELPSW',,''))		//|	Senha da conta de e-mail para envio
	lAuth				:= GetMv('MV_RELAUTH',,'')
	cBody				:= ''
	cPara				:= AllTrim(GetMv('AM_05D0101',,''))
	cUsuario			:= Upper(UsrRetName(RetCodUsr()))
	cProcesso			:= 'M05D01'
	cAssunto			:= 'Atualização de Tabela de Preço'
	lConnected			:= .F. 

	lReturn := .F.

	Begin Sequence
		If Empty(cPara)
			Break

		EndIf

		oProcess := TWFProcess():New('',cProcesso)
		oProcess:NewTask('Inicio','/WORKFLOW/MACOM/WF_MACOM_GENERICO.HTML')
		
		oHtml := oProcess:oHtml
		oHtml:Valbyname('PROCESSO'    	,cProcesso + ' - ' + cAssunto)
		oHtml:Valbyname('USUARIO'    	,cUsuario)
		oHtml:Valbyname('DATA'    		,cDataProcessamento)
		oHtml:Valbyname('HORA'    		,cHoraProcessamento)
		oHtml:Valbyname('MSG'    		,cMailMensagem)

		cBody 		:= oHtml:HtmlCode()

		cHTMLLOG := cBody

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnected

		If lAuth
			If !MailAuth(cAccount,cPassword)
				cError	:= 'Erro ao conectar na conta de e-mail.'
				DISCONNECT SMTP SERVER

				Break
			EndIf
		EndIf

		If ! MailSend ( cAccount, {cPara}, {}, {}, 'Workflow Macom - ' + cAssunto, cBody, {''}, .T. )
			GET MAIL ERROR cError
			Break

		EndIf

		DISCONNECT SMTP SERVER Result lDisconnect

		/*
			Libera processo de WF
		*/
		oProcess:Free()
		oProcess:= Nil

		lReturn := .T.

	End Sequence

Return lReturn

/*
	Efetua a gravação do Log Local em HTML e abre na tela
*/
Static Function gravaLogLocal(cHTMLLOG, cNomeArquivo)
	Local cCaminhoLog		as character
	Local cArquivoHTML		as character

	cCaminhoLog := GetTempPath()
	cArquivoHTML := cNomeArquivo + ".html"

	If SubString(cCaminhoLog,Len(cCaminhoLog),1) <> "\"
		cCaminhoLog += "\"

	EndIf

	MemoWrite(cCaminhoLog + cArquivoHTML,cHTMLLOG)
	ShellExecute("OPEN", cArquivoHTML, "", cCaminhoLog, 1)

Return
