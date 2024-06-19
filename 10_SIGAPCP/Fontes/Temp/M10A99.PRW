#INCLUDE "TOTVS.CH"
#Include 'RptDef.ch'
#include 'TBICONN.ch'
#Include 'Protheus.ch'
#include 'TOPCONN.CH'

User Function M10A99()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Numero de Série para Mobiliário                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||M10A99A()},"Processa criação de Número de Série para Mobiliário")

Return

Static Function M10A99A

//Local aArea     := GetArea()
//Local aAreaZAB  := ZAB->(GetArea())
Local nProc

cQuery := "SELECT B1_COD, B2_LOCAL, sum(B2_QATU) SALDO, "
cQuery += "(SELECT COUNT(*) FROM ZAB010 WHERE ZAB_FILIAL = ' ' AND ZAB_CODPRO = B1_COD AND D_E_L_E_T_ <> '*') QTDZAB, "
cQuery += "(SELECT MAX(C2_NUM+C2_SEQUEN+C2_ITEM) FROM SC2010 WHERE C2_FILIAL = '01' AND C2_PRODUTO = B1_COD AND D_E_L_E_T_ <> '*') ULT_OP "
cQuery += "FROM SB1010 SB1 JOIN SB2010 SB2 ON B1_COD = B2_COD WHERE  B1_FILIAL = '' and SB1.D_E_L_E_T_<>'*' and B2_FILIAL = '01' and SB2.D_E_L_E_T_<>'*' and B1_XFAMILI = '000003' and B1_TIPO ='PA' and B2_QATU > 0 "
cQuery += "GROUP BY B1_COD, B2_LOCAL, B2_QATU "
cQuery += "ORDER BY B1_COD, B2_QATU DESC "

TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())

//nSeq := 0
nSeq := 1050

ProcRegua(1000)

	While !Eof() 

		IncProc("Incluindo registro na ZAB:"+SD3->D3_FILIAL)

		For nProc := 1 To QUERY->SALDO

			nSeq ++
			_cNumSer := "M"+"J"+StrZero(nSeq,6)+"D"

			Reclock("ZAB",.T.)
			ZAB->ZAB_FILIAL := xFilial("ZAB")
			ZAB->ZAB_NUMSER	:= _cNumSer
			ZAB->ZAB_CODPRO	:= QUERY->B1_COD
			ZAB->ZAB_NUMOP	:= Left(QUERY->ULT_OP,6)
			ZAB->ZAB_ITEMOP	:= Substr(QUERY->ULT_OP,7,2)
			ZAB->ZAB_SEQOP	:= Substr(QUERY->ULT_OP,9,3)
			ZAB->(MsUnlock())

		Next

		dbSelectArea("QUERY")
		dbSkip()
	EndDo

MsgStop("Não é possível a geração de Número(s) de Série, para Ordem de Produção Encerrada ou Iniciada ", "Atenção")

Return
