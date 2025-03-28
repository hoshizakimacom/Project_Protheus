#Include "TOPCONN.CH"
#Include "rwmake.ch"
#Include "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ M261BCHOI³ Autor ³                       ³ Data ³ 13/01/25 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Botao para buscar os Pendenhos de Um O.P. na Trans.Modelo2 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261BCHOI

Local aBut261 := {}

aAdd(aBut261, {'PESQUISA' 	,{ || U_M261BUSCAOP() } 	, "Sel.Itens por OP"			, "Sel.OP." } )
aAdd(aBut261, {'EDIT'	   	,{ || U_M261BUSPRD() }  	, "Sel.Produto por Empenho" 	,"Prod.Emp" } )

//aAdd(aBut261, {'EDIT'	   , { || U_M261BUSEMP() }  , "Sel.Produto por Empenho" ,"Prod.Emp" } )
//aAdd(aBut261, {'EDITABLE'	, { || U_M261BUSPROD() } , "Sel.Produto Avulso"      ,"Prod.Av."  } )
//aAdd(aBut261, {'PENDENTE'	, { || U_M261BUSCAOP() }, "Sel.OP.", "Sel.OP." } )  //  Mark
//aAdd(aBut261, {'LBOK'		, { || U_M261BUSCAOP() }, "Sel.Prod.Av.", "Sel.Produto Avulso" } )  // Marcado
//aAdd(aBut261, {'LBNO'		, { || U_M261BUSCAOP() }, "Sel.OP.", "Sel.OP." } )                  // Desmarcado
//aAdd(aBut261, {'PESQUISA'	, { || U_M261BUSCAOP() }, "Sel.Prod.", "Sel.Produto por Empenho" } ) // Lupa
//aAdd(aBut261, {'OMSDIVIDE' , { || U_M261BUSCAOP() }, "Sel.OP.", "Sel.OP." } )  // Identador
//aAdd(aBut261, {'S4WB008N'	, { || U_M261BUSCAOP() }, "Sel.OP.", "Sel.OP." } )  // Calculadora
//aAdd(aBut261, {'S4WB004N'	, { || U_M261BUSCAOP() }, "Sel.OP.", "Sel.OP." } )  // Vassoura

Return(aBut261)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³M261BUSCAOP³ Autor ³ Silas Souza          ³ Data ³ 12/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Busca os Empenhos para a tela de Transf. Modelo2 por Op    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261BUSCAOP

Local cOPTrans := Space(13)
Local oDlg
Local nOpca
Local cLocOri := "01"    //"Left(GetMv("MV_XLOCEST"),2) // Local de Estoque 14
Local cLocEmp := "99"    //Left(GetMv("MV_XLOCPRO"),2)

//DEFINE MSDIALOG oDlg TITLE OemToAnsi("Selecione a Ordem de Produção a Transferir") FROM 200,001 TO 310,350 PIXEL
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Selecione a Ordem de Produção a Transferir") FROM 200,001 TO 410,350 PIXEL

/*/
@ 016,007 SAY OEMTOANSI("Ordem de Produção : ") SIZE 080,07 OF oDlg PIXEL
@ 016,077 MSGET cOPTrans F3 "SC2" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid !Empty(cOPTrans)

@ 030,007 SAY OEMTOANSI("Local Origem : ") SIZE 080,07 OF oDlg PIXEL
@ 030,077 MSGET cLocOri F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocOri)

@ 044,007 SAY OEMTOANSI("Local Destino/Empenho : ") SIZE 080,07 OF oDlg PIXEL
@ 044,077 MSGET cLocEmp F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocEmp)
/*/

@ 035,007 SAY OEMTOANSI("Ordem de Produção : ") SIZE 080,07 OF oDlg PIXEL
@ 035,077 MSGET cOPTrans F3 "SC2" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid !Empty(cOPTrans)

@ 049,007 SAY OEMTOANSI("Local Origem : ") SIZE 080,07 OF oDlg PIXEL
@ 049,077 MSGET cLocOri F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocOri)

@ 063,007 SAY OEMTOANSI("Local Destino/Empenho : ") SIZE 080,07 OF oDlg PIXEL
@ 063,077 MSGET cLocEmp F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocEmp)

// Ver Tabela de Local
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED

If nOpca <> 0
	Processa({||U_M261BSCOP("1",cOPTrans,cLocOri,cLocEmp)},"Selecionando produtos da Ordem de producao...")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³M261BUSPRD ³ Autor ³ Marcos Eduardo Rocha ³ Data ³ 11/06/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Busca os Empenhos para a tela de Transf. Modelo2 por Prod. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261BUSPRD

Local cCodPro := Space(15)
Local oDlg
Local nOpca
Local cLocOri := "01"  //Left(GetMv("MV_XLOCEST"),2) // Local de Estoque 14
Local cLocEmp := "99"   // Left(GetMv("MV_XLOCPRO"),2)

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Selecione o Produto a Transferir") FROM 200,001 TO 410,350 PIXEL

/*/
@ 016,007 SAY OEMTOANSI("Produto : ") SIZE 080,07 OF oDlg PIXEL
@ 016,077 MSGET cCodPro F3 "SB1" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid !Empty(cCodPro)

@ 030,007 SAY OEMTOANSI("Local Origem : ") SIZE 080,07 OF oDlg PIXEL
@ 030,077 MSGET cLocOri F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocOri)

@ 044,007 SAY OEMTOANSI("Local Destino/Empenho : ") SIZE 080,07 OF oDlg PIXEL
@ 044,077 MSGET cLocEmp F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocEmp)
/*/

@ 030,007 SAY OEMTOANSI("Produto : ") SIZE 080,07 OF oDlg PIXEL
@ 030,077 MSGET cCodPro F3 "SB1" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid !Empty(cCodPro)

@ 044,007 SAY OEMTOANSI("Local Origem : ") SIZE 080,07 OF oDlg PIXEL
@ 044,077 MSGET cLocOri F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocOri)

@ 058,007 SAY OEMTOANSI("Local Destino/Empenho : ") SIZE 080,07 OF oDlg PIXEL
@ 058,077 MSGET cLocEmp F3 "97" WHEN .T. SIZE 010,07 OF oDlg PIXEL Valid !Empty(cLocEmp)

// Ver Tabela de Local
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| nOpca := 1, oDlg:End() }, {||nOpca := 0, oDlg:End()}) CENTERED

If nOpca <> 0
	Processa({||U_M261BSCOP("2",cCodPro,cLocOri,cLocEmp)},"Selecionando produtos...")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³M261BUSEMP ³ Autor ³ Marcos Eduardo Rocha ³ Data ³ 12/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Busca os Empenhos para a tela de Transf. Modelo2           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*/
User Function M261BUSEMP

Local oDlg
Local nOpca
Local cLocOri    := Space(2)
Local cLocDes    := Space(2)
Local cProdTran  := Space(15)
Local nQtdTran   := 0
Local cOpRef     := Space(11)

//dbSelectArea("SZ6")
//SZ6->(dbSetOrder(1))
//If SZ6->(dbSeek(xFilial("SZ6")+UPPER(cUserName)))
//	cLocOri := Left(SZ6->Z6_LOCORIG,2)
//	cLocDes := Left(SZ6->Z6_LOCDEST,2)
//Else
//	Aviso("Transferência Modelo 2","Usuario não cadastrado na tabela de dados complementar",{"&Ok"},2)
//	Return
//EndIf

Aviso("Transferência Modelo 2",OemToAnsi("Rotina não disponível"),{"&Ok"},2)
Return

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Selecione o Produto Empenhado a Transferir") FROM 200,001 TO 335,350 PIXEL

@ 016,007 SAY OEMTOANSI("Local Origem : ") SIZE 050,06 OF oDlg PIXEL
@ 016,077 MSGET cLocOri F3 "97" WHEN .T. SIZE 010,10 OF oDlg PIXEL Valid(ExistCpo("SX5","Z6"+cLocOri))

@ 028,007 SAY OEMTOANSI("Local Destino : ") SIZE 050,06 OF oDlg PIXEL
@ 028,077 MSGET cLocDes F3 "97" WHEN .T. SIZE 010,10 OF oDlg PIXEL Valid(ExistCpo("SX5","Z6"+cLocDes))

