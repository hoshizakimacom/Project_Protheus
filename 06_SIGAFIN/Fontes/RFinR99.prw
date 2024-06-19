#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"

//+----------------------------------------------------------------------------------------
User Function RFINR99(cPrefixo,cNumero,cParcela,cCliente,cLoja,cBanco,cAgencia,cConta,nDias,cCarga,dEmissao)
	Local aRegs			:= {}
	Local aTamSX3			:= {}
	Private lEnd				:= .F.
	Private lAuto			:= .F.
	Private nLastKey		:= 0
	Private Tamanho			:= "P"
	Private cDesc1			:= "Este programa tem como objetivo efetuar a impressão do"
	Private cDesc2			:= "Boleto de Cobrança com código de barras, conforme os"
	Private cDesc3			:= "parâmetros definidos pelo usuário."
	Private cString			:= "SE1"
	Private wnrel			:= "RFINR99"
	Private cPerg			:= "FINR99    "

	Private Titulo		:= "Boleto de Cobrança com Código de Barras"
	Private aReturn		:= {"Banco", 1,"Financeiro", 2, 2, 1, "",1 }
	Private aLst			:= {}

	// Verifica se a chamada foi feita por outro programa
	If ValType(cPrefixo)  == "C" .Or.;
		ValType(cNumero)  == "C" .Or.;
		ValType(cParcela) == "C" .Or.;
		ValType(cCliente) == "C" .Or.;
		ValType(cLoja)    == "C" .Or.;
		ValType(cBanco)   == "C" .Or.;
		ValType(cAgencia) == "C" .Or.;
		ValType(cConta)   == "C" .Or.;
		ValType(nDias)    == "N" .Or.;
		ValType(dEmissao)   == "D"
		lAuto	:= .T.
	EndIf

	// Cria array com as perguntas da rotina
	aTamSX3	:= TAMSX3("E1_PREFIXO")
	aAdd(aRegs,{cPerg,"01","Do Prefixo",	 			"","","mv_ch1",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR01","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo",				"","","mv_ch2",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR02","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})

	aTamSX3	:= TAMSX3("E1_NUM")
	aAdd(aRegs,{cPerg,"03","Do Numero", 				"","","mv_ch3",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR03","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero",				"","","mv_ch4",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR04","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})

	aTamSX3	:= TAMSX3("E1_PARCELA")
	aAdd(aRegs,{cPerg,"05","Da Parcela",				"","","mv_ch5",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR05","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","011",	"",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela",				"","","mv_ch6",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR06","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","011",	"",""})

	aTamSX3	:= TAMSX3("E1_CLIENTE")
	aAdd(aRegs,{cPerg,"07","Do Cliente",				"","","mv_ch7",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR07","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","001",	"",""})
	aAdd(aRegs,{cPerg,"08","Ate Cliente",				"","","mv_ch8",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR08","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","001",	"",""})

	aTamSX3	:= TAMSX3("E1_LOJA")
	aAdd(aRegs,{cPerg,"09","Da Loja",					"","","mv_ch9",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR09","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","002",	"",""})
	aAdd(aRegs,{cPerg,"10","Ate Loja",		  			"","","mv_chA",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR10","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","002",	"",""})

	aTamSX3	:= TAMSX3("EE_CODIGO")
	aAdd(aRegs,{cPerg,"11","Banco Cobranca",			"","","mv_chB",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR11","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","SA6",	"","007",	"",""})

	aTamSX3	:= TAMSX3("EE_AGENCIA")
	aAdd(aRegs,{cPerg,"12","Agencia Cobranca",			"","","mv_chC",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR12","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","008",	"",""})

	aTamSX3	:= TAMSX3("EE_CONTA")
	aAdd(aRegs,{cPerg,"13","Conta Cobranca",			"","","mv_chD",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR13","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","009",	"",""})

	aTamSX3	:= TAMSX3("EE_SUBCTA")
	aAdd(aRegs,{cPerg,"14","Carteira Cobrança",			"","","mv_chE",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR14","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"15","Re-Impressao",				"","","mv_chF","N",			01,			00,			2,"C","","MV_PAR15","Sim",	"Sim",	"Sim",	"",						"","Nao",	"Nao",	"Nao",	"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"16","Considera Bco Cliente",		"","","mv_chG","N",			01,			00,			2,"C","","MV_PAR16","Sim",	"Sim",	"Sim",	"",						"","Nao",	"Nao",	"Nao",	"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"17","Traz Titulos Marcados",		"","","mv_chH","N",			01,			00,			2,"C","","MV_PAR17","Sim",	"Sim",	"Sim",	"",						"","Nao",	"Nao",	"Nao",	"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"18","Num dias vencimento  ",		"","","mv_chI","N",			03,			00,		    0,"G","","MV_PAR18",   "",	   "",	   "",	"",						"",   "",   	"",    "",	"","","","","","","","","","","","","","","","","",		"","",		"",""})

	aTamSX3	:= TAMSX3("E1_EMISSAO")
	aAdd(aRegs,{cPerg,"19","Data de Emissao Inicial",		"","","mv_chJ","D",08,	00,		0,"G","","MV_PAR19","",		"",		"",		"01/01/08",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})
	aAdd(aRegs,{cPerg,"20","Data de Emissao Final",			"","","mv_chK","D",08,	00,		0,"G","","MV_PAR20","",		"",		"",		"31/12/08",				"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"",""})

	// Cria SX1 se não existir
	CriaSx1(aRegs,cPerg)

	// Atualiza o SX1 se a chamada foi feita por outro programa
	If lAuto
		dbSelectArea("SA6")
		dbSetOrder(1)

		If !dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta,.f.)
			Aviso("Impressao de Boletos","Configuraçao de banco nao encontrada para o banco "+Alltrim(cbanco)+", agencia "+Alltrim(cAgencia)+", conta "+Alltrim(cConta)+" do cliente "+Alltrim(SA1->A1_NOME)+". Verifique o cadastro de parametros de bancos para que a rotina possa ser gerada.",{"OK"},,"Atencao:")
			DbSelectArea("QUERY")
			Return(Nil)
		EndIf

		cCarteira := SEE->EE_SUBCTA
		cConvenio := Alltrim(SEE->EE_CODEMP)

		dbSelectArea("SX1")
		dbSeTorder(1)
		MsSeek(cPerg)

		While !Eof() .and. SX1->X1_GRUPO == cPerg
			Reclock("SX1",.F.)
			If SX1->X1_ORDEM == "01"
				SX1->X1_CNT01	:= cPrefixo
			ElseIf SX1->X1_ORDEM == "02"
				SX1->X1_CNT01	:= cPrefixo
			ElseIf SX1->X1_ORDEM == "03"
				SX1->X1_CNT01	:= cNumero
			ElseIf SX1->X1_ORDEM == "04"
				SX1->X1_CNT01	:= cNumero
			ElseIf SX1->X1_ORDEM == "05"
				SX1->X1_CNT01	:= cParcela
			ElseIf SX1->X1_ORDEM == "06"
				SX1->X1_CNT01	:= cParcela
			ElseIf SX1->X1_ORDEM == "07"
				SX1->X1_CNT01	:= cCliente
			ElseIf SX1->X1_ORDEM == "08"
				SX1->X1_CNT01	:= cCliente
			ElseIf SX1->X1_ORDEM == "09"
				SX1->X1_CNT01	:= cLoja
			ElseIf SX1->X1_ORDEM == "10"
				SX1->X1_CNT01	:= cLoja
			ElseIf SX1->X1_ORDEM == "11"
				SX1->X1_CNT01	:= SA6->A6_COD
			ElseIf SX1->X1_ORDEM == "12"
				SX1->X1_CNT01	:= SA6->A6_AGENCIA
			ElseIf SX1->X1_ORDEM == "13"
				SX1->X1_CNT01	:= SA6->A6_NUMCON
			ElseIf SX1->X1_ORDEM == "14"
				SX1->X1_CNT01	:= SEE->EE_SUBCTA
			ElseIf SX1->X1_ORDEM == "15"
				SX1->X1_PRESEL	:= 2
			ElseIf SX1->X1_ORDEM == "16'"
				SX1->X1_PRESEL	:= 2
			ElseIf SX1->X1_ORDEM == "17"
				SX1->X1_PRESEL	:= 1
			ElseIf SX1->X1_ORDEM == "18"
				SX1->X1_CNT01	:= Str( nDias, 3 )
			ElseIf SX1->X1_ORDEM == "19"
				SX1->X1_CNT01	:= dEmissao
			ElseIf SX1->X1_ORDEM == "20"
				SX1->X1_CNT01	:= dEmissao
			EndIf

			SX1->(MsUnLock())
			SX1->(dbSkip())
		EndDo

		Pergunte(cPerg,.F.)
	Else
		If !Pergunte(cPerg, .T.)
			Return(Nil)
		EndIf
	EndIf

	//Chama a rotina para carregar os dados a serem processados
	Processa( { |lEnd| CallLst() }, "Selecionando dados a processar", Titulo )

	// Verifica se há dados a serem exibidos
	If Len(aLst) > 0
		Processa( { |lEnd| CallMark() }, "Selecionando dados a processar", Titulo )
	Else
		Aviso(	Titulo,"Não existem dados a serem impressos. Verifique os parâmetros.",{"&Fechar"},,"Sem Dados" )
	EndIf
Return

//+----------------------------------------------------------------------------------------
//	Carrega os registros a serem processados
//+----------------------------------------------------------------------------------------
Static Function CallLst()
	Local aAreaAtu	:= GetArea()
	Local aTamSX3		:= {}
	Local nCnt			:= 0
	Local dDataMax  	:= dDataBase + mv_par18
	Private cQuery		:= ""

	cQry	:= " SELECT SE1.R_E_C_N_O_ AS REGSE1,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,"
	cQry	+= " SE1.E1_LOJA,SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_PORTADO,"
	cQry	+= " SE1.E1_NUMBCO,SE1.E1_PEDIDO,SE1.E1_XRENEG,' '  F2_CARGA"
	cQry	+= " FROM "+RetSqlName( "SE1" ) + " SE1 (NOLOCK) "
	cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQry	+= " AND SE1.E1_SALDO > 0 "
	cQry	+= " AND SE1.E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQry	+= " AND SE1.E1_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQry	+= " AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQry	+= " AND SE1.E1_TIPO IN('NF ','RA', 'FT', 'NDC', 'BOL', 'DP', 'JP')"
	cQry	+= " AND SE1.E1_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQry	+= " AND SE1.E1_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQry	+= " AND SE1.E1_VENCTO <= '"+Dtos(dDataMax)+"'"
	cQry	+= " AND SE1.E1_EMISSAO BETWEEN '" + Dtos(mv_par19) + "' AND '" + Dtos(mv_par20) + "'"

	If mv_par15 == 1    //Verifica se eh reimpressao.
		cQry	+= " AND SE1.E1_NUMBCO <> '"+Space(TAMSX3("E1_NUMBCO")[1])+"'"
		If SE1->(FieldPos("E1_BCOBOL")) > 0
			cQry	+= " AND SE1.E1_BCOBOL = '"+mv_par11+"'"
		Else
			cQry	+= " AND SE1.E1_PORTADO = '"+mv_par11+"'"
		EndIf
	Else
		cQry	+= " AND SE1.E1_NUMBCO = '"+Space(TAMSX3("E1_NUMBCO")[1])+"'"
	Endif

	cQry	+= " AND SE1.D_E_L_E_T_ = '' "
	cQry	+= " ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO"


	// Se existir o alias temporário, fecha para não dar erro
	If Select("RFINR99A") > 0
		dbSelectArea("RFINR99A")
		dbCloseArea()
	EndIf

	// Executa a select no banco para pegar os registros a processar
	TCQUERY cQry NEW ALIAS "RFINR99A"
	dbSelectArea("RFINR99A")
	dbGoTop()

	// Compatibiliza os campos com a TopField
	aTamSX3	:= TAMSX3("E1_EMISSAO")
	TCSETFIELD("RFINR99A", "E1_EMISSAO",	aTamSX3[3], aTamSX3[1], aTamSX3[2])

	aTamSX3	:= TAMSX3("E1_VENCTO")
	TCSETFIELD("RFINR99A", "E1_VENCTO",		aTamSX3[3], aTamSX3[1], aTamSX3[2])

	aTamSX3	:= TAMSX3("E1_VENCREA")
	TCSETFIELD("RFINR99A", "E1_VENCREA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])

	aTamSX3	:= TAMSX3("E1_VALOR")
	TCSETFIELD("RFINR99A", "E1_VALOR",		aTamSX3[3], aTamSX3[1], aTamSX3[2])
	
	aTamSX3	:= TAMSX3("E1_XRENEG")
	TCSETFIELD("RFINR99A", "E1_XRENEG",		aTamSX3[3], aTamSX3[1], aTamSX3[2])	

	// Conta os registros a serem processados
	RFINR99A->( dbEval( { || nCnt++ },,{ || !Eof() } ) )
	dbGoTop()

	// Alimenta array com os dados a serem exibidos na tela de marcação
	dbSelectArea("RFINR99A")
	dbGoTop()
	ProcRegua( nCnt )

	While !Eof()
		IncProc( "Título: " + RFINR99A->E1_PREFIXO +"/"+ RFINR99A->E1_NUM +"/"+ RFINR99A->E1_PARCELA )

		aAdd(aLst, {	(mv_par17 == 1),;
						RFINR99A->E1_PREFIXO,;
						RFINR99A->E1_NUM,;
						RFINR99A->E1_PARCELA,;
						RFINR99A->E1_TIPO,;
						RFINR99A->E1_CLIENTE,;
						RFINR99A->E1_LOJA,;
						RFINR99A->E1_NOMCLI,;
						RFINR99A->E1_EMISSAO,;
						RFINR99A->E1_VENCTO,;
						RFINR99A->E1_VENCREA,;
						RFINR99A->E1_VALOR,;
						RFINR99A->E1_PORTADO,;
						RFINR99A->E1_XRENEG,;
						RFINR99A->F2_CARGA,;
						RFINR99A->REGSE1 })
		dbSelectArea("RFINR99A")
		dbSkip()
	EndDo

	dbSelectArea("RFINR99A")
	dbCloseArea()

	RestArea(aAreaAtu)
Return

//+----------------------------------------------------------------------------------------
//	Monta a tela de impressão gráfica
//+----------------------------------------------------------------------------------------
Static Function CallMark()
	Local oLst
	Local oDlg
	Local oOk		:= LoadBitMap( GetResources(), "LBOK" )
	Local oNo		:= LoadBitMap( GetResources(), "LBNO" )
	Local lExec		:= .F.
	Local lProc		:= .F.
	Local nLoop		:= 0
	Local lChk      := .F.
	Local oChk

	// Monta interface com usuário para efetuar a marcação dos títulos
	DEFINE MSDIALOG oDlg TITLE "Seleção de Títulos" FROM 000,000 TO 400,700 OF oDlg PIXEL
		@ 005,003	LISTBOX oLst ;
					FIELDS HEADER	" ",;
									"Prefixo",;
									"Número",;
									"Parcela",;
									"Tipo",;
									"Cliente",;
									"Loja",;
									"Nome",;
									"Emissão",;
									"Vencimento",;
									"Venc.Real",;
									"Valor",;
									"Portador",;
									"Renegociação";
									"Carga" ;
					COLSIZES	GetTextWidth(0,"BB"),;
								GetTextWidth(0,"BBBB"),;
								GetTextWidth(0,"BBBBB"),;
								GetTextWidth(0,"BB"),;
								GetTextWidth(0,"BB"),;
								GetTextWidth(0,"BBBB"),;
								GetTextWidth(0,"BB"),;
								GetTextWidth(0,"BBBBBBBBBBBB"),;
								GetTextWidth(0,"BBBB"),;
								GetTextWidth(0,"BBBB"),;
								GetTextWidth(0,"BBBB"),;
								GetTextWidth(0,"BBBBBBBBB"),;
								GetTextWidth(0,"BBB"),;
								GetTextWidth(0,"BBBBBBB"),;
								GetTextWidth(0,"BBBB") ;
					ON DBLCLICK(	aLst[oLst:nAt,1] := !aLst[oLst:nAt,1],;
									oLst:Refresh() ) ;
					SIZE 345,170 OF oDlg PIXEL

		oLst:SetArray(aLst)
		oLst:bLine := { || {	If(aLst[oLst:nAt,01], oOk, oNo),;					//Marca
								aLst[oLst:nAt,02],;									//Prefixo
								aLst[oLst:nAt,03],;									//Numero
								aLst[oLst:nAt,04],;									//Parcela
								aLst[oLst:nAt,05],;									//Tipo
								aLst[oLst:nAt,06],;									//Cliente
								aLst[oLst:nAt,07],;									//Loja
								aLst[oLst:nAt,08],;									//Nome
								DToC(aLst[oLst:nAt,09]),;				   			//Emissao
								DToC(aLst[oLst:nAt,10]),;							//Vencimento
								DToC(aLst[oLst:nAt,11]),;							//Vencimento real
								Transform(aLst[oLst:nAt,12], "@E 999,999,999.99"),;//Valor
								aLst[oLst:nAt,13],;									//Portador
								DToC(aLst[oLst:nAt,14]),;							//Renegociação
								aLst[oLst:nAt,15] ;									//Carga
								} }
		@ 185 , 005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca Todos" SIZE 70,10 PIXEL OF oDlg;
		        ON CLICK(Iif(lChk,Marca(lChk,oLst),Marca(lChk,oLst)))

		DEFINE SBUTTON oBtnOk	FROM 180,310 TYPE 1 ACTION(lExec := .T., oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON oBtnCan	FROM 180,275 TYPE 2 ACTION(lExec := .F., oDlg:End()) ENABLE OF oDlg

	ACTIVATE DIALOG oDlg CENTERED

	// Verifica se teclou no botão confirma
	If lExec

		// Verifica se tem algum título marcado
		For nLoop := 1 To Len(aLst)
			If aLst[nLoop,1]
				lProc	:= .T.
				Exit
			EndIf
		Next nLoop

		If !lProc
			Aviso(	Titulo,"Nenhum título foi marcado. Não há dados a serem impressos.",{"&Fechar"},,"Sem Dados" )

		// Chama a rotina que irá montar e imprimir o relatório
		Else
			Processa( { |lEnd| MontaRel() }, "Montando Imagem do Relatório.", Titulo )
		Endif
	EndIf
Return

//+----------------------------------------------------------------------------------------
//	Marca e Desmarca todos os itens da MarkBrowse.
//+----------------------------------------------------------------------------------------
Static Function Marca(lMarca,oLst)
	Local i := 0

	For i := 1 To Len(aLst)
		  aLst[i][1] := lMarca
	Next i

	oLst:Refresh()
Return

//+----------------------------------------------------------------------------------------
//	Monta relatório
//+----------------------------------------------------------------------------------------
Static Function MontaRel()
	Local oPrint
	Local aDadEmp	:= {}
	Local aDadBco	:= {}
	Local aDadTit	:= {}
	Local aDadCli	:= {}
	Local aBarra	:= {}
	Local nLoop	:= 0
	Local nTpImp	:= 0

	// Define o tipo de configuração a ser utilizado na MSBAR
	// 1 = Polegadas, 2 = Centímetros
//	nTpImp	:= Aviso(	Titulo,;
//	   		  			"Os boletos devem ser impressos com qual definição ?",;
//						{ "Polegadas", "Centímetros" },,;
//						"Definição de Tamanho" )
    nTpImp := 2
	// Seta as configuração do objeto print
	oPrint:= TMSPrinter():New( Titulo )
	oPrint:Setup()
	oPrint:SetPortrait()
	oPrint:SetSize(215,297)

	// Posiciona no Banco
	dbSelectArea("SA6")
	dbSetOrder(1)
	If !MsSeek(xFilial("SA6")+mv_par11+mv_par12+mv_par13)
		Aviso(	Titulo,;
				"Banco/Agência/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +Chr(13)+Chr(10)+;
				"O registro não foi localizado no arquivo. Será desconsiderado.",;
				{"&Fechar"},2,;
				"Registro Inválido" )
		Return(Nil)
	EndIf

	// Posiciona no Parâmetro do Banco
	dbSelectArea("SEE")
	dbSetOrder(1)
	If !MsSeek(xFilial("SEE")+mv_par11+mv_par12+mv_par13+mv_par14)
		Aviso(	Titulo,;
				"Banco/Agência/Conta/Carteira: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ AllTrim(mv_par14) + Chr(13) + Chr(10) +;
				"Os parâmetros do banco não foram localizados. Será desconsiderado.",;
				{"&Continua"},2,;
				"Registro Inválido" )
		Return(Nil)
	EndIf

	// Chama rotina que pega os dados do banco e empresa
	If !U_TCDadBco(aDadEmp, aDadBco)
		Aviso(	Titulo,;
				"Banco/Agência/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ Chr(13) + Chr(10) +;
				"Banco do cliente: "+ SA1->A1_BCO1 + Chr(13) + Chr(10) + ;
				"Não foi possível obter os dados do banco.",;
				{"&Continua"},2,;
				"Registro Inválido" )
		Return(Nil)
	EndIf

	ProcRegua(Len(aLst))

	For nLoop := 1 To Len(aLst)
		IncProc( "Título: " + aLst[nLoop,02] +"/"+ aLst[nLoop,03] )

		// Só processa se estiver marcado
		If aLst[nLoop,01]

			// Posiciona no título
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbGoTo(aLst[nLoop,16])
			If Eof() .Or. Bof()
				Aviso(	Titulo,"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+"O título não foi localizado no arquivo. Será desconsiderado.",{"&Continua"},2,"Registro Inválido" )
				Loop
			EndIf

			// Posiciona no Cliente
			dbSelectArea("SA1")
			dbSetOrder(1)
			If !MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				Aviso(	Titulo,"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+"Cliente/Loja: "+ SE1->E1_CLIENTE +"/"+ SE1->E1_LOJA +Chr(13)+Chr(10)+"O cliente não foi localizado no arquivo. Será desconsiderado.",{"&Continua"},2,"Registro Inválido" )
				Loop
			EndIf

			// Verifica se o considera o banco definido no cadastro do cliente e
			// se o banco do parâmetro é o mesmo do cadastro
			If mv_par16 == 1 .And. !Empty(SA1->A1_BCO1) .And. SA1->A1_BCO1 <> mv_par11
				Aviso(	Titulo,"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+"Banco/Agência/Conta: "+ mv_par11 +"/"+ mv_par12 +"/"+ mv_par13 +Chr(13)+Chr(10)+"Banco do cliente: "+ SA1->A1_BCO1 +Chr(13)+Chr(10)+"O Banco do cadastro é diferente do parâ,etro. Será desconsiderado.",{"&Continua"},2,"Registro Inválido" )
				Loop
			EndIf

			// Posiciona no Título
			dbSelectArea("SE1")

			// Chama rotina que pega os dados do título e cliente
			If !U_TCDadTit(aDadTit, aDadCli, aBarra, aDadBco)
				Aviso(	Titulo,"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+"Não foi possível obter os dados do título. será desconsiderado.",{"&Continua"},2,"Registro Inválido" )
				Loop
			EndIf

			// Chama a função de impressão do boleto
			U_TCImpBol(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

			// Atualiza o título com o nosso número
			DbSelectArea("SE1")
			RecLock("SE1",.F.)

				SE1->E1_NUMBCO		:= aBarra[3]

				If FieldPos("E1_BCOBOL") > 0
					SE1->E1_BCOBOL	:= aDadBco[1]
				EndIf
			SE1->(MsUnlock())
		EndIf

	Next nLoop

	oPrint:Preview()

	MS_FLUSH()
Return(Nil)

//+----------------------------------------------------------------------------------------
// Cria Perguntas no SX1
//+----------------------------------------------------------------------------------------
Static Function CRIASX1(aRegs,cPerg)
Local i:=1
Local j:=1
	dbSelectArea("SX1")
	dbSetOrder(1)

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
Return
