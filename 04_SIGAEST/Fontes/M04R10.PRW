#include "Protheus.Ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M04R10    ºAutor  ³Marcos Rocha	     º Data ³  17/02/25   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Consulta Transf x Requisição 99 (WIP)            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Macom 		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04R10()

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

c_Perg := "M04R10"
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
oReport := TReport():New("M04R10","Relatório de Transf. x Req. WIP","M04R10", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite com movimentos de Transf x Requisição de Processo  !")
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
oVenProd := TRSection():New(oReport,"Rel. Transf x Requisição 99 (WIP) ",{"SD3","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"PRODUTO"	     ,/*Tabela*/ ,"Produto"	    ,PesqPict("SB1","B1_COD")	  ,TamSx3("B1_COD")[1]	  ,/*lPixel*/,{|| cProduto})		// Descrição do Produto
TRCell():New(oVenProd,"EMISSAO"		 ,/*Tabela*/ ,"Emissao"	    ,PesqPict("SC2","C2_EMISSAO") ,TamSx3("C2_EMISSAO")[1] ,/*lPixel*/,{|| dEmissao})		// Armazem de estoque
TRCell():New(oVenProd,"OP"	         ,/*Tabela*/ ,"Ordem Prod." ,PesqPict("SD3","D3_OP")	  ,TamSx3("D3_OP")[1]      ,/*lPixel*/,{|| cOP })		// Código do Produto
TRCell():New(oVenProd,"QTD_TRANSF"   ,/*Tabela*/ ,"Qtd.Transf." ,PesqPict("SD3","D3_QUANT")	  ,TamSx3("D3_QUANT")[1]	  ,/*lPixel*/,{|| nQtdTransf })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"QTD_REQ"      ,/*Tabela*/ ,"Qtd.Requis." ,PesqPict("SD3","D3_QUANT")	  ,TamSx3("D3_QUANT")[1]	  ,/*lPixel*/,{|| nQtdReq })		// Quantidade em pedido de vendas
TRCell():New(oVenProd,"PICKING"		 ,/*Tabela*/ ,"Picking"	    ,PesqPict("SB1","B1_XPICLIS") ,3	  ,/*lPixel*/,{|| cPicking })		// Descrição do Produto
TRCell():New(oVenProd,"FANTASMA"	 ,/*Tabela*/ ,"Fantasma"    ,PesqPict("SB1","B1_XKBAN")   ,3	  ,/*lPixel*/,{|| cFantasma})		// Descrição do Produto
TRCell():New(oVenProd,"KANBAN"		 ,/*Tabela*/ ,"KanBan"	    ,PesqPict("SB1","B1_XKBAN")	 ,3	  ,/*lPixel*/,{|| cKanBan  })		// Descrição do Produto
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasQry

SELECT PRODUTO, EMISSAO, OP, SUM(QTD_TRANSF) QTD_TRANSF,
SUM(QTD_REG_TRF) QTD_LANC_TRF,
SUM(QTD_REQ) QTD_REQ, 
SUM(QTD_REG_REQ) QTD_LANC_REQ ,

(CASE WHEN ISNULL((SELECT MAX(B1_XPICLIS) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = PRODUTO
	AND %NotDel%),' ') = '1' THEN 'SIM' ELSE 'NAO' END) PICKING,

(CASE WHEN ISNULL((SELECT MAX(B1_FANTASM) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = PRODUTO
	AND %NotDel%),' ') = 'S' THEN 'SIM' ELSE 'NAO' END) FANTASMA,

(CASE WHEN ISNULL((SELECT MAX(B1_XKBAN) FROM %Table:SB1% SB1 WHERE B1_FILIAL = %xFilial:SB1%
	AND B1_COD = PRODUTO
	AND %NotDel%),' ') = '1' THEN 'SIM' ELSE 'NAO' END) KANBAN

FROM (

SELECT D3_COD PRODUTO, D3_EMISSAO EMISSAO, D3_XOP OP,
(CASE WHEN D3_CF = 'DE4' THEN D3_QUANT ELSE D3_QUANT*-1 END) QTD_TRANSF,
1 QTD_REG_TRF,
0 QTD_REQ,
0 QTD_REG_REQ 
FROM %Table:SD3% SD3
WHERE D3_FILIAL =  %xFilial:SD3%
AND D3_EMISSAO BETWEEN %Exp:MPAR01% AND  %Exp:MPAR02%
AND (D3_CF IN('DE4','RE4') AND D3_LOCAL = '99')
AND D3_COD BETWEEN %Exp:MV_PAR03% AND  %Exp:MV_PAR04%
AND %NotDel%

UNION ALL

SELECT D3_COD PRODUTO, D3_EMISSAO EMISSAO, D3_OP OP,
0 QTD_TRANSF, 
0 QTD_REG_TRF,
D3_QUANT QTD_REQ,
1 QTD_REG_REQ
FROM %Table:SD3% SD3
WHERE D3_FILIAL = %xFilial:SD3%
AND D3_EMISSAO BETWEEN %Exp:MPAR01% AND  %Exp:MPAR02%

AND (LEFT(D3_CF,2) = 'RE' AND D3_LOCAL = '99')
AND D3_OP <> ' '
AND D3_COD BETWEEN %Exp:MV_PAR03% AND  %Exp:MV_PAR04%
AND %NotDel%

) TAB
GROUP BY PRODUTO, EMISSAO, OP
ORDER BY PRODUTO, OP, EMISSAO

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

	cProduto    := (cAliasQry)->PRODUTO
	cOP         := (cAliasQry)->OP
	dEmissao    := Stod((cAliasQry)->EMISSAO)
	nQtdTransf  := (cAliasQry)->QTD_TRANSF
	nQtdReq    	:= (cAliasQry)->QTD_REQ

	nLancTr     := (cAliasQry)->QTD_LANC_TRF
	nLancReq    := (cAliasQry)->QTD_LANC_REQ 

	cPicking    := (cAliasQry)->PICKING
	cFantasma   := (cAliasQry)->FANTASMA
	cKanBan     := (cAliasQry)->KANBAN
	
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
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

// Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
aAdd(aRegs,{c_Perg,"01"  ,"Emissao De ?  ",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"02"  ,"Emissao Até ? ",""      ,""     ,"MV_CH2","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"03"  ,"Produto De ?  ",""      ,""     ,"MV_CH3","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"04"  ,"Produto Até ? ",""      ,""     ,"MV_CH4","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

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
