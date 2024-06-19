#Include "PROTHEUS.ch"
                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M34R09   ³ Autor ³ Claudio Ambrosini     ³ Data ³ 11/09/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao Devoluções de Vendas                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M34R09()

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
±±³Programa  ³ReportDef ³ Autor ³ Claudio Ambrosini     ³ Data ³ 11/09/22 ³±±
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
Local oRelDev
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
oReport := TReport():New("M34R09","DEVOLUCOES","M34R09", {|oReport| ReportPrint(oReport,cAliasQry,oRelDev)},"Este relatorio emite a relacao de Devolucoes de pedido de vendas.")
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
oRelDev := TRSection():New(oReport,"Devolucao",{"SFT","SA1","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Devolucoes de Pedido de Venda"
oRelDev:oReport:cFontBody := "Verdana"
oRelDev:oReport:nFontBody := 10

oRelDev:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define celulas da secao                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oRelDev,"FILIAL"         ,/*Tabela*/ ,"Filial"              ,PesqPict("SFT","FT_FILIAL")   ,TamSx3("FT_FILIAL")[1]     ,/*lPixel*/,{|| cXFilial})		// 01 - Filial
TRCell():New(oRelDev,"DT ENT DEV"	  ,/*Tabela*/ ,"Dt Ent Dev"		     ,PesqPict("SFT","FT_ENTRADA")	,TamSx3("FT_ENTRADA")[1]	,/*lPixel*/,{|| dDtEntrDev})    // 02 - Data de entrada da Devolucao
TRCell():New(oRelDev,"EMISSAO"		  ,/*Tabela*/ ,"Emissao"			 ,PesqPict("SFT","FT_EMISSAO")	,TamSx3("FT_EMISSAO")[1]	,/*lPixel*/,{|| dDtEmisDev})	// 03 - Data de emissão da Devolucao
TRCell():New(oRelDev,"NOTA FISCAL"	  ,/*Tabela*/ ,"Nota Fiscal"		 ,PesqPict("SFT","FT_NFISCAL")	,TamSx3("FT_NFISCAL")[1]    ,/*lPixel*/,{|| cNFiscal})		// 04 - Numero da Nota Fiscal de Devolucao
TRCell():New(oRelDev,"DOCTO ORIGEM"	  ,/*Tabela*/ ,"Docto Origem"		 ,PesqPict("SFT","FT_NFORI")	,TamSx3("FT_NFORI")[1]	    ,/*lPixel*/,{|| cNfori})		// 05 - Nota Fiscal de Origem
TRCell():New(oRelDev,"SERIE ORIGEM"	  ,/*Tabela*/ ,"Serie Origem"		 ,PesqPict("SFT","FT_SERORI")	,TamSx3("FT_SERORI")[1]		,/*lPixel*/,{|| cSerori})		// 06 - Serie Origem
TRCell():New(oRelDev,"CLIFOR"		  ,/*Tabela*/ ,"Clifor"			     ,PesqPict("SFT","FT_CLIEFOR")  ,TamSx3("FT_CLIEFOR")[1]	,/*lPixel*/,{|| cCodClifor})	// 07 - Código do Cliente / Fornecedor
TRCell():New(oRelDev,"LOJA"		      ,/*Tabela*/ ,"Loja"			     ,PesqPict("SFT","FT_LOJA")	    ,TamSx3("FT_LOJA")[1] 	    ,/*lPixel*/,{|| cLojClifor})	// 08 - Loja Cliente / Fornecedor
TRCell():New(oRelDev,"Cli_Loja" 	  ,/*Tabela*/ ,"Cli/Loja"			 ,PesqPict("SA1","A1_NREDUZ")   ,TamSx3("A1_NREDUZ")[1]     ,/*lPixel*/,{|| cCliLoja})		// Código do Cliente + Loja éder fm
TRCell():New(oRelDev,"NOMECLI"		  ,/*Tabela*/ ,"Razao Social"		 ,PesqPict("SA1","A1_NOME")	    ,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| cNomCliFor})	// 09 - Nome Cliente / Fornecedor
TRCell():New(oRelDev,"TIPOCLI"		  ,/*Tabela*/ ,"Tipo Cli"		     ,PesqPict("SA1","A1_TIPO")	    ,TamSx3("A1_TIPO")[1]		,/*lPixel*/,{|| cTipoCli})	    // 10 - Tipo do Cliente -> F=Consumidor Final / L=Produtor Rural / R=Revendedor / S=Solidario / X=Exportacao
TRCell():New(oRelDev,"GRUPOTRI"	      ,/*Tabela*/ ,"Grupo tributario"    ,PesqPict("SA1","A1_GRPTRIB")	,TamSx3("A1_GRPTRIB")[1]    ,/*lPixel*/,{|| cGrupoTri})		// 11 - Código do grupo de Tributario SA1
TRCell():New(oRelDev,"EST.REFERENCIA" ,/*Tabela*/ ,"Estado Referencia"   ,PesqPict("SFT","FT_ESTADO")	,TamSx3("FT_ESTADO")[1]     ,/*lPixel*/,{|| cEstRef	})		// 12 - Estado de Referencia
TRCell():New(oRelDev,"OPERACAO"	      ,/*Tabela*/ ,"Operacao"		     ,PesqPict("SB1","B1_DESC")	    ,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| cOperaNew})		// 13 - Operacao (tipo de produto -> SE FOR "ME" sera igual a "REMESSA" e demais sera "VENDA")
TRCell():New(oRelDev,"Tip_Xprd"      ,/*Tabela*/ ,"Tipo Produto"	     ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]     ,/*lPixel*/,{|| cXtipPr	})		// Tipo Produto customizado Éder FM
TRCell():New(oRelDev,"Fam_HJ"	      ,/*Tabela*/ ,"Familia_HJ"	   	     ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1] 	,/*lPixel*/,{|| cFamHj	})		// Família HJ Éder FM
TRCell():New(oRelDev,"NOME_VEND1"    ,/*Tabela*/ ,"Nome Vendedor 1"	 ,PesqPict("SA3","A3_NOME")	    ,TamSx3("A3_NOME")[1]       ,/*lPixel*/,{|| cNomVend})		// Nome do Vendedor 1
TRCell():New(oRelDev,"Vendedor"      ,/*Tabela*/ ,"Vendedor"	    	 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]    	,/*lPixel*/,{|| cXVende	})		// Vendedor Customizado éDER
TRCell():New(oRelDev,"DIVISAO"       ,/*Tabela*/ ,"Divisao"	    	 ,PesqPict("SA1","A1_NREDUZ")	,TamSx3("A1_NREDUZ")[1]     ,/*lPixel*/,{|| cDivisa	})		// Divisão ÉDER FM
TRCell():New(oRelDev,"COD PRODUTO"	  ,/*Tabela*/ ,"Cod Produto"	     ,PesqPict("SFT","FT_PRODUTO")	,TamSx3("FT_PRODUTO")[1]	,/*lPixel*/,{|| cCodPro	})		// 14 - Código do Produto
TRCell():New(oRelDev,"DESCRICAO"	  ,/*Tabela*/ ,"Descricao"		     ,PesqPict("SB1","B1_DESC")	    ,TamSx3("B1_DESC")[1] 	    ,/*lPixel*/,{|| cDescPro})		// 15 - Descrição do Produto
TRCell():New(oRelDev,"Tipo Produto"	  ,/*Tabela*/ ,"Tipo Produto"		 ,PesqPict("SB1","B1_TIPO")	    ,TamSx3("B1_TIPO")[1] 	    ,/*lPixel*/,{|| cTipPro})		// 16 - Tipo do Produto-> PA=PRODUTO ACABADO / MP=MATERIA PRIMA etc...  /
TRCell():New(oRelDev,"Origem Produto" ,/*Tabela*/ ,"Origem Produto"		 ,PesqPict("SB1","B1_ORIGEM")   ,TamSx3("B1_ORIGEM")[1] 	,/*lPixel*/,{|| cOriPro})		// 17 - Origem do Produto-> 0=NACIONAL ...ETC.... 
TRCell():New(oRelDev,"NCM"            ,/*Tabela*/ ,"NCM"		         ,PesqPict("SFT","FT_POSIPI")	,TamSx3("FT_POSIPI")[1]     ,/*lPixel*/,{|| cPosIPI })		// 18 - NCM - Posição de IPI
TRCell():New(oRelDev,"Conta Contabil" ,/*Tabela*/ ,"Conta Contabil"      ,PesqPict("SFT","FT_CONTA")	,TamSx3("FT_CONTA")[1]      ,/*lPixel*/,{|| cConta })		// 19 - Conta Contabil
TRCell():New(oRelDev,"CFOP"	          ,/*Tabela*/ ,"CFOP"		         ,PesqPict("SFT","FT_CFOP")	    ,TamSx3("FT_CFOP")[1] 	    ,/*lPixel*/,{|| cCfop	})		// 20 - Codigo da CFOP
TRCell():New(oRelDev,"FAMILIA"	      ,/*Tabela*/ ,"Familia"		     ,PesqPict("ZA1","ZA1_COD")	    ,TamSx3("ZA1_COD")[1] 	    ,/*lPixel*/,{|| cCodFam	})		// Código da Familia
TRCell():New(oRelDev,"QUANT"          ,/*Tabela*/ ,"Quantidade"          ,PesqPict("SFT","FT_QUANT")	,TamSx3("FT_QUANT")[1]      ,/*lPixel*/,{|| nQuant  })		// 21 - Quantidade
TRCell():New(oRelDev,"PRC UNITARIO"   ,/*Tabela*/ ,"Preco Unitario"	     ,PesqPict("SFT","FT_PRCUNIT")	,TamSx3("FT_PRCUNIT")[1]    ,/*lPixel*/,{|| nPrcUni })		// 22 - Preco Unitario
TRCell():New(oRelDev,"VALOR TOTAL"    ,/*Tabela*/ ,"Valor Total"	     ,PesqPict("SFT","FT_TOTAL")	,TamSx3("FT_TOTAL")[1]      ,/*lPixel*/,{|| nValTot })		// 23 - Valor Total
TRCell():New(oRelDev,"VALOR FRETE"    ,/*Tabela*/ ,"Valor Frete"	 	 ,PesqPict("SFT","FT_FRETE")	,TamSx3("FT_FRETE")[1]      ,/*lPixel*/,{|| nFrete  })		// 24 - valor do Frete
TRCell():New(oRelDev,"VALOR SEGURO"   ,/*Tabela*/ ,"Valor Seguro"	     ,PesqPict("SFT","FT_SEGURO")	,TamSx3("FT_SEGURO")[1]     ,/*lPixel*/,{|| nSeguro })		// 25 - Valor do Seguro
TRCell():New(oRelDev,"VALOR DESPESA"  ,/*Tabela*/ ,"Valor Despesa"	     ,PesqPict("SFT","FT_DESPESA")	,TamSx3("FT_DESPESA")[1]    ,/*lPixel*/,{|| nDespesa})		// 26 - Valor da Despesa 
TRCell():New(oRelDev,"VALOR DESCONTO" ,/*Tabela*/ ,"Valor Desconto"	     ,PesqPict("SFT","FT_DESCONT")	,TamSx3("FT_DESCONT")[1]    ,/*lPixel*/,{|| nDescon })		// 27 - Valor do Desconto
TRCell():New(oRelDev,"VALCONTL"       ,/*Tabela*/ ,"Vlr. Cont. Liq."	 ,PesqPict("SFT","FT_TOTAL")	,TamSx3("D2_VALBRUT")[1]    ,/*lPixel*/,{|| nVlContL})		// 28 - Valor Contabil Liquido 
TRCell():New(oRelDev,"VALOR CONTABIL" ,/*Tabela*/ ,"Valor Contabil"	     ,PesqPict("SFT","FT_VALCONT")	,TamSx3("FT_VALCONT")[1]    ,/*lPixel*/,{|| nValCont})		// 29 - Valor Contabil
TRCell():New(oRelDev,"VLCNTAT"       ,/*Tabela*/ ,"Vlr. Cont. Atual"	 ,PesqPict("SFT","FT_TOTAL")	,TamSx3("D2_VALBRUT")[1]    ,/*lPixel*/,{|| nVlContA})		// Valor Contabil Atual Éder FM
TRCell():New(oRelDev,"BASE ICMS"      ,/*Tabela*/ ,"Base de ICMS"	     ,PesqPict("SFT","FT_BASEICM")	,TamSx3("FT_BASEICM")[1]    ,/*lPixel*/,{|| nBasICM })		// 30 - Valor da Base de ICMS
TRCell():New(oRelDev,"ALIQ ICMS"      ,/*Tabela*/ ,"Aliq. de ICMS"	     ,PesqPict("SFT","FT_ALIQICM")  ,TamSx3("FT_ALIQICM")[1]    ,/*lPixel*/,{|| nAlqICM })		// 31 - Valor da Aliquota de ICMS
TRCell():New(oRelDev,"VAL ICMS"       ,/*Tabela*/ ,"Valor de ICMS"	     ,PesqPict("SFT","FT_VALICM")	,TamSx3("FT_VALICM")[1]     ,/*lPixel*/,{|| nValICM })		// 32 - Valor do ICMS
TRCell():New(oRelDev,"BASE IPI"       ,/*Tabela*/ ,"Base de IPI"	     ,PesqPict("SFT","FT_BASEIPI")	,TamSx3("FT_BASEIPI")[1]    ,/*lPixel*/,{|| nBasIPI })		// 33 - Valor da Base de IPI
TRCell():New(oRelDev,"ALIQ IPI"       ,/*Tabela*/ ,"Aliq. de IPI"	     ,PesqPict("SFT","FT_ALIQIPI")	,TamSx3("FT_ALIQIPI")[1]    ,/*lPixel*/,{|| nAlqIPI })		// 34 - Valor da Aliquota de IPI
TRCell():New(oRelDev,"VAL IPI"        ,/*Tabela*/ ,"Valor de IPI"	     ,PesqPict("SFT","FT_VALIPI")	,TamSx3("FT_VALIPI")[1]     ,/*lPixel*/,{|| nValIPI })		// 35 - Valor do IPI
TRCell():New(oRelDev,"BASE RETENCAO"  ,/*Tabela*/ ,"Base ICMS-ST"        ,PesqPict("SFT","FT_BASERET")   ,TamSx3("FT_BASERET")[1]   ,/*lPixel*/,{|| nBaseST })      // 36 - Valor da Base de ICMS-ST (Analisar claudio)
TRCell():New(oRelDev,"ALIQ ICMS SOL"  ,/*Tabela*/ ,"Aliq Icms Sol"       ,PesqPict("SFT","FT_ALIQSOL")  ,TamSx3("FT_ALIQSOL")[1]    ,/*lPixel*/,{|| nAliqSol})      // 37 - Valor da Aliquota do ICMS-Solidario
TRCell():New(oRelDev,"ICMS RET"       ,/*Tabela*/ ,"Valor ICMS-ST"       ,PesqPict("SFT","FT_ICMSRET")  ,TamSx3("FT_ICMSRET")[1]    ,/*lPixel*/,{|| nValST  })      // 38 - Valor de ICMS-ST
TRCell():New(oRelDev,"BASE PIS"       ,/*Tabela*/ ,"Base PIS"	         ,PesqPict("SFT","FT_BASEPIS")	,TamSx3("FT_BASEPIS")[1]    ,/*lPixel*/,{|| nBasPIS })		// 39 - Base de Calculo do PIS
TRCell():New(oRelDev,"ALIQ PIS"       ,/*Tabela*/ ,"Aliq. PIS"	         ,PesqPict("SFT","FT_ALIQPIS")	,TamSx3("FT_ALIQPIS")[1]    ,/*lPixel*/,{|| nAlqPIS })		// 40 - Aliquota de PIS
TRCell():New(oRelDev,"VALOR PIS"      ,/*Tabela*/ ,"Valor PIS"	         ,PesqPict("SFT","FT_VALPIS")	,TamSx3("FT_VALPIS")[1]     ,/*lPixel*/,{|| nValPIS })		// 41 - Valor do PIS
TRCell():New(oRelDev,"BASE COFINS"    ,/*Tabela*/ ,"Base COFINS"	     ,PesqPict("SFT","FT_BASECOF")	,TamSx3("FT_BASECOF")[1]    ,/*lPixel*/,{|| nBasCOF })		// 42 - Base de COFINS
TRCell():New(oRelDev,"ALIQ COFINS"    ,/*Tabela*/ ,"Aliq. COFINS"	     ,PesqPict("SFT","FT_ALIQCOF")	,TamSx3("FT_ALIQCOF")[1]    ,/*lPixel*/,{|| nAlqCOF })		// 43 - Aliquota de COFINS
TRCell():New(oRelDev,"VALOR COFINS"   ,/*Tabela*/ ,"Valor COFINS"	     ,PesqPict("SFT","FT_VALCOF")	,TamSx3("FT_VALCOF")[1]     ,/*lPixel*/,{|| nValCOF })		// 44 - Valor do COFINS
TRCell():New(oRelDev,"PDORI"          ,/*Tabela*/ ,"P.DIFAL Origem"      ,PesqPict("SFT","FT_PDORI")    ,TamSx3("FT_PDORI")[1]      ,/*lPixel*/,{|| nPdOri  })      // 45 - Percentual DIFAL Origem
TRCell():New(oRelDev,"PDDES"          ,/*Tabela*/ ,"P.DIFAL Destino"     ,PesqPict("SFT","FT_PDDES")    ,TamSx3("FT_PDDES")[1]      ,/*lPixel*/,{|| nPdDes  })      // 46 - Percentual DIFAL Destino
TRCell():New(oRelDev,"VALCECPF"       ,/*Tabela*/ ,"VAL FECP "           ,PesqPict("SFT","FT_VALFECP")  ,TamSx3("FT_VALFECP")[1]    ,/*lPixel*/,{|| nFECP})         // 47 - Valor do FECP 
TRCell():New(oRelDev,"FCPEDIF" 	      ,/*Tabela*/ ,"FECP+DIFAL"          ,PesqPict("SFT","FT_VALFECP")  ,TamSx3("FT_VALFECP")[1]    ,/*lPixel*/,{|| nFCPEDIF})      // FECP + DIFAL Éder FM

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ CLAUDIO AMBROSINI	    ³ Data ³ 11/09/22 ³±±
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
Static Function ReportPrint(oReport,cAliasQry,oRelDev)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFT")		// Livro Fiscal por Item de NF   
dbSetOrder(1)			// FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO                                                                                   
                        // Filial + Tipo Mov.+ Série NF + Doc. Fiscal + Cli/Forn. + Codigo loja + Código

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT DISTINCT
		     FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_NFORI,FT_SERORI,FT_TIPO, FT_OBSERV, FT_CLIEFOR,FT_LOJA,A1_NOME,A1_TIPO,FT_CLASFIS,A1_GRPTRIB,FT_ESTADO,FT_PRODUTO,B1_DESC,
		     B1_TIPO,B1_ORIGEM,FT_POSIPI,FT_CONTA,FT_CFOP,FT_QUANT,FT_PRCUNIT,FT_TOTAL,FT_FRETE,FT_SEGURO,FT_DESPESA,FT_DESCONT,FT_VALCONT,FT_BASEICM,
		     FT_ALIQICM,FT_VALICM,FT_BASEIPI,FT_ALIQIPI,FT_VALIPI,FT_BASERET,FT_ALIQSOL,FT_ICMSRET,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
		     FT_VALCOF,FT_PDORI,FT_PDDES,FT_VALFECP,B1_XTIPOHO,B1_COD,B1_XDSCFAM,B1_XFAMILI,C5_VEND1,C5_XTPVEN  
		FROM %Table:SFT% SFT 
        INNER JOIN %Table:SA1% SA1 ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND SA1.%notdel% 
        INNER JOIN %Table:SB1% SB1 ON FT_PRODUTO = B1_COD AND SB1.%notdel% 
        INNER JOIN %Table:SC5% SC5 ON FT_FILIAL = C5_FILIAL AND FT_CLIEFOR = C5_CLIENTE AND FT_NFORI = C5_NOTA AND FT_SERORI = C5_SERIE AND SC5.%notdel% 
        WHERE
             SFT.FT_OBSERV NOT LIKE '%CANCELADA%' AND
             SFT.FT_TIPO ='D' AND 
             SFT.FT_FILIAL  >= %Exp:MV_PAR01% AND
             SFT.FT_FILIAL  <= %Exp:MV_PAR02% AND
             SFT.FT_ENTRADA >= %Exp:MV_PAR03% AND
             SFT.FT_ENTRADA <= %Exp:MV_PAR04% AND
             SFT.FT_EMISSAO >= %Exp:MV_PAR05% AND
			 SFT.FT_EMISSAO <= %Exp:MV_PAR06% AND 
             SFT.%notdel%           
		ORDER BY SFT.FT_EMISSAO
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //INNER JOIN %Table:SF2% SF2 ON FT_NFORI = F2_DOC AND FT_SERORI = F2_SERIE AND SF2.%notdel% 
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFT")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

    cOperaNew := ""

	cXFilial    := (cAliasQry)->FT_FILIAL       // 01 - Filial
    dDtEntrDev  := (cAliasQry)->FT_ENTRADA      // 02 - Data de entrada da Devolucao
    dDtEmisDev  := (cAliasQry)->FT_EMISSAO      // 03 - Data de emissão da Devolucao
    cNFiscal    := (cAliasQry)->FT_NFISCAL      // 04 - Numero da Nota Fiscal de Devolucao
    cNfori      := (cAliasQry)->FT_NFORI		// 05 - Nota Fiscal de Origem
    cSerori     := (cAliasQry)->FT_SERORI		// 06 - Serie Origem
    cCodClifor  := (cAliasQry)->FT_CLIEFOR  	// 07 - Código do Cliente / Fornecedor
    cLojClifor  := (cAliasQry)->FT_LOJA 	    // 08 - Loja Cliente / Fornecedor
    cCliLoja	:= (cAliasQry)->FT_CLIEFOR + "-" + (cAliasQry)->FT_LOJA //Éder fm
    cNomCliFor  := (cAliasQry)->A1_NOME         // 09 - Nome Cliente / Fornecedor
    cTipoCli    := (cAliasQry)->A1_TIPO 	    // 10 - Tipo do Cliente -> F=Consumidor Final / L=Produtor Rural / R=Revendedor / S=Solidario / X=Exportacao
    cGrupoTri   := (cAliasQry)->A1_GRPTRIB      // 11 - Código do grupo de Tributario TABELA SA1
    cEstRef     := (cAliasQry)->FT_ESTADO       // 12 - Estado de Referencia
    cOperacao   := (cAliasQry)->B1_TIPO  		// 13 - Operacao BUSCAR DA B1, SE O TIPO FOR "ME" VAI SER "REVENDA" O RESTO SERA VENDA
    IF cOperacao == "ME"
       cOperacao := "REVENDA"
       cOperaNew := cOperacao
    else
       cOperacao := "VENDA"
       cOperaNew := cOperacao
    EndIF
    cCodPro     := (cAliasQry)->FT_PRODUTO  	// 14 - Código do Produto
    cDescPro    := (cAliasQry)->B1_DESC         // 15 - Descrição do Produto
    cTipPro     := (cAliasQry)->B1_TIPO 		// 16 - Tipo do Produto-> PA=PRODUTO ACABADO / MP=MATERIA PRIMA etc...  /
    cOriPro     := (cAliasQry)->B1_ORIGEM		// 17 - Origem do Produto-> 0=NACIONAL ...ETC.... 
    cPosIPI     := (cAliasQry)->FT_POSIPI		// 18 - NCM - Posição de IPI
    cConta      := (cAliasQry)->FT_CONTA		// 19 - Conta Contabil
    cCfop       := (cAliasQry)->FT_CFOP 		// 20 - Codigo da CFOP
    nQuant      := (cAliasQry)->FT_QUANT 		// 21 - Quantidade
    nPrcUni     := (cAliasQry)->FT_PRCUNIT		// 22 - Preco Unitario
    nValTot     := (cAliasQry)->FT_TOTAL		// 23 - Valor Total
    nFrete      := (cAliasQry)->FT_FRETE		// 24 - valor do Frete
    nSeguro     := (cAliasQry)->FT_SEGURO		// 25 - Valor do Seguro
    nDespesa    := (cAliasQry)->FT_DESPESA		// 26 - Valor da Despesa 
    nDescon     := (cAliasQry)->FT_DESCONT      // 27 - Valor do Desconto
    nVlContL    := (cAliasQry)->FT_VALCONT - ((cAliasQry)->FT_VALICM + (cAliasQry)->FT_VALIPI + (cAliasQry)->FT_ICMSRET + (cAliasQry)->FT_VALPIS + (cAliasQry)->FT_VALCOF + (cAliasQry)->FT_PDDES + (cAliasQry)->FT_VALFECP )   // 28 - Valor Contabil Liquido   
    nValCont    := (cAliasQry)->FT_VALCONT		// 29 - Valor Contabil
    nBasICM     := (cAliasQry)->FT_BASEICM		// 30 - Valor da Base de ICMS
    nAlqICM     := (cAliasQry)->FT_ALIQICM		// 31 - Valor da Aliquota de ICMS
    nValICM     := (cAliasQry)->FT_VALICM		// 32 - Valor do ICMS
    nBasIPI     := (cAliasQry)->FT_BASEIPI		// 33 - Valor da Base de IPI
    nAlqIPI     := (cAliasQry)->FT_ALIQIPI		// 34 - Valor da Aliquota de IPI
    nValIPI     := (cAliasQry)->FT_VALIPI		// 35 - Valor do IPI
    nBaseST     := (cAliasQry)->FT_BASERET      // 36 - Valor da Base de ICMS-ST (Analisar claudio)
    nAliqSol    := (cAliasQry)->FT_ALIQSOL      // 37 - Valor da Aliquota do ICMS-Solidario
    nValST      := (cAliasQry)->FT_ICMSRET      // 38 - Valor de ICMS-ST
    nBasPIS     := (cAliasQry)->FT_BASEPIS		// 39 - Base de Calculo do PIS
    nAlqPIS     := (cAliasQry)->FT_ALIQPIS		// 40 - Aliquota de PIS
    nValPIS     := (cAliasQry)->FT_VALPIS   	// 41 - Valor do PIS
    nBasCOF     := (cAliasQry)->FT_BASECOF		// 42 - Base de COFINS
    nAlqCOF     := (cAliasQry)->FT_ALIQCOF		// 43 - Aliquota de COFINS
    nValCOF     := (cAliasQry)->FT_VALCOF		// 44 - Valor do COFINS
    nPdOri      := (cAliasQry)->FT_PDORI        // 45 - Percentual DIFAL Origem
    nPdDes      := (cAliasQry)->FT_PDDES        // 46 - Percentual DIFAL Destino
    nFECP       := (cAliasQry)->FT_VALFECP      // 47 - Valor do FECP 

    IIF((cAliasQry)->FT_VALFECP+(cAliasQry)->FT_PDDES>0,nFCPEDIF:=(cAliasQry)->FT_VALFECP+(cAliasQry)->FT_PDDES,0)

    //nVlContA	:= nVlContL - (nValICM + nValIPI + nValST + nValPIS + nValCOF + nVFCPDIF + nVlDifal)

    nVlContA	:= nVlContL - (nValICM + nValIPI + nValST + nValPIS + nValCOF + nFCPEDIF)

    IIF((cAliasQry)->B1_XTIPOHO <> "",cXtipPr:=(cAliasQry)->B1_XTIPOHO,"")
    
	If (cAliasQry)->B1_XTIPOHO $ "3"
		cXtipPr := "Refrigerador Horizontal"
	ElseIf (cAliasQry)->B1_XTIPOHO $ "2"
		cXtipPr := "Máquina de Gelo"
	ElseIf (cAliasQry)->B1_XTIPOHO $ "4"
		cXtipPr := "Refrigerador Vertical"
	Else
		cXtipPr := "Diversos"
	EndIf


    If Substr((cAliasQry)->B1_COD,1,6) $ "HOSSRM"
        cFamHj := "SRM IMPORT"
    ElseIf Substr((cAliasQry)->B1_COD,1,3) $ "SRM"
        cFamHj := "SRM IN HOUSE"
    ElseIf Substr((cAliasQry)->B1_COD,1,3) $ "HOS" .AND. Substr((cAliasQry)->B1_COD,4,2) <> "KM" .AND. Substr((cAliasQry)->B1_COD,4,3) <> "SRM"
        cFamHj := "IM IMPORT"
    ElseIf Substr((cAliasQry)->B1_COD,1,2) $ "KM"
        cFamHj := "IM IN HOUSE"
    ElseIf (cAliasQry)->B1_TIPO $ "ME"
        cFamHj := "RESALE"
    ElseIf Alltrim((cAliasQry)->B1_XDSCFAM) == "COCCAO"
        cFamHj := "COOKING"
    ElseIf Alltrim((cAliasQry)->B1_XDSCFAM) == "REFRIGERACAO"
        cFamHj := "RI"
    ElseIf Alltrim((cAliasQry)->B1_XDSCFAM) == "COMPONENTES"
        cFamHj := "FABRICATION NASUL OOG"
    Else
        cFamHj := "FABRICATION NASUL OOG"
    EndIf

    IIF(!Empty(POSICIONE("ZA1",1,xFilial("ZA1")+(cAliasQry)->B1_XFAMILI,"ZA1_DESC")),cCodFam:=POSICIONE("ZA1",1,xFilial("ZA1")+(cAliasQry)->B1_XFAMILI,"ZA1_DESC"),"")


    //F=Cons.Final;L=Produtor Rural;R=Revendedor;X=Exportacao                                                             	
    If (cAliasQry)->A1_TIPO $ "F"
        cTipoCli := "Cons.Final"
    ELSEIF (cAliasQry)->A1_TIPO $ "L"
        cTipoCli := "Produtor Rural"
    ELSEIF (cAliasQry)->A1_TIPO $ "R"
        cTipoCli := "Revendedor"
    Else
        cTipoCli := "Exportação"
    EndIf

    If (cAliasQry)->A1_TIPO $ "R"
        cDivisa := "DEALER"
    ElseIf (cAliasQry)->A1_TIPO $ "X"
        cDivisa := "EXPORTACAO"
    Else
        cDivisa := "OTHERS"
    EndIf

    If SubStr((cAliasQry)->A1_NOME,1,2) $ "MC"
        cDivisa := "MC"
    EndIf

    cNomVend    := POSICIONE('SA3',1,XFILIAL('SA3') + (cAliasQry)->C5_VEND1 ,'A3_NOME')
    cXVende1    := POSICIONE('SA3',1,XFILIAL('SA3') + (cAliasQry)->C5_VEND1 ,'A3_XTPHOSH')

    If cXVende1 $ "1"
        cXVende := "Suporte Técnico"
    ElseIf cXVende1 $ "2"
        cXVende := "Redes"
    else
        cXVende := "Gastronomia"
    EndIf

