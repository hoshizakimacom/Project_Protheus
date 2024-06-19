#Include "PROTHEUS.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M34R11   ³ Autor ³ Marcos Rocha          ³ Data ³ 06/03/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Razao Contabil por Usuario                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espeficico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M34R11()

Local oReport
oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³                       ³ Data ³ 29/01/19 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oLanctos
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
oReport := TReport():New("M34R11","Razao Contabil","M34R11", {|oReport| ReportPrint(oReport,cAliasQry)},"Este relatorio emite os movimentos de contas x centros de custo por acesso de usuario ")
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

oLanctos := TRSection():New(oReport,"Razao Contabil",{"CT2","CT1"},/*{Array com as ordens do relatï¿½rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oLanctos:SetTotalInLine(.F.)
oLanctos:oReport:cFontBody := "Verdana"
oLanctos:oReport:nFontBody := 10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oLanctos,"FILIAL"	        ,/*Tabela*/	,"Filial"	 ,PesqPict("CT2","CT2_FILIAL")	,TamSx3("CT2_FILIAL")[1]  ,/*lPixel*/,{|| cCodFil	})				
TRCell():New(oLanctos,"DATALC"	        ,/*Tabela*/	,"Data"	 	 ,PesqPict("CT2","CT2_DATA")	,TamSx3("CT2_DATA")[1]    ,/*lPixel*/,{|| dData 	})				
TRCell():New(oLanctos,"LOTE"	        ,/*Tabela*/	,"Lote"		 ,PesqPict("CT2","CT2_LOTE")	,TamSx3("CT2_LOTE")[1]    ,/*lPixel*/,{|| cLote	})				
TRCell():New(oLanctos,"SUBLOTE"	        ,/*Tabela*/	,"SubLote"	 ,PesqPict("CT2","CT2_SBLOTE")	,TamSx3("CT2_SBLOTE")[1]  ,/*lPixel*/,{|| cSubLote	})				
TRCell():New(oLanctos,"DOC"	            ,/*Tabela*/	,"Documento" ,PesqPict("CT2","CT2_DOC")	    ,TamSx3("CT2_DOC")[1]     ,/*lPixel*/,{|| cDoc	})				
TRCell():New(oLanctos,"LINHA"	        ,/*Tabela*/	,"Linha"     ,PesqPict("CT2","CT2_LINHA")	,TamSx3("CT2_LINHA")[1]   ,/*lPixel*/,{|| cLinha	})				
TRCell():New(oLanctos,"DEBITO"          ,/*Tabela*/	,"Debito"    ,PesqPict("CT2","CT2_DEBITO")	,TamSx3("CT2_DEBITO")[1]  ,/*lPixel*/,{|| cDebito	})				
TRCell():New(oLanctos,"CREDITO"	        ,/*Tabela*/,"Credito"    ,PesqPict("CT2","CT2_CREDIT")	,TamSx3("CT2_CREDIT")[1]  ,/*lPixel*/,{|| cCredito	})				
TRCell():New(oLanctos,"DESC_CONTA"	   ,/*Tabela*/	,"Desc.Conta",PesqPict("CT1","CT1_DESC01")	,TamSx3("CT1_DESC01")[1]  ,/*lPixel*/,{|| cDescCta	})				
TRCell():New(oLanctos,"VALOR"	       ,/*Tabela*/	,"Valor"     ,PesqPict("CT2","CT2_VALOR")	,TamSx3("CT2_VALOR")[1]   ,/*lPixel*/,{|| nValor 	})				
TRCell():New(oLanctos,"HISTORICO"      ,/*Tabela*/	,"Historico" ,PesqPict("CT2","CT2_HIST")	,TamSx3("CT2_HIST")[1]    ,/*lPixel*/,{|| cHist	})
//TRCell():New(oLanctos,"HISTORIC2"      ,/*Tabela*/	,"Historico" ,PesqPict("CT2","CT2_HIST")	,TamSx3("CT2_HIST")[1]    ,/*lPixel*/,{|| cHist2	})
//TRCell():New(oLanctos,"HISTORIC3"      ,/*Tabela*/	,"Historico" ,PesqPict("CT2","CT2_HIST")	,TamSx3("CT2_HIST")[1]    ,/*lPixel*/,{|| cHist3	})
TRCell():New(oLanctos,"CC_DEBITO"	   ,/*Tabela*/	,"CC.Debito" ,PesqPict("CT2","CT2_CCD")	    ,TamSx3("CT2_CCD")[1]     ,/*lPixel*/,{|| cCCD	})				
TRCell():New(oLanctos,"CC_CREDITO"	   ,/*Tabela*/	,"CC.Credito",PesqPict("CT2","CT2_CCC")	    ,TamSx3("CT2_CCC")[1]     ,/*lPixel*/,{|| cCCC	})				
TRCell():New(oLanctos,"C_CUSTO"	       ,/*Tabela*/	,"C.Custo"   ,PesqPict("CTT","CTT_DESC01")  ,TamSx3("CTT_DESC01")[1]  ,/*lPixel*/,{|| cDescCC })				
TRCell():New(oLanctos,"COD_USU"	       ,/*Tabela*/	,"Cod.Usuar.",PesqPict("AKX","AKX_USER")    ,TamSx3("AKX_USER")[1]    ,/*lPixel*/,{|| cCodUsr	})				
TRCell():New(oLanctos,"USUARIO"	       ,/*Tabela*/	,"Usuario"   ,PesqPict("AKX","AKX_NOME")    ,TamSx3("AKX_NOME")[1]    ,/*lPixel*/,{|| cUser	})				
TRCell():New(oLanctos,"ITEM_CONTABIL"  ,/*Tabela*/	,"It_Ctb"    ,PesqPict("CT2","CT2_ITEMD")   ,TamSx3("CT2_ITEMD")[1]   ,/*lPixel*/,{|| cItemD	})				
TRCell():New(oLanctos,"ITEM_CONT_DESC" ,/*Tabela*/	,"Desc.Item" ,PesqPict("CTD","CTD_DESC01")  ,TamSx3("CTD_DESC01")[1]  ,/*lPixel*/,{|| cDescItD	})				
TRCell():New(oLanctos,"ITEM_CONT_DC"    ,/*Tabela*/	,"Desc.Item.Cred" ,PesqPict("CTD","CTD_DESC01")  ,TamSx3("CTD_DESC01")[1]  ,/*lPixel*/,{|| cDescItC	})

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³                	    ³ Data ³ 11/09/06 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry)

