#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M10R05   ³ Autor ³ Cleber Maldonado      ³ Data ³ 30/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio do Diario                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAPCP / SIGAFAT                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M10R05()

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
±±³Programa  ³ReportDef ³ Autor ³ Cleber Maldonado      ³ Data ³ 29/01/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
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
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
oReport := TReport():New("M10R05","Diario Projetos","M10R05", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao diaria de itens do pedido de venda" + " " + " para pedidos de venda com status Ativo da Filial 01.")
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
oVenProd := TRSection():New(oReport,"Diario Projetos",{"SC6","SB1"},/*{Array com as ordens do relatï¿½rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRCell():New(oVenProd,"FILIAL"		,/*Tabela*/	,"Filial"			 ,PesqPict("SC6","C6_FILIAL")	,TamSx3("C6_FILIAL")[1]		,/*lPixel*/,{|| cFilSC6 	})				// Filiais que sirão no relatório GMUD0006
TRCell():New(oVenProd,"OPER"		,/*Tabela*/	,"Operacao"			 ,PesqPict("SC6","C6_XOPER")	,TamSx3("C6_XOPER")[1]		,/*lPixel*/,{|| cOper	})				// Tipo de Operaï¿½ï¿½o
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/	,"Emissao"			 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]	,/*lPixel*/,{|| dEmiss	})				// Data de Emissï¿½o
TRCell():New(oVenProd,"NUM"			,/*Tabela*/	,"Pedido"	 		 ,PesqPict("SC6","C6_NUM")		,TamSx3("C6_NUM")[1]		,/*lPixel*/,{|| cNum	})				// Numero do Pedido
TRCell():New(oVenProd,"TPVEN"		,/*Tabela*/ ,"Tipo Venda"		 ,PesqPict("SC5","C5_XTPVEN")	,TamSx3("C5_XTPVEN")[1]		,/*lPixel*/,{|| cXTpVen })				// Tipo de Venda
TRCell():New(oVenProd,"CLIENT"		,/*Tabela*/	,"Cliente"			 ,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNome	})				// Nome do Cliente
TRCell():New(oVenProd,"ITEM"		,/*Tabela*/ ,"Item"				 ,PesqPict("SC6","C6_ITEM")		,TamSx3("C6_ITEM")[1]		,/*lPixel*/,{|| cItem	})				// Item do Pedido
TRCell():New(oVenProd,"PLANTA"		,/*Tabela*/ ,"Planta"			 ,PesqPict("SC6","C6_XITEMP")	,TamSx3("C6_XITEMP")[1]		,/*lPixel*/,{|| cPlanta	},,,"CENTER")	// Item Planta
TRCell():New(oVenProd,"LIBTEC"		,/*Tabela*/	,"Lib.Tec.Com."		 ,PesqPict("SC6","C6_XGOPDT")	,TamSx3("C6_XGOPDT")[1]		,/*lPixel*/,{|| dDtLib	})				// Data Liberacao Tec.Comerc.
TRCell():New(oVenProd,"Prod. Padrao",/*Tabela*/ ,"Prod. Padrao?"	 ,PesqPict("SB1","B1_XPADRAO")	,TamSx3("B1_XPADRAO")[1]	,/*lPixel*/,{|| cXPadra})				// Produto Padr�o?
TRCell():New(oVenProd,"PDF"			,/*Tabela*/ ,"PDF?"		 		 ,PesqPict("SB1","B1_XPDF")		,TamSx3("B1_XPDF")[1]		,/*lPixel*/,{|| cXPdf})					// PDF DEsenvolvido?
TRCell():New(oVenProd,"DXF"			,/*Tabela*/ ,"DXF?"		 		 ,PesqPict("SB1","B1_XDFX")		,TamSx3("B1_XDFX")[1]		,/*lPixel*/,{|| cXDxf})					// DXF Desenvolvido?
TRCell():New(oVenProd,"ESTRU"		,/*Tabela*/ ,"Estrutura?"		 ,PesqPict("SB1","B1_XESTR")	,TamSx3("B1_XESTR")[1]		,/*lPixel*/,{|| cXEstru})				// Estrutura liberada?
TRCell():New(oVenProd,"MDOBRA"		,/*Tabela*/ ,"Mao de Obra?"		 ,PesqPict("SB1","B1_XMDOBRA")	,TamSx3("B1_XMDOBRA")[1]	,/*lPixel*/,{|| cXMDObra})				// M�o de Obra Cadastrada?
TRCell():New(oVenProd,"Dev. Eng"	,/*Tabela*/ ,"Dev. Eng?"		 ,PesqPict("SB1","B1_XITDESE")	,TamSx3("B1_XITDESE")[1]	,/*lPixel*/,{|| cXItDese})				// Item em Desenvolvimento
TRCell():New(oVenProd,"Dt.Dev.Eng"	,/*Tabela*/ ,"Dt.Dev.Eng"	 	 ,PesqPict("SB1","B1_XDTITDS")	,TamSx3("B1_XDTITDS")[1]	,/*lPixel*/,{|| dXDtItDs})				// Data que o item foi colocado em desenvolvimento
TRCell():New(oVenProd,"Prod.Lib.Eng",/*Tabela*/ ,"Prod.Lib.Eng"		 ,PesqPict("SB1","B1_XESPLIB")	,TamSx3("B1_XESPLIB")[1]	,/*lPixel*/,{|| cXEspLib})				// produto Especial Liberado?
TRCell():New(oVenProd,"Dt.Prod.Lib.Eng"  ,/*Tabela*/ ,"Dt.Prod.Lib.Eng"		 ,PesqPict("SB1","B1_XDTLIB")	,TamSx3("B1_XDTLIB")[1]		,/*lPixel*/,{|| cXDtLib})				// Data Libera��o Engenharia
TRCell():New(oVenProd,"Obs Teccom"	,/*Tabela*/ ,"Obs Teccom?"	 	 ,PesqPict("SC6","C6_XOBSENG")	,TamSx3("C6_XOBSENG")[1]	,/*lPixel*/,{|| cXObsEng})				// Observa��o TECCOM

TRCell():New(oVenProd,"ETAPA"		,/*Tabela*/ ,"Etapa"			 ,PesqPict("SC6","C6_XETAPA")	,TamSx3("C6_XETAPA")[1]		,/*lPixel*/,{|| cXEtapa })				// Etapa
TRCell():New(oVenProd,"CODIGO"		,/*Tabela*/	,"Codigo"			 ,PesqPict("SC6","C6_PRODUTO")	,TamSx3("C6_PRODUTO")[1]	,/*lPixel*/,{|| cCodigo	})				// C�digo do Produto

