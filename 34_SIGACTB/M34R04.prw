#INCLUDE "MATR620.ch"
#Include "PROTHEUS.ch"
                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M34R04   ³ Autor ³ Cleber Maldonado      ³ Data ³ 27/05/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Faturamento                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M34R04()

Local oReport
Private cCFOPs    := AllTrim(GetMv("AM_CFOFATD"))

//If FindFunction("TRepInUse") .And. TRepInUse()  
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
//EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Cleber Maldonado      ³ Data ³ 27/05/19 ³±±
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
oReport := TReport():New("M34R04","FATURAMENTO","M34R04", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},"Este relatorio emite a relacao de faturamento por itens do pedido de vendas. CFOPs a ignorar (3 últimos) Digitos : "+cCFOPs)
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
oVenProd := TRSection():New(oReport,"FATURAMENTO",{"SC6","SB1","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:oReport:cFontBody := "Verdana"
oVenProd:oReport:nFontBody := 10

oVenProd:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oVenProd,"FILIAL"      ,/*Tabela*/	,"Filial"            ,PesqPict("SD2","D2_FILIAL")   ,TamSx3("D2_FILIAL")[1]     ,/*lPixel*/,{|| cXFilial})		// Filial
TRCell():New(oVenProd,"ENTRADA"		,/*Tabela*/ ,"Entrada"			 ,PesqPict("SD2","D2_EMISSAO")	,TamSx3("D2_EMISSAO")[1]	,/*lPixel*/,{|| dDtEntr	})		// Data de entrada
TRCell():New(oVenProd,"EMISSAO"		,/*Tabela*/ ,"Emissao"			 ,PesqPict("SD2","D2_EMISSAO")	,TamSx3("D2_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmiss})		// Data de emissão
TRCell():New(oVenProd,"MES_EMIS"	,/*Tabela*/ ,"Mes_Emissao"		 ,PesqPict("SD2","D2_EST")	    ,TamSx3("D2_EST")[1]	    ,/*lPixel*/,{|| cMesEmis})		// Mês de Emissão
TRCell():New(oVenProd,"ANO_EMIS"	,/*Tabela*/	,"Ano_Emissao"		 ,PesqPict("SB5","B5_ANOBEN")	,TamSx3("B5_ANOBEN")[1]	    ,/*lPixel*/,{|| cAnoEmis})		// Ano de Emissão
TRCell():New(oVenProd,"NUMDOC"		,/*Tabela*/ ,"N.Documento"		 ,PesqPict("SD2","D2_DOC")		,TamSx3("D2_DOC")[1]		,/*lPixel*/,{|| cNumDoc	})		// Numero do Documento
TRCell():New(oVenProd,"SERIE"		,/*Tabela*/ ,"Serie"			 ,PesqPict("SD2","D2_SERIE")	,TamSx3("D2_SERIE")[1]		,/*lPixel*/,{|| cSerie	})		// Saldo
TRCell():New(oVenProd,"CLIENTE"		,/*Tabela*/ ,"Cliente"			 ,PesqPict("SD2","D2_CLIENTE")  ,TamSx3("D2_CLIENTE")[1]	,/*lPixel*/,{|| cCodCli	})		// Código do Cliente
TRCell():New(oVenProd,"LOJA"		,/*Tabela*/ ,"Loja"			     ,PesqPict("SD2","D2_LOJA")	    ,TamSx3("D2_LOJA")[1] 	    ,/*lPixel*/,{|| cLoja	})		// Loja Cliente
TRCell():New(oVenProd,"NOMECLI"		,/*Tabela*/ ,"Razao Social"		 ,PesqPict("SA1","A1_NOME")	    ,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNomeCli})		// Nome Cliente
TRCell():New(oVenProd,"PRODUTO"		,/*Tabela*/ ,"Produto"			 ,PesqPict("SD2","D2_COD")		,TamSx3("D2_COD")[1]		,/*lPixel*/,{|| cCod	})		// Código do Produto
TRCell():New(oVenProd,"DESCRICAO"	,/*Tabela*/ ,"Descricao"		 ,PesqPict("SB1","B1_DESC")	    ,TamSx3("B1_DESC")[1] 	    ,/*lPixel*/,{|| cDesc	})		// Descrição
TRCell():New(oVenProd,"CFOP"	    ,/*Tabela*/ ,"CFOP"		         ,PesqPict("SD2","D2_CF")	    ,TamSx3("D2_CF")[1] 	    ,/*lPixel*/,{|| cCfop	})		// CFOP
TRCell():New(oVenProd,"FAMILIA"	    ,/*Tabela*/ ,"Familia"		     ,PesqPict("ZA1","ZA1_COD")	    ,TamSx3("ZA1_COD")[1] 	    ,/*lPixel*/,{|| cCodFam	})		// Código da Familia
TRCell():New(oVenProd,"GRUPO"	    ,/*Tabela*/ ,"Grupo"		     ,PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO")[1] 	    ,/*lPixel*/,{|| cGrupo	})		// Código do grupo de produtos
TRCell():New(oVenProd,"ESTADO"	    ,/*Tabela*/ ,"Estado"		     ,PesqPict("SD2","D2_EST")	    ,TamSx3("D2_EST")[1] 	    ,/*lPixel*/,{|| cEst	})		// Estado
TRCell():New(oVenProd,"REGIAO"	    ,/*Tabela*/ ,"Regiao"		     ,PesqPict("SA1","A1_DSCREG")	,TamSx3("A1_DSCREG")[1]     ,/*lPixel*/,{|| cRegiao	})		// Região
TRCell():New(oVenProd,"PEDIDO"	    ,/*Tabela*/ ,"Num.Pedido"		 ,PesqPict("SD2","D2_PEDIDO")	,TamSx3("D2_PEDIDO")[1]     ,/*lPixel*/,{|| cNumPed	})		// Numero do Pedido
TRCell():New(oVenProd,"VENDEDOR1"   ,/*Tabela*/ ,"Vendedor1"		 ,PesqPict("SC5","C5_VEND1")	,TamSx3("C5_VEND1")[1]      ,/*lPixel*/,{|| cCodVend})		// Código do Vendedor 1
TRCell():New(oVenProd,"NOME_VEND1"  ,/*Tabela*/ ,"Nome Vendedor 1"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNomVend})		// Nome do Vendedor 1
TRCell():New(oVenProd,"GERENCIA"    ,/*Tabela*/ ,"Gerencia"	         ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNomGer })		// Nome do Gerente
TRCell():New(oVenProd,"COMISSAO1"   ,/*Tabela*/ ,"Comissao 1"	     ,PesqPict("SC5","C5_COMIS1")	,TamSx3("C5_COMIS1")[1]     ,/*lPixel*/,{|| nComiss })		// Comissão do Vendedor 1
TRCell():New(oVenProd,"TPVENDA"     ,/*Tabela*/ ,"Tipo Venda"		 ,PesqPict("SC5","C5_XTPVEN")	,TamSx3("C5_XTPVEN")[1]     ,/*lPixel*/,{|| cXTpVen})		// Tipo de Venda
TRCell():New(oVenProd,"POSIPI"      ,/*Tabela*/ ,"POSIPI"		     ,PesqPict("SB1","B1_POSIPI")	,TamSx3("B1_POSIPI")[1]     ,/*lPixel*/,{|| cPosIPI })		// Posição de IPI
TRCell():New(oVenProd,"QUANT"       ,/*Tabela*/ ,"Qauntidade"        ,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]      ,/*lPixel*/,{|| nQuant  })		// Quantidade
TRCell():New(oVenProd,"CODTAB"      ,/*Tabela*/ ,"Cod.Tabela"		 ,PesqPict("SC5","C5_TABELA")	,TamSx3("C5_TABELA")[1]     ,/*lPixel*/,{|| cCodTab })		// Código da Tabela de Preço
TRCell():New(oVenProd,"DESCTAB"     ,/*Tabela*/ ,"Descrição"		 ,PesqPict("DA0","DA0_DESCRI")	,TamSx3("DA0_DESCRI")[1]    ,/*lPixel*/,{|| cDescTab})		// Descrição da Tabela de Preço
TRCell():New(oVenProd,"PRCTAB"      ,/*Tabela*/ ,"Preco Tabela"		 ,PesqPict("DA1","DA1_PRCVEN")	,TamSx3("DA1_PRCVEN")[1]    ,/*lPixel*/,{|| nPrcTab })		// Valor unitário da Tabela de Preço
TRCell():New(oVenProd,"PRCUNIT"     ,/*Tabela*/ ,"Preco Unitario"	 ,PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN")[1]     ,/*lPixel*/,{|| nPrcUni })		// Quantidade
TRCell():New(oVenProd,"DESCONTO"    ,/*Tabela*/ ,"Desconto"	 	     ,PesqPict("SD2","D2_DESCON")	,TamSx3("D2_DESCON")[1]     ,/*lPixel*/,{|| nDescon })		// Desconto
TRCell():New(oVenProd,"FRETE"       ,/*Tabela*/ ,"Frete"	 	     ,PesqPict("SD2","D2_VALFRE")	,TamSx3("D2_VALFRE")[1]     ,/*lPixel*/,{|| nFrete  })		// Frete
TRCell():New(oVenProd,"SEGURO"      ,/*Tabela*/ ,"Seguro"	 	     ,PesqPict("SD2","D2_SEGURO")	,TamSx3("D2_SEGURO")[1]     ,/*lPixel*/,{|| nSeguro })		// Seguro
TRCell():New(oVenProd,"DESPESA"     ,/*Tabela*/ ,"Despesa"	 	     ,PesqPict("SD2","D2_DESPESA")	,TamSx3("D2_DESPESA")[1]    ,/*lPixel*/,{|| nDespesa})		// Despesa 
TRCell():New(oVenProd,"VALTOT"      ,/*Tabela*/ ,"Valor Total"	     ,PesqPict("SD2","D2_TOTAL")	,TamSx3("D2_TOTAL")[1]      ,/*lPixel*/,{|| nValTot })		// Valor Total
TRCell():New(oVenProd,"VALINST"     ,/*Tabela*/ ,"Valor Instalacao"  ,PesqPict("SC5","C5_XVLINST")	,TamSx3("C5_XVLINST")[1]    ,/*lPixel*/,{|| nValInst})		// Valor Instalacao
TRCell():New(oVenProd,"VALINST"     ,/*Tabela*/ ,"% Rat. Instalacao" ,PesqPict("SC5","C5_XVLINST")	,TamSx3("C5_XVLINST")[1]    ,/*lPixel*/,{|| nPerInst})		// % Rateio de Instalação
TRCell():New(oVenProd,"VALCONT"     ,/*Tabela*/ ,"Valor Contabil"	 ,PesqPict("SD2","D2_VALBRUT")	,TamSx3("D2_VALBRUT")[1]    ,/*lPixel*/,{|| nValCont})		// Valor Contabil
TRCell():New(oVenProd,"VALCONTL"    ,/*Tabela*/ ,"Vlr. Cont. Liq."	 ,PesqPict("SD2","D2_VALBRUT")	,TamSx3("D2_VALBRUT")[1]    ,/*lPixel*/,{|| nVlContL})		// Valor Contabil Liquido (D2_VALBRUT - IMPOSTOS)
TRCell():New(oVenProd,"BASEICMS"    ,/*Tabela*/ ,"Base de ICMS"	     ,PesqPict("SD2","D2_BASEICM")	,TamSx3("D2_BASEICM")[1]    ,/*lPixel*/,{|| nBasICM })		// Base de ICMS
TRCell():New(oVenProd,"ALIQICMS"    ,/*Tabela*/ ,"Aliq. de ICMS"	 ,PesqPict("SD2","D2_PICM")	    ,TamSx3("D2_PICM")[1]       ,/*lPixel*/,{|| nAlqICM })		// Aliquota de ICMS
TRCell():New(oVenProd,"VALICMS"     ,/*Tabela*/ ,"Valor de ICMS"	 ,PesqPict("SD2","D2_VALICM")	,TamSx3("D2_VALICM")[1]     ,/*lPixel*/,{|| nValICM })		// Valor do ICMS
TRCell():New(oVenProd,"BASEIPI"     ,/*Tabela*/ ,"Base de IPI"	     ,PesqPict("SD2","D2_BASEIPI")	,TamSx3("D2_BASEIPI")[1]    ,/*lPixel*/,{|| nBasIPI })		// Base de IPI
TRCell():New(oVenProd,"ALIQIPI"     ,/*Tabela*/ ,"Aliq. de IPI"	     ,PesqPict("SD2","D2_IPI")	    ,TamSx3("D2_IPI")[1]        ,/*lPixel*/,{|| nAlqIPI })		// Aliquota de IPI
TRCell():New(oVenProd,"VALIPI"      ,/*Tabela*/ ,"Valor de IPI"	     ,PesqPict("SD2","D2_VALIPI")	,TamSx3("D2_VALIPI")[1]     ,/*lPixel*/,{|| nValIPI })		// Valor do IPI
TRCell():New(oVenProd,"BASERET"     ,/*Tabela*/ ,"Base ICMS-ST"      ,PesqPict("SD2","D2_BRICMS")   ,TamSx3("D2_BRICMS")[1]     ,/*lPixel*/,{|| nBaseST })      // Base de ICMS-ST
TRCell():New(oVenProd,"ICMSRET"     ,/*Tabela*/ ,"Valor ICMS-ST"     ,PesqPict("SD2","D2_ICMSRET")  ,TamSx3("D2_ICMSRET")[1]    ,/*lPixel*/,{|| nValST  })      // Valor de ICMS-ST
TRCell():New(oVenProd,"BASIMP6"     ,/*Tabela*/ ,"Base PIS"	         ,PesqPict("SD2","D2_BASIMP6")	,TamSx3("D2_BASIMP6")[1]    ,/*lPixel*/,{|| nBasPIS })		// Base de PIS
TRCell():New(oVenProd,"ALQIMP6"     ,/*Tabela*/ ,"Aliq. PIS"	     ,PesqPict("SD2","D2_ALQIMP6")	,TamSx3("D2_ALQIMP6")[1]    ,/*lPixel*/,{|| nAlqPIS })		// Aliquota de PIS
TRCell():New(oVenProd,"VALIMP6"     ,/*Tabela*/ ,"Valor PIS"	     ,PesqPict("SD2","D2_VALIMP6")	,TamSx3("D2_VALIMP6")[1]    ,/*lPixel*/,{|| nValPIS })		// Valor do PIS
TRCell():New(oVenProd,"BASIMP5"     ,/*Tabela*/ ,"Base COFINS"	     ,PesqPict("SD2","D2_BASIMP5")	,TamSx3("D2_BASIMP5")[1]    ,/*lPixel*/,{|| nBasCOF })		// Base de COF
TRCell():New(oVenProd,"ALQIMP5"     ,/*Tabela*/ ,"Aliq. COFINS"	     ,PesqPict("SD2","D2_ALQIMP5")	,TamSx3("D2_ALQIMP5")[1]    ,/*lPixel*/,{|| nAlqCOF })		// Aliquota de COF
TRCell():New(oVenProd,"VALIMP5"     ,/*Tabela*/ ,"Valor COFINS"	     ,PesqPict("SD2","D2_VALIMP5")	,TamSx3("D2_VALIMP5")[1]    ,/*lPixel*/,{|| nValCOF })		// Valor do COF
TRCell():New(oVenProd,"PDORI"       ,/*Tabela*/ ,"P.DIFAL Origem"    ,PesqPict("SD2","D2_PDORI")    ,TamSx3("D2_PDORI")[1]      ,/*lPixel*/,{|| nPdOri  })      // Percentual DIFAL Origem
TRCell():New(oVenProd,"PDDES"       ,/*Tabela*/ ,"P.DIFAL Destino"   ,PesqPict("SD2","D2_PDDES")    ,TamSx3("D2_PDDES")[1]      ,/*lPixel*/,{|| nPdDes  })      // Percentual DIFAL Destino
TRCell():New(oVenProd,"PDDES"       ,/*Tabela*/ ,"Valor Difal"       ,PesqPict("SD2","D2_DIFAL")    ,TamSx3("D2_DIFAL")[1]      ,/*lPixel*/,{|| nVlDifal})      // Valor DIFAL
TRCell():New(oVenProd,"VFCPDIF"     ,/*Tabela*/ ,"FECP DIFAL"        ,PesqPict("SD2","D2_VFCPDIF")  ,TamSx3("D2_VFCPDIF")[1]    ,/*lPixel*/,{|| nVFCPDIF})      // Valor do FECP sobre o DIFAL
TRCell():New(oVenProd,"TIPOMOV"     ,/*Tabela*/ ,"Tipo Mov."         ,PesqPict("SD2","D2_TIPO")     ,TamSx3("D2_TIPO")[1]       ,/*lPixel*/,{|| "S"     })      // Tipo de movimento "S" - Saída
TRCell():New(oVenProd,"OBS"         ,/*Tabela*/ ,"Observações"       ,PesqPict("SFT","FT_OBSERV")   ,TamSx3("FT_OBSERV")[1]     ,/*lPixel*/,{|| cOBS    })      // Observações
TRCell():New(oVenProd,"VENDEDOR2"   ,/*Tabela*/ ,"Vendedor2"		 ,PesqPict("SC5","C5_VEND2")	,TamSx3("C5_VEND2")[1]      ,/*lPixel*/,{|| cCoVend2})		// Código do Vendedor 2 #5761
TRCell():New(oVenProd,"NOME_VEND2"  ,/*Tabela*/ ,"Nome Vendedor 2"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNoVend2})		// Nome do Vendedor 2   #5761
TRCell():New(oVenProd,"COMISSAO2"   ,/*Tabela*/ ,"Comissao2"	     ,PesqPict("SC5","C5_COMIS2")	,TamSx3("C5_COMIS2")[1]     ,/*lPixel*/,{|| nComis2 })		// Comissão do Vendedor 2 #5778
TRCell():New(oVenProd,"VENDEDOR3"   ,/*Tabela*/ ,"Vendedor3"		 ,PesqPict("SC5","C5_VEND3")	,TamSx3("C5_VEND3")[1]      ,/*lPixel*/,{|| cCoVend3})		// Código do Vendedor 3 #8778
TRCell():New(oVenProd,"NOME_VEND3"  ,/*Tabela*/ ,"Nome Vendedor 3"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNoVend3})		// Nome do Vendedor 3   #8778
TRCell():New(oVenProd,"COMISSAO3"   ,/*Tabela*/ ,"Comissao3"	     ,PesqPict("SC5","C5_COMIS3")	,TamSx3("C5_COMIS3")[1]     ,/*lPixel*/,{|| nComis3 })		// Comissão do Vendedor 3 #8778
TRCell():New(oVenProd,"VENDEDOR4"   ,/*Tabela*/ ,"Vendedor4"		 ,PesqPict("SC5","C5_VEND4")	,TamSx3("C5_VEND4")[1]      ,/*lPixel*/,{|| cCoVend4})		// Código do Vendedor 4 #8778
TRCell():New(oVenProd,"NOME_VEND4"  ,/*Tabela*/ ,"Nome Vendedor 4"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNoVend4})		// Nome do Vendedor 4   #8778
TRCell():New(oVenProd,"COMISSAO4"   ,/*Tabela*/ ,"Comissao4"	     ,PesqPict("SC5","C5_COMIS4")	,TamSx3("C5_COMIS4")[1]     ,/*lPixel*/,{|| nComis4 })		// Comissão do Vendedor 4 #8778
TRCell():New(oVenProd,"VENDEDOR5"   ,/*Tabela*/ ,"Vendedor5"		 ,PesqPict("SC5","C5_VEND5")	,TamSx3("C5_VEND5")[1]      ,/*lPixel*/,{|| cCoVend5})		// Código do Vendedor 5 #8778
TRCell():New(oVenProd,"NOME_VEND5"  ,/*Tabela*/ ,"Nome Vendedor 5"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNoVend5})		// Nome do Vendedor 5   #8778
TRCell():New(oVenProd,"COMISSAO5"   ,/*Tabela*/ ,"Comissao5"	     ,PesqPict("SC5","C5_COMIS5")	,TamSx3("C5_COMIS5")[1]     ,/*lPixel*/,{|| nComis5 })		// Comissão do Vendedor 5 #8778
TRCell():New(oVenProd,"PADRÃO"		,/*Tabela*/ ,"Padrão"			 ,PesqPict("SB1","B1_XPADRAO")	,TamSx3("B1_XPADRAO")[1] 	,/*lPixel*/,{|| cXpad})			// Produto Padrão? #6306
TRCell():New(oVenProd,"Rede"		,/*Tabela*/ ,"Rede"				 ,PesqPict("SA1","A1_XREDE")	,TamSx3("A1_XREDE")[1] 		,/*lPixel*/,{|| cXrede})		// Rede #6306
TRCell():New(oVenProd,"Nome Rede"	,/*Tabela*/ ,"Nome Rede"		 ,PesqPict("ZA6","ZA6_DESC")	,TamSx3("ZA6_DESC")[1] 		,/*lPixel*/,{|| cReddes})		// Nome Rede #6306
TRCell():New(oVenProd,"Seg Mercado"	,/*Tabela*/ ,"Seg Mercado"		 ,PesqPict("SA1","A1_XSEGM")	,TamSx3("A1_XSEGM")[1] 		,/*lPixel*/,{|| cXsegm})		// Segmento de Mercado #6306
TRCell():New(oVenProd,"Nome Seg Mer",/*Tabela*/ ,"Nome Seg Mercado"	 ,PesqPict("ZA8","ZA8_DESC")	,TamSx3("ZA8_DESC")[1] 		,/*lPixel*/,{|| cSegmde})		// Nome Segmento de Mercado #6306
TRCell():New(oVenProd,"SUB FAM.SUG.",/*Tabela*/ ,"Familia Sugerida"  ,PesqPict("SB1","B1_XFAMSGD")	,TamSx3("B1_XFAMSGD")[1]	,/*lPixel*/,{|| cXFamSgd })		// Familia Sugerida
TRCell():New(oVenProd,"FAMILIA.SUG.",/*Tabela*/ ,"Sub.Fam. Sugerida" ,PesqPict("SB1","B1_XSUBFAM")	,TamSx3("B1_XSUBFAM")[1]	,/*lPixel*/,{|| cXSubFam })		// Sub Fam.Sugerida
TRCell():New(oVenProd,"TES"		    ,/*Tabela*/ ,"TES"				 ,PesqPict("SD2","D2_TES")		,TamSx3("D2_TES")[1]		,/*lPixel*/,{|| cXTES })		// TES				#9197
TRCell():New(oVenProd,"ATU. ESTOQUE",/*Tabela*/ ,"Atu.Estoque"		 ,PesqPict("SF4","F4_ESTOQUE")	,TamSx3("F4_ESTOQUE")[1]	,/*lPixel*/,{|| cAtuEst })		// Atualiza Estoque	#9197
TRCell():New(oVenProd,"%DESCONT"    ,/*Tabela*/ ,"% Desconto Linha"	 ,PesqPict("SD2","D2_DESC")		,TamSx3("D2_DESC")[1]		,/*lPixel*/,{|| cDescD2 })		// % Desconto #9160	
TRCell():New(oVenProd,"DESCONT1"    ,/*Tabela*/ ,"Desconto 1"		 ,PesqPict("SC5","C5_DESC1")	,TamSx3("C5_DESC1")[1]		,/*lPixel*/,{|| cDesc1 })		// Desconto 1 #9160
TRCell():New(oVenProd,"DESCONT2"    ,/*Tabela*/ ,"Desconto 2"		 ,PesqPict("SC5","C5_DESC2")	,TamSx3("C5_DESC2")[1]		,/*lPixel*/,{|| cDesc2 })		// Desconto 2 #9160
TRCell():New(oVenProd,"DESCONT3"    ,/*Tabela*/ ,"Desconto 3"		 ,PesqPict("SC5","C5_DESC3")	,TamSx3("C5_DESC3")[1]		,/*lPixel*/,{|| cDesc3 })		// Desconto 3 #9160
TRCell():New(oVenProd,"DESCONT4"    ,/*Tabela*/ ,"Desconto 4"		 ,PesqPict("SC5","C5_DESC4")	,TamSx3("C5_DESC4")[1]		,/*lPixel*/,{|| cDesc4 })		// Desconto 4 #9160
TRCell():New(oVenProd,"ACRESC"      ,/*Tabela*/ ,"Acres. Finan"	 	 ,PesqPict("SC5","C5_ACRSFIN")	,TamSx3("C5_ACRSFIN")[1]	,/*lPixel*/,{|| cAcresc })		// Acréscimo Financeiro #9160
TRCell():New(oVenProd,"ACRESC1"     ,/*Tabela*/ ,"Acres.Linha"	     ,PesqPict("SD2","D2_VALACRS")	,TamSx3("C6_XACRESC")[1]	,/*lPixel*/,{|| cAcresc1 })		// Acrescimo Linha do Pedido #9160
TRCell():New(oVenProd,"ACRESC%"     ,/*Tabela*/ ,"Acres. Pedido %" 	 ,PesqPict("SC5","C5_XACRESC")	,TamSx3("C5_XACRESC")[1]	,/*lPixel*/,{|| cAcresc2 })		// Acréscimo % #9160
TRCell():New(oVenProd,"FRETE %"     ,/*Tabela*/ ,"Frete %" 	         ,PesqPict("SC5","C5_XFRETE")	,TamSx3("C5_XFRETE")[1]		,/*lPixel*/,{|| cFretePed })	// Frete do Pedido #9160
TRCell():New(oVenProd,"CUSTOSD2"    ,/*Tabela*/ ,"Custo Médio Linha" ,PesqPict("SD2","D2_CUSTO1")	,TamSx3("D2_CUSTO1")[1]		,/*lPixel*/,{|| cCustD2 })		// Custo em Linha #9371
TRCell():New(oVenProd,"TPPROD"      ,/*Tabela*/ ,"Tipo do Produto"   ,PesqPict("SD2","D2_TP")		,TamSx3("D2_TP")[1]			,/*lPixel*/,{|| cTpTipo })		// Tipo de Produto #9371
TRCell():New(oVenProd,"TPCLI"       ,/*Tabela*/ ,"Tipo Cliente"   	 ,PesqPict("SA1","A1_TIPO")		,TamSx3("A1_TIPO")[1]		,/*lPixel*/,{|| cTpCli })		// Tipo de Cliente #9371
TRCell():New(oVenProd,"LINHA"		,/*Tabela*/	,"Linha Produto"	 ,PesqPict("SB5","B5_XDSCLIN")	,TamSx3("B5_XDSCLIN")[1]    ,/*lPixel*/,{|| cLinha})		// Linha do Produto #10542
TRCell():New(oVenProd,"TPCLI"       ,/*Tabela*/ ,"Canal do Cliente"	 ,PesqPict("SA1","A1_XCANAL")	,TamSx3("A1_XCANAL")[1]		,/*lPixel*/,{|| cCanal })		// Canal do Cliente #10542

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Cleber Maldonado	    ³ Data ³ 27/05/19 ³±±
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

