#include "Protheus.Ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M04R06    ºAutor  ³Marcos Rocha	     º Data ³  02/01/24   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Itens em Processo                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom 		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04R06()

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
//EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marcos Rocha          ³ Data ³ 21/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oVenProd
Local cAliasQry := GetNextAlias()

c_Perg := "M04R06"
ValidPerg()

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
oReport := TReport():New("M04R06","Relatório de Custos em Processo","M04R06", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite os custos de material em processo !")
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
oVenProd := TRSection():New(oReport,"Rel. Custos em Processo",{"SC2","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"OP"	        ,/*Tabela*/	,"Ordem Prod."	 ,PesqPict("SD3","D3_OP")		,TamSx3("D3_OP")[1]		 ,/*lPixel*/,{|| cOP})		// Código do Produto
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Emissao"	     ,PesqPict("SC2","C2_EMISSAO")	,TamSx3("C2_EMISSAO")[1] ,/*lPixel*/,{|| dEmissao	})		// Armazem de estoque
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"		 ,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]	 ,/*lPixel*/,{|| cProduto})		// Descrição do Produto
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"		     ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]	 ,/*lPixel*/,{|| cTipo})		// Descrição do Produto
TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descriçao"     ,PesqPict("SB1","B1_DESC")		,50	                     ,/*lPixel*/,{|| cDesc	})		// Descrição do Produto
TRCell():New(oVenProd,"COMP"		,/*Tabela*/ ,"COMP"		     ,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]	 ,/*lPixel*/,{|| cComponente})		// Descrição do Produto
TRCell():New(oVenProd,"QTD"	        ,/*Tabela*/ ,"Quant.OP."	 ,PesqPict("SC2","C2_QUANT")	,TamSx3("C2_QUANT")[1]	 ,/*lPixel*/,{|| nQtdOP  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_PROD"    ,/*Tabela*/ ,"Quant.Prod."	 ,PesqPict("SC2","C2_QUJE")	    ,TamSx3("C2_QUJE")[1]	 ,/*lPixel*/,{|| nQtdProd  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"CUSTO_MP"	,/*Tabela*/ ,"Cst MP"	     ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstMP })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"CUSTO_CH"	,/*Tabela*/ ,"Cst.Chapa."    ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstChapa })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"CUSTO_MOD"   ,/*Tabela*/ ,"Cst.MOD."	     ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstMOD   })		// Quantidade em pedido de vendas

TRCell():New(oVenProd,"CUSTO_TOT"   ,/*Tabela*/ ,"Cst.Tot."	     ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstTot   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"CST_STD"     ,/*Tabela*/ ,"Cst.Std."	     ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstStd   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"CST_ULT"     ,/*Tabela*/ ,"Cst.Ult.Fech." ,PesqPict("SD3","D3_CUSTO1")	,TamSx3("D3_CUSTO1")[1]	 ,/*lPixel*/,{|| nCstUlt   })		// Quantidade em pedido de vendas

TRCell():New(oVenProd,"ETAPA"       ,/*Tabela*/ ,"Etapa"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	 ,/*lPixel*/,{|| cEtapa})		// Descrição do Produto

//TRCell():New(oVenProd,"CST_REQ"     ,/*Tabela*/ ,"Prim.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQPrim   })		// Quantidade em pedido de vendas

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³                  	    ³ Data ³ 11/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)
 
Local nProc
Private aEstrutura := {}

//Data ref 
//OP DE 
//OP ATE  
//Emissao De
//Emissao Ate

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasQry

SELECT OP, PRODUTO, EMISSAO, QUANT, QUJE, C2_VINI1, CSTREQ, CSTPROD, (CSTREQ-CSTPROD) CSTNAPR 
   FROM ( 
		SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP, C2_PRODUTO PRODUTO, C2_EMISSAO EMISSAO, 
		C2_QUANT QUANT, C2_QUJE QUJE, C2_VINI1, 

		ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) 
		FROM %Table:SD3% SD3 
		WHERE D3_FILIAL = %xFilial:SD3%
		AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN+'  '
		AND D3_EMISSAO <= %Exp:MV_PAR01% 
		AND D3_CF IN ('RE0','RE1','DE0','DE1') 
		AND SD3.%NotDel% ),0) CSTREQ, 

		ISNULL((SELECT SUM(D3_CUSTO1) 
		FROM %Table:SD3% SD3 
		WHERE D3_FILIAL =  %xFilial:SD3%
		AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN+'  ' 
		AND D3_EMISSAO <= %Exp:MV_PAR01% 
		AND D3_CF IN ('PR0','PR1') 
		AND SD3.%NotDel% ),0) CSTPROD 

 FROM %Table:SC2% SC2 (NOLOCK)
 WHERE C2_FILIAL =  %xFilial:SC2% 
 AND C2_EMISSAO <= %Exp:MV_PAR01% 
 AND (C2_DATRF > %Exp:MV_PAR01%  OR C2_DATRF = ' ')  
 AND C2_EMISSAO BETWEEN %Exp:MV_PAR04% AND  %Exp:MV_PAR05%
 AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN %Exp:MV_PAR02% AND  %Exp:MV_PAR03%
 AND SC2.%NotDel% ) TAB 
 ORDER BY OP

