#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE CRLF CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06A11   ³ Autor ³ Montes - MooveGestão  ³ Data ³ 01/04/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio do Pedido, Boleto e/ou Danfe por E-mail              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MACOM                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M06A11(cNumBor)

	Local aPergs := {}
    Local cMarca := GetMark()
	Local cCaixaCompras := "COMPRAS"
	Local cCaixaFin     := "FINANCEIRO" 

	PRIVATE lExec      := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	Private aArea      := GetArea()
	Private aAreaSM0   := SM0->(GetArea())
	Private lAuto      := .F.
	Private lEnd       := .F.
	Private nTemplate  := 0

	Default cNumBor    := SPACE(6)

	PutMV("MV_WFMLBOX",cCaixaFin) // Altero a caixa
	//MsgStop("Trocada MV_WFMLBOX para FINANCEIRO")

	If IsInCallStack("MATA410") //Chamado do Pedido de Venda

		lAuto := .T.

	EndIf

	cPerg    := PADR("M06A11",LEN(SX1->X1_GRUPO))

	dbSelectArea("SE1")
	aPergs := {}
	Aadd(aPergs,{"De Prefixo ?"    ,"","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo ?"   ,"","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero ?"     ,"","","mv_ch3","C",TamSx3("E1_NUM")[1],0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero ?"    ,"","","mv_ch4","C",TamSx3("E1_NUM")[1],0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela ?"    ,"","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela ?"   ,"","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador ?"   ,"","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","BCO","","","",""})
	Aadd(aPergs,{"Ate Portador ?"  ,"","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","BCO","","","",""})
	Aadd(aPergs,{"De Cliente ?"    ,"","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA1FIL","","","",""})
	Aadd(aPergs,{"Ate Cliente ?"   ,"","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1FIL","","","",""})
	Aadd(aPergs,{"De Loja ?"       ,"","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja ?"      ,"","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao ?"    ,"","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao ?"   ,"","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/24","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento ?" ,"","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento ?","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/24","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero ?"    ,"","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","",""      ,"","","","","","","","","","","","","","","","","","","","","BORNOB","","","",""})
	Aadd(aPergs,{"Ate Bordero ?"   ,"","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","BORNOB","","","",""})
	Aadd(aPergs,{"Envia NF ?"      ,"","","mv_chj","N",1,0,1,"C","","MV_PAR19","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Envia Pedido ?"  ,"","","mv_chk","N",1,0,1,"C","","MV_PAR20","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Envia Boleto ?"  ,"","","mv_chl","N",1,0,1,"C","","MV_PAR21","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","",""})
	aTamSX3	:= TAMSX3("EE_CODIGO")
	Aadd(aPergs,{"Banco Boleto ?"   ,"","","mv_chm",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR22","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","SA6",	"","007",	"",""})
	aTamSX3	:= TAMSX3("EE_AGENCIA")
	Aadd(aPergs,{"Agencia Boleto ?" ,"","","mv_chn",aTamSX3[3],aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR23","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","008",	"",""})
	aTamSX3	:= TAMSX3("EE_CONTA")
	Aadd(aPergs,{"Conta Boleto ?"   ,"","","mv_cho",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR24","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","009",	"",""})
	Aadd(aPergs,{"Pedido de ?"      ,"","","mv_chp","C",6,0,0,"G","","MV_PAR25","","","",""      ,"","","","","","","","","","","","","","","","","","","","","SC5","","","",""})
	Aadd(aPergs,{"Pedido ate ?"     ,"","","mv_chq","C",6,0,0,"G","","MV_PAR26","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SC5","","","",""})
	Aadd(aPergs,{"Modelo de Email ?","","","mv_chr","N",1,0,1,"C","","MV_PAR27","Em aberto","Em aberto","Em aberto","","Em atraso","Em Atraso","Em Atraso","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Email para ?"     ,"","","mv_chs","N",1,0,1,"C","","MV_PAR28","Cliente/Equip.Cobrança","Cliente/Equip.Cobrança","Cliente/Equip.Cobrança","","Equipe Cobrança","Equipe Cobrança","Equipe Cobrança","","Usuário Logado","Usuário Logado","Usuário Logado","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Comfirma Envio ?" ,"","","mv_cht","N",1,0,1,"C","","MV_PAR29","Sim","","","","Não","","","","","","","","","","","","","","","","","","","","","","","",""})

	AjustaPerg(cPerg,aPergs)

	If !lAuto
		If !Pergunte (cPerg,.T.)
			Set Filter to
			Return
		EndIf
	
		If MV_PAR27 = 2
			nTemplate := 3
		Else
			nTemplate := 2
		EndIf

	Else
		Pergunte (cPerg,.F.) //Carrega parametros default

		MV_PAR01 := '   '
		MV_PAR02 := 'ZZZ'
		MV_PAR03 := '         '
		MV_PAR04 := 'ZZZZZZZZZ'
		MV_PAR05 := ' '
		MV_PAR06 := 'Z'
		MV_PAR07 := '   '
		MV_PAR08 := 'ZZZ'
		MV_PAR09 := '      '
		MV_PAR10 := 'ZZZZZZ'
		MV_PAR11 := '  '
		MV_PAR12 := 'ZZ'
		MV_PAR13 := CTOD('01/01/01')
		MV_PAR14 := CTOD('31/12/49')
		MV_PAR15 := CTOD('01/01/01')
		MV_PAR16 := CTOD('31/12/49')

		If !EMPTY(cNumBor)
			MV_PAR17 := cNumBor
			MV_PAR18 := cNumBor
		Else
			MV_PAR17 := '      '
			MV_PAR18 := 'ZZZZZZ'
		EndIf

		If IsInCallStack("MATA410") //Chamado do Pedido de Venda
			MV_PAR19 := 2
			MV_PAR20 := 1
			MV_PAR21 := 1
			MV_PAR25 := SC5->C5_NUM
			MV_PAR26 := SC5->C5_NUM
			nTemplate := 1
		Else
			MV_PAR19 := 1
			MV_PAR20 := 1
			MV_PAR21 := 1
			MV_PAR25 := '      '
			MV_PAR26 := 'ZZZZZZ'
		EndIf
		MV_PAR30 := CTOD('01/01/01')
		MV_PAR31 := CTOD('31/12/49')
	EndIf

	If !lAuto 

		cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO > 0 .And."
		cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
		cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
		cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
		cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
		cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
		cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
		cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
		cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
		cFilter		+= 'DTOS(E1_XRENEG)>="'+DTOS(mv_par30)+'".and.DTOS(E1_XRENEG)<="'+DTOS(mv_par31)+'".And.'
		cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
		cFilter		+= "!(E1_TIPO$MVABATIM).And."
		cFilter		+= "E1_PEDIDO>='" + MV_PAR25 + "'.And.E1_PEDIDO<='" + MV_PAR26 + "'.And."
		cFilter		+= "E1_TIPO$'NF |BOL'"   //.And."

//		cFilter		+= "E1_NUMBOR<>'      '.And."   // Teste
//		cFilter		+= "!EMPTY(E1_NUMBCO)"          // Teste

		dbSelectArea("SE1")
		dbGoTop()
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"

			oPanel := TPanel():New(001,001,'',oDlg,, .T., .T.,, ,350,170)

			oMrkBrowse:= FWMarkBrowse():New()
			oMrkBrowse:oBrowse:SetEditCell(.T.)
			oMrkBrowse:SetFieldMark("E1_OK")
			oMrkBrowse:SetOwner(oPanel)
			oMrkBrowse:SetAlias("SE1")
			oMrkBrowse:SetFilterDefault(cFilter)
			oMrkBrowse:SetMenuDef("")
			oMrkBrowse:bMark	:= {|| .T. /*Fa070bAval(cAliasLote,cMarca,oValor,oQtda)*/}
			oMrkBrowse:bAllMark	:= {|| .T. /*FA070Inverte(cMarca,oValor,oQtda,,cAliasLote)*/}
			oMrkBrowse:SetMark( cMarca, "SE1", "E1_OK" )
			oMrkBrowse:SetDescription("")
			oMrkBrowse:DisableReport()
			oMrkBrowse:DisableLocate()
			oMrkBrowse:DisableConfig()
			//oMrkBrowse:SetColumns(aColumns)
			//oMrkBrowse:SetSeek(.T.,aSeek)
			oMrkBrowse:Activate()

			@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
			@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED

		dbSelectArea("SE1")
		dbGoTop()

		If lExec
			Processa({|lEnd|ProcEnv(nTemplate,lAuto)})
		EndIf

	Else
		ProcEnv(nTemplate,lAuto)
	EndIf

MsgStop("Voltando Parametro de envio de e-mail para COMPRAS")
// Ajustar isso depois
//For nProc := 1 To 5000	
//	cTeste := "  "
//Next
PutMV("MV_WFMLBOX",cCaixaCompras)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ProcEnv  ³ Autor ³ Montes                ³ Data ³ 01/04/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do envio dos Boletos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MACOM                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcEnv(nTemplate,lAuto)

	Local aArea         := GetArea()
	Local cAliasQry     := GetNextAlias()
	Local cMarca        := IIF(nTemplate<>1,oMrkBrowse:Mark(),"")
	Local nTotal		:= 0
	Local nAtual		:= 0
	Local lImprime		:= .F.
	Local cBarra        := if(isSrvUnix(),"/","\")
	Local cFolderFiles  := cBarra + "temp" + cBarra
	Local cFileCondF    := cBarra + "workflow" + cBarra + "condicoes_de_fornecimento.pdf"
	Local cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos.htm"
	Local cAssinatura   := cBarra + "workflow" + cBarra + "assinaturaemail.jpg"
	Local cTitulo       := ""
	Local n, nB, nX
	Local cEmailCC      := GETMV("AM_M06A11")  //,.F.,"tcerqueira@hoshizakimacom.com.br;ghenrique@hoshizakimacom.com.br")
	Local nEnvNf        := MV_PAR19
	Local nEnvPed       := MV_PAR20
	Local nEnvBol       := MV_PAR21
	Local cParBco       := MV_PAR22
	Local cParAge       := MV_PAR23
	Local cParCta       := MV_PAR24
	Local nEmailPara    := MV_PAR28
	Private lImprVlr    := .T. //Imprime valores no pedido de venda (R05R03.PRW)

	DEFAULT nTemplate := 0
	/*
			//Seleção de Template
			nTemplate := 0
			If !EMPTY(cFilePedido) .And. EMPTY(cFileDANFE) .And. LEN(aFileBoleto) > 0
				nTemplate := 1
			ElseIf !EMPTY(cFilePedido) .And. !EMPTY(cFileDANFE) .And. LEN(aFileBoleto) > 0
				nTemplate := 2
			ElseIf nDiasAtraso > 0
				nTemplate := 3
			EndIf
	*/

	dbSelectArea("SC5")
	dbSetOrder(1)

	dbSelectArea("SE4")
	dbSetOrder(1)

    dbSelectArea("SE1")
    dbSetOrder(1)

	If !lAuto
		cWhere := "%AND E1_OK = '"+cMarca+"'%"
	Else
		cWhere := "%%"
	EndIf

    BeginSql Alias cAliasQry
        
        SELECT E1_CLIENTE,E1_LOJA, E1_TIPO, SE1.R_E_C_N_O_ RECSE1
        FROM %table:SE1% SE1
        WHERE   E1_FILIAL = %xfilial:SE1% AND
//				E1_SALDO > 0 AND
	            E1_PREFIXO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
				E1_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND 
				E1_PARCELA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% AND
				E1_PORTADO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% AND
				E1_CLIENTE BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10% AND
				E1_LOJA BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12% AND
				E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR13)% AND %Exp:DTOS(MV_PAR14)% AND
				E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR15)% AND %Exp:DTOS(MV_PAR16)%  AND
				E1_XRENEG  BETWEEN %Exp:DTOS(MV_PAR30)% AND %Exp:DTOS(MV_PAR31)%  AND
				E1_NUMBOR BETWEEN %Exp:MV_PAR17% AND %Exp:MV_PAR18% AND
				E1_PEDIDO BETWEEN %Exp:MV_PAR25% AND %Exp:MV_PAR26% AND
				E1_TIPO IN ('NF ','BOL') AND 
                SE1.%notDel%
				%Exp:cWhere%
		ORDER BY E1_CLIENTE,E1_LOJA, E1_TIPO
   
    EndSql

/*/				
				E1_NUMBOR <> '      ' AND   // Teste
				E1_NUMBCO <> '  ' AND       // Teste
/*/

    dbSelectArea(cAliasQry)
	(cAliasQry)->(dbGoTop())

	nAtual := 0
	Count To nTotal
	ProcRegua(nTotal)

	aEnvios := {}

	cEmailEnv := ""   // Inicializa emails

    (cAliasQry)->(DbGoTop())
    While (cAliasQry)->(!Eof())

		cCliente    := (cAliasQry)->E1_CLIENTE
		cLoja       := (cAliasQry)->E1_LOJA
		aDuplicatas := {}
		ltemPVA     := .F.
		cEmailEnv := ""   // Inicializa emails - Marcos 27/09/24

		//Posiciona o SA1 (Cliente)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+cCliente+cLoja)

    	dbSelectArea(cAliasQry)
	    While (cAliasQry)->(!Eof() .And. E1_CLIENTE == cCliente  .And. E1_LOJA == cLoja)

    	    SE1->(dbGoTo((cAliasQry)->RECSE1))

			If SE1->E1_PREFIXO = 'PVA'  // Tipo BOL
				ltemPVA  := .T.
			EndIf

			//Não Envia Boleto da Nota se Já enviou ou tem PVA
			If 	ltemPVA .And. AllTrim(SE1->E1_TIPO)  = 'NF'
				(cAliasQry)->(DbSkip())
				Loop
			EndIf

			//Incrementando a régua
    	    nAtual++
        	IncProc("Imprimindo titulo " + Alltrim(SE1->E1_NUM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
 
			AADD(aDuplicatas,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_VEND1,SE1->E1_VEND2,SE1->E1_VEND3,SE1->E1_VEND4,SE1->E1_VEND5,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_SALDO,SE1->E1_PEDIDO,(cAliasQry)->RECSE1})

			SC5->(dbSeek(xFilial("SC5",SE1->E1_FILIAL)+SE1->E1_PEDIDO))

			cEmailEnv := EmailCli(cEmailEnv)
			cEmailEnv := EmailVen(cEmailEnv)

		    (cAliasQry)->(DbSkip())
		EndDo
		
		AADD(aEnvios,{cCliente,cLoja,ACLONE(aDuplicatas),cEmailEnv})
    EndDo
    (cAliasQry)->(DbCloseArea())

	If nTemplate = 1 .And. LEN(aEnvios) = 0 //Envio de Conf.Pedido

		cEmailEnv := EmailCli(cEmailEnv)
		cEmailEnv := EmailVen(cEmailEnv)

		AADD(aEnvios,{"","",{},cEmailEnv})

	EndIf

	For nX := 1 To Len(aEnvios)

		cEmailEnv := aEnvios[nX][4]
		lEnvia    := .F.  //Envia somente se tiver arquivo gerado
		cCondicao := ""
		cTitulos  := ""
		nTitulos  := 0
		
		//cEmailEnv := cEmailCC
		aAnexos := {}
		AADD(aAnexos,cAssinatura)
		For nB := 1 To Len(aEnvios[nX][3])

			SE1->(dbGoTo(aEnvios[nX][3][nB][13]))

			//Posiciona o SA1 (Cliente)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

			cFilePedido := ""
			cFileDanfe  := ""
			cFileXML    := ""
			aFileBoleto := {}

			nEnvNf := 1 //Envia NF
			If nEnvNf = 1 //Envia NF

				cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
				dbSelectArea("SF2")
				dbSetOrder(1)
				dbSeek(SE1->E1_FILIAL+SE1->E1_NUM+cSerie)

				dbSelectArea("SE1")
				If RTRIM(SF2->F2_ESPECIE) == "SPED"
					cFileDanfe := GetDanfe(SF2->F2_FILIAL,SF2->F2_SERIE,SF2->F2_DOC)
					cFileXML   := GetXML(SF2->F2_FILIAL,SF2->F2_SERIE,SF2->F2_DOC)
				EndIf
			EndIf

//			If nEnvBol == 1 //Envia Boleto
			If nEnvBol == 1 .And. SE1->E1_SALDO > 0  // Tras titulos sem saldo na query para demonstrar no email.
				aFileBoleto := GetBoleto(SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,cParBco,cParAge,cParCta)
			EndIf

			If nEnvPed == 1 //Envia Pedido
				SC5->(dbSeek(xFilial("SC5",SE1->E1_FILIAL)+SE1->E1_PEDIDO))
				cFilePedido := U_M05R03A(.T./*lAuto*/)
			EndIf

			cChaveSE1   := SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO
			cPrefixo    := SE1->E1_PREFIXO
			dEmissao    := SE1->E1_EMISSAO
			dVencto     := SE1->E1_VENCTO
			lImprime    := .F.
			cFileOri    := ""
			cFilePDF    := ""
			nDiasAtraso := (dDataBase-SE1->E1_VENCTO)

			//Pega numero do RPS
			If Alltrim(SE1->E1_NFELETR) == "0" .Or. EMPTY(SE1->E1_NFELETR)
				cNumTit := SE1->E1_NUM
			Else
				cNumTit := SE1->E1_NFELETR
			EndIf

			If !EMPTY(cFilePedido) .And. ASCAN(aAnexos,{|x|x=cFolderFiles+cFilePedido}) = 0
				AADD(aAnexos,cFolderFiles+cFilePedido)

				AADD(aAnexos,cFileCondF)   // Envia 
				lEnvia := .T.

			EndIf
			If !EMPTY(cFileXML) .And. ASCAN(aAnexos,{|x|x=cFolderFiles+cFileXML}) = 0
				AADD(aAnexos,cFolderFiles+cFileXML)
				lEnvia := .T.
			EndIf
			If !EMPTY(cFileDanfe) .And. ASCAN(aAnexos,{|x|x=cFolderFiles+cFileDanfe}) = 0  
				AADD(aAnexos,cFolderFiles+cFileDanfe)
				lEnvia := .T.
			EndIf
			For n := 1 To Len(aFileBoleto)
				cTitulo := IIF(EMPTY(SE1->E1_NFELETR),Alltrim(SE1->E1_NUM),AllTrim(SE1->E1_NFELETR))
				If cTitulo+IIF(EMPTY(SE1->E1_PARCELA),"","_"+ALLTRIM(SE1->E1_PARCELA)) $ aFileBoleto[n]
					If ASCAN(aAnexos,{|x|x=cFolderFiles+aFileBoleto[n]}) = 0
						AADD(aAnexos,cFolderFiles+aFileBoleto[n])
						lEnvia := .T.
					EndIf
				EndIf
			Next
		
			cTitulos  += '    <tr>'
			cTitulos  += '      <td style="width: 77px;">'+SE1->E1_NUM+'</td>'
			cTitulos  += '      <td style="width: 58px;">'+SE1->E1_PARCELA+'</td>'
			If SE1->E1_SALDO == 0
				cTitulos  += '      <td style="width: 122px;">'+"  /  /  "+'</td>'
				If nTemplate = 1
					cTitulos  += '      <td style="width: 122px;">'+DTOC(SE1->E1_BAIXA)+'</td>'
				EndIf
				cTitulos  += '      <td style="width: 122px; text-align: right;">'+TRANSFORM(SE1->E1_VALOR,"@e 999,999,999.99")+'</td>'
			Else
				cTitulos  += '      <td style="width: 122px;">'+DTOC(SE1->E1_VENCREA)+'</td>'
				If nTemplate = 1
					cTitulos  += '      <td style="width: 122px;">'+"  /  /  "+'</td>'
				EndIf
				cTitulos  += '      <td style="width: 122px; text-align: right;">'+TRANSFORM(SE1->E1_VALOR,"@e 999,999,999.99")+'</td>'
			EndIf
			cTitulos  += '      <td style="width: 455px;">'+TRANSFORM(SE1->E1_CODDIG,"@R XXXXX.XXXXX XXXXX.XXXXXX XXXXX.XXXXXX X XXXXXXXXXXXXXX")+'</td>'
			cTitulos  += '    </tr>'

			nTitulos  += 1

		Next

		If nTitulos > 0
        
			cCondicao := '<table style="text-align: left; width: 758px; height: 60px;"'
			cCondicao += ' border="1" cellpadding="2" cellspacing="2">'
			cCondicao += '  <tbody>'
			cCondicao += '    <tr>'
			cCondicao += '      <td'
			cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 77px;">NOTA</td>'
			cCondicao += '      <td'
			cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 58px;">PARCELA</td>'
			cCondicao += '      <td'
			cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 122px;">VENCIMENTO</td>'
			cCondicao += '      <td'
			If nTemplate = 1
				cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 122px;">DATA.PAGTO</td>'
				cCondicao += '      <td'
			EndIf
			cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 122px; text-align: right;">VALOR</td>'
			cCondicao += '      <td'
			cCondicao += ' style="font-weight: bold; font-style: italic; text-decoration: underline; width: 455px;">LINHA DIGITAVEL</td>'
			cCondicao += '    </tr>'
			cCondicao += cTitulos
			cCondicao += '  </tbody>'
			cCondicao += '</table>'

		Else
			SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
			cCondicao := AllTrim(SE4->E4_DESCRI)

		EndIf

		If nTemplate = 1
			//If MV_PAR20 = 1 //Envia Pedido
			cFilePedido := U_M05R03A(.T./*lAuto*/)

			If !EMPTY(cFilePedido) .And. ASCAN(aAnexos,{|x|x=cFolderFiles+cFilePedido}) = 0
				AADD(aAnexos,cFolderFiles+cFilePedido)

//				MsgStop("2 : "+cFileCondF)
				AADD(aAnexos,cFileCondF)   // Envia 

				lEnvia := .T.
			EndIf
			//EndIf

		EndIf

		If !Empty(cEmailEnv) 

			If lEnvia .And. nTemplate > 0

				If nTemplate = 1
					cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos_template1.htm"
					cSubject        := "Informe - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+"."
				ElseIf nTemplate = 2
					cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos_template2.htm"
					If nDiasAtraso > 0
						cSubject        := "Cobrança - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+"."
					Else
						cSubject        := "Lembrete Vencto - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+"."					
					EndIf
				ElseIf nTemplate = 3
					cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos_template3.htm"
					If nDiasAtraso > 0
						cSubject        := "Cobrança - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+"."
					Else
						cSubject        := "Lembrete Vencto - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+"."					
					EndIf
				Else
					cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos.htm"
					cSubject        := "Faturamento - Pedido : "+SC5->C5_NUM+" - "+AllTrim(SA1->A1_NOME)+" - NF "+ALLTRIM(cNumTit)+;
									IF(!EMPTY(SE1->E1_PARCELA)," Parcela "+RTRIM(SE1->E1_PARCELA),"")+" - "+AllTrim(SA1->A1_NOME)+" com vencimento em "+DTOC(SE1->E1_VENCTO)+"."
				EndIf

				cFromName := "Financeiro - "+AllTrim(SM0->M0_NOMECOM)
				cFromAddr := "workflow@hoshizakimacom.com.br"

				oProcess:= TWFProcess():New("000001", "Workflow - Envio de Documentos "+DtoC(Date()))
				oProcess:NewTask("Workflow Envio de Documentos",cHtml)
				oProcess:cSubject 	:= cSubject
				If nEmailPara = 1
					oProcess:cTo      	:= cEmailEnv
					If cEmailCC <> cEmailEnv
						oProcess:cCC      	:= cEmailCC
					EndIf
				ElseIf nEmailPara = 2
					oProcess:cTo      	:= cEmailCC
				Else
					oProcess:cTo      	:= UsrRetMail(RetCodUsr())
				EndIf
				//oProcess:cBCC      	:= ""

				oProcess:NewVersion(.T.)
				oProcess:cFromName  := cFromName
				//oProcess:cFromAddr	:= cFromAddr
				oProcess:bReturn  	:= ""

				If Len(aAnexos) > 0
					// Anexar arquivo
					For n := 1 To Len(aAnexos)
						oProcess:AttachFile(aAnexos[n])
					Next
				EndIf

				oHtml := oProcess:oHTML

				If nEmailPara == 2 .Or. nEmailPara == 3
					oHtml:ValByName( "CLIENTE"  , AllTrim(SA1->A1_NOME)+" email(s) "+cEmailEnv)
				Else
					oHtml:ValByName( "CLIENTE"  , SA1->A1_NOME)
				Endif
				oHtml:ValByName( "CCONDICAO"  , cCondicao )

//				If nTemplate = 1 
//					oHtml:ValByName( "CCONDICAO"  , cCondicao )
//				Else
//					oHtml:ValByName( "EMPRESA"    , SM0->M0_NOMECOM  )
//					oHtml:ValByName( "CNUMTIT"    , "" /*ALLTRIM(cNumTit)*/ )
//					oHtml:ValByName( "CEMISSAO"   , "" /*DTOC(dEmissao)*/   )
//					oHtml:ValByName( "CVENCTO"    , "" /*DTOC(dVencto)*/    )
//				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Mensagem com as contas e pedido de confirmação                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par29 == 2 .Or. MsgYesNo('Confirma Envio do Email ?' + CRLF + CRLF;
							+ 'Cliente...: ' + AllTrim(SA1->A1_NOME) + CRLF ;
							+ 'Titulo....: ' + SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"/"+SE1->E1_PARCELA+"/"+SE1->E1_TIPO + CRLF ;
							+ 'Pedido....: ' + SE1->E1_PEDIDO + CRLF ;
							+ 'Emails....: ' + Left(oProcess:cTo,40) + CRLF ;
							+ SubStr(oProcess:cTo,41,40) + CRLF ;
							+ SubStr(oProcess:cTo,81,40) + CRLF ;
							+ SubStr(oProcess:cTo,121,40) + CRLF ;
							+ SubStr(oProcess:cTo,161,40) + CRLF)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Função envio de e-mail                                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oProcess:Start()
					oProcess:Finish()
				EndIf
			EndIf

		EndIf

	Next

RestArea(aArea)
		
//Força saída da caixa de e-mail
wfsendmail()

Return nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaPerg(cPerg, aPergs)

	Local aCposSX1	:= {}
	Local nX 		:= 0
	Local lAltera	:= .F.
	Local cKey		:= ""
	Local nJ			:= 0

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
		"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
		"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
		"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
		"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
		"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
		"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
		"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

	cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		lFound  := .F.
		If (lFound := dbSeek(cPerg+Right(aPergs[nX][11], 2)))
			If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
					Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			Endif
		Endif

		If ! lAltera .And. lFound .And. X1_TIPO <> aPergs[nX][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif

		If !lFound .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
						FieldPos(AllTrim(aCposSX1[nJ])) > 0
					Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
				Endif
			Next nj
			MsUnlock()
			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

			If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			Else
				aHelpSpa := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			Else
				aHelpEng := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			Else
				aHelpPor := {}
			Endif

			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		Endif
	Next
Return Nil

/*/{Protheus.doc} GetDANFE
    Função responsável por gerar a danfe em PDF
    @type  Function
    @author Montes
    @since 01/05/2024
    @version 12.1.2310
    @param cFilial
    @param cNota
    @return cFileDanfe
/*/
Static Function GetDANFE(cFilDoc,cSerie,cDoc)

Local aArea         := GetArea()
Local cFileDanfe    := ""
local oDanfe        := nil
local oSetup        := nil    
local cBarra        := if(isSrvUnix(),"/","\")
local cFolderFiles  := cBarra + "temp" + cBarra 
local lFile         := .F.
local lIsLoja       := .F. 
local cProg		    := iif(existBlock("DANFEProc"),"U_DANFEProc",iif(isRdmPad("DANFEProc"),"DANFEProc", ""))
Local lDanfe        := !empty(cProg)
local nTimes        := 0
local aPerg         := {}
local lExistNfe     := .F.

Local cSavFil       := cFilAnt
Local aAreaSM0      := SM0->(GetArea())

cFilAnt := cFilDoc
SM0->(dbSeek(cEmpAnt+cFilAnt))

cFileDanfe := "danfe_"+RTRIM(SM0->M0_CGC)+"_"+RTRIM(cDoc)+".pdf"

If !(lFile := FILE(cFolderFiles+cFileDanfe)) .And. !EMPTY(cDoc)

    cIdEnt := GetIdEnt()

    oDANFE := FWMSPrinter():New(cFileDanfe, IMP_PDF, .F. /*lAdjustToLegacy*/,cFolderFiles/*cPathInServer*/,.T.,/*lTReport*/,/*oPrintSetup*/,/*cPrinter*/,/*lServer*/,/*lPDFAsPNG*/,/*lRaw*/,.F.,/*nQtdCopy*/)
    oDanfe:SetResolution(78)
    oDanfe:SetPortrait()
    oDanfe:SetPaperSize(DMPAPER_A4)
    oDanfe:SetMargin(60,60,60,60)
    oDanfe:lServer := .T.
    oDanfe:nDevice := IMP_PDF
    oDanfe:cPathPDF := cFolderFiles
    oDANFE:SetCopies( 1 )
                            
    //alimenta parametros da tela de configuracao da impressao da DANFE
    aPerg := {}
    Pergunte("NFSIGW", .F.,,,,, @aPerg)
    MV_PAR01 := cDoc
    MV_PAR02 := cDoc
    MV_PAR03 := cSerie
    MV_PAR04 := 0 //[Operacao] NF de Entrada / Saida
    MV_PAR05 := 2 //[Frente e Verso] Nao
    MV_PAR06 := 2 //[DANFE simplificado] Nao
//    MV_PAR07 := Ctod("") // //[Data] Inicio
//    MV_PAR08 := Ctod("") // //[Data] Fim
    MV_PAR07 := dDataBase - 300
    MV_PAR08 := dDataBase + 300

    __SaveParam("NFSIGW", aPerg)

    oDanfe:lInJob := .T.
    If !lDanfe
        PRTMSG( "Fonte de impressao de DANFE nao compilado! Acesse o portal do cliente, baixe os fontes DANFEII.PRW, DANFEIII.PRW e compile em seu ambiente", LOG_ERROR )
        FERASE(cFolderFiles+cFileDanfe)    
        return ""
    Else
        &cProg.(@oDanfe, nil, cIdEnt, nil, nil, @lExistNfe, lIsLoja)
        if !oDanfe:Preview()
            PRTMSG( "Nao foi possivel gerar a DANFE para Empresa: "+ cEmpAnt + cFilDoc + " nota: " + alltrim(cDoc), LOG_PRINT )
            FERASE(cFolderFiles+cFileDanfe)    
            return ""
        EndIf
        if !lExistNfe
//            PRTMSG( "Nao foi gerado a DANFE para Empresa: "+ cEmpAnt + cFilDoc+ " nota: " + alltrim(cDoc), LOG_ERROR )
            MsgStop( "Nao foi gerado a DANFE para Empresa: "+ cEmpAnt + cFilDoc+ " nota: " + alltrim(cDoc))
            FERASE(cFolderFiles+cFileDanfe)
            Return ""
        endif
    EndIf

    While( !lFile .And. nTimes < 10)
        lFile := file(cFolderFiles+cFileDanfe)
        If(!lFile)
            nTimes++
            Sleep(500)
        Else
            Exit
        Endif    
    Enddo

    fwFreeObj(oSetup)
    fwFreeObj(oDanfe)
    oSetup := nil
    oDanfe := nil

EndIf

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

If !lFile
    cFileDanfe := ""
EndIf

RESTAREA(aArea)

Return cFileDanfe

/*/{Protheus.doc} GetXML
    Função responsável por retornar o XML da NF-e
    @type  Function
    @author Montes
    @since 01/05/2024
    @version 12.1.2310
    @param cFilial
    @param cNota
    @return cFileXML
/*/
Static Function GetXML(cFilDoc,cSerie,cDoc)

Local aArea         := GetArea()
Local cURL          := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cErro         := ""
Local cAviso        := ""
Local cXML          := ""
Local cFileXML      := ""
Local cSavFil       := cFilAnt
Local aAreaSM0      := SM0->(GetArea())
local cBarra        := if(isSrvUnix(),"/","\")
local cFolderFiles  := cBarra + "temp" + cBarra 
Local nX

cFilAnt := cFilDoc
SM0->(dbSeek(cEmpAnt+cFilAnt))

cFileXml := "nfe_"+RTRIM(SM0->M0_CGC)+"_"+RTRIM(cDoc)+".xml"

If !FILE(cFolderFiles+cFileXml)

    cIdEnt := GetIdEnt()

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt
	oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial        := cSerie+cDoc
	oWS:cIdFinal          := cSerie+cDoc
	oWS:dDataDe           := CTOD("  /   /   ")
	oWS:dDataAte          := dDataBase
	oWS:cCNPJDESTInicial  := "              "
	oWS:cCNPJDESTFinal    := "99999999999999"
	oWS:nDiasparaExclusao := 0
	lOk:= oWS:RETORNAFX()
	oRetorno := oWS:oWsRetornaFxResult
	lOk := iif( valtype(lOk) == "U", .F., lOk )

	If lOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exporta as notas                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)

		 	oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
			oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"_",@cErro,@cAviso)
			cXML	:= ""
			//If ValAtrib("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
			//	cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			//ElseIF ValAtrib("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
			//	cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
			//Else
	    	//	cCNPJDEST := ""
    	    //EndIf
    		cVerNfe := IIf(ValAtrib("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
	  		cVerCte := Iif(ValAtrib("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
	  		cVerMDfe:= Iif(ValAtrib("oXmlExp:_MDFE:_INFMDFE:_VERSAO:TEXT") <> "U", oXmlExp:_MDFE:_INFMDFE:_VERSAO:TEXT, '')

		 	If !Empty(oXml:oWSNFe:cProtocolo)
			    cNotaIni := oXml:cID
				cIdflush := cNotaIni
			 	cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
				cModelo := cChvNFe
				cModelo := StrTran(cModelo,"NFe","")
				cModelo := StrTran(cModelo,"CTe","")
				cModelo := StrTran(cModelo,"MDFe","")
				cModelo := SubStr(cModelo,21,02)

				Do Case
					Case cModelo == "57"
						cPrefixo := "CTe"
					Case cModelo == "65"
						cPrefixo := "NFCe"
					Case cModelo == "58"
						cPrefixo := "MDFe"
					OtherWise
						if '<cStat>301</cStat>' $ oXml:oWSNFe:cxmlPROT .or. '<cStat>302</cStat>' $ oXml:oWSNFe:cxmlPROT
							cPrefixo := "den"
						else
							cPrefixo := "NFe"
						endif
				EndCase

		 		cChvNFe	:= iif( cModelo == "58", SubStr(cChvNFe,5,44), SubStr(cChvNFe,4,44) )

			 	nHandle := FCreate(cFolderFiles+cFileXML)
			 	If nHandle > 0
			 		cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
			 		If cModelo == "57"
						cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
						cRodap := '</cteProc>'
					Else
						Do Case
							Case cVerNfe <= "1.07"
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
							Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
								cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
							OtherWise
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
						EndCase
						cRodap := '</nfeProc>'
					EndIf
					FWrite(nHandle,AllTrim(cCab1))
				 	FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
				 	FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
					FWrite(nHandle,AllTrim(cRodap))
				 	FClose(nHandle)

                EndIf
            EndIf
        Next
    EndIf   
    If !FILE(cFolderFiles+cFileXml)
        cFileXML := ""
    EndIf
EndIf

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

RESTAREA(aArea)

Return cFileXml

/*/{Protheus.doc} GetBoleto
    Função responsável por retornar os arquivos PDF's do Boleto
    @type  Function
    @author Montes
    @since 01/05/2024
    @version 12.1.2310
    @param cFilial
    @param cNota
    @return aFilesBoleto
/*/
Static Function GetBoleto(cFilDoc,cPrefixo,cNumero,cParcela,cParBco,cParAge,cParCta)

Local aArea        := GetArea()
Local cSavFil      := cFilAnt
Local aAreaSM0     := SM0->(GetArea())
Local aAreaSE1     := SE1->(GetArea())
//Local cBarra       := if(isSrvUnix(),"/","\")
//Local cFolderFiles := cBarra + "temp" + cBarra
//Local nX           := 0
Local aFileBoletos := {}
Local cTitulo      := ""
Local cFileBol     := ""
Local cCarteira    := ""

cFilAnt := cFilDoc
SM0->(dbSeek(cEmpAnt+cFilAnt))

dbSelectArea("SE1")
dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA
If dbSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela)
//	MsgStop(" Não Achou Titulo "+xFilial("SE1")+cPrefixo+cNumero+cParcela)
//Else

    cTitulo  := IF(EMPTY(SE1->E1_NFELETR),Alltrim(SE1->E1_NUM),AllTrim(SE1->E1_NFELETR))
	cFileBOL := "boleto_"+RTRIM(SM0->M0_CGC)+"_"+RTRIM(cTitulo)+IIF(!EMPTY(SE1->E1_PARCELA),"_"+ALLTRIM(SE1->E1_PARCELA),"")+".pdf"

//	If !FILE(cFolderFiles+cFileBOL)
		If !EMPTY(SE1->E1_NUMBCO)  //.Or. IF(SE1->E1_PORTADO==cParBco))

//		If (EMPTY(SE1->E1_NUMBCO) //.Or. IF(SE1->E1_PORTADO==cParBco))
			//.And.!EMPTY(SE1->E1_NUMBOR)

			If !EMPTY(SE1->E1_NUMBCO) //Reimpressão
				cBanco    := IIF(!EMPTY(SE1->E1_PORTADO),SE1->E1_PORTADO,cParBco)
				cAgencia  := IIF(!EMPTY(SE1->E1_AGEDEP),SE1->E1_AGEDEP,cParAge)
				cConta    := IIF(!EMPTY(SE1->E1_CONTA),SE1->E1_CONTA,cParCta)
				cCarteira := "109" //SEE->EE_SUBCTA

			Else //Nova Impressão
				cBanco    := cParBco
				cAgencia  := cParAge
				cConta    := cParCta
				cCarteira := "109" //SEE->EE_SUBCTA
			EndIf
			cFileBOL := U_RFINR99(cPrefixo,cNumero,cParcela,SE1->E1_CLIENTE,SE1->E1_LOJA,cBanco,cAgencia,cConta,999/*nDias*/,/*cCarga*/,SE1->E1_EMISSAO,cCarteira)
		
		Else

			cFileBol := ""
		EndIf

//	EndIf

	If !Empty(cFileBOL)
		Aadd(aFileBoletos,cFileBOL)
	EndIf

EndIf

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

RestArea(aAreaSE1)
RestArea(aArea)

Return aFileBoletos

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³                       ³ Data ³01/10/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOMECOM   //SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)

/*/{Protheus.doc} ValAtrib
Função utilizada para substituir o type onde não seja possivél a sua retirada para não haver  
ocorrencia indevida pelo SonarQube.
/*/
//-----------------------------------------------------------------------
static Function ValAtrib(atributo)
Return (type(atributo) )


//-------------------------------------------------------------------
/*/{Protheus.doc} PRTMSG()

Executa um Print padronizado 
  

@param 	cMensagem    mensagem a ser printada no console  
@param 	nTypeMsg     Tipo do Conout 

@return nil

@author 	Renato Nagib 
@since		28/11/2016
@version	12.1.15

/*/
//-------------------------------------------------------------------
Static Function PRTMSG(cMensagem, nTypeMsg)

	Local cDelConout := Replicate("-", 78 )

	default nTypeMsg	:= 1
	
	if(nTypeMsg == LOG_ERROR)
		ConOut(CRLF + cDelConout + CRLF + "[ ERROR: " + UPPER(procName(1)) + "] " + (StrZero(ProcLine(1), 4)) + " [Thread: " + alltrim(str(ThreadId())) + "] " + "[" + dtoc(date()) +" "+ time() + "] " + CRLF + "[" + cMensagem + "] " + CRLF + cDelConout)
	elseif( nTypeMsg == LOG_PRINT)
		ConOut(CRLF + cDelConout + CRLF + "[ LOG: " + UPPER(procName(1)) + "] " + (StrZero(ProcLine(1), 4)) + " [Thread: " + alltrim(str(ThreadId())) + "] " + "[" + dtoc(date()) +" "+ time() + "] "  + CRLF +  "[" + cMensagem + "] " + CRLF + cDelConout)
	elseif(nTypeMsg == LOG_WARNING .and. __lWarning )
		ConOut(CRLF + cDelConout + CRLF + "[ WARNING: " + UPPER(procName(1)) + "] " + (StrZero(ProcLine(1), 4)) + " [Thread: " + alltrim(str(ThreadId())) + "] " + "[" + dtoc(date()) +" "+ time() + "] "  + CRLF +  "[" + cMensagem + "] " + CRLF + cDelConout)
	elseif(nTypeMsg == LOG_INFO .and. __lInfo )
		ConOut(CRLF + cDelConout + CRLF + "[ INFO: " + UPPER(procName(1)) + "] " + (StrZero(ProcLine(1), 4)) + " [Thread: " + alltrim(str(ThreadId())) + "] " + "[" + dtoc(date()) +" "+ time() + "] "  + CRLF +  "[" + cMensagem + "] " + CRLF + cDelConout)
	endif

return


//-------------------------------------------------------------------
/*/{Protheus.doc} EmailCli()

Email's de contato do cliente 
  
@return nil

@author 	Montes
@since		27/-6/2024
@version	12.1.2310

/*/
//-------------------------------------------------------------------
Static Function EmailCli(cEmailRet)

Local aArea         := GETAREA()
Local cAliasCont    := GetNextAlias()
Local cEntidade     := 'SA1'
Local cCodEnt       := PadR(SC5->(C5_CLIENTE + C5_LOJACLI),TamSX3('AC8_CODENT')[1])

BeginSql Alias cAliasCont
	SELECT U5_CODCONT,U5_CONTAT,U5_EMAIL,U5_FCOM1,U5_DDD,U5_CELULAR,UM_DESC
    FROM %Table:AC8% AC8
    LEFT JOIN %Table:SU5% SU5 ON SU5.%NotDel% AND U5_FILIAL = %xFilial:SU5% AND U5_CODCONT = AC8_CODCON
    INNER JOIN %Table:SUM% SUM ON SUM.%NotDel% AND UM_FILIAL = %xFilial:SUM% AND UM_CARGO = U5_FUNCAO
    WHERE AC8_ENTIDA = %Exp:cEntidade%
    AND AC8.%NotDel%
    AND AC8_FILIAL = %xFilial:AC8%
    AND AC8_CODENT = %Exp:cCodEnt%
EndSql

If Empty(SC5->C5_XCONT) .And. Empty(SC5->C5_XCONT2) .And. Empty(SC5->C5_XCONT3) .And. Empty(SC5->C5_XCONT4) .And. Empty(SC5->C5_XCONT5)  
    If (cAliasCont)->(!EOF())
        While (cAliasCont)->(!EOF())

			If !lower(AllTrim((cAliasCont)->U5_EMAIL)) $ cEmailRet 
				cEmailRet += IIF(!EMPTY(cEmailRet),";","")+lower(AllTrim((cAliasCont)->U5_EMAIL))
			EndIf

			(cAliasCont)->(DbSkip())
        EndDo
    EndIf
Else
	While (cAliasCont)->(!EOF())
		If 	(cAliasCont)->U5_CODCONT == SC5->C5_XCONT .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT2 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT3 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT4 .Or. (cAliasCont)->U5_CODCONT == SC5->C5_XCONT5  

			If !lower(AllTrim((cAliasCont)->U5_EMAIL)) $ cEmailRet
				cEmailRet += IIF(!EMPTY(cEmailRet),";","")+lower(AllTrim((cAliasCont)->U5_EMAIL))
			EndIf

        Endif
		(cAliasCont)->(DbSkip())
	EndDo
EndIf

RestArea(aArea)

Return cEmailRet

//-------------------------------------------------------------------
/*/{Protheus.doc} EmailVen()

Email's de contato dos Gerentes, Vendedores e  
  
@return nil

@author 	Montes
@since		27/-6/2024
@version	12.1.2310

/*/
//-------------------------------------------------------------------
Static Function EmailVen(cEmailRet)

Local aArea         := GetArea()
Local cAliasCont    := GetNextAlias()

BeginSql Alias cAliasCont

	SELECT DISTINCT A3_EMAIL,A3_NOME FROM (
	
	SELECT DISTINCT A3_EMAIL, A3_NOME 
	FROM %Table:SA3% SA3
	WHERE A3_FILIAL = %xFilial:SA3% 
	AND A3_COD IN  (%Exp:SC5->C5_VEND1%,%Exp:SC5->C5_VEND2%,%Exp:SC5->C5_VEND3%,%Exp:SC5->C5_VEND4%,%Exp:SC5->C5_VEND5%) 
	AND SA3.D_E_L_E_T_ = ' '

	UNION ALL
	
	SELECT A3_EMAIL, A3_NOME 
	FROM %Table:SA3% SA3
	WHERE A3_FILIAL = %xFilial:SA3% AND A3_COD IN (
	SELECT DISTINCT A3_GEREN FROM %Table:SA3% SA3GER
	WHERE SA3GER.A3_FILIAL = %xFilial:SA3% 
		AND SA3GER.A3_COD IN (%Exp:SC5->C5_VEND1%,%Exp:SC5->C5_VEND2%,%Exp:SC5->C5_VEND3%,%Exp:SC5->C5_VEND4%,%Exp:SC5->C5_VEND5%) AND SA3GER.D_E_L_E_T_ = ' '
	) AND SA3.D_E_L_E_T_ = ' '
	) AS TMP

EndSql

(cAliasCont)->(dbGotop())
While (cAliasCont)->(!Eof())

	If !Lower(AllTrim((cAliasCont)->A3_EMAIL)) $ cEmailRet
		cEmailRet += IIF(!EMPTY(cEmailRet),";","")+lower(AllTrim((cAliasCont)->A3_EMAIL))
	EndIf

	(cAliasCont)->(dbSkip())
EndDo

RestArea(aArea)

Return cEmailRet
