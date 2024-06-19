#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M04E06  บAutor  ณ Marcos Rocha        บ Data ณ  24/11/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta Inventแrio                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Macom                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function M04E06()

Local cTitulo	:= "Etiqueta Inventแrio"
Private aDados := {}

cPerg := PADR("M04E06",LEN(SX1->X1_GRUPO))

If !Pergunte(cPerg)
	Return
EndIf

/*/
dbSeek(xFilial("SB1")+"RFEG0038")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","A23"})

dbSeek(xFilial("SB1")+"MVGB0058")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","A13"})

dbSeek(xFilial("SB1")+"RFEG0066")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","A28"})

dbSeek(xFilial("SB1")+"CHCC0010")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","B1FR52"})

dbSeek(xFilial("SB1")+"MTDV2222")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","B2FR32"})

dbSeek(xFilial("SB1")+"METS0197")
Aadd(aDados,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_CODBAR,"01","B3FR26"})
/*/

//If mv_par08 == 1
	Processa({|| M04E06QRY() },cTitulo,"Buscando Dados...")
//Else
//	Processa({|| M04E06BCO() },cTitulo,"Gerando Etiquetas em Branco...")
//EndIf

Processa({|| M04E06IMP() },cTitulo,"Imprimindo...")

// NNR_XCODFIC

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M04E06QRY บAutor  ณ Marcos Rocha      บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Impressใo da Etiqueta                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function M04E06QRY

Local cEOL		:= Chr(10)+Chr(13)
Local cQry		:= " "
Local aProdutos
Local nTotLocaliz := 0
Local nQtdLocaliz := 0
Local cProduto    := Space(15)

//Local nProc4

//For nProc4 := 1 To Len(aProdutos)
//	cCodProd := Left(aProdutos[nProc4],15)
//	CriaSB2(cCodProd,mv_par03) 
//Next

cQry := "SELECT B1_COD PRODUTO, B1_DESC DESCRI, B1_UM UM, B1_CODBAR CODBAR, B1_XCLASIN TIPINV, " +cEOL
cQry += " B2_LOCAL LOCALM , "+If(mv_par06 == 1," BF_LOCALIZ "," ' ' ")+" LOCALIZ " +cEOL

If mv_par06 == 1
	cQry += " , (SELECT COUNT(*) FROM "+RetSqlName("SBF")+" SBF "+cEOL
	cQry += " 	WHERE BF_FILIAL = '"+xFilial("SBF")+"'"+cEOL
	cQry += " 	AND BF_PRODUTO = B1_COD "+cEOL
	cQry += " 	AND BF_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+cEOL
	cQry += " 	AND SBF.D_E_L_E_T_ <> '*' ) QTD_LOCALIZ "+cEOL
EndIf

cQry += " FROM "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB2")+" SB2 " +cEOL
If mv_par06 == 1  // Com Endere็o
	cQry += " , "+RetSqlName("SBF")+" SBF "+cEOL
EndIf
cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"+cEOL
cQry += " AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+cEOL
cQry += " AND B1_TIPO IN ('BN','EM','ME','MI','MP','PA','PI','PP') "+cEOL
cQry += " AND SB1.D_E_L_E_T_ <> '*' "+cEOL

cQry += " AND B2_FILIAL = '"+xFilial("SB2")+"'"+cEOL
cQry += " AND B2_COD = B1_COD "+cEOL
cQry += " AND B2_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+cEOL
cQry += " AND B2_LOCAL <> '  ' "+cEOL
If mv_par05 == 1
	cQry += " AND B2_QATU > 0 "+cEOL
ElseIf  mv_par05 == 2
	cQry += " AND B2_QATU <= 0 "+cEOL
EndIf
cQry += " AND SB2.D_E_L_E_T_ <> '*' "+cEOL

If mv_par06 == 1  // Com Endere็o
	cQry += " AND BF_FILIAL = '"+xFilial("SBF")+"'"+cEOL
	cQry += " AND BF_PRODUTO = B1_COD "+cEOL
	cQry += " AND BF_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+cEOL
	cQry += " AND LEFT(BF_LOCALIZ,8) BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "+cEOL
	cQry += " AND SBF.D_E_L_E_T_ <> '*' "+cEOL
