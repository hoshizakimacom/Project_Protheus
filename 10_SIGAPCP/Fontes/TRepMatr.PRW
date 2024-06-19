//Bibliotecas
#Include "Totvs.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#Define STR_PULA	Chr(13)+Chr(10)


/*/{Protheus.doc} User Function zRelator
Relatório Centro de Custo por Período
@author TIAGO DIAS
@since 14/07/2022
@version 1.0
@type function
/*/

User Function tRepMatr()

	WFPrepEnv("01","01")
	
	Local aArea     
	Local oReport
	Local aPergs 	as array   
    local aPar	 	as array	    
					
	Private aRetorno 	as array
	Private cCodComp
	Private cTipoComp
	Private cDescComp
	Private cUniComp
	Private nQtdComp
	Private cCodProd
	Private cDescProd
	Private cTipoProd
	Private cUniProd

	aArea	:= FWGetArea()
	aPergs	:= {}

	aPar	:= 	{;
				Space( TamSx3( "B1_TIPO" )[ 01 ] ),;
				}

	aRetorno:= {}

	//Adicionando os parametros do ParamBox
	Aadd(aPergs, {1, "Tipo de Prod.", aPar[ 01 ], "", "", "SB1", ""		, 061, .F. })//D3_EMISSAO
	
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parametros", @aRetorno)
		oReport := U_fReportDef(aRetorno)
		oReport:PrintDialog()
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} U_fReportDef
Definicoes do relatorio zRelator
@author TIAGO DIAS
@since 14/07/2022
@version 1.0
@type function
/*/

User Function fReportDef(aRetorno)

	Local oReport
	Local oSection
	Local oQuebra 
	Local nDevice	:= 4 //apenas excel

	oSection	:= Nil
	oQuebra		:= Nil
	
	//Criacao do componente de impressao
	oReport := TReport():New( "tRepMatr",;
		"Relatório de Produto X Componente",;
		,;
		{|oReport| U_fRepPrint(oReport, aRetorno),};
		)
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)
	
	//Orientacao do Relatorio - paisagem
	oReport:SetLandscape()

	//oReport:SetPortrait() //Retrato
	oReport:SetDevice(nDevice)	//Excel
	
	//Criando a secao de dados
	oSection := TRSection():New(oReport,"Produto X Componente",{"SB1","SG1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	

	oSection:SetTotalInLine(.F.)
	
	//Colunas do relatorio
	TRCell():New(oSection,"COD"			,/*Tabela*/	,"Código Produto"			 ,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| Alltrim(cCodProd)	})		// CODIGO DO PRODUTO
	TRCell():New(oSection,"DESC"		,/*Tabela*/ ,"Descrição Produto"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| Alltrim(cDescProd)	})		// DESCRIÇÃO DO PRODUTO
	TRCell():New(oSection,"TIPO"		,/*Tabela*/	,"Tipo Produto"		 		 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{|| Alltrim(cTipoProd)	})		// TIPO DO PRODUTO
	TRCell():New(oSection,"UM"			,/*Tabela*/	,"Unidade Produto"			 ,PesqPict("SB1","B1_UM")		,TamSx3("B1_UM")[1]			,/*lPixel*/,{|| Alltrim(cUniProd)  	})		// UNIDADE DO PRODUTO
	TRCell():New(oSection,"COD"			,/*Tabela*/ ,"Código Componente"		 ,PesqPict("SG1","G1_COMP")		,TamSx3("G1_COMP")[1]		,/*lPixel*/,{|| Alltrim(cCodComp)	})		// CODIGO DO PRODUTO
	TRCell():New(oSection,"TIPO"		,/*Tabela*/	,"Tipo Componente"	 	 	 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{|| Alltrim(cTipoComp)	})		// TIPO DO PRODUTO
	TRCell():New(oSection,"DESC"		,/*Tabela*/	,"Descriçao Componente"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| Alltrim(cDescComp)	})		// DESCRIÇÃO DO PRODUTO
	TRCell():New(oSection,"QUANT"		,/*Tabela*/	,"Quantidade Componente"	 ,PesqPict("SG1","G1_QUANT")	,TamSx3("G1_QUANT")[1]		,/*lPixel*/,{|| nQtdComp			})		// QUANTIDADE
	TRCell():New(oSection,"UM"			,/*Tabela*/	,"Unidade Componente"		 ,PesqPict("SB1","B1_UM")		,TamSx3("B1_UM")[1]			,/*lPixel*/,{|| Alltrim(cUniComp)	})		// UNIDADE DO PRODUTO


	//Quebras do relatorio
	//oQuebra := TRBreak():New(oSection, oSection:Cell("B1_COD"), {||"Quebra por PRODUTO"}, .F.)
	
	//Totalizadores
	//TRFunction():New(oSection:Cell("C7_EMISSAO"), , "COUNT", oQuebra, , "@!", , .F.)
	