TRCell():New(oVenProd,"COMPRIMENTO"	,/*Tabela*/	,"Comprimento"		 ,PesqPict("SB5","B5_COMPRLC")	,TamSx3("B5_COMPRLC")[1]	,/*lPixel*/,{|| cCompri	})				// Comprimento do equipamento
TRCell():New(oVenProd,"LARGURA"		,/*Tabela*/	,"Largura"			 ,PesqPict("SB5","B5_LARGLC")	,TamSx3("B5_LARGLC")[1]		,/*lPixel*/,{|| cLargur	})				// Largura do equipamento
TRCell():New(oVenProd,"ALTURA"		,/*Tabela*/	,"Altura"			 ,PesqPict("SB5","B5_ALTURLC")	,TamSx3("B5_ALTURLC")[1]	,/*lPixel*/,{|| cAltura	})				// Altura do equipamento

//TRCell():New(oVenProd,"FABRIC"		,/*Tabela*/ ,"Fabrica"			 ,PesqPict("SB1","B1_XFABRIC")	,TamSx3("B1_XFABRIC")[1]	,/*lPixel*/,{|| cXFabric})				// Fabrica
TRCell():New(oVenProd,"TIPO"		,/*Tabela*/ ,"Tipo"				 ,PesqPict("SB1","B1_TIPO")		,TamSx3("B1_TIPO")[1]		,/*lPixel*/,{|| cTipo	})				// Tipo do Produto
TRCell():New(oVenProd,"LOCAL"		,/*Tabela*/ ,"Armazem"			 ,PesqPict("SB1","B1_LOCPAD")	,TamSx3("B1_LOCPAD")[1]		,/*lPixel*/,{|| cLocal	})				// Armazem
TRCell():New(oVenProd,"DESC"		,/*Tabela*/	,"Descricao"		 ,PesqPict("SB5","B5_CEME")		,TamSx3("B5_CEME")[1]		,/*lPixel*/,{|| cDesc	})				// Descriï¿½ï¿½o do Produto
TRCell():New(oVenProd,"QUANT"		,/*Tabela*/	,"Quantidade"		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nQuant	})				// Quantidade
TRCell():New(oVenProd,"SALDO"		,/*Tabela*/	,"A Entregar"		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nSaldo	})				// Saldo
TRCell():New(oVenProd,"SALDOEST"	,/*Tabela*/	,"Saldo Em Estoque"	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldEst })				// Saldo em Estoque
TRCell():New(oVenProd,"ENTREGA"		,/*Tabela*/	,"Dt.Entrega"		 ,PesqPict("SC6","C6_ENTREG")	,TamSx3("C6_ENTREG")[1]		,/*lPixel*/,{|| dDtEntr	})				// Data de Entrega

TRCell():New(oVenProd,"FAMILIA"		,/*Tabela*/	,"Familia"			 ,PesqPict("SB1","B1_XFAMILI")	,TamSx3("B1_XFAMILI")[1]	,/*lPixel*/,{|| cXFamil	})				// Familia
TRCell():New(oVenProd,"OP"			,/*Tabela*/	,"OP"				 ,PesqPict("SC6","C6_OP")		,TamSx3("C6_OP")[1]			,/*lPixel*/,{||	cOP		})				// Numero da Ordem de Produï¿½ï¿½o
//TRCell():New(oVenProd,"VLUIPI"		,/*Tabela*/	,"Vl.Tot+IPI"		 ,PesqPict("SC6","C6_XVLTBRU")	,TamSx3("C6_XVLTBRU")[1]	,/*lPixel*/,{||	nVlUnIPI})

TRCell():New(oVenProd,"VLNET"		,/*Tabela*/	,"Vl.Tot NET"		 ,PesqPict("SC6","C6_XVLTBRU")	,TamSx3("C6_XVLTBRU")[1]	,/*lPixel*/,{||	nVlNET})		