//    U_BusTpVen(cTpVen) //Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN

    If Alltrim((cAliasQry)->C5_XTPVEN) == "1" 
		cXTpVen := "1 - Projeto"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "2"
		cXTpVen := "2 - Venda Unitaria"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "3"
		cXTpVen := "3 - Dealer"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "4"
		cXTpVen := "4 - E-Commerce"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "5"
		cXTpVen := "5 - Pronta Entrega"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "6"
		cXTpVen := "6 - Projeto-Dealer"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "7"
		cXTpVen		:= "7 - Venda de Peças"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "8"
		cXTpVen		:= "8 - Suporte Tecnico"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "9"
		cXTpVen		:= "9 - ARE"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "10"
		cXTpVen		:= "10 - Serviços"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "11"
		cXTpVen		:= "11 - Itens Faltantes"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == "12"
		cXTpVen		:= "12 - SAC"
	ElseIf Alltrim((cAliasQry)->C5_XTPVEN) == ""
		cXTpVen		:= ""			
	Endif   
    */
 //   cOBS  := Posicione('SFT',1,xFilial("SFT")+"S"+(cAliasQry)->D2_SERIE+(cAliasQry)->D2_DOC+(cAliasQry)->D2_CLIENTE+(cAliasQry)->D2_LOJA+(cAliasQry)->D2_ITEM,'FT_OBSERV')                                                                                  

	oReport:Section(1):PrintLine()

	(cAliasQry)->(dbSkip())
	oReport:IncMeter()	

End
	
dbSelectArea(cAliasQry)

oReport:SetLandScape()
oReport:Section(1):Finish()

Return
