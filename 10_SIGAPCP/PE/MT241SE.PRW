#INCLUDE "totvs.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch
/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  | MT241SE      |Autor |Valdemir Miranda                | Data | 05/04/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Carregando dados do P I C K I N G - L I S T                             ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function MT241SE()

Local i            := 0
Local nx           := 0
Private lOk          := .F.
Private aEstrutura   := {}
Private aAreaSD4     := SD4->(GetArea())
Private aAreaSDC     := SDC->(GetArea())
Private nPercOP      := 0
Private lSugSemSld   := .F.
Private aColsPE      := {}
Private cLocaliz     := Criavar("D3_LOCALIZ",.F.)
Private cNumSeri     := Criavar("D3_NUMSERI",.F.)
Private lItemNeg     := .F.
Private oDlg
Private _cQuery   := ""
Private _nRegSg1  := 0
Private aSaldo    := {}
Private nSaldo    := 0
Private lDelLinha := .F.
Private _aCDetSD3 := {}
Private oDlg2
Private oArmazem
Private cNumArmaz:= space(2)

If !Empty(cProdEst) .And. nQtdOrigEs > 0

	aEstrutura := MT241OP01(cOpEst,nQtdOrigEs,cProdEst)

	aCols := {}
	AADD(aCols,Array(Len(aHeader)+1))

	// *** Le somente os itens de primeiro nivel *** //
	For i:=1 to Len(aEstrutura)

		// *** Se a primeira linha esta em branco remove a mesma do acols  *** //
		If Empty(aCols[1,nPosCod])
			ADEL(aCols,1)
			ASIZE(aCols,Len(aCols)-1)
		EndIf

		// *** Adiciona item no acols *** //
		AADD(aCols,Array(Len(aHeader)+1))
		// *** Preenche conteudo do acols *** //
		For nx:=1 to Len(aHeader)
			cCampo:=Alltrim(aHeader[nx,2])
			If IsHeadRec(cCampo)
				aCols[Len(aCols)][nx] := 0
			ElseIf IsHeadAlias(cCampo)
				aCols[Len(aCols)][nx] := "SD3"
			Else
				aCols[Len(aCols)][nx] := CriaVar(cCampo,.F.)
			EndIf
		Next nx
		
		/*
		|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		|| Tratamento para marcar como deletados os itens com quantidade negativa na 		   ||
		|| estrutura ou positiva-los, de acordo com o tipo de movimentacao RE/DE.    		   ||
		|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		*/
		If QtdComp(aEstrutura[i,4]) <= QtdComp(0)
			lItemNeg := .T. // *** variavel para exibicao de aviso ao usuario *** //
			If cTm > "500"
				// ** Requisicoes *** //
				If QtdComp(aEstrutura[i,4]) <= QtdComp(0)
					// *** Quantidade negativa ou zerada: deve ser deletado, pois nao se pode requisitar quantidade negativa ou zerada *** //
					aCOLS[Len(aCols)][Len(aHeader)+1] := .T.
				EndIf
			Else
				// *** Devolucoes *** //
				If QtdComp(aEstrutura[i,4]) < QtdComp(0)
					// *** Quantidade negativa: deve ser positivada, pois trata-se de devolucao *** //
					aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
					aEstrutura[i,4] := (aEstrutura[i,4] * -1)
				Else
					// *** Quantidade zerada: deve ser deletado, pois nao se pode devolver quantidade zerada *** //
					aCOLS[Len(aCols)][Len(aHeader)+1] := .T.
				EndIF
			EndIf
		Else
			aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
		EndIf

		// *** Preenche campos especificos *** //
		SB1->(dbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+aEstrutura[i,3]))
		GDFieldPut("D3_COD",aEstrutura[i,3],Len(aCols))
		GDFieldPut("D3_DESCRI",SB1->B1_DESC,Len(aCols))
		GDFieldPut("D3_UM",SB1->B1_UM,Len(aCols))
		GDFieldPut("D3_SEGUM",SB1->B1_SEGUM,Len(aCols))
		GDFieldPut("D3_QUANT",aEstrutura[i,4],Len(aCols))
		GDFieldPut("D3_LOCAL",RetFldProd(SB1->B1_COD,"B1_LOCPAD"),Len(aCols))
		GDFieldPut("D3_CONTA",SB1->B1_CONTA,Len(aCols))
		GDFieldPut("D3_ITEMCTA",SB1->B1_ITEMCC,Len(aCols))

		// *** Preenche o numero da  *** //
		If !Empty(cOpEst)

			GDFieldPut("D3_LOCAL",SB1->B1_LOCPAD,Len(aCols))
		
			GDFieldPut("D3_OP",cOpEst,Len(aCols))
			GDFieldPut("D3_TRT",aEstrutura[i,5],Len(aCols))
			GDFieldPut("D3_LOTECTL",aEstrutura[i,6],Len(aCols))
			GDFieldPut("D3_NUMLOTE",aEstrutura[i,7],Len(aCols))

		EndIf
		// Executa gatilhos e validacoes
		If ExistTrigger("D3_COD")
			RunTrigger(2,Len(aCols),,"D3_COD")
		EndIf
		If ExistTrigger("D3_QUANT")
			RunTrigger(2,Len(aCols),,"D3_QUANT")
		EndIf
		If ExistTrigger("D3_LOCAL")
			RunTrigger(2,Len(aCols),,"D3_LOCAL")
		EndIf
		If ExistTrigger("D3_OP")
			RunTrigger(2,Len(aCols),,"D3_OP")
		EndIf
	Next i
