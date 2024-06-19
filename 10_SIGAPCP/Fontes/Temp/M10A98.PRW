#INCLUDE "TOTVS.CH"
#Include 'RptDef.ch'
#include 'TBICONN.ch'
#Include 'Protheus.ch'
#include 'TOPCONN.CH'

User Function M10A98()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Numero de Série para Mobiliário                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||M10A98A()},"Processa criação de Número de Série para Mobiliário")

Return

Static Function M10A98A

//Local aArea     := GetArea()
//Local aAreaZAB  := ZAB->(GetArea())
Local nProc

cQuery := "SELECT C2_PRODUTO,B1_XFAMILI, C2_NUM, C2_ITEM, C2_SEQUEN, C2_QUANT-C2_QUJE SALDO "
cQuery += " FROM SC2010 as SC2 "
cQuery += " Join SB1010 as SB1 "
cQuery += " ON C2_PRODUTO = B1_COD "
cQuery += " WHERE B1_XFAMILI = '000003' and " 
cQuery += " B1_FILIAL = '' and " 
cQuery += " SB1.D_E_L_E_T_ <> '*' and " 
cQuery += " C2_QUJE < C2_QUANT and " 
cQuery += " C2_EMISSAO > 20240101 and "
cQuery += " C2_FILIAL = '01' and " 
cQuery += " SC2.D_E_L_E_T_ <> '*' "
cQuery += " AND C2_PRODUTO <> 'REQUISICAO' "

TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())

nSeq := 0

ProcRegua(1000)

	While !Eof() 

		IncProc("Incluindo registro na ZAB:"+SD3->D3_FILIAL)

		For nProc := 1 To QUERY->SALDO

			nSeq ++
			_cNumSer := "M"+"J"+StrZero(nSeq,6)+"D"

			Reclock("ZAB",.T.)
			ZAB->ZAB_FILIAL :=  xFilial("ZAB")
			ZAB->ZAB_NUMSER	:= _cNumSer
			ZAB->ZAB_CODPRO	:= QUERY->C2_PRODUTO
			ZAB->ZAB_NUMOP	:= QUERY->C2_NUM
			ZAB->ZAB_ITEMOP	:= QUERY->C2_ITEM
			ZAB->ZAB_SEQOP	:= QUERY->C2_SEQUEN
			ZAB->(MsUnlock())

		Next

		dbSelectArea("QUERY")
		dbSkip()
	EndDo

MsgStop("Não é possível a geração de Número(s) de Série, para Ordem de Produção Encerrada ou Iniciada ", "Atenção")

Return
