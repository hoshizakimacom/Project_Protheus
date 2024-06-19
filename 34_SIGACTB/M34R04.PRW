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
TRCell():New(oVenProd,"COMISSAO1"   ,/*Tabela*/ ,"Comissao"		     ,PesqPict("SC5","C5_COMIS1")	,TamSx3("C5_COMIS1")[1]     ,/*lPixel*/,{|| nComiss })		// Comissão do Vendedor 1
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
TRCell():New(oVenProd,"PADRÃO"		,/*Tabela*/ ,"Padrão"			 ,PesqPict("SB1","B1_XPADRAO")	,TamSx3("B1_XPADRAO")[1] 	,/*lPixel*/,{|| cXpad})			// Produto Padrão? #6306
TRCell():New(oVenProd,"Rede"		,/*Tabela*/ ,"Rede"				 ,PesqPict("SA1","A1_XREDE")	,TamSx3("A1_XREDE")[1] 		,/*lPixel*/,{|| cXrede})		// Rede #6306
TRCell():New(oVenProd,"Nome Rede"	,/*Tabela*/ ,"Nome Rede"		 ,PesqPict("ZA6","ZA6_DESC")	,TamSx3("ZA6_DESC")[1] 		,/*lPixel*/,{|| cReddes})		// Nome Rede #6306
TRCell():New(oVenProd,"Seg Mercado"	,/*Tabela*/ ,"Seg Mercado"		 ,PesqPict("SA1","A1_XSEGM")	,TamSx3("A1_XSEGM")[1] 		,/*lPixel*/,{|| cXsegm})		// Segmento de Mercado #6306
TRCell():New(oVenProd,"Nome Seg Mer",/*Tabela*/ ,"Nome Seg Mercado"	 ,PesqPict("ZA8","ZA8_DESC")	,TamSx3("ZA8_DESC")[1] 		,/*lPixel*/,{|| cSegmde})		// Nome Segmento de Mercado #6306


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
			D2_BASIMP6,D2_ALQIMP6,D2_VALIMP6,D2_BASIMP5,D2_ALQIMP5,D2_VALIMP5,D2_PDORI,D2_PDDES,D2_DIFAL,D2_VFCPDIF
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

	cXrede	:= SA1->A1_XREDE
	cXsegm	:= SA1->A1_XSEGM
	cReddes	:= POSICIONE("ZA6",1,xFilial("ZA6")+SA1->A1_XREDE,"ZA6_DESC")
	cSegmde	:= POSICIONE("ZA8",1,xFilial("ZA8")+SA1->A1_XSEGM,"ZA8_DESC")

	lPosB1 	:= SB1->(MsSeek(xFilial("SB1")+(cAliasQry)->D2_COD))
	lPosA1	:= SA1->(MsSeek(xFilial("SA1")+(cAliasQry)->D2_CLIENTE))
	
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
	
//    nVlContL    := (cAliasQry)->D2_VALBRUT - ((cAliasQry)->D2_VALICM + (cAliasQry)->D2_VALIPI + (cAliasQry)->D2_VALIMP6 + (cAliasQry)->D2_VALIMP5)
    nVlContL    := (cAliasQry)->D2_VALBRUT - ((cAliasQry)->D2_VALICM + (cAliasQry)->D2_VALIPI +  (cAliasQry)->D2_ICMSRET + (cAliasQry)->D2_VALIMP6 + (cAliasQry)->D2_VALIMP5)

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
	Else
        cNomeCli    := ""
        cRegiao     := ""
	Endif

	If lPosC5
    	cCodVend    := SC5->C5_VEND1
        cCoVend2    := SC5->C5_VEND2
    	nComiss     := SC5->C5_COMIS1
        nComis2     := SC5->C5_COMIS2
        cCodTab     := SC5->C5_TABELA
        nValInst    := SC5->C5_XVLINST
        nPerInst    := SC5->C5_XINSTA

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(XFILIAL('SA3') + SC5->C5_VEND1)
        cNomVend    := SA3->A3_NOME
		
		dbSelectArea(cAliasQry)

		cNomGer     := POSICIONE('SA3',1,XFILIAL('SA3') + SA3->A3_GEREN ,'A3_NOME')
        cNoVend2    := POSICIONE('SA3',1,XFILIAL('SA3') + SC5->C5_VEND2 ,'A3_NOME')
        cDescTab    := POSICIONE('DA0',1,XFILIAL('DA0') + SC5->C5_TABELA,'DA0_DESCRI')
        nPrcTab     := POSICIONE('DA1',2,XFILIAL('DA1') + (cAliasQry)->D2_COD + SC5->C5_TABELA,'DA1_PRCVEN')

        /*
        If SC5->C5_XTPVEN == '1'
        	cTpVenda  	:= 'PROJETO'
        ElseIf SC5->C5_XTPVEN == '2'
            cTpVenda  	:= 'VENDA UNITARIA'
        ElseIf SC5->C5_XTPVEN == '3'
            cTpVenda  	:= 'DEALER'
        ElseIf SC5->C5_XTPVEN == '4'
             cTpVenda  	:= 'E-COMMERCE'
        ElseIf SC5->C5_XTPVEN == '5'
             cTpVenda  	:= 'PRONTA ENTREGA'                     
        Endif
        */

//		U_BusTpVen(SC5->C5_XTPVEN,"C5_XTPVEN") //Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN

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
        cNomGer     := ""
        cXTpVen  	:= ""
        cCodTab     := ""
        cDescTab    := ""
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
