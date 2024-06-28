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

	Local	aPergs := {}
    Local   cMarca := GetMark()

	PRIVATE lExec      := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	Private aArea      := GetArea()
	Private aAreaSM0   := SM0->(GetArea())
	Private lAuto      := .F.
	Private lEnd       := .F.

	Default cNumBor    := SPACE(6)

	cPerg    := PADR("M06A11",LEN(SX1->X1_GRUPO))

	dbSelectArea("SE1")

	aPergs := {}
	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",TamSx3("E1_NUM")[1],0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",TamSx3("E1_NUM")[1],0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","BCO","","","",""})
	Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","BCO","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA1FIL","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1FIL","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/24","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/24","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","BORNOB","","","",""})
	Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","BORNOB","","",""})
	Aadd(aPergs,{"Envia NF?","","","mv_chj","N",1,0,1,"C","","MV_PAR19","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","",""})

	AjustaPerg(cPerg,aPergs)

	If Empty(cNumBor)
		If !Pergunte (cPerg,.T.)
			Set Filter to
			Return
		EndIf
	Else
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
		MV_PAR17 := cNumBor
		MV_PAR18 := cNumBor
		MV_PAR19 := 1
	EndIf

	cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
	cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
	cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
	cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
	cFilter		+= "!(E1_TIPO$MVABATIM)"
	cFilter		+= ".And.E1_TIPO=='NF '"
	cFilter		+= ".And.E1_NUMBOR<>'      '"
	cFilter		+= ".And.!EMPTY(E1_NUMBCO)"

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
		If lAuto
			ProcEnv()
		Else
			Processa({|lEnd|ProcEnv()})
		EndIf
	EndIf

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
Static Function ProcEnv()

	Local aArea         := GetArea()
	Local cAliasQry     := GetNextAlias()
	Local cMarca        := oMrkBrowse:Mark()
	Local nTotal		:= 0
	Local nAtual		:= 0
	Local lImprime		:= .F.
	Local cBarra        := if(isSrvUnix(),"/","\")
	Local cFolderFiles  := cBarra + "temp" + cBarra
	Local cHtml			:= cBarra + "workflow" + cBarra + "enviodedocumentos.htm"
	Local cAssinatura   := cBarra + "workflow" + cBarra + "assinaturaemail.jpg"
	Local cTitulo       := ""
	Local n

	Private lImprVlr    := .T. //Imprime valores no pedido de venda (R05R03.PRW)

    dbSelectArea("SE1")
    dbSetOrder(1)

    BeginSql Alias cAliasQry
        
        SELECT SE1.R_E_C_N_O_ RECSE1
        FROM %table:SE1% SE1
        WHERE   E1_FILIAL = %xfilial:SE1% AND
                E1_OK = %Exp:cMarca% AND
                %notDel%
    EndSql

    dbSelectArea(cAliasQry)
	(cAliasQry)->(dbGoTop())

	nAtual := 0
	Count To nTotal
	ProcRegua(nTotal)

    (cAliasQry)->(DbGoTop())
    While (cAliasQry)->(!Eof())

        SE1->(dbGoTo((cAliasQry)->RECSE1))

		//Incrementando a régua
        nAtual++
        IncProc("Imprimindo titulo " + Alltrim(SE1->E1_NUM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
 
        cFilePedido := ""
		cFileDanfe  := ""
		cFileXML    := ""
		aFileBoleto := {}

		If MV_PAR19 = 1 //Envia NF
			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_SERIE)
			dbSelectArea("SE1")
					
			If RTRIM(SF2->F2_ESPECIE) == "SPED"
				cFileDanfe := GetDANFE(SD2->D2_FILIAL,SD2->D2_SERIE,SD2->D2_DOC)
				cFileXML := GetXML(SD2->D2_FILIAL,SD2->D2_SERIE,SD2->D2_DOC)
			EndIf
		EndIf

		aFileBoleto := GetBoleto(SD2->D2_FILIAL,SD2->D2_SERIE,SD2->D2_DOC)

        cFilePedido := U_M05R03A(.T./*lAuto*/)

		cChaveSE1 := SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO
		cEmailEnv := ""
		cPrefixo  := SE1->E1_PREFIXO
		dEmissao  := SE1->E1_EMISSAO
		dVencto   := SE1->E1_VENCTO
		lImprime  := .F.
		cFileOri  := ""
		cFilePDF  := ""

		//Pega numero do RPS
		If Alltrim(SE1->E1_NFELETR) == "0" .Or. EMPTY(SE1->E1_NFELETR)
			cNumTit := SE1->E1_NUM
		Else
			cNumTit := SE1->E1_NFELETR
		EndIf

		//Posiciona o SA1 (Cliente)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

		/*dbSelectArea("AI0")
		dbSetOrder(1)
		dbSeek(xFilial("AI0")+SE1->E1_CLIENTE+SE1->E1_LOJA)

		If AI0->AI0_RECBOL <> "1" 
			dbSelectArea("SE1")
			dbSkip()
			Loop
		EndIf
		
		cEmailEnv := AllTrim(AI0->AI0_EMABOL)
		*/
        cEmailEnv := "marcos.montes@moovegestao.com.br;marcos.rocha@moovegestao.com.br"

		If !EMPTY(cEmailEnv) 

			lEnvia := .F.  //Envia somente se tiver arquivo gerado

			aAnexos := {}
			AADD(aAnexos,cAssinatura)
			If !EMPTY(cFilePedido)
				AADD(aAnexos,cFolderFiles+cFilePedido)
				lEnvia := .T.
			EndIf
			If !EMPTY(cFileXML)
				AADD(aAnexos,cFolderFiles+cFileXML)
				lEnvia := .T.
			EndIf
			If !EMPTY(cFileDanfe)
				AADD(aAnexos,cFolderFiles+cFileDanfe)
				lEnvia := .T.
			EndIf
			For n := 1 To Len(aFileBoleto)
				cTitulo := IIF(EMPTY(SE1->E1_NFELETR),Alltrim(SE1->E1_NUM),AllTrim(SE1->E1_NFELETR))
				If cTitulo+IIF(EMPTY(SE1->E1_PARCELA),"","_"+ALLTRIM(SE1->E1_PARCELA)) $ aFileBoleto[n]
					AADD(aAnexos,cFolderFiles+aFileBoleto[n])
					lEnvia := .T.
				EndIf
			Next

			If lEnvia

				cFromName := "Financeiro - "+AllTrim(SM0->M0_NOMECOM)
				//cFromAddr := "naoresponda@acosmacom.com.br" 
				cFromAddr := "workflow@hoshizakimacom.com.br" 

				cSubject  := "Faturamento "+AllTrim(SM0->M0_NOMECOM)+" - NF "+ALLTRIM(cNumTit)+;
							IIF(!EMPTY(SE1->E1_PARCELA)," Parcela "+RTRIM(SE1->E1_PARCELA),"")+" - "+AllTrim(SA1->A1_NOME)+" com vencimento em "+DTOC(SE1->E1_VENCTO)+"."

				oProcess:= TWFProcess():New("000001", "Workflow - Envio de Documentos "+DtoC(Date()))
				oProcess:NewTask("Workflow Envio de Documentos",cHtml)
				oProcess:cSubject 	:= cSubject
				oProcess:cTo      	:= cEmailEnv

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

				oHtml:ValByName( "CLIENTE"    , SA1->A1_NOME     )
				oHtml:ValByName( "CNUMTIT"    , ALLTRIM(cNumTit) )
				oHtml:ValByName( "CEMISSAO"   , DTOC(dEmissao)   )
				oHtml:ValByName( "CVENCTO"    , DTOC(dVencto)    )
				oHtml:ValByName( "EMPRESA"    , SM0->M0_NOMECOM  )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Função envio de e-mail                                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oProcess:Start()
				oProcess:Finish()
			
			EndIf

		EndIf

        (cAliasQry)->(DbSkip())
    EndDo
    (cAliasQry)->(DbCloseArea())

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
local cFolderFiles  := cBarra + "temp" + cBarra + cBarra
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
    //MV_PAR07 := ctod("") // //[Data] Inicio
    //MV_PAR08 := ctod("") // //[Data] Fim

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
            PRTMSG( "Nao foi gerado a DANFE para Empresa: "+ cEmpAnt + cFilDoc+ " nota: " + alltrim(cDoc), LOG_ERROR )
            FERASE(cFolderFiles+cFileDanfe)
            return ""
        endif
    EndIf

    while( !lFile .And. nTimes < 10)
        lFile := file(cFolderFiles+cFileDanfe)
        if(!lFile)
            nTimes++
            sleep(500)
        else
            exit
        endif    
    enddo

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
local cFolderFiles  := cBarra + "temp" + cBarra + cBarra
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
Static Function GetBoleto(cFilDoc,cSerie,cDoc)

Local aArea        := GetArea()
Local cSavFil      := cFilAnt
Local aAreaSM0     := SM0->(GetArea())
Local aAreaSF2     := SF2->(GetArea())
Local aAreaSE1     := SE1->(GetArea())
Local cBarra       := if(isSrvUnix(),"/","\")
Local cFolderFiles := cBarra + "temp" + cBarra + cBarra
Local nX           := 0
Local aFileBoletos := {}
Local cTitulo      := ""

cFilAnt := cFilDoc
SM0->(dbSeek(cEmpAnt+cFilAnt))

dbSelectArea("SF2")
dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE
dbSeek(xFilial("SF2",cFilDoc)+cDoc+cSerie)
dbSelectArea("SE1")
dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
If dbSeek(xFilial("SE1",SF2->F2_FILIAL)+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC)

    cTitulo  := IIF(EMPTY(SE1->E1_NFELETR),Alltrim(SE1->E1_NUM),AllTrim(SE1->E1_NFELETR))

    //Busca arquivos via Directory
    aArquivos := Directory(cFolderFiles+"boleto_"+RTRIM(SM0->M0_CGC)+"_"+RTRIM(cTitulo)+"*.pdf","A")
    
    //FWAlertInfo("Tamanho do aArquivos: " + cValToChar(Len(aArquivos)), "Atenção")
    For nX := 1 To Len(aArquivos)
        AADD(aFileBoletos,aArquivos[nX][1])
    Next

EndIf

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

RESTAREA(aAreaSF2)
RESTAREA(aAreaSE1)
RESTAREA(aArea)

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
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
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
static function PRTMSG(cMensagem, nTypeMsg)

	local cDelConout := replicate("-", 78 )

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