@ 040,007 SAY OEMTOANSI("Produto : ") SIZE 050,06 OF oDlg PIXEL
//@ 040,077 MSGET cProdTran F3 "SD4X" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid !Empty(cProdTran)
@ 040,077 MSGET cProdTran F3 "SB1" WHEN .T. SIZE 050,10 OF oDlg PIXEL Valid(ExistCpo("SB1",cProdTran))// !Empty(cProdTran)

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar( oDlg, {|| If(ValCpo(cLocOri,cLocDes,cProdTran),( nOpca := 1, oDlg:End()),) }, {||nOpca := 0, oDlg:End()}) CENTERED

If nOpca <> 0
	U_M261INCPRD("1",cProdTran,cLocOri,cLocDes,nQtdTran,cOpRef)
EndIf

Return
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³M261BSCOP ³ Autor ³ Silas Souza           ³ Data ³ 12/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Rotina de Empenho apos as transferencias                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261BSCOP(cTipoSel,cCodigo,cLocOri,cLocEmp)

Local aArea := GetArea()
Local aAreaSB2 := SB2->(GetArea())
Local cQuery
Local nLoop
Local nProc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis de Posicao utilizado no Siga Pyme   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosCODOri := 1  //Codigo do Produto Origem
Local nPosDOri	  := 2  //Descricao do Produto Origem
Local nPosUMOri  := 3  //Unidade de Medida Origem
Local nPosLOCOri := 4  //Armazem Origem
Local nPosLcZOri := 5  //Localizacao Origem

Local nPosCODDes := 6  //Codigo do Produto Destino
Local nPosDDes	  := 7  //Descricao do Produto Destino
Local nPosUMDes  := 8  //Unidade de Medida Destino
Local nPosLOCDes := 9  //Armazem Destino
Local nPosLcZDes := 10 //Localizacao Destino

Local nPosNSer   := 11	//Numero de Serie
Local nPosLoTCTL := 12	//Lote de Controle
Local nPosNLOTE  := 13	//Numero do Lote
Local nPosDTVAL  := 14	//Data Valida
Local nPosPotenc := 15	//Potencia
Local nPosQUANT  := 16	//Quantidade
Local nPosQTSEG  := 17	//Quantidade na 2a. Unidade de Medida
Local nPosEstor  := 18	//Estornado
Local nPosNumSeq := 19	//Sequencia
Local nPosLotDes := 20  //Lote Destino
Local nPosDtVldD := 21  //Data Valida de Destino
Local nPosOPTr   := aScan( aHeader, { |x| AllTrim( x[2] ) == "D3_XOP"})
Local cQuery
Local aDadosOk
Local cLocEst  := "01"  //Getmv("MV_XLOCEST")
Local cLocProc := "99"  //Getmv("MV_XLOCPRO")
//Private cNumOPTr

If Empty(cCodigo)
	If cTipoSel == "1"
		Aviso(OemToAnsi("Atenção"),OemToAnsi("OP para transferência não informada !"),{"OK"},1,"Atenção")
	Else
		Aviso(OemToAnsi("Atenção"),OemToAnsi("Produto para transferência não informado !"),{"OK"},1,"Atenção")
	EndIf
	Return
EndIf

//cNumOPTr := cCodigo

// Verifica mais de uma ocorrencia para aglutinar
If cTipoSel == "1" .And. U_M261AGLUT(cCodigo) == .F.
	Alert (OemToAnsi('Operaçào cancelada pelo usuário!'))
	Return
Endif

cQuery := "SELECT D4_COD, SUM(D4_QUANT) D4_QUANT, D4_LOTECTL, D4_OP"
cQuery += " FROM " +RetSqlName("SD4")+" SD4 , " + RetSqlName("SB1")+" SB1"
cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"'"

If cTipoSel == "1"
	cQuery += " AND SUBSTRING(D4_OP,1,11) = '" + Left(cCodigo,11) + "'"
Else
	cQuery += " AND D4_COD  = '"+cCodigo+"'"
	// Buscar somente os com Fabrica Sim
EndIf
cQuery += " AND SD4.D4_QUANT > 0"
cQuery += " AND SD4.D4_LOCAL = '"+cLocEmp+"'"
cQuery += " AND SD4.D_E_L_E_T_ <> '*'"
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND SB1.B1_COD = D4_COD"
cQuery += " AND SB1.B1_FANTASM IN ('N',' ')"

cQuery += "	AND SB1.B1_XPICLIS IN ('1') "

cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D4_COD, D4_LOTECTL, D4_OP"
cQuery += " ORDER BY D4_COD, D4_OP"

