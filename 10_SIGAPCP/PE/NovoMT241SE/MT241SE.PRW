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

Local aEstrutura   := {}
Local i            := 0
Local nx           := 0
Private lOk          := .F.
Private aAreaSD4     := SD4->(GetArea())
Private aAreaSDC     := SDC->(GetArea())
Private nPercOP      := 0
Private lSugSemSld   := .F.
Private aColsPE      := {}
Private cLocaliz     := Criavar("D3_LOCALIZ",.F.)
Private cNumSeri     := Criavar("D3_NUMSERI",.F.)
Private lItemNeg     := .F.
Private oDlg

//Private nQtdOrigEs := 1
//Private cProdEst   := Criavar("D3_COD",.F.)
//Private cOpEst     := Criavar("D3_OP",.F.)
//Private nEstru     := 0
If !Empty(cProdEst) .And. nQtdOrigEs > 0

	// Le os empenhos caso a op esteja preenchida
/*.
	If !Empty(cOPEst)
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+cOpEst)

		// Calcula qual o percentual da baixa de insumos
		nPercOp:=nQtdOrigEs/SC2->C2_QUANT
		dbSelectArea("SDC")
		dbSetOrder(2)
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+cOpEst)
//		While !Eof() .And. D4_FILIAL+D4_OP==xFilial("SD4")+cOpEst
		While !Eof() .And. D4_FILIAL == xFilial("SD4") .And. Left(D4_OP,6) == Left(cOpEst,6)

			If !lSugSemSld .AND. QtdComp(D4_QUANT)==QtdComp(0)
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Produtos de apropriacao indireta, quando ja possuem saldo no armazem de processo |
			//| a baixa e automatica pela producao, quando ainda nao possuem saldo no armazem de |
			//| de processo devera ser feita requisicao manual do armazem padrao.                |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If A260ApropI(D4_COD)
				dbSkip()
				Loop
			EndIf

			If cTm > "500"
			//	If SDC->(dbSeek(xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE))
			//		While !SDC->(Eof()) .And. xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE == SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE)
			//			AADD(aEstrutura,{NIL,NIL,SD4->D4_COD,Min(SDC->DC_QUANT,(SDC->DC_QTDORIG*nPercOp)),SDC->DC_TRT,SDC->DC_LOTECTL,SDC->DC_NUMLOTE,SDC->DC_LOCALIZ,SDC->DC_NUMSERI,SD4->D4_LOCAL,SD4->D4_DTVALID})
			//			SDC->(dbSkip())
			//		End
			//	Else
			//		AADD(aEstrutura,{NIL,NIL,SD4->D4_COD,Min(SD4->D4_QUANT,(SD4->D4_QTDEORI*nPercOp)),SD4->D4_TRT,SD4->D4_LOTECTL,SD4->D4_NUMLOTE,cLocaliz,cNumSeri,SD4->D4_LOCAL,SD4->D4_DTVALID})
			//	EndIf
			Else
				AADD(aEstrutura,{NIL,NIL,SD4->D4_COD,Min(SD4->D4_QTDEORI*nPercOp,SD4->D4_QTDEORI-SD4->D4_QUANT),SD4->D4_TRT,SD4->D4_LOTECTL,SD4->D4_NUMLOTE,cLocaliz,cNumSeri,SD4->D4_LOCAL,SD4->D4_DTVALID})
			EndIf
			dbSelectArea("SD4")
			dbSkip()
		EndDo
		RestArea(aAreaSD4)
		RestArea(aAreaSDC)
	// Se nao preencheu OP le somente a estrutura
	Else
		// Explode o 1 nivel da estrutura
//		A241Explod(cProdEst,nQtdOrigEs,@aEstrutura)
//	EndIf
/*/

	aEstrutura := MT241OP01(cOpEst,nQtdOrigEs,cProdEst)

	aCols := {}
	AADD(aCols,Array(Len(aHeader)+1))

	// Le somente os itens de primeiro nivel
	For i:=1 to Len(aEstrutura)

		// Se a primeira linha esta em branco remove a mesma do acols
		If Empty(aCols[1,nPosCod])
			ADEL(aCols,1)
			ASIZE(aCols,Len(aCols)-1)
		EndIf

		// Adiciona item no acols
		AADD(aCols,Array(Len(aHeader)+1))
		// Preenche conteudo do acols
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para marcar como deletados os itens com quantidade negativa na ³
		//³estrutura ou positiva-los, de acordo com o tipo de movimentacao RE/DE.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QtdComp(aEstrutura[i,4]) <= QtdComp(0)
			lItemNeg := .T. // variavel para exibicao de aviso ao usuario
			If cTm > "500"
				// Requisicoes
				If QtdComp(aEstrutura[i,4]) <= QtdComp(0)
					// Quantidade negativa ou zerada: deve ser deletado, pois nao se pode requisitar quantidade negativa ou zerada
					aCOLS[Len(aCols)][Len(aHeader)+1] := .T.
				EndIf
			Else
				// Devolucoes
				If QtdComp(aEstrutura[i,4]) < QtdComp(0)
					// Quantidade negativa: deve ser positivada, pois trata-se de devolucao
					aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
					aEstrutura[i,4] := (aEstrutura[i,4] * -1)
				Else
					// Quantidade zerada: deve ser deletado, pois nao se pode devolver quantidade zerada
					aCOLS[Len(aCols)][Len(aHeader)+1] := .T.
				EndIF
			EndIf
		Else
			// Item com quantidade positiva > 0
			aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
		EndIf

		// Preenche campos especificos
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
		// Preenche o numero da OP
		If !Empty(cOpEst)
		//	If aEstrutura[i,10]# NIL .AND. !Empty(aEstrutura[i,10])