//	cQry += " ORDER BY B2_LOCAL, BF_LOCALIZ "+cEOL
//	cQry += " ORDER BY B1_COD, BF_LOCALIZ "+cEOL
Else
	cQry += " AND (SELECT COUNT(*) FROM "+RetSqlName("SBF")+" SBF "+cEOL
	cQry += " 	WHERE BF_FILIAL = '"+xFilial("SBF")+"'"+cEOL
	cQry += " 	AND BF_PRODUTO = B1_COD "+cEOL
	cQry += " 	AND BF_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+cEOL
	cQry += " 	AND SBF.D_E_L_E_T_ <> '*' ) = 0 "+cEOL
EndIf

If !Empty(mv_par10)
	cQry += " AND (SELECT COUNT(*) FROM "+RetSqlName("CB0")+" CB0 "+cEOL
	cQry += " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "
	cQry += " AND CB0_CODPRO = B1_COD "
	cQry += " AND CB0_LOCAL = B2_LOCAL "
	If mv_par06 == 1  // Com Endere็o
		cQry += " AND CB0_LOCALI = BF_LOCALIZ "
	EndIf
	cQry += " AND LEFT(CB0_CODETI,7)  BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "
	cQry += " AND CB0.D_E_L_E_T_ <> '*' ) > 0 "
EndIf

cQry += " ORDER BY PRODUTO, LOCALIZ "+cEOL


If Select("TRB_SB1") > 0
	dbSelectArea("TRB_SB1")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SB1", .F., .T.)

dbSelectArea("TRB_SB1")
TRB_SB1->(dbGoTop())

aProdutos := {}
Aadd(aProdutos,'MECS0050       REC')
Aadd(aProdutos,'CHCP0006       REC')
Aadd(aProdutos,'FDAN0024       REC')

/*/
aFichasImp := {}
Aadd(aFichasimp,'36-0761')
Aadd(aFichasimp,'36-0007')
/*/

ProcRegua(1000)

While TRB_SB1->(!Eof())

	IncProc("Carregando Etiqueras a Imprimir : "+TRB_SB1->PRODUTO)

//	If Ascan(aProdutos,TRB_SB1->PRODUTO) == 0
//		dbSkip()
//		Loop
//	EndIf

	If mv_par06 == 1
		cEndere := Left(TRB_SB1->LOCALIZ,8)

		nTotLocaliz := TRB_SB1->QTD_LOCALIZ
		If TRB_SB1->PRODUTO == cProduto
			nQtdLocaliz ++
		Else
			nQtdLocaliz := 1
			cProduto := TRB_SB1->PRODUTO
		EndIf
		cAtu_x_Tot := StrZero(nQtdLocaliz,2)+"/"+StrZero(nTotLocaliz,2)

	Else
		cEndere    := ""
		cAtu_x_Tot := ""
	EndIf
	cFicha := AvalFicha(TRB_SB1->PRODUTO,TRB_SB1->LOCALM,cEndere)

//	If Ascan(aFichasImp,Alltrim(cFicha)) <> 0

//	If Ascan(aProdutos,TRB_SB1->PRODUTO+Alltrim(cEndere)) > 0

		Aadd(aDados,{TRB_SB1->PRODUTO, TRB_SB1->DESCRI, TRB_SB1->UM, TRB_SB1->CODBAR, TRB_SB1->LOCALM,cEndere,cFicha,cAtu_x_Tot})
//	EndIf

	dbSelectArea("TRB_SB1")
	dbSkip()
EndDo

If Select("TRB_SB1") > 0
	dbSelectArea("TRB_SB1")
	dbCloseArea()
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M04E06BCO บAutor  ณ Marcos Rocha      บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Impressใo da Etiqueta                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//Static Function M04E06BCO

//Local cEOL		:= Chr(10)+Chr(13)
//Local cQry		:= " "