cQuery := ChangeQuery(cQuery)

//MemoWrite("\QUERYSYS\M261BCHOI.SQL",cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .T., .T.)

ProcRegua(RecCount())

aDadosOk := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela de selecao                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGotop()
While !Eof()
	
	_cProduto := TRB->D4_COD
	_nSaldoD4 := TRB->D4_QUANT
	_nSaldoB8 := 0
	
	aArray := {}
	
	If Rastro(TRB->D4_COD) .Or. Localiza(TRB->D4_COD)
		aArray := SldPorLote(TRB->D4_COD,cLocOri, TRB->D4_QUANT,,,,,,,.F.,,.F.,,.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma a quantidade disponivel por Lote/Localizacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotDisp := 0.00
		For _n := 1 to Len(aArray)
			nTotDisp += aArray[_n,5]
		Next
		
	Else
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+TRB->D4_COD+cLocOri)
			aArray := {SB2->B2_QATU,0,0,0,0}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quantidade disponivel do produto        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotDisp := aArray[1]
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ignora o registro caso nao exista              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aArray) == 0
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf
	
	If nTotDisp <= 0
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf
	
	/*	 SOMENTE SE ATENDER TOTALMENTE A OP
	If nTotDisp < TRB->D4_QUANT
	
	DbSelectArea("TRB")
	DbSkip()
	Loop
	Endif
	*/
	//Produtos com lote
	If Rastro(TRB->D4_COD) .Or. Localiza(TRB->D4_COD)
		For _a := 1 to Len(aArray)
			
			If _nSaldoD4 > 0
				_nSaldoD4 -= aArray[_a,5]
				_nSaldoB8 += aArray[_a,5]
				
				Aadd(aDadosOk,{ TRB->D4_COD, Iif(_nSaldoB8 > TRB->D4_QUANT, TRB->D4_QUANT, aArray[_a,5]), aArray[_a,1], _nSaldoD4, _nSaldoB8, aArray[_a,2], aArray[_a,7], aArray[_a,4], TRB->D4_OP, aArray[_a,3] } )
			Else
				Exit
			Endif
		Next _a
		
	Else
		Aadd(aDadosOk,{TRB->D4_COD, Iif(nTotDisp > TRB->D4_QUANT, TRB->D4_QUANT, nTotDisp), "  ", _nSaldoD4, nTotDisp, "  ", "  ", "  ", TRB->D4_OP } )
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o SB2 do Local 12 caso nao exista. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+TRB->D4_COD+cLocEmp)
		CriaSB2(TRB->D4_COD,cLocEmp)
	EndIf
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

dbSelectArea("TRB")
dbCloseArea()

nItIncl := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui Itens no Acols. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nProc := 1 To Len(aDadosOk)
	
	nItIncl ++
	lIncluiu := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o ultimo item esta em branco e utiliza. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Acols[Len(aCols),nPosCODOri])
		aAdd( aCols, Array( Len(aHeader) + 1) )
		For _ni := 1 To Len(aHeader)
		    If ALLTRIM(aHeader[_ni,2]) == "D3_ALI_WT"
		       aCols[Len(aCols),_ni] := "SD3"
		    ElseIf ALLTRIM(aHeader[_ni,2]) == "D3_REC_WT"
		       aCols[Len(aCols),_ni] := 0
		    Else
   			   aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2])
   			EndIf
		Next
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		lIncluiu := .T.
	EndIf

	// No caso de Transferencia por produto, trazer deletado
	If cTipoSel == "2"
		aCols[Len(aCols),Len(aHeader)+1] := .T.
	EndIf
	
	//Origem
	aCols[Len(aCols),nPosCODOri] := aDadosOk[nProc,1]
	aCols[Len(aCols),nPosDOri]   := Posicione("SB1",1,xFilial("SB1") + aDadosOk[nProc,1], "B1_DESC")
	aCols[Len(aCols),nPosUMOri]  := Posicione("SB1",1,xFilial("SB1") + aDadosOk[nProc,1], "B1_UM")
	aCols[Len(aCols),nPosLOCOri] := cLocOri
	
	//Destino
	aCols[Len(aCols),nPosCODDes] := aDadosOk[nProc,1]
	aCols[Len(aCols),nPosDDes]   := Posicione("SB1",1,xFilial("SB1") + aDadosOk[nProc,1], "B1_DESC")
	aCols[Len(aCols),nPosUMDes]  := Posicione("SB1",1,xFilial("SB1") + aDadosOk[nProc,1], "B1_UM")
	aCols[Len(aCols),nPosLOCDes] := cLocEmp
	
	aCols[Len(aCols),nPosLoTCTL] := aDadosOk[nProc,3]
	aCols[Len(aCols),nPosNLOTE]  := aDadosOk[nProc,6]
	
	aCols[Len(aCols),nPosNSer ]  := aDadosOk[nProc,8]
	
	aCols[Len(aCols),nPosDTVAL]  := aDadosOk[nProc,7]
	
	aCols[Len(aCols),nPosQUANT]  := aDadosOk[nProc,2]
	aCols[Len(aCols),nPosEstor]  := "N"
	
	If cTipoSel == "1"
		aCols[Len(aCols),nPosOPTr]   := cCodigo
