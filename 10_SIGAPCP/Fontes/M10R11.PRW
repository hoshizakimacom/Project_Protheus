#Include "PROTHEUS.Ch"
#INCLUDE "MATR620.ch"
                

/*-----------------------------------------------------------------------------------------*/
// FUN��O PRINCIPAL
User Function M10R11()

	Local oReport

	If FindFunction("TRepInUse") .And. TRepInUse()
		//-- Interface de impressao
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

Return
// FIM DA FUN��O PRINCIPAL
/*-----------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------*/
// APRESENTA��O DE DADOS
Static Function ReportDef()

	Local oReport
	Local oVenProd
	Local cAliasQry := GetNextAlias()


	oReport := TReport():New("M10R11","Relacao Dos Apontamentos de Produ��o","M10R11", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao dos apontamentos das " + " " + "Ordens de Produ��o. ")
	oReport:SetTotalInLine(.F.)

	Pergunte(oReport:uParam,.F.)

	oVenProd := TRSection():New(oReport,"APONTAMENTOS DE OPs",{"SD3","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao das Ordens de Produ��o"
	oVenProd:SetTotalInLine(.F.)

	//������������������������������������������������������������������������Ŀ
	//�Define celulas da secao                                                 �
	//��������������������������������������������������������������������������
	TRCell():New(oVenProd,"NUMOP"		,/*Tabela*/	,"Num.OP"	 		 ,PesqPict("SD3","D3_OP")		,TamSx3("D3_OP")[1]			,/*lPixel*/,{|| cNumOP	})	// Numero da Ordem de Produ��o
	TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Codigo Produto"	 ,PesqPict("SD3","D3_COD")		,TamSx3("D3_COD")[1]		,/*lPixel*/,{|| cCodProd})	// C�digo do Produto
	TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descri�ao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})	// Descri��o do Produto
	TRCell():New(oVenProd,"TIPO"        ,/*Tabela*/ ,"Tipo"              ,PesqPict("SB1","B1_TIPO")     ,TamSx3("B1_TIPO")[1]       ,/*lPixel*/,{|| cTipo   })  // Tipo do Produto
	TRCell():New(oVenProd,"FAMILIA"     ,/*Tabela*/ ,"Familia"           ,PesqPict("SB1","B1_XFAMILI")  ,TamSx3("B1_XFAMILI")[1]    ,/*lPixel*/,{|| cFamilia})  // Familia de Produtos
	TRCell():New(oVenProd,"ARMAZEM"		,/*Tabela*/ ,"Armazem"			 ,PesqPict("SD3","D3_LOCAL")	,TamSx3("D3_LOCAL")[1]		,/*lPixel*/,{|| cLocal	})	// Armazem
	TRCell():New(oVenProd,"QTDAPON"		,/*Tabela*/ ,"Qtd. Apontada"	 ,PesqPict("SD3","D3_QUANT")	,TamSx3("D3_QUANT")[1]		,/*lPixel*/,{|| nQtdApon})	// Quantidade apontada (produzida)
	TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Dt.Apontamento"	 ,PesqPict("SD3","D3_EMISSAO")  ,TamSx3("D3_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmiss})	// Data de Emiss�o da O.P.
	TRCell():New(oVenProd,"OPERADOR"	,/*Tabela*/ ,"Operador"	         ,PesqPict("SD3","D3_USUARIO")  ,TamSx3("D3_USUARIO")[1]	,/*lPixel*/,{|| cUsuario})	// Operador que efetuou o apontamento
	TRCell():New(oVenProd,"PARCTOT"		,/*Tabela*/ ,"Parcial/Total"	 ,PesqPict("SD3","D3_PARCTOT")	,TamSx3("D3_PARCTOT")[1]	,/*lPixel*/,{|| cParcTot})	// Parcial Total
	TRCell():New(oVenProd,"NUMSER"		,/*Tabela*/ ,"Numero Serie"		 ,PesqPict("SD3","D3_XNSERIE")	,TamSx3("D3_XNSERIE")[1]	,/*lPixel*/,{|| cNumSer})	// Numero de Serie
	TRCell():New(oVenProd,"NUMNF"		,/*Tabela*/ ,"Numero da NF"		 ,PesqPict("SC6","C6_NOTA")		,TamSx3("C6_NOTA")[1]		,/*lPixel*/,{|| cNumNF})	// Numero da NF #3791
	TRCell():New(oVenProd,"DTFAT"		,/*Tabela*/ ,"Data Ult. FAt"	 ,PesqPict("SC6","C6_DATFAT")	,TamSx3("C6_DATFAT")[1]		,/*lPixel*/,{|| dDtFat})	// Data do �ltimo Faturamento #3791