//Local nProc 
//For nProc := 1 To mv_par11	
//	Aadd(aDados,{Space(15), Space(10), Space(2), Space(15), Space(2),Space(10),Space(7)})
//Next

/*/
cQry := "SELECT B1_COD PRODUTO, B1_DESC DESCRI, B1_UM UM, B1_CODBAR CODBAR, B1_XCLASIN TIPINV, BF_LOCAL LOCALM , BF_LOCALIZ LOCALIZ" +cEOL
cQry += " FROM "+RetSqlName("SB1")+" SB1 ,"+RetSqlName("SBF")+" SBF "+cEOL
cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"+cEOL
cQry += " AND B1_COD = '"+mv_par09+"' "+cEOL
cQry += " AND B1_TIPO IN ('BN','EM','ME','MI','MP','PA','PI','PP') "+cEOL
cQry += " AND SB1.D_E_L_E_T_ <> '*' "+cEOL
If mv_par06 == 1  // Com Endere็o
	cQry += " AND BF_FILIAL = '"+xFilial("SBF")+"'"+cEOL
	cQry += " AND BF_PRODUTO = B1_COD "+cEOL
	cQry += " AND BF_LOCAL = '"+mv_par10+"' "+cEOL
	cQry += " AND LEFT(BF_LOCALIZ,8) = '"+mv_par11+"' "+cEOL
	cQry += " AND SBF.D_E_L_E_T_ <> '*' "+cEOL
	cQry += " ORDER BY B1_COD, BF_LOCALIZ "+cEOL
Else
	cQry += " ORDER BY B1_COD "+cEOL
EndIf

If Select("TRB_SB1") > 0
	dbSelectArea("TRB_SB1")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SB1", .F., .T.)

//aFichasImp := {}
//Aadd(aFichasimp,'50-1407')

dbSelectArea("TRB_SB1")
TRB_SB1->(dbGoTop())

ProcRegua(1000)

While TRB_SB1->(!Eof())

	IncProc("Carregando Etiqueras a Imprimir : "+TRB_SB1->PRODUTO)

	cEndere := Left(TRB_SB1->LOCALIZ,8)
	cFicha := AvalFicha(TRB_SB1->PRODUTO,TRB_SB1->LOCALM,cEndere)

//	If Ascan(aFichasImp,Alltrim(cFicha)) <> 0
		Aadd(aDados,{TRB_SB1->PRODUTO, TRB_SB1->DESCRI, TRB_SB1->UM, TRB_SB1->CODBAR, TRB_SB1->LOCALM,cEndere,cFicha})
//	EndIf

	dbSelectArea("TRB_SB1")
	dbSkip()
EndDo

If Select("TRB_SB1") > 0
	dbSelectArea("TRB_SB1")
	dbCloseArea()
EndIf
/*/

//Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M04E06IMP บAutor  ณ Marcos Rocha      บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Impressใo da Etiqueta                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function M04E06IMP()

Local nDevice		:= 6 				//IMP_PDF
Local cDirPadr		:= GetTempPath()	//Diretorio onde serแ salvo o relat๓rio
Local lDisSetup		:= .T.				//Verifica se exibe a tela de setup
Local lViewPDF		:= .T.				//Aviso("Aviso","Deseja visualizar a etiqueta?",{"Sim","Nใo"},,"Aten็ใo:",,"BMPPERG") == 1
Local nAltIni		:= 8.5  //9.95
Local nLarIni       := 14  //16.9	
Local nAltRel		:= 0
Local nLarRel       := 0
Local nFator		:= 20.1 // 30.1 //37.79527559055
Local nAux			:= 0
Local nLinIni		:= 5 //50
Local nLinha		:= 0
Local nCol
Local lNovaPag		:= .T.
Local nLinCodB 
Local nX
Local nProc
Local nProc2
Local nColCodB 
Local cAtu_x_Tot

