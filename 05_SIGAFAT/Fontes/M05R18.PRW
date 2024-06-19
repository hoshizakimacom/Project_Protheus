#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M05R18   ³ Autor ³ Cleber Maldonado      ³ Data ³ 15/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faturamento por Redes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M05R18()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Cleber Maldonado      ³ Data ³ 15/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oVenProd
Local cAliasQry := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("M05R18","Faturamento X Redes","M05R18", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite o faturamento por redes e o " + " " + "respectivo percentual de participação no resultado.")
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oVenProd := TRSection():New(oReport,STR0023,{"SC5","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"NOME"		,/*Tabela*/ ,"Rede"				 	 ,PesqPict("ZA7","ZA7_DESC")	,TamSx3("ZA7_DESC")[1]-20	,/*lPixel*/,{|| cRede   })		// Rede
TRCell():New(oVenProd,"VALFAT"		,/*Tabela*/	,"Valor Faturado"	 	 ,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT")[1]	,/*lPixel*/,{|| nValBrut})		// Valor Bruto
TRCell():New(oVenProd,"PERCFAT"		,/*Tabela*/ ,"% Representatividade"	 ,PesqPict("SD2","D2_ALQIMP6")	,TamSx3("D2_ALQIMP6")[1]	,/*lPixel*/,{|| nPercFat})		// % de participação no faturamento

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Cleber Maldonado	    ³ Data ³ 15/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)

Local _nTotal	:= 0
Local _nFrete	:= 0
Local _nSeguro	:= 0 
Local _nDesp	:= 0
Local _nFreteA	:= 0
Local _nAcrFin	:= 0
Local _cCondPag	:= ""
Local cNomArq	:= ""
Local aCampos	:= {}
Local lPosC5	:= .F.
Private aTotal	:= {}
Private lPosA1	:= .F.
Private cAliasTot	:= GetNextAlias()

Private oTempTable	:= NIl
Private nTotalFat	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

	SELECT 
		C5_FILIAL,C5_EMISSAO,C5_NUM,C5_CLIENTE,C5_LOJACLI 
	FROM 
		SC5010 SC5 
	WHERE  
		SC5.C5_EMISSAO >= %Exp:MV_PAR01% AND 
		SC5.C5_EMISSAO <= %Exp:MV_PAR02% AND
		SC5.C5_VEND1 = '000007' AND
		SC5.%NotDel%
	ORDER BY 
		SC5.C5_EMISSAO
	
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{ "TB_REDE"  ,"C",06,0 } )		// Codigo da rede
AADD(aCampos,{ "TB_VALOR" ,"N",18,2 } )		// Valores de Faturamento

cNomArq := GetNextAlias()

oTempTable	:= FWTemporaryTable():New( cNomArq )

oTempTable:SetFields( aCampos )
oTempTable:AddIndex("1",{"TB_REDE"})

oTempTable:Create()

dbSelectArea(cNomArq)
dbSetOrder(1)
(cAliasQry)->(dbGoTop())

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cCodRede := Posicione('SA1',1,xFilial('SA1')+(cAliasQry)->C5_CLIENTE+(cAliasQry)->C5_LOJACLI,'A1_XREDE')
	
	If Empty(cCodRede)
		(cAliasQry)->(dbSkip())
		Loop
	Endif	

	lPosC5	:= SC5->(MsSeek(xFilial('SC5')+(cAliasQry)->C5_NUM))
	
	If lPosC5
		// Calcula o valor total do pedido considerando os impostos
		M5R18TOT(SC5->(Recno()),@_nTotal,@_nFrete,@_nSeguro,@_nDesp,@_nFreteA,@_nAcrFin,@_cCondPag)
		nVlrPedt	:= ( _nTotal + _nFrete + _nSeguro + _nDesp + _nFreteA + _nAcrFin )
	Else
		(cAliasQry)->(dbSkip())
		Loop		
	Endif

	If (cNomArq)->(MsSeek(cCodRede))
		RecLock(cNomArq,.F.)
		(cNomArq)->TB_VALOR += nVlrPedt
		nTotalFat += nVlrPedt
		MsUnlock()
	Else
		RecLock(cNomArq,.T.)
		(cNomArq)->TB_REDE := cCodRede
		(cNomArq)->TB_VALOR := nVlrPedt
		nTotalFat += nVlrPedt
		MsUnlock()
	Endif

	cCodRede := ""	

	oReport:IncMeter()	
	(cAliasQry)->(dbSkip())
End		

oReport:SetMeter((cNomArq)->(LastRec()))

(cAliasQry)->(dbGoTop())
(cNomArq)->(dbGoTop())

While !oReport:Cancel() .And. !(cNomArq)->(Eof())

	nPerRepr	:= ((cNomArq)->TB_VALOR / nTotalFat) * 100
	
	nValBrut	:= (cNomArq)->TB_VALOR
	nPercFat	:= nPerRepr
	cRede		:= Posicione('ZA6',1,xFilial('ZA6')+(cNomArq)->TB_REDE,'ZA6_DESC')
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cNomArq)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())
(cNomArq)->(DbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M6R8TOT   ³ Autor ³ Cleber Maldonado     ³ Data ³ 09/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina responsável pelo cálculo do total do pedido		  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ M06R08 - Relatório CondPag                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function M5R18TOT(_nRecnoSC5,_nTotal,_nFrete,_nSeguro,_nDesp,_nFreteA,_nAcrFin,_cCondPag)
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

	MA6R8FisIni(@aFisGet,@aFisGetSC5)

	cCliEnt 	:= IIf(!Empty(SC5->(FieldGet(FieldPos("C5_CLIENT")))),SC5->C5_CLIENT,SC5->C5_CLIENTE)
	_nAcrFin	:= Posicione('SE4',1,xFilial('SE4') + _cCondPag ,'E4_ACRSFIN')

	MaFisIni(	cCliEnt,;								// 1-Codigo Cliente/Fornecedor
				SC5->C5_LOJACLI,;						// 2-Loja do Cliente/Fornecedor
				If(SC5->C5_TIPO$'DB',"F","C"),;			// 3-C:Cliente , F:Fornecedor
				SC5->C5_TIPO,;							// 4-Tipo da NF
				SC5->C5_TIPOCLI,;						// 5-Tipo do Cliente/Fornecedor
				aRelImp,;								// 6-Relacao de Impostos que suportados no arquivo
				,;						   				// 7-Tipo de complemento
				,;										// 8-Permite Incluir Impostos no Rodape .T./.F.
				"SB1",;									// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				"MATA461")								// 10-Nome da rotina que esta utilizando a funcao

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
						nPrcLista					,;	// 4-Preco Unitario ( Obrigatorio )
						nDesconto					,;	// 5-Valor do Desconto ( Opcional )
						cNfOri						,;	// 6-Numero da NF Original ( Devolucao/Benef )
						cSeriOri					,;	// 7-Serie da NF Original ( Devolucao/Benef )
						nRecnoSD1					,;	// 8-RecNo da NF Original no arq SD1/SD2
						0							,;	// 9-Valor do Frete do Item ( Opcional )
						0							,;	// 10-Valor da Despesa do item ( Opcional )
						0							,;	// 11-Valor do Seguro do item ( Opcional )
						0							,;	// 12-Valor do Frete Autonomo ( Opcional )
						nValMerc					,;	// 13-Valor da Mercadoria ( Obrigatorio )
						0							,;	// 14-Valor da Embalagem ( Opiconal )
						0							,;	// 15-RecNo do SB1
						0							)	// 16-RecNo do SF4

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
Static Function MA6R8FisIni(aFisGet,aFisGetSC5)
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
