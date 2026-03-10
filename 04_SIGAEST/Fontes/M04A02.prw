#INCLUDE "Rwmake.ch"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "FWMVCDef.ch"

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

Local aAreaSG1    := SG1->(GetArea())
Local aStruct     := {}
Local lContinua   := .T.
Local lExistEstru := .F.
Local lIncluiPAI  := .F.
//Local aStruDel    := {}
//Local aRecDel     := {}
Local nProc
//Local nProc4
Local nProc3
Local nProc5
Local nLinha     := 0
Local nE

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
cCodPA    := Space(5)
cCodMP    := Space(5)
nQtdMP    := 0
cCodPAAnt := Space(15)

ProcRegua(FT_FLASTREC())

FT_FGOTOP()

While !FT_FEOF()
	
	IncProc("Analisando arquivo...")

	nLinha += 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena na variavel cBuffer a linha do arquivo texto               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := Alltrim(FT_FREADLN())
	cBuffer := Upper(cBuffer)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta variaveis de controle                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//cBuffer := U_RETACENT(cBuffer)
	//cBuffer := StrTran(cBuffer,'"','')
	cBuffer := StrTran(cBuffer,'"','')

	// Ignora a linha do cabecalho  
	/*
	If Left(cBuffer,1) = "A" 
		FT_FSKIP()
		Loop
	EndIf
	*/

	aCampos := {}
	For nProc := 1 To 11
		
		nPos := At(";",cBuffer)

		// Quando a primeira coluna não for uma letra
		If nProc == 1 .And. !Alltrim(Left(cBuffer,nPos-1))$"ABCDEFGHI" 
			Aadd(aLog,"Divergência de LayOut na primeira coluna ! Favor Verificar ! "+" ("+RTRIM(STR(nLinha))+")")
			lContinua := .F.
			Exit
		EndIf

		// Quando a primeira coluna não for uma letra
		If nPos == 0 .And. nProc <> 11
			Aadd(aLog,"Erro na importaçâo do arquivo ! Divergência de quantidade de colunas !"+" ("+RTRIM(STR(nLinha))+")")
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
	cCodPA    := PADR(aCampos[02],TAMSX3("G1_COD")[1])
	cDescPA   := ""
	cCodMP    := PADR(aCampos[03],TAMSX3("G1_COMP")[1])
	cDescMP   := ""
	nQtdMP    := Val(StrTran(aCampos[05],",","."))
	nPerda    := Val(StrTran(aCampos[06],",","."))
	cSeqTRT   := PADR(aCampos[08],TAMSX3("G1_TRT")[1])
	cAnsul    := PADR(aCampos[11],TAMSX3("G1_XANSUL")[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodPA)
		Aadd(aLog,"Código de Produto em Branco. Código : "+cCodPA+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	ElseIf !dbSeek(xFilial("SB1")+cCodPA)
		Aadd(aLog,"Codigo da Produto não encontrado .. Código : "+cCodPA+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	EndIf
	nQtdEmb := SB1->B1_QB
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodMP)
		Aadd(aLog,"Código de Produto Componente em Branco. Código : "+cCodMP+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	ElseIf !dbSeek(xFilial("SB1")+cCodMP)
		Aadd(aLog,"Codigo da Produto Componente não encontrado .. Código : "+cCodMP+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida produto MP. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(cCodMP) == AllTrim(cCodPA)
		Aadd(aLog,"Código de Produto igual ao do Componente  ! Código : "+cCodMP+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	EndIf

	cTipProd := SB1->B1_TIPO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca e Valida a Quantidade de MP e tipo de registro. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If cCodSeq == "A"  // Ignora a primeira linha - Cabec 
		FT_FSKIP()
		Loop
	EndIf	
	*/

	If nQtdMP <= 0.000
		Aadd(aLog,"Quantidade do Componente Zero.. Código : "+cCodMP+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	EndIf	

	If !cAnsul $ " NIE"
		Aadd(aLog,"Informação Ansul Invalida.. Deve conter Branco, N=Não, I-Interno ou E=Externo. Código : "+cCodMP+" - Ansul : "+cAnsul+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.	
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se já existe estrutura cadastrada. Só alguns usuários pode re-importar. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+cCodPA)
		lExistEstru := .T.

		Aadd(aLog,"Produto com estrutura já existente : "+cCodPA+" ("+RTRIM(STR(nLinha))+")")

		If !RetCodUsr() $ GetMv("AM_M04A02")		//#8213
			Aadd(aLog,"Usuario sem acesso para importar/atualizar estrutura já existente : "+cCodPA+" ("+RTRIM(STR(nLinha))+")")

			FT_FSKIP()

			lContinua := .F.
			Loop 
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida duplicidade.                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosStr	:= aScan(aStruct,{|x| x[1]+x[2]+x[10] == cCodPA+cCodMP+cSeqTRT})
	If nPosStr > 0   //.and. !RetCodUsr() $ GetMv("AM_M04A02")											//#8213
		Aadd(aLog,"Existem componentes iguais na estrutura com a mesma sequência Pai/Filho/TRT : "+cCodPA+cCodMP+cSeqTRT+" ("+RTRIM(STR(nLinha))+")")
		FT_FSKIP()
		lContinua := .F.
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta a Matriz com a Estrutura.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aStruct,{cCodPA, cCodMP, nQtdMP, cDescPA, cDescMP, nQtdEmb, cTipProd,nPerda,cAnsul,cSeqTRT,cCodSeq})
	
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

If 	lContinua .And. lExistEstru
	If Aviso("PRODUTOJAEXISTE",OemToAnsi("Produtos com estruturas já existentes!"),{"Abandona","Sobrepõe"}) = 1
		lContinua := .F.
	EndIf
EndIf

If lContinua

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificacao da Quantidade de Estruturas ou Sub-estruturas (Resumo       ³
	//³ das Estruturas a serem importadas)                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodPai := ""
	aQtdEstru := {}
	For nProc := 1 To Len(aStruct)

		If aStruct[nProc,11] == "A"
			cCodPai := aStruct[nProc,1]
		EndIf

		nPos	:= aScan(aQtdEstru,{|x| x[1] == cCodPai })
		If nPos == 0
			Aadd(aQtdEstru,{cCodPai,;
							1,;
							POSICIONE("SB1",1,XFILIAL("SB1")+cCodPai,"B1_REVATU")/*Space(3)*/,;
							.F.,;
							aStruct[nProc,2],;
							aStruct[nProc,3],;
							aStruct[nProc,8],; // Codigo, Quant de Produtos, Revisao, Usou ja cadastrada ou Importou e Qtd.Comp, qtd, Perda
							{},; //8-Componentes
							"",; //9-Msg.Error
							""}) //10-Nova Revisão

			nPos := Len(aQtdEstru)
		EndIf			
		aQtdEstru[nPos,2] ++
		AADD(aQtdEstru[nPos,8],ACLONE(aStruct[nProc]))
	Next

	ProcRegua(Len(aQtdEstru))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificacao de Estrutura ja existente para cada SubEstruturas           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nProc := 1 To Len(aQtdEstru)

		IncProc("Gravando Estrutura...")
		
		cProduto    := Left(aQtdEstru[nProc,1]+Space(15),15)
		nQtdEmb     := 1  // Quantidade Base de Estrutura


		dbSelectArea("SG1")
		dbSetOrder(1)
		lIncluiPAI := !dbSeek(xFilial("SG1")+cProduto)

		aEstrImp := {}
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta uma matriz somente com a SubEstrutura Corrente                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nProc3 := 1 To Len(aQtdEstru[nProc,8])

				Aadd(aEstrImp,{	aQtdEstru[nProc,8][nProc3,1],;
								aQtdEstru[nProc,8][nProc3,2],;
								aQtdEstru[nProc,8][nProc3,3],;
								aQtdEstru[nProc,8][nProc3,8],;
								aQtdEstru[nProc,8][nProc3,9],;
								aQtdEstru[nProc,8][nProc3,10]})

				//Verifica se existe estrutura para o componente
				dbSelectArea("SG1")
				If dbSeek(xFilial("SG1")+aQtdEstru[nProc,8][nProc3,2])
					
					If Ascan(aQtdEstru[nProc,8],{|x|x[1]==aQtdEstru[nProc,8][nProc3,2]}) == 0

						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1")+aQtdEstru[nProc,8][nProc3,2]))

						cRevisao := SB1->B1_REVATU //IIF(EMPTY(SB1->B1_REVATU),"001",SB1->B1_REVATU)

						aEstruAtu := {}
						aEstruAtu := MontaEstru(aQtdEstru[nProc,8][nProc3,2],SB1->B1_REVATU,aEstruAtu)

						For nE := 1 To Len(aEstruAtu)

							Aadd(aEstrImp,{	aEstruAtu[nE,1],; //1-CODIGO
											aEstruAtu[nE,2],; //2-COMPONENTE
											aEstruAtu[nE,4],; //3-QUANTIDADE
											aEstruAtu[nE,5],; //4-PERDA
											aEstruAtu[nE,6],; //5-ANSUL
											aEstruAtu[nE,3]}) //6-TRT

						Next

					EndIf

				EndIf

		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava estrutura         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aErro := M04M02Est(cProduto,aEstrImp,lIncluiPAI)

		If aErro[1]
			aQtdEstru[nProc,4] := .T.
			aQtdEstru[nProc,9] := ""
			aQtdEstru[nProc,10] := SB1->B1_REVATU
		Else
			aQtdEstru[nProc,4] := .F.
			aQtdEstru[nProc,9] := aErro[2]
			Aadd(aLog,aErro[2])
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Pré Estrutura. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M04M02Pre(cProduto,aEstrImp)

	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe Resumo de Revisoes utilizadas ou Criadas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta aHeader. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader:={}
	Aadd(aHeader,{ "Seq"             , "SEQ"     , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Produto"         , "PRODUTO" , "@!",15 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Descricao"       , "DESCRIC" , "@!",20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Qtd.PI/MP"       , "QTDPIMP" , "@E 999,999.999",06, 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "N","TRB"})
	Aadd(aHeader,{ "Revisao Anterior", "REVISAO" , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Nova Revisao."   , "REVATU"  , "@!",03 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Status"          , "STATUS"  , "@!",20 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C","TRB"})
	Aadd(aHeader,{ "Msg.Erro"        , "MSGERRO" , "@X",80 , 00,".F.","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "M","TRB"})
	nUsado := 4

	_nItem := 0
	Acols:={}
	For nProc5 := 1 To Len(aQtdEstru)
		_nItem++
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aQtdEstru[nProc5,1])
		Aadd(Acols,{StrZero(_nItem,3),aQtdEstru[nProc5,1],Left(SB1->B1_DESC,30),aQtdEstru[nProc5,2],aQtdEstru[nProc5,3],aQtdEstru[nProc5,10],If(aQtdEstru[nProc5,4],"Ok","Erro"),aQtdEstru[nProc5,9],.F.})

	Next

	@ 150,1 TO 430,630 Dialog oDlg1 Title "Resumo da Importação"

	@ 010,010 TO 105,300 Multiline Object oLinhas
	@ 115,270 BmpButton Type 1 Action Close(oDlg1)

	Activate Dialog oDlg1 Centered

EndIf

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
	M04A02EXC()
EndIf

RestArea(aAreaSG1)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M04A02EXC³ Autor ³ Montes                ³ Data ³16/12/2024³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para exportacao de dados para Excel                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M04A02EXC()

    Local oFWMsExcel := FWMsExcelEx():New() 
    Local cArquivo   := GetTempPath() + AllTrim(Str(Randomize(1,34000))) + ".xml"
    Local cPastaExc  := "LOG Importação Estrutura"
    Local cTabelaExc := "inconsistencias"
    Local nCont      := 0
    Local oOpenExcel as object

    oFWMsExcel:AddworkSheet(cPastaExc)

    oFWMsExcel:AddTable (cPastaExc,cTabelaExc)
    oFWMsExcel:AddColumn(cPastaExc,cTabelaExc,"inconsistencias",1,1)

    oFWMsExcel:SetCelBold(.T.)
    oFWMsExcel:SetCelFont('Arial')
    oFWMsExcel:SetCelItalic(.T.)
    oFWMsExcel:SetCelUnderLine(.T.)
    oFWMsExcel:SetCelSizeFont(10)

    For nCont := 1 To Len(aLog)

        oFWMsExcel:AddRow(cPastaExc,cTabelaExc,{aLog[nCont]})

    Next nCont

    oFWMsExcel:Activate()

    oFWMsExcel:GetXMLFile(cArquivo)

    oFWMSExcel:DeActivate()

    //Abrindo o excel e abrindo o arquivo xml
    IF GetRemoteType() == 1
        oOpenExcel := MsExcel():New()           //Abre uma nova conexo com Excel
        oOpenExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
        oOpenExcel:SetVisible(.T.)              //Visualiza a planilha
        oOpenExcel:Destroy()
    EndIf

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

Private aRotina   := { 	{ "Pesquisar"  , "AxPesqui"     , 0, 1 },;
						{ "Visualizar" , "PCPA200MNU(2)", 0, 2 },;
						{ "Importar"   , 'U_M04A021'    , 0, 3 }}

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
±±ºDescricao ³ Atualiza Pré Estrutura.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M04M02Pre(cProduto,aEstrImp)

Local nProc5

// Deletando Registros da SGG
For nProc5 := 1 To Len(aEstrImp)

	cProduto := aEstrImp[nProc5,1]
	
	dbSelectArea("SGG")
	dbSetOrder(1)
	dbSeek(xFilial("SGG")+cProduto)
	While !Eof() .And. SGG->GG_FILIAL+SGG->GG_COD == xFilial("SGG")+cProduto
		RecLock("SGG",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo
Next

// Criando registros na SGG
For nProc5 := 1 To Len(aEstrImp)

	RecLock("SGG",.T.)
	SGG->GG_FILIAL := xFilial("SGG")
	SGG->GG_COD    := aEstrImp[nProc5,1]
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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ M04M02EstºAutor  ³ Montes-Moovegestão º Data ³ 09/10/2025  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inclusão/Alteração                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M04M02Est(cProduto,aEstrImp,lIncluiPAI)

Local aEstruAtu    := {}
Local aProduto     := {}
Local aComponentes := {}
Local nE, nP
Local cErrorLog    := ""
Local lMsErroAuto  := .F.

SG1->(dbSetOrder(1)) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cProduto))

cRevisao := SB1->B1_REVATU //IIF(EMPTY(SB1->B1_REVATU),"001",SB1->B1_REVATU)

aEstruAtu := MontaEstru(cProduto,cRevisao,aEstruAtu)

aProduto := {	{"G1_COD"   , cProduto , NIL},; //Código do produto PAI.
         		{"G1_QUANT" , nQtdEmb  , NIL},; //Quantidade base do produto PAI.
         		{"AUTREVPAI", cRevisao , NIL},; //A variável AUTREVPAI é utilizada para indicar qual a revisão do produto pai será considerada. Caso não seja enviado, será utilizada a revisão atual do produto.
         		{"ATUREVSB1", "S"      , NIL},; //A variável ATUREVSB1 é utilizada para gerar nova revisão quando MV_REVAUT=.F.
         		{"NIVALT"   , "S"      , NIL}}  //A variável NIVALT é utilizada para recalcular ou não os níveis da estrutura.

//Atualiza os componentes existentes na estrutura atual
For nE := 1 To LEN(aEstruAtu)

	nPosNew := ASCAN(aEstrImp,{|x|x[1]==aEstruAtu[nE,1].And.x[2]==aEstruAtu[nE,2].And.x[6]==aEstruAtu[nE,3]})

	aItemComp := {}
	If nPosNew > 0
		Aadd(aItemComp,{"G1_COD"	,aEstrImp[nPosNew,1],NIL})
		Aadd(aItemComp,{"G1_COMP"	,aEstrImp[nPosNew,2],NIL})
		Aadd(aItemComp,{"G1_TRT"	,aEstrImp[nPosNew,6]/*Space(3)*/,NIL})  
		Aadd(aItemComp,{"G1_QUANT"	,aEstrImp[nPosNew,3],NIL})
		Aadd(aItemComp,{"G1_INI"	,Ctod("01/01/2024"),NIL})
		Aadd(aItemComp,{"G1_FIM"	,Ctod("31/12/2049"),NIL})
		Aadd(aItemComp,{"G1_FIXVAR"	,"V",NIL})
		Aadd(aItemComp,{"G1_PERDA"	,aEstrImp[nPosNew,4],NIL})
		Aadd(aItemComp,{"G1_XANSUL"	,If(aEstrImp[nPosNew,5]=="I","1",If(aEstrImp[nPosNew,5]=="E","2","3")),NIL})
		Aadd(aItemComp,{"LINPOS"  	,"G1_FILIAL+G1_COD+G1_COMP+G1_TRT",xFilial("SG1"),aEstrImp[nPosNew,1],aEstrImp[nPosNew,2],aEstrImp[nPosNew,6]})
		//Aadd(aItemComp,{"AUTDELETA" ,"N",NIL})
	Else
		Aadd(aItemComp,{"G1_COD"	,aEstruAtu[nE,1],NIL})
		Aadd(aItemComp,{"G1_COMP"	,aEstruAtu[nE,2],NIL})
		Aadd(aItemComp,{"G1_TRT"	,aEstruAtu[nE,3]/*STRZERO(nE,3)*/,NIL})  
		Aadd(aItemComp,{"LINPOS"  	,"G1_FILIAL+G1_COD+G1_COMP+G1_TRT",xFilial("SG1"),aEstruAtu[nE,1],aEstruAtu[nE,2],aEstruAtu[nE,3]})
		Aadd(aItemComp,{"AUTDELETA" ,"S",NIL})
	EndIf

	Aadd(aComponentes,aclone(aItemComp))

Next

//Adiciona os componentes novos que nao existem na estrutura atual
For nP := 1 To LEN(aEstrImp)

	nPosNew := ASCAN(aEstruAtu,{|x|x[1]==aEstrImp[nP,1].And.x[2]==aEstrImp[nP,2].And.x[3]==aEstrImp[nP,6]})

	If nPosNew = 0
		aItemComp := {}
		Aadd(aItemComp,{"G1_COD"	,aEstrImp[nP,1],NIL})
		Aadd(aItemComp,{"G1_COMP"	,aEstrImp[nP,2],NIL})
		Aadd(aItemComp,{"G1_TRT"	,aEstrImp[nP,6]/*Space(3)*/,NIL})
		Aadd(aItemComp,{"G1_QUANT"	,aEstrImp[nP,3],NIL})
		Aadd(aItemComp,{"G1_INI"	,Ctod("01/01/2024"),NIL})
		Aadd(aItemComp,{"G1_FIM"	,Ctod("31/12/2049"),NIL})
		Aadd(aItemComp,{"G1_FIXVAR"	,"V",NIL})
		Aadd(aItemComp,{"G1_PERDA"	,aEstrImp[nP,4],NIL})
		Aadd(aItemComp,{"G1_XANSUL"	,If(aEstrImp[nP,5]=="I","1",If(aEstrImp[nP,5]=="E","2","3")),NIL})
		//Aadd(aItemComp,{"AUTDELETA" ,"N",NIL})

		Aadd(aComponentes,aclone(aItemComp))
	EndIf

Next

MSExecAuto({|x,y,z| PCPA200(x,y,z)},aProduto,aComponentes,IIF(!lIncluiPAI,4,3))

//Se conseguir executar a operação automática
If !lMsErroAuto 
				
	lRet := .T.

Else

    cErrorLog := MemoRead(NomeAutoLog())
    //MostraErro()

	lRet := .F.
	lMsErroAuto := .F.

EndIf

Return {lRet,cErrorLog}

/*

Monta array com a estrutura do Protheus e seus Niveis

*/
Static Function MontaEstru(cProduto,cRevisao,aEstrutura)

Local nRecAnt    := 0
Local cComp      := ''
Local cRevPI 	 := ""
Local lRet		 := .T.
Local lContinua	 := .T.
Local lExpand    := .T. 
Local lExibeOPC  := .T.
Local nIndSG1	 := 1
Local lOpcional  := .F.
Local lOpcAux    := .T.
Local lPCPREVATU := FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)

//-- Posiciona no SB1
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial('SB1') + cProduto, .F.))

DEFAULT cRevisao := SB1->B1_REVATU

SG1->(dbSetOrder(nIndSG1))
If !SG1->(dbSeek(xFilial('SG1') + cProduto, .F.))
	lRet := .F.
EndIf

If lRet .And. lContinua
	
	cTRTPai := If(cTRTPai==Nil,SG1->G1_TRT,cTRTPai)

	While !SG1->(Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

		lExpEst := .T.

		//-- Nao Adiciona Componentes fora da Revis„o
		If (cRevisao # Nil) .And. ;
			!(SG1->G1_REVINI <= cRevisao .And. (SG1->G1_REVFIM >= cRevisao .Or. SG1->G1_REVFIM = ' '))
			SG1->(dbSkip())
			Loop
		EndIf

		lAtivo := .T.
		If dDataBase < SG1->G1_INI .Or. dDataBase > SG1->G1_FIM
			lAtivo := .F.
		EndIf


		If lAtivo

			nRecAnt  := SG1->(Recno())
			cComp    := SG1->G1_COMP
			cSeqTRT  := SG1->G1_TRT

			If Empty(SG1->G1_GROPC)
				lOpcAux := .F.
			Else
				lOpcAux := .T.
			EndIf


			//-- Posiciona no SB1
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1') + cComp, .F.))

			AADD(aEstrutura,{cProduto,cComp,cSeqTRT,SG1->G1_QUANT,SG1->G1_PERDA,SG1->G1_XANSUL})

			If SG1->(dbSeek(xFilial('SG1') + SG1->G1_COMP, .F.)) 

				cRevPi := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU)
				If empty(cRevPI)
					cRevPi := '001'
				EndIf

				If lExpand .And. lExibeOPC
					//-- Adiciona um Nivel a Estrutura
					If cComp == SG1->G1_COD .And. !lOpcAux
						lOpcional := .F.
					Else
						lOpcional := .T.
					EndIf
					aEstrutura := MontaEstru(SG1->G1_COD,cRevPI,aEstrutura)
				EndIf
			EndIf
		EndIf

		SG1->(dbGoto(nRecAnt))
		SG1->(dbSkip())
	EndDo
EndIf

Return aEstrutura
