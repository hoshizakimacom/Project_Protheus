#INCLUDE "Rwmake.ch"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M04A02  º Autor ³ Marcos Eduardo Rocha º Data ³ 30/03/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa Estrutura de Produtos                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Macom                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M04A02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := OemToAnsi("Importação de Estrutura de Produtos")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa??o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina	:= MenuDef()

mBrowse(06,01,22,75,"SG1")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M04A021  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³24/04/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M04A021(cAlias,nReg,nOpcx)

Private nHdl	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cType    := "Arquivos nao Processados | *.CSV | Arquivos ja Processados | *.PRC "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o arquivo                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo de interface"),1,"",.F.,GETF_LOCALHARD + GETF_NETWORKDRIVE)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se o arquivo existe                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(cArq)
	Aviso("Atenção !","Arquivo selecionado nao Localizado !",{"Ok"})
	Return
EndIf

Processa({|| U_M04A022(cArq) },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M04A022  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³24/04/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M04A022(cArq)

Local aAreaSG1  := SG1->(GetArea())
Local aStruct   := {}
Local lContinua := .T.
Local aStruDel  := {}
Local aRecDel   := {}
Local nProc
Local nProc4
Local nProc3
Local nProc5
//Local cEmail    := GetMv("PR_MAILSTD")
Private aLog	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl := FT_FUSE(cArq)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se conseguiu abrir o arquivo texto                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdl <> Nil .and. nHdl <= 0
	
	Aviso("Atenção !","Não foi possível a abertura do arquivo "+Alltrim(cArq)+" !",{"Ok"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha o arquivo texto                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUSE()
	
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a leitura sequencial do arquivo                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodPA   := Space(5)
cCodMP   := Space(5)
nQtdMP   := 0
cCodPAAnt := Space(15)

ProcRegua(FT_FLASTREC())

FT_FGOTOP()

While !FT_FEOF()
	
	IncProc("Analisando arquivo...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena na variavel cBuffer a linha do arquivo texto               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := Alltrim(FT_FREADLN())
	cBuffer := Upper(cBuffer)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta variaveis de controle                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//cBuffer := U_RETACENT(cBuffer)
	//   cBuffer := StrTran(cBuffer,'"','')
	cBuffer := StrTran(cBuffer,'"','')

	// Ignora a linha do cabecalho  
	If Left(cBuffer,1) = "A" 
		FT_FSKIP()
		Loop
	EndIf

	aCampos := {}
	For nProc := 1 To 11
		
//		MsgStop("teste 1.1")

		nPos := At(";",cBuffer)

		// Quando a primeira coluna não for uma letra
		If nProc == 1 .And. !Alltrim(Left(cBuffer,nPos-1))$"ABCDEFGHI" 
			MsgStop(OemToAnsi("Divergência de LayOut na primeira coluna ! Favor Verificar ! "))
			lContinua := .F.
			Exit
		EndIf

		// Quando a primeira coluna não for uma letra
		If nPos == 0 .And. nProc <> 11
			MsgStop(OemToAnsi("Erro na importaçâo do arquivo ! Divergência de quantidade de colunas !"))
			lContinua := .F.
			Exit
		ElseIf nPos == 0
			nPos := 100
		EndIf

		Aadd(aCampos,Left(cBuffer,nPos-1))
		cBuffer := SubStr(cBuffer,nPos+1)
	Next
	
	If !lContinua
		Exit
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto PAI. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodSeq   := AllTrim(aCampos[01])
	cCodPA    := AllTrim(aCampos[02])
	cDescPA   := ""
	cCodMP    := AllTrim(aCampos[03])
	cDescMP   := ""
	nQtdMP    := Val(StrTran(aCampos[05],",","."))
	nPerda    := Val(StrTran(aCampos[06],",","."))	
	cSeqTRT   := AllTrim(aCampos[08]) 
	cAnsul    := AllTrim(aCampos[11])

	// RevIni
	// RevFim
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodPA)
		MsgStop(OemToAnsi("Código de Produto em Branco ! Código : ")+cCodPA)
		Aadd(aLog,"Código de Produto em Branco. Código : "+cCodMP)
		FT_FSKIP()
		Loop
	ElseIf !dbSeek(xFilial("SB1")+cCodPA)
		MsgStop(OemToAnsi("Código de Produto não encontrado, socilitar inclusão ao Depto de Cadastro.. Código : ")+cCodPA)
		Aadd(aLog,"Codigo da Produto não encontrado .. Código : "+cCodPA)
		FT_FSKIP()
		Loop
	EndIf
	nQtdEmb := SB1->B1_QB
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodMP)
		MsgStop(OemToAnsi("Código de Produto Componente em Branco ! Código : ")+cCodMP)
		Aadd(aLog,"Código de Produto  Componente em Branco. Código : "+cCodMP)
		FT_FSKIP()
		Loop
	ElseIf !dbSeek(xFilial("SB1")+cCodMP)
		MsgStop(OemToAnsi("Código de Produto Componente não encontrado, socilitar inclusão ao Depto de Cadastro.. Código : ")+cCodMP)
		Aadd(aLog,"Codigo da Produto Componente não encontrado .. Código : "+cCodMP)
		FT_FSKIP()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(cCodMP) == AllTrim(cCodPA)
		MsgStop(OemToAnsi("Código de Produto igual ao do Componente ! Código : ")+cCodMP)
		Aadd(aLog,"Código de Produto igual ao do Componente  ! Código : "+cCodMP)
		FT_FSKIP()
		Loop
	EndIf

	cTipProd := SB1->B1_TIPO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida a Quantidade de MP e tipo de registro. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCodSeq == "A"  // Ignora a primeira linha - Cabec 
		FT_FSKIP()
		Loop
	EndIf	

	If nQtdMP <= 0.000
		MsgStop(OemToAnsi("Quantidade do Componente Zero.. Código : ")+cCodMP)
		Aadd(aLog,"Quantidade do Componente Zero.. Código : "+cCodMP)
		FT_FSKIP()
		Loop
	EndIf	

	If !cAnsul $ " NIE"
		MsgStop(OemToAnsi("Informação Ansul Invalida.. Deve conter Branco, N=Não, I-Interno ou E=Externo. Código : ")+cCodMP+" - Ansul : "+cAnsul)
		Aadd(aLog,"Informação Ansul Invalida.. Deve conter Branco, N=Não, I-Interno ou E=Externo. Código : "+cCodMP+" - Ansul : "+cAnsul)
		FT_FSKIP()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se já existe estrutura cadastrada. Só alguns usuários pode re-importar. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !RetCodUsr() $ GetMv("AM_M04A02")		//#8213

		// Deletando a Estrutura Atual
		dbSelectArea("SG1")
		dbSetOrder(1)
		If dbSeek(xFilial("SG1")+cCodPA)
			MsgStop(OemToAnsi("Usuario sem acesso para importar/atualizar estrutura já existente : ")+cCodPA)
			Aadd(aLog,"Usuario sem acesso para importar/atualizar estrutura já existente : "+cCodPA)
		EndIf

		FT_FSKIP()

		lContinua := .F.
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida duplicidade.                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosStr	:= aScan(aStruct,{|x| AllTrim(x[1])+AllTrim(x[2])+AllTrim(x[10]) == cCodPA+cCodMP+cSeqTRT})
	If nPosStr > 0   //.and. !RetCodUsr() $ GetMv("AM_M04A02")											//#8213
		MsgStop(OemToAnsi("Existem componentes iguais na estrutura com a mesma sequência Pai/Filho/TRT : ")+cCodPA+cCodMP+cSeqTRT)
		Aadd(aLog,"Existem componentes iguais na estrutura com a mesma sequência Pai/Filho/TRT : "+cCodPA+cCodMP+cSeqTRT)
		FT_FSKIP()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta a Matriz com a Estrutura.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aStruct,{cCodPA, cCodMP, nQtdMP, cDescPA, cDescMP, nQtdEmb, cTipProd,nPerda,cAnsul,cSeqTRT})
	cCodPAAnt := cCodPA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona na proxima linha                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FSKIP()
EndDo


//MsgStop("Quantidade registros lidos : "+Str(Len(aStruct)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo texto                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FUSE()

If !lContinua
	RestArea(aAreaSG1)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacao da Quantidade de Estruturas ou Sub-estruturas (Resumo       ³
//³ das Estruturas a serem importadas)                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//MsgStop("teste 4")

aQtdEstru := {}
For nProc := 1 To Len(aStruct)

	nPos	:= aScan(aQtdEstru,{|x| AllTrim(x[1]) == AllTrim(aStruct[nProc,1])})
	If nPos == 0
		Aadd(aQtdEstru,{aStruct[nProc,1],;
		1,;
		Space(3),;
		.F.,;
		aStruct[nProc,2],;
		aStruct[nProc,3],;
		aStruct[nProc,8]})  // Codigo, Quant de Produtos, Revisao, Usou ja cadastrada ou Importou e Qtd.Comp, qtd, Perda

	Else
		aQtdEstru[nPos,2] ++
//		If aStruct[nProc,07] $ "MP/PA/PI"
//			aQtdEstru[nPos,6] += aStruct[nProc,3]
//		EndIf
	EndIf
	
Next

ProcRegua(Len(aQtdEstru))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacao de Estrutura ja existente para cada SubEstruturas           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nProc := 1 To Len(aQtdEstru)
	
	IncProc("Gravando Estrutura...")
	
	cProduto    := Left(aQtdEstru[nProc,1]+Space(15),15)
	//cDescProd := aQtdEstru[nProc,5]
	nQtdEmb     := 1  //aQtdEstru[nProc,7]
	
	aEstrImp := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a formula fecha 100%. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If aQtdEstru[nProc,6] <> 1.000000
//		Aadd(aLog,"Formula do Produto "+cProduto+" nao fechada !"+TransForm(aQtdEstru[nProc,6] ,"999,999.999999"))
//		Exit
//	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta uma matriz somente com a SubEstrutura Corrente                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nProc3 := 1 To Len(aStruct)

		If AllTrim(aStruct[nProc3,1]) == AllTrim(cProduto)

//			If aScan(aEstrImp,{|x| AllTrim(x[1])+AllTrim(x[2])+AllTrim(x[6]) == ;
//				AllTrim(aStruct[nProc3,1])+AllTrim(aStruct[nProc3,2])+AllTrim(aStruct[nProc3,10]) }) == 0

				Aadd(aEstrImp,{aStruct[nProc3,1],;
				aStruct[nProc3,2],;
				aStruct[nProc3,3],;
				aStruct[nProc3,8],;
				aStruct[nProc3,9],;
				aStruct[nProc3,10]})

//			EndIf
		EndIf
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca a Quantidade de revisoes do Produto.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*/
	cQuery := " SELECT REVISAO AS REVISAO FROM ("
	cQuery += " SELECT SG1.G1_REVINI AS REVISAO "
	cQuery += " FROM "+RetSqlName("SG1")+" SG1"
	cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND SG1.D_E_L_E_T_ <> '*'"
	cQuery += " AND SG1.G1_COD = '"+cProduto+"'"
	cQuery += " GROUP BY G1_REVINI"
	cQuery += " UNION "
	
	cQuery += " SELECT SG1.G1_REVFIM AS REVISAO "
	cQuery += " FROM "+RetSqlName("SG1")+" SG1 "
	cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND SG1.D_E_L_E_T_ <> '*'"
	cQuery += " AND SG1.G1_COD = '"+cProduto+"'"
	cQuery += " GROUP BY G1_REVFIM )  TAB "
	cQuery += " ORDER BY REVISAO "
	
	aRetRev := U_QryArr(cQuery)
	
	lUsouEstru := .F.
//	cProxRev   := "001"
	cRevisao   := "   "
	cProxSequen := "   "
	/*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Estrutura de cada Revisao. 		                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/	
	For nProc2 := 1 To Len(aRetRev)
		
		cRevisao := aRetRev[nProc2,1]
		cQuery := " SELECT SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SB1.B1_TIPO  "
		cQuery += " FROM "+RetSqlName("SG1")+" SG1 ,"+ RetSqlName("SB1")+" SB1 ,"
		cQuery += " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND SG1.D_E_L_E_T_ <> '*'"
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <> '*'"
		cQuery += " AND SG1.G1_COD = '"+cProduto+"'"
		cQuery += " AND SB1.B1_COD = SG1.G1_COMP "
		cQuery += " AND '"+cRevisao+"' BETWEEN SG1.G1_REVINI AND SG1.G1_REVFIM "
		cQuery += " ORDER BY G1_COMP "
		aRetEstr := U_QryArr(cQuery)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa a comparacao da Estrutura ou SubStrutura                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aRetEstr) == Len(aEstrImp)
			
			aRetEstr := aSort(aRetEstr,,,{|x,y| x[2] > y[2]})
			aEstrImp := aSort(aEstrImp,,,{|x,y| x[2] > y[2]})
			For nProc4 := 1 To Len(aRetEstr)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Nao compara Embalagens e Etiquetas.                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//            If aRetEstr[nProc4,4] <> "MP"
				//               Loop
				//     EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Checa o componente e a quantidade da estrutura com o da importada. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim(aRetEstr[nProc4,2]) <> AllTrim(aEstrImp[nProc4,2]) .Or. aRetEstr[nProc4,3] <> aEstrImp[nProc4,3]
					lUsouEstru := .F.
					Exit
				EndIf
				lUsouEstru := .T.
			Next
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Aborta verificacao quando encontrar uma semelhante. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUsouEstru
			Exit
		EndIf
		
		cProxRev := If(cRevisao=="   ","001",Soma1(cRevisao))
		cProxSequen := If(cProxSequen=="   ","001",Soma1(cProxSequen))
	Next
/*/

	//   Begin Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava uma nova estrutura aproveitando os itens semelhantes da ultima. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If !lUsouEstru
		
		// cRevisao := cProxRev
		// cProxSequen := If(cProxSequen	=="   ","001",Soma1(cProxSequen))
		
		For nProc4 := 1 To Len(aEstrImp)
			
			lCria       := .T.
			cComp :=  Left(aEstrImp[nProc4,2]+Space(15),15)

			//³ Deleta todas do mesmo nível
			If Ascan(aStruDel,cProduto) == 0 
				Aadd(aStruDel,cProduto)

				// Deletando a Estrutura Atual
				dbSelectArea("SG1")
				dbSetOrder(1)
				dbSeek(xFilial("SG1")+cProduto)
				While !Eof() .And. SG1->G1_FILIAL == xFilial("SG1") .And. ;
					SG1->G1_COD == cProduto
					
					//If (SG1->G1_REVINI >= cRevisao .And. SG1->G1_REVFIM <= cRevisao) .And. ;
					//	SG1->G1_QUANT == aEstrImp[nProc4,3]
					//	RecLock("SG1",.F.)
					//	SG1->G1_REVFIM := cProxRev
					//	MsUnLock()
					//	lCria := .F.
					//EndIf
					//cProxSequen := If(SG1->G1_TRT=="   ","001",Soma1(SG1->G1_TRT))

					// Gravar os recnos numa matriz e reaproveitar o registro
					Aadd(aRecDel,Recno())

					RecLock("SG1",.F.)
					dbDelete()
					MsUnLock()

					dbSkip()
				EndDo
			Endif

			cProxSequen := "   "

			// Define a proxima sequencia do TRT
			/*/
			dbSelectArea("SG1")
			dbSetOrder(1)
			dbSeek(xFilial("SG1")+cProduto+cComp)
			While !Eof() .And. SG1->G1_FILIAL == xFilial("SG1") .And. ;
				SG1->G1_COD == cProduto .And. ;
				SG1->G1_COMP == cComp
			
				cProxSequen := If(SG1->G1_TRT=="   ","001",Soma1(SG1->G1_TRT))
				dbSkip()
			EndDo
			/*/

			If lCria
				//If Len(aRecDel) > 0
				//	dbGoto(aRecDel[1])
				//	RecLock("SG1",.F.)
				//	ADEL(aRecDel,1)
				//	ASIZE(aCols,Len(aCols)-1)
				//Else
					RecLock("SG1",.T.)
				//EndIf
				SG1->G1_FILIAL := xFilial("SG1")
				SG1->G1_COD    := cProduto
				SG1->G1_COMP   := aEstrImp[nProc4,2]
				SG1->G1_TRT    := aEstrImp[nProc4,6]  //cProxSequen
				SG1->G1_QUANT  := aEstrImp[nProc4,3]
//				SG1->G1_INI    := FirstDay(dDataBase)
				SG1->G1_INI    := Ctod("01/01/2024")
				SG1->G1_FIM    := Ctod("31/12/2049")
				SG1->G1_FIXVAR := "V"
				SG1->G1_PERDA  := aEstrImp[nProc4,4]
//				SG1->G1_REVINI := cProxRev
//				SG1->G1_REVFIM := cProxRev
				SG1->G1_REVINI := "   "
				SG1->G1_REVFIM := "ZZZ"
				SG1->G1_NIV    := "01"   // Tratar
				SG1->G1_NIVINV := "99"   // Tratar
				SG1->G1_XANSUL := If(aEstrImp[nProc4,5]=="I","1",If(aEstrImp[nProc4,5]=="E","2","3"))
				MsUnLock()
			EndIf
		Next
		aQtdEstru[nProc,4] := .F.  // Nao usou revisao cadastrada
		
//	Else
//		aQtdEstru[nProc,4] := .T. // Usou revisao cadastrada
		
//	EndIf
//	aQtdEstru[nProc,3] := If(lUsouEstru,cRevisao,cProxRev)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Registro no cadastro de revisao de Produtos                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG5")
	dbSetOrder(1)
	If !dbSeek(xFilial("SG5")+cProduto+Space(3))
		RecLock("SG5",.T.)
		SG5->G5_FILIAL  := xFilial("SG5")
		SG5->G5_PRODUTO := cProduto
//		SG5->G5_REVISAO := If(lUsouEstru,cRevisao,cProxRev)
	Else
		RecLock("SG5",.F.)
	EndIf
	SG5->G5_DATAREV := dDataBase
	MsUnLock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Pré Estrutura. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	M04M02Pre(cProduto,aEstrImp)

	//   End Transaction
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe Resumo de Revisoes utilizadas ou Criadas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta aHeader. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:={}
Aadd(aHeader,{ "Seq"       , "SEQ"     , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Produto"   , "PRODUTO" , "@!",15 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Descricao" , "DESCRIC" , "@!",20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Qtd.PI/MP" , "QTDPIMP" , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
Aadd(aHeader,{ "Revisao"   , "REVISAO" , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
//Aadd(aHeader,{ "Qtd.Emb."  , "QTDEMB"  , "@E 999",00 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
Aadd(aHeader,{ "Status"    , "STATUS"  , "@!",20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
nUsado := 4

_nItem := 0
Acols:={}
For nProc5 := 1 To Len(aQtdEstru)
	_nItem++
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aQtdEstru[nProc5,1])
	Aadd(Acols,{StrZero(_nItem,3),aQtdEstru[nProc5,1],Left(SB1->B1_DESC,30),aQtdEstru[nProc5,2],aQtdEstru[nProc5,3],If(aQtdEstru[nProc5,4],"Re-Utilizada Revisao","Criada Nova Revisao"),.F.})

Next

@ 150,1 TO 430,630 Dialog oDlg1 Title "Resumo da Importacao"

//	@ 030,020 TO 115,210 Multiline Modify Delete Valid LineOk() Object oLinhas
@ 010,010 TO 105,300 Multiline Object oLinhas
@ 115,270 BmpButton Type 1 Action Close(oDlg1)

Activate Dialog oDlg1 Centered

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Renomeia o arquivo para processado. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
If "CSV" $ Upper(cArq)
	If "CSV" $ Upper(cArq)
		cArqCop := Left(cArq,At(".",cArq)-1)+".CSV"
	Else
		cArqCop := Left(cArq,At(".",cArq)-1)+".PRC"
	EndIf
	__CopyFile(cArq,cArqCop)
	Ferase(cArq)
EndIf
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o arquivo de log                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aLog) > 0
	MsgStop(OemToAnsi("Atenção ! Relatório de inconsistências na importação !"))
	U_M04A02IMP()
EndIf

RestArea(aAreaSG1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RESTA05IMP³ Autor ³ Marcos Eduardo Rocha  ³ Data ³11/06/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M04A02IMP()

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
Local nProc

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
tamanho   := "P"
limite    := 80
titulo    := PADC("Importacao Estrutura",74)
cDesc1    := PADC("Este programa ira emitir o Log de importacao de Estrutura de Produtos",74)
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2,1,"",1 }
nomeprog  := "M04A02"
cPerg     := "M04A02"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "M04A02"
aOrd      := {}
nTam := 66     // Apenas Informativo

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
cString := ""
wnrel   := SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
EndIf

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

For nProc := 1 To Len(aLog)
	
	If nLin > 50
		@ 0,0 PSay AvalImp(limite)
		nLin := 3
	EndIf
	
	@ nLin,0 PSay aLog[nProc]
	nLin ++
	
Next

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marcos	            ³ Data ³17/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Private aRotina   := { { "Pesquisar"  ,   "AxPesqui"     , 0, 1 },;
{ "Visualizar"      , "AxVisual"     , 0, 2 },;
{ "Importar"        , 'U_M04A021'   , 0, 3 }}

Return(aRotina)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ QryArr   ºAutor  ³                    º Data ³ 21/06/2001  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para rodar uma Query e retornar como Array          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cQuery - Query SQL a ser executado                         º±±
±±ºRetorno   ³ aTrb   - Array com o conteudo da Query                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo MaltaCleyton                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function QryArr(cQuery)

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Gravacao do Ambiente Atual e Variaveis para Utilizacao                   º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
Local aRet    := {}
Local aRet1   := {}
Local aArea   := GetArea()
Local nRegAtu := 0
Local x       := 0

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Ajustes e Execucao da Query                                              º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "_TRB"

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Montagem do Array para Retorno                                           º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
dbSelectArea("_TRB")
aRet1   := Array(Fcount())
nRegAtu := 1

While !Eof()
	
	For x:=1 To Fcount()
		aRet1[x] := FieldGet(x)
	Next
	Aadd(aRet,aclone(aRet1))
	
	dbSkip()
	nRegAtu += 1
Enddo

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Encerra Query e Retorna Ambiente                                         º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍSilvio CazelaÍ¼
dbSelectArea("_TRB")
_TRB->(DbCloseArea())

RestArea(aArea)

Return(aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ M04M02PreºAutor  ³                    º Data ³ 27/02/2024  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FAtualiza Pré Estrutura.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M04M02Pre(cProduto,aEstrImp)

Local nProc5

// Deletando Registros  da SGG
//For nProc5 := 1 To Len(aEstrImp)

// Deletando Registros  da SGG
dbSelectArea("SGG")
dbSetOrder(1)
dbSeek(xFilial("SGG")+cProduto)
While !Eof() .And. SGG->GG_FILIAL+SGG->GG_COD == xFilial("SGG")+cProduto
	RecLock("SGG",.F.)
	dbDelete()
	MsUnLock()
	dbSkip()
EndDo

// Criando registros na SGG
For nProc5 := 1 To Len(aEstrImp)

	RecLock("SGG",.T.)
	SGG->GG_FILIAL := xFilial("SGG")
	SGG->GG_COD    := cProduto
	SGG->GG_COMP   := aEstrImp[nProc5,2]
	SGG->GG_TRT    := aEstrImp[nProc5,6]  //cProxSequen
	SGG->GG_QUANT  := aEstrImp[nProc5,3]
	SGG->GG_INI    := FirstDay(dDataBase)
	SGG->GG_FIM    := Ctod("31/12/2049")
	SGG->GG_FIXVAR := "V"
	SGG->GG_PERDA  := aEstrImp[nProc5,4]
	SGG->GG_REVINI := "   "
	SGG->GG_REVFIM := "ZZZ"
	SGG->GG_NIV    := "01"   // Tratar
	SGG->GG_NIVINV := "99"   // Tratar
	SGG->GG_XANSUL := If(aEstrImp[nProc5,5]=="I","1",If(aEstrImp[nProc5,5]=="E","2","3"))
	MsUnLock()

Next

Return