TRCell():New(oVenProd,"ESTADO"		,/*Tabela*/	,"Estado"			 ,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| cEst	})				// Estado
TRCell():New(oVenProd,"GEREN"		,/*Tabela*/ ,"Gerente"			 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]		,/*lPixel*/,{|| cGeren	})
/*Falar com pessoal do Comercial*/TRCell():New(oVenProd,"VEND"		,/*Tabela*/ ,"Representante"	 ,PesqPict("SC5","C5_VEND1")	,TamSx3("C5_VEND1")[1]		,/*lPixel*/,{|| cVend1	})				// Representante
TRCell():New(oVenProd,"EMAIL"		,/*Tabela*/ ,"E-mail"			 ,PesqPict("SA3","A3_EMAIL")	,TamSx3("A3_EMAIL")[1]		,/*lPixel*/,{|| cMailRep})				// E-Mail do Representante
TRCell():New(oVenProd,"LIBFIN"		,/*Tabela*/	,"Lib.Fin"		 	 ,PesqPict("SC5","C5_XSTSFIN")	,TamSx3("C5_XSTSFIN")[1]	,/*lPixel*/,{|| cXStsFin})				// Status Liberaï¿½ï¿½o Financeira
TRCell():New(oVenProd,"DTLIBFIN"	,/*Tabela*/ ,"Dt.Lib.Financ."	 ,PesqPict("SC5","C5_XDTAPRV")	,TamSx3("C5_XDTAPRV")[1]	,/*lPixel*/,{|| dDtLibCom})				// Data da Liberação Financeira
TRCell():New(oVenProd,"FRETE"		,/*Tabela*/ ,"Tp.Frete"			 ,PesqPict("SC5","C5_TPFRETE")  ,TamSx3("C5_TPFRETE")[1]	,/*lPixel*/,{|| cTpFret })				// Tipo de Frete
TRCell():New(oVenProd,"TRANSP"		,/*Tabela*/	,"Transportadora" 	 ,PesqPict("SC5","C5_TRANSP")	,TamSx3("C5_TRANSP")[1]		,/*lPixel*/,{|| cNomTran})				// Nome da Transportadora
TRCell():New(oVenProd,"ATRASADO"	,/*Tabela*/	,"Atrasado?"		 ,PesqPict("SB1","B1_FAMILIA")	,TamSx3("B1_FAMILIA")[1]	,/*lPixel*/,{|| cAtraso	})				// Atrasado ? Sim/Nï¿½o
TRCell():New(oVenProd,"CLASSE"		,/*Tabela*/	,"Classe"			 ,PesqPict("SB1","B1_COD")		,TamSX3("B1_COD")[1]		,/*lPixel*/,{|| cClasse	})				// Classe
TRCell():New(oVenProd,"PRODUZIDO"	,/*Tabela*/	,"Produzido em"		 ,PesqPict("SB1","B1_XPROD")	,TamSx3("B1_XPROD")[1]		,/*lPixel*/,{|| cProd	})				// Produzido em
/*rever*/TRCell():New(oVenProd,"ANOMES"		,/*Tabela*/ ,"Ano/Mes"			 ,PesqPict("SC6","C6_NUM")		,TamSx3("C6_NUM")[1]		,/*lPixel*/,{|| cAnoMes })				// Ano/Mï¿½s da data de entrega
TRCell():New(oVenProd,"LIBREV"      ,/*Tabela*/ ,"Lib. Revenda"      ,PesqPict("SC5","C5_XLIBREV")  ,TamSx3("C5_XLIBREV")[1]    ,/*lPixel*/,{|| cXLibRev})              // Status de Liberacao do Financeiro Para Revenda
TRCell():New(oVenProd,"MOTIVO"      ,/*Tabela*/ ,"Motivo"            ,PesqPict("SC5","C5_XMOTLIB")  ,TamSx3("C5_XMOTLIB")[1]    ,/*lPixel*/,{|| cXMotLib})              // Motivo de Liberacao do Financeiro Para Revenda
TRCell():New(oVenProd,"STATUSFIM"	,/*Tabela*/ ,"Status"			 ,PesqPict("SC6","C6_ITEM")		,TamSx3("C6_ITEM")[1]		,/*lPixel*/,{|| cStatus })				// Status de Embarque
TRCell():New(oVenProd,"DTENTREGA1"	,/*Tabela*/	,"Dt.Entrega1"		 ,PesqPict("SC5","C5_XDTPCP1")	,TamSx3("C5_XDTPCP1")[1]	,/*lPixel*/,{|| cDtpcp1	})				// Data de Entrega 1
TRCell():New(oVenProd,"OBS1"		,/*Tabela*/ ,"Observacao1"		 ,PesqPict("SC5","C5_XOBS1")	,TamSx3("C5_XOBS1")[1]		,/*lPixel*/,{|| cObs1 	})				// Observaï¿½ï¿½o 1
//TRCell():New(oVenProd,"DTENTREGA2"	,/*Tabela*/	,"Dt.Entrega2"		 ,PesqPict("SC5","C5_XDTPCP2")	,TamSx3("C5_XDTPCP2")[1]	,/*lPixel*/,{|| cDtpcp2	})				// Data de Entrega 2
//TRCell():New(oVenProd,"OBS2"		,/*Tabela*/ ,"Observacao2"		 ,PesqPict("SC5","C5_XOBS2")	,TamSx3("C5_XOBS2")[1]		,/*lPixel*/,{|| cObs2	})				// Observaï¿½ï¿½o 2
//TRCell():New(oVenProd,"DTENTREGA3"	,/*Tabela*/	,"Dt.Entrega3"		 ,PesqPict("SC5","C5_XDTPCP3")	,TamSx3("C5_XDTPCP3")[1]	,/*lPixel*/,{|| cDtpcp3	})				// Data de Entrega 3
//TRCell():New(oVenProd,"OBS3"		,/*Tabela*/ ,"Observacao3"		 ,PesqPict("SC5","C5_XOBS3")	,TamSx3("C5_XOBS3")[1]		,/*lPixel*/,{|| cObs3 	})				// Observaï¿½ï¿½o 3
//TRCell():New(oVenProd,"DTENTREGA4"	,/*Tabela*/	,"Dt.Entrega4"		 ,PesqPict("SC5","C5_XDTPCP4")	,TamSx3("C5_XDTPCP4")[1]	,/*lPixel*/,{|| cDtpcp4	})				// Data de Entrega 4
//TRCell():New(oVenProd,"OBS4"		,/*Tabela*/ ,"Observacao4"		 ,PesqPict("SC5","C5_XOBS4")	,TamSx3("C5_XOBS4")[1]		,/*lPixel*/,{|| cObs4 	})				// Observaï¿½ï¿½o 4
//TRCell():New(oVenProd,"DTENTREGA5"	,/*Tabela*/	,"Dt.Entrega5"		 ,PesqPict("SC5","C5_XDTPCP5")	,TamSx3("C5_XDTPCP5")[1]	,/*lPixel*/,{|| cDtpcp5	})				// Data de Entrega 5
//TRCell():New(oVenProd,"OBS5"		,/*Tabela*/ ,"Observacao5"		 ,PesqPict("SC5","C5_XOBS5")	,TamSx3("C5_XOBS5")[1]		,/*lPixel*/,{|| cObs5 	})				// Observaï¿½ï¿½o 5
//TRCell():New(oVenProd,"DTENTREGA6"	,/*Tabela*/	,"Dt.Entrega6"		 ,PesqPict("SC5","C5_XDTPCP6")	,TamSx3("C5_XDTPCP6")[1]	,/*lPixel*/,{|| cDtpcp6	})				// Data de Entrega 6
//TRCell():New(oVenProd,"OBS6"		,/*Tabela*/ ,"Observacao6"		 ,PesqPict("SC5","C5_XOBS6")	,TamSx3("C5_XOBS6")[1]		,/*lPixel*/,{|| cObs6 	})				// Observaï¿½ï¿½o 6
//TRCell():New(oVenProd,"DTENTREGA7"	,/*Tabela*/	,"Dt.Entrega7"		 ,PesqPict("SC5","C5_XDTPCP7")	,TamSx3("C5_XDTPCP7")[1]	,/*lPixel*/,{|| cDtpcp7	})				// Data de Entrega 7
//TRCell():New(oVenProd,"OBS7"		,/*Tabela*/ ,"Observacao7"		 ,PesqPict("SC5","C5_XOBS7")	,TamSx3("C5_XOBS7")[1]		,/*lPixel*/,{|| cObs7 	})				// Observaï¿½ï¿½o 7
//TRCell():New(oVenProd,"DTENTREGA8"	,/*Tabela*/	,"Dt.Entrega8"		 ,PesqPict("SC5","C5_XDTPCP8")	,TamSx3("C5_XDTPCP8")[1]	,/*lPixel*/,{|| cDtpcp8	})				// Data de Entrega 8
//TRCell():New(oVenProd,"OBS8"		,/*Tabela*/ ,"Observacao8"		 ,PesqPict("SC5","C5_XOBS8")	,TamSx3("C5_XOBS8")[1]		,/*lPixel*/,{|| cObs8 	})				// Observaï¿½ï¿½o 8
TRCell():New(oVenProd,"LIBPROD"		,/*Tabela*/ ,"Lib.Producao"		 ,PesqPict("SC5","C5_XLIBPRO")	,TamSx3("C5_XLIBPRO")[1]	,/*lPixel*/,{|| cXLibPro})				// Liberação financeira para produção.
TRCell():New(oVenProd,"DTLIBPROD"	,/*Tabela*/ ,"Dt.Lib.Producao"	 ,PesqPict("SC5","C5_XDLIBPR")	,TamSx3("C5_XDLIBPR")[1]	,/*lPixel*/,{|| dXDlibPr})				// Data da Liberação financeira para produção.
TRCell():New(oVenProd,"QTD_PRV_PROD",/*Tabela*/	,"Prev.Entr.(OP)"	 ,PesqPict("SC2","C2_QUANT")		,TamSx3("C2_QUANT")[1]		,/*lPixel*/,{|| nPrvEntr })				// Saldo em Estoque
TRCell():New(oVenProd,"PRONTA"	  ,/*Tabela*/	,"Pronta Entrega?"	 ,PesqPict("SB1","B1_FAMILIA")	,TamSx3("B1_FAMILIA")[1]+10	,/*lPixel*/,{|| cPronta	})			// Pronta Entrega ?
// Valor Frete 
TRCell():New(oVenProd,"FRETEPV"	    ,/*Tabela*/	,"Frete"		     ,PesqPict("SC5","C5_FRETE")	,TamSx3("C5_FRETE")[1]	,/*lPixel*/,{||	nFrete})				// Vl Bruto + IPI
// Pedido
TRCell():New(oVenProd,"PV_QUANT"	,/*Tabela*/	,"PV.Quantidade"	 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nQuant	})				// Quantidade
TRCell():New(oVenProd,"PV_SALDO"	,/*Tabela*/	,"PV A Entregar"	 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nSaldo	})				// Saldo
TRCell():New(oVenProd,"PV_QT_LIB"   ,/*Tabela*/	,"PV.Qtd.Lib."		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nPvLib	})				// Saldo
// Saldos
TRCell():New(oVenProd,"SLDEST"	    ,/*Tabela*/	,"Sld Estoque"	     ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldEst })				// Saldo em Estoque
TRCell():New(oVenProd,"QTD_EMP"	    ,/*Tabela*/	,"Qtd.Est.Empen."	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldLib })				// Saldo em Estoque
TRCell():New(oVenProd,"QTD_DISP"    ,/*Tabela*/	,"Qtd.Est.Disp."	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldDisp })				// Saldo em Estoque
TRCell():New(oVenProd,"RAT_FRETE"	,/*Tabela*/	,"Rat.Frete"		 ,PesqPict("SC5","C5_XFRETE")	,TamSx3("C5_XFRETE")[1]	    ,/*lPixel*/,{||	nRatFre})				// Rateio de Frete #6805

