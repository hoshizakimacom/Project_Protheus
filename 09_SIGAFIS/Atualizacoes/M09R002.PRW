#Include "PROTHEUS.CH"
#Include "TopConn.ch"
#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM09R002   บ Autor ณ Denyse Telles         บ Data ณ          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera um relatrio da Apura็ใo de Pis/Cofins - Faturamento    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M09R002()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da Rotina                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aRegs			:= {}
Local aButtons		:= {}
Local cPerg     	:= "M09R002"
Local aSays			:= {}
Local nOpcA			:= 0

Private oProcess	:= Nil
Private Titulo		:= OemToAnsi("Relatorio de Conferencia - Apura็ใo de Pis e Cofins")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao dos parametros                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 = Periodo De                                               ณ
//ณ mv_par02 = Periodo Ate                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aRegs,{cPerg,"01","Data de"		,"","","mv_ch1","D", 08,0,0,"G","","mv_par01" ,""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data at้"		,"","","mv_ch2","D", 08,0,0,"G","","mv_par02" ,""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Filiais"		,"","","mv_ch3","C", 80,0,0,"G","","mv_par03" ,""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria as perguntas dentro do SX1                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ValidPerg(cPerg,aRegs)

Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta interface com o usuario                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aSays,OemToAnsi("Este programa monta um relatorio de compara็ใo dos valores da   " ))
aAdd(aSays,OemToAnsi("Apura็ใo de Pis e Cofins                                        " ))
aAdd(aSays,OemToAnsi("                                                                " ))
aAdd(aSays,OemToAnsi("                                                                " ))
aAdd(aSays,OemToAnsi("                                                                " ))

aAdd(aButtons, { 5,.T.,{|o| nOpcA:= 0 ,Pergunte(cPerg,.T.)	} } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA:= 1,o:oWnd:End() 			} } )
aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSays, aButtons )

