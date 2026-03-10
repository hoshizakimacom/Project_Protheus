#include "Protheus.Ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M04R09    ºAutor  ³Marcos Rocha	     º Data ³  10/02/25   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Analise de OP                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom 		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04R09()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

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

c_Perg := "M04R09"
//ValidPerg()

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
oReport := TReport():New("M04R09","Relatório de Analise de OP/WIP","M04R09", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite com movimentos da Op x WIP !")
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
oVenProd := TRSection():New(oReport,"Rel. Analise de OP/WIP",{"SC2","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"OP"	        ,/*Tabela*/	,"Ordem Prod." ,PesqPict("SD3","D3_OP")	     ,TamSx3("D3_OP")[1]      ,/*lPixel*/,{|| cOP })		// Código do Produto
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Emissao"	   ,PesqPict("SC2","C2_EMISSAO") ,TamSx3("C2_EMISSAO")[1] ,/*lPixel*/,{|| dEmissao})		// Armazem de estoque
TRCell():New(oVenProd,"COD_PROD"	,/*Tabela*/ ,"Produto"	   ,PesqPict("SB1","B1_COD")	 ,TamSx3("B1_COD")[1]	  ,/*lPixel*/,{|| cProduto})		// Descrição do Produto

TRCell():New(oVenProd,"QTD_OP"      ,/*Tabela*/ ,"Quant.OP."   ,PesqPict("SC2","C2_QUANT")	 ,TamSx3("C2_QUANT")[1]	  ,/*lPixel*/,{|| nQtdOP   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_PROD"    ,/*Tabela*/ ,"Quant.Prod." ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nQtdProd })		// Quantidade em pedido de vendas

TRCell():New(oVenProd,"COD_COMP"	,/*Tabela*/ ,"Componente"  ,PesqPict("SB1","B1_COD")	 ,TamSx3("B1_COD")[1]	  ,/*lPixel*/,{|| cComponente})		// Descrição do Produto
TRCell():New(oVenProd,"DESC_COMP"	,/*Tabela*/ ,"Desc.Comp"   ,PesqPict("SB1","B1_DESC")	 ,50	                  ,/*lPixel*/,{|| cDescComp })		// Descrição do Produto

TRCell():New(oVenProd,"DATA_REQ"	,/*Tabela*/ ,"Dt.Req."	  ,PesqPict("SD3","D3_EMISSAO")  ,TamSx3("D3_EMISSAO")[1] ,/*lPixel*/,{|| dDtReq})		    // Armazem de estoque
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"	      ,PesqPict("SB1","B1_TIPO")     ,TamSx3("B1_TIPO")[1]    ,/*lPixel*/,{|| cTipoComp })		// Descrição do Produto
TRCell():New(oVenProd,"CST_STD"		,/*Tabela*/ ,"Cst.Std"	  ,PesqPict("SB1","B1_CUSTD")    ,TamSx3("B1_CUSTD")[1]   ,/*lPixel*/,{|| nCstStd })		// Descrição do Produto

TRCell():New(oVenProd,"PICKING"		,/*Tabela*/ ,"Picking"	   ,PesqPict("SB1","B1_XPICLIS") ,3	  ,/*lPixel*/,{|| cPicking })		// Descrição do Produto
TRCell():New(oVenProd,"FANTASMA"	,/*Tabela*/ ,"Fantasma"	   ,PesqPict("SB1","B1_XKBAN")   ,3	  ,/*lPixel*/,{|| cFantasma})		// Descrição do Produto
TRCell():New(oVenProd,"KANBAN"		,/*Tabela*/ ,"KanBan"	   ,PesqPict("SB1","B1_XKBAN")	 ,3	  ,/*lPixel*/,{|| cKanBan  })		// Descrição do Produto

TRCell():New(oVenProd,"QTD_ESTRU"  ,/*Tabela*/ ,"Qtd.Estr.."   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nQtdEstr })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_REQ"    ,/*Tabela*/ ,"Qtd.Req."	   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nQtdReq  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_EMP"    ,/*Tabela*/ ,"Qtd.Emp."	   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nQtdEmp  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_TR_99"  ,/*Tabela*/ ,"Qtd_Tr_99"	   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nTran99  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"SLD_EMP"    ,/*Tabela*/ ,"Sld.Emp."	   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nSldEmp  })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"SLD_99"     ,/*Tabela*/ ,"Sld.99"	   ,PesqPict("SC2","C2_QUJE")	 ,TamSx3("C2_QUJE")[1]	  ,/*lPixel*/,{|| nSld99   })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"ETAPA"       ,/*Tabela*/ ,"Etapa"	   ,PesqPict("SB1","B1_TIPO")	 ,TamSx3("B1_TIPO")[1]	  ,/*lPixel*/,{|| cEtapa})		// Descrição do Produto

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
 
Private aEstrutura := {}
Private MPAR01 := DtoS(MV_PAR01)
Private MPAR02 := DtoS(MV_PAR02)
Private cDataZG1 := Left(GetMv("AM_PROCZG1"),10)
cDataZG1 := SubStr(cDataZG1,7,4)+SubStr(cDataZG1,4,2)+Left(cDataZG1,2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasQry

SELECT OP, 

ISNULL((SELECT MAX(C2_EMISSAO) FROM %Table:SC2% WHERE C2_FILIAL = %xFilial:SC2%
	AND C2_NUM+C2_ITEM+C2_SEQUEN = LEFT(OP,11)
	AND %NotDel%),' ') EMISSAO,

COD_PROD, 

ISNULL((SELECT MAX(C2_QUANT) FROM %Table:SC2% WHERE C2_FILIAL = %xFilial:SC2%
	AND C2_NUM+C2_ITEM+C2_SEQUEN = LEFT(OP,11)
	AND %NotDel%),' ') QTD_OP,

QTD_PROD, COD_COMP, 

ISNULL((SELECT MAX(B1_DESC) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') DESC_COMP,

 DATA_REQ,

ISNULL((SELECT MAX(B1_TIPO) FROM %Table:SB1% SB1 WHERE B1_FILIAL = ' ' 
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') TIPO,

ISNULL((SELECT MAX(B1_CUSTD) FROM %Table:SB1% SB1 WHERE B1_FILIAL = ' ' 
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') CST_STD,


(CASE WHEN ISNULL((SELECT MAX(B1_XPICLIS) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') = '1' THEN 'SIM' ELSE 'NAO' END) PICKING,

(CASE WHEN ISNULL((SELECT MAX(B1_FANTASM) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') = 'S' THEN 'SIM' ELSE 'NAO' END) FANTASMA,

(CASE WHEN ISNULL((SELECT MAX(B1_XKBAN) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = COD_COMP
	AND %NotDel%),' ') = '1' THEN 'SIM' ELSE 'NAO' END) KANBAN,

(QTD_ESTRU * QTD_PROD) QTD_ESTRU,

QTD_REQ,

(ISNULL((SELECT SUM(D4_QTDEORI) FROM %Table:SD4% SD4 WHERE D4_FILIAL = %xFilial:SD4%
	AND D4_OP = OP
	AND D4_COD = COD_COMP
	AND %NotDel%),0) )  QTD_EMP,

(ISNULL((SELECT SUM(D4_QUANT) FROM %Table:SD4% SD4 WHERE D4_FILIAL = %xFilial:SD4%
	AND D4_OP = OP
	AND D4_COD = COD_COMP
	AND %NotDel%),0) ) SLD_EMP,

(ISNULL((SELECT SUM(B2_QATU) FROM %Table:SB2% SB2 WHERE B2_FILIAL = %xFilial:SB2%
	AND B2_LOCAL = '99'
	AND B2_COD = COD_COMP
	AND %NotDel%),0) ) SLD_99,

QTD_TR_99

FROM (

SELECT OP, 
(SELECT MAX(D3_COD) 
	FROM %Table:SD3% SD3
	WHERE D3_FILIAL = %xFilial:SD3%
	AND D3_EMISSAO BETWEEN %Exp:MPAR01% AND  %Exp:MPAR02%
	AND LEFT(D3_CF,2) = 'PR'
	AND D3_OP = OP
	AND %NotDel%) COD_PROD,

(SELECT MAX(D3_QUANT) 
	FROM %Table:SD3% SD3
	WHERE D3_FILIAL = %xFilial:SD3%
	AND D3_EMISSAO BETWEEN %Exp:MPAR01% AND  %Exp:MPAR02%
	AND LEFT(D3_CF,2) = 'PR'
	AND D3_OP = OP
	AND %NotDel%) QTD_PROD,

COD_COMP, 
SUM(QTD_ESTRU) QTD_ESTRU,
SUM(QTD_REQ) QTD_REQ,
MAX(DATA_REQ) DATA_REQ,

ISNULL((SELECT SUM(D3_QUANT) 
	FROM %Table:SD3% SD32
	WHERE D3_FILIAL = %xFilial:SD3%
	AND D3_EMISSAO BETWEEN %Exp:MPAR01% AND  %Exp:MPAR02%
	AND D3_LOCAL = '99'
	AND D3_CF IN ('DE4')
	AND D3_COD = COD_COMP
	AND D3_XOP = OP
	AND %NotDel%),0) QTD_TR_99

FROM (

SELECT D3_OP OP, D3_COD COD_COMP, D3_QUANT QTD_REQ , D3_EMISSAO DATA_REQ, 0 QTD_ESTRU
FROM %Table:SD3% SD3
WHERE D3_FILIAL = %xFilial:SD3%
AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND  %Exp:MV_PAR02%
AND LEFT(D3_CF,2) = 'RE'
AND LEFT(D3_COD,3) <> 'MO-'
AND D3_OP <> ' '
AND D3_OP BETWEEN %Exp:MV_PAR03% AND  %Exp:MV_PAR04%
AND SD3.%NotDel%

UNION ALL

SELECT D3_OP OP, ZG1_COMP COD_COMP, 0 QTD_REQ , '' DATA_REQ, ZG1_QUANT QTD_ESTRU
FROM %Table:SD3% SD3, %Table:ZG1% ZG1
WHERE D3_FILIAL = %xFilial:SD3%
AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND  %Exp:MV_PAR02%
AND LEFT(D3_CF,2) = 'PR'
AND LEFT(D3_COD,3) <> 'MO-'
AND D3_OP <> ' '
AND D3_OP BETWEEN %Exp:MV_PAR03% AND  %Exp:MV_PAR04%
AND SD3.%NotDel%
AND ZG1_FILIAL = %xFilial:ZG1%
AND ZG1_DTINCL = %Exp:cDataZG1%
AND ZG1_COD = D3_COD
AND LEFT(ZG1_COMP,3) <> 'MO-'
AND ZG1.%NotDel%

) TAB
GROUP BY OP, COD_COMP

) TAB2
ORDER BY OP, COD_COMP

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

	cOP         := (cAliasQry)->OP
	dEmissao    := Stod((cAliasQry)->EMISSAO)
	cProduto    := (cAliasQry)->COD_PROD
	nQtdOP      := (cAliasQry)->QTD_OP
	nQtdProd    := (cAliasQry)->QTD_PROD
	cComponente := (cAliasQry)->COD_COMP
	cDescComp   := (cAliasQry)->DESC_COMP

	dDTReq    	:= Stod((cAliasQry)->DATA_REQ)
	cTipoComp 	:= (cAliasQry)->TIPO
	nCstStd   	:= (cAliasQry)->CST_STD

	cPicking    := (cAliasQry)->PICKING
	cFantasma   := (cAliasQry)->FANTASMA
	cKanBan     := (cAliasQry)->KANBAN
	nQtdReq     := (cAliasQry)->QTD_REQ

	nQtdEstr    := (cAliasQry)->QTD_ESTRU
	nQtdEmp     := (cAliasQry)->QTD_EMP
	nSldEmp     := (cAliasQry)->SLD_EMP
	nSld99      := (cAliasQry)->SLD_99
	nTran99     := (cAliasQry)->QTD_TR_99
	cEtapa      := " "
	
	oReport:IncMeter()
	oReport:Section(1):PrintLine()

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
±±ºFun‡„o    ³ValidPerg º Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function ValidPerg()
//
//Local _sAlias := Alias()
//Local aRegs := {}
//Local i,j
//
//dbSelectArea("SX1")
//dbSetOrder(1)
//c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))
//
//// Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
//aAdd(aRegs,{c_Perg,"01"  ,"Emissao De ?      ",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//aAdd(aRegs,{c_Perg,"02"  ,"Emissao Até ?     ",""      ,""     ,"MV_CH2","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//aAdd(aRegs,{c_Perg,"03"  ,"Ordem Prod. De ?  ",""      ,""     ,"MV_CH3","C"    ,11      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//aAdd(aRegs,{c_Perg,"04"  ,"Ordem Prod. Até ? ",""      ,""     ,"MV_CH4","C"    ,11      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
////aAdd(aRegs,{c_Perg,"05"  ,"qUANTO.Estrut.? ",""      ,""     ,"MV_CH5","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//
//For i:=1 to Len(aRegs)
//	If !dbSeek(c_Perg+aRegs[i,2])
//		RecLock("SX1",.T.)
//		For j:=1 to FCount()
//			If j <= Len(aRegs[i])
//				FieldPut(j,aRegs[i,j])
//			Endif
//		Next
//		MsUnlock()
//	EndIf	
//Next
//
//dbSelectArea(_sAlias)
//
//Return Nil