TRCell():New(oVenProd,"RESP. ENG"	,/*Tabela*/	,"Resp. Eng"		 ,PesqPict("SB1","B1_XREPENG")	,TamSx3("B1_XREPENG")[1]	,/*lPixel*/,{||	cXRespE})				// Rateio de Frete #6805
TRCell():New(oVenProd,"SUB FAM.SUG.",/*Tabela*/ ,"Familia Sugerida"  ,PesqPict("SB1","B1_XFAMSGD")	,TamSx3("B1_XFAMSGD")[1]	,/*lPixel*/,{|| cXFamSgd })				// Familia Sugerida
TRCell():New(oVenProd,"FAMILIA.SUG.",/*Tabela*/ ,"Sub.Fam. Sugerida" ,PesqPict("SB1","B1_XSUBFAM")	,TamSx3("B1_XSUBFAM")[1]	,/*lPixel*/,{|| cXSubFam })
TRCell():New(oVenProd,"VLUIPI"		,/*Tabela*/	,"Vl.Tot+IPI"		 ,PesqPict("SC6","C6_XVLTBRU")	,TamSx3("C6_XVLTBRU")[1]	,/*lPixel*/,{||	nVlUnIPI})				// Sub Fam.Sugerida

TRCell():New(oVenProd,"AG_PROJETO"  ,/*Tabela*/ ,"AGING.PROJ"		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]	,/*lPixel*/,{|| dAgProj	})
TRCell():New(oVenProd,"AG_TEC"      ,/*Tabela*/	,"AGING.TEC"		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]    ,/*lPixel*/,{|| dAgTec	})
TRCell():New(oVenProd,"DIAS_MANUF"  ,/*Tabela*/ ,"DIAS.MANUF"		 ,PesqPict("SC6","C6_XGOPDT")	,TamSx3("C6_XGOPDT")[1]		,/*lPixel*/,{|| dDManuf	})	
TRCell():New(oVenProd,"AG_ENG"      ,/*Tabela*/	,"AGING.ENG"		 ,PesqPict("SB1","B1_XDTLIB")	,TamSx3("B1_XDTLIB")[1]		,/*lPixel*/,{|| dAgEng	})			

//TRCell():New(oVenProd,"AG_TEC"      ,/*Tabela*/	,"AGING.TEC"		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]    ,/*lPixel*/,{|| dAgTec	})				
//TRCell():New(oVenProd,"DIAS_MANUF"  ,/*Tabela*/ ,"DIAS.MANUF"		 ,PesqPict("SC6","C6_XGOPDT")	,TamSx3("C6_XGOPDT")[1]		,/*lPixel*/,{|| dDManuf	})				
//TRCell():New(oVenProd,"AG_PROJETO"  ,/*Tabela*/ ,"AGING.PROJ"		 ,PesqPict("SC5","C5_EMISSAO")	,TamSx3("C5_EMISSAO")[1]	,/*lPixel*/,{|| dAgProj	})				
//TRCell():New(oVenProd,"AG_ENG"      ,/*Tabela*/	,"AGING.ENG"		 ,PesqPict("SB1","B1_XDTLIB")	,TamSx3("B1_XDTLIB")[1]		,/*lPixel*/,{|| dAgEng	})		
TRCell():New(oVenProd,"LIB_ENG"     ,/*Tabela*/ ,"LIB.ENG"			 ,PesqPict("SB1","B1_XDTLIB")	,TamSx3("B1_XDTLIB")[1]		,/*lPixel*/,{|| dLibEng	})	
TRCell():New(oVenProd,"DIAS_PCP"     ,/*Tabela*/,"DIAS.PCP"			 ,PesqPict("SB1","B1_XDTLIB")	,TamSx3("B1_XDTLIB")[1]		,/*lPixel*/,{|| dDiasPcp})	


//	nPvLib   := 0
//  nSldLib  := 0
//	nSldDisp := 0

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Cleber Maldonado	    ³ Data ³ 11/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
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
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)

