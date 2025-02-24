#INCLUDE "PROTHEUS.CH"
#INCLUDE "FINA980.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Reclassificador de naturezas                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M06A13()

Local aSize 	:= {}
Local aCampos 	:= {}
Local cAlias 	:= ""
Local cCpoOk 	:= ""
Local oDlg		:= Nil
Local oMainWnd 	:= Nil
Local nOpcao   	:= 0
Local lInverte 	:= .F.
Local cPerg 	:= "FIN980"
Local cMarca 	:= GetMark()

Private oMark 	:= Nil

If !Pergunte(cPerg,.T.)
	Return nil
EndIf

If mv_par03 == 1
	cAlias := "SE2"
	cCpoOk := "E2_OK"
Else
	cAlias := "SE1"
	cCpoOk := "E1_OK"
Endif

F980GerTmp(cAlias)
dbSelectArea(cAlias)

If (cAlias)->(Eof())
	MsgInfo (STR0002, STR0001)
Else

	//Campos da MarkBrowse
	aAdd(aCampos,{cCpoOk,"","  ",""})
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek (cAlias))

	//Adiciona o campo filial no browse somente se a tabela estiver exclusivo e em uso.
	If !Empty(FwFilial(cAlias)) .Or. X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		aAdd(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
		SX3->(dbSkip())
	EndIf

	While !Eof() .And. (X3_ARQUIVO == cAlias)
		If X3USO(X3_USADO)  .And. cNivel >= X3_NIVEL .And. X3_CONTEXT != "V"
			aAdd(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
		EndIf
		SX3->(dbSkip())
	Enddo

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	bOk1 := {|| F980Natur(cAlias,cMarca,cCpoOk),oDlg:End(),(cAlias)->(dbCloseArea())}
	bOk2 := {|| oDlg:End(),(cAlias)->(dbCloseArea())}

	aSize := MsAdvSize()
	DEFINE MSDIALOG oDlg TITLE STR0003 From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	oDlg:lMaximized := .T.

	oMark := MsSelect():New(cAlias,cCpoOk,,aCampos,@lInverte,@cMarca,{50,oDlg:nLeft,oDlg:nBottom,oDlg:nRight})
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT // Somente Interface MDI

	//oMark:bMark := {||  }
	oMark:bAval	:= {|| F980Mark(cAlias,cCpoOk,cMarca) }
	oMark:oBrowse:lhasMark = .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:bAllMark := { || F980Invert(cMarca,cAlias,cCpoOk) }
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| Iif(F980VldMrk(cAlias,cMarca,cCpoOk),Eval(bOk1),)},{|| Eval(bOk2)},,/*aButtons*/)) CENTER

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtra o alias SE1 ou SE2 pra montagem da MarkBrowse        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980GerTmp(cAlias)

Local cDataIni := ""
Local cDataFim := ""
Local cFilter  := ""
Local cChave   := ""
Local nCarteira := mv_par03 //1 = Pagar; 2= Receber
Local cNaturIni := mv_par04
Local cNaturFim := mv_par05
Local cIndex  	:= CriaTrab(Nil,.F.)