Return oReport

/*/{Protheus.doc} U_fRepPrint
Impressao do relatorio zRelator
@author TIAGO DIAS
@since 14/07/2022
@version 1.0
@type function
/*/

User Function fRepPrint(oReport, aRetorno)
	//PARÂMETRO
	Local cFiltra   := Alltrim(aRetorno[1])

	//QUERY
	Local cQuery 	:= ""
	Local nTotal	:= 0
	Local nAtual	:= 0

	//Pegando as secoes do relatorio
	oSecao := oReport:Section(1)

		//QUERY RETORNA TODOS OS ITENS DA SB1 QUE CONTEM SG1
		cQuery += "SELECT "										+ STR_PULA
		cQuery += "B1_COD,"										+ STR_PULA
		cQuery += "B1_DESC,"									+ STR_PULA
		cQuery += "B1_TIPO,"									+ STR_PULA
		cQuery += "B1_UM,"										+ STR_PULA
		cQuery += "G1_COMP,"									+ STR_PULA
		cQuery += "G1_QUANT"									+ STR_PULA
		cQuery += "FROM "+RETSQLNAME("SB1")+" SB1 (NOLOCK) "	+ STR_PULA
		cQuery += "INNER JOIN "+RETSQLNAME("SG1")+" SG1 ON "	+ STR_PULA
		cQuery += "G1_FILIAL = '"+FWxFilial("SG1")+"' AND "		+ STR_PULA
		cQuery += "G1_COD = B1_COD AND SG1.D_E_L_E_T_ ='' "		+ STR_PULA
		cQuery += "WHERE B1_FILIAL ='"+FWxFilial("SB1")+"' "	+ STR_PULA
		cQuery += "AND SB1.D_E_L_E_T_ ='' "						+ STR_PULA

		if !empty(cFiltra)
			cQuery += " AND B1_TIPO ='" +cFiltra+"' "				+ STR_PULA
		endif

		cQuery += "ORDER BY B1_COD"									+ STR_PULA

	
	//Executando consulta e setando o total da regua
	PlsQuery(cQuery, "QRY_REP")
	DbSelectArea("QRY_REP")
	Count to nTotal
	oReport:SetMeter(nTotal)

		//Posiciona para pegar informações de componente
		SB1->(dbSetOrder(1))
		SB1->(DbGotop())
	
	//Enquanto houver dados
	oSecao:Init()
	QRY_REP->(DbGoTop())
	While ! QRY_REP->(Eof()) //.and. nAtual < 1000

		cCodProd  := QRY_REP->B1_COD
		cCodComp  := QRY_REP->G1_COMP
		cUniProd  := QRY_REP->B1_UM
		cDescProd := QRY_REP->B1_DESC
		cTipoProd := QRY_REP->B1_TIPO
		//nQtdComp  := cValToChar(QRY_REP->G1_QUANT)
		nQtdComp  := QRY_REP->G1_QUANT


		if SB1->(dbSeek(xFilial("SB1")+ cCodComp))

			cTipoComp := SB1->B1_TIPO
			cDescComp := SB1->B1_DESC
			cUniComp  := SB1->B1_UM

			if cTipoComp == 'BN' .OR. cTipoComp == 'MI' .OR. cTipoComp == 'MP' .OR. cTipoComp == 'PA' .OR.  cTipoComp == 'ME' .OR.  cTipoComp == 'PI'
				//Incrementando a regua
				nAtual++
				oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
				oReport:IncMeter()
				
				//Imprimindo a linha atual
				oSecao:PrintLine()

			ENDIF

		ENDIF

		QRY_REP->(DbSkip())

	EndDo

	oSecao:Finish()
	QRY_REP->(DbCloseArea())
	
	//FWRestArea(aArea)

Return