//	Else
//		aCols[Len(aCols),nPosOPTr]   := aDadosOk[nProc,9]
	EndIf
	
	If LEN(aDadosOk[nProc]) >= 10 // Endereco Origem/Destino
		aCols[Len(aCols),nPosLcZOri] := aDadosOk[nProc,10]
		aCols[Len(aCols),nPosLcZDes] := aDadosOk[nProc,10]
	EndIf
	
Next

If nItIncl == 0
	Aviso(OemToAnsi("Atenção"),OemToAnsi("Não incluido nenhum item."),{"OK"},1,"Atenção")
Else
	If nItIncl == 1
		Aviso(OemToAnsi("Atenção"),OemToAnsi("Incluido 1 item."),{"OK"},1,"Atenção")
	Else
		Aviso(OemToAnsi("Atenção"),OemToAnsi("Incluidos "+AllTrim(Str(nItIncl))+" itens. "),{"OK"},1,"Atenção")
	EndIf
EndIf

RestArea(aAreaSB2)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³M261INCPRD³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 29/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³Rotina de Empenho apos as transferencias                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*/
User Function M261INCPRD(cTipo,cProduto,cLocOri,cLocDes,nQuant,cOpRef)

Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis de Posicao utilizado no Siga Pyme   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosCODOri := 1  //Codigo do Produto Origem
Local nPosDOri	  := 2  //Descricao do Produto Origem
Local nPosUMOri  := 3  //Unidade de Medida Origem
Local nPosLOCOri := 4  //Armazem Origem
Local nPosLcZOri := 5  //Localizacao Origem

Local nPosCODDes := 6  //Codigo do Produto Destino
Local nPosDDes	  := 7  //Descricao do Produto Destino
Local nPosUMDes  := 8  //Unidade de Medida Destino
Local nPosLOCDes := 9  //Armazem Destino
Local nPosLcZDes := 10					//Localizacao Destino

Local nPosNSer   := 11	//Numero de Serie
Local nPosLoTCTL := 12	//Lote de Controle
Local nPosNLOTE  := 13	//Numero do Lote
Local nPosDTVAL  := 14	//Data Valida
Local nPosPotenc := 15	//Potencia
Local nPosQUANT  := 16	//Quantidade
Local nPosQTSEG  := 17	//Quantidade na 2a. Unidade de Medida
Local nPosEstor  := 18	//Estornado
Local nPosNumSeq := 19	//Sequencia
Local nPosLotDes := 20  //Lote Destino
Local nPosDtVldD := 21  //Data Valida de Destino
Local nPosOPRef  := aScan( aHeader, { |x| AllTrim( x[2] ) == "D3_XOP"})
Local cLocEst  := Getmv("MV_XLOCEST")
Local cLocProc := Getmv("MV_XLOCPRO")

//If cTipo == "1" // Por Empenho
//	If Empty(cOpRef)
//		Aviso(OemToAnsi("Atenção"),OemToAnsi("OP para referencia !"),{"OK"},1,"Atenção")
//		Return
//	EndIf
//EndIf

// Tratar Lote
//aDadosOk := {}
// Query dos SD4 com Saldo
// Tela




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o SB2 do Local 12 caso nao exista. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
dbSetOrder(1)
If !dbSeek(xFilial("SB2")+cProduto+cLocDes)
	CriaSB2(cProduto,cLocDes)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o ultimo item esta em branco e utiliza. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Acols[Len(aCols),nPosCODOri])
	aAdd( aCols, Array( Len(aHeader) + 1) )
	For _ni := 1 To Len(aHeader)
		aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2])
	Next
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	lIncluiu := .T.
	