cDataIni := Str(Year(mv_par01),4)+StrZero(Month(mv_par01),2)+StrZero(Day(mv_par01),2)
cDataFim := Str(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+StrZero(Day(mv_par02),2)

If nCarteira == 1 // Pagar

	cFilter := 'E2_FILIAL == "'+xFilial("SE2")+'" .And. '
	cFilter += '(DTOS(E2_EMISSAO) >= "'+cDataIni+'" .And. DTOS(E2_EMISSAO) <= "'+cDataFim+'") .And. '
	cFilter += '(E2_NATUREZ >= "'+cNaturIni+'" .And. E2_NATUREZ <= "'+cNaturFim+'") .And. '
	cFilter += '!(E2_TIPO $ "'+MVABATIM+'|'+MVTAXA+'|'+MVTXA+'|'+MVINSS+'|'+'SES|CID")'

	cChave := "E2_FILIAL+E2_EMISSAO"

Else //Receber

	cFilter := 'E1_FILIAL == "'+xFilial("SE1")+'" .And. '
	cFilter += '(DTOS(E1_EMISSAO) >= "'+cDataIni+'" .And. DTOS(E1_EMISSAO) <= "'+cDataFim+'") .And. '
	cFilter += '(E1_NATUREZ >= "'+cNaturIni+'" .And. E1_NATUREZ <= "'+cNaturFim+'") .And. '
	cFilter += '!(E1_TIPO $ "'+MVABATIM+'|'+MVINABT+'|'+MVIRABT+'|'+MVCSABT+'|'+MVCFABT+'|'+MVPIABT+'")'

	cChave := "E1_FILIAL+E1_EMISSAO"

Endif

dbSelectArea(cAlias)
cChave  := IndexKey()
IndRegua(cAlias,cIndex,cChave,,cFilter,STR0004)  //Aguarde
nIndex := RetIndex(cAlias)
(cAlias)->(dbSetOrder(nIndex+1))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  05/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a marcação da markbrowse                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980VldMrk(cAlias,cMarca,cCpoOk)

Local lReturn    := .F.
Local aAreaAlias := {}

dbSelectArea(cAlias)
aAreaAlias := (cAlias)->(GetArea())

(cAlias)->(dbGoTop())

While !(cAlias)->(Eof())

	If (cAlias)->(&cCpoOk) == cMarca
		lReturn := .T.
		Exit
	EndIf

   	(cAlias)->(dbSkip())

EndDo

If !lReturn
	MsgAlert(STR0005, STR0001) //Selecione ao menos um título para o processamento da reclassificação.
EndIf

RestArea(aAreaAlias)

Return lReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  05/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera a tela pra informar a natureza e exibe o resultado da  º±±
±±º          ³substituição de naturezas                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980Natur(cAlias, cMarca, cCpoOk)

Local oDlg2 	:= Nil
Local oMemo 	:= Nil
Local bProces 	:= Nil
Local lProc 	:= .F.
Local aProces 	:= {}
Local cNatureza := CriaVar("ED_CODIGO",.F.)
Local cTexto 	:= ""
Local nX 		:= 0

DEFINE MSDIALOG oDlg2 FROM  15,6 TO 100,350 TITLE STR0006 PIXEL

bProces := {|| F980Proc(cNatureza, @lProc, @aProces, cAlias, cMarca, cCpoOk),oDlg2:End()}
oDlg2:lMaximized := .F.

@ 10,15 SAY STR0007 SIZE 23, 7 OF oDlg2 PIXEL COLOR CLR_HBLUE
@ 10,50 MSGET cNatureza F3 "SED" SIZE 60, 10 OF oDlg2 PIXEL Picture "@!"  Valid F980VldNat(cNatureza) HASBUTTON

DEFINE SBUTTON FROM 10,120 TYPE 1 ACTION Eval(bProces) ENABLE OF oDlg2

ACTIVATE MSDIALOG oDlg2 CENTERED

//Informe do processamento
If Len(aProces) > 0

	If mv_par03 == 1 //Pagar

		cTexto := STR0008+CRLF // Titulos a Pagar
		cTexto += "---------------------------------------------------------------"+CRLF

		cTexto += PadR(STR0010,TamSx3("E2_PREFIXO")[1]+1," ") 		//Prefixo
		cTexto += PadR(STR0011,TamSx3("E2_NUM")[1]+2," ")      	//Numero
		cTexto += PadR(STR0012,TamSx3("E2_PARCELA")[1]+2," ")   	//Parcela
		cTexto += PadR(STR0013,TamSx3("E2_TIPO")[1]+4," ") 	  	//Tipo
		cTexto += PadR(STR0014,TamSx3("E2_FORNECE")[1]+1," ")	 	//Fornecedor
		cTexto += PadR(STR0016,TamSx3("E2_LOJA")[1]+3," ")      	//Loja
		cTexto += STR0017+CRLF                               		//Status

	ElseIf mv_par03 = 2 //Receber

		cTexto := STR0009+CRLF // Titulos a Receber
		cTexto += "---------------------------------------------------------------"+CRLF

		cTexto += PadR(STR0010,TamSx3("E1_PREFIXO")[1]+1," ")  	//Prefixo
		cTexto += PadR(STR0011,TamSx3("E1_NUM")[1]+2," ")      	//Numero
		cTexto += PadR(STR0012,TamSx3("E1_PARCELA")[1]+2," ")   	//Parcela
		cTexto += PadR(STR0013,TamSx3("E1_TIPO")[1]+4," ") 	  	//Tipo
		cTexto += PadR(STR0015,TamSx3("E1_CLIENTE")[1]+1," ") 		//Cliente
		cTexto += PadR(STR0016,TamSx3("E1_LOJA")[1]+3," ")     	//Loja
		cTexto += STR0017+CRLF                              		//Status

	EndIf

	cTexto += "---------------------------------------------------------------"+CRLF

	For nX := 1 to Len(aProces)

		cTexto += aProces[nX][1]+"-"+aProces[nX][2]+"  "+aProces[nX][3]+"  "+aProces[nX][4]+"    "+aProces[nX][5]+" "+aProces[nX][6]

		If aProces[nX][7] == "0"
			cTexto += " - "+STR0018+CRLF
		Else
			cTexto += " - "+STR0019+CRLF
		EndIf


	Next nX

	//Dados complementares
	cTexto += CRLF+"---------------------------------------------------------------"+CRLF
	cTexto += " "
	cTexto += STR0020 //ATENÇÃO: Os registros NÃO PROCESSADOS possuem naturezas que não condizem com a informada.
	cTexto += " "
	cTexto += STR0021 //Verifique uma natureza compatível antes da seleção.


	DEFINE FONT oFont NAME "Mono AS" SIZE 6,15
	DEFINE MSDIALOG oDlg2 TITLE STR0022 From 3,0 to 340,417 PIXEL //Registros processados
	@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg2 PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg2:End() ENABLE OF oDlg2 PIXEL

	ACTIVATE MSDIALOG oDlg2 CENTER

Else
	cTexto := STR0023+CRLF //Nenhum registro foi processado.
	cTexto += STR0024+CRLF //A natureza e/ou títulos selecionados não são equivalentes
	cTexto += STR0025+CRLF //ou o processo foi interrompido pelo usuário.

	MsgInfo(cTexto, STR0001)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  05/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa as subtituções de naturezas                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980Proc(cNatureza, lProc, aProces, cAlias, cMarca, cCpoOk)

Local aConfNat	:= {}
Local aRegistro	:= {}

Local nX 		:= 0
Local nCarteira := mv_par03 //1=Pagar; 2=Receber

Local cCpoNat 	:= ""
Local cCposOut 	:= "APURPIS|APURCOF|PCAPPIS|PCAPCOF|IRRFCAR|INSSCAR" //Outros campos --> Carreteiro e Apuração
Local cCampo	:= ""

Local lNatVld 	:= .T.

Local cNatOrig 	:= ""
Local cPrefOrig := ""
Local cNumOrig 	:= ""
Local cParcOrig := ""
Local cTipOrig 	:= ""
Local cCFOrig 	:= ""
Local cLojOrig 	:= ""

Local cFiltro 	:= ""
Local nRecno	:= ""
Local aArea		:= {}

DEFAULT cNatureza 	:= ""
DEFAULT cAlias	 	:= ""
DEFAULT cMarca	 	:= ""
DEFAULT cCpoOk	 	:= ""
DEFAULT aProces 	:= {}
DEFAULT lProc	 	:= .F.


//Campos a serem validados na atualização da natureza
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek ("SED"))