If nOpcA == 1
	oProcess := MsNewProcess():New({|lEnd| M09R002a(oProcess)},Titulo)
	oProcess:Activate()
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM09R002a  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo temporแrio para a impressใo do Excel.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMZ                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function M09R002a(oProcess)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local lRetorno	:= .T.
Local cQry		:= ""
Local nA		:= 0
Local _cArquivo	:= ""
Local cPath	    := AllTrim(GetTempPath())
Local cDirDocs 	:= "\system\"
Local cBarra 	:= If(IsSrvUnix(), "/", "\")
Local cRegAnt   := ""

Local aCabec	:= {}
Local aEstilos	:= {}

Local cCFOP     := ""
Local nTotReg	:= 0

Private aCmpTmp		:= {}
Private aCmpTst		:= {}
Private cArqTrb1	:= ""
Private cArqTrb2	:= ""
Private aInd		:= {}

Private cArquivo  	:= CriaTrab(,.F.)
Private nHandle   	:= 0
Private cCPOOrgPub  := GetNewPar ("MV_A1M996","A1_B2B")

aAdd(aEstilos,{"Bold"})
aAdd(aEstilos,{"Bold","Italic"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o formato do arquivo que irแ gerar a planilha.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Aadd(aCmpTmp, { 'FT_FILIAL'		,TAMSX3('FT_FILIAL')[3]		,TAMSX3('FT_FILIAL')[1]		,TAMSX3('FT_FILIAL')[2]		})
Aadd(aCmpTmp, { 'FT_NFISCAL'   	,TAMSX3('FT_NFISCAL')[3]	,TAMSX3('FT_NFISCAL')[1]	,TAMSX3('FT_NFISCAL')[2]	})
Aadd(aCmpTmp, { 'FT_NFELETR'   	,TAMSX3('FT_NFELETR')[3]	,TAMSX3('FT_NFELETR')[1]	,TAMSX3('FT_NFELETR')[2]	})
Aadd(aCmpTmp, { 'FT_SERIE'   	,TAMSX3('FT_SERIE')[3]		,TAMSX3('FT_SERIE')[1]		,TAMSX3('FT_SERIE')[2]		})
Aadd(aCmpTmp, { 'FT_CLIEFOR'   	,TAMSX3('FT_CLIEFOR')[3]	,TAMSX3('FT_CLIEFOR')[1]	,TAMSX3('FT_CLIEFOR')[2]	})
Aadd(aCmpTmp, { 'FT_LOJA'   	,TAMSX3('FT_LOJA')[3]		,TAMSX3('FT_LOJA')[1]		,TAMSX3('FT_LOJA')[2]		})
Aadd(aCmpTmp, { 'A2_NOME'   	,TAMSX3('A2_NOME')[3]		,TAMSX3('A2_NOME')[1]		,TAMSX3('A2_NOME')[2]		}) // Alterado Nome
Aadd(aCmpTmp, { 'A1_CGC'   		,TAMSX3('A1_CGC')[3]		,TAMSX3('A1_CGC')[1]		,TAMSX3('A1_CGC')[2]		})
Aadd(aCmpTmp, { 'FT_ITEM'   	,TAMSX3('FT_ITEM')[3]		,TAMSX3('FT_ITEM')[1]		,TAMSX3('FT_ITEM')[2]		})
Aadd(aCmpTmp, { 'FT_CFOP'   	,TAMSX3('FT_CFOP')[3]		,TAMSX3('FT_CFOP')[1]		,TAMSX3('FT_CFOP')[2]		})
Aadd(aCmpTmp, { 'D2_TES'	   	,TAMSX3('D2_TES')[3]		,TAMSX3('D2_TES')[1]		,TAMSX3('D2_TES')[2]		})
Aadd(aCmpTmp, { 'X5_DESCRI'   	,TAMSX3('X5_DESCRI')[3]		,TAMSX3('X5_DESCRI')[1]		,TAMSX3('X5_DESCRI')[2]		})
Aadd(aCmpTmp, { 'FT_CODBCC'    	,TAMSX3('FT_CODBCC')[3]  	,TAMSX3('FT_CODBCC')[1]		,TAMSX3('FT_CODBCC')[2]		})
Aadd(aCmpTmp, { 'FT_CSTPIS'    	,TAMSX3('FT_CSTPIS')[3]  	,TAMSX3('FT_CSTPIS')[1]		,TAMSX3('FT_CSTPIS')[2]		})
Aadd(aCmpTmp, { 'FT_CSTCOF'   	,TAMSX3('FT_CSTCOF')[3]		,TAMSX3('FT_CSTCOF')[1]		,TAMSX3('FT_CSTCOF')[2]		})
Aadd(aCmpTmp, { 'FT_ALIQPIS'   	,TAMSX3('FT_ALIQPIS')[3]	,TAMSX3('FT_ALIQPIS')[1]	,TAMSX3('FT_ALIQPIS')[2]	})
Aadd(aCmpTmp, { 'FT_ALIQCOF'	,TAMSX3('FT_ALIQCOF')[3]	,TAMSX3('FT_ALIQCOF')[1]	,TAMSX3('FT_ALIQCOF')[2]	})
Aadd(aCmpTmp, { 'A1_XORGPUB' 	,TAMSX3(cCPOOrgPub)[3]		,TAMSX3(cCPOOrgPub)[1]		,TAMSX3(cCPOOrgPub)[2] 		})
Aadd(aCmpTmp, { 'LINHA'    		,'C'						,40							,0							})
Aadd(aCmpTmp, { 'FT_VALCONT'	,TAMSX3('FT_VALCONT')[3]	,TAMSX3('FT_VALCONT')[1]	,TAMSX3('FT_VALCONT')[2]	})
Aadd(aCmpTmp, { 'E1_SALDO'		,TAMSX3('E1_SALDO')[3] 		,TAMSX3('E1_SALDO')[1] 		,TAMSX3('E1_SALDO')[2]		})
Aadd(aCmpTmp, { 'FT_TOTAL'		,TAMSX3('FT_TOTAL')[3]		,TAMSX3('FT_TOTAL')[1] 		,TAMSX3('FT_TOTAL')[2] 		})
Aadd(aCmpTmp, { 'FT_BASEPIS'	,TAMSX3('FT_BASEPIS')[3]	,TAMSX3('FT_BASEPIS')[1]	,TAMSX3('FT_BASEPIS')[2]	})
Aadd(aCmpTmp, { 'FT_BASECOF'  	,TAMSX3('FT_BASECOF')[3]	,TAMSX3('FT_BASECOF')[1]	,TAMSX3('FT_BASECOF')[2]	})
Aadd(aCmpTmp, { 'FT_VALPIS'  	,TAMSX3('FT_VALPIS')[3]		,TAMSX3('FT_VALPIS')[1]		,TAMSX3('FT_VALPIS')[2]		})
Aadd(aCmpTmp, { 'FT_VALCOF'   	,TAMSX3('FT_VALCOF')[3]		,TAMSX3('FT_VALCOF')[1]		,TAMSX3('FT_VALCOF')[2]		})
Aadd(aCmpTmp, { 'FT_VALIPI'   	,TAMSX3('FT_VALIPI')[3]		,TAMSX3('FT_VALIPI')[1]		,TAMSX3('FT_VALIPI')[2]		})
Aadd(aCmpTmp, { 'FT_PRODUTO'   	,TAMSX3('FT_PRODUTO')[3]	,TAMSX3('FT_PRODUTO')[1]	,TAMSX3('FT_PRODUTO')[2]	})
Aadd(aCmpTmp, { 'FT_NFORI'   	,TAMSX3('FT_NFORI')[3]		,TAMSX3('FT_NFORI')[1]		,TAMSX3('FT_NFORI')[2]		})
Aadd(aCmpTmp, { 'DTNFORI'   	,TAMSX3('FT_ENTRADA')[3]	,TAMSX3('FT_ENTRADA')[1]	,TAMSX3('FT_ENTRADA')[2]	})
Aadd(aCmpTmp, { 'B1_POSIPI'   	,TAMSX3('B1_POSIPI')[3]		,TAMSX3('B1_POSIPI')[1]		,TAMSX3('B1_POSIPI')[2]	})
Aadd(aCmpTmp, { 'CG1_CODIGO'   	,TAMSX3('CG1_CODIGO')[3]	,TAMSX3('CG1_CODIGO')[1]	,TAMSX3('CG1_CODIGO')[2]	})
Aadd(aCmpTmp, { 'CG1_ALIQ'   	,TAMSX3('CG1_ALIQ')[3]		,TAMSX3('CG1_ALIQ')[1]		,TAMSX3('CG1_ALIQ')[2]		})
Aadd(aCmpTmp, { 'D2_TIPO'   	,TAMSX3('D2_TIPO')[3]		,TAMSX3('D2_TIPO')[1]		,TAMSX3('D2_TIPO')[2]		})
Aadd(aCmpTmp, { 'D2_LOTECTL'   	,TAMSX3('D2_LOTECTL')[3]	,TAMSX3('D2_LOTECTL')[1]	,TAMSX3('D2_LOTECTL')[2]	})
Aadd(aCmpTmp, { 'FT_ICMSRET'   	,TAMSX3('FT_ICMSRET')[3]	,TAMSX3('FT_ICMSRET')[1]	,TAMSX3('FT_ICMSRET')[2]	})
Aadd(aCmpTmp, { 'FT_FRETE'   	,TAMSX3('FT_FRETE')[3]		,TAMSX3('FT_FRETE')[1]		,TAMSX3('FT_FRETE')[2]		})
Aadd(aCmpTmp, { 'FT_SEGURO'   	,TAMSX3('FT_SEGURO')[3]		,TAMSX3('FT_SEGURO')[1]		,TAMSX3('FT_SEGURO')[2]		})
Aadd(aCmpTmp, { 'FT_DESPESA'   	,TAMSX3('FT_DESPESA')[3]	,TAMSX3('FT_DESPESA')[1]	,TAMSX3('FT_DESPESA')[2]	})
Aadd(aCmpTmp, { 'FT_DESCONT'   	,TAMSX3('FT_DESCONT')[3]	,TAMSX3('FT_DESCONT')[1]	,TAMSX3('FT_DESCONT')[2]	})

Aadd(aCmpTmp, { 'A1_NOME'   	,TAMSX3('A1_NOME')[3]		,TAMSX3('A1_NOME')[1]		,TAMSX3('A1_NOME')[2]		})
Aadd(aCmpTmp, { 'A1_NREDUZ'   	,TAMSX3('A1_NREDUZ')[3]		,TAMSX3('A1_NREDUZ')[1]		,TAMSX3('A1_NREDUZ')[2]		})
Aadd(aCmpTmp, { 'A1_VEND'   	,TAMSX3('A1_VEND')[3]		,TAMSX3('A1_VEND')[1]		,TAMSX3('A1_VEND')[2]		})
Aadd(aCmpTmp, { 'A1_REGIAO'   	,TAMSX3('A1_REGIAO')[3]		,TAMSX3('A1_REGIAO')[1]		,TAMSX3('A1_REGIAO')[2]		})
Aadd(aCmpTmp, { 'A1_EST'   		,TAMSX3('A1_EST')[3]		,TAMSX3('A1_EST')[1]		,TAMSX3('A1_EST')[2]		})
//Aadd(aCmpTmp, { 'A1_XCLAS'   	,TAMSX3('A1_XCLAS')[3]		,TAMSX3('A1_XCLAS')[1]		,TAMSX3('A1_XCLAS')[2]		})
Aadd(aCmpTmp, { 'B1_DESC'   	,TAMSX3('B1_DESC')[3]		,TAMSX3('B1_DESC')[1]		,TAMSX3('B1_DESC')[2]		})
Aadd(aCmpTmp, { 'FT_BASEICM'   	,TAMSX3('FT_BASEICM')[3]	,TAMSX3('FT_BASEICM')[1]	,TAMSX3('FT_BASEICM')[2]	}) // Acrescentado    
Aadd(aCmpTmp, { 'FT_VALICM'   	,TAMSX3('FT_VALICM')[3]		,TAMSX3('FT_VALICM')[1]		,TAMSX3('FT_VALICM')[2]		})    
Aadd(aCmpTmp, { 'FT_DIFAL'   	,TAMSX3('FT_DIFAL')[3]		,TAMSX3('FT_DIFAL')[1]		,TAMSX3('FT_DIFAL')[2]		})
Aadd(aCmpTmp, { 'FT_VFCPDIF'   	,TAMSX3('FT_VFCPDIF')[3]	,TAMSX3('FT_VFCPDIF')[1]	,TAMSX3('FT_VFCPDIF')[2]	})
Aadd(aCmpTmp, { 'FT_ICMSCOM'   	,TAMSX3('FT_ICMSCOM')[3]	,TAMSX3('FT_ICMSCOM')[1]	,TAMSX3('FT_ICMSCOM')[2]	})

Aadd(aCmpTmp, { 'FT_ISENICM'   	,TAMSX3('FT_ISENICM')[3]	,TAMSX3('FT_ISENICM')[1]	,TAMSX3('FT_ISENICM')[2]	})    
Aadd(aCmpTmp, { 'FT_OUTRICM'   	,TAMSX3('FT_OUTRICM')[3]	,TAMSX3('FT_OUTRICM')[1]	,TAMSX3('FT_OUTRICM')[2]	})
Aadd(aCmpTmp, { 'FT_ALIQICM'   	,TAMSX3('FT_ALIQICM')[3]	,TAMSX3('FT_ALIQICM')[1]	,TAMSX3('FT_ALIQICM')[2]	})
Aadd(aCmpTmp, { 'FT_CLASFIS'   	,TAMSX3('FT_CLASFIS')[3]	,TAMSX3('FT_CLASFIS')[1]	,TAMSX3('FT_CLASFIS')[2]	})

Aadd(aCmpTmp, { 'A1_INSCR'   	,TAMSX3('A1_INSCR')[3]		,TAMSX3('A1_INSCR')[1]		,TAMSX3('A1_INSCR')[2]		})
Aadd(aCmpTmp, { 'FT_ENTRADA'   	,TAMSX3('FT_ENTRADA')[3]	,TAMSX3('FT_ENTRADA')[1]	,TAMSX3('FT_ENTRADA')[2]	})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo temporario                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArqTrb1 := CriaTrab(aCmpTmp,.T.)
dbUseArea(.T.,"DBFCDX",cArqTrb1,"TMPTRB",.T.,.F.)
DbSelectArea("TMPTRB")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aInd,{CriaTrab(Nil,.F.),"FT_FILIAL+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM","Filial + Doc + Serie + Cliefor + Loja + Produto + Item"})
For nA := 1 to Len(aInd)
	IndRegua("TMPTRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando อndice Temporแrio...") )
Next nA

DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para pegar os registros da SD1  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry := " SELECT	FT_FILIAL,
cQry += " 			FT_NFISCAL,FT_NFELETR,
cQry += " 			FT_SERIE,
cQry += " 			FT_CLIEFOR,
cQry += " 			RTRIM(LTRIM(ISNULL(A1_CGC,' ')))+RTRIM(LTRIM(ISNULL(A2_CGC,' '))) A1_CGC,
cQry += " 			FT_LOJA,
cQry += " 			(SELECT A2_NOME FROM SA2010 SA2 WHERE A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = FT_CLIEFOR AND A2_LOJA = FT_LOJA AND SA2.D_E_L_E_T_ = ' ') A2_NOME, " // Alterado Nome
cQry += " 			FT_ITEM,
cQry += " 			FT_CFOP,
cQry += " 			D2_TES,
cQry += " 			X5_DESCRI,
cQry += " 			ISNULL(FT_CODBCC,'  ') FT_CODBCC,
cQry += " 			FT_CSTPIS,
cQry += " 			FT_CSTCOF,
cQry += " 			FT_ALIQPIS,
cQry += " 			FT_ALIQCOF,
cQry += " 			CASE WHEN FT_TIPO NOT IN ('D','B') AND "+cCPOOrgPub+" IN ('1','S') THEN 'S' ELSE 'N' END A1_XORGPUB,
cQry += " 			CASE	WHEN SUBSTRING(FT_CFOP,1,1)='7' THEN 'FAT.EXP'
cQry += " 					WHEN SUBSTRING(FT_CFOP,2,3) IN ('110','109') THEN 'FAT.ZFM'
cQry += " 					WHEN SUBSTRING(FT_CFOP,2,3) IN ('201','202','203','204') THEN 'DEVOLUCAO'
cQry += " 					WHEN FT_ALIQCOF=3.00 AND FT_BASECOF>0 THEN 'FAT.CUM'
cQry += " 					WHEN FT_ALIQCOF=7.60 AND FT_BASECOF>0 THEN 'FAT.NCUM'
cQry += " 			ELSE 'NAO TRATADO' END LINHA,
cQry += " 			0 E1_SALDO,
cQry += " 			FT_VALCONT,
cQry += " 			CASE WHEN FT_ESPECIE='RPS' THEN FT_VALCONT ELSE FT_TOTAL END FT_TOTAL,
cQry += " 	   		CASE WHEN F4_PISCRED IN ('1','2') THEN FT_BASEPIS ELSE 0 END FT_BASEPIS,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_BASECOF ELSE 0 END FT_BASECOF,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_VALPIS ELSE 0 END FT_VALPIS,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_VALCOF - FT_MVALCOF ELSE 0 END FT_VALCOF,
cQry += " 			FT_VALIPI,
cQry += " 			SD2.R_E_C_N_O_ RECSD,
cQry += " 			FT_TIPO,
cQry += " 			FT_PRODUTO,
cQry += " 			FT_NFORI,
cQry += " 		   	' ' DTNFORI,
cQry += " 		   	SFT.R_E_C_N_O_ RECSFT,
cQry += " 		   	SFT.FT_POSIPI B1_POSIPI,
cQry += " 		   	ISNULL(CG1_CODIGO,'')CG1_CODIGO,
cQry += " 		   	ISNULL(CG1_ALIQ,0)CG1_ALIQ,
cQry += " 		   	D2_TIPO,D2_LOTECTL,FT_ICMSRET,FT_FRETE,FT_SEGURO,FT_DESPESA,FT_DESCONT

cQry += "           ,A1_NOME,A1_NREDUZ,A1_VEND,A1_REGIAO,A1_EST,B1_DESC,FT_VALICM, FT_BASEICM, FT_DIFAL, FT_VFCPDIF, FT_ICMSCOM, FT_ISENICM, FT_OUTRICM,FT_ALIQICM, FT_CLASFIS

cQry += "           ,A1_INSCR,FT_ENTRADA



cQry += " FROM "+RetSQLName("SFT")+" SFT
cQry += " LEFT JOIN "+RetSQLName("SB1")+" SB1 ON B1_FILIAL ='"+xFilial("SB1")+"' AND B1_COD=FT_PRODUTO AND SB1.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SD2")+" SD2 ON D2_FILIAL =FT_FILIAL AND D2_DOC=FT_NFISCAL AND D2_SERIE=FT_SERIE AND D2_CLIENTE=FT_CLIEFOR AND D2_LOJA=FT_LOJA AND D2_ITEM=FT_ITEM AND SD2.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SF4")+" SF4 ON F4_FILIAL ='"+xFilial("SF4")+"' AND F4_CODIGO=D2_TES AND SF4.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SX5")+" SX5 ON X5_FILIAL ='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=FT_CFOP AND SX5.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SA1")+" SA1 ON A1_FILIAL ='"+xFilial("SA1")+"' AND A1_COD=FT_CLIEFOR AND A1_LOJA=FT_LOJA AND SA1.D_E_L_E_T_=' ' AND FT_TIPO NOT IN ('D','B')
cQry += " LEFT JOIN "+RetSQLName("SA2")+" SA2 ON A2_FILIAL ='"+xFilial("SA2")+"' AND A2_COD=FT_CLIEFOR AND A2_LOJA=FT_LOJA AND SA2.D_E_L_E_T_=' ' AND FT_TIPO     IN ('D','B')
cQry += " LEFT JOIN "+RetSQLName("SB5")+" SB5 ON B5_FILIAL=B1_FILIAL AND B5_COD=B1_COD AND SB5.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("CG1")+" CG1 ON CG1_FILIAL='"+xFilial("CG1")+"' AND CG1_CODIGO=B5_CODATIV AND CG1.D_E_L_E_T_=' '
cQry += " WHERE
cQry += "     FT_FILIAL IN ('"+StrTran(AllTrim(MV_PAR03),',',"','")+"')
cQry += " AND FT_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
cQry += " AND FT_TIPOMOV='S'
cQry += " AND FT_DTCANC=' '
cQry += " AND SFT.D_E_L_E_T_=' '
cQry += " UNION ALL
cQry += " SELECT	FT_FILIAL,
cQry += " 			FT_NFISCAL,FT_NFELETR,
cQry += " 			FT_SERIE,
cQry += " 			FT_CLIEFOR,
cQry += " 			RTRIM(LTRIM(ISNULL(A1_CGC,' ')))+RTRIM(LTRIM(ISNULL(A2_CGC,' '))) A1_CGC,
cQry += " 			FT_LOJA,
cQry += " 			(SELECT A2_NOME FROM SA2010 SA2 WHERE A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = FT_CLIEFOR AND A2_LOJA = FT_LOJA AND SA2.D_E_L_E_T_ = ' ') A2_NOME, " // Alterado Nome
cQry += " 			FT_ITEM,
cQry += " 			FT_CFOP,
cQry += " 			D1_TES,
cQry += " 			X5_DESCRI,
cQry += " 			ISNULL(FT_CODBCC,'  ') FT_CODBCC,
cQry += " 			FT_CSTPIS,
cQry += " 			FT_CSTCOF,
cQry += " 			FT_ALIQPIS,
cQry += " 			FT_ALIQCOF,
cQry += " 			'N' A1_XORGPUB,
cQry += " 			'ENTRADA' LINHA,
cQry += " 			0 E1_SALDO,
cQry += " 			FT_VALCONT,
cQry += " 			FT_VALCONT FT_TOTAL,
cQry += " 	   		CASE WHEN F4_PISCRED IN ('1','2') THEN FT_BASEPIS ELSE 0 END FT_BASEPIS,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_BASECOF ELSE 0 END FT_BASECOF,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_VALPIS ELSE 0 END FT_VALPIS,
cQry += " 			CASE WHEN F4_PISCRED IN ('1','2') THEN FT_VALCOF - FT_MVALCOF ELSE 0 END FT_VALCOF,
cQry += " 			FT_VALIPI,
cQry += " 			SD1.R_E_C_N_O_ RECSD,
cQry += " 			FT_TIPO,
cQry += " 			FT_PRODUTO,
cQry += " 			FT_NFORI,
cQry += " 			' ' DTNFORI,
cQry += "	   		SFT.R_E_C_N_O_ RECSFT,
cQry += " 		   	SFT.FT_POSIPI B1_POSIPI,
cQry += "	   		ISNULL(CG1_CODIGO,'')CG1_CODIGO,
cQry += "	   		ISNULL(CG1_ALIQ,0)CG1_ALIQ,
cQry += " 		   	D1_TIPO, D1_LOTECTL,FT_ICMSRET,FT_FRETE,FT_SEGURO,FT_DESPESA,FT_DESCONT