Return(oReport)
// FIM DA APRESENTA��O DE DADOS
/*-----------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------*/
// QUERY + TRATAMENTO
Static Function ReportPrint(oReport,cAliasQry,oVenProd)

	Local lPosB1	:= .F.

	//������������������������������������������������������������������������Ŀ
	//�Filtragem do relat�rio                                                  �
	//��������������������������������������������������������������������������
	dbSelectArea("SB1")		// Cadastro do Produt
	dbSetOrder(1)			// Filial+Produto - �ndice da tabela

	#IFDEF TOP
		
		// IN�CIO DA QUERY                                       
		/*-------------------------------------------------------------------------------*/

		oReport:Section(1):BeginQuery()	

		BeginSql Alias cAliasQry
		
			SELECT 
				D3_FILIAL,D3_COD,D3_QUANT,D3_CF,D3_LOCAL,D3_DOC
				,D3_EMISSAO,D3_PARCTOT,D3_OP,D3_USUARIO,D3_XNSERIE
				,C6_DATFAT,C6_NOTA
			FROM 
				%Table:SD3% SD3
				LEFT JOIN SC6010 SC6 //#3791
					ON SD3.D_E_L_E_T_ = ' '
					AND D3_COD = C6_PRODUTO
					AND LEFT (D3_OP,8) = (C6_NUMOP + C6_ITEMOP)//#3791
			WHERE 
				SD3.D3_FILIAL = '01' AND
				SD3.D3_EMISSAO >= %Exp:MV_PAR01% AND 
				SD3.D3_EMISSAO <= %Exp:MV_PAR02% AND
				SD3.D3_CF = 'PR0' AND
				SD3.%NotDel%
			ORDER BY SD3.D3_EMISSAO
		EndSql 

		// FIM DA QUERY
		/*-------------------------------------------------------------------------------*/

		oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	#ENDIF		

	//������������������������������������������������������������������������Ŀ
	//�Inicio da impressao do fluxo do relat�rio                               �
	//��������������������������������������������������������������������������
	dbSelectArea(cAliasQry)
	dbGoTop()
	oReport:SetMeter((cAliasQry)->(LastRec()))
	oReport:Section(1):Init()

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		lPosB1 	:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->D3_COD))
		
		If lPosB1
			cCodigo  := SB1->B1_COD
			cDesc	 := SB1->B1_DESC
			cTipo    := SB1->B1_TIPO
			cFamilia := Alltrim(SB1->B1_XDSCFAM)
		Else
			cCodigo  := "Nao cadastrado"
			cDesc	 := "Nao cadastrado"
			cFamilia := "Nao cadastrado"
			cTipo    := "Nao cadastrado"
		Endif		
		cNumOP      := (cAliasQry)->D3_OP
		cCodProd    := (cAliasQry)->D3_COD
		cLocal      := (cAliasQry)->D3_LOCAL
		nQtdApon	:= (cAliasQry)->D3_QUANT    
		dDtEmiss    := (cAliasQry)->D3_EMISSAO
		cUsuario	:= (cAliasQry)->D3_USUARIO
		cParcTot    := IIF((cAliasQry)->D3_PARCTOT == "T","TOTAL","PARCIAL")
		cNumSer		:= (cAliasQry)->D3_XNSERIE

		cNumNF 		:= IIF((cAliasQry)->C6_NOTA != " ",C6_NOTA,"NF N�O EMITIDA") //#3791
		dDtFat		:= (cAliasQry)->C6_DATFAT //#3791
		

		oReport:IncMeter()
		oReport:Section(1):PrintLine()

		(cAliasQry)->(dbSkip())
	End
	
	dbSelectArea(cAliasQry)

	oReport:SetLandScape()
	oReport:Section(1):Finish()

Return
// FIM DA QUERY + TRATAMENTO
/*-----------------------------------------------------------------------------------------*/