Local cCodUser  := RetCodUsr()
Local cDtIniRef := Dtos(Mv_par01)
Local cDtFimRef := Dtos(Mv_par02)

If AllTrim(cCodUser) == "000508" .Or.  AllTrim(cCodUser) == "000014" .Or.  AllTrim(cCodUser) == "000529"  // meduardo (add 000116)
	cCodUser  := mv_par03
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CT2")		// Itens do Pedido de Vendas
dbSetOrder(1)			// Produto,Numero

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasQry

//COLUMN DATALC AS DATE

SELECT 
CT2_FILIAL FILIAL,
CT2_DATA DATALC,
CT2_LOTE LOTE,
CT2_SBLOTE SUBLOTE,
CT2_DOC DOC,
CT2_LINHA LINHA,
CT2_DEBITO DEBITO,
CT2_CREDIT CREDITO,
CT1_DESC01 DESC_CONTA,
CT2_VALOR VALOR,
CT2_HIST HISTORICO,
//ISNULL((SELECT MAX(CT2_HIST) FROM %Table:CT2% CT22 WHERE CT22.CT2_FILIAL = %xFilial:CT2% AND CT22.CT2_LOTE = CT2.CT2_LOTE AND CT22.CT2_DATA = CT2.CT2_DATA AND CT22.CT2_SEQUEN = CT2.CT2_SEQUEN AND CT22.CT2_DC NOT IN ('3','4') AND CT22.%NotDel%  ) ,' ')
CT2_CCD CC_DEBITO,
CT2_CCC CC_CREDITO,
CTT_DESC01 C_CUSTO,
AKX_USER COD_USU,
AKX_NOME USUARIO,
CT2_ITEMD ITEM_CONTABIL,
ISNULL(CTD_DESC01,' ') ITEM_CONT_DESC,

(CASE WHEN CT2_ITEMC <> ' ' THEN CT2_ITEMC ELSE 
ISNULL((SELECT MAX(CT2_ITEMC) FROM %Table:CT2% CT22 
   WHERE CT22.CT2_FILIAL = %xFilial:CT2% AND CT22.CT2_LOTE = CT2.CT2_LOTE 
   AND CT22.CT2_DATA = CT2.CT2_DATA AND CT22.CT2_SEQUEN = CT2.CT2_SEQUEN 
   AND CT22.CT2_KEY = CT2.CT2_KEY 
   AND CT22.CT2_DC NOT IN ('3','4') AND CT22.%NotDel%  ) ,' ')
END) ITEM_CTBC

FROM %Table:CT2% CT2

INNER JOIN %Table:CT1% CT1 ON 
CT2_DEBITO = CT1_CONTA AND 
//CT2_DEBITO = '3110400020' AND

CT1_FILIAL = %xFilial:CT1% AND
CT1_XRELOR <> 'N' AND 
CT1.%NotDel%  

INNER JOIN %Table:CTT% CTT ON 
CTT_CUSTO = CT2_CCD AND 
CTT_FILIAL = %xFilial:CTT% AND 
CTT.%NotDel%

INNER JOIN %Table:AKX% AKX ON 
CT2_CCD BETWEEN AKX_CC_INI AND AKX_CC_FIN AND 
AKX_FILIAL = %xFilial:AKX% AND 
AKX.%NotDel%

LEFT JOIN %Table:CTD% CTD ON 
CTD_ITEM = CT2_ITEMD AND 
CTD_FILIAL = %xFilial:CTD% AND 
CTD.%NotDel%