cQry += "           ,A1_NOME, A1_NREDUZ, A1_VEND, A1_REGIAO, A1_EST, B1_DESC,FT_VALICM,FT_BASEICM,FT_DIFAL, FT_VFCPDIF, FT_ICMSCOM, FT_ISENICM, FT_OUTRICM,FT_ALIQICM, FT_CLASFIS

cQry += "           ,A1_INSCR,FT_ENTRADA

cQry += " FROM "+RetSQLName("SFT")+" SFT
cQry += " LEFT JOIN "+RetSQLName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=FT_PRODUTO AND SB1.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SD1")+" SD1 ON D1_FILIAL=FT_FILIAL AND D1_DOC=FT_NFISCAL AND D1_SERIE=FT_SERIE AND D1_FORNECE=FT_CLIEFOR AND D1_LOJA=FT_LOJA AND D1_ITEM=FT_ITEM AND SD1.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SF4")+" SF4 ON F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=D1_TES AND SF4.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SX5")+" SX5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=FT_CFOP AND SX5.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("SA1")+" SA1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=FT_CLIEFOR AND A1_LOJA=FT_LOJA AND SA1.D_E_L_E_T_=' ' AND FT_TIPO     IN ('D','B')
cQry += " LEFT JOIN "+RetSQLName("SA2")+" SA2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=FT_CLIEFOR AND A2_LOJA=FT_LOJA AND SA2.D_E_L_E_T_=' ' AND FT_TIPO NOT IN ('D','B')
cQry += " LEFT JOIN "+RetSQLName("SB5")+" SB5 ON B5_FILIAL=B1_FILIAL AND B5_COD=B1_COD AND SB5.D_E_L_E_T_=' '
cQry += " LEFT JOIN "+RetSQLName("CG1")+" CG1 ON CG1_FILIAL='"+xFilial("CG1")+"' AND CG1_CODIGO=B5_CODATIV AND CG1.D_E_L_E_T_=' '
cQry += " WHERE
cQry += "     FT_FILIAL IN ('"+StrTran(AllTrim(MV_PAR03),',',"','")+"')
cQry += " AND FT_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
cQry += " AND FT_TIPOMOV='E'
cQry += " AND FT_DTCANC=' '
cQry += " AND SFT.D_E_L_E_T_=' '
cQry += " ORDER BY FT_FILIAL, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, FT_ITEM

MemoWrite("\system\rfisr50.txt",cQry)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha o alias temporแrio pr้vio	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("QUERY") > 0
	DbSelectArea("QUERY")
	DbCloseArea()
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona na tabela a ser usada   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SE1")
dbSetORder(1)

dbSelectArea("SF4")
dbSetORder(1)

dbSelectArea("SF2")
dbSetORder(1)

dbSelectArea("SD2")
dbSetORder(3)//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

dbSelectArea("SD1")
dbSetOrder(1)//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

TcQuery cQry New Alias "QUERY"

tcSetField( "QUERY",'DTNFORI','D',8,0)

DbSelectArea("QUERY")

dbSelectArea("QUERY")
QUERY->(dbGoTop())
QUERY->(dbEval({|| nTotReg++},,{|| !EOF()}))
QUERY->(dbGoTop())
oProcess:SetRegua2(nTotReg)