Private oFont09		:= TFont():New("Arial",,09,,.F.,,,,,.F.,.F.)
Private oFont09N 	:= TFont():New("Arial",,09,,.T.,,,,,.F.,.F.)
Private oFont10N 	:= TFont():New("Arial",,10,,.T.,,,,,.F.,.F.)
Private oFont10 	:= TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)
Private oFont12N 	:= TFont():New("Arial",,12,,.T.,,,,,.F.,.F.)
Private oFont12 	:= TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)
Private oFont14N 	:= TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
Private oFont16N 	:= TFont():New("Arial",,16,,.T.,,,,,.F.,.F.)
Private oFont18N 	:= TFont():New("Arial",,18,,.T.,,,,,.F.,.F.)
Private oFont24N 	:= TFont():New("Arial",,24,,.T.,,,,,.F.,.F.)
Private oFont28N 	:= TFont():New("Arial",,28,,.T.,,,,,.F.,.F.)
Private oFont32N 	:= TFont():New("Arial",,32,,.T.,,,,,.F.,.F.)
Private oFont72N 	:= TFont():New("Arial",,72,,.T.,,,,,.F.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณStart de Impressใo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrinter := FWMSPrinter():New("M04E06"+Replace(Time(),":",""),nDevice,.F.,,lDisSetup,,,,,,,lViewPDF)
oPrinter := FWMSPrinter():New("M04E06"+Replace(Time(),":",""),nDevice,.F.,,lDisSetup,,,,,,,lViewPDF)

//oPrinter := FWMSPrinter():New(cFileImp, IMP_PDF, .T./*_lAdjustToLegacy*/, cLocal,.T.,,,,,,,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine o local de impressใo padrao caso o Setup esteja desabilitado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lDisSetup
	oPrinter:CPATHPDF := cDirPadr
EndIf

//oPrinter:SetPortrait() 	// Formato do Papel - Retrato = SetPortrait() || Paisagem = SetLandscape()
oPrinter:SetLandscape() 	// Formato do Papel - Retrato = SetPortrait() || Paisagem = SetLandscape()
oPrinter:SetPaperSize(9)	// Tamanho do Papel - 9 = A4

For nX := 1 to Len(aDados)
	
	oPrinter:StartPage()
   	nColCodB    := 1.2
	nCol		:= 12  

	For nProc2 := 1 To 2

		If nProc2 == 2
			If Len(aDados) > nX
				nX ++
			else
				Loop
			EndIf
		EndIf	

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Aplica o fator de conversao para altura e largura padrao do relat๓rio ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nAltRel	  := nAltIni*nFator
		nLarRel   := nLarIni*nFator
		nLinha	  := nLinIni

		nLinCodB  := 6.2

		// PRIMEIRO BLOCO
		oPrinter:Say(nLinha+20,nCol+90,"Inventแrio 2024",oFont16N)
//		oPrinter:SayBitmap(nLinha+7,nCol+303, "\system\Logo_Macom.bmp", 45,35) //  71,190
		oPrinter:SayBitmap(nLinha+13,nCol+270, "\system\Logo_Macom.bmp", 67,32) //  71,190

		nLinha	+= (nFator*0.85)

		cAlmox := aDados[nX,5]
		//cFicha := cAlmox+"-"+StrZero(nX,4)
		cFicha := aDados[nX,7]

		oPrinter:Say(nLinha+20,nCol+95,"Ficha : "+cFicha,oFont14N)
		nLinha	+= (nFator*1.5)

		cUm := aDados[nX,3]

		// Posiciona SB1
		//If mv_par08 == 1
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+aDados[nX,1])
			cTipoInv := SB1->B1_XCLASIN
		//Else
		//	cTipoInv := " "
		//EndIf

		oPrinter:Say(nLinha+07,nCol+5,"Codigo : ",oFont12N)
		oPrinter:Say(nLinha+07,nCol+40,aDados[nX,1],oFont12)

		oPrinter:Say(nLinha+07,nCol+230,cTipoInv,oFont24N)

		cEnderec := aDados[nX,6]
		cAtu_x_Tot := aDados[nX,8]   // Endereco XX/XX
		cAtu_x_Tot := If(cAtu_x_Tot=="01/01",""," - Multi : "+cAtu_x_Tot)

		nLinha	+= (nFator*0.75)
		oPrinter:Say(nLinha+07,nCol+5,"Descric.: ",oFont10N)

		cDescProd1 := Left(aDados[nX,2],35)
		cDescProd2 := SubStr(aDados[nX,2],36,50)
		cDescProd3 := SubStr(aDados[nX,2],86,50)
		oPrinter:Say(nLinha+07,nCol+40,cDescProd1,oFont10)

		nLinha	+= (nFator*0.55)
		oPrinter:Say(nLinha+07,nCol+5,cDescProd2,oFont10)

		nLinha	+= (nFator*0.55)
		oPrinter:Say(nLinha+07,nCol+5,cDescProd3,oFont10)

		nCont := 3
		lImpCont := .T. 

		// 3 BLOCOS
		For nProc := 1 To 3

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Aplica o fator de conversao para altura e largura padrao do relat๓rio ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//			nAltRel	  := nAltIni*nFator
//			nLarRel   := nLarIni*nFator
//			nLinha	  := nLinIni

			cCont := StrZero(nCont,1)

			If nCont == 1   // Nใo Imprime primera contagem
				lImpCont := .F.