EndIf

//Origem
aCols[Len(aCols),nPosCODOri] := cProduto
aCols[Len(aCols),nPosDOri]   := Posicione("SB1",1,xFilial("SB1") + cProduto, "B1_DESC")
aCols[Len(aCols),nPosUMOri]  := Posicione("SB1",1,xFilial("SB1") + cProduto, "B1_UM")
aCols[Len(aCols),nPosLOCOri] := cLocOri

//User Function M261INCPRD(cTipo,cProduto,cLocOri,cLocDes,cOpRef)

//Destino
aCols[Len(aCols),nPosCODDes] := cProduto
aCols[Len(aCols),nPosDDes]   := Posicione("SB1",1,xFilial("SB1") + cProduto, "B1_DESC")
aCols[Len(aCols),nPosUMDes]  := Posicione("SB1",1,xFilial("SB1") + cProduto, "B1_UM")

aCols[Len(aCols),nPosLOCDes] := cLocDes

//aCols[Len(aCols),nPosLoTCTL] := aDadosOk[nProc,3]
//aCols[Len(aCols),nPosNLOTE]  := aDadosOk[nProc,6]
//aCols[Len(aCols),nPosNSer ]  := aDadosOk[nProc,8]
//aCols[Len(aCols),nPosDTVAL]  := aDadosOk[nProc,7]
aCols[Len(aCols),nPosQUANT]  := nQuant
aCols[Len(aCols),nPosEstor]  := "N"

If cTipo == "1"
	aCols[Len(aCols),nPosOPRef] := cOpRef
EndIf

RestArea(aArea)

Return
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M261BCHOI º Autor ³ PH (Oficina1)      º Data ³  06/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem ocorrencias iguais de mesmo produto e aglutina.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M261AGLUT(cNumOPTr)

// Verifica ocorrencia de mais de um item para aglutinar
cQuery := "SELECT SD4.R_E_C_N_O_ RECSD4, D4_COD, D4_LOTECTL, D4_TRT, D4_OP, "
cQuery += "	(SELECT SUM(D4_QUANT) FROM " + RetSqlName("SD4") + " SD4A "
cQuery += "		WHERE SD4A.D_E_L_E_T_<>'*' "
cQuery += "		AND SD4A.D4_COD = SD4.D4_COD "
cQuery += "		AND SD4A.D4_OP = SD4.D4_OP "
cQuery += "		AND SD4A.D4_FILIAL = SD4.D4_FILIAL "
cQuery += "	) D4_QUANT, "
cQuery += "	(SELECT SUM(D4_QTDEORI) FROM " + RetSqlName("SD4") + " SD4A "
cQuery += "		WHERE SD4A.D_E_L_E_T_<>'*' "
cQuery += "		AND SD4A.D4_COD = SD4.D4_COD "
cQuery += "		AND SD4A.D4_OP = SD4.D4_OP "
cQuery += "		AND SD4A.D4_FILIAL = SD4.D4_FILIAL "
cQuery += "	) D4_QTDEORI "

//cQuery += "	(SELECT SUM(D4_BAIXAR) FROM " + RetSqlName("SD4") + " SD4A "
//cQuery += "		WHERE SD4A.D_E_L_E_T_<>'*' "
//cQuery += "		AND SD4A.D4_COD = SD4.D4_COD "
//cQuery += "		AND SD4A.D4_OP = SD4.D4_OP "
//cQuery += "		AND SD4A.D4_FILIAL = SD4.D4_FILIAL "
//cQuery += "	) D4_BAIXAR "

cQuery += "FROM " + RetSqlName("SD4") + " SD4 , " + RetSqlName("SB1") + " SB1 "
cQuery += "	WHERE D4_FILIAL = '" + xFilial("SD4") + "' "
cQuery += "	AND SUBSTRING(D4_OP,1,11) = '" + Left(cNumOPTr,11) + "'"
cQuery += "	AND SD4.D4_QUANT > 0 "
cQuery += "	AND SD4.D_E_L_E_T_ <> '*' "
cQuery += "	AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
cQuery += "	AND SB1.B1_COD = D4_COD "
cQuery += "	AND SB1.B1_FANTASM IN ('N',' ') "