If !QUERY->(EOF())//Verifica se a consulta retornou algum resultado
	
	Do While !EOF()
		
		oProcess:IncRegua2("Gravando dados ... ")
		
		RecLock("TMPTRB",.T.)
		
		For nA	:= 1 to Len(aCmpTmp)
			TMPTRB->&(aCmpTmp[nA][1])	:= GetVldValue(QUERY->&(aCmpTmp[nA][1]),nA)
		Next nA
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณQuando encontrar o campo E1_SALDO, busca o saldo de           ณ
		//ณtodas as parcelas do titulo em questใo na data de final do mesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nSaldoTit := 0
		nSaldoTot := 0
		nSaldoRet := 0
		If TMPTRB->A1_XORGPUB = 'S' .And.;
			!(cRegAnt==QUERY->(FT_FILIAL+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA)) //Processa o saldo somente para um dos itens do Doc
			dbSelectArea("SF2") //dbSetOrder(1)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			If dbSeek(TMPTRB->(FT_FILIAL+FT_NFISCAL+FT_SERIE))
				dbSelectArea("SE1") //dbSetOrder(1)//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				If dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
					While !Eof();
						.And. SE1->E1_FILIAL == xFilial("SE1");
						.And. SE1->E1_PREFIXO==SF2->F2_PREFIXO;
						.AND. SE1->E1_NUM=SF2->F2_DOC
						
						If !(SE1->E1_TIPO $ "NF " .AND. SE1->E1_CLIENTE == SF2->F2_CLIENTE .AND. SE1->E1_LOJA=SF2->F2_LOJA)
							dbSelectArea("SE1")
							dbSkip()
							Loop
						EndIf
						//Funcao que retorna o saldo de um titulo em uma data (E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE - (movimentos SE5)
						//			SaldoTit(cPrefixo			,cNumero		,cParcela			,cTipo			,cNatureza			,cCart	,cCliFor			,nMoeda			,dData		,dDataBaixa		,cLoja			,cFilTit,nTxMoeda,nTipoData)
						nSaldoTit := SaldoTit(SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,SE1->E1_NATUREZ	,"R"	,SE1->E1_CLIENTE	,SE1->E1_MOEDA	,mv_par02	,mv_par02		,SE1->E1_LOJA)
						//A funcao acima soma acrescimos e diminui decrescimo. Desfa็o esta opera็ใo para aproximar o valor do titulo ao valor da nota fiscal
						nSaldoTit := nSaldoTit - SE1->E1_SDACRES + SE1->E1_SDDECRE
						//Se o titulo esta baixado parcial, verifico e subtraio retencoes baixadas
						If nSaldoTit < SE1->E1_VLCRUZ
							nSaldoRet := SubRetBX()
						EndIf
						//Saldo liquido do titulo
						nSaldoTot += (nSaldoTit - nSaldoRet)
						
						dbSelectArea("SE1")
						dbSkip()
					EndDo
				EndIf
			EndIf
		EndIf
		
		TMPTRB->E1_SALDO := nSaldoTot
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณQuando a nf entrada for de venda cancelada, verifica se e     ณ
		//ณdevolucao de nfsaida emitida dentro ou anterior ao periodo    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lDevol := .F.
		cCFOP  := Upper(AllTrim(QUERY->FT_CFOP))
		
		If QUERY->FT_TIPO == "D"
			If cCFOP < '5000'
				dbSelectArea("SD1")
				If dbSeek(QUERY->(FT_FILIAL+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
					dbSelectArea("SD2")//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					If dbSeek(SD1->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMORI))
						dbSelectArea("SF4")
						dbSeek(xFilial("SF4")+SD2->D2_TES)
						If SD2->D2_EMISSAO >= MV_PAR01 .And. SD2->D2_EMISSAO <= MV_PAR02
							TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + " DEVOL NO MES - " + SD2->D2_CF
							lDevol := .T.
						Else
							//Se a devolucao nao for dentro do mes, infrma a data da NF Saida
							TMPTRB->DTNFORI := SD2->D2_EMISSAO
						EndIf
						
						TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + IIF(SF4->F4_PISCOF$"1,2,3".AND.SF4->F4_PISCRED$"1,2".AND.(SD2->D2_VALIMP5+SD2->D2_VALIMP6)>0," S.TRIB"," ")
					EndIf
				EndIf
			Else
				dbSelectArea("SD2")
				If dbSeek(QUERY->(FT_FILIAL+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM))
					dbSelectArea("SD1")//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
					If dbSeek(SD2->(D2_FILIAL+D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEMORI))
						dbSelectArea("SF4")
						dbSeek(xFilial("SF4")+SD1->D1_TES)
						If SD1->D1_DTDIGIT >= MV_PAR01 .And. SD1->D1_DTDIGIT <= MV_PAR02
							TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + " DEVOL NO MES - " + SD1->D1_CF
							lDevol := .T.
						Else
							//Se a devolucao nao for dentro do mes, infrma a data da NF Saida
							TMPTRB->DTNFORI := SD1->D1_DTDIGIT
						EndIf
						TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + IIF(SF4->F4_PISCOF$"1,2,3".AND.SF4->F4_PISCRED$"1,2".AND.(SD1->D1_VALIMP5+SD1->D1_VALIMP6)>0," E.TRIB"," ")
					EndIf
				EndIf
			EndIf
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEncerra a gravacao do Registr                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		TMPTRB->(MsUnlock())
		cRegAnt := QUERY->(FT_FILIAL+FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCaso a nota seja uma devolucao dentro do mes, atualiza a contrapartida
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lDevol
			dbSelectArea("TMPTRB")
			If cCFOP < '5000'
				If dbSeek(SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM))
					RecLock("TMPTRB",.F.)
					TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + " DEVOL NO MES - " + cCFOP
					TMPTRB->(MsUnlock())
				EndIf
			Else
				If dbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM))
					RecLock("TMPTRB",.F.)
					TMPTRB->LINHA := AllTrim(TMPTRB->LINHA) + " DEVOL NO MES - " + cCFOP
					TMPTRB->(MsUnlock())
				EndIf
			EndIf
			
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณpassa para o pr๓ximo registro                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("QUERY")
		QUERY->(dbSkip())
		
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicializa o arquivo XML e define osณ
	//ณestilos que estarใo disponํveis paraณ
	//ณas linhas seguintes.                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	xmlInitFile(aEstilos)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine o cabe็alho da impressใo dos itensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCabec	:= {}
	
	Aadd(aCabec, { X3XTit('FT_FILIAL')   	,'FT_FILIAL'	,TAMSX3('FT_FILIAL')[3]		,TAMSX3('FT_FILIAL')[1]		,TAMSX3('FT_FILIAL')[2]		})
	Aadd(aCabec, { X3XTit('FT_NFISCAL')   	,'FT_NFISCAL'   ,TAMSX3('FT_NFISCAL')[3]	,TAMSX3('FT_NFISCAL')[1]	,TAMSX3('FT_NFISCAL')[2]	})
	Aadd(aCabec, { X3XTit('FT_NFELETR')   	,'FT_NFELETR'   ,TAMSX3('FT_NFELETR')[3]	,TAMSX3('FT_NFELETR')[1]	,TAMSX3('FT_NFELETR')[2]	})
	Aadd(aCabec, { X3XTit('FT_SERIE')   	,'FT_SERIE'   	,TAMSX3('FT_SERIE')[3]		,TAMSX3('FT_SERIE')[1]		,TAMSX3('FT_SERIE')[2]		})
	Aadd(aCabec, { X3XTit('FT_CLIEFOR')		,'FT_CLIEFOR'  	,TAMSX3('FT_CLIEFOR')[3]	,TAMSX3('FT_CLIEFOR')[1]	,TAMSX3('FT_CLIEFOR')[2]	})
	Aadd(aCabec, { X3XTit('FT_LOJA')		,'FT_LOJA'   	,TAMSX3('FT_LOJA')[3]		,TAMSX3('FT_LOJA')[1]		,TAMSX3('FT_LOJA')[2]		})
	Aadd(aCabec, { X3XTit('A2_NOME')		,'A2_NOME'   	,TAMSX3('A2_NOME')[3]		,TAMSX3('A2_NOME')[1]  		,TAMSX3('A2_NOME')[2]		}) // Alterado Nome
	Aadd(aCabec, { X3XTit('A1_CGC')			,'A1_CGC'   	,TAMSX3('A1_CGC')[3]		,TAMSX3('A1_CGC')[1]		,TAMSX3('A1_CGC')[2]		})
	Aadd(aCabec, { X3XTit('FT_ITEM')		,'FT_ITEM'   	,TAMSX3('FT_ITEM')[3]		,TAMSX3('FT_ITEM')[1]		,TAMSX3('FT_ITEM')[2]		})
	Aadd(aCabec, { X3XTit('FT_CFOP')   		,'FT_CFOP'   	,TAMSX3('FT_CFOP')[3]		,TAMSX3('FT_CFOP')[1]		,TAMSX3('FT_CFOP')[2]		})
	Aadd(aCabec, { X3XTit('D2_TES')   		,'D2_TES'   	,TAMSX3('D2_TES')[3]		,TAMSX3('D2_TES')[1]		,TAMSX3('D2_TES')[2]		})
	Aadd(aCabec, { X3XTit('X5_DESCRI')   	,'X5_DESCRI'   	,TAMSX3('X5_DESCRI')[3]		,TAMSX3('X5_DESCRI')[1]		,TAMSX3('X5_DESCRI')[2]		})
	Aadd(aCabec, { X3XTit('FT_CODBCC')   	,'FT_CODBCC'    ,TAMSX3('FT_CODBCC')[3]  	,TAMSX3('FT_CODBCC')[1]		,TAMSX3('FT_CODBCC')[2]		})
	Aadd(aCabec, { X3XTit('FT_CSTPIS')   	,'FT_CSTPIS'    ,TAMSX3('FT_CSTPIS')[3]  	,TAMSX3('FT_CSTPIS')[1]		,TAMSX3('FT_CSTPIS')[2]		})
	Aadd(aCabec, { X3XTit('FT_CSTCOF')   	,'FT_CSTCOF'   	,TAMSX3('FT_CSTCOF')[3]		,TAMSX3('FT_CSTCOF')[1]		,TAMSX3('FT_CSTCOF')[2]		})
	Aadd(aCabec, { X3XTit('FT_ALIQPIS')   	,'FT_ALIQPIS'   ,TAMSX3('FT_ALIQPIS')[3]	,TAMSX3('FT_ALIQPIS')[1]	,TAMSX3('FT_ALIQPIS')[2]	})
	Aadd(aCabec, { X3XTit('FT_ALIQCOF')   	,'FT_ALIQCOF'	,TAMSX3('FT_ALIQCOF')[3]	,TAMSX3('FT_ALIQCOF')[1]	,TAMSX3('FT_ALIQCOF')[2]	})
	Aadd(aCabec, { 'A1_XORGPUB'		   		,'A1_XORGPUB'   ,TAMSX3(cCPOOrgPub)[3]		,TAMSX3(cCPOOrgPub)[1]		,TAMSX3(cCPOOrgPub)[2]		})
	Aadd(aCabec, { 'LINHA'					,'LINHA'   		,'C'						,20							,0							})
	Aadd(aCabec, { X3XTit('FT_VALCONT')   	,'FT_VALCONT'	,TAMSX3('FT_VALCONT')[3]	,TAMSX3('FT_VALCONT')[1]	,TAMSX3('FT_VALCONT')[2]	})
	Aadd(aCabec, { X3XTit('E1_SALDO')   	,'E1_SALDO'		,TAMSX3('E1_SALDO')[3] 		,TAMSX3('E1_SALDO')[1] 		,TAMSX3('E1_SALDO')[2]		})
	Aadd(aCabec, { X3XTit('FT_TOTAL')   	,'FT_TOTAL'		,TAMSX3('FT_TOTAL')[3]		,TAMSX3('FT_TOTAL')[1]		,TAMSX3('FT_TOTAL')[2]		})
	Aadd(aCabec, { X3XTit('FT_BASEPIS')   	,'FT_BASEPIS'	,TAMSX3('FT_BASEPIS')[3]	,TAMSX3('FT_BASEPIS')[1]	,TAMSX3('FT_BASEPIS')[2]	})
	Aadd(aCabec, { X3XTit('FT_BASECOF')   	,'FT_BASECOF'  	,TAMSX3('FT_BASECOF')[3]	,TAMSX3('FT_BASECOF')[1]	,TAMSX3('FT_BASECOF')[2]	})
	Aadd(aCabec, { X3XTit('FT_VALPIS')   	,'FT_VALPIS'  	,TAMSX3('FT_VALPIS')[3]		,TAMSX3('FT_VALPIS')[1]		,TAMSX3('FT_VALPIS')[2]		})
	Aadd(aCabec, { X3XTit('FT_VALCOF')   	,'FT_VALCOF'   	,TAMSX3('FT_VALCOF')[3]		,TAMSX3('FT_VALCOF')[1]		,TAMSX3('FT_VALCOF')[2]		})
	Aadd(aCabec, { X3XTit('FT_VALIPI')   	,'FT_VALIPI'   	,TAMSX3('FT_VALIPI')[3]		,TAMSX3('FT_VALIPI')[1]		,TAMSX3('FT_VALIPI')[2]		})
	Aadd(aCabec, { X3XTit('FT_PRODUTO')		,'FT_PRODUTO'   ,TAMSX3('FT_PRODUTO')[3]	,TAMSX3('FT_PRODUTO')[1]	,TAMSX3('FT_PRODUTO')[2]	})
	Aadd(aCabec, { X3XTit('FT_NFORI')		,'FT_NFORI'   	,TAMSX3('FT_NFORI')[3]		,TAMSX3('FT_NFORI')[1]		,TAMSX3('FT_NFORI')[2]		})
	Aadd(aCabec, { 'DTNFORI'				,'DTNFORI'  	,TAMSX3('FT_ENTRADA')[3]	,TAMSX3('FT_ENTRADA')[1]	,TAMSX3('FT_ENTRADA')[2]	})
	Aadd(aCabec, { X3XTit('B1_POSIPI')		,'B1_POSIPI'   	,TAMSX3('B1_POSIPI')[3]		,TAMSX3('B1_POSIPI')[1]		,TAMSX3('B1_POSIPI')[2]		})
	Aadd(aCabec, { X3XTit('CG1_CODIGO')		,'CG1_CODIGO'   ,TAMSX3('CG1_CODIGO')[3]	,TAMSX3('CG1_CODIGO')[1]	,TAMSX3('CG1_CODIGO')[2]	})
	Aadd(aCabec, { X3XTit('CG1_ALIQ')		,'CG1_ALIQ'   	,TAMSX3('CG1_ALIQ')[3]		,TAMSX3('CG1_ALIQ')[1]		,TAMSX3('CG1_ALIQ')[2]		})
	Aadd(aCabec, { X3XTit('D2_TIPO')		,'D2_TIPO'   	,TAMSX3('D2_TIPO')[3]		,TAMSX3('D2_TIPO')[1]		,TAMSX3('D2_TIPO')[2]		})
	Aadd(aCabec, { X3XTit('D2_LOTECTL')		,'D2_LOTECTL'   ,TAMSX3('D2_LOTECTL')[3]	,TAMSX3('D2_LOTECTL')[1]	,TAMSX3('D2_LOTECTL')[2]	})
	Aadd(aCabec, { X3XTit('FT_ICMSRET')		,'FT_ICMSRET'   ,TAMSX3('FT_ICMSRET')[3]	,TAMSX3('FT_ICMSRET')[1]	,TAMSX3('FT_ICMSRET')[2]	})
	Aadd(aCabec, { X3XTit('FT_FRETE')		,'FT_FRETE'   	,TAMSX3('FT_FRETE')[3]		,TAMSX3('FT_FRETE')[1]		,TAMSX3('FT_FRETE')[2]		})
	Aadd(aCabec, { X3XTit('FT_SEGURO')		,'FT_SEGURO'   	,TAMSX3('FT_SEGURO')[3]		,TAMSX3('FT_SEGURO')[1]		,TAMSX3('FT_SEGURO')[2]		})
	Aadd(aCabec, { X3XTit('FT_DESPESA')		,'FT_DESPESA'   ,TAMSX3('FT_DESPESA')[3]	,TAMSX3('FT_DESPESA')[1]	,TAMSX3('FT_DESPESA')[2]	})
	Aadd(aCabec, { X3XTit('FT_DESCONT')		,'FT_DESCONT'   ,TAMSX3('FT_DESCONT')[3]	,TAMSX3('FT_DESCONT')[1]	,TAMSX3('FT_DESCONT')[2]	})
	
	Aadd(aCabec, { X3XTit('A1_NOME')		,'A1_NOME'   	,TAMSX3('A1_NOME')[3]		,TAMSX3('A1_NOME')[1]		,TAMSX3('A1_NOME')[2]		})
	Aadd(aCabec, { X3XTit('A1_NREDUZ')		,'A1_NREDUZ'   	,TAMSX3('A1_NREDUZ')[3]		,TAMSX3('A1_NREDUZ')[1]		,TAMSX3('A1_NREDUZ')[2]		})
	Aadd(aCabec, { X3XTit('A1_VEND')		,'A1_VEND'   	,TAMSX3('A1_VEND')[3]		,TAMSX3('A1_VEND')[1]		,TAMSX3('A1_VEND')[2]		})
	Aadd(aCabec, { X3XTit('A1_REGIAO')		,'A1_REGIAO'   	,TAMSX3('A1_REGIAO')[3]		,TAMSX3('A1_REGIAO')[1]		,TAMSX3('A1_REGIAO')[2]		})
	Aadd(aCabec, { X3XTit('A1_EST')			,'A1_EST'   	,TAMSX3('A1_EST')[3]		,TAMSX3('A1_EST')[1]		,TAMSX3('A1_EST')[2]		})
 //	Aadd(aCabec, { X3XTit('A1_XCLAS')		,'A1_XCLAS'   	,TAMSX3('A1_XCLAS')[3]		,TAMSX3('A1_XCLAS')[1]		,TAMSX3('A1_XCLAS')[2]		})
	Aadd(aCabec, { X3XTit('B1_DESC')		,'B1_DESC'   	,TAMSX3('B1_DESC')[3]		,TAMSX3('B1_DESC')[1]		,TAMSX3('B1_DESC')[2]		})
	Aadd(aCabec, { X3XTit('FT_BASEICM')		,'FT_BASEICM'   ,TAMSX3('FT_BASEICM')[3]	,TAMSX3('FT_BASEICM')[1]	,TAMSX3('FT_BASEICM')[2]	}) //Acrescentado
	Aadd(aCabec, { X3XTit('FT_VALICM')		,'FT_VALICM'   	,TAMSX3('FT_VALICM')[3]		,TAMSX3('FT_VALICM')[1]		,TAMSX3('FT_VALICM')[2]		})
    Aadd(aCabec, { X3XTit('FT_DIFAL' )  	,'FT_DIFAL'		,TAMSX3('FT_DIFAL')[3]		,TAMSX3('FT_DIFAL')[1]    	,TAMSX3('FT_DIFAL')[2]  	})
    Aadd(aCabec, { X3XTit('FT_VFCPDIF')   	,'FT_VFCPDIF'	,TAMSX3('FT_VFCPDIF')[3]	,TAMSX3('FT_VFCPDIF')[1]    ,TAMSX3('FT_VFCPDIF')[2]	})
    Aadd(aCabec, { X3XTit('FT_ICMSCOM')  	,'FT_ICMSCOM'	,TAMSX3('FT_ICMSCOM')[3]	,TAMSX3('FT_ICMSCOM')[1]    ,TAMSX3('FT_ICMSCOM')[2]  	})

	Aadd(aCabec, { X3XTit('FT_ISENICM')		,'FT_ISENICM'   ,TAMSX3('FT_ISENICM')[3]	,TAMSX3('FT_ISENICM')[1]	,TAMSX3('FT_ISENICM')[2]	})
    Aadd(aCabec, { X3XTit('FT_OUTRICM')  	,'FT_OUTRICM'	,TAMSX3('FT_OUTRICM')[3]	,TAMSX3('FT_OUTRICM')[1]    ,TAMSX3('FT_OUTRICM')[2]  	})
    Aadd(aCabec, { X3XTit('FT_ALIQICM')   	,'FT_ALIQICM'	,TAMSX3('FT_ALIQICM')[3]	,TAMSX3('FT_ALIQICM')[1]    ,TAMSX3('FT_ALIQICM')[2]	})
    Aadd(aCabec, { X3XTit('FT_CLASFIS')  	,'FT_CLASFIS'	,TAMSX3('FT_CLASFIS')[3]	,TAMSX3('FT_CLASFIS')[1]    ,TAMSX3('FT_CLASFIS')[2]  	})
    
    Aadd(aCabec, { X3XTit('A1_INSCR')		,'A1_INSCR'   	,TAMSX3('A1_INSCR')[3]		,TAMSX3('A1_INSCR')[1]		,TAMSX3('A1_INSCR')[2]		})
    Aadd(aCabec, { X3XTit('FT_ENTRADA')		,'FT_ENTRADA'   ,TAMSX3('FT_ENTRADA')[3]	,TAMSX3('FT_ENTRADA')[1]	,TAMSX3('FT_ENTRADA')[2]	})    

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGera uma planilha nova com base no alias aberto no momentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Resume1()
	dbSelectArea("RESUME")
	dbGoTop()
	xmlAddPlan("Resumido1"	,Titulo,,aCabec,1,,oProcess,2) //,6)
	
	Resume2()
	dbSelectArea("RESUME")
	dbGoTop()
	xmlAddPlan("Resumido2"	,Titulo,,aCabec,1,,oProcess,2) //,6)
	
	dbSelectArea("TMPTRB")
	dbGoTop()
	xmlAddPlan("Analitico"	,Titulo,,aCabec,1,,oProcess,2) //,6)
	
	ResumeDif()
	dbGoTop()
	dbSelectArea("RESUMEDIF")
	xmlAddPlan("a Diferir"	,Titulo,,aCabec,1,,oProcess,2) //,6)
	
	ResumeBLP()
	dbGoTop()
	dbSelectArea("RESUMEBLP")
	xmlAddPlan("BlocoP"	,Titulo,,aCabec,1,,oProcess,2) //,6)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFinaliza o arquivo .XMLณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	xmlCloseFile("Arquivo gerado com sucesso!")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Copia o arquivo do servidor para o remote                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ennvio para o Excel                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo)
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
	
