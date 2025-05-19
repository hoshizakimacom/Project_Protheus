#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)

/*/{Protheus.doc} M04M13

Download dos arquivos de Desenho dos Produtos (PDF)

@author Marcos Antonio Montes
@since 21/01/2025
@return Nil Nulo
/*/
User Function M04M13()

Local aPergs     := {}

Private cTitulo   := "Download arquivos de Desenho dos Produtos (PDF)"
Private aRetPar   := {}

Aadd(aPergs, {1, "Produto"                ,REPLICATE(' ',TAMSX3("D3_COD")[1]),"@X","","SB1","",80,.F.})     //1
Aadd(aPergs, {6, "Local destino"          ,SPACE(100),"","","",100,.T.,"Todos os arquivos (*.*) |*.*",,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_NETWORKDRIVE}) //2

While .T.

	If !ParamBox(aPergs, "Informe o produto e local de destino", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)
		Exit 
	EndIf

	FwMakeDir(aRetPar[2])

	LjMsgRun( "Executando o Download..." ,, {|| U_M04M13D() } )

EndDo

Return Nil


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} U_M04M13D

Executando o download dos arquivos

@author    Montes 
@version   12.1
@since     21.01.2025

@return NIL

/*/
//------------------------------------------------------------------------------------------
User Function M04M13D()

Local cProduto  := aRetPar[1]
Local cDirDest  := LOWER(RTRIM(aRetPar[2]))
Local nArquivos := 0
Local aFile     := {}
Local nX        := 0
Local lErro     := .F.

If !(RIGHT(cDirDest,1) $ "\/")
	cDirDest := cDirDest + "\"
EndIf

If LEN(aFile := Directory(cDirDest+"*.*", "F")) > 0 
	If Aviso("ALERTA","Existem arquivos na pasta destino, ao confirmar para seguir os arquivos serão deletados!",{"Continua","Abandona"}) = 1
		For nX := 1 To Len(aFile)
			If FERASE(cDirDest+aFile[nX,1]) <> 0
				lErro := .T.
			EndIf
		Next
	Else
		lErro := .T.
	EndIf
EndIf

If lErro

	FWAlertInfo("Não foi possivel apagar arquivos na pasta destino!!", "Feche todos os arquivos da pasta")
Else

	MontaEstru(cProduto,cDirDest,@nArquivos,)

	If nArquivos > 0

		FWAlertInfo("Download de "+RTRIM(STR(nArquivos,10))+" arquivos PDF's!!", "DownLoad arquivos de Desenhos")

		ShellExecute("open",LOWER(cDirDest),"","",5) //5=Show
	Else
		
		FWAlertInfo("Não encontrado arquivos para DownLoad!!", "DownLoad arquivos de Desenhos")
	EndIf

EndIf

Return nArquivos

/*

Pesquisa Estrutura e efetua download do arquivo

*/
Static Function MontaEstru(cProduto,cDirDest,nArquivos,cRevisao)

Local nRecAnt    := 0
Local cComp      := ''
Local cRevPI 	 := ""
Local dValIni    := CtoD('  /  /  ')
Local dValFim    := CtoD('  /  /  ')
Local lRet		 := .T.
Local lContinua	 := .T.
Local lExpand    := .T. 
Local lExibeOPC  := .T.
Local nIndSG1	 := 1
Local lOpcional  := .F.
Local lOpcAux    := .T.

lExpEst := .T.

//-- Posiciona no SB1
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial('SB1') + cProduto, .F.))

DEFAULT cRevisao := SB1->B1_REVATU

TemAnexo(cProduto,cDirDest,@nArquivos)

SG1->(dbSetOrder(nIndSG1))
If !SG1->(dbSeek(xFilial('SG1') + cProduto, .F.))
	lRet := .F.
EndIf

If lRet .And. lContinua
	
	cTRTPai := If(cTRTPai==Nil,SG1->G1_TRT,cTRTPai)

	dValIni := SG1->G1_INI
	dValFim := SG1->G1_FIM

	//-- Define as Pastas a serem usadas
	lAtivo := .T.
	If (dDataBase < dValIni .Or. dDataBase > dValFim)
		lAtivo := .F.
	EndIf

	While !SG1->(Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

		lExpEst := .T.

			//-- Nao Adiciona Componentes fora da Revis„o
			If (cRevisao # Nil) .And. ;
				!(SG1->G1_REVINI <= cRevisao .And. (SG1->G1_REVFIM >= cRevisao .Or. SG1->G1_REVFIM = ' '))
				SG1->(dbSkip())
				Loop
			EndIf

			nRecAnt  := SG1->(Recno())
			cComp    := SG1->G1_COMP

			If Empty(SG1->G1_GROPC)
				lOpcAux := .F.
			Else
				lOpcAux := .T.
			EndIf

			lAtivo := .T.
			If dDataBase < SG1->G1_INI .Or. dDataBase > SG1->G1_FIM
				lAtivo := .F.
			EndIf

			//-- Posiciona no SB1
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1') + cComp, .F.))
			lExpEst := .T.

   			If SG1->(dbSeek(xFilial('SG1') + SG1->G1_COMP, .F.)) .and. lExpEst

				cRevPi := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU)  
				IF empty(cRevPI)
					cRevPi := '001'
				endif
				//cRevPi := IIf(SB1->B1_REVATU = ' ','001',SB1->B1_REVATU)

   				If lExpand .And. lExibeOPC
					//-- Adiciona um Nivel a Estrutura
					If cComp == SG1->G1_COD .And. !lOpcAux
                		lOpcional := .F.
             		Else
                		lOpcional := .T.
             		EndIf
					MontaEstru(SG1->G1_COD,cDirDest,@nArquivos,cRevPI)
				Else
				
					If lAtivo
						TemAnexo(cComp,cDirDest,@nArquivos)
					EndIf
				EndIf
			Else

				If lAtivo
					TemAnexo(cComp,cDirDest,@nArquivos)
				EndIf
			EndIf

		SG1->(dbGoto(nRecAnt))
		SG1->(dbSkip())
	EndDo
EndIf

Return 

Static Function TemAnexo(cProduto,cDirDest,nArquivos)

Local cDirServer := "\produtos_anexos\"
Local aFile      := {}

If LEN(aFile := Directory(cDirServer+RTRIM(cProduto)+"_PDF"+"*.*", "F")) > 0
	
	nArquivos += 1
	
	//Copiando o arquivo do servidor para o cliente
    If CpyS2T(cDirServer+"\"+aFile[1,1],cDirDest)
		//Força a chamada para impressão pelo programa padrão definido no Explorer
		//ShellExecute("open",LOWER(cDirDest+aFile[1,1]),"","",0) //0=ESCONDIDO
		//ShellExecute("print","C:\Program Files\Google\Chrome\Application\chrome.exe",LOWER(cDirDest+aFile[1,1]),"",0) //0=ESCONDIDO
	EndIf
EndIf

Return Nil