//Inclui a natureza no array
aAdd(aConfNat,{"ED_FILIAL",CriaVar("ED_FILIAL",.F.)})

While !Eof() .And. (X3_ARQUIVO == "SED")
	If X3Uso(X3_USADO)  .And. cNivel >= X3_NIVEL .And. X3_CONTEXT != "V" .And.;
	   (SubStr(X3_CAMPO,4,4) $ "CALC|PERC|BASE" .Or. SubStr(X3_CAMPO,4,3) == "DED" .Or. SubStr(X3_CAMPO,4,7) $ cCposOut )
		aAdd(aConfNat,{X3_CAMPO,CriaVar(X3_CAMPO,.F.)})
	EndIf
	SX3->(dbSkip())
Enddo

//Posiciona na natureza selecionada
dbSelectArea("SED")
SED->(dbSetOrder(1))

If SED->(dbSeek(xFilial("SED")+cNatureza))

	For nX := 1 to Len(aConfNat)
		cCampo := aConfNat[nX][1]
		aConfNat[nX][2] := SED->(&cCampo)
	Next nX

Endif

//Campos que serao atualizados
If nCarteira == 1 // Pagar
	cCpoNat := "E2_NATUREZ"
ElseIf nCarteira == 2 //Receber
	cCpoNat := "E1_NATUREZ"