cQuery += "	AND SB1.B1_XPICLIS IN ('1') "

cQuery += "	AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "	AND EXISTS (SELECT D4_COD, COUNT(*) "
cQuery += "		FROM " + RetSqlName("SD4") + " SD4 , " + RetSqlName("SB1") + " SB1 "
cQuery += "			WHERE D4_FILIAL = '" + xFilial("SD4") + "'"
cQuery += "			AND SUBSTRING(D4_OP,1,11) = '" + Left(cNumOPTr,11) + "'"
cQuery += "			AND SD4.D4_QUANT > 0 "
cQuery += "			AND SD4.D_E_L_E_T_ <> '*' "
cQuery += "			AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
cQuery += "			AND SB1.B1_COD = D4_COD "
cQuery += "			AND SB1.B1_FANTASM IN ('N',' ') "
cQuery += "			AND SB1.B1_XPICLIS IN ('1') "
cQuery += "			AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "		GROUP BY D4_COD "
cQuery += "		HAVING COUNT(*) > 1 "
cQuery += "		) "
cQuery += " ORDER BY SD4.D4_COD, SD4.R_E_C_N_O_"

cQuery := ChangeQuery(cQuery)

// MemoWrite("\QUERYSYS\M261AGLUT.SQL",cQuery)
If Select("TRB2") > 0 ; TRB2->(DbCloseArea()) ; Endif
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB2', .T., .T.)

If TRB2->(Eof())
	TRB2->(DbCloseArea())
	Return (.t.)
Endif

IF !MsgYesNo(OemToAnsi("Existem produtos que deverão ser aglutinados ? Confirma ?")); Return (.f.); Endif

mProdutos := "Os seguintes produtos serão aglutinados" + Chr(13) + Chr(10)
mProdutos += Chr(13) + Chr(10)
nQtAlter := 0
cCodProduto := ""
While TRB2->(!Eof())
	If nQtAlter <= 20
		If cCodProduto != TRB2->D4_COD
			mProdutos += TRB2->D4_COD + "   " + Str(TRB2->D4_QUANT) + Chr(13) + Chr(10)
			nQtAlter += 1
			cCodProduto := TRB2->D4_COD
		Endif
	Endif
	TRB2->(DbSkip())
EndDo

Alert(mProdutos)

TRB2->(DbGotop())

cCodProduto := ""

While TRB2->(!Eof())
	SD4->(DbGoTo(TRB2->RECSD4))
	If cCodProduto != SD4->D4_COD
		Reclock("SD4",.F.)
		Replace SD4->D4_QUANT With TRB2->D4_QUANT
		Replace SD4->D4_QTDEORI With TRB2->D4_QTDEORI
//		Replace SD4->D4_BAIXAR With TRB2->D4_BAIXAR
		MsUnlock()
		cCodProduto := TRB2->D4_COD
	Else
		Reclock("SD4",.F.)
		SD4->(DbDelete())
		MsUnlock()
	Endif
	TRB2->(DbSkip())
EndDo

TRB2->(DbCloseArea())

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerUsuarioºAutor  ³Anderson Goncalves  º Data ³  09/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao se o usuario pode usar o armazem selecionado     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValCpo(xParam1,xParam2,xParam3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega os armazem a serem manuzeados pelo usuario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
SZ6->(dbSetOrder(1))
SZ6->(dbSeek(xFilial("SZ6")+UPPER(cUserName)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazem de Origem									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(xParam1 $ SZ6->Z6_LOCORIG)
	Aviso("Transferencia Modelo 2","Campo armazem origem, armazem não autorizado, use os armazens "+AllTrim(SZ6->Z6_LOCORIG),{"&Ok"},2)
	Return(.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazem de destino                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(xParam2 $ SZ6->Z6_LOCDEST)
	Aviso("Transferencia Modelo 2","Campo armazem destino, armazem não autorizado, use os armazens "+AllTrim(SZ6->Z6_LOCDEST),{"&Ok"},2)
	Return(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto esta preenchido               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(xParam3)
	Aviso("Transferencia Modelo 2","Campo em branco, digite um produto valido",{"&Ok"},2)
	Return(.F.)
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M261LBOX  ºAutor  ³Anderson Goncalves  º Data ³  09/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de list box para o usuario selecionar os produtos  º±±
±±º          ³ via list box para transferencia                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M261LBOX(cProduto,cArmaz1,cArmaz2)

Local aButtons	 := {}
Local nTotReg   := 0
Local oDlg
Local oOk 	    := LoadBitmap( GetResources(), "LBOK")
Local oNo 	    := LoadBitmap( GetResources(), "LBNO")
Local aEmpenhos := {}
Local oEmpenhos
Local cQuery 	 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros atraves da query                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT D4_COD,D4_QUANT,D4_LOCAL,D4_OP,D4_DATA "
cQuery += "FROM " + RetSqlName("SD4") + " "
cQuery += "WHERE D4_FILIAL = '" + xFilial("SD4") + "' "
cQuery += "AND D4_COD '" + cProduto + "' "
cQuery += "AND D4_LOCAL = '" + cArmaz1 + "' "
cQuery += "AND D4_QUANT > 0 "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY D4_COD,D4_OP"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .T., .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Compatibiliza registros atraves da setfilter        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(SD4->(dbStruct()),{|x| If(x[2]!="C", TcSetField("TMP",AllTrim(x[1]),x[2],x[3],x[4]),Nil)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a contagem dos registros a serem exibidos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP")
TMP->(dbGoTop())
TMP->(dbEval({|| nTotReg++},,{|| !Eof()}))
TMP->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se for igual a zero retorna o aviso                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotReg == 0
	Aviso("Transferencia Modelo 2","Não ha registros à transferir...",{"&Ok"},2)
	Return
EndIf

While TMP->(!EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega listbox com o resultado da query            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aEmpenhos,{	.F.,;
	TMP->D4_OP,;
	TMP->D4_LOCAL,;
	TMP->D4_DATA,;
	TMP->D4_QUANT,;
	TMP->D4_QUANT})
	
	TMP->(dbSkip())
	
Enddo

DEFINE MSDIALOG oDlg TITLE cProduto +" - "+ Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC") FROM 178,181 TO 580,967 PIXEL

@ 019,002 ListBox oEmpenhos Fields HEADER "","OP","Armazem","Data Empenho","Quantidade","Qtd a Tranferir";
Size 388,179 Of oDlg Pixel ColSizes 25,50,25,50,100,100;
On DBLCLICK ( aEmpenhos[oEmpenhos:nAt,06]:= InsertQtd(aEmpenhos[oEmpenhos:nAt,05]),aEmpenhos[oEmpenhos:nAt,1] := !(aEmpenhos[oEmpenhos:nAt,1]), oEmpenhos:Refresh() )
oEmpenhos:SetArray(aEmpenhos)

oEmpenhos:bLine	:= {|| {	If(	aEmpenhos[oEmpenhos:nAT,01],oOk,oNo),;
aEmpenhos[oEmpenhos:nAT,02],;
aEmpenhos[oEmpenhos:nAT,03],;
aEmpenhos[oEmpenhos:nAT,04],;
aEmpenhos[oEmpenhos:nAT,05],;
aEmpenhos[oEmpenhos:nAT,06]}}

ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar(oDlg, {||Alert("Acao do OK")},{||Alert("Acao do Cancel"),oDlg:End()},,aButtons)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InsertQtd ºAutor  ³Anderson Goncalves  º Data ³  09/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inserção da quantidade a ser transferida                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Macom                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InsertQtd(nQuantOri)

Local nQuant	 	:= TransForm(nQuantOri,"@E 999,999,999.99")
Local aButtons		:= {}
Local oDlg				// Dialog Principal
Local nOpcQ         := 0

DEFINE MSDIALOG oDlg TITLE "Transferencia Modelo 2" FROM 178,181 TO 338,574 PIXEL

@ 021,007 Say "Quantidade..: "+nQuantOri Size 175,008 PIXEL OF oDlg
@ 037,102 MsGet nQuant Size 081,009 Picture "@E 999,999,999.99" PIXEL OF oDlg
@ 039,007 Say "Informe a quantidade a ser transferida" Size 095,008 PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar(oDlg, {|| If(nQuant <> 0,(nOpcQ:=1,oDlg:End()),)},{|| nOpcQ:=0,oDlg:End() },,aButtons)

Return(nQuant)