Local lPronta	:= .F.
Local lAtraso	:= .F.
//Local nNumero   := 0
Local nCod      := ""
Local nCod2     := ""
Local cXFamSgdCod 
Local cXSubFamCod

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)			// Produto,Numero
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		COLUMN C6_XGOPDT AS DATE
		COLUMN C6_ENTREG AS DATE
	
			
		SELECT DISTINCT

    SC5.C5_XTPVEN,
    SB1.B1_TIPO,
    SC6.C6_XGOPDT,
    SB1.B1_XDTLIB,SB1.B1_XITDESE,SB1.B1_XFABRIC,SB1.B1_XDTITDS,SB1.B1_XPROD,SB1.B1_XPDF,SB1.B1_XDFX,SB1.B1_XESTR,SB1.B1_XMDOBRA,SB1.B1_XESPLIB,
	SB1.B1_XPADRAO,SB1.B1_XDTLIB,SB1.B1_XREPENG,SB1.B1_XFAMILI,
	SB5.B5_COMPRLC,SB5.B5_LARGLC,SB5.B5_ALTURLC,SB1.B1_DESC,

    SC6.C6_FILIAL,
    SC6.C6_NUM,
    SC6.C6_ITEM,
    SC6.C6_PRODUTO,
    SC6.C6_QTDVEN,
    SC6.C6_QTDENT,
    SC6.C6_LOCAL,
    SC6.C6_BLQ,
    SC6.C6_TES, SC6.C6_XVLTIPI,SC6.C6_XVLTICM,SC6.C6_XVLTCF2,SC6.C6_XVLTPS2,SC6.C6_XVLTSOL,

    SC6.C6_XITEMP,
    SC6.C6_XOPER,
    SC6.C6_XETAPA,
    SC6.C6_OP,
    SC6.C6_ENTREG,
	SC6.C6_XOBSENG,
	SC6.C6_XVLTBRU,

    SC5.C5_EMISSAO,SC5.C5_TPFRETE,SC5.C5_EMISSAO,SC5.C5_TRANSP,
    SC5.C5_VEND1,
    SC5.C5_XSTSFIN,SC5.C5_XMOTLIB,SC5.C5_XDTPCP1,SC5.C5_XOBS1,SC5.C5_XDTPCP2,SC5.C5_XOBS2,SC5.C5_XDTPCP3,SC5.C5_XOBS3,  SC5.C5_XDTPCP4,SC5.C5_XOBS4,
	SC5.C5_XDTPCP5,SC5.C5_XOBS5,
	SC5.C5_XDTPCP6,SC5.C5_XOBS6,
	SC5.C5_XDTPCP7,SC5.C5_XOBS7,
	SC5.C5_XDTPCP8,SC5.C5_XOBS8,SC5.C5_XDTAPRV,SC5.C5_XDLIBPR,SC5.C5_FRETE,SC5.C5_XLIBREV,SC5.C5_XFRETE,SC5.C5_XTPVEN,

    SB2.B2_QATU,
	SA1.A1_NOME,SA1.A1_EST,SA1.A1_NREDUZ,
	SA3.A3_NOME,SA3.A3_EMAIL,SA3.A3_COD,SA3.A3_GEREN,

    /* AGING TEC */
    CASE
        WHEN SC6.C6_XGOPDT IS NULL
          OR SC6.C6_XGOPDT = ''
          OR SC6.C6_XGOPDT < SC5.C5_EMISSAO
        THEN 0
        ELSE DATEDIFF(
            DAY,
            CONVERT(DATE, SC5.C5_EMISSAO, 112),
            CONVERT(DATE, SC6.C6_XGOPDT, 112)
        )
    END AS AG_TEC,

    /* AGING PROJETO */
    CASE
        WHEN SC6.C6_ENTREG IS NULL
        THEN 0
        ELSE DATEDIFF(
            DAY,
            CONVERT(DATE, SC5.C5_EMISSAO, 112),
            CONVERT(DATE, SC6.C6_ENTREG, 112)
        )
    END AS AG_PROJETO,

    /* LIB ENG */
    CASE
        WHEN SB1.B1_XDTLIB = ''
          OR SB1.B1_XDTLIB < SC5.C5_EMISSAO
        THEN 0
        ELSE DATEDIFF(
            DAY,
            CONVERT(DATE, SC5.C5_EMISSAO, 112),
            CONVERT(DATE, SB1.B1_XDTLIB, 112)
        )
    END AS LIB_ENG,

    /* AGING ENG */
    CASE
        WHEN SC5.C5_XTPVEN <> '1'
             AND SB1.B1_TIPO = 'PA'
        THEN
            CASE
                WHEN SB1.B1_XDTLIB = ''
                  OR SB1.B1_XDTLIB < SC5.C5_EMISSAO
                THEN 0
                ELSE DATEDIFF(
                    DAY,
                    CONVERT(DATE, SC5.C5_EMISSAO, 112),
                    CONVERT(DATE, SB1.B1_XDTLIB, 112)
                )
            END
        WHEN SB1.B1_XDTLIB = ''
          OR SB1.B1_XDTLIB < SC6.C6_XGOPDT
          OR SC6.C6_XGOPDT = ''
        THEN 0
        ELSE DATEDIFF(
            DAY,
            CONVERT(DATE, SC6.C6_XGOPDT, 112),
            CONVERT(DATE, SB1.B1_XDTLIB, 112)
        )
    END AS AG_ENG,

    /* DIAS MANUFATURA */
    CASE
        WHEN SC5.C5_XTPVEN <> '1'
             AND SB1.B1_TIPO = 'PA'
        THEN
            DATEDIFF(
                DAY,
                CONVERT(DATE, SC5.C5_EMISSAO, 112),
                CONVERT(DATE, SC6.C6_ENTREG, 112)
            )
        WHEN SC6.C6_XGOPDT = ''
          OR SC6.C6_ENTREG < SC6.C6_XGOPDT
        THEN 0
        ELSE DATEDIFF(
            DAY,
            CONVERT(DATE, SC6.C6_XGOPDT, 112),
            CONVERT(DATE, SC6.C6_ENTREG, 112)
        )
    END AS DIAS_MANUF,

    /* SUBQUERIES */
    (SELECT SUM(C2_QUANT - C2_QUJE)
       FROM SC2010 SC2
      WHERE SC2.C2_FILIAL  = SC6.C6_FILIAL
        AND SC2.C2_PRODUTO = SC6.C6_PRODUTO
        AND SC2.C2_DATRF   = ' '
        AND SC2.D_E_L_E_T_ = ''
    ) AS QTD_PRV_PROD,

    (SELECT SUM(C6_VALOR)
       FROM SC6010 SC62
      WHERE SC62.C6_FILIAL = SC6.C6_FILIAL
        AND SC62.C6_NUM    = SC6.C6_NUM
        AND SC62.D_E_L_E_T_ = ''
    ) AS TOT_SC6,

    (SELECT SUM(C9_QTDLIB)
       FROM SC9010 SC9
      WHERE SC9.C9_FILIAL  = SC6.C6_FILIAL
        AND SC9.C9_PEDIDO  = SC6.C6_NUM
        AND SC9.C9_PRODUTO = SC6.C6_PRODUTO
        AND SC9.C9_BLEST   = '  '
        AND SC9.D_E_L_E_T_ = ''
    ) AS PV_QT_LIB,

    (SELECT SUM(C9_QTDLIB)
       FROM SC9010 SC9
      WHERE SC9.C9_FILIAL  = SC6.C6_FILIAL
        AND SC9.C9_PRODUTO = SC6.C6_PRODUTO
        AND SC9.C9_BLEST   = '  '
        AND SC9.D_E_L_E_T_ = ''
    ) AS QTD_EMP

