#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  M320FILNF  บAutor  ณHelio Ferreira      บ Data ณ  30/09/22   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para filtrar produtos que nใo devem ter   บฑฑ
ฑฑบ          ณ seu custo standard reprocessados                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ A็os Macom                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑบ Chamada do PE no fonte padrใo, MATA320.prx                            ฑฑบ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//
//      While !EOF() .And. B1_FILIAL == xFilial("SB1")
// 			If (oTProces<>Nil)
// 				oTProces:IncRegua1( STR0030 + aFilsCalc[ nForFilial, 2 ] + " - " + aFilsCalc[ nForFilial, 3 ] ) // "Processando Filial:  "
// 			Else
// 				IncProc( STR0030 + aFilsCalc[ nForFilial, 2 ] + " - " + aFilsCalc[ nForFilial, 3 ] ) // "Processando Filial:  "
// 			EndIf
// 			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// 			//ณ Filtra os tipos e grupos selecionados                               ณ
// 			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 			If B1_TIPO < mv_par06 .Or. B1_TIPO > mv_par07 .Or. B1_GRUPO < mv_par08 .Or. B1_GRUPO > mv_par09
// 				dbSkip()
// 				Loop
// 			EndIf
// 			dbSelectArea("SD1")
// 			dbSeek(xFilial("SD1")+SB1->B1_COD+Replicate("z",LEN(SD1->D1_LOCAL)),.T.)
// 			dbSkip(-1)
// 			aCusto:={}
// 			While !Bof() .And. D1_FILIAL+D1_COD == xFilial("SD1")+SB1->B1_COD
// 				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// 				//ณ Ponto de Entrada utizado para customizacoes do filtro 					ณ
// 				//ณ do Calculo do custo de Reposicao para a Ultimo Custo de Compra.     ณ
// 				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 				If lM320FilNF
// 			   		lContinua := ExecBlock("M320FILNF",.F.,.F.)
// 				   	If Valtype(lContinua) <> "L"
// 				   		lContinua := .T.
// 				   	EndIf
// 				Else
// 					lContinua := .T.
// 				EndIf
// 			   	If lContinua
// 					If SD1->D1_TIPO == "N" .And. SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES)) .And. SF4->F4_ESTOQUE == "S" .And. SF4->F4_UPRC <> 'N'
// 						nCusto:=&("D1_CUSTO"+If(mv_par01==1," ",Str(mv_par01,1,0))) / SD1->D1_QUANT
// 						If nCusto > 0
// 							AADD(aCusto,{nCusto,SD1->D1_DTDIGIT,SD1->D1_NUMSEQ})
// 						EndIf
// 					EndIf
// 				EndIf
// 				dbSkip(-1)
// 			End
// 			If Len(aCusto) > 0
// 				ASORT(aCusto,,,{ |x,y| dtos(x[2])+x[3] < dtos(y[2])+y[3]})
// 				If RetArqProd(SB1->B1_COD)
// 					RecLock("SB1",.F.)
// 					Replace B1_CUSTD   With aCusto[Len(aCusto),1]
// 					Replace B1_MCUSTD  With Str(mv_par01,1,0)
// 					Replace B1_UCALSTD With dDatabase
// 					Replace B1_DATREF  With aCusto[Len(aCusto),2]
// 					MsUnLock()
// 				Else
// 					RecLock("SBZ",.F.)
// 					Replace BZ_CUSTD   With aCusto[Len(aCusto),1]
// 					Replace BZ_MCUSTD  With Str(mv_par01,1,0)
// 					Replace BZ_UCALSTD With dDatabase
// 					Replace BZ_DATREF  With aCusto[Len(aCusto),2]
// 					MsUnLock()
// 					dbSelectArea("SB1")
// 				EndIf
// 				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// 				//ณ Executa Ponto de Entrada                                        ณ
// 				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 				If lA320Custd
// 					ExecBlock("A320CUST",.F.,.F.,{SB1->B1_COD,aCusto[Len(aCusto),1],cTipo})
// 				EndIf
// 			EndIf
// 			dbSelectArea("SB1")
// 			dbSkip()
// 		EndDo

User Function M320FILNF()
	Local _Retorno := .T.

	If !Empty(SB1->B1_XDTCUSS)
		If SD1->D1_DTDIGIT < SB1->B1_XDTCUSS
			_Retorno := .F.
		EndIf
	EndIf

Return _Retorno

