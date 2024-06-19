#INCLUDE "MATR225.CH"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR225  ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao simplificada das estruturas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M10R18()

Local oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= u_RportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marcos V. Ferreira    ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RportDef()
Local oReport
Local oSection1
Local oSection2

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
oReport:= TReport():New("M10R18",OemToAnsi(STR0001),"M10R18", {|oReport| U_RportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004))  //"Este programa emite a relacao de estrutura de um determinado produto"##"selecionado pelo usuario. Esta relacao nao demonstra custos. Caso o"##"produto use opcionais, sera listada a estrutura com os opcionais padrao."
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
//³ mv_par09   // Imprime Ate Nivel ?    ³
//³ mv_par10   // Data de referência?    ³
//  mv_par11   // Considera Bloqueados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)

//Verifica se o MV_PAR10 existe no pergunte MTR225 -> Protecao de fonte.
//U_AjstPergt()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a secao.                   ³
//³ExpA4 : Array com as Ordens do relatorio                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0036,{"SG1","SB1"}) //"Detalhes do produto Pai"
oSection1:SetLineStyle()

nB1_cod   := tamSX3('B1_COD')[1] + 1
nB1_desc  := tamSX3('B1_DESC')[1] + 1
nB1_tipo  := tamSX3('B1_TIPO')[1] + 1
nB1_grupo := tamSX3('B1_GRUPO')[1] + 1
nB1_um    := tamSX3('B1_UM')[1] + 1
nB1_qb    := tamSX3('B1_QB')[1] + 1
nB1_opc   := tamSX3('B1_OPC')[1] + 1