FROM SC6010 SC6

INNER JOIN SC5010 SC5
    ON SC5.C5_FILIAL = SC6.C6_FILIAL
   AND SC5.C5_NUM    = SC6.C6_NUM
   AND SC5.C5_MSBLQL <> '1'
   AND SC5.D_E_L_E_T_ = ''

INNER JOIN SB1010 SB1
    ON SB1.B1_COD = SC6.C6_PRODUTO
   AND SB1.D_E_L_E_T_ = ''

INNER JOIN SB2010 SB2
    ON SB2.B2_FILIAL = SC6.C6_FILIAL
   AND SB2.B2_COD    = SC6.C6_PRODUTO
   AND SB2.B2_LOCAL  = SC6.C6_LOCAL
   AND SB2.D_E_L_E_T_ = ''

INNER JOIN SA1010 SA1
    ON SA1.A1_COD  = SC5.C5_CLIENTE
   AND SA1.A1_LOJA = SC5.C5_LOJACLI
   AND SA1.D_E_L_E_T_ = ''

LEFT JOIN SB5010 SB5
    ON SB5.B5_FILIAL = SC5.C5_FILIAL
   AND SB5.B5_COD    = SC6.C6_PRODUTO
   AND SB5.D_E_L_E_T_ = ''

INNER JOIN SA3010 SA3
    ON SA3.A3_COD = SC5.C5_VEND1
   AND SA3.D_E_L_E_T_ = ''

WHERE
    SC6.C6_FILIAL = %xFilial:SC6%
AND SC6.C6_BLQ <> 'R'
AND SC6.C6_QTDVEN > SC6.C6_QTDENT
AND SC5.C5_TIPO NOT IN ('D','B')
AND SC5.C5_EMISSAO >= %Exp:Dtos(MV_PAR04)%
AND SC5.C5_EMISSAO <= %Exp:Dtos(MV_PAR05)%
AND SC6.C6_NUM >= %Exp:MV_PAR06%
AND SC6.C6_NUM <= %Exp:MV_PAR07%
AND SC6.C6_PRODUTO >= %Exp:MV_PAR08%
AND SC6.C6_PRODUTO <= %Exp:MV_PAR09%
AND SC6.D_E_L_E_T_ = ''