//			ElseIf cTipoInv == "D" .And. nCont <> 1
//
			ElseIf cTipoInv == "D" .And. nCont == 3
				lImpCont := .F.
			Else
				lImpCont := .T.
			EndIf

			nLinha	+= (nFator*0.9)
//			oPrinter:Line(nLinha,nCol,nLinha,nCol+330)
			oPrinter:Line(nLinha,nCol,nLinha,nCol+370)

			If 	lImpCont
				oPrinter:Say(nLinha+20,nCol+95,"Ficha : "+cFicha,oFont14N)
			EndIf

			nLinha	+= (nFator*1.3)

			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5,cCont+"a Contagem - Arm : "+cAlmox,oFont12N) // Nome do Armazem
				oPrinter:Say(nLinha+07,nCol+130,"Ender.: "+cEnderec+cAtu_x_Tot,oFont12N)
			EndIf

			nLinha	+= (nFator*0.75)

			If cCont == "3"
				If 	lImpCont
					oPrinter:SayBitmap(nLinha-20,nCol+300, "\system\Inv_Tri.bmp", 45,45) //  71,190
				EndIf
			ElseIf  cCont == "2"
				If 	lImpCont
					oPrinter:SayBitmap(nLinha-20,nCol+300, "\system\Inv_Qua.bmp", 45,45) //  71,190
				EndIf
			ElseIf lImpCont 
				oPrinter:SayBitmap(nLinha-20,nCol+300, "\system\Inv_Cir.bmp", 45,45) //  71,190
			EndIf

			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5,"Codigo : ",oFont12N)
				oPrinter:Say(nLinha+07,nCol+40,aDados[nX,1],oFont12)
			
				oPrinter:Say(nLinha+07,nCol+130,"UM : ",oFont12N)
				oPrinter:Say(nLinha+07,nCol+150,aDados[nX,3],oFont12)
			EndIf

			nLinha	+= (nFator*0.75)

			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5,"Descric.: ",oFont10N)
				cDescProd1 := Left(aDados[nX,2],35)
				cDescProd2 := SubStr(aDados[nX,2],36,50)
				cDescProd3 := SubStr(aDados[nX,2],86,50)

				oPrinter:Say(nLinha+07,nCol+40,cDescProd1,oFont10)
			EndIf
			nLinha	+= (nFator*0.55)

			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5,cDescProd2,oFont10)
			EndIf
			nLinha	+= (nFator*0.55)
			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5,cDescProd3,oFont10)
			EndIf
			nLinha	+= (nFator*1.1)

			If 	lImpCont
				oPrinter:Say(nLinha+07,nCol+5  ,"Qtde :__________ ",oFont14N)
				oPrinter:Say(nLinha+07,nCol+160,"Crachแ 1:__________ ",oFont14N)
			EndIf
			nLinha	+= (nFator*0.75)

			If 	lImpCont

				oPrinter:Say(nLinha+07,nCol+5  ,"Data :____/"+mv_par07,oFont14N)
				oPrinter:Say(nLinha+07,nCol+160,"Crachแ 2:__________ ",oFont14N)
			EndIf

			nLinCodB += 14.0

			If 	lImpCont  //.And. mv_par08 = 1
				cChavebarra := Left(cFicha,2)+SubStr(cFicha,4,4)+cCont+SB1->B1_COD+cEnderec
				oPrinter:FWMSBAR("CODE128",nLinCodB,nColCodB,cChavebarra,oPrinter,.F.,,.T.,0.040,0.6,,,,.F.,)

			EndIf
			//@param nRow Posi็ใo relativa ao topo
			//@param nCol Posi็ใo relativa เ esquerda
			//@param cCodeBar Texto a ser codificado
			//@param nWidth Largura da Barra
			//@param nHeight Altura da Barra
			//@param lSay Indica se deve colocar say com o conte๚do em baixo do c๓digo de barras
			//@param lCheck Indica se deve calcular o digito verificador

			nLinha	+= (nFator*0.75)
			nLinha	+= (nFator*0.75)
			
			nCont --
		Next