EndIf

Return(aCols)


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  | MT241OP      |Autor |Valdemir Miranda                | Data | 05/04/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Carregando dados doP I C K I N G - L I S T                              ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MT241OP01(_cNumOP,_nQuant,_cCdPro)


_cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSqlName("SD3")+" WHERE D3_OP = '"+_cNumOP+"' AND D_E_L_E_T_ = ''"
TcQuery _cQuery New Alias (cAlias := GetNextAlias())
(cAlias)->(DbEval({|| _nRegSg1 ++ }))
(cAlias)->(DbGoTop())

// ***
cProces01:="S"
If (cAlias)->QTD > 0 .and. cProces01 = "N"
	(cAlias)->(DBCLOSEAREA())
	FWAlertError("Favor utilizar a rotina de movimentação múltipla para OPs com apontamentos parciais", "Apontamento Parcial")
	Return
Else
	_cQuery := ""
	_cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, NIVEL ) AS "
	_cQuery += "( "

	_cQuery += "SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, 1 AS NIVEL "
	_cQuery += "FROM SG1010 SG1 (NOLOCK) "
	_cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
	_cQuery += "AND G1_FILIAL      = '"+xFilial("SG1")+"' " 

	_cQuery += "UNION ALL "

	_cQuery += "SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1 "
	_cQuery += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) "
	_cQuery += "INNER JOIN ESTRUT EST "
	_cQuery += "ON G1_COD = COD_COMP "
	_cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
	_cQuery += "AND SG1.G1_FILIAL = '"+xFilial("SG1")+"' "

	_cQuery += ") "

	_cQuery += "SELECT * "
	_cQuery += "FROM ESTRUT E1 "
	_cQuery += "WHERE E1.CODIGO = '"+_cCdPro+"' "
	_cQuery += "AND E1.DT_FIM >= '20471231' "

	TcQuery _cQuery New Alias (cAlias := GetNextAlias())
	(cAlias)->(DbEval({|| _nRegSg1 ++ }))
	(cAlias)->(DbGoTop())

	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())

		// *** Pega Dados do cadastro de Produtos *** //
		cCodProPsq := (cAlias)->COD_COMP
		cCodProduto := cCodProPsq

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+cCodProduto)

		If AllTrim(SB1->B1_XPICLIS) == "1"  //.and. cB1_LOCPAD = cNumArmaz
			nQuantPKL := (cAlias)->QTD*_nQuant
			// *** Grava Vetor *** //
			AADD(aEstrutura,{NIL,NIL,cCodProPsq,nQuantPKL,"","","","","",SB1->B1_LOCPAD,Ctod("  /  /  ")})
		EndIf

		(cAlias)->(DbSkip())
	Enddo

Endif
(cAlias)->(DBCLOSEAREA())
    
Return(aEstrutura)