EndSql 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo EndQuery ( Classe TRSection )                                    ³
//³Prepara o relatório para executar o Embedded SQL.                       ³
//³ExpA1 : Array com os parametros do tipo Range                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	nCstMP    := 0 
	nCstChapa := 0
	nCstMOD   := 0
	nCstTot   := 0
	nCstProd  := 0
	nCstStd   := 0
	nCstUlt   := 0 

	// Usar a Funcao que explode a extrutura
	//aEsruct   // Pegar da Rotina de Custo Standard
	aEstrutura  := {}
	BuscaEstru((cAliasQry)->PRODUTO,"001")

	// Processa outros niveis
	BusEstr2("001","002")
	BusEstr2("002","003")
	BusEstr2("003","004")
	BusEstr2("004","005")
	BusEstr2("005","006")

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+(cAliasQry)->PRODUTO)

	cOP       := (cAliasQry)->OP
	dEmissao  := Stod((cAliasQry)->EMISSAO)
	cProduto  := (cAliasQry)->PRODUTO
	cTipo     := SB1->B1_TIPO
	cDesc     := Left(SB1->B1_DESC,50)
	nQtdOP    := (cAliasQry)->QUANT
	nQtdProd  := (cAliasQry)->QUJE
	nSldProd  := (cAliasQry)->QUANT - (cAliasQry)->QUJE
	cEtapa    := "XX"
	cComponente := ""

	nCstStd   := SB1->B1_CUSTD
	nCstUlt   := BusCusto((cAliasQry)->PRODUTO)

	// Busca os códigos de Chapas na Estrutura
	For nProc := 1 To Len(aEstrutura)

		nCstUnit := BusCusto(aEstrutura[nProc,1])

		nQtd     := aEstrutura[nProc,2]
		nCstProd  := nCstUnit * (nQtd * nSldProd)

		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+aEstrutura[nProc,1])

		If Left(aEstrutura[nProc,1],3) == "MO-"   // Mao de Obra
			nCstMOD   += nCstProd
			aEstrutura[nProc,4] := nCstProd

		ElseIf  Left(SB1->B1_DESC,5) == "CHAPA"   // Chapas
			nCstChapa += nCstProd
			aEstrutura[nProc,5] := nCstProd

		Else
			nCstMP    += nCstProd
			aEstrutura[nProc,6] := nCstProd

		EndIf
		nCstTot += nCstProd

		aEstrutura[nProc,7] := SB1->B1_CUSTD
		aEstrutura[nProc,8] := nQtd

		//Aadd(aEstrutura,{SG1->G1_COMP,SG1->G1_QUANT,cNivel,0,0,0,0,0,0})
	Next
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	If mv_par06 == 1  // Imprime Componentes
		For nProc := 1 To Len(aEstrutura)

			cComponente := aEstrutura[nProc,1]

			nCstMOD   := aEstrutura[nProc,4]
			nCstChapa := aEstrutura[nProc,5]
			nCstMP    := aEstrutura[nProc,6]
			nCstTot   := nCstMOD + nCstChapa + nCstMP
			nCstStd   := aEstrutura[nProc,7]
			nCstUlt   := 0
			nQtdOP    := aEstrutura[nProc,8]
			//nPerda    := aEstrutura[nProc,9]

			oReport:IncMeter()
			oReport:Section(1):PrintLine()
		Next
	EndIf

	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbSkip())