Else
	Aviso("Aviso","Nใo foram encontrados registros que atendessem aos crit้rios de filtro.",{"OK"},,"Aten็ใo",,"BMPPERG")
	lRetorno := .F.
Endif

If Select("QUERY") > 0
	QUERY->(dbCloseArea())
EndIf

If Select("TMPTRB") > 0
	TMPTRB->(dbCloseArea())
EndIf

Return lRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Criador de perguntas para o SX1                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(cPerg,aRegs)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da Rotina                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local i 	:= 0
Local j 	:= 0
Local aArea := GetArea()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre a tabela de perguntas                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX1")
dbSetOrder(1)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processa o array para a gravacao se nao existir no SX1    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i:= 1 to Len(aRegs)
	If !dbSeek(Padr(cPerg,Len(X1_GRUPO))+aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to Len(aRegs[1])
			FieldPut(j,aRegs[i,j])
		Next j
		MsUnlock()
	EndIf
Next i

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVldValueบAutor  ณV. Greg๓rio         บ Data ณ  23/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe valor para o campo da tabela, se existir บฑฑ
ฑฑบ          ณ converte para o tipo do campo. Se nใo houver retorna o      บฑฑ
ฑฑบ          ณ CriaVar do campo.										   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EcoUrbis                                                    บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function	GetVldValue(xValor,nPos)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local xRetorno	:= Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica, segundo o tipo da variแvel,ณ
//ณse existe valor para ele. Se existir,ณ
//ณconverte o valor para o formato      ณ
//ณcorreto.                             ณ
//ณ                                     ณ
//ณSe nใo existir, retorna o CriaVar do ณ
//ณcampo.                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ValType(xValor)=='U'//se for nulo
	xRetorno	:= CriaVar(aCmpTmp[nPos][1],.F.)
ElseIf ValType(xValor)=='C'
	If Empty(Alltrim(xValor))
		xRetorno	:= CriaVar(aCmpTmp[nPos][1],.F.)
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConverter para o valorณ
		//ณpara o tipo do campo  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If aCmpTmp[nPos][2]=='C'
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRemover os Acentosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			xRetorno	:= xValor
		ElseIf aCmpTmp[nPos][2]=='N'
			xRetorno	:= xValor
		ElseIf aCmpTmp[nPos][2]=='D'
			xRetorno	:= STOD(xValor)
		ElseIf aCmpTmp[nPos][2]=='L'
			xRetorno	:= &(xValor)
		Endif
		
	Endif
	
ElseIf ValType(xValor)=='N'
	xRetorno	:= xValor
ElseIf aCmpTmp[nPos][2]=='D'
	xRetorno	:= xValor
ElseIf ValType(xValor)=='L'
	xRetorno	:= xValor
Endif

RestArea(aArea)

Return xRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออัออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณxmlInitFileบAutorณVinํcius Greg๓rio บ Data ณ 26/04/11 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออฯออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Inicializa o arquivo .xml                            บฑฑ
ฑฑบ          ณ                                                      บฑฑ
ฑฑบ          ณ aStyle - Array com a seguinte estrutura              บฑฑ
ฑฑบ          ณ     Nํvel 1: Determina qual o estilo (ID) de ref.    บฑฑ
ฑฑบ          ณ     Nํvel 2: Quais efeitos que serใo adicionados ao  บฑฑ
ฑฑบ          ณ     estilo referenciado no ID do estilo (nํvel 1)    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xmlInitFile(aStyle)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lRetorno 	:= .T.
Local nLoop		:= 0
Local nLoopStyle:= 0
Local cString	:= ''

cString	:= '<?xml version="1.0"?>'+CRLF
cString	+= '<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'+CRLF
If !Empty(aStyle)
	cString	+= '    <ss:Styles>'+CRLF
	For nLoop	:= 1 to Len(aStyle)
		cString	+= '        <ss:Style ss:ID="'+Alltrim(STR(nLoop))+'">'+CRLF
		cString	+= '            <ss:Font '
		For nLoopStyle := 1 to Len(aStyle[nLoop])
			cString	+= 'ss:'+aStyle[nLoop][nLoopStyle]+'="1" '
		Next nLoopStyle
		cString	+= '/>'+CRLF
		cString	+= '        </ss:Style>'+CRLF
	Next nLoop
	cString	+= '    </ss:Styles>'+CRLF
Endif

GrvArq(cString,@nHandle)

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออปฑฑ
ฑฑบPrograma  ณxmlAddPlan บAutor  ณVinํcius Greg๓rio บ Data ณ26/04/11 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para adicionar o conte๚do de um arquivo em uma บฑฑ
ฑฑบ          ณ planilha (worksheet).                                 บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ cWkSheet: Nome da Planilha                            บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ aPreSection: Array com a formata็ใo de uma pr้-se็ใo  บฑฑ
ฑฑบ          ณ antes da impressใo dos itens da tabela.               บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ aCabec: Cabe็alho dos itens que serใo impressos.      บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ nStyleID: ID do estilho do cabe็alho.                 บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ aFooter: Array com a formata็ใo de uma se็ใo de       บฑฑ
ฑฑบ          ณ rodap้.                                               บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ oProcess: refer๊ncia do objeto que deverแ ser atuali- บฑฑ
ฑฑบ          ณ zado conforme o progresso da gera็ใo de XML.          บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ nStyleCab: n๚mero do estilo que serแ utilizado para o บฑฑ
ฑฑบ          ณ cabe็alho da planilha.                                บฑฑ
ฑฑบ          ณ                                                       บฑฑ
ฑฑบ          ณ bFunction: Fun็ใo que serแ executada antes da         บฑฑ
ฑฑบ          ณ impressใo de cada linha de c๓digo.                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico                                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xmlAddPlan(cWkSheet,cTitulo,aPreSection,aCabec,nStyleID,aFooter,oProcess,nStyleCab,bFunction)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lRetorno		:= .T.
Local nLoop			:= 0
Local nTotReg		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแvel que armazena o nome da tabelaณ
//ณde trabalho para a impressใo do XML.  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cAlias		:= Alias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแvel que armazena o tamanho total das c้lulas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nTamTot		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosi็ใo dos campos no cabe็alhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nPosText		:= 1
Local nPosField		:= 2
Local nPosType		:= 3
Local nPosSize		:= 4
Local cString		:= ''

DEFAULT aCabec	:= {}

If Len(aCabec)==0
	ConOut("**xmlAddPlan: nใo foi informado corretamente o caba็alho para o xml!**")
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula o nTamTotณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop := 1 to Len(aCabec)
	nTamTot	+= 	aCabec[nLoop][nPosSize]
Next nLoop

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria็ใo da WorkSheetณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cString	:= '    <ss:Worksheet ss:Name="'+cWkSheet+'">'+CRLF
cString	+= '        <ss:Table>'+CRLF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclusใo da pr้-sectionณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//TODO: implementar essa funcionalidade

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de cabe็alho dos itens da tabela ativaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop	:= 1 to Len(aCabec)
	cString	+= '            <ss:Column ss:Width="'+Alltrim(STR(aCabec[nLoop][nPosSize]))+'"/>'+CRLF
Next nLoop

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressใo do tํtulo do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cTitulo)
	cString	+= '<ss:Row>'+CRLF
	If nStyleCab <> nil .and. ValType(nStyleCab)=='N'
		cString	+= '    	<ss:Cell ss:MergeAcross="'+Alltrim(STR(Len(aCabec)-1))+'" ss:StyleID="'+Alltrim(STR(nStyleCab))+'"><ss:Data ss:Type="String">'+cTitulo+'</ss:Data></ss:Cell>'+CRLF
	ElseIf nStyleId <> nil .and. ValType(nStyleId)=='N'
		cString	+= '    	<ss:Cell ss:MergeAcross="'+Alltrim(STR(Len(aCabec)-1))+'" ss:StyleID="'+Alltrim(STR(nStyleID))+'"><ss:Data ss:Type="String">'+cTitulo+'</ss:Data></ss:Cell>'+CRLF
	Else
		cString	+= '    	<ss:Cell ss:MergeAcross="'+Alltrim(STR(Len(aCabec)-1))+'"><ss:Data ss:Type="String">'+cTitulo+'</ss:Data></ss:Cell>'+CRLF
	Endif
	cString	+= '</ss:Row>'+CRLF