//		nCol      += 360
//		nColCodB  += 30.5
		nCol      += 390
		nColCodB  += 33.5

	Next

	lNovaPag 	:= .T.
	nAux		:= 0
	oPrinter:EndPage()
Next nX

//oPrinter:EndPage()

oPrinter:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AvalFicha บAutor  ณ Marcos Rocha      บ Data ณ  08/19/15   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AvalFicha(cProduto,cLocal, cEndere)

Local aArea     := GetArea()
Local cCodFicha := Space(10)
Local cQry

cQry := " SELECT '1' TIPO, CB0_CODETI FICHA"
cQry += " FROM "+RetSqlName("CB0")+" CB0 "
cQry += " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "
cQry += " AND CB0_CODPRO = '"+cProduto+"' "
cQry += " AND CB0_LOCAL = '"+cLocal+"' "
cQry += " AND CB0_LOCALI = '"+cEndere+"' "
cQry += " AND CB0.D_E_L_E_T_ <> '*' "

cQry += " UNION ALL "

cQry += " SELECT '2' TIPO, MAX(CB0_CODETI) FICHA"
cQry += " FROM "+RetSqlName("CB0")+" CB0 "
cQry += " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "
cQry += " AND CB0_LOCAL = '"+cLocal+"' "
cQry += " AND CB0.D_E_L_E_T_ <> '*' "

cQry += " ORDER BY TIPO  "

If Select("TRB_CB0") > 0
	dbSelectArea("TRB_CB0")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_CB0", .F., .T.)
dbSelectArea("TRB_CB0")
TRB_CB0->(dbGoTop())

lCriaCB0 := .f.

While !Eof()
	cCodFicha := TRB_CB0->FICHA
	If TRB_CB0->TIPO == "1"
		Exit
	ElseIf TRB_CB0->TIPO == "2"
		cCodFicha := cLocal+"-"+StrZero(Val(SubStr(cCodFicha,4,4))+1,4)

		lCriaCB0 := .T.
	EndIf
	dbSkip()
EndDo
TRB_CB0->(dbCloseArea())

If Empty(cCodFicha)
	cCodFicha := cLocal+"-0001"
EndIf

If lCriaCB0
	dbSelectArea("CB0")
	RecLock("CB0",.T.)
	CB0->CB0_FILIAL := xFilial("CB0")
	CB0->CB0_CODETI := cCodFicha
	CB0->CB0_TIPO   := "01"   //01=Produto;02=Endereco;03=Unitizador;04=Usuario;05=Volume                                                                       
	CB0->CB0_DTNASC := dDataBase
	CB0->CB0_CODPRO := cProduto
	CB0->CB0_LOCAL  := cLocal
	CB0->CB0_LOCALI := cEndere
	MsUnLock()
Else
//	RecLock("CB0",.F.)
// Incrementa contador de etiquetas reeimpressas
//	MsUnLock()
EndIf

RestArea(aArea)

Return(cCodFicha)