ORDER BY SC6.C6_FILIAL, SC6.C6_NUM
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

	cClasse		:= ""
	nSaldo		:= ((cAliasQry)->C6_QTDVEN - (cAliasQry)->C6_QTDENT)
	
	If MV_PAR01 == 2 .And. nSaldo == 0
		(cAliasQry)->(dbSkip())
		Loop
	ElseIf MV_PAR01 == 1 .And. nSaldo <> 0
		(cAliasQry)->(dbSkip())
		Loop
	Endif

   	cXFabric := IIF((cAliasQry)->B1_XFABRIC == "1","1 - Guarulhos","2 - Porto Feliz")
	cTipo	 := (cAliasQry)->B1_TIPO
	cLocal	 := (cAliasQry)->C6_LOCAL
	cXItDese := (cAliasQry)->B1_XITDESE
	dXDtItDs := (cAliasQry)->B1_XDTITDS
	nSldEst	 := (cAliasQry)->B2_QATU
	nPrvEntr := (cAliasQry)->QTD_PRV_PROD
	cProd	 := (cAliasQry)->B1_XPROD
	cXPdf	 := (cAliasQry)->B1_XPDF		//#6839
	cXDxf	 := (cAliasQry)->B1_XDFX		//#6839
	cXEstru  := (cAliasQry)->B1_XESTR		//#6839
	cXMDObra := (cAliasQry)->B1_XMDOBRA		//#6839	
	cXEspLib := (cAliasQry)->B1_XESPLIB		//#6839
	cXDtLib := (cAliasQry)->B1_XDTLIB		//#6839
	cXPadra := (cAliasQry)->B1_XPADRAO		//#6839
	cCompri := (cAliasQry)->B5_COMPRLC		//#6839
	cLargur := (cAliasQry)->B5_LARGLC		//#6839
	cAltura := (cAliasQry)->B5_ALTURLC		//#6839
	cXRespE := (cAliasQry)->B1_XREPENG		//#6839

	//SC6->(dbGoto((cAliasQry)->RECSC6))
	cXObsEng := SC6->C6_XOBSENG 	//#6839
	//cXObsEng := (cAliasQry)->C2_XOBSENG	//#6839

	Do Case
    	Case (cAliasQry)->B1_XPROD == "1"		
    		 cProd   := "CPC"
    	Case (cAliasQry)->B1_XPROD == "2"
    	 	 cProd   := "Coccao"
    	Case (cAliasQry)->B1_XPROD == "3"
    		 cProd   := "Refrigeracao"
		Case (cAliasQry)->B1_XPROD == "4"
    		 cProd   := "Mobiliario"
		Case (cAliasQry)->B1_XPROD == "5"
    		 cProd   := "Periferico"	 
    End Case

	// B1_XITDESE								 #6839
	Do Case
		Case (cAliasQry)->B1_XITDESE == "S"
			cXItDese   := "Sim"
		Case (cAliasQry)->B1_XITDESE == "N"
			cXItDese   := "N�o"
		Case (cAliasQry)->B1_XITDESE == " "
			cXItDese   := "Avaliar"
	End Case
	
	// B1_XPDF									#6839
	Do Case
		Case (cAliasQry)->B1_XPDF == "1"
			cXPdf   := "Sim"
		Case (cAliasQry)->B1_XPDF == "2"
			cXPdf   := "N�o"
		Case (cAliasQry)->B1_XPDF == " "
			cXPdf   := "Avaliar"
	End Case
	
	// B1_XDFX									#6839
	Do Case
		Case (cAliasQry)->B1_XDFX == "1"
			cXDxf   := "Sim"
		Case (cAliasQry)->B1_XDFX == "2"
			cXDxf   := "N�o"
		Case (cAliasQry)->B1_XDFX == "3"
			cXDxf   := "N/A"
		Case (cAliasQry)->B1_XDFX == " "
			cXDxf   := "Avaliar"	
	End Case

	// B1_XESTR									#6839
	Do Case
		Case (cAliasQry)->B1_XESTR == "1"
			cXEstru   := "Sim"
		Case (cAliasQry)->B1_XESTR == "2"
			cXEstru   := "N�o"
		Case (cAliasQry)->B1_XESTR == " "
			cXEstru   := "Avaliar"
	End Case

	// B1_XMDOBRA								#6839
	Do Case
		Case (cAliasQry)->B1_XMDOBRA == "1"
			cXMDObra   := "Sim"
		Case (cAliasQry)->B1_XMDOBRA == "2"
			cXMDObra   := "N�o"
		Case (cAliasQry)->B1_XMDOBRA == " "
			cXMDObra   := "Avaliar"
	End Case

	// B1_XESPLIB								#6839
	Do Case
		Case (cAliasQry)->B1_XESPLIB == "1"
			cXEspLib   := "Sim"
		Case (cAliasQry)->B1_XESPLIB == "2"
			cXEspLib   := "N�o"
		Case (cAliasQry)->B1_XESPLIB == " "
			cXEspLib   := "N�o"
	End Case

	cXFamil	 := POSICIONE("ZA1",1,xFilial("ZA1")+(cAliasQry)->B1_XFAMILI,"ZA1_DESC")
	If MV_PAR03 == 1
		cDesc	:= (cAliasQry)->B1_DESC
	Endif

	If MV_PAR02 == 1
		cNome	:= (cAliasQry)->A1_NOME
	Else
		cNome	:= (cAliasQry)->A1_NREDUZ
	Endif			

	cEst	    := (cAliasQry)->A1_EST
	cFilSC6 	:= (cAliasQry)->C6_FILIAL
	cNum		:= (cAliasQry)->C6_NUM
	cItem		:= (cAliasQry)->C6_ITEM
	cPlanta		:= (cAliasQry)->C6_XITEMP
	cCodigo		:= (cAliasQry)->C6_PRODUTO
	cOper		:= (cAliasQry)->C6_XOPER  
	cOP			:= (cAliasQry)->C6_OP
	cXEtapa		:= Posicione("ZA3",1,XFILIAL("ZA3") + (cAliasQry)->C6_XETAPA,"ZA3_DESCRI")
	dDtEntr		:= (cAliasQry)->C6_ENTREG
	dDtLib		:= (cAliasQry)->C6_XGOPDT
	nQuant		:= (cAliasQry)->C6_QTDVEN

	/*
	Verificar se o pedido gera ou não receita chamado 2154
	*/

	
	cGerafin	:= Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->C6_TES,"F4_DUPLIC")
	
	If AllTrim(cGerafin) = 'S'
		nVlUnIPI	:= ((cAliasQry)->C6_XVLTBRU / nQuant ) * nSaldo
	Else
		nVlUnIPI	:= 0
	Endif
	
	
	cGerafin2	:= Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->C6_TES,"F4_DUPLIC")

	If AllTrim(cGerafin2) = 'S'
		nVlNET	:= ((cAliasQry)->((C6_XVLTBRU - (C6_XVLTIPI+C6_XVLTICM+C6_XVLTCF2+C6_XVLTPS2+C6_XVLTSOL))/C6_QTDVEN)*(C6_QTDVEN-C6_QTDENT))
	Else
		nVlNET	:= 0
	Endif

	lAtraso		:= (cAliasQry)->C6_ENTREG < DDATABASE
	cStatus		:= IIF(nSldEst >= nSaldo,"OK"," ")  
	cXTpVen		:= (cAliasQry)->C5_XTPVEN
	dEmiss		:= (cAliasQry)->C5_EMISSAO
	cGeren   	:= Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->A3_GEREN,"A3_NOME")
	cVend1		:= (cAliasQry)->A3_NOME
	cMailRep	:= (cAliasQry)->A3_EMAIL
	cTpFret		:= IIF((cAliasQry)->C5_TPFRETE == "C","CIF","FOB")
	lPronta		:= ((cAliasQry)->C6_ENTREG - (cAliasQry)->C5_EMISSAO) < 7

	If (cAliasQry)->C5_VEND1 == "000007"
		cClasse := "Redes"
	ElseIf (cAliasQry)->C5_VEND1 == "000008"
		cClasse := "Suporte Tecnico"
	Endif	

	If Empty(cClasse)
		cClasse		:= U_RetClasse((cAliasQry)->TOT_SC6)
	Endif

	cNomTran	:= Posicione("SA4",1,xFilial("SA4")+(cAliasQry)->C5_TRANSP,"A4_NOME")
	cAnoMes		:= AnoMes(dDtEntr)
	cXMotLib    := (cAliasQry)->C5_XMOTLIB
	cDtpcp1		:= (cAliasQry)->C5_XDTPCP1
	cObs1		:= (cAliasQry)->C5_XOBS1
	cDtpcp2		:= (cAliasQry)->C5_XDTPCP2
	cObs2		:= (cAliasQry)->C5_XOBS2
	cDtpcp3		:= (cAliasQry)->C5_XDTPCP3
	cObs3		:= (cAliasQry)->C5_XOBS3  
	cDtpcp4		:= (cAliasQry)->C5_XDTPCP4
	cObs4		:= (cAliasQry)->C5_XOBS4
	cDtpcp5		:= (cAliasQry)->C5_XDTPCP5
	cObs5		:= (cAliasQry)->C5_XOBS5
	cDtpcp6		:= (cAliasQry)->C5_XDTPCP6
	cObs6		:= (cAliasQry)->C5_XOBS6
	cDtpcp7		:= (cAliasQry)->C5_XDTPCP7
	cObs7		:= (cAliasQry)->C5_XOBS7
	cDtpcp8		:= (cAliasQry)->C5_XDTPCP8
	cObs8		:= (cAliasQry)->C5_XOBS8 
	dDtLibCom	:= (cAliasQry)->C5_XDTAPRV
	dXDlibPr    := (cAliasQry)->C5_XDLIBPR
	nFrete      := (cAliasQry)->C5_FRETE

	//nNumero     := (cAliasQry)->A1_COD
	nCod   		:= (cAliasQry)->C5_EMISSAO    
	nCod2++  
	cXLibRev    := IIF((cAliasQry)->C5_XLIBREV == "1", "Sim" , "Nao") 

	nPvLib   := (cAliasQry)->PV_QT_LIB
    nSldLib  := (cAliasQry)->QTD_EMP
	nSldDisp := nSldEst - (cAliasQry)->QTD_EMP
  	nRatFre  := (cAliasQry)->C5_XFRETE

	dAgTec   := (cAliasQry)->AG_TEC
	dDManuf  := (cAliasQry)->DIAS_MANUF
	dAgProj  := (cAliasQry)->AG_PROJETO
	dAgEng   := (cAliasQry)->AG_ENG
	dLibEng	 := (cAliasQry)->LIB_ENG
	dDiasPcp := dDManuf - dAgEng