Local lPosA1	:= .F.
Local lPosB1	:= .F.
Local lPosC5	:= .F.
Local lPosC6	:= .F.
Local lPosB5	:= .F.
Local cXFamSgdCod 
Local cXSubFamCod


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")		// Itens do Pedido de Vendas
dbSetOrder(3)			// Num. Docto. + Serie + Cliente + Loja + Produto + Item

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT 
			D2_FILIAL,D2_EMISSAO,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM,
			D2_CF,
			D2_GRUPO,
			D2_EST,D2_PEDIDO,D2_QUANT,D2_PRCVEN,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_DESPESA,D2_TOTAL,
			D2_VALBRUT,D2_BASEICM,D2_PICM,D2_VALICM,D2_BASEIPI,D2_IPI,D2_VALIPI,D2_BRICMS,D2_ICMSRET,
			D2_BASIMP6,D2_ALQIMP6,D2_VALIMP6,D2_BASIMP5,D2_ALQIMP5,D2_VALIMP5,D2_PDORI,D2_PDDES,D2_DIFAL,
			D2_TES,D2_DESC,D2_VALACRS,D2_PEDIDO,D2_ITEMPV,D2_CUSTO1,D2_TP,D2_VFCPDIF
		FROM 
			%Table:SD2% SD2
		WHERE 
			SD2.D2_FILIAL >= %Exp:MV_PAR01% AND
			SD2.D2_FILIAL <= %Exp:MV_PAR02% AND
			SD2.D2_EMISSAO >= %Exp:MV_PAR03% AND
			SD2.D2_EMISSAO <= %Exp:MV_PAR04% AND
			SD2.%NotDel%
		ORDER BY SD2.D2_EMISSAO
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