EndIf

GrvArq(cString,@nHandle)

If nStyleID <> nil .and. ValType(nStyleID)=='N'
	cString	:= '           <ss:Row ss:StyleID="'+Alltrim(STR(nStyleID))+'">'+CRLF
Else
	cString	:= '            <ss:Row>'+CRLF
Endif

For nLoop	:= 1 to Len(aCabec)
	cString	+= '                <ss:Cell>'+CRLF
	cString	+= '                    <ss:Data ss:Type="String">'+aCabec[nLoop][nPosText]+'</ss:Data>'+CRLF
	cString	+= '                </ss:Cell>'+CRLF
Next nLoop

cString	+= '            </ss:Row>'+CRLF

GrvArq(cString,@nHandle)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
(cAlias)->(dbEval({|| nTotReg++},,{|| !EOF()}))
(cAlias)->(dbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Retorna a rotina caso nใo tenha encontrado registros                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nTotReg == 0
	
	//Aviso(Titulo,OemToAnsi("Nใo hแ informa็๕es a serem geradas para esta planilha.("+ALLTRIM(cWkSheet)+")"),{"Ok"},,"Sem Dados")
	
	cString	:= '        </ss:Table>'+CRLF
	cString	+= '    </ss:Worksheet>'+CRLF
	
	GrvArq(cString,@nHandle)
	
	Return Nil
EndIf

oProcess:SetRegua2(nTotReg)

Do While !(cAlias)->(EOF())
	
	oProcess:IncRegua2("Gerando Planilha... ("+cWkSheet+")")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta a fun็ใo parametrizada antes da impressใo da linha.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If bFunction <> nil
		Eval(bFunction)
	Endif
	
	cString	:= '            <ss:Row>'+CRLF
	For nLoop	:= 1 to Len(aCabec)
		cString	+= '                <ss:Cell>'+CRLF
		If aCabec[nLoop][nPosType]=="C"
			cString	+= '	                    <ss:Data ss:Type="String">'+(cAlias)->&(aCabec[nLoop][nPosField])+'</ss:Data>'+CRLF
		ElseIf aCabec[nLoop][nPosType]=="N"
			cString	+= '	                    <ss:Data ss:Type="Number">'+Alltrim(STR((cAlias)->&(aCabec[nLoop][nPosField])))+'</ss:Data>'+CRLF
		ElseIf aCabec[nLoop][nPosType]=="D"
			cString	+= '	                    <ss:Data ss:Type="String">'+DTOC((cAlias)->&(aCabec[nLoop][nPosField]))+'</ss:Data>'+CRLF
		Endif
		cString	+= '                </ss:Cell>'+CRLF
	Next nLoop
	cString	+= '            </ss:Row>'+CRLF
	
	GrvArq(cString,@nHandle)
	
	(cAlias)->(dbSkip())
EndDo

cString	:= '        </ss:Table>'+CRLF
cString	+= '    </ss:Worksheet>'+CRLF

GrvArq(cString,@nHandle)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressใo do rodap้ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//TODO: Implementar essa funcionalidade

Return lRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณxmlCloseFileบAutorณVinํcius Greg๓rio บ Data ณ  26/04/11  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha o arquivo .xml                                    บฑฑ
ฑฑบ          ณ                                                         บฑฑ
ฑฑบ          ณ cMsg: Mensagem exibida para o usuแrio ap๓s o t้rmino.   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xmlCloseFile(cMsg)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lRetorno	:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha a estrutura l๓gica do  ณ
//ณarquivo XML. Fecha o arquivo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
GrvArq('</ss:Workbook>',@nHandle,.T.)

MsgInfo(cMsg)

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออหอออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvArq บAutorณVinํcius Greg๓rio บ Data ณ  11/05/10   บฑฑ
ฑฑฬออออออออออุอออออออสอออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava็ใo dos textos no arquivo .xml                 บฑฑ
ฑฑบ          ณ                                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico                                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvArq(cText, nHdl, lClose)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDirDocs  	:= "\system\"//MsDocPath()
Local cBarra 		:= If(IsSrvUnix(), "/", "\")

DEFAULT lClose 		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo na primeira vez que irแ gravar um textoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nHdl==0
	
	cArquivo := cArquivo+".xml"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera o arquivo em formato .CSV                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nHdl := FCreate(cDirDocs + cBarra + cArquivo)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o arquivo foi gerado corretamente                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nHdl == -1
		MsgStop("Nใo foi possํvel criar o arquivo .xml para ser utilizado com o Excel. Verifique as permiss๕es.")
		Return Nil
	EndIf
	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava็ใo do novo arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fwrite(nHdl, cText)
cText := ""

If lClose
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณfecha o arquivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fclose(nHdl)
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณX3XTit    บAutor  ณVinํcius Greg๓rio   บ Data ณ  16/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que pega a descri็ใo do campo no X3 sem precisar    บฑฑ
ฑฑบ          ณ posicionar no registro.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ PARAMETROS:                                                บฑฑ
ฑฑบ          ณ cCampo: Qual o campo do dicionแrio que irแ retornar o nome.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ RETORNO:                                                   บฑฑ
ฑฑบ          ณ cRetorno: Descri็ใo do campo no dicionแrio.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function X3XTit(cCampo)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local cRetorno	:= ""

dbSelectArea('SX3')
dbSetOrder(2)
If dbSeek(cCampo,.F.)
	
	cRetorno	:= SX3->X3_TITULO
	
Endif

RestArea(aArea)
Return cRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM09R002   บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Resume1()

Local aInd			:= {}
Local nHandle   	:= 0

Private cArqTrb4	:= ""
Private cArqTrb5	:= ""
Private cArquivo2  	:= CriaTrab(,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo temporario                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("RESUME") > 0
	dbSelectArea("RESUME")
	RESUME->(dbCloseArea())
EndIf

cArqTrb4 := CriaTrab(aCmpTmp,.T.)
dbUseArea(.T.,"DBFCDX",cArqTrb4,"RESUME",.T.,.F.)

dbSelectArea("RESUME")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aInd,{CriaTrab(Nil,.F.),"FT_CFOP+X5_DESCRI+FT_CODBCC+FT_CSTPIS+FT_CSTCOF+STR(FT_ALIQPIS,6,2)+STR(FT_ALIQCOF,6,2)+A1_XORGPUB+LINHA","Cfop + Descr.CFO + CST + Aliq"})
For nA := 1 to Len(aInd)
	IndRegua("RESUME",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando ํndice temporแrio...") )
Next nA

DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

dbSelectArea("TMPTRB")
dbGoTop()
While !Eof()
	
	dbSelectArea("RESUME")
	If dbSeek(TMPTRB->(FT_CFOP+X5_DESCRI+FT_CODBCC+FT_CSTPIS+FT_CSTCOF)+STR(TMPTRB->FT_ALIQPIS,6,2)+STR(TMPTRB->FT_ALIQCOF,6,2)+TMPTRB->A1_XORGPUB+TMPTRB->LINHA)
		RecLock("RESUME",.F.)
	Else
		RecLock("RESUME",.T.)
		RESUME->FT_CFOP    := TMPTRB->FT_CFOP
		RESUME->X5_DESCRI  := TMPTRB->X5_DESCRI
		RESUME->FT_CODBCC  := TMPTRB->FT_CODBCC
		RESUME->FT_CSTPIS  := TMPTRB->FT_CSTPIS
		RESUME->FT_CSTCOF  := TMPTRB->FT_CSTCOF
		RESUME->FT_ALIQPIS := TMPTRB->FT_ALIQPIS
		RESUME->FT_ALIQCOF := TMPTRB->FT_ALIQCOF
		RESUME->A1_XORGPUB := TMPTRB->A1_XORGPUB
		RESUME->LINHA      := TMPTRB->LINHA
	EndIf
	RESUME->A2_NOME := Posicione("SA2",1,xFilial("SA2")+TMPTRB->FT_CLIEFOR+TMPTRB->FT_LOJA,"A2_NOME") //Alterado Nome
	
	RESUME->FT_VALCONT += TMPTRB->FT_VALCONT
	RESUME->E1_SALDO   += TMPTRB->E1_SALDO
	RESUME->FT_TOTAL   += TMPTRB->FT_TOTAL
	RESUME->FT_BASEPIS += TMPTRB->FT_BASEPIS
	RESUME->FT_BASECOF += TMPTRB->FT_BASECOF
	RESUME->FT_VALPIS  += TMPTRB->FT_VALPIS
	RESUME->FT_VALCOF  += TMPTRB->FT_VALCOF
	RESUME->FT_VALIPI  += TMPTRB->FT_VALIPI
	
	RESUME->FT_ICMSRET += TMPTRB->FT_ICMSRET
	RESUME->FT_FRETE   += TMPTRB->FT_FRETE
	RESUME->FT_SEGURO  += TMPTRB->FT_SEGURO
	RESUME->FT_DESPESA += TMPTRB->FT_DESPESA
	RESUME->FT_DESCONT += TMPTRB->FT_DESCONT
	
	RESUME->FT_BASEICM 	+= TMPTRB->FT_BASEICM
	RESUME->FT_VALICM 	+= TMPTRB->FT_VALICM
	RESUME->FT_DIFAL 	+= TMPTRB->FT_DIFAL
	RESUME->FT_VFCPDIF 	+= TMPTRB->FT_VFCPDIF
	RESUME->FT_ICMSCOM 	+= TMPTRB->FT_ICMSCOM
	
	RESUME->FT_ISENICM 	+= TMPTRB->FT_ISENICM
	RESUME->FT_OUTRICM 	+= TMPTRB->FT_OUTRICM
	                                                   
	RESUME->(MsUnlock())
	
	dbSelectArea("TMPTRB")
	dbSkip()
EndDo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM09R002   บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Resume2()

Local aInd			:= {}
Local nHandle   	:= 0

Private cArqTrb4	:= ""
Private cArqTrb5	:= ""
Private cArquivo2  	:= CriaTrab(,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo temporario                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("RESUME") > 0
	dbSelectArea("RESUME")
	RESUME->(dbCloseArea())
EndIf

cArqTrb4 := CriaTrab(aCmpTmp,.T.)
dbUseArea(.T.,"DBFCDX",cArqTrb4,"RESUME",.T.,.F.)

dbSelectArea("RESUME")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aInd,{CriaTrab(Nil,.F.),"FT_CFOP+X5_DESCRI+FT_CODBCC+FT_CSTPIS+FT_CSTCOF+STR(FT_ALIQPIS,6,2)+STR(FT_ALIQCOF,6,2)+A1_XORGPUB+LINHA+FT_PRODUTO+D2_LOTECTL","Cfop + Descr.CFO + CST + Aliq"})
For nA := 1 to Len(aInd)
	IndRegua("RESUME",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando ํndice temporแrio...") )
Next nA

DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

dbSelectArea("TMPTRB")
dbGoTop()
While !Eof()
	
	dbSelectArea("RESUME")
	If dbSeek(TMPTRB->(FT_CFOP+X5_DESCRI+FT_CODBCC+FT_CSTPIS+FT_CSTCOF)+STR(TMPTRB->FT_ALIQPIS,6,2)+STR(TMPTRB->FT_ALIQCOF,6,2)+TMPTRB->A1_XORGPUB+TMPTRB->LINHA+TMPTRB->FT_PRODUTO+TMPTRB->D2_LOTECTL)
		RecLock("RESUME",.F.)
	Else
		RecLock("RESUME",.T.)
		RESUME->FT_CFOP    := TMPTRB->FT_CFOP
		RESUME->X5_DESCRI  := TMPTRB->X5_DESCRI
		RESUME->FT_CODBCC  := TMPTRB->FT_CODBCC
		RESUME->FT_CSTPIS  := TMPTRB->FT_CSTPIS
		RESUME->FT_CSTCOF  := TMPTRB->FT_CSTCOF
		RESUME->FT_ALIQPIS := TMPTRB->FT_ALIQPIS
		RESUME->FT_ALIQCOF := TMPTRB->FT_ALIQCOF
		RESUME->A1_XORGPUB := TMPTRB->A1_XORGPUB
		RESUME->LINHA      := TMPTRB->LINHA
		RESUME->FT_PRODUTO := TMPTRB->FT_PRODUTO
		RESUME->D2_LOTECTL := TMPTRB->D2_LOTECTL
	EndIf
	
	RESUME->A2_NOME := Posicione("SA2",1,xFilial("SA2")+TMPTRB->FT_CLIEFOR+TMPTRB->FT_LOJA,"A2_NOME") //Alterado Nome
	RESUME->FT_VALCONT += TMPTRB->FT_VALCONT
	RESUME->E1_SALDO   += TMPTRB->E1_SALDO
	RESUME->FT_TOTAL   += TMPTRB->FT_TOTAL
	RESUME->FT_BASEPIS += TMPTRB->FT_BASEPIS
	RESUME->FT_BASECOF += TMPTRB->FT_BASECOF
	RESUME->FT_VALPIS  += TMPTRB->FT_VALPIS
	RESUME->FT_VALCOF  += TMPTRB->FT_VALCOF
	RESUME->FT_VALIPI  += TMPTRB->FT_VALIPI
	RESUME->FT_ICMSRET += TMPTRB->FT_ICMSRET
	RESUME->FT_FRETE   += TMPTRB->FT_FRETE
	RESUME->FT_SEGURO  += TMPTRB->FT_SEGURO
	RESUME->FT_DESPESA += TMPTRB->FT_DESPESA
	RESUME->FT_DESCONT += TMPTRB->FT_DESCONT
	
	RESUME->FT_BASEICM 	+= TMPTRB->FT_BASEICM
	RESUME->FT_VALICM 	+= TMPTRB->FT_VALICM
	RESUME->FT_DIFAL 	+= TMPTRB->FT_DIFAL
	RESUME->FT_VFCPDIF 	+= TMPTRB->FT_VFCPDIF
	RESUME->FT_ICMSCOM 	+= TMPTRB->FT_ICMSCOM

	RESUME->FT_ISENICM 	+= TMPTRB->FT_ISENICM
	RESUME->FT_OUTRICM 	+= TMPTRB->FT_OUTRICM
	
	
	RESUME->(MsUnlock())
	
	dbSelectArea("TMPTRB")
	dbSkip()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM09R002   บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResumeDif()

Local aInd			:= {}
Local nHandle   	:= 0

Private cArqTrb6	:= ""
Private cArqTrb7	:= ""
Private cArquivo3  	:= CriaTrab(,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo temporario                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("RESUMEDIF") > 0
	dbSelectArea("RESUMEDIF")
	RESUMEDIF->(dbCloseArea())
EndIf

cArqTrb6 := CriaTrab(aCmpTmp,.T.)
dbUseArea(.T.,"DBFCDX",cArqTrb6,"RESUMEDIF",.T.,.F.)

dbSelectArea("RESUMEDIF")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aInd,{CriaTrab(Nil,.F.),"A1_CGC+FT_CSTPIS+FT_CSTCOF+STR(FT_ALIQPIS,6,2)+STR(FT_ALIQCOF,6,2)+A1_XORGPUB+LINHA","CGC + Aliq"})
For nA := 1 to Len(aInd)
	IndRegua("RESUMEDIF",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando ํndice temporแrio...") )
Next nA

DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

dbSelectArea("TMPTRB")
dbGoTop()
While !Eof()
	
	If !(TMPTRB->A1_XORGPUB $ "1/S") .Or.;
		!(AllTrim(TMPTRB->LINHA) $ "FAT.CUM/FAT.NCUM")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("RESUMEDIF")
	If dbSeek(TMPTRB->(A1_CGC+FT_CSTPIS+FT_CSTCOF)+STR(TMPTRB->FT_ALIQPIS,6,2)+STR(TMPTRB->FT_ALIQCOF,6,2)+TMPTRB->A1_XORGPUB+TMPTRB->LINHA)
		RecLock("RESUMEDIF",.F.)
	Else
		RecLock("RESUMEDIF",.T.)
		RESUMEDIF->A1_CGC     := TMPTRB->A1_CGC
		RESUMEDIF->FT_CSTPIS  := TMPTRB->FT_CSTPIS
		RESUMEDIF->FT_CSTCOF  := TMPTRB->FT_CSTCOF
		RESUMEDIF->FT_ALIQPIS := TMPTRB->FT_ALIQPIS
		RESUMEDIF->FT_ALIQCOF := TMPTRB->FT_ALIQCOF
		RESUMEDIF->A1_XORGPUB := TMPTRB->A1_XORGPUB
		RESUMEDIF->LINHA      := TMPTRB->LINHA
	EndIf
	
	RESUMEDIF->A2_NOME := Posicione("SA2",1,xFilial("SA2")+TMPTRB->FT_CLIEFOR+TMPTRB->FT_LOJA,"A2_NOME") //Alterado Nome
	RESUMEDIF->FT_VALCONT += TMPTRB->FT_VALCONT
	RESUMEDIF->E1_SALDO   += TMPTRB->E1_SALDO
	RESUMEDIF->FT_VALPIS  += TMPTRB->((E1_SALDO*FT_ALIQPIS)/100)
	RESUMEDIF->FT_VALCOF  += TMPTRB->((E1_SALDO*FT_ALIQCOF)/100)
	RESUMEDIF->FT_VALIPI  += TMPTRB->FT_VALIPI
	RESUMEDIF->FT_ICMSRET += TMPTRB->FT_ICMSRET
	RESUMEDIF->FT_FRETE   += TMPTRB->FT_FRETE
	RESUMEDIF->FT_SEGURO  += TMPTRB->FT_SEGURO
	RESUMEDIF->FT_DESPESA += TMPTRB->FT_DESPESA
	RESUMEDIF->FT_DESCONT += TMPTRB->FT_DESCONT
	
	RESUMEDIF->FT_BASEICM 	+= TMPTRB->FT_BASEICM
	RESUMEDIF->FT_VALICM 	+= TMPTRB->FT_VALICM
	RESUMEDIF->FT_DIFAL 	+= TMPTRB->FT_DIFAL
	RESUMEDIF->FT_VFCPDIF 	+= TMPTRB->FT_VFCPDIF
	RESUMEDIF->FT_ICMSCOM 	+= TMPTRB->FT_ICMSCOM

	RESUMEDIF->FT_ISENICM 	+= TMPTRB->FT_ISENICM
	RESUMEDIF->FT_OUTRICM 	+= TMPTRB->FT_OUTRICM

	
	RESUMEDIF->(MsUnlock())
	
	dbSelectArea("TMPTRB")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRemove os registros com saldo zerado ao final do mes     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("RESUMEDIF")
dbGoTop()
While !Eof()
	
	If RESUMEDIF->E1_SALDO == 0
		RecLock("RESUMEDIF")
		RESUMEDIF->(dbDelete())
		MsUnlock()
	EndIf
	
	dbSelectArea("RESUMEDIF")
	dbSkip()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSubRetBX  บAutor  ณElias Reis          บ Data ณ10/05/2012   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o valor dos titulos de retencao baixados para o tituบฑฑ
ฑฑบ          ณlo posicionado em questao                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SubRetBX()

Local aAreaSE1  := SE1->(GetArea())
Local aArea	    := GetArea()
Local nRet      := 0

Local cPrefixo  := SE1->E1_PREFIXO
Local cNumero   := SE1->E1_NUM
Local cCliente  := SE1->E1_CLIENTE
Local cLoja     := SE1->E1_LOJA
Local nMoeda    := SE1->E1_MOEDA
Local dData     := MV_PAR02

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+cPrefixo+cNumero)
	While !Eof();
		.And. SE1->E1_FILIAL  == xFilial("SE1");
		.And. SE1->E1_PREFIXO == cPrefixo;
		.And. SE1->E1_NUM     == cNumero;
		.And. SE1->E1_CLIENTE == cCliente;
		.And. SE1->E1_LOJA    == cLoja
		
		If SE1->E1_TIPO $ MVPIABT;//Pis
			.Or. SE1->E1_TIPO $ MVCFABT;//Cofins
			.Or. SE1->E1_TIPO $ MVCSABT;//Csll
			.Or. SE1->E1_TIPO $ MVIRABT;//Irrf
			.Or. SE1->E1_TIPO $ MVINABT;//Inss
			.Or. SE1->E1_TIPO $ MVISABT//Iss
			If SE1->E1_BAIXA <= dData
				nRet += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,dData)
			EndIf
		EndIf
		
		DbSelectArea("SE1")
		dbSkip()
	Enddo
EndIf

RestArea(aAreaSe1)
RestArea(aArea)

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณResumeBLP บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResumeBLP()

Local aInd				:= {}
Local nHandle   		:= 0

Private cArqTrb6a		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo temporario                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("RESUMEBLP") > 0
	dbSelectArea("RESUMEBLP")
	RESUMEBLP->(dbCloseArea())
EndIf

cArqTrb6a := CriaTrab(aCmpTmp,.T.)
dbUseArea(.T.,"DBFCDX",cArqTrb6a,"RESUMEBLP",.T.,.F.)

dbSelectArea("RESUMEBLP")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aInd,{CriaTrab(Nil,.F.),"FT_FILIAL+CG1_CODIGO+B1_POSIPI+FT_CFOP+STR(CG1_ALIQ,6,2)+D2_TES","Coigo+PosIPI+CFOP+TES"})
For nA := 1 to Len(aInd)
	IndRegua("RESUMEBLP",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando ํndice temporแrio...") )
Next nA

DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

dbSelectArea("TMPTRB")
dbGoTop()
While !Eof()
	
	dbSelectArea("RESUMEBLP")
	If dbSeek(TMPTRB->(FT_FILIAL+CG1_CODIGO+B1_POSIPI+FT_CFOP)+STR(TMPTRB->CG1_ALIQ,6,2)+D2_TES)
		RecLock("RESUMEBLP",.F.)
	Else
		RecLock("RESUMEBLP",.T.)
		RESUMEBLP->FT_FILIAL	:= TMPTRB->FT_FILIAL
		RESUMEBLP->CG1_CODIGO	:= TMPTRB->CG1_CODIGO
		RESUMEBLP->B1_POSIPI	:= TMPTRB->B1_POSIPI
		RESUMEBLP->FT_CFOP		:= TMPTRB->FT_CFOP
		RESUMEBLP->X5_DESCRI  	:= TMPTRB->X5_DESCRI
		RESUMEBLP->D2_TES		:= TMPTRB->D2_TES
		RESUMEBLP->CG1_ALIQ		:= TMPTRB->CG1_ALIQ
	EndIf
	
	RESUMEBLP->FT_VALCONT		+= TMPTRB->FT_VALCONT
	RESUMEBLP->FT_VALIPI		+= TMPTRB->FT_VALIPI
	RESUMEBLP->E1_SALDO			+= (TMPTRB->FT_VALCONT - TMPTRB->FT_VALIPI)

	MsUnlock()
	
	dbSelectArea("TMPTRB")
	dbSkip()
EndDo

Return