EndDo
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³BuscaEStruº Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaEStru(cProduto,cNivel)

Local aArea     := GetArea()
//	aProdutos  := {}

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera somente itens vencidos , sem opcionais ou fora  ³
		//³ da revisao atual.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If QtdComp(nQuantItem) != QtdComp(0)
		//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
		//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
		//	nCusTot := nCusTot + (nQuantItem * nCusto)
		//EndIf

		// Tratar a Validade da Estrutura
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

		//dbSelectArea("SB1")
		//dbSeek(xFilial("SB1")+SG1->G1_COD)

		nQtdEstr := ( SG1->G1_QUANT / (100 - SG1->G1_PERDA))*100

		Aadd(aEstrutura,{SG1->G1_COMP,nQtdEstr,cNivel,0,0,0,0,0})

		dbSelectArea("SG1")	
		dbSkip()
	EndDo

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ BusEstr2 º Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BusEstr2(cNivel1,cNivel2)

Local aArea     := GetArea()
Local nProc2

For nProc2 := 1 to Len(aEstrutura)

	If aEstrutura[nProc2,3] <> cNivel1
		Loop
	EndIf

	cProduto := aEstrutura[nProc2,1]   // Produto

	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+cProduto)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera somente itens vencidos , sem opcionais ou fora  ³
		//³ da revisao atual.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If QtdComp(nQuantItem) != QtdComp(0)
		//	nCusto  := IIf(lA320CUSM, MA320CusM(SB1->B1_COD), RetFldProd(SB1->B1_COD,"B1_CUSTD"))
		//	nCusto  := xMoeda(nCusto,val(alltrim(SB1->B1_MCUSTD)),mv_par01, mv_par03)
		//	nCusTot := nCusTot + (nQuantItem * nCusto)
		//EndIf

		// Tratar a Validade da Estrutura  // 06/07/23 - Não tratar (o pode se tratar de OPS antigas e estrutura já vencida na data atual)
//		If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
//			dbSelectArea("SG1")
//			dbSkip()
//			Loop
//		EndIf  

		//dbSelectArea("SB1")
		//dbSeek(xFilial("SB1")+SG1->G1_COD)
		Aadd(aEstrutura,{SG1->G1_COMP,SG1->G1_QUANT,cNivel2,0,0,0,0,0})

		dbSelectArea("SG1")	
		dbSkip()
	EndDo

Next

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ BusCusto º Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Criar uma Matriz somente com as chapas
Static Function BusCusto(cProduto)

Local nCstUnit := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona a Nota de Saida da Filial de Origem. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT SUM(B2_VFIM1) VFIM1, SUM(B2_QFIM) QFIM, MAX(B2_CM1) CM1 "
cQuery += " FROM "+RetSqlName("SB2")+" SB2"
cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"'" 
cQuery += " AND B2_COD = '"+cProduto+"'"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "TRBSB2" 

lAchouCst  := .F.

dbSelectArea("TRBSB2")
dbGotop()
While !Eof()

//	If TRBSB2->VFIM1 > 1 .And. TRBSB2->QFIM > 0 .And. Left(cProduto,3) <> "MO-"
//		nCstUnit := TRBSB2->VFIM1 / TRBSB2->QFIM
//		lAchouCst := .T.
//		Exit
//	Else
		nCstUnit := TRBSB2->CM1
//	EndIf

	dbSkip()
EndDo

TRBSB2->(dbCloseArea())

Return(nCstUnit)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ValidPerg º Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

//              Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
aAdd(aRegs,{c_Perg,"01"  ,"Data Referencia ? ",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"02"  ,"Ordem Prod. De ?  ",""      ,""     ,"MV_CH2","C"    ,11      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"03"  ,"Ordem Prod. Até ? ",""      ,""     ,"MV_CH3","C"    ,11      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"04"  ,"Emissao De ?      ",""      ,""     ,"MV_CH4","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"05"  ,"Emissao Até ?     ",""      ,""     ,"MV_CH5","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"06"  ,"Impr.Componente ? ",""      ,""     ,"MV_CH6","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR06","Sim"         ,""      ,""      ,""   ,""         ,"Não"             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf	
Next

dbSelectArea(_sAlias)

Return Nil
