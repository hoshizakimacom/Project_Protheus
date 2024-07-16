#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
#include "protheus.ch"

User Function MT250TOK()
  
Local lRet  	:= .T.
Local aArea     := GetArea()
Local aAreaSD3  := SD3->(GetArea())
Local aAreaZAB  := ZAB->(GetArea())
Local cFamili	:= Posicione("SB1",1, xFilial("SB1") + M->D3_COD, "B1_XFAMILI")

//+---------------------------------------+
//|| Efetua validação de quantidade única |
//+---------------------------------------+
If M->D3_QUANT <> 1 .And. cFamili $ "000001|000002|000004"
	MsgStop("Quantidade apontada deve ser igual a 1","ATENÇÃO")
	lRet := .F.
Endif

//+----------------------------------------------+
//| Efetua validação do numero de série          |
//| verifica se o mesmo já existe na tabela ZA0. |
//+----------------------------------------------+ 
dbSelectArea("SD3")
dbSetOrder(18) // ZA0_FILIAL+ZA0_SERIE
If Len(RTRIM(M->D3_XNSERIE)) <> 9 .And. cFamili $ "000001|000002|000003|000004"
	MsgAlert("Numero de digitos do numero de série incompatível. Verifique se foi digitado numeros a mais, a menos ou espaços em branco !.","Atenção")
	lRet := .F.	
Endif

If  cFamili $ "000001|000002|000003|000004" .And. Empty(M->D3_XNSERIE)
	MsgAlert("Para produtos da Família Refrigeração, Cocção e Maquina de Gelo fabricação Macom, deve ser informado o número de série","Atenção")
	lRet := .F.
EndIf

If lRet

	dbSelectArea("ZAB")
    dbSetOrder(1)
    If MsSeek(xFilial("ZAB")+M->D3_XNSERIE)
    	//If Empty(ZAB->ZAB_OPTRAN) .and. M->D3_OP <> ZAB->ZAB_NUMOP
    	//	Reclock("ZAB",.F.)
    	//	ZAB->ZAB_OPTRAN := Substr(M->D3_OP,1,6)
    	//	ZAB->ZAB_ITTRAN := Substr(M->D3_OP,7,2)
    	//	ZAB->ZAB_SQTRAN := Substr(M->D3_OP,9,3)
    	//	ZAB->(MsUnlock())
    	//Else
    		//MsgStop("Numero de série já transformado ou OP de origem igual !","ATENÇÃO")
    		//lRet := .F.
    	//EndIf

    ElseIf cFamili $ "000001|000002|000003|000004"
    	MsgStop("Número de série não encontrado !","ATENÇÃO")
    	lRet := .F.
    Endif
EndIf

///////////////////////// Bloqueio de Apontamento de OPs
DEFINE FONT oFont1 NAME "ARIAL" SIZE 8,14 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se foram requisitados os itens na mesma proporcao do apontamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//MsgStop("MT250TOK - 1")

//If GetMv("AM_XVLDPRD") == "S" .And. lRet // Parametro para Validar se foi requisitado na mesma proporcao
If lRet // Parametro para Validar se foi requisitado na mesma proporcao

	nPropApon := NoRound(((SC2->C2_QUJE+M->D3_QUANT) / SC2->C2_QUANT) * 100,2)

	cQuery := "SELECT PRODUTO PRODUTO, SUM(QTDORI) QTDORI, SUM(QTDREQ) QTDREQ, MAX(PERCREQ) PERCREQ FROM ("
	cQuery += " SELECT PRODUTO PRODUTO, SUM(QTDORI) QTDORI, "
	cQuery += " SUM(QTDREQ) QTDREQ, (CASE WHEN SUM(QTDORI) > 0 THEN ROUND((SUM(QTDREQ)/SUM(QTDORI))*100,2) ELSE 100 END) PERCREQ FROM ( "

	cQuery += " SELECT D4_COD PRODUTO, D4_QTDEORI QTDORI, 0 QTDREQ"
	cQuery += " FROM "+RetSqlName("SD4")+" SD4 "
	cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"'"
	cQuery += " AND D4_OP = '"+M->D3_OP+"'"
	cQuery += " AND SUBSTRING(D4_COD,1,3) <> 'MOD'"
	cQuery += " AND D_E_L_E_T_ <> '*'"

	cQuery += " UNION ALL"

	cQuery += " SELECT D3_COD PRODUTO, 0 QTDORI, D3_QUANT QTDREQ"
	cQuery += " FROM "+RetSqlName("SD3")+" SD3"
	cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQuery += " AND D3_OP = '"+M->D3_OP+"'"
	cQuery += " AND SUBSTRING(D3_CF,1,2) = 'RE'"
	cQuery += " AND D3_ESTORNO <> 'S'"
	cQuery += " AND SUBSTRING(D3_COD,1,3) <> 'MOD'"
	cQuery += " AND SD3.D_E_L_E_T_ <> '*'"
	
	cQuery += " UNION ALL"

	cQuery += " SELECT D3_COD PRODUTO, 0 QTDORI, D3_QUANT*-1 QTDREQ"
	cQuery += " FROM "+RetSqlName("SD3")+" SD3"
	cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQuery += " AND D3_OP = '"+M->D3_OP+"'"
	cQuery += " AND SUBSTRING(D3_CF,1,2) = 'DE'"
	cQuery += " AND D3_ESTORNO <> 'S'"
	cQuery += " AND SUBSTRING(D3_COD,1,3) <> 'MOD'"
	cQuery += " AND SD3.D_E_L_E_T_ <> '*' ) TAB"
	cQuery += " GROUP BY PRODUTO ) TAB2"
	cQuery += " WHERE PERCREQ < "+AllTrim(Str(nPropApon))
	cQuery += " GROUP BY PRODUTO"