//cCFOPs := AllTrim(MV_PAR05)+"/"+AllTrim(MV_PAR06)+"/"+AllTrim(MV_PAR07)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	If SubStr(Alltrim((cAliasQry)->D2_CF),2,3) $ cCFOPs
		(cAliasQry)->(dbSkip())
		Loop
	Endif

	//If Alltrim((cAliasQry)->D2_CF) $ cCFOPs
	If SubStr(Alltrim((cAliasQry)->D2_CF),2,3) $ cCFOPs
		Alert("CFOP inválido : " + (cAliasQry)->D2_CF)
	Endif

	//cXrede	:= Posicione("SA1",1,xFilial("SA1")+SA1->A1_XREDE,"A1_XREDE")						//#7746
	//cXsegm	:= Posicione("SA1",1,xFilial("SA1")+SA1->A1_XSEGM,"A1_XSEGM")						//#7746
	//cReddes	:= POSICIONE("ZA6",1,XFILIAL("ZA6")+SA1->A1_XREDE,"ZA6_DESC") 	//#7746                                                                     
	//cSegmde	:= POSICIONE("ZA8",1,xFilial("ZA8")+SA1->A1_XSEGM,"ZA8_DESC")	//#7746

	lPosB1 	:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->D2_COD))
	lPosA1	:= SA1->(MsSeek(xFilial("SA1")+(cAliasQry)->D2_CLIENTE))
	lPosB5 	:= SB5->(MsSeek(xFilial("SB5")+(cAliasQry)->D2_COD))
	
	cXFilial    := (cAliasQry)->D2_FILIAL

		
	lPosC5  := SC5->(MsSeek(cXFilial+(cAliasQry)->D2_PEDIDO))
    
    dDtEntr     := (cAliasQry)->D2_EMISSAO
    dDtEmiss    := (cAliasQry)->D2_EMISSAO
    cMesEmis    := MONTH((cAliasQry)->D2_EMISSAO)
    cAnoEmis    := Alltrim(Str(YEAR((cAliasQry)->D2_EMISSAO)))
    cNumDoc     := (cAliasQry)->D2_DOC
    cSerie      := (cAliasQry)->D2_SERIE
    cCodCli     := (cAliasQry)->D2_CLIENTE 
    cLoja       := (cAliasQry)->D2_LOJA
    cCod        := (cAliasQry)->D2_COD
    cCfop       := (cAliasQry)->D2_CF
    cGrupo      := (cAliasQry)->D2_GRUPO
    cEst        := (cAliasQry)->D2_EST
	cNumPed     := (cAliasQry)->D2_PEDIDO
	nQuant      := (cAliasQry)->D2_QUANT
    nPrcUni     := (cAliasQry)->D2_PRCVEN
    nDescon     := (cAliasQry)->D2_DESCON
    nFrete      := (cAliasQry)->D2_VALFRE  
    nSeguro     := (cAliasQry)->D2_SEGURO 
    nDespesa    := (cAliasQry)->D2_DESPESA
    nValTot     := (cAliasQry)->D2_TOTAL 
    nValCont    := (cAliasQry)->D2_VALBRUT
	cXTES		:= (cAliasQry)->D2_TES
	cDescD2		:= (cAliasQry)->D2_DESC
	cCustD2		:= (cAliasQry)->D2_CUSTO1
	cTpTipo		:= (cAliasQry)->D2_TP
					