WHERE CT2_FILIAL <> ' ' AND 
CT2_DATA BETWEEN %Exp:cDtIniRef% AND %Exp:cDtFimRef% AND 

CT2_DEBITO BETWEEN AKX_XCTADE AND AKX_XCTAAT AND
(LEFT(AKX_XCTCON,1) = ' ' OR CT2_DEBITO = LEFT(AKX_XCTCON,20)) AND
(LEFT(AKX_XCTNCO,1) = ' ' OR CT2_DEBITO <> LEFT(AKX_XCTNCO,20)) AND
CT2_DEBITO <> ' ' AND
CT2.%NotDel% AND 
AKX_USER = %Exp:cCodUser%

UNION  ALL

SELECT 
CT2_FILIAL FILIAL,
CT2_DATA DATALC,
CT2_LOTE LOTE,
CT2_SBLOTE SUBLOTE,
CT2_DOC DOC,
CT2_LINHA LINHA,
CT2_DEBITO DEBITO,
CT2_CREDIT CREDITO,
CT1_DESC01 DESC_CONTA,
(CT2_VALOR*(-1)) VALOR,
CT2_HIST HISTORICO,
//CT2_HIST HISTORIC2,
//CT2_HIST HISTORIC3,
CT2_CCD CC_DEBITO,
CT2_CCC CC_CREDITO,
CTT_DESC01 C_CUSTO,
AKX_USER COD_USU,
AKX_NOME USUARIO,
CT2_ITEMC ITEM_CONTABIL,
ISNULL(CTD_DESC01,' ') ITEM_CONT_DESC,
' ' ITEM_CTBC

FROM %Table:CT2% CT2

INNER JOIN %Table:CT1% CT1 ON 
CT2_CREDIT = CT1_CONTA AND 
//CT2_CREDIT = '3110400020' AND

CT1_FILIAL = %xFilial:CT1% AND 
CT1.%NotDel% 

INNER JOIN %Table:CTT% CTT ON 
CTT_CUSTO = CT2_CCC AND 
CTT_FILIAL = %xFilial:CTT% AND 
CT1_XRELOR <> 'N' AND 
CTT.%NotDel% 

INNER JOIN %Table:AKX% AKX ON 
CT2_CCC BETWEEN AKX_CC_INI AND AKX_CC_FIN AND 
AKX_FILIAL = %xFilial:AKX% AND 
AKX.%NotDel% 

LEFT JOIN %Table:CTD% CTD ON 
CTD_ITEM = CT2_ITEMC AND 
CTD_FILIAL = %xFilial:CTD% AND 
CTD.%NotDel%  

WHERE CT2_FILIAL <> ' ' AND 
CT2_DATA BETWEEN %Exp:cDtIniRef% AND %Exp:cDtFimRef% AND

CT2_CREDIT BETWEEN AKX_XCTADE AND AKX_XCTAAT AND
(LEFT(AKX_XCTCON,1) = ' ' OR CT2_CREDIT = LEFT(AKX_XCTCON,20)) AND
(LEFT(AKX_XCTNCO,1) = ' ' OR CT2_CREDIT <> LEFT(AKX_XCTNCO,20)) AND
CT2_CREDIT <> ' ' AND 
CT2.%NotDel%  AND 
AKX_USER = %Exp:cCodUser%

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
//oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasQry)
dbGoTop()

oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

   	cCodFil   := (cAliasQry)->FILIAL
	dData     := Stod((cAliasQry)->DATALC)
	cLote	  := (cAliasQry)->LOTE
	cSubLote  := (cAliasQry)->SUBLOTE
	cDoc      := (cAliasQry)->DOC
	cLinha    := (cAliasQry)->LINHA
	cDebito   := (cAliasQry)->DEBITO
	cCredito  := (cAliasQry)->CREDITO
	cDescCta  := (cAliasQry)->DESC_CONTA
	nValor    := (cAliasQry)->VALOR
	cHist     := (cAliasQry)->HISTORICO
	cCCD      := (cAliasQry)->CC_DEBITO
	cCCC      := (cAliasQry)->CC_CREDITO
	cDescCC   := (cAliasQry)->C_CUSTO
	cCodUsr   := (cAliasQry)->COD_USU
	cUser     := (cAliasQry)->USUARIO
	cItemD    := (cAliasQry)->ITEM_CONTABIL
	cDescItD  := If(!Empty((cAliasQry)->ITEM_CONTABIL), (cAliasQry)->ITEM_CONT_DESC," ")
	cDescItC  := " "

	If Empty((cAliasQry)->ITEM_CONTABIL) .And. !Empty((cAliasQry)->ITEM_CTBC)  // Busca a Descricao do Item Crédito (Fornecedor)
    	cDescItC := AllTrim((cAliasQry)->ITEM_CTBC)+" - "+ Posicione("CTD",1,xFilial("CTD")+ITEM_CTBC,"CTD_DESC01")
	EndIf

	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
Enddo
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return                          