//	MemoWrite("\QUERYSYS\MT250TOK.SQL",cQuery)  
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBTOK', .T., .F.)
	dbSelectArea("TRBTOK")

	cMensag := ""
	nQtdItens := 0

	dbGotop()
	While !Eof()
		lRet := .F.

		If Empty(cMensag)
			cMensag := OemToAnsi("Com esta produção de "+AllTrim(TransForm(M->D3_QUANT,"@E 999,999.99"))+" pc(s), esta OP passará a ter "+AllTrim(TransForm(nPropApon,"@E 999.99"))+"% apontada.")+ Chr(13) + Chr(10)
			cMensag += OemToAnsi("Existem itens que não foram requisitados na mesma proporção.")+ Chr(13) + Chr(10)
			cMensag += "PRODUTO        QTD.EMP.   QTD.REQ.  % REQ."+ Chr(13) + Chr(10)

		EndIf
		nQtdItens ++
		
		If nQtdItens > 20
			cMensag += "++ Itens"+Chr(13) + Chr(10)
			Exit
		Else
			cMensag += TRBTOK->PRODUTO+"   "+TransForm(TRBTOK->QTDORI,"@E 999,999.99")+"   "+TransForm(TRBTOK->QTDREQ,"@E 999,999.99")+"   "+TransForm(TRBTOK->PERCREQ ,"@E 9999.99")+ Chr(13) + Chr(10)
		EndIf
		
		dbSkip()
	EndDo
	
	If !Empty(cMensag)
		Aviso(OemToAnsi("Atenção !"),cMensag, { "Ok" }, 3 ) 
	EndIf

	lRet := .T.  // Só Aviso por enquanto
 
	dbSelectArea("TRBTOK")
	dbCloseArea()
EndIf
///// Final do Bloqueio de Apontamento de OPs

///// Valida se teve Item requisitado para OP ou tenha Chapa nos Empenhos
If lRet 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida se existe empenho ou requisicao para os apontamentos. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT SUM(REGSD4) REGSD4, SUM(REGSD4CHA) REGSD4CHA, SUM(REGSD3) REGSD3 FROM ( "
	cQuery += " SELECT COUNT(*) REGSD4, 0 REGSD4CHA, 0 REGSD3  
	cQuery += " FROM "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
	cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery += " AND D4_OP = '"+M->D3_OP+"'"
	cQuery += " AND LEFT(D4_COD,3) <> 'MOD' "
	cQuery += " AND (LEFT(D4_COD,2) <> 'CH' AND B1_DESC NOT LIKE '%CHAPA%') "
	cQuery += " AND SD4.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND B1_COD = D4_COD "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "

 	cQuery += " UNION ALL "

	cQuery += " SELECT 0 REGSD4, COUNT(*) REGSD4CHA, 0 REGSD3 "
	cQuery += " FROM "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
	cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery += " AND D4_OP = '"+M->D3_OP+"'"
	cQuery += " AND (LEFT(D4_COD,2) = 'CH' AND B1_DESC LIKE '%CHAPA%') "
	cQuery += " AND SD4.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND B1_COD = D4_COD "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "

 	cQuery += " UNION ALL "

	cQuery += " SELECT 0 REGSD3, 0 REGSD4CHA, COUNT(*) REGSD3 "
	cQuery += "  FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += "  WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += "  AND D3_OP = '"+M->D3_OP+"'"
	cQuery += "  AND LEFT(D3_CF,2) IN ('RE','DE')" 
	cQuery += "  AND D3_ESTORNO = ' ' "
 	cQuery += " AND LEFT(D3_COD,3) <> 'MOD' " 
 	cQuery += " AND SD3.D_E_L_E_T_ <> '*' "
	cQuery += " ) TAB "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBTOK', .T., .F.)
	dbSelectArea("TRBTOK")
	dbGotop()
	While !Eof()
		If TRBTOK->REGSD3 == 0 .And. TRBTOK->REGSD4CHA == 0
			lRet  := .F.
		EndIf
		dbSkip()
	EndDo

	dbSelectArea("TRBTOK")
	dbCloseArea()
	If !lRet
		Aviso(OemToAnsi("Atenção !"),"A Ordem de produção selecionada não possui requisiçoes e não possui Chapas nos Empenhos !", { "Ok" }, 3 ) 
		lRet := .T. // Só avisa por enquanto
	EndIf

EndIf

If lRet .And. cFamili $ "000001|000002|000003|000004"

	// Grava tabela de número de Serie como apontado
	dbSelectArea("ZAB")
	dbSetOrder(1)
	If ZAB->(MsSeek(xFilial("ZAB")+ M->D3_XNSERIE)) .And. lRet
		If ZAB->ZAB_APONTA == "X"
			MsgAlert("Numero de série já apontado !","ATENÇÃO")
			lRet := .F.
		EndIf
	EndIf

	If lRet
		If MsSeek(xFilial("ZAB")+M->D3_XNSERIE)
			Reclock("ZAB",.F.)
			ZAB->ZAB_APONTA := "X"
			ZAB->(MsUnlock())
		Endif
	Endif

EndIf

RestArea(aAreaZAB)
RestArea(aAreaSD3)
RestArea(aArea)

Return lRet