//				GDFieldPut("D3_LOCAL",aEstrutura[i,10],Len(aCols))
				GDFieldPut("D3_LOCAL",SB1->B1_LOCPAD,Len(aCols))
		//	EndIf
			GDFieldPut("D3_OP",cOpEst,Len(aCols))
			GDFieldPut("D3_TRT",aEstrutura[i,5],Len(aCols))
			GDFieldPut("D3_LOTECTL",aEstrutura[i,6],Len(aCols))
			GDFieldPut("D3_NUMLOTE",aEstrutura[i,7],Len(aCols))
//			GDFieldPut("D3_DTVALID",aEstrutura[i,11],Len(aCols))
//			If ! Empty(cTM) .and. SF5->F5_TIPO=="D"
//				GDFieldPut("D3_LOCALIZ",Space(15),Len(aCols))
//				GDFieldPut("D3_NUMSERI",Space(20),Len(aCols))
//			Else
//				GDFieldPut("D3_LOCALIZ",aEstrutura[i,8],Len(aCols))
//				GDFieldPut("D3_NUMSERI",aEstrutura[i,9],Len(aCols))
//			EndIf
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³A241Explod³ Autor ³Marcos V. Ferreira      ³ Data ³07.10.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao recursiva para localizar todos os componentes do 	   ³±±
±±³          ³ primeiro nivel da estrutura.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Produto Pai                               ³±±
±±³          ³ ExpN1 = Quantidade do produto Pai                           ³±±
±±³          ³ ExpA1 = aArray de retorno                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*/
Static Function A241Explod(cProduto,nQuant,aNewStruct)
Local nX		     := 0
Local aAreaAnt	 := GetArea()
Local aArrayAux  := {}

Default cProduto := ""
Default nQuant	 := 0

//Variavel publica declarada na funcao M241SeleEs()
nEstru := 0

aArrayAux := Estrut(cProduto,nQuant,.T.)

dbSelectArea("SB1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Processa todos os componentes do 1 nivel da estrutura,  |
//| verificando a existencia de produtos fantasmas.         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aArrayAux)
	If dbSeek(xFilial("SB1")+aArrayAux[nx,3]) //Filial+Componente
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") $ "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			A241Explod(aArrayAux[nx,3],aArrayAux[nx,4],aNewStruct) //Componente+Qtde
		Else
			aAdd(aNewStruct,aArrayAux[nx])
		EndIf
	EndIf
Next nX

RestArea(aAreaAnt)
Return Nil
/*/


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

Local aEstrutura  := {} 
Private _cQuery   := ""
Private _nRegSg1  := 0
Private aSaldo    := {}
Private nSaldo    := 0
Private lDelLinha := .F.
Private _aCDetSD3 := {}
Private oDlg2
Private oArmazem
Private cNumArmaz:= space(2)

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
//		cCodProPsq := AllTrim((cAlias)->COD_COMP)
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