/* Sub Fam�lia e Fam�lia Sugerida do Produtos
*/
	cXSubFam	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XSUBFAM")
	cXFamSgd	:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XFAMSGD")

	cXFamSgdCod := AllTrim(cXFamSgd)
	If cXFamSgdCod 		== "1"
		cXFamSgd		:= "1 - Coc��o"
	ElseIf cXFamSgdCod 	== "2"
		cXFamSgd		:= "2 - Componentes"
	ElseIf cXFamSgdCod  == "3"
		cXFamSgd		:= "3 - M�quina de Gelo"
	ElseIf cXFamSgdCod	== "4"
		cXFamSgd		:= "4 - Mobili�rios"
	ElseIf cXFamSgdCod 	== "5"
		cXFamSgd		:= "5 - N�o Vend�veis"
	ElseIf cXFamSgdCod 	== "6"
		cXFamSgd		:= "6 - Refrigera��o"
	ElseIf cXFamSgdCod 	== "7"
		cXFamSgd		:= "7 - Diversos"
	ElseIf cXFamSgdCod 	== "8"
		cXFamSgd		:= "8 - Lavadoras"	
	Endif

	cXSubFamCod := AllTrim(cXSubFam)
	If cXSubFamCod		== "1"
		cXSubFam		:= "1 - Fabrica��o"
	ElseIf cXSubFamCod 	== "2"
		cXSubFam		:= "2 - Revenda - Nacional"
	ElseIf cXSubFamCod  == "3"
		cXSubFam		:= "3 - Revenda - Importada"
	ElseIf cXSubFamCod	== "4"
		cXSubFam		:= "4 - Revenda - Grupo Hoshizaki"
	ElseIf cXSubFamCod 	== "5"
		cXSubFam		:= "5 - Servi�os"
	ElseIf cXSubFamCod 	== "6"
		cXSubFam		:= "6 - Mat�ria Prima"
	ElseIf cXSubFamCod 	== "7"
		cXSubFam		:= "7 - Embalagem"
	ElseIf cXSubFamCod 	== "8"
		cXSubFam		:= "8 - Ativo"
	ElseIf cXSubFamCod 	== "9"
		cXSubFam		:= "9 - Material de Consumo"
	Endif


//Pedido
//TRCell():New(oVenProd,"PV_QUANT"	 ,/*Tabela*/	,"PV.Quantidade"	 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nQuant	})				// Quantidade
//TRCell():New(oVenProd,"PV_SALDO"	 ,/*Tabela*/	,"PV A Entregar"	 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nSaldo	})				// Saldo
//TRCell():New(oVenProd,"PV_QT_LIB"  ,/*Tabela*/	,"PV.Qtd.Lib."		 ,PesqPict("SC6","C6_QTDVEN")	,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| nSaldo	})				// Saldo

//Saldos
//TRCell():New(oVenProd,"SLDEST"	 ,/*Tabela*/	,"Sld Estoque"	     ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldEst })				// Saldo em Estoque
//TRCell():New(oVenProd,"QTD_EMP"	 ,/*Tabela*/	,"Qtd.Est.Empen."	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldEst })				// Saldo em Estoque
//TRCell():New(oVenProd,"QTD_DISP"   ,/*Tabela*/	,"Qtd.Est.Disp."	 ,PesqPict("SB2","B2_QATU")		,TamSx3("B2_QATU")[1]		,/*lPixel*/,{|| nSldEst })				// Saldo em Estoque

	//+-------------------------------------------------------------------+
	//| Altera liberação para produção de acordo com o critério abaixo :  |
	//+-------------------------------------------------------------------+
	//| SE Tipo de venda (coluna D) = “Projeto” e                         |
	//| Lib Tec Com (Coluna R) = “vazio” e                                |
	//| Familia (Coluna Q) <> “Revenda”                                   |
	//+-------------------------------------------------------------------+
	If Alltrim((cAliasQry)->C5_XTPVEN) == "1" .And. Empty(dDtLib) .And. ! "REVENDA" $ Alltrim(cXFamil)
		cXLibPro := "NAO LIBERADO PARA PRODUCAO"  
	Else	
		cXLibPro    := "Sim"
	Endif

	If (cAliasQry)->C5_XSTSFIN == "1"
		cXStsFin := "BLOQUEADO"
	ElseIf (cAliasQry)->C5_XSTSFIN == "2"
		cXStsFin := "LIBERADO"
	Else
		cXStsFin := " "
	Endif
	
//	U_BusTpVen(cTpVen) //Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN
	
	Do Case
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "1" 
			cXTpVen		:= "1 - Projeto"		
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "2"
			cXTpVen		:= "2 - Venda Unitaria"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "3"
			cXTpVen		:= "3 - Dealer"			
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "4"
			cXTpVen		:= "4 - E-Commerce"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "5"
			cXTpVen		:= "5 - Pronta Entrega"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "6"
			cXTpVen		:= "6 - Projeto-Dealer"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "7"
			cXTpVen		:= "7 - Venda Pecas"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "8"
			cXTpVen		:= "8 - Sup.Tecnico"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "9"
			cXTpVen		:= "9 - ARE"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "10"
			cXTpVen		:= "10 - Serv"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "11"
			cXTpVen		:= "11 - Itens Falta"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == "12"
			cXTpVen		:= "12 - SAC"
		Case Alltrim((cAliasQry)->C5_XTPVEN) == ""
			cXTpVen		:= ""
	EndCase
	

	IIF(lAtraso,cAtraso	:= "Sim",cAtraso := "Nao")
	IIF(lPronta,cPronta := "Sim",cPronta := "Nao")
	
	If MV_PAR03 == 2
		cDesc	:= (cAliasQry)->B5_CEME
	Endif

	oReport:IncMeter()
	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

(cAliasQry)->(DbCloseArea())

Return                          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RetClasse  ³ Autor ³ Cleber Maldonado      ³ Data ³ 30/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a classe do pedido ( P/M/G ) baseado em seu valor.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAPCP / SIGAFAT                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RetClasse(nTotPed)

Local cRet 		:= ""
//Local cAliasTot := GetNextAlias()

DEFAULT lPos 	:= .F.
DEFAULT cNumPed := ""

If nTotPed > 0
/*
	BeginSql Alias cAliasTot
	
		SELECT 
			SUM(C6_VALOR) AS TOTAL
		FROM 
			%Table:SC6% SC6
		WHERE 
			SC6.C6_FILIAL = %xFilial:SC6% AND
			SC6.C6_NUM = %Exp:cNumPed% AND
			SC6.%NotDel%
	EndSql
*/
	
	If nTotPed > 20000.00 .And. nTotPed < 200000.00
		cRet	:= "Gastronomia"
	ElseIf nTotPed < 20000.00
		cRet	:= "Pequeno"
	ElseIf nTotPed > 200000.00
		cRet	:= "Grande"
	Endif

Endif

Return cRet
