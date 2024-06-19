#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
                
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M04R05   ³ Autor ³ Marcos Rocha          ³ Data ³ 30/10/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Inventário - ACD                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Macom - Temporario devido a erros monitor ACD   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M04R05()

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
±±³Programa  ³ReportDef ³ Autor ³ Marcos Rocha          ³ Data ³ 21/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
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
oReport := TReport():New("M04R05","Análise Inventario ACD","M04R05", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite divergencias de inventario !")
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
oVenProd := TRSection():New(oReport,"Analise Inventario ACD",{"CBA","CBC"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"CODINV"		,/*Tabela*/	,"Cod.Inv."	 		 ,PesqPict("SB2","B2_COD")		,TamSx3("B2_COD")[1]		,/*lPixel*/,{|| cCodInv})		// Código do Produto
TRCell():New(oVenProd,"LOCEST"		,/*Tabela*/ ,"Armazem"			 ,PesqPict("SB2","B2_LOCAL")	,TamSx3("B2_LOCAL")[1]		,/*lPixel*/,{|| cLocal	})		// Armazem de estoque
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"		     ,PesqPict("SB1","B1_COD")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cProduto})		// Descrição do Produto
TRCell():New(oVenProd,"DESC"		,/*Tabela*/ ,"Descriçao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cDesc	})		// Descrição do Produto
TRCell():New(oVenProd,"QTD_PRIM"	,/*Tabela*/ ,"Prim.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQPrim   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_SEGUM"	,/*Tabela*/ ,"Segum.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQSegum })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_TERC"	,/*Tabela*/ ,"terc.Cont. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQTerc  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"SLDEST"	    ,/*Tabela*/ ,"Sld.Est. "	     ,PesqPict("SB2","B2_QPEDVEN")	,TamSx3("B2_QPEDVEN")[1]	,/*lPixel*/,{|| nQEst   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"OBSERVACAI"  ,/*Tabela*/ ,"Observacao"		 ,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cObserva})		// Descrição do Produto

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")		// Cadastro do produto
dbSetOrder(1)			// Produto,Local

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry

	SELECT CODINV, PRODUTO, LOCEST, 
	QTD_PRIM,
	QTD_SEGUM,
	QTD_TERC, 
	SLDEST,
	(CASE WHEN SLDEST > 0  AND QTD_PRIM = 0  THEN '1A CONTAGEM PENDENTE' 
	  	WHEN SLDEST > 0  AND QTD_SEGUM = 0 THEN '2A CONTAGEM PENDENTE' 
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM = QTD_SEGUM AND QTD_PRIM = SLDEST  THEN 'CONTAGEM COMPLETA - OK COM SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM = QTD_SEGUM AND QTD_PRIM <> SLDEST THEN 'CONTAGEM COMPLETA - DIF SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC = 0      THEN 'FAZER 3A CONTAGEM' 
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC <> 0 AND QTD_TERC = SLDEST  THEN '3A CONTAGEM OK - OK COM SLD'
	  	WHEN (QTD_PRIM <> 0 OR QTD_SEGUM <> 0) AND QTD_PRIM <> QTD_SEGUM AND QTD_TERC <> 0 AND QTD_TERC <> SLDEST THEN '3A CONTAGEM OK - DIF SLD'
	  	ELSE 'ANALISAR' END ) OBSERVACAO
		  FROM (
	SELECT CODINV, PRODUTO, LOCEST, 
	SUM(QTD_PRIM) QTD_PRIM,
	SUM(QTD_SEGUM) QTD_SEGUM,
	SUM(QTD_TERC) QTD_TERC, 
	SUM(SLDEST) SLDEST
	FROM (

	SELECT CBG_CODINV CODINV, CBG_CODPRO PRODUTO, CBG_ARM LOCEST, 
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '1' THEN CBG_QTDE ELSE 0 END ) QTD_PRIM,
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '2' THEN CBG_QTDE ELSE 0 END ) QTD_SEGUM,
	(CASE WHEN SUBSTRING(CBG_CODOPE,6,1) = '3' THEN CBG_QTDE ELSE 0 END ) QTD_TERC,
	(SELECT B2_QATU FROM SB2010 SB2 WHERE B2_FILIAL = '01' 
    	AND B2_COD = CBG_CODPRO
     	AND B2_LOCAL = CBG_ARM
	  	AND D_E_L_E_T_ <> '*' )  SLDEST

	FROM %Table:CBG% CBG
	WHERE CBG_FILIAL = '01' 
	AND CBG_CODINV  %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
	AND CBG_CODPRO  %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND 
	AND CBG_QTDE <> 0
	AND CBG.%NotDel% ) TAB 
	GROUP BY CODINV, PRODUTO, LOCEST ) TAB2

	EndSql 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	cCodiInv  := (cAliasQry)->CODINV
	cLocal	  := (cAliasQry)->LOCEST
	cOperador := (cAliasQry)->OPERAD

	cProduto  := (cAliasQry)->PRODUTO
	cDesc     := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->PRODUTO,"B1_DESC"),30)
	nQPrim    := (cAliasQry)->QTD_PRIM
	nQSegum   := (cAliasQry)->QTD_SEGUM
	nQTerc    := (cAliasQry)->QTD_TERC
	nQEst     := (cAliasQry)->SLDEST
	cObserva  := (cAliasQry)->OBSERVACAO



	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	nComp	:= 0
	nLarg	:= 0
	nAlt	:= 0
	nPeso	:= 0
	nM3		:= 0

	(cAliasQry)->(dbSkip())
EndDo
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()


Return(oReport)