TRCell():New(oSection1,'G1_COD'	    ,'SG1',/*Titulo*/,/*Picture*/,nB1_cod,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_desc,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO'   	,'SB1',/*Titulo*/,/*Picture*/,nB1_tipo,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO'  	,'SB1',/*Titulo*/,/*Picture*/,nB1_grupo,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'	    ,'SB1',/*Titulo*/,/*Picture*/,nB1_um,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_QB'		,'SB1',/*Titulo*/,/*Picture*/,nB1_qb,/*lPixel*/, {|| IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
TRCell():New(oSection1,'B1_OPC'		,'SB1',/*Titulo*/,/*Picture*/,nB1_opc,/*lPixel*/, {|| RetFldProd(SB1->B1_COD,"B1_OPC")})

oSection1:SetNoFilter("SB1")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0037,{'SG1','SB1'}) // "Estruturas"

TRCell():New(oSection2,'NIVEL'		,'   ',STR0019	,/*Picture*/					,10			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_COMP'	,'SG1',STR0020	,/*Picture*/					,nB1_cod,/*lPixel*/,/*{|| code-block de impressao }*/) //B1_COD deve ter o mesmo tamanho que G1_COMP, por isso usei a variável que já tinha a informação na memória, sem realizar a busca novamente na tabela 
TRCell():New(oSection2,'G1_TRT'		,'SG1',STR0021	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_TIPO'	,'SB1',STR0022	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_GRUPO'	,'SB1',STR0023	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
If nB1_desc > 30
	TRCell():New(oSection2,'B1_DESC'	,'SB1',STR0024	,/*Picture*/					,30,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oSection2,'B1_DESC'	,'SB1',STR0024	,/*Picture*/					,nB1_desc,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

TRCell():New(oSection2,'G1_OBSERV'	,'SG1',STR0025	,/*Picture*/					,45,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QUANTITEM'	,'   ',STR0026	,PesqPict('SG1','G1_QUANT',14)	,14	   		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_UM'		,'SB1',STR0027	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_PERDA'	,'SG1',STR0028	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_QUANT'	,'SG1',STR0029	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_QB'		,'SB1',STR0030	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{||If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
TRCell():New(oSection2,'G1_FIXVAR'	,'SG1',STR0031	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_INI'		,'SG1',STR0032	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_FIM'		,'SG1',STR0033	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_GROPC'	,'SG1',STR0034	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'G1_OPC'		,'SG1',STR0035	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:SetHeaderPage()
oSection2:SetNoFilter("SB1")

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RportPrint ³ Autor ³Marcos V. Ferreira   ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica RportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cProduto 	:= ""
Local nNivel   	:= 0
Local lContinua := .T.
Local lDatRef   := !Empty(mv_par10)
Private lNegEstr:=GETMV("MV_NEGESTR")
Private cNegativo:=ALLTRIM(STR(MV_PAR11))
Private cSeqZG1 
Private cProdPai

dbSelectArea("ZG1")

mv_par10 := ddatabase  // Date()  // Colocar em parametro no Schedule depois

// Deleta Registros Tabela ZG1
If mv_par13 == 1 // Gera ZG1 - Apagar no Inicio o Produto em Questao ou pelo Parametro
	cQuery := "DELETE FROM "+RetSqlName("ZG1")
	cQuery += " WHERE ZG1_FILIAL = '"+xFilial("ZG1")+"' "
	cQuery += " AND ZG1_DTINCL = '"+Dtos(mv_par10)+"' "
	TcSqlExec(cQuery)
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea('SG1')
//dbSetOrder(1)
//MsSeek(xFilial('SG1')+mv_par01,.T.)

cQuery := " SELECT SG1.R_E_C_N_O_ REGSG1, SG1.G1_COD, SG1.G1_COMP, SG1.G1_TRT"
cQuery += " FROM "+RetSqlName("SG1")+" SG1 ,"+ RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' "
cQuery += " AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND SG1.D_E_L_E_T_ <> '*' "
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND SB1.B1_COD = SG1.G1_COD "
cQuery += " AND SB1.B1_TIPO  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

If !Empty(mv_par12)
	cQuery += " AND SB1.B1_TIPO IN " + FormatIn(mv_par12, "/")
EndIf

If mv_par11 == 2  // Imprime Bloqueados se for Sim - 1 (não faz nada e carrega todos os produtos)
	cQuery += " AND SB1.B1_MSBLQL <> '1' " // *** Produtos diferentes de bloqueados - Branco ou "2"
EndIf

cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP, SG1.G1_TRT ASC "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "SG1TRB"


//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Montagem do Array para Retorno                                           º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
dbSelectArea("SG1TRB")

oReport:SetMeter(SG1TRB->(LastRec()))
oSection1:Init(.F.)

While !oReport:Cancel() .And. SG1TRB->(!Eof())  //.And. SG1->G1_FILIAL+SG1->G1_COD <= xFilial('SG1')+mv_par02

	oReport:IncMeter()

	// ***
	dbSelectArea("SG1")
	dbGoto(SG1TRB->REGSG1)

	If lDatRef .And. (G1_INI > mv_par10 .Or. G1_FIM < mv_par10)
	    dbSelectArea("SG1TRB")
		SG1TRB->(dbSkip())
		Loop
	EndIf

	cProduto  := SG1->G1_COD
	cProdPai  := SG1->G1_COD
	nNivel    := 2
    lContinua := .T.
	cSeqZG1 := "001"

	dbSelectArea('SB1')
	MsSeek(xFilial('SB1')+cProduto)
	If Eof() .Or. SB1->B1_TIPO < mv_par03 .Or. SB1->B1_TIPO > mv_par04 .Or. SB1->B1_GRUPO < mv_par05 .Or. SB1->B1_GRUPO > mv_par06
		dbSelectArea('SG1')
		While !oReport:Cancel() .And. !Eof() .And. xFilial('SG1')+cProduto == SG1TRB->G1_FILIAL+SG1TRB->G1_COD
			dbSkip()
			oReport:IncMeter()
		EndDo
		lContinua := .F.
	EndIf

	If lContinua	
		
		oSection1:Init(.F.)
		oReport:SkipLine()     

		//--  Imprime grupo de opcionais.
		If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
			oSection1:Cell('B1_OPC'):Show()
		Else
			oSection1:Cell('B1_OPC'):Hide()
		EndIf                

		oSection1:PrintLine()
		oReport:SkipLine()     
		oSection1:Finish()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	Impressao da Sessao 2                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSection2:Init()
		
		//-- Explode Estrutura
		U_MTR225ExplG(oReport,oSection2,cProduto,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,RetFldProd(SB1->B1_COD,"B1_OPC"),IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))	,IIf(Empty(mv_par08),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU ),mv_par08))

		oSection2:Finish()
		
		//-- Verifica se salta ou nao pagina
		If mv_par07 == 1
			oSection1:SetPageBreak(.T.)
		Else    
			oReport:ThinLine() //-- Impressao de Linha Simples
	 	EndIf	 
	
	EndIf
	
	// Pula todos os SG1 com o mesmo Codigo Pai
	dbSelectArea("SG1TRB")
	While SG1TRB->G1_COD == cProduto
		dbSkip()
	EndDo
EndDo

dbSelectArea("SG1TRB")
dbClosearea()

//-- Devolve a condicao original do arquivo principal
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MTR225ExplG³ Autor ³ Marcos V. Ferreira    ³ Data ³ 17/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MR225Expl(ExpO1,ExpO2,ExpC3,ExpN4,ExpN5,ExpC6,ExpN7,ExpC8) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do Relatorio                                ³±±
±±³          ³ ExpO2 = Sessao a ser impressa                              ³±±
±±³          ³ ExpC3 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN4 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN5 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC6 = Opcionais do produto                               ³±±
±±³          ³ ExpN7 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ ExpC8 = Numero da Revisao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MTR225ExplG(oReport,oSection2,cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase,cRevisao)

Local nReg 		  := 0
Local nQuantItem  := 0
Local nPrintNivel := 0
Local cAteNiv     := If(mv_par09=Space(3),"999",mv_par09)
Local cRevEst	  := ''
Local lDatRef     := !Empty(mv_par10)
Local lVlOpc      := .T.

dbSelectArea('SG1')
While !oReport:Cancel() .And. !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial('SG1')+cProduto
	oSection2:IncMeter()
	nReg       := Recno()
	
	//Se não existir nenhum grupo/opcional default, deverá listar todos os opcionais
	If Empty(cOpcionais) .Or. cOpcionais == Nil
		lVlOpc := .F.
	EndIf
		
	nQuantItem := ExplEstr(nQuantPai,Iif(lDatRef,mv_par10,Nil),cOpcionais,cRevisao,,,,,,,,,lVlOpc)
	dbSelectArea('SG1')
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
		
			dbSelectArea('SB1')
			dbSetOrder(1)
			MsSeek(xFilial('SB1')+SG1->G1_COMP)

			//If SB1->B1_TIPO $ 'PA|PI|MI|BN|EM|MP|MC'

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao da Sessao 2			                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPrintNivel:=IIf(nNivel>17,17,nNivel-2)
				oSection2:Cell('NIVEL'		):SetValue(Space(nPrintNivel)+StrZero(nNivel,3))
				oSection2:Cell('QUANTITEM'	):SetValue(nQuantItem)
				oSection2:PrintLine()
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe sub-estrutura                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea('SG1')
				MsSeek(xFilial('SG1')+SG1->G1_COMP)
				cRevEst := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )
				If Found()
					u_MTR225ExplG(oReport,oSection2,SG1->G1_COD,nQuantItem,nNivel+1,SB1->B1_OPC,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),If(!Empty(cRevEst),cRevEst,mv_par08))
				EndIf
				dbGoto(nReg)

				If mv_par13 == 1 // Gera ZG1 - Apagar no Inicio o Produto em Questao ou pelo Parametro
					RecLock("ZG1",.T.)
					ZG1->ZG1_FILIAL := xFilial("ZG1")
					ZG1->ZG1_COD    := cProdPai  //SG1->G1_COD
					ZG1->ZG1_SEQ    := cSeqZG1
					ZG1->ZG1_COMP   := SG1->G1_COMP
					ZG1->ZG1_NIVEL  := StrZero(nNivel,3)
					ZG1->ZG1_QUANT  := nQuantItem
					ZG1->ZG1_QTBASE := IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))
					ZG1->ZG1_PERDA  := SG1->G1_PERDA
					ZG1->ZG1_FIXVAR := SG1->G1_FIXVAR
					ZG1->ZG1_DTINCL := dDataBase
					MsUnLock()
				EndIf
				dbSelectArea('SG1')

				cSeqZG1 := Soma1(cSeqZG1)  // Incrementa Sequencia
			//Else
			//	dbSkip()
			//EndIf
		EndIf
	EndIf
	dbSkip()
EndDo

Return