EndIf

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While !(cAlias)->(Eof())

	IncProc("Processando...")

	If (cAlias)->(&cCpoOk) == cMarca

		If nCarteira == 1 // Pagar
			cNatOrig	:= (cAlias)->E2_NATUREZ
			cPrefOrig	:= (cAlias)->E2_PREFIXO
			cNumOrig	:= (cAlias)->E2_NUM
			cParcOrig 	:= (cAlias)->E2_PARCELA
			cTipOrig 	:= (cAlias)->E2_TIPO
			cCFOrig 	:= (cAlias)->E2_FORNECE
			cLojOrig 	:= (cAlias)->E2_LOJA

		ElseIf nCarteira == 2 //Receber
			cNatOrig	:= (cAlias)->E1_NATUREZ
			cPrefOrig	:= (cAlias)->E1_PREFIXO
			cNumOrig	:= (cAlias)->E1_NUM
			cParcOrig 	:= (cAlias)->E1_PARCELA
			cTipOrig 	:= (cAlias)->E1_TIPO
			cCFOrig 	:= (cAlias)->E1_CLIENTE
			cLojOrig 	:= (cAlias)->E1_LOJA
		EndIf

	   	If SED->(dbSeek(xFilial("SED")+cNatOrig))
	   		//Compara as características da natureza
	   		For nX := 1 to Len(aConfNat)
				cCampo := aConfNat[nX][1]
				If SED->(&cCampo) <> aConfNat[nX][2]
					lNatVld := .F.
					Exit
				EndIf
			Next nX
	   	EndIf

		//Array que ira conter os detalhes do registro processado
		//-- [1] Prefixo
		//-- [2] Numero
		//-- [3] Parcela
		//-- [4] Tipo
		//-- [5] Cliente/Fornecedor
		//-- [6] Loja
		//-- [7] Processado? 0=Nao;1=Sim
		aRegistro := Array(7)

		aRegistro[1] := cPrefOrig
		aRegistro[2] := cNumOrig
		aRegistro[3] := cParcOrig
		aRegistro[4] := cTipOrig
		aRegistro[5] := cCFOrig
		aRegistro[6] := cLojOrig

		If lNatVld

			//Atualiza a natureza do títilo
			RecLock(cAlias, .F.)
			(cAlias)->(&cCpoNat) := cNatureza
			(cAlias)->(MsUnlock())

			//Procura por baixas realizadas para fazer a alteração.
			dbSelectArea("SE5")
			SE5->(dbSetOrder(7))

			If SE5->(dbSeek(xFilial("SE5")+cPrefOrig+cNumOrig+cParcOrig+cTipOrig+cCFOrig+cLojOrig))

				While !SE5->(Eof()) .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == xFilial("SE5")+cPrefOrig+cNumOrig+cParcOrig+cTipOrig+cCFOrig+cLojOrig

					If SE5->E5_NATUREZ <> cNatureza
						RecLock("SE5", .F.)
						SE5->E5_NATUREZ := cNatureza
						SE5->(MsUnlock())
					EndIf

					SE5->(dbSkip())
				EndDo

			EndIf

			//Procura por abatimento AB-
			dbSelectArea(cAlias)
			aArea   := (cAlias)->(GetArea())
			nRecno  := (cAlias)->(Recno())
			cFiltro := (cAlias)->(dbFilter())

			If nCarteira == 1 // Pagar
				(cAlias)->(dbSetOrder(6))
			ElseIf nCarteira == 2
				(cAlias)->(dbSetOrder(2))
			EndIf

			(cAlias)->(dbClearFilter())

			If (cAlias)->(dbSeek(xFilial(cAlias)+cCFOrig+cLojOrig+cPrefOrig+cNumOrig+cParcOrig+"AB-"))
				If (cAlias)->(&cCpoNat) == cNatOrig
					//Atualiza o abatimento
					RecLock(cAlias, .F.)
					(cAlias)->(&cCpoNat) := cNatureza
					(cAlias)->(MsUnlock())
				EndIf
			EndIf

			Set Filter to &cFiltro
			RestArea(aArea)

			aRegistro[7] := "1" //Registro processado

		Else
			aRegistro[7] := "0" //Registro nao processado
		EndIf

		aAdd(aProces,aRegistro)
		lNatVld := .T.
	EndIf

	(cAlias)->(dbSkip())

EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte a seleção da markbrowse                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980Invert(cMarca,cAlias,cCampo)

Local nReg := (cAlias)->(Recno())

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While !Eof()
	RecLock(cAlias,.F.)
	IF (cAlias)->&cCampo == cMarca
		(cAlias)->&cCampo := "  "
	Else
		(cAlias)->&cCampo := cMarca
	Endif
	(cAlias)->(MsUnlock())
	(cAlias)->(dbSkip())
Enddo

(cAlias)->(dbGoto(nReg))

oMark:oBrowse:Refresh(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  12/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a marca do título selecionado                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980Mark(cAlias,cCampo,cMarca)

Local nReg := (cAlias)->(Recno())

dbSelectArea(cAlias)


RecLock(cAlias,.F.)
	If (cAlias)->&cCampo <> cMarca
		(cAlias)->&cCampo := cMarca
	Else
		(cAlias)->&cCampo := ""
	EndIf
(cAlias)->(MsUnlock())

oMark:oBrowse:Refresh(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA980   ºAutor  ³Microsiga           º Data ³  05/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a natureza selecionada para a substituição           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F980VldNat(cNatureza)

Local lReturn := .T.
Local aReserv := {}

Local nX := 0

If Empty(cNatureza)
	MsgStop(STR0026, STR0001) //Informe uma natureza antes de confirmar o processamento
	lReturn := .F.
ElseIf !ExistCpo("SED",cNatureza)
	lReturn := .F.
Else
	dbSelectArea("SED")
	SED->(dbSetOrder(1))

	//Naturezas reservadas
	aAdd(aReserv,StrTran(GetMv("MV_CIDE"),'"')) 	//-- CIDE
	aAdd(aReserv,StrTran(GetMv("MV_COFINS"),'"')) 	//-- COFINS
	aAdd(aReserv,StrTran(GetMv("MV_PISNAT"),'"')) 	//-- PIS
	aAdd(aReserv,StrTran(GetMv("MV_CSLL"),'"')) 	//-- CSLL
	aAdd(aReserv,StrTran(GetMv("MV_INSS"),'"')) 	//-- INSS
	aAdd(aReserv,StrTran(GetMv("MV_IRF"),'"')) 	//-- IRRF
	aAdd(aReserv,StrTran(GetMv("MV_ISS"),'"')) 	//-- ISS
	aAdd(aReserv,StrTran(GetMv("MV_SEST"),'"')) 	//-- SEST

	If SED->(dbSeek(xFilial("SED")+cNatureza))
		For nX := 1 to Len(aReserv)
			If AllTrim(SED->ED_CODIGO) == AllTrim(aReserv[nX])
				MsgInfo(STR0027, STR0001) //A natureza informada é de uso exclusivo do sistema ou não pode ser utilizada por esta rotina.
				lReturn := .F.
				Exit
			EndIf
		Next nX
	EndIf
Endif

Return lReturn
