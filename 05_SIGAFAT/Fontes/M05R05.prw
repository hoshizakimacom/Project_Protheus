#INCLUDE "MATR600.CH" 
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M05R05  ³ Autor ³ Cleber Maldonado       ³ Data ³ 03/04/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Orçamentos por Vendedor/Cliente                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M05R05()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Cleber Maldonado      ³ Data ³03/04/17  ³±±
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
Local oVendedor
Local oPedVC
Local oTotGer
Local cNome 	:= ""
Local cMun		:= ""
Local cUF		:= ""
Local cReg		:= ""
Local cStatus	:= ""

Local nTotPed1	:= 0
Local nTotGer	:= 0
Local dEmissao	:= CTOD("  /  /  ")
Private cRefObra	:= ""


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
oReport := TReport():New("M05R05","Orçamentos Por Vendedor/Cliente","M05R05", {|oReport| ReportPrint(oReport,oPedVC,oVendedor,oTotGer)},"Este relatório ira emitir a relação de Orçamentos por " + STR0017)	// "Pedidos Por Vendedor/Cliente"###
oReport:SetPortrait()   																																													// "Este relatorio ira emitir a relacao de Pedidos por"###"ordem de Vendedor/Cliente."
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
oVendedor := TRSection():New(oReport,"Orçamentos Por Vendedor/Cliente",{"TRB","SA3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Pedidos Por Vendedor/Cliente"
oVendedor:SetTotalInLine(.F.)
TRCell():New(oVendedor,"VENDEDOR"	,"TRB",STR0028,PesqPict("SA3","A3_COD")	,TamSx3("A3_COD"	)[1],/*lPixel*/,/*{|| code-block de impressao }*/	)	// Codigo do Vendedor
TRCell():New(oVendedor,"A3_NOME"	,	  ,RetTitle("A3_NOME")	,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME"	)[1],/*lPixel*/,{|| SA3->A3_NOME }	)	// Nome do Vendedor
TRCell():New(oVendedor,"GERENTE"	,"TRB",RetTitle("A3_GEREN"),PesqPict("SA3","A3_GEREN")	,TamSx3("A3_GEREN"	)[1],/*lPixel*/,{|| SA3->A3_GEREN } )	// Codigo do Gerente
TRCell():New(oVendedor,"A3_NOMEG"	,	  ,RetTitle("A3_NOME")	,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME"	)[1],/*lPixel*/,{|| Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_NOME") },,.T.,	)	// Nome do gerente

oPedVC := TRSection():New(oVendedor,"Orçamentos Por Vendedor/Cliente",{"TRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Pedidos Por Vendedor/Cliente"
oPedVC:SetTotalInLine(.F.)
TRCell():New(oPedVC,"CLIENTE"	,"TRB"  ,"Cliente"				,PesqPict("SA1","A1_COD")	,TamSx3("A1_COD"	 )[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)	// Codigo do Cliente
TRCell():New(oPedVC,"CNOME"		,		,RetTitle("A1_NOME")	,PesqPict("SA1","A1_NOME")	,TamSx3("A1_NOME"	 )[1]	,/*lPixel*/,{|| cNome 		}					)	// Razao Social do Cliente
TRCell():New(oPedVC,"CMUN"		,		,RetTitle("A1_MUN")		,PesqPict("SA1","A1_MUN")	,TamSx3("A1_MUN"	 )[1]-35,/*lPixel*/,{|| cMun  		}					)	// Municipio do Cliente
TRCell():New(oPedVC,"UF"		,		,RetTitle("A1_EST")		,PesqPict("SA1","A1_EST")	,TamSx3("A1_EST"	 )[1]	,/*lPixel*/,{|| cUF			}              		)	// UF do Cliente
TRCell():New(oPedVC,"REGIAO"	,		,"Regiao"				,PesqPict("SX5","X5_DESCRI"),TamSx3("X5_DESCRI"	 )[1]-40,/*lPixel*/,{|| cReg  		}					)	// Região do Cliente
TRCell():New(oPedVC,"NUMORC"	,"TRB"  ,RetTitle("CJ_NUM")		,PesqPict("SCJ","CJ_NUM")	,TamSx3("CJ_NUM"	 )[1]	,/*lPixel*/,/*{|| code-block de impressao }*/   )	// Numero do Orçamento
TRCell():New(oPedVC,"EMISSAO"	,		,RetTitle("CJ_EMISSAO")	,PesqPict("SCJ","CJ_EMISSAO"),TamSx3("CJ_EMISSAO")[1]	,/*lPixel*/,{|| dEmissao	}					)	// Emissão do orçamento
TRCell():New(oPedVC,"NTOTPED1"	,		,STR0019				,TM(nTotPed1,18,2)			 ,TamSx3("CK_VALOR"	 )[1]	,/*lPixel*/,{|| nTotPed1 	},,,"RIGHT"			)	// "Total"
TRCell():New(oPedVC,"STATUSC"	,		,"Status"				,PesqPict("SCJ","CJ_STATUS") ,14                     	,/*lPixel*/,{|| cStatus  	},,,				)   //Status do Orçamento
TRCell():New(oPedVC,"USUARIO"	,		,"Usuario Inclusao"		,PesqPict("SCJ","CJ_XINCLUI"),TamSx3("CJ_XINCLUI")[1]  	,/*lPixel*/,{|| cUsrInc 	},,,				)   //Status do Orçamento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta Secao serve apenas para receber as Querys que irao gerar o arquivo³
//³ temporario para impressao 							                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTemp := TRSection():New(oReport,"Orçamentos Por Vendedor/Cliente",{"SCJ","SA1"},,/*Campos do SX3*/,/*Campos do SIX*/)		// "Pedidos Por Vendedor/Cliente"
oTemp:SetTotalInLine(.F.)

oTemp1 := TRSection():New(oReport,"Orçamentos Por Vendedor/Cliente",{"SCK"},,/*Campos do SX3*/,/*Campos do SIX*/)		// "Pedidos Por Vendedor/Cliente"
oTemp1:SetTotalInLine(.F.)

// Secao Total Geral
oTotGer := TRSection():New(oReport,"",,/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Pedidos Por Vendedor/Cliente"
oTotGer:SetTotalInLine(.F.)
                            
TRCell():New(oTotGer,""	,,STR0030	,PesqPict("SA1","A1_COD")	,TamSx3("A1_COD"		)[1],/*lPixel*/,/*{|| code-block de impressao }*/	)	// Codigo do Cliente
TRCell():New(oTotGer,""	,," ",PesqPict("SA1","A1_NOME")	,TamSx3("A1_NOME"		)[1],/*lPixel*/,/*{|| code-block de impressao }*/								)	// Razao Social do Cliente
TRCell():New(oTotGer,""	,," ",PesqPict("SA1","A1_MUN")	,TamSx3("A1_MUN"		)[1],/*lPixel*/,/*{|| code-block de impressao }*/									)	// Municipio do Cliente
TRCell():New(oTotGer,""	,," ",PesqPict("SCJ","CJ_NUM")	,TamSx3("CJ_NUM"		)[1],/*lPixel*/,/*{|| code-block de impressao }*/	)	// Numero do Pedido de Venda
TRCell():New(oTotGer,"NTOTGER"	,," ",TM(nTotGer,18,2) ,TamSx3("CK_VALOR"		)[1],/*lPixel*/,{|| nTotGer },,,"RIGHT")	// "Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no topo da pagina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Section(1):SetHeaderPage()
oReport:Section(1):SetTotalText(STR0022) 

oReport:Section(2):SetEditCell(.F.)
oReport:Section(3):SetEditCell(.F.)

oReport:Section(1):Section(1):SetEdit(.F.)
oReport:Section(4):SetEdit(.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Cleber Maldonado      ³ Data ³03/04/2017³±±
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
Static Function ReportPrint(oReport,oPedVC,oVendedor,oTotGer)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao das Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCli,cVend,nTotPed1,cLoja
Local aCampos 	:= {}
Local aTam		:= {}
Local cExt		:= ""
Local cVendCh	:= ""
Local j, Suf
Local nTotSCK 	:= 0 
Local cEstoq 	:= "SN" // If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ) )
Local cDupli 	:= "SN" // If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ) )

Local cFilSA3 := ""
#IFNDEF TOP
	Local cFilSA1 := ""
	Local cFilSCJ := ""
	Local cFilSCK := ""
#ENDIF	
Local aPedido	:= {}
Local nCont		:= 0
Local nPos		:= 0
Local nTotGer   := 0
                                                                  
TRPosition():New(oReport:Section(1),"SA3",1,{|| xFilial("SA3")+TRB->VENDEDOR })
TRPosition():New(oReport:Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+TRB->CLIENTE+TRB->LOJA })

If mv_par09 ==  1
	TRFunction():New(oPedVC:Cell("NTOTPED1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,TM(nTotPed1,18,2),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	oReport:Section(1):Section(1):SetTotalText(STR0021)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser         ³
//³ utilizadas em outras funcoes nao precisando declara-las      ³
//³ como private											  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Section(1):Cell("CNOME" 		):SetBlock({|| cNome	})
oReport:Section(1):Section(1):Cell("CMUN" 		):SetBlock({|| cMun		})
oReport:Section(1):Section(1):Cell("UF"			):SetBlock({|| cUF		})
oReport:Section(1):Section(1):Cell("REGIAO"		):SetBlock({|| cReg		})
oReport:Section(1):Section(1):Cell("NTOTPED1" 	):SetBlock({|| nTotPed1	})
oReport:Section(1):Section(1):Cell("EMISSAO"	):SetBlock({|| dEmissao	})
oReport:Section(1):Section(1):Cell("STATUSC"	):SetBlock({|| cStatus  })
//oReport:Section(1):Section(1):Cell("XOBRAS"		):SetBlock({|| cRefObra })
oReport:Section(4):Cell("NTOTGER" 	):SetBlock({|| nTotGer	})
cNome 	:= ""
cMun	:= ""
cUF		:= ""
cReg	:= ""
cStatus := ""
cRefObra:= ""
nTotPed1:= 0
dEmissao:= CTOD("  /  /  ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("CJ_XVEND1")
AADD(aCampos,{ "VENDEDOR","C",aTam[1],aTam[2] } )
aTam:=TamSX3("CK_NUM")
AADD(aCampos,{ "NUMORC"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("CJ_CLIENTE")
AADD(aCampos,{ "CLIENTE" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("CJ_EMISSAO")
AADD(aCampos,{ "EMISSAO" ,"D",10,aTam[2] } )
aTam:=TamSX3("CJ_LOJA")
AADD(aCampos,{ "LOJA"    ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "MOEDA"   ,"N",1,0 } )
aTam:=TamSX3("F1_VALBRUT")
AADD(aCampos,{ "TOTPED"    ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "CLINOME"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_MUN")
AADD(aCampos,{ "CLIMUN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_EST")
AADD(aCampos,{ "CLIUF"	,"C",aTam[1],aTam[2]  }  )
aTam:=TamSX3("X5_DESCRI")
AADD(aCampos,{ "CLIREG","C",aTam[1],aTam[2]   }  )
aTam:=TamSX3("CJ_STATUS")
AADD(aCampos,{ "STATUSC","C",14,aTam[2]	}  )
aTam:=TamSX3("CJ_XINCLUI")
AADD(aCampos,{ "XINCLUI","C",aTam[1],aTam[2]	}  )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pula pagina na quebra por vendedor                           ³
//³ PARÂMETRO DESCONSIDERADO - MV_PAR07 - SALTA PAGINA           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// If mv_par07 == 1
//	oReport:Section(1):SetPageBreak(.T.)
// EndIf	
TRFunction():New(oPedVC:Cell("NTOTPED1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,TM(nTotPed1,18,2),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oVendedor)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
Use &cNomArq	Alias TRB   NEW
IndRegua("TRB",cNomArq,"VENDEDOR+CLIENTE+NUMORC",,,STR0018)		// "Selecionando Registros..."
          
If len(oReport:Section(1):GetAdvplExp("SA3")) > 0
	cFilSA3 := oReport:Section(1):GetAdvplExp("SA3")
EndIf


#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		GTrabTopR4(oReport)
	Else
#ENDIF

	If len(oReport:Section(2):GetAdvplExp("SA1")) > 0
		cFilSA1 := oReport:Section(2):GetAdvplExp("SA1")
	EndIf
	If len(oReport:Section(2):GetAdvplExp("SCJ")) > 0
		cFilSCJ := oReport:Section(2):GetAdvplExp("SCJ")
	EndIf
	If len(oReport:Section(3):GetAdvplExp("SCK")) > 0
		cFilSCK := oReport:Section(3):GetAdvplExp("SCK")
	EndIf

	dbSelectArea("SCJ")		// Cabecalho do Pedido de Vendas
	dbSetOrder(2)			// Filial,Emissao,Numero do Pedido
	dbSeek(xFilial()+DTOS(mv_par01),.T.)
	
	oReport:SetMeter(RecCount())		// Total de Elementos da regua
	While !Eof() .And. CJ_EMISSAO >= mv_par01 .And. CJ_EMISSAO <= mv_par02 .and. CJ_FILIAL == xFilial()

      // Verifica filtro do usuario
		If !Empty(cFilSCJ) .And. !(&cFilSCJ)
			dbSelectArea("SCJ")
			dbSkip()
			Loop
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta no mesmo pedido para pegar somente os itens ³
		//³ que esteja de acordo com a pergunta de considera residuo e se³
		//³ o conteudo do campo C6_BLQ = "R ".                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCK")		// Itens do Pedido de Vendas
		dbSetOrder(1)			// Filial,Pedido,Item,Produto
		dbSeek(xFilial()+SCJ->CJ_NUM)
	
		While !Eof() .And. CK_FILIAL == xFilial("SCK") .And. CK_NUM == SCJ->CJ_NUM

			SF4->( dbSetOrder( 1 ) )		// Cadastro de Tes: Filial,Codigo Tes 
			SF4->( MsSeek( xFilial( "SF4" ) + SCK->CK_TES ) ) 
			If !AvalTes(SCK->CK_TES,cEstoq,cDupli)
				dbSkip()
				Loop
			Endif
		
			// Nao considera pedidos do tipo "D" ou "B"
			//If AT(SCJ->C5_TIPO,"DB") != 0
			//	dbSelectArea("SC6")
			//	dbSkip()
			//	Loop
			//EndIf           
			
	      // Verifica filtro do usuario
			If !Empty(cFilSCK) .And. !(&cFilSCK)
				dbSelectArea("SCK")
				dbSkip()
				Loop
			EndIf
			
			oReport:IncMeter()		// Icrementa regua
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se Vendedor devera ser impresso                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For j:=1 TO 5
				suf := "CJ_XVEND"+Str(j,1)
				dbSelectArea("SCJ")
				IF Empty(&suf)
					Exit
				EndIF
				cVendCh := &suf
				dbSelectArea("SA3")
				If (dbSeek(cFilial+cVendCH))
					dbSelectArea("SCJ")
					IF &suf >= mv_par03 .And. &suf <= mv_par04
						If TRB->(!dbSeek(cVendCh+SCJ->CJ_CLIENTE+SCJ->CJ_NUM))
							GravTrabR4(j)
						EndIf
					EndIF
				Endif
			Next j
		
			dbSelectArea("SCK")
			dbSkip()
		
		EndDo
		dbSelectArea("SCJ")
		dbSkip()
	EndDO
#IFDEF TOP
	EndIf	
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()
oReport:Section(1):Init()
oReport:SetMeter(RecCount())		// Total de Elementos da regua
While !Eof() 

	// Verifica filtro do usuario
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1))
	SA3->(dbSeek( xFilial("SA3") + TRB->VENDEDOR ))
	dbSelectArea("SA3")
	If !Empty(cFilSA3) .And. !(&cFilSA3)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf

	#IFNDEF TOP
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek( xFilial("SA1") + TRB->CLIENTE+TRB->LOJA ))
		If !Empty(cFilSA1) .And. !(&cFilSA1)
			dbSelectArea("TRB")
			dbSkip()
			Loop
		EndIf
	#ENDIF		
	
	dbSelectArea("TRB")
	cVend := TRB->VENDEDOR
	oReport:Section(1):PrintLine()
	
	dbSelectArea("TRB")   
	While !Eof() .And.  TRB->VENDEDOR == cVend
		
		#IFDEF TOP
			If ( TcSrvType()<>"AS/400" )
			Else
		#ENDIF
			IF TRB->CLIENTE < mv_par05 .Or. TRB->CLIENTE > mv_par06 .Or. TRB->LOJA < mv_par07 .Or. TRB->LOJA > mv_par08
				dbSkip()
				Loop
			EndIF
		#IFDEF TOP
			EndIf
		#ENDIF		
		
		cCli 		:= TRB->CLIENTE
		cLoja		:= TRB->LOJA   
		oReport:Section(1):Section(1):Init()
		While !Eof() .And. TRB->VENDEDOR == cVend .And. TRB->CLIENTE == cCli .And. TRB->LOJA == cLoja
			
			oReport:IncMeter()
			#IFDEF TOP
				If ( TcSrvType()<>"AS/400" )
					nTotPed1:=xMoeda( TRB->TOTPED, TRB->MOEDA, 1, TRB->EMISSAO )
				Else
			#ENDIF
				dbSelectArea("SCK")
				dbSeek( xFilial()+TRB->NUMORC )
				nTotPed1 := 0
			
				While !Eof() .And. TRB->NUMORC == SCK->CK_NUM
			 		SF4->( dbSetOrder( 1 ) ) 
				 	SF4->( MsSeek( xFilial( "SF4" ) + SCK->CK_TES ) ) 
			 	
					If AvalTes(SCK->CK_TES,cEstoq,cDupli)
						If cPaisLoc=="BRA"
						 	nTotSCK := If( SF4->F4_AGREG == "N" .And. MV_PAR12 == 1, 0, CK_VALOR )
							nTotPed1 += xMoeda( nTotSCK,TRB->MOEDA,1,TRB->EMISSAO)
						Else
							nTotPed1 += xMoeda( CK_VALOR ,TRB->MOEDA,1,TRB->EMISSAO)
						Endif
					Endif
					dbSkip()
				Enddo			
			#IFDEF TOP
				EndIf
			#ENDIF            

         	DbSelectArea("TRB")
			#IFDEF TOP
				If ( TcSrvType()<>"AS/400" )
					cNome   := TRB->CLINOME
					cMun    := TRB->CLIMUN
					cUF	    := TRB->CLIUF
					cReg    := TRB->CLIREG
					cStatus := TRB->STATUSC
					dEmissao:= TRB->EMISSAO
					cUsrInc := TRB->XINCLUI					
				Else
			#ENDIF
				SA1->(dbSetOrder(1))
				SA1->(dbSeek( xFilial("SA1") + TRB->CLIENTE+TRB->LOJA ))
				cNome 		:= SA1->A1_NOME
				cMun  		:= SA1->A1_MUN
				cUF	  		:= SA1->A1_EST
				dEmissao	:= SCJ->CJ_EMISSAO
				cReg  		:= POSICIONE("SX5",1,xFilial("SX5")+"A2"+A1_REGIAO,X5_DESCRI)
			#IFDEF TOP
				EndIf
			#ENDIF  
			
			oReport:Section(1):Section(1):PrintLine()			
			
//			If mv_par10 == 2
//				nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == cCli+cLoja+TRB->NUMORC})
//				If nPos == 0
//					AADD(aPedido,{cCli,cLoja,TRB->NUMORC})
//					nTotGer += nTotPed1
//				EndIf	
//			Else	
				nTotGer += nTotPed1			
//			EndIf		
			

			dbSkip()
			
		EndDo

		// Total por Cliente
		IF (mv_par09 == 1 .And. TRB->CLIENTE+TRB->LOJA <> cCli+cLoja) .Or. (mv_par09 == 1 .And. TRB->VENDEDOR <> cVend)
			oReport:Section(1):Section(1):SetTotalText(STR0021 + cCli+cLoja)
			oReport:Section(1):Section(1):Finish()
			oReport:Section(1):Section(1):Init()
		EndIF

		dbSelectArea("TRB")
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime totalizador                									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):SetTotalText(STR0022 + cVend)
	oReport:section(1):Finish()
	oReport:section(1):Init()
	
	dbSelectArea("TRB")
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Total geral                									   ³
//³ PARÂMETRO DESCONSIDERADO - MV_PAR07 - SALTA PAGINA					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If mv_par07 == 2
	oReport:section(4):Init()
	oReport:section(4):Printline()
	oReport:section(4):Finish()
//EndIf	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Areas                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
cExt := OrdBagExt()
dbCloseArea()
If File(cNomArq+GetDBExtension())
	FERASE(cNomArq+GetDBExtension())		//arquivo de trabalho
Endif

If File(cNomArq + cExt)
	FERASE(cNomArq+cExt)					//indice gerado
Endif

dbSelectArea("SCJ")
dbSetOrder(1)

dbSelectArea("SA3")
dbClearFilter()
dbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravTrabR4³ Autor ³ Cleber Maldonado      ³ Data ³03/04/2017 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Arquivo de Trabalho                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nEl - Ordem do Vendedor                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M05R05                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion GravTrabR4(nEl)

Local suf := "SCJ->CJ_XVEND" + Str(nEl,1)

RecLock("TRB",.t.)
Replace VENDEDOR With &suf
Replace NUMORC   With SCJ->CJ_NUM
Replace CLIENTE  With SCJ->CJ_CLIENTE
Replace EMISSAO  With SCJ->CJ_EMISSAO
Replace LOJA     With SCJ->CJ_LOJA
Replace MOEDA    With SCJ->CJ_MOEDA
Replace STATUSC  With SCJ->CJ_STATUS
Replace XINCLUI	 With SCJ->CJ_XINCLUI
MsUnlock()
dbSelectArea("SCJ")

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GTrabTopR4³ Autor ³  Cleber Maldonado     ³ Data ³03/04/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Arquivo de Trabalho                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nEl - Ordem do Vendedor                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M05R05                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GTrabTopR4(oReport)

Local aArea		:= GetArea()
Local nJ      	:= 0
Local cSCJTmp 	:= GetNextAlias()
Local cSCJTmp2	:= GetNextAlias()
Local cCampos  	:= ""
Local cQuery2 	:= ""
Local cVendCh 	:= ""
Local cSuf    	:= ""
Local nVend	  	:= Fa440CntVen()
Local cVend   	:= ""
Local cWhere   	:= ""
Local cPedTemp 	:= ""
Local cStatTmp	:= ""
Local aVend   	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

cSuf:="0"
cWhere := "%("
For nJ:=1 to nVend
	cSuf := Soma1(cSuf)
	cVend := "CJ_XVEND"+cSuf
	If SCJ->(FieldPos(cVend))>0
		Aadd(aVend,cVend)
		cCampos+=cVend+","
		If Len(cWhere) > 2
			cWhere+="or "
		Endif
		cWhere+="("+cVend+"<>'' and "+cVend+">='"+mv_par03+"' and "+cVend+"<='"+mv_par04+"') "
	Endif
Next
cWhere += ")%"

cCampos := "%,"
For nJ := 1 To SCJ->(FCount())
	If nJ > 1 .And. ! SCJ->(FieldName(nJ)) $ 'CJ_HIST|CJ_XHIST|CJ_XINFOR'
		cCampos += ", "
	EndIf	
	If 	! SCJ->(FieldName(nJ)) $ 'CJ_HIST|CJ_XHIST|CJ_XINFOR'
		cCampos += SCJ->(FieldName(nJ))
	Endif
Next
cCampos += "%"

If TcSrvType() != "AS/400"

	oReport:Section(2):BeginQuery()	
	BeginSql Alias cSCJTmp
	
	COLUMN CJ_EMISSAO as Date

	SELECT A1_NOME,A1_MUN,A1_EST,A1_REGIAO,A1_DSCREG,CJ_STATUS,CJ_EMISSAO,CJ_XINCLUI %Exp:cCampos%
	FROM %Table:SCJ% SCJ, %Table:SA1% SA1
	WHERE SCJ.CJ_FILIAL = %xFilial:SCJ%
		AND SCJ.%notdel%
		AND SCJ.CJ_CLIENTE >= %Exp:MV_PAR05%  AND SCJ.CJ_CLIENTE <= %Exp:MV_PAR06%
		AND SCJ.CJ_LOJA >= %Exp:MV_PAR07% AND SCJ.CJ_LOJA <= %Exp:MV_PAR08%
		AND SCJ.CJ_EMISSAO >= %Exp:Dtos(MV_PAR01)% AND SCJ.CJ_EMISSAO <= %Exp:Dtos(MV_PAR02)%
		AND %Exp:cWhere%
		AND SA1.A1_FILIAL = %xFilial:SA1%
		AND SA1.A1_COD = SCJ.CJ_CLIENTE
		AND SA1.A1_LOJA = SCJ.CJ_LOJA
		AND SA1.%notdel%
		AND
		(SELECT SUM(CK_VALOR) 
		FROM %Table:SCK% SCK, %Table:SF4% SF4, %Table:SC5% SC5,
		WHERE SCK.CK_FILIAL = %xFilial:SCK%
			AND SCK.CK_NUM = SCJ.CJ_NUM
			AND SF4.F4_FILIAL = %xFilial:SF4%
			AND SF4.F4_CODIGO = SCK.CK_TES
			AND SCK.%notdel%
			AND SF4.%notdel%) > 0
	EndSql 
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)	

Else
    
	oReport:Section(2):BeginQuery()	
	BeginSql Alias cSCJTmp

	SELECT A1_NOME,A1_MUN %Exp:cCampos%
	FROM %Table:SCJ% SCJ, %Table:SA1% SA1
	WHERE SCJ.CJ_FILIAL = %xFilial:SCJ%
		AND SCJ.%notdel%
		AND SCJ.CJ_CLIENTE >= %Exp:MV_PAR05%  AND SCJ.CJ_CLIENTE <= %Exp:MV_PAR06%
		AND SCJ.CJ_LOJA >= %Exp:MV_PAR07% AND SCJ.CJ_LOJA <= %Exp:MV_PAR08%
		AND SCJ.CJ_EMISSAO >= %Exp:Dtos(MV_PAR01)% AND SCJ.CJ_EMISSAO <= %Exp:Dtos(MV_PAR02)%
		AND %Exp:cWhere%
		AND SA1.A1_FILIAL = %xFilial:SA1%
		AND SA1.A1_COD = SCJ.CJ_CLIENTE
		AND SA1.A1_LOJA = SCJ.CJ_LOJA
		AND SA1.%notdel%
		AND
		0 < (SELECT SUM(CK_VALOR)
			FROM %Table:SCK% SCK, %Table:SF4% SF4, %Table:SC5% SC5
			WHERE SCK.CK_FILIAL = %xFilial:SCK%
				AND SCK.CK_NUM = SCJ.CJ_NUM
				AND SF4.F4_FILIAL = %xFilial:SF4%
				AND SF4.F4_CODIGO = SCK.CK_TES
				AND SCK.%notdel%
				AND SF4.%notdel%)
	EndSql 
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
EndIf

oReport:SetMeter(SCK->(LastRec()))
DbSelectArea(cSCJTmp)
While (cSCJTmp)->(!Eof())
	
	cPedTemp := (cSCJTmp)->CJ_NUM
	oReport:Section(3):BeginQuery()	
	BeginSql Alias cSCJTmp2
	SELECT SUM(CK_VALOR) nTotPed
	FROM %Table:SCK% SCK, %Table:SF4% SF4
	WHERE SCK.CK_FILIAL = %xFilial:SCK%
		AND SCK.CK_NUM = %Exp:cPedTemp%
		AND SF4.F4_FILIAL = %xFilial:SF4%
		AND SF4.F4_CODIGO = SCK.CK_TES
		AND SCK.%notdel%
		AND SF4.%notdel%
	EndSql 
	oReport:Section(3):EndQuery(/*Array com os parametros do tipo Range*/)	
	
	If (cSCJTmp2)->nTotPed > 0
		For nJ:=1 to Len(aVend) //nVend
			cVend := aVend[nJ]
			cVendCh := (cSCJTmp)->&cVend
			
			If (cSCJTmp)->CJ_STATUS == "A"
				cStatTmp := "ABERTO"
			ElseIf (cSCJTmp)->CJ_STATUS == "B"
				cStatTmp := "BAIXADO"
			ElseIf (cSCJTmp)->CJ_STATUS == "C"
				cStatTmp := "CANCELADO"
			ElseIf (cSCJTmp)->CJ_STATUS == "D"
				cStatTmp := "NAO ORCADO"
			ElseIf (cSCJTmp)->CJ_STATUS == "1"
				cStatTmp := "DESBLOQ."
			ElseIf (cSCJTmp)->CJ_STATUS == "2" 
				cStatTmp := "BLOQUEADO"
			Endif

			If !Empty(cVendCH) .And. cVendCh >= mv_par03 .And. cVendCh <= mv_par04
				RecLock("TRB",.t.)
				Replace TRB->VENDEDOR With cVendCH
				Replace TRB->NUMORC   With (cSCJTmp)->CJ_NUM
				Replace TRB->CLIENTE  With (cSCJTmp)->CJ_CLIENTE
				Replace TRB->EMISSAO  With (cSCJTmp)->CJ_EMISSAO
				Replace TRB->LOJA     With (cSCJTmp)->CJ_LOJA
				Replace TRB->MOEDA    With (cSCJTmp)->CJ_MOEDA
				Replace TRB->TOTPED   With (cSCJTmp2)->nTotPed
				Replace TRB->CLINOME  With (cSCJTmp)->A1_NOME
				Replace TRB->CLIMUN   With (cSCJTmp)->A1_MUN
				Replace TRB->CLIUF	  With (cSCJTmp)->A1_EST
				Replace TRB->CLIREG	  With (cSCJTmp)->A1_DSCREG
				Replace TRB->STATUSC  With cStatTmp
				Replace TRB->XINCLUI  With (cSCJTmp)->CJ_XINCLUI
				TRB->(MsUnlock())
			Endif
		Next
	EndIf
	DbSelectArea(cSCJTmp2)
	dbCloseArea()
	DbSelectArea(cSCJTmp)
	oReport:IncMeter()
	(cSCJTmp)->(DbSkip())
Enddo

DbSelectArea(cSCJTmp)
DbCloseArea()

RestArea(aArea)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M05R05   ³ Autor ³ Cleber Maldonado      ³ Data ³ 03.04.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos de Vendas por Vendedor/Cliente          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M05R05R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL titulo := OemToAnsi(STR0001)	//"Pedidos Por Vendedor/Cliente"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este relatorio ira emitir a relacao de Pedidos por"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"ordem de Vendedor/Cliente."
LOCAL cDesc3 := ""
Private CbTxt
Private CbCont,cabec1,cabec2,wnrel
Private tamanho:="P"
Private limite := 80
Private cString:="SCJ"
Private lContinua := .T.
Private nTotCli1,nTotVend1,nTotGer1,nContCli
Private cCli,cVend,nTotPed1,cLoja
Private aCampos := {},cVencCh
Private aTam    := {}

PRIVATE aReturn := { STR0004, 1,STR0005, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="M05R05"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="M05R05"

pergunte("M05R05",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// A partir da data                      ³
//³ mv_par02        	// Ate a data                            ³
//³ mv_par03        	// Vendedor de                           ³
//³ mv_par04 	     	// Vendedor ate                          ³
//³ mv_par05	     	// Cliente de                            ³
//³ mv_par06        	// Cliente ate                           ³
//³ mv_par07	     	// Loja Cliente de                       ³
//³ mv_par08        	// Loja Cliente ate                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="M05R05"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If  nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C600Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C600IMP  ³ Autor ³ Cleber Maldonado      ³ Data ³ 03.04.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M05R05			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C600Imp(lEnd,WnRel,cString)
LOCAL CbTxt
LOCAL titulo := OemToAnsi(STR0001)		//"Pedidos Por Vendedor/Cliente"
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:="P"
LOCAL lContinua := .T.
LOCAL nTotCli1,nTotVend1,nTotGer1,nContCli
LOCAL cCli,cVend,nTotPed1,cLoja
LOCAL aCampos := {}
LOCAL aTam:={}, aTamSXG, aCoord, aTam2
Local cExt
LOCAL cVendCh
LOCAL j, Suf
LOCAL nTotSCK := 0 
LOCAL cEstoq := "S" // If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ) )
LOCAL cDupli := "S" // If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ) )
LOCAL nTotGerAux := 0
LOCAL aPedido := {}
LOCAL nPos    := 0	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("CJ_XVEND1")
AADD(aCampos,{ "VENDEDOR","C",aTam[1],aTam[2] } )
aTam:=TamSX3("CK_NUM")
AADD(aCampos,{ "NUMORC"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("CJ_CLIENTE")
AADD(aCampos,{ "CLIENTE" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("CJ_EMISSAO")
AADD(aCampos,{ "EMISSAO" ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("CJ_LOJA")
AADD(aCampos,{ "LOJA"    ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "MOEDA"   ,"N",1,0 } )
aTam:=TamSX3("F1_VALBRUT")
AADD(aCampos,{ "TOTPED"    ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "CLINOME"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_MUN")
AADD(aCampos,{ "CLIMUN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_EST")
AADD(aCampos,{ "CLIUF"	,"C", aTam[1],aTam[2]  }  )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTamSXG := TamSXG("001")

titulo := "ORÇAMENTOS POR VENDEDOR/CLIENTE" + " em "+GetMv("MV_MOEDA"+Str(1,1))   //"PED. DE VENDAS POR VENDEDOR/CLIENTE"
If aTamSXG[1] == aTamSXG[3]
	cabec1 := STR0007		//"CODIGO RAZAO SOCIAL             PRACA                  PEDIDO            TOTAL"
								// 999999 XXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXX   999999 9999999999999999
	aCoord := {07, 32, 55, 62}
	aTam2  := {22, 20}
Else
	cabec1 := STR0014		//"CODIGO               RAZAO SOCIAL         PRACA           PEDIDO           TOTAL"
								// 999999xxxxxxxxxxxxxx XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 9999999999999999999999
								//           1         2         3         4         5         6         7
								// 01234567890123456789012345678901234567890123456789012345678901234567890123456789
	aCoord := {21, 42, 58, 64}
	aTam2  := {20, 15}
EndIf
cabec2 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
Use &cNomArq	Alias TRB   NEW
IndRegua("TRB",cNomArq,"VENDEDOR+CLIENTE+NUMORC",,,STR0008)		//"Selecionando Registros..."

#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		GerTrabTop()
	Else
#ENDIF
	dbSelectArea("SCJ")
	dbSetOrder(2)
	dbSeek(xFilial()+DTOS(mv_par01),.T.)
	
	SetRegua(RecCount())		// Total de Elementos da regua

	While !Eof() .And. lContinua .And. CJ_EMISSAO >= mv_par01 .And. CJ_EMISSAO <= mv_par02 .and. CJ_FILIAL == xFilial()

		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSkip()
			Loop
		EndIf	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta no mesmo pedido para pegar somente os itens ³
		//³ que esteja de acordo com a pergunta de considera residuo e se³
		//³ o conteudo do campo C6_BLQ = "R ".                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("SCK")
		dbSetOrder(1)
		dbSeek(xFilial()+SCJ->CJ_NUM)
	
		While !Eof() .And. lContinua .And. CK_NUM == SCJ->CJ_NUM
		
			SF4->( dbSetOrder( 1 ) ) 
			SF4->( MsSeek( xFilial( "SF4" ) + SCK->CK_TES ) ) 
			If !AvalTes(SCK->CK_TES,cEstoq,cDupli)
				dbSkip()
				Loop
			Endif
		
			dbSelectArea("SCJ")
			dbSetOrder(2)
		
			IncRegua()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se Vendedor devera ser impresso                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FOR j:=1 TO 5
				suf := "CJ_XVEND"+Str(j,1)
				dbSelectArea("SCJ")
				IF Empty(&suf)
					Exit
				EndIF
				cVendCh := &suf
				dbSelectArea("SA3")
				If (dbSeek(cFilial+cVendCH))
					dbSelectArea("SCJ")
					IF &suf >= mv_par03 .And. &suf <= mv_par04
						If TRB->(!dbSeek(cVendCh+SCJ->CJ_CLIENTE+SCJ->CJ_NUM))
							GravaTrab(j)
						EndIf
					EndIF
				Endif
			NEXT j
		
			dbSelectArea("SCK")
			dbSkip()
		
		EndDo
		dbSelectArea("SCJ")
		dbSkip()
	EndDO
#IFDEF TOP
	EndIf	
#ENDIF

dbSelectArea("TRB")
dbGoTop()
nTotGer1 := 0
nTotGerAux := 0

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0009		//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	cVend := VENDEDOR
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek( xFilial() + cVend )
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_NORM"))
	EndIF
	@li,  0 Psay STR0010+ cVend + "  " + SA3->A3_NOME		//"VENDEDOR : "
	li++
	dbSelectArea("TRB")
	nTotVend1 := 0
	
	While !Eof() .And. lContinua .And. VENDEDOR == cVend
		
		IF lEnd
			@PROW()+1,001 Psay STR0009		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		#IFDEF TOP
			If ( TcSrvType()<>"AS/400" )
			Else
		#ENDIF
			IF CLIENTE < mv_par05 .Or. CLIENTE > mv_par06 .Or. LOJA < mv_par07 .Or. LOJA > mv_par08
				dbSkip()
				Loop
			EndIF
		#IFDEF TOP
			EndIf
		#ENDIF		
		nTotCli1 := 0
		cCli := CLIENTE
		cLoja:= LOJA
		nContCli := 0
		While !Eof() .And. lContinua .And. VENDEDOR == cVend .And. CLIENTE == cCli .And. LOJA == cLoja
			
			IF lEnd
				@PROW()+1,001 Psay STR0009		//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				EXIT
			ENDIF
			
			IncRegua()
			
			IF li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_NORM"))				   				
			EndIF
			
			#IFDEF TOP
				If ( TcSrvType()<>"AS/400" )
					nTotPed1:=xMoeda( TRB->TOTPED, TRB->MOEDA, 1, TRB->EMISSAO )
				Else
			#ENDIF
				dbSelectArea("SCK")
				dbSeek( xFilial()+TRB->NUMORC )
				nTotPed1 := 0
			
				While !Eof() .And. TRB->NUMORC == SCK->CK_NUM
			 		SF4->( dbSetOrder( 1 ) ) 
				 	SF4->( MsSeek( xFilial( "SF4" ) + SCK->CK_TES ) ) 
				 	
					If AvalTes(SCK->CK_TES,cEstoq,cDupli)
						If cPaisLoc=="BRA"
						 	nTotSCK := If( SF4->F4_AGREG == "N", 0, CK_VALOR )
							nTotPed1 += xMoeda( nTotSCK,TRB->MOEDA,1,TRB->EMISSAO)
						Else
							nTotPed1 += xMoeda( CK_VALOR ,TRB->MOEDA,1,TRB->EMISSAO)
						Endif
					Endif
					dbSkip()
				Enddo			
			#IFDEF TOP
				EndIf
			#ENDIF            

         	DbSelectArea("TRB")
			@li, 0 Psay TRB->CLIENTE + " "
			#IFDEF TOP
				If ( TcSrvType()<>"AS/400" )
					@li, aCoord[1] Psay SubStr(CLINOME, 1, aTam2[1])
					@li, aCoord[2] Psay SubStr(CLIMUN,  1, aTam2[2])
				Else
			#ENDIF
				SA1->(dbSetOrder(1))
				SA1->(dbSeek( xFilial("SA1") + TRB->CLIENTE+TRB->LOJA ))
				@li, aCoord[1] Psay SubStr(SA1->A1_NOME, 1, aTam2[1])
				@li, aCoord[2] Psay SubStr(SA1->A1_MUN,  1, aTam2[2])
			#IFDEF TOP
				EndIf
			#ENDIF
			@li, aCoord[3] Psay NUMORC
			@li, aCoord[4] Psay nTotPed1	Picture tm(nTotPed1,16)
			li++
			nTotCli1 += nTotPed1
			nContCli++			

			If mv_par10 == 2
				nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == cCli+cLoja+TRB->NUMORC})
				If nPos == 0
					AADD(aPedido,{cCli,cLoja,TRB->NUMORC})
					nTotGerAux += nTotPed1
				EndIf	
			EndIf		
			
			dbSkip()
			
		EndDO
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_NORM"))
		EndIF

		//-- Total por Cliente
		IF mv_par09 == 1 .And. CLIENTE+LOJA <> cCli+cLoja
			@li, 0         Psay STR0011+ cCli + cLoja		//"TOTAL CLIENTE   ---> "
			@li, aCoord[4] Psay nTotCli1	   	   Picture  tm(nTotCli1,16)
		EndIF
		nTotVend1 += nTotCli1
		If mv_par09 == 1
			li++
		EndIf
		dbSelectArea("TRB")
	End
	
	@li, 0         Psay STR0012+ cVend		//"TOTAL VENDEDOR  ---> "
	@li, aCoord[4] Psay nTotVend1		Picture tm(nTotVend1,16)
//	If mv_par07 == 1
//		li:=90
//	Else
		li++
		@li,00 PSay Repl("-",80)
		li++
//	Endif
	
	If mv_par10 == 2
		nTotGer1 += nTotGerAux
		nTotGerAux := 0
	Else	
		nTotGer1 += nTotVend1
	EndIf	
		
	dbSelectArea("TRB")
EndDo

IF li != 80
	If mv_par07 # 1
		@li,  0        Psay STR0013	//"T O T A L  G E R A L : "
		@li, aCoord[4] Psay nTotGer1	Picture tm(nTotGer1,16)
	Endif
	roda(cbcont,cbtxt,"P")
EndIF

dbSelectArea("TRB")
cExt := OrdBagExt()
dbCloseArea()
If File(cNomArq+GetDBExtension())
	FERASE(cNomArq+GetDBExtension())    //arquivo de trabalho
Endif

If File(cNomArq + cExt)
	FERASE(cNomArq+cExt)    //indice gerado
Endif

dbSelectArea("SCJ")
dbSetOrder(1)

dbSelectArea("SA3")
dbClearFilter()
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaTrab ³ Autor ³ Cleber Maldonado      ³ Data ³03/04/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Arquivo de Trabalho                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nEl - Ordem do Vendedor                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M05R05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion GravaTrab(nEl)
Local suf := "SCJ->CJ_XVEND" + Str(nEl,1)
RecLock("TRB",.t.)
Replace VENDEDOR With &suf
Replace NUMORC   With SCJ->CJ_NUM
Replace CLIENTE  With SCJ->CJ_CLIENTE
Replace EMISSAO  With SCJ->CJ_EMISSAO
Replace LOJA     With SCJ->CJ_LOJA
Replace MOEDA    With SCJ->CJ_MOEDA
MsUnlock()
dbSelectArea("SCJ")
Return .T.
#IFDEF TOP
Static Function GerTrabTop()
Local aArea:=GetArea()
Local aStruSCJ:= {}
Local nJ      := 0
Local nLoop   := 0
Local cSCJTmp := GetNextAlias()
Local cSCJTmp2:= GetNextAlias()
Local cQuerTmp := ""				//Utilizada para adequar a query segundo necessidades de bancos Sybase
Local cQuery  := ""
Local cQuery2 := ""
Local cVendCh := ""
Local cSuf    := ""
Local nVend	  := Fa440CntVen()
Local cVend   := ""
Local cCond   := ""
Local cPedido := ""
Local aVend   := {}

aStruSCJ  := SCJ->(dbStruct())

cQuery:="SELECT "
cSuf:="0"
For nJ:=1 to nVend
	cSuf := Soma1(cSuf)
	cVend := "CJ_XVEND"+cSuf
	If SCJ->(FieldPos(cVend))>0
		Aadd(aVend,cVend)
		cQuery+=cVend+","
		If !Empty(cCond)
			cCond+="or "
		Endif
		cCond+="("+cVend+"<>'' and "+cVend+">='"+mv_par03+"' and "+cVend+"<='"+mv_par04+"') "
	Endif
Next	                                                        
For nJ := 1 To SCJ->(FCount())
	If nJ > 1
		cQuery += ", "
	EndIf		
	cQuery += SCJ->(FieldName(nJ))
Next      
cQuery+=",A1_NOME,A1_MUN "
cQuery+="FROM "+RetSqlName("SCJ")+" SCJ, "+RetSqlName("SA1")+" SA1 " +RetSqlName("SC5")+" SC5 "
cQuery+="WHERE "
cQuery+="SCJ.CJ_FILIAL='"+xFilial("SCJ")+"' "
cQuery+="AND SCJ.D_E_L_E_T_=' ' "
cQuery+="AND SCJ.CJ_CLIENTE>='"+MV_PAR05+"' AND SCJ.CJ_CLIENTE<='"+MV_PAR06+"' "
cQuery+="AND SCJ.CJ_LOJA>='"+MV_PAR07+"' AND SCJ.CJ_LOJA<='"+MV_PAR08+"' "
cQuery+="AND SCJ.CJ_EMISSAO>='"+Dtos(MV_PAR01)+"' AND SCJ.CJ_EMISSAO<='"+Dtos(MV_PAR02)+"' "
cQuery+="AND ("+cCond+") "
cQuery+="AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "	
cQuery+="AND SA1.A1_COD=SCJ.CJ_CLIENTE "
cQuery+="AND SA1.A1_LOJA=SCJ.CJ_LOJA "
cQuery+="AND SA1.D_E_L_E_T_=' ' "
If TcSrvType() != "AS/400"		
	cQuery+="AND ("
Else
	cQuery+="AND 0 < ("
EndIf
cQuery2:="SELECT SUM(CK_VALOR) nTotPed FROM "+RetSqlName("SCK")+" SCK,"+RetSqlName("SF4")+" SF4 "
cQuery2+="WHERE "
cQuery2+="SCK.CK_FILIAL='"+xFilial("SCK")+"' AND "
cQuery2+="SCK.CK_NUM=CJ_NUM AND "
cQuery2+="SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
cQuery2+="SF4.F4_CODIGO=SCK.CK_TES  AND "
If cPaisLoc=="BRA"
	If MV_PAR12==1
		cQuery2+="SF4.F4_AGREG<>'N' AND "
	Endif
Endif
If mv_par13==1
	cQuery2 += "SF4.F4_ESTOQUE = 'S' AND "
ElseIf mv_par13==2
	cQuery2 += "SF4.F4_ESTOQUE = 'N' AND "
EndIf
If mv_par14==1
	cQuery2 += "SF4.F4_DUPLIC = 'S' AND "
ElseIf mv_par14==2
	cQuery2 += "SF4.F4_DUPLIC = 'N' AND "
EndIf
cQuery2+="SF4.D_E_L_E_T_=' ' AND "		
cQuery2+="SCK.D_E_L_E_T_=' ' "

cQuerTmp := STRTRAN(cQuery2,"nTotPed","")
cQuerTmp := STRTRAN(cQuerTmp,"CJ_NUM","SCJ.CJ_NUM")
If TcSrvType() != "AS/400"
	cQuery += cQuerTmp + ") > 0 "
Else
	cQuery += cQuerTmp + ")"	
EndIf
cQuery:=ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cSCJTmp)

For nLoop := 1 To Len(aStruSCJ)
	If aStruSCJ[nLoop][2] <> "C" .and. FieldPos(aStruSCJ[nLoop][1]) > 0
		TcSetField(cSCJTmp,aStruSCJ[nLoop][1],aStruSCJ[nLoop][2],aStruSCJ[nLoop][3],aStruSCJ[nLoop][4])
	EndIf
Next nLoop

SetRegua(SCK->(LastRec()))
DbSelectArea(cSCJTmp)
While (cSCJTmp)->(!Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a validacao do filtro do usuario           	        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		(cSCJTmp)->(DbSkip())
		Loop
	EndIf	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,StrTran(cQuery2,"=CJ_NUM","='"+(cSCJTmp)->CJ_NUM+"'")),cSCJTmp2)
	If (cSCJTmp2)->nTotPed>0
		For nJ:=1 to nVend
			cVend := aVend[nJ]
			cVendCh := (cSCJTmp)->&cVend
			If !Empty(cVendCH) .And. cVendCh >= mv_par03 .And. cVendCh <= mv_par04
				RecLock("TRB",.t.)
				Replace TRB->VENDEDOR With cVendCH
				Replace TRB->NUMORC   With (cSCJTmp)->CJ_NUM
				Replace TRB->CLIENTE  With (cSCJTmp)->CJ_CLIENTE
				Replace TRB->EMISSAO  With (cSCJTmp)->CJ_EMISSAO
				Replace TRB->LOJA     With (cSCJTmp)->CJ_LOJA
				Replace TRB->MOEDA    With (cSCJTmp)->CJ_MOEDA
				Replace TRB->TOTPED   With (cSCJTmp2)->nTotPed
				Replace TRB->CLINOME  With (cSCJTmp)->A1_NOME
				Replace TRB->CLIMUN   With (cSCJTmp)->A1_MUN
				Replace TRB->CLIUF    With (cSCJTmp)->A1_EST
				TRB->(MsUnlock())
			Endif
		Next
	EndIf
	DbSelectArea(cSCJTmp2)
	dbCloseArea()
	DbSelectArea(cSCJTmp)
	IncRegua()
	(cSCJTmp)->(DbSkip())
Enddo

DbSelectArea(cSCJTmp)
DbCloseArea()
RestArea(aArea)
Return
#ENDIF