//    nVlContL    := (cAliasQry)->D2_VALBRUT - ((cAliasQry)->D2_VALICM + (cAliasQry)->D2_VALIPI + (cAliasQry)->D2_VALIMP6 + (cAliasQry)->D2_VALIMP5)
    nVlContL    := (cAliasQry)->D2_VALBRUT - ((cAliasQry)->D2_VALICM + (cAliasQry)->D2_VALIPI +  (cAliasQry)->D2_ICMSRET + (cAliasQry)->D2_VALIMP6 + (cAliasQry)->D2_VALIMP5 + (cAliasQry)->D2_DIFAL+ (cAliasQry)->D2_VFCPDIF)

    nBasICM     := (cAliasQry)->D2_BASEICM 
    nAlqICM     := (cAliasQry)->D2_PICM 
    nValICM     := (cAliasQry)->D2_VALICM 
    nBasIPI     := (cAliasQry)->D2_BASEIPI 
    nAlqIPI     := (cAliasQry)->D2_IPI 
    nValIPI     := (cAliasQry)->D2_VALIPI
    nBaseST     := (cAliasQry)->D2_BRICMS  
    nValST      := (cAliasQry)->D2_ICMSRET
    nBasPIS     := (cAliasQry)->D2_BASIMP6
    nAlqPIS     := (cAliasQry)->D2_ALQIMP6
    nValPIS     := (cAliasQry)->D2_VALIMP6 
    nBasCOF     := (cAliasQry)->D2_BASIMP5
    nAlqCOF     := (cAliasQry)->D2_ALQIMP5 
    nValCOF     := (cAliasQry)->D2_VALIMP5 
    nPdOri      := (cAliasQry)->D2_PDORI
    nPdDes      := (cAliasQry)->D2_PDDES
    nVlDifal    := (cAliasQry)->D2_DIFAL
    nVFCPDIF    := (cAliasQry)->D2_VFCPDIF
	cPedido		:= (cAliasQry)->D2_PEDIDO
	cItemPV		:= (cAliasQry)->D2_ITEMPV
	

	lPosC6  	:= SC6->(MsSeek(cXFilial+(cAliasQry)->D2_PEDIDO + (cAliasQry)->D2_ITEMPV))
	cAcresC6	:= SC6->C6_XACRESC
	cAcresc1	:= POSICIONE('SD2',8,XFILIAL('SD2') + (cPedido + cItemPV),"cAcresC6")

    
	If lPosB5
    	cLinha      := SB5->B5_XDSCLIN
    Else
		cLinha      := ""
	Endif
	
	If lPosB1
    	cDesc       := SB1->B1_DESC
    	cPosIPI     := SB1->B1_POSIPI
    	cCodFam     := POSICIONE("ZA1",1,xFilial("ZA1")+SB1->B1_XFAMILI,"ZA1_DESC")
		cXpad		:= SB1->B1_XPADRAO
	Else
		cDesc       := ""
		cPosIPI     := ""
		cCodFam     := ""
		cXpad		:= ""
    Endif

	If		cXpad	== "1"
			cXpad 	:= "1-Sim"
	ElseIf 	cXpad	== "2"
			cXpad	:= "2-Não"
	ElseIf  cXpad	== ""
			cXpad	:= ""
	Endif

	If lPosA1
		cNomeCli    := SA1->A1_NOME
		cRegiao     := SA1->A1_DSCREG
		cXrede	    := SA1->A1_XREDE
		cXsegm      := SA1->A1_XSEGM
		cTpCli		:= SA1->A1_TIPO
		cCanal		:= SA1->A1_XCANAL
	Else
        cNomeCli    := ""
        cRegiao     := ""
		cXrede	    := SA1->A1_XREDE
		cXsegm      := SA1->A1_XSEGM
		cTpCli		:= SA1->A1_TIPO
		cCanal		:= SA1->A1_XCANAL
	Endif

	If Alltrim(SA1->A1_XCANAL) == "1" 
		cCanal := "1 - Gastronomia"
	ElseIf Alltrim(SA1->A1_XCANAL) == "2"
		cCanal := "2 - Contas Corporativas"
	ElseIf Alltrim(SA1->A1_XCANAL) == "3"
		cCanal:= "3 - Dealer"
	ElseIf Alltrim(SA1->A1_XCANAL) == "4"
		cCanal := "4 - Exportacao"
	EndIf

	If lPosC5
    	cCodVend    := SC5->C5_VEND1
        cCoVend2    := SC5->C5_VEND2
		cCoVend3	:= SC5->C5_VEND3
		cCoVend4	:= SC5->C5_VEND4
		cCoVend5	:= SC5->C5_VEND5
    	nComiss     := SC5->C5_COMIS1
        nComis2     := SC5->C5_COMIS2
		nComis3		:= SC5->C5_COMIS3
		nComis4		:= SC5->C5_COMIS4
		nComis5		:= SC5->C5_COMIS5
        cCodTab     := SC5->C5_TABELA
        nValInst    := SC5->C5_XVLINST
        nPerInst    := SC5->C5_XINSTA
		cDesc1 		:= SC5->C5_DESC1
		cDesc2		:= SC5->C5_DESC2
		cDesc3		:= SC5->C5_DESC3
		cDesc4		:= SC5->C5_DESC4
		cAcresc		:= SC5->C5_ACRSFIN
		cAcresc2	:= SC5->C5_XACRESC
		cFretePed	:= SC5->C5_XFRETE

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(XFILIAL('SA3') + SC5->C5_VEND1)
        cNomVend    := SA3->A3_NOME
		
		dbSelectArea(cAliasQry)

		cNomGer     := POSICIONE('SA3',1,XFILIAL('SA3') + SA3->A3_GEREN ,'A3_NOME')
        cNoVend2    := POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND2 ,'A3_NOME')
		cNoVend3	:= POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND3 ,'A3_NOME')
		cNoVend4	:= POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND4 ,'A3_NOME')
		cNoVend5	:= POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND5 ,'A3_NOME')
        cDescTab    := POSICIONE('DA0',1,XFILIAL('DA0') + SC5->C5_TABELA,'DA0_DESCRI')
        nPrcTab     := POSICIONE('DA1',2,XFILIAL('DA1') + (cAliasQry)->D2_COD + SC5->C5_TABELA,'DA1_PRCVEN')
		cReddes		:= POSICIONE("ZA6",1,XFILIAL("ZA6")+SA1->A1_XREDE,"ZA6_DESC")                                                                    
		cSegmde		:= POSICIONE("ZA8",1,xFilial("ZA8")+SA1->A1_XSEGM,"ZA8_DESC")
		
        
        If cTpCli == 'F'
        	cTpCli  	:= 'Cons. Final'
        ElseIf cTpCli == 'L'
            cTpCli  	:= 'Produtor Rural'
        ElseIf cTpCli == 'R'
            cTpCli  	:= 'Revendedor'
        ElseIf cTpCli == 'S'
             cTpCli  	:= 'Solidário'
        ElseIf cTpCli == 'X'
             cTpCli  	:= 'Exportação'                     
        Endif
        

//		U_BusTpVen(SC5->C5_XTPVEN,"C5_XTPVEN") //Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN

		cAtuEst	:= Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->D2_TES,"F4_ESTOQUE")
	
		If cAtuEst 		== "S" 	//#9197
			cAtuEst	:= "Sim"
		ElseIf cAtuEst 	== "N" //#9197
			cAtuEst	:= "Não"
		EndIf
		
	
		If Alltrim(SC5->C5_XTPVEN) == "1" 
			cXTpVen := "1 - Projeto"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "2"
			cXTpVen := "2 - Venda Unitaria"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "3"
			cXTpVen := "3 - Dealer"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "4"
			cXTpVen := "4 - E-Commerce"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "5"
			cXTpVen := "5 - Pronta Entrega"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "6"
			cXTpVen := "6 - Projeto-Dealer"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "7"
			cXTpVen		:= "7 - Venda de Peças"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "8"
			cXTpVen		:= "8 - Suporte Tecnico"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "9"
			cXTpVen		:= "9 - ARE"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "10"
			cXTpVen		:= "10 - Serviços"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "11"
			cXTpVen		:= "11 - Itens Faltantes"
		ElseIf Alltrim(SC5->C5_XTPVEN) == "12"
			cXTpVen		:= "12 - SAC"
		ElseIf Alltrim(SC5->C5_XTPVEN) == ""
			cXTpVen		:= ""			
		Endif    

	Else
        nComiss     := 0
        nComis2     := 0
        nPrcTab     := 0
        nValInst    := 0
        nPerInst    := 0
    	cCodVend    := ""
        cNomVend    := ""
        cCoVend2    := ""
        cNoVend2    := ""  
		cCoVend3	:= ""
		cNoVend3	:= ""
		cCoVend4	:= ""
		cNoVend4	:= ""
		cCoVend5	:= ""
		cNoVend5	:= ""    
        cNomGer     := ""
        cXTpVen  	:= ""
        cCodTab     := ""
        cDescTab    := ""
    Endif    	
    
	cXSubFam	:= Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D2_COD,"B1_XSUBFAM")
	cXFamSgd	:= Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D2_COD,"B1_XFAMSGD")

	cXFamSgdCod := AllTrim(cXFamSgd)
	If cXFamSgdCod 		== "1"
		cXFamSgd		:= "1 - Cocção"
	ElseIf cXFamSgdCod 	== "2"
		cXFamSgd		:= "2 - Componentes"
	ElseIf cXFamSgdCod  == "3"
		cXFamSgd		:= "3 - Máquina de Gelo"
	ElseIf cXFamSgdCod	== "4"
		cXFamSgd		:= "4 - Mobiliários"
	ElseIf cXFamSgdCod 	== "5"
		cXFamSgd		:= "5 - Não Vendáveis"
	ElseIf cXFamSgdCod 	== "6"
		cXFamSgd		:= "6 - Refrigeração"
	ElseIf cXFamSgdCod 	== "7"
		cXFamSgd		:= "7 - Diversos"
	ElseIf cXFamSgdCod 	== "8"
		cXFamSgd		:= "8 - Lavadoras"	
	Endif

	cXSubFamCod := AllTrim(cXSubFam)
	If cXSubFamCod		== "1"
		cXSubFam		:= "1 - Fabricação"
	ElseIf cXSubFamCod 	== "2"
		cXSubFam		:= "2 - Revenda - Nacional"
	ElseIf cXSubFamCod  == "3"
		cXSubFam		:= "3 - Revenda - Importada"
	ElseIf cXSubFamCod	== "4"
		cXSubFam		:= "4 - Revenda - Grupo Hoshizaki"
	ElseIf cXSubFamCod 	== "5"
		cXSubFam		:= "5 - Serviços"
	ElseIf cXSubFamCod 	== "6"
		cXSubFam		:= "6 - Matéria Prima"
	ElseIf cXSubFamCod 	== "7"
		cXSubFam		:= "7 - Embalagem"
	ElseIf cXSubFamCod 	== "8"
		cXSubFam		:= "8 - Ativo"
	ElseIf cXSubFamCod 	== "9"
		cXSubFam		:= "9 - Material de Consumo"
	Endif


	cOBS  := Posicione('SFT',1,xFilial("SFT")+"S"+(cAliasQry)->D2_SERIE+(cAliasQry)->D2_DOC+(cAliasQry)->D2_CLIENTE+(cAliasQry)->D2_LOJA+(cAliasQry)->D2_ITEM,'FT_OBSERV')                                                                                  

	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
	oReport:IncMeter()	

	nPrcTab := 0
	cRegiao := ""
End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return
