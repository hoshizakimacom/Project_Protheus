#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE 'DBTREE.CH'

#DEFINE CONTROL_ALIGN_CENTER 0

STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)

/*/{Protheus.doc} M04M10

Função para chamada no Menudef da Rotina de Produtos

@author Marcos Antonio Montes
@since 13/09/2024
@return Nil Nulo
/*/
User Function M04M10(nAcao)

Local oAnexo := ClassAnexoProduto():New()

If nAcao = 1
    If oAnexo:PodeVisualizar("UPLOAD")
	    oAnexo:Anexar()
	Else
		Aviso("SEMPERMISSAO","Usuário sem permissão para efetuar UPLOAD de arquivos!!!",{"Ok"})
	EndIf
ElseIf nAcao = 2
    oAnexo:Visualizar()
EndIf

//oAnexo:Destroy()

Return


/*/{Protheus.doc} ClassAnexoProduto

Classe para controle de Anexo do cadastro de Produto

@author Marcos Antonio Montes
@since 13/09/2024
@return Nil Nulo
/*/
CLASS ClassAnexoProduto

    Data cMsgError As String
    Data cDirAnexos As String

	METHOD New() CONSTRUCTOR

	METHOD Anexar()

	METHOD SalvarAnexo()

	METHOD Visualizar(cProduto)

	METHOD AbrirAnexo(cFileName,cFilePath)

	METHOD PodeVisualizar(cPrefixo)

ENDCLASS

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ New                                                  ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD New() CLASS ClassAnexoProduto

::cMsgError := ""
::cDirAnexos := "\produtos_anexos\"

FWMakeDir(::cDirAnexos)

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ Anexar                                               ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD Anexar() CLASS ClassAnexoProduto

	Local cFilePath	:= ""
    Local cDirLocal := 'c:\temp\'
    Local nProc5
	Local aFiles    := {}
	Local aPergs    := {}
	Local aRetPar   := {}

	Private aHeader  := {}
	Private aCols    := {}
	Private aRotina  := {}

	If ::PodeVisualizar("UPLOAD")

		Aadd(aPergs, {6, "Pasta Origem",SPACE(100),"","","",100,.F.,"*.*"/*cMask*/,cDirLocal,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_NETWORKDRIVE}) //6

		If !ParamBox(aPergs, "UPLOAD de arquivos para o Produto", @aRetPar,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPOSX*/,/*nPOSY*/,/*oDlgWIzard*/,/*cLoad*/,/*lCanSave*/,.T./*lUserSave*/)
			cFilePath := ""
		Else
			cFilePath := ALLTRIM(aRetPar[1])
		EndIf

		If !Empty(cFilePath)

			aFiles := ::salvarAnexo(cFilePath)

			//????????????????????
			//? Alimenta aHeader. ?
			//?????????????????????
			aHeader:={}
			Aadd(aHeader,{ ""          ,       "Legenda" , "@BMP",01 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Item"      ,       "Item"    , "@9"  ,05 , 00,".F.","???????????????", "N","TRB"})
			Aadd(aHeader,{ "Arquivo"   ,       "File"    , "@!"  ,30 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Produto"   ,       "PRODUTO" , "@!"  ,15 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Descricao" ,       "DESCRIC" , "@!"  ,30 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Tipo de Arquivo",  "TIPARQ"  , "@!"  ,20 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Extensão" ,        "EXTENSAO", "@!"  ,05 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Sufixo" ,          "SUFIXO"  , "@!"  ,05 , 00,".F.","???????????????", "C","TRB"})
			Aadd(aHeader,{ "Ocorrencia",       "OCORR"   , "@!"  ,100, 00,".F.","???????????????", "C","TRB"})
			nUsado := 4

			_nItem := 0
			aCols:={}
			For nProc5 := 1 To Len(aFiles)
				_nItem++
				Aadd(aCols,{IIF(aFiles[nProc5,1],"BR_VERDE","BR_VERMELHO"),StrZero(_nItem,3),aFiles[nProc5,2],Left(aFiles[nProc5,3],30),aFiles[nProc5,4],aFiles[nProc5,5],aFiles[nProc5,6],aFiles[nProc5,7],aFiles[nProc5,8],.F.})
			Next

			@ 150,1 TO 720/*430*/,1220/*630*/ Dialog oDlg1 Title "Resumo da Importação"

			@ 010,010 TO 255/*107*/,600/*310*/ Multiline Object oLinhas

			@ 265/*118*/,520/*280*/ Button "Excel" Action ExpExcel(aHeader,aCols)
			@ 265/*118*/,570/*280*/ BmpButton Type 1 Action Close(oDlg1)

			Activate Dialog oDlg1 Centered

		EndIf
	EndIf

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ salvarAnexo                                          ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD salvarAnexo(_cFilePath) CLASS ClassAnexoProduto

	Local aRet			:= {}
    Local aFiles        := Directory(_cFilePath+"*.*", "F")
	Local cDirServer	:= ::cDirAnexos
	Local lSobrepor     := (::PodeVisualizar("SOBREP"))

	Private oProcess := Nil

    dbSelectArea("SB1")
    dbSetOrder(1)

	oProcess := MsNewProcess():New( { | lEnd | aRet := UpLoad(@lEnd,_cFilePath,cDirServer,aFiles,lSobrepor) }, "Carregando", "Aguarde, carregando arquivos...", .F. )
	oProcess:Activate()

Return aRet

Static Function UpLoad(lEnd,cFilePath,cDirServer,aFiles,lSobrepor)

	Local aRet			:= {}
	Local cFileName		:= ""//Nome ORIGINAL do arquivo.
    Local cDrive        := ""
    Local cCaminho      := ""
    Local cNome         := ""
    Local cExtensao     := ""
    Local cRevisao      := ""
	Local aFilesOld     := ""
    Local lStatus       := .T.
    Local lUpdate       := .F.
	Local lFErase       := .F.
	Local nTimes        := 0
    Local nF, nX

	oProcess:SetRegua1( Len(aFiles) )

    For nF := 1 To Len(aFiles)

        lStatus   := .T.
        cFileName := cFilePath+aFiles[nF,1]

		oProcess:IncRegua1( "Copiando arquivo " + cFileName + " ..." )

		oProcess:SetRegua2( 2 )

		oProcess:IncRegua2( "Validando nomenclatura do arquivo.." )

        cDrive   := ""
        cCaminho := ""
        cNome    := ""
        cExtensao:= ""
        SPLITPATH( cFileName, @cDrive, @cCaminho, @cNome, @cExtensao )

        cProduto  := LEFT(cNome,(LEN(cNome)-5))  
        cSufixo   := LEFT(RIGHT(cNome,5),3) 
		cRevisao  := RIGHT(cNome,2)
		cDescProd := ""

        cOcorrencia := ""
        If cSufixo == "PDF" //"DES"
            cTipoArq  := "Desenho do produto"
        ElseIf cSufixo == "COM"
            cTipoArq  := "Desenho de Componentes"
        ElseIf cSufixo == "FCT"
            cTipoArq  := "Ficha técnica"
        ElseIf cSufixo == "MNL"
            cTipoArq  := "Manual"
        ElseIf cSufixo == "RVT"
            cTipoArq  := "Revit/Bloco 2D/3D"
        ElseIf cSufixo == "DXF" //"COR"
            cTipoArq  := "DXF (Desenho de corte)"
        Else
            cTipoArq  := "Não identificado"
            lStatus := .F.
            cOcorrencia := "Sufixo do arquivo inválido!"
        EndIf

        If lStatus 
			If !SB1->(dbSeek(xFilial("SB1")+PADR(cProduto,TAMSX3("B1_COD")[1])))
				lStatus := .F.
				cOcorrencia := "Produto não cadastrado!"
			Else
				cDescProd := SB1->B1_DESC
			EndIf
		EndIf

        If lStatus .And. !File(cFileName)
            lStatus := .F.
            cOcorrencia := "Não foi possivel localizar o arquivo na origem!"
        EndIf

        If lStatus .And. File(cDirServer+cNome+cExtensao)
            lStatus := .F.
            cOcorrencia := "Já existe o arquivo no servidor!"
        EndIf

        lUpdate := .F.
        If lStatus .And. LEN(aFilesOld := Directory(cDirServer+cProduto+cSufixo+"*"+cExtensao, "F")) > 0
            
			If !lSobrepor
				lStatus := .F.
				cOcorrencia := "Usuário sem acesso a sobrepor arquivos no servidor!"
				Exit
			Else
			
				For nX := 1 To Len(aFilesOld)
					cRevServer := LEFT(RIGHT(aFilesOld[nX,1],2+LEN(cExtensao)),2)
					If cRevisao <= cRevServer
						lStatus := .F.
						cOcorrencia := "Revisão inferior ao do servidor, não permitido sobrepor! Revisão do Servidor:"+cRevServer+" # Revisão do novo Arquivo:"+cRevisao
						Exit
					Else			
						If (FErase(cDirServer+aFilesOld[nX,1]) == 0)
							lUpdate := .T.
						Else
							lStatus := .F.
							cOcorrencia := "Erro ao sobrepor arquivo no servidor! Houve uma falha na exclusão do arquivo, erro #" + cValToChar(FError())
							Exit
						EndIf
					EndIf
				Next
			EndIf
        EndIf

        //Copiando o arquivo do cliente para o servidor
        If lStatus 
			oProcess:IncRegua2( "Copiando arquivo.." )

            If CpyT2S(cFileName,cDirServer,.T.,.F.)

				lFound := .F.
				nTempo := 0
				While !lFound 
					lFound := File(cDirServer+cNome+cExtensao)
					nTempo += 1
					If nTempo > 1000
					   Exit
					EndIf
				EndDo

				If lFound
					lStatus := .T.
					If lUpdate
						cOcorrencia := "Arquivo atualizado com sucesso!"
					Else
						cOcorrencia := "Arquivo anexo com sucesso!"
					EndIf
					//Apaga arquivo na origem após copia
					lFErase := .F.
					nTimes := 0
					While( !lFErase .And. nTimes < 10)
						lFErase := (FErase(cFileName) == 0)
						If(!lFErase)
							nTimes++
							Sleep(500)
						Else
							Exit
						EndIf    
					EndDo
					If !lFErase
						cOcorrencia += " Só não foi possivel apagar o arquivo de origem, pode estar em uso!!"
					EndIf
				Else
					lStatus := .F.
					cOcorrencia := "Erro ao fazer o upload do arquivo!"
				EndIf
            Else
                lStatus := .F.
                cOcorrencia := "Erro ao fazer o upload do arquivo!"
            EndIf
        EndIf

        AADD(aRet,{lStatus,aFiles[nF][1],cProduto,cDescProd,cTipoArq,cExtensao,cSufixo,cOcorrencia})
    Next

Return aRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ O                                           ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD Visualizar(cProduto) CLASS ClassAnexoProduto


    Local	nLin	as	numeric
    Local	ncol	as	numeric
    Local	oDlg	as	object
    //Local	oSay	as	object

    Local	bClick_PDF	as	codeblock
    Local	bClick_COM	as	codeblock
    Local	bClick_FCT	as	codeblock
    Local	bClick_MNL	as	codeblock
    Local	bClick_RVT	as	codeblock
    Local	bClick_DXF	as	codeblock

    Local	oFont 	as	object

	Private cFileName as  string 
	Private cFilePath as  string 
    Private oTFont       := TFont():New('Verdana',0/*nWidth*/,-10/*-30*//*nHeight*/,,.F./*lBold*/,,,,,.F./*lUnderline*/,.F./*lItalic*/)

	Private aPodeVis := {}
    Private nPosPDF  := 1
    Private nPosCOM  := 2
    Private nPosFCT  := 3
    Private nPosMNL  := 4
    Private nPosRVT  := 5
    Private nPosDXF  := 6

    Default cProduto := SB1->B1_COD

    cFilePath	:= ::cDirAnexos //Diretorio contendo os anexos no servidor
    cFileName   := Alltrim(cProduto)

    cImg			:=	'banner_taf'
    oFont 			:= 	TFont():New('Arial',,-12,.T.)

	cImgPDF         := cFilePath+"imgpdf.bmp"
	cImgCOM         := cFilePath+"imgpdf.bmp" 
	cImgFCT         := cFilePath+"imgpdf.bmp" 
	cImgMNL         := cFilePath+"imgpdf.bmp" 
	cImgRVT         := cFilePath+"imgrfa.bmp" 
	cImgDXF         := cFilePath+"imgdxf.bmp"

	cImgPDFNo       := cFilePath+"imgpdf_no.bmp"
	cImgCOMNo       := cFilePath+"imgpdf_no.bmp" 
	cImgFCTNo       := cFilePath+"imgpdf_no.bmp" 
	cImgMNLNo       := cFilePath+"imgpdf_no.bmp" 
	cImgRVTNo       := cFilePath+"imgrfa_no.bmp" 
	cImgDXFNo       := cFilePath+"imgdxf_no.bmp"

	If FILE("c:\temp\imgpdf.bmp")
		CPYT2S("c:\temp\imgpdf.bmp",cFilePath)
		CPYT2S("c:\temp\imgrfa.bmp",cFilePath)
		CPYT2S("c:\temp\imgdxf.bmp",cFilePath)
		CPYT2S("c:\temp\imgpdf_no.bmp",cFilePath)
		CPYT2S("c:\temp\imgrfa_no.bmp",cFilePath)
		CPYT2S("c:\temp\imgdxf_no.bmp",cFilePath)

		FERASE("c:\temp\imgpdf.bmp")
		FERASE("c:\temp\imgrfa.bmp")
		FERASE("c:\temp\imgdxf.bmp")
		FERASE("c:\temp\imgpdf_no.bmp")
		FERASE("c:\temp\imgrfa_no.bmp")
		FERASE("c:\temp\imgdxf_no.bmp")
	EndIf

	aPodeVis := {}
	AADD(aPodeVis,::PodeVisualizar("PDF"))
	AADD(aPodeVis,::PodeVisualizar("COM"))
	AADD(aPodeVis,::PodeVisualizar("FCT"))
	AADD(aPodeVis,::PodeVisualizar("MNL"))
	AADD(aPodeVis,::PodeVisualizar("RVT"))
	AADD(aPodeVis,::PodeVisualizar("DXF"))

    bClick_PDF		:=	{|| ::AbrirAnexo(cFileName+"PDF",cFilePath) }
    bClick_COM		:=	{|| ::AbrirAnexo(cFileName+"COM",cFilePath) }
    bClick_FCT		:=	{|| ::AbrirAnexo(cFileName+"FCT",cFilePath) }
    bClick_MNL		:=	{|| ::AbrirAnexo(cFileName+"MNL",cFilePath) }
    bClick_RVT		:=	{|| ::AbrirAnexo(cFileName+"RVT",cFilePath) }
    bClick_DXF		:=	{|| ::AbrirAnexo(cFileName+"DXF",cFilePath) }

    bValid_PDF		:=	{|| aPodeVis[nPosPDF] }
    bValid_COM		:=	{|| aPodeVis[nPosCOM] }
    bValid_FCT		:=	{|| aPodeVis[nPosFCT] }
    bValid_MNL		:=	{|| aPodeVis[nPosMNL] }
    bValid_RVT		:=	{|| aPodeVis[nPosRVT] }
    bValid_DXF		:=	{|| aPodeVis[nPosDXF] }

    nCol			:= 1120	/*820*/
    nLin	        :=	770 /*570*/
	
    //foi necessário comentar o "nOr( WS_VISIBLE, WS_POPUP )" devido a um problema de lib onde o botão (X) que fecha a tela do objeto FWLayer
    //não está aparecendo na versão 12. Descomentar após correção do fw.
    oDlg := MsDialog():New( 0, 0, nLin, nCol, "",,,, /*nOr( WS_VISIBLE, WS_POPUP )*/,,,,, .T.,,,, .F. )

	oGrpCo1 := TGROUP():New(000, 000, nLin-450, nCol-560/*600*/, "Estrutura de Produto - Visualiza Anexos", oDlg, CLR_HBLUE,, .T.)
	//oGrpCo1:Align := CONTROL_ALIGN_ALLCLIENT
	oTree := DbTree():New( 000, 000, nLin, nCol, oGrpCo1,{|| AtuBotao(oTree,.T.)},,.T.,,,'Produto/Componentes;Sentido Pre;PDF;COM;FCT;MNL;RVT;DXF')
	oTree:Align := CONTROL_ALIGN_ALLCLIENT

	//oGrpCo2 := TGROUP():New(nLin-450, 000, nLin-250, nCol-600, "Dados do produto", oDlg, CLR_HBLUE,, .T.)

	cProdAux  := ""
	cFileName := ""
 
	nLinIni := 285

    oTSayPrd := TSay():New(nLinIni+045,010,{||"Produto:"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,100,010,.F.,.T.,.F.,.F.,.F.,.F. )
    oTGetPrd := TGet():New(nLinIni+040,060,{ | u | If( PCount() == 0, cProdAux, cProdAux := u ) },/*oGrpCo2*/,500,010,"@X",,0,,oTFont,.F.,,.T.,,.F.,,.F.,.F.,{|| },.F.,.F.,,'cProduto',,,, )

	nCol := 000
	If aPodeVis[nPosPDF]
		oImgPDF := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgPDFNo,.T.,oDlg/*oGrpCo2*/,bClick_PDF,bClick_PDF,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_PDF,.T.)
		oImgPDF:Disable()
	    oTSayPDF := TSay():New(nLinIni+085,nCol+010,{||"PDF:Desenhos dos Produtos"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
		nCol += 080
	EndIf
	If aPodeVis[nPosCOM]
		oImgCOM := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgCOMNo,.T.,oDlg/*oGrpCo2*/,bClick_COM,bClick_COM,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_COM,.T.)
		oImgCOM:Disable()
	    oTSayCOM := TSay():New(nLinIni+085,nCol+010,{||"COM:Desenhos de Componentes"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
		nCol += 080
	EndIf
	If aPodeVis[nPosFCT]
		oImgFCT := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgFCTNo,.T.,oDlg/*oGrpCo2*/,bClick_FCT,bClick_FCT,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_FCT,.T.)
		oImgFCT:Disable()
	    oTSayFCT := TSay():New(nLinIni+085,nCol+010,{||"FCT:Ficha Técnica"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
		nCol += 080
	EndIf
	If aPodeVis[nPosMNL]
		oImgMNL := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgMNLNo,.T.,oDlg/*oGrpCo2*/,bClick_MNL,bClick_MNL,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_MNL,.T.)
		oImgMNL:Disable()
	    oTSayMNL := TSay():New(nLinIni+085,nCol+010,{||"MNL:Manual"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
		nCol += 080
	EndIf
	If aPodeVis[nPosRVT]
		oImgRVT := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgRVTNo,.T.,oDlg/*oGrpCo2*/,bClick_RVT,bClick_RVT,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_RVT,.T.)
		oImgRVT:Disable()
	    oTSayRVT := TSay():New(nLinIni+085,nCol+010,{||"RVT:Revit/Bloco 2D/3D"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
		nCol += 080
	EndIf
	If aPodeVis[nPosDXF]
		oImgDXF := TBitmap():New(nLinIni+060,nCol+013,20,20,,cImgDXFNo,.T.,oDlg/*oGrpCo2*/,bClick_DXF,bClick_DXF,.F./*lScroll*/,.T./*lStretch*/,,,,bValid_DXF,.T.)
		oImgDXF:Disable()
    	oTSayDXF := TSay():New(nLinIni+085,nCol+010,{||"DXF:Desenho de Corte"},oDlg/*oGrpCo2*/,,oTFont,.F.,.F.,.F.,.T.,0,,50,020,.F.,.T.,.F.,.F.,.F.,.F. )
	EndIf

    MontaEstru(oDlg,oTree)

	oDlg:Activate(,,,.T.,,,{|| AtuBotao(oTree,.T.) } )

Return

Static Function AtuBotao(oTree,lRefresh)

cCargo    := oTree:GetCargo()
cPrompt   := oTree:GetPrompt()

cProdAux  := LEFT(cPrompt,AT(";",cPrompt)-1 /*TAMSX3("B1_COD")[1]+TAMSX3("B1_DESC")[1]+1*/)
cFileName := ALLTRIM(LEFT(cPrompt,AT(" ",cPrompt)-1 /*TAMSX3("B1_COD")[1]*/))

If aPodeVis[nPosPDF] 
	If ";PDF" $ cPrompt
		oImgPDF:cBmpFile := cImgPDF
		oImgPDF:Enable()
	Else
		oImgPDF:cBmpFile := cImgPDFNo
		oImgPDF:Disable()
	EndIf
EndIf
If aPodeVis[nPosCOM] 
	If ";COM" $ cPrompt
		oImgCOM:cBmpFile := cImgCOM
		oImgCOM:Enable()
	Else
		oImgCOM:cBmpFile := cImgCOMNo
		oImgCOM:Disable()
	EndIf
EndIf
If aPodeVis[nPosFCT] 
	If ";FCT" $ cPrompt
		oImgFCT:cBmpFile := cImgFCT
		oImgFCT:Enable()
	Else
		oImgFCT:cBmpFile := cImgFCTNo
		oImgFCT:Disable()
	EndIf
EndIf
If aPodeVis[nPosMNL] 
	If ";MNL" $ cPrompt
		oImgMNL:cBmpFile := cImgMNL
		oImgMNL:Enable()
	Else
		oImgMNL:cBmpFile := cImgMNLNo
		oImgMNL:Disable()
	EndIf
EndIf
If aPodeVis[nPosRVT] 
	If ";RVT" $ cPrompt 
		oImgRVT:cBmpFile := cImgRVT
		oImgRVT:Enable()
	Else
		oImgRVT:cBmpFile := cImgRVTNo
		oImgRVT:Disable()
	EndIf
EndIf
If aPodeVis[nPosDXF] 
	If ";DXF" $ cPrompt
		oImgDXF:cBmpFile := cImgDXF
		oImgDXF:Enable()
	Else
		oImgDXF:cBmpFile := cImgDXFNo
		oImgDXF:Disable()
	EndIf
EndIf

oTGetPrd:Refresh()

Return Nil

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ AbrirAnexo                                           ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD AbrirAnexo(cFileName,cFilePath) CLASS ClassAnexoProduto

	Local lRet		:= .F.
	Local lFErase   := .F.
	Local nTimes    := 0

    aFile := Directory(cFilePath+"\"+cFileName+"*.*", "F")

    If LEN(aFile) > 0 .And. File(cFilePath+"\"+aFile[1,1])
        //Copiando o arquivo do servidor para o cliente
        If CpyS2T(cFilePath+"\"+aFile[1,1],GetTempPath())
            ShellExecute("open",GetTempPath()+aFile[1,1],"","",5) // 5=SW_SHOW
            Aviso("Visualizar","Arquivo aberto no visualizador padrão.",{"Fechar"})
            
            //Apaga arquivo após visualização
			lFErase := .F.
			nTimes := 0
			While( !lFErase .And. nTimes < 10)
				lFErase := (FERASE(GetTempPath()+aFile[1,1]) <> -1)
				If(!lFErase)
					nTimes++
					Sleep(500)
				Else
					Exit
				EndIf    
			EndDo

            lRet := .T.
        EndIf
    EndIf

Return lRet


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³   METODO   ³ PodeVisualizar                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
METHOD PodeVisualizar(cPrefixo) CLASS ClassAnexoProduto
 
	Local lRet		:= .F.
	Local aArea     := GetArea()
	Local cField    := IIF(cPrefixo=="SOBREP","PA0_SOBREP",IIF(cPrefixo=="UPLOAD","PA0_UPLOAD","PA0_VIS"+cPrefixo))

	dbSelectArea("PA0")
	dbSetOrder(1)
	If dbSeek(xFilial("PA0")+RetCodUsr(cUserName))

		If FIELDPOS(cField) > 0
			lRet := (FIELDGET(FIELDPOS(cField)) == "1")
		EndIf

	EndIf

	RestArea(aArea)

Return lRet


////////////////////////////////////
// Carrega a estrutura do produto //
//////////////////////////////////./
Static Function MontaEstru(oDlg,oTree)

Local aArea  := GETAREA()
Local lRet   := .T.
Local nOpcx  := 2

		ldbTree    := .T.

		//Tratamento para visualização de itens sem estrutura #MONTES20250324
        SG1->(dbSetOrder(1))
		If !SG1->(dbSeek(xFilial('SG1') + SB1->B1_COD, .F.))
			nOpcx := 3
		EndIf

		oTree:Reset()
		MontaTree(oTree, oDlg, SB1->B1_COD,, nOpcX, /*cCargo*/, /*cTRTPai*/, /*lZeraStatic*/, /*lOpc*/ )
		oTree:TreeSeek(oTree:GetCargo())

RESTAREA(aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MontaTree ³ Autor ³ Montes              ³ Data ³04.10.2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carrega estrutura para o Tree(Func.Recurssiva)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MontaTree(ExpO1,ExpO2,ExpC1,ExpC2,ExpC3,ExpN1,ExpC4,ExpC5)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto Tree                                        ³±±
±±³          ³ ExpO2 = Objeto Dlg                                         ³±±
±±³          ³ ExpC1 = Codigo do Produto                                  ³±±
±±³          ³ ExpC2 = Codigo da estrutura similar		 (OPC)	          ³±±
±±³          ³ ExpC3 = Codigo da revisao				 (OPC)	          ³±±
±±³          ³ ExpN1 = Numero da Op‡„o Escolhida         (OPC)            ³±±
±±³          ³ ExpC4 = Cargo do Produto no Tree          (OPC)            ³±±
±±³          ³ ExpC5 = Sequencia Pai                     (OPC)            ³±±
±±³          ³ ExpL1 = Zera cont. das variaves staticas  (OPC) 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ False se o Codigo do Produto nao existir, e True em C.C.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M04M10                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaTree(oTree, oDlg, cProduto, cRevisao, nOpcX, cCargo, cTRTPai, lZeraStatic, lOpc )

Local nRecAnt    := 0
Local cComp      := ''
Local cPrompt    := ''
Local cFolderA   := 'FOLDER5'
Local cFolderB   := 'FOLDER6'
Local cRevPI 	 := ""
Local nRecCargo  := 0
Local dValIni    := CtoD('  /  /  ')
Local dValFim    := CtoD('  /  /  ')
Local lRet		 := .T.
Local lContinua	 := .T.
Local nQtdeSG1   := 0
Local lExpand    := .T. 
Local lExibeOPC  := .T.
Local nIndSG1	 := 1
Local lRevAut    := SuperGetMv("MV_REVAUT",.F.,.F.)
Local lOpcional  := .F.
Local lOpcAux    := .T.
Local cOpc       := ""
Local aOpc       := {}
Local nIndex     := 1

Static nNivelTr  := 0
Static cFistCargo:= NIL

Default lOpc := .T.
Default lAutomacao := .F.

// -- Atualiza nivel da estrutura
nNivelTr += 1

nOpcX := If(nOpcX==Nil,0,nOpcX)

lExpEst := .T.

If !ldbTree .And. nOpcX < 5
	oDlg:SetFocus()
	lRet := .F.
EndIf

If lRet
	lExpEst := .T.

	//-- Posiciona no SB1
	cPrompt := cProduto //+ Space(400)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1') + cProduto, .F.))
		cPrompt := AllTrim(cProduto) + " - " + SB1->B1_DESC + Space(Len(SB1->B1_COD) - Len(AllTrim(cProduto)))			
	EndIf
	//cPrompt += Space(Len("QTDE:")+TamSX3("G1_QUANT")[1]) 
	//cPrompt += Space(200)

	SG1->(dbSetOrder(nIndSG1))
	If nOpcX == 3 .And. cProduto # Replicate('ú', Len(SG1->G1_COD)) 

		//-- Cria‡„o de uma nova estrutura
		oTree:AddTree(AddPromp(cPrompt,"",,cProduto),.T.,cFolderA,cFolderB,,,cProduto+Space(TamSx3("G1_TRT")[1])+cProduto+'000000000'+'000000000'+'NOVO')
		oTree:EndTree()
		oTree:Refresh()
		oTree:SetFocus()
		lContinua := .F.

	ElseIf !SG1->(dbSeek(xFilial('SG1') + cProduto, .F.))
		If !lAutomacao
			If ldbTree
				oTree:Refresh()
				oTree:SetFocus()
			Else
				oDlg:SetFocus()
			EndIf
		EndIf
		lRet := .F.
	EndIf

	If lRet .And. lContinua
		cTRTPai := If(cTRTPai==Nil,SG1->G1_TRT,cTRTPai)

		dValIni := SG1->G1_INI
		dValFim := SG1->G1_FIM
		If cCargo == Nil
			cCargo := SG1->G1_COD + cTRTPai + SG1->G1_COMP + StrZero(SG1->(Recno()), 9) + StrZero(nIndex ++, 9) + 'CODI'
		ElseIf (nRecCargo := Val(SubStr(cCargo,Len(SG1->G1_COD + SG1->G1_TRT + SG1->G1_COMP) + 1, 9))) > 0
			nRecAnt := SG1->(Recno())
			SG1->(dbGoto(nRecCargo))
			dValIni := SG1->G1_INI
			dValFim := SG1->G1_FIM
			nQtdeSG1 := SG1->G1_QUANT
			If GetMV("MV_SELEOPC") == "S" .And. lOpc
           		cOpc := Padr(SG1->G1_GROPC, TamSX3("G1_GROPC")[1]) + Padr(SG1->G1_OPC, TamSX3("G1_OPC")[1]) + "/"
           		aOpc := aClone(ListOpc(Nil,Nil,cOpc))
        	EndIf
			SG1->(dbGoto(nRecAnt))
		EndIf

		//-- Define as Pastas a serem usadas
		cFolderA := 'FOLDER5'
		cFolderB := 'FOLDER6'
		If Right(cCargo, 4) == 'COMP' .And. ;
			(dDataBase < dValIni .Or. dDataBase > dValFim)
			cFolderA := 'FOLDER7'
			cFolderB := 'FOLDER8'
		EndIf

		//-- Adiciona o Pai na Estrutura
		If !lAutomacao
			oTree:AddTree(AddPromp(cPrompt,cCargo,nQtdeSG1,cProduto,aOpc),.T.,cFolderA,cFolderB,,,cCargo)
		EndIf

		Do While !SG1->(Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

			lExpEst := .T.

			//-- Nao Adiciona Componentes fora da Revis„o
			If (nOpcX == 2 .Or. nOpcX == 4) .And. (cRevisao # Nil) .And. ;
				!(SG1->G1_REVINI <= cRevisao .And. (SG1->G1_REVFIM >= cRevisao .Or. SG1->G1_REVFIM = ' '))
				SG1->(dbSkip())
				Loop
			EndIf

			nRecAnt  := SG1->(Recno())
			cComp    := SG1->G1_COMP
			cCargo   := SG1->G1_COD + SG1->G1_TRT + cComp + StrZero(SG1->(Recno()), 9) + StrZero(nIndex ++, 9) + 'COMP'
			nQtdeSG1 := SG1->G1_QUANT

			If Empty(SG1->G1_GROPC)
				lOpcAux := .F.
			Else
				lOpcAux := .T.
			EndIf

			If cFistCargo == NIL
				cFistCargo := cCargo
			EndIf

			//-- Define as Pastas a serem usadas
			cFolderA := 'FOLDER5'
			cFolderB := 'FOLDER6'
			If dDataBase < SG1->G1_INI .Or. dDataBase > SG1->G1_FIM
				cFolderA := 'FOLDER7'
				cFolderB := 'FOLDER8'
			EndIf

			//-- Posiciona no SB1
			cPrompt := cComp //+ Space(400)
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial('SB1') + cComp, .F.))
				cPrompt := AllTrim(cComp) + " - " + SB1->B1_DESC + Space(Len(SB1->B1_COD) - Len(AllTrim(cComp)))
			EndIf
			//cPrompt += Space(Len("QTDE:")+TamSX3("G1_QUANT")[1]) 
			//cPrompt += Space(200)
			lExpEst := .T.

   			If SG1->(dbSeek(xFilial('SG1') + SG1->G1_COMP, .F.)) .and. lExpEst

				cRevPi := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU)  //PCPREVATU(SB1->B1_COD)
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
					MontaTree(oTree, oDlg, SG1->G1_COD,cRevPi,IIF(lRevaut,2,If(nOpcX==3,0,nOpcX)), cCargo, cTRTPai,,lOpcional )
				Else
					oTree:AddItem(AddPromp(cPrompt, cCargo, nQtdeSG1,cComp,aOpc), cCargo, cFolderA, cFolderB,,, 2)
				EndIf
			Else
				DBADDITEM oTree PROMPT AddPromp(cPrompt, cCargo ,nQtdeSG1,cComp,aOpc) RESOURCE cFolderA CARGO cCargo
			EndIf

			SG1->(dbGoto(nRecAnt))
			SG1->(dbSkip())
		EndDo
		If !lAutomacao
			oTree:EndTree()

			If ldbTree
				// --- Atualiza obj.dbtree apos processar a estrutura
				If nNivelTr == 1
					If( cFistCargo <> NIL )
						cCargo := cFistCargo
						cFirstCargo := NIL
					EndIf
					oTree:TreeSeek(cCargo)
					oTree:Refresh()
					oTree:SetFocus()
				EndIf
			Else
				oDlg:SetFocus()
			EndIf
		EndIf
	EndIf
EndIf
If lContinua
	// --- Atualiza nivel da estrutura
	nNivelTr -= 1
EndIf

//Zera conteudo das variaveis static, necessario para montagem do tree na rotina MATC015.
If ValType(lZeraStatic)=="L" .And. lZeraStatic
	nNivelTr  := 0
	cFistCargo:= NIL
EndIf
Return lRet

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AddPromp      ³ Autor ³ MONTES             ³ Data ³ 04/10/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acrescenta TRT ao prompt do dbtree baseado no conteudo       ³±±
±±³          ³ da propriedade cargo                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC3 := AddPromp(ExpC1,ExpC2,ExpN1)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = codigo do prompt                                     ³±±
±±³          ³ ExpC2 = chave do registro                                    ³±±
±±³          ³ ExpN1 = quantidade do componente                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC3 = prompt + TRT + Quant (codigo + sequencia + qtde.)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ M04M10                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AddPromp(cPrompt, cCargo, nQtdeSG1,cProdAtu,aOpc)
Local cTRT       := Space(Len(SG1->G1_TRT)+3)
Local aTamQtde   := TamSX3("G1_QUANT")
Local cQuant     := ""
Local cRet       := ""
Local nTamCod    := TamSX3("G1_COD")[1]
Local nTamTRT    := TamSX3("G1_TRT")[1]
Local cOpc       := ""
Local cAnexos    := ""
Default cProdAtu := ""
Default nQtdeSG1 := 0
Default aOpc     := { }

If ! (cCargo == Nil .Or. Empty(cCargo) .Or. Right(cCargo, 4) $ "CODI,NOVO")
	If ! Empty(cTRT := SubStr(cCargo, nTamCod+1, nTamTRT))
		cTRT := " - " + cTRT
	Endif
	cQuant   := " / "+"QTDE:"+Str(nQtdeSG1,aTamQtde[1],aTamQtde[2])
	//If lM200TEXT
	//	cProdAtu := AllTrim(SubStr(cCargo, nTamCod+1+nTamTRT, nTamCod))
	//EndIf
Endif

//If lM200TEXT .And. Empty(cProdAtu) .And. !(Empty(cCargo)) .And. Right(cCargo, 4) $ "CODI,NOVO"
//	cProdAtu := AllTrim(SubStr(cCargo, 1, nTamCod))
//EndIf

//If GetMV("MV_SELEOPC") == "S" .And. Len(aOpc) > 0
   //cOpc := " / " + STR0077 + AllTrim(aOpc[1][3]) + " - " + AllTrim(aOpc[1][4]) + " / " + STR0078 + AllTrim(aOpc[1][5]) + " - " + AllTrim(aOpc[1][6])
//EndIf

cAnexos := TemAnexo(cProdAtu)

if lExpEst
	cRet := (Pad(AllTrim(cPrompt) + cTRT + cQuant + cOpc + cAnexos, Len(cPrompt+cTRT+cQuant+cOpc+cAnexos)))
else
	cRet := (Pad(AllTrim(cPrompt) + cTRT + cQuant + cOpc + '  *' + cAnexos, Len(cPrompt+cTRT+cQuant+cOpc+cAnexos)))
endif

Return cRet

Static Function TemAnexo(cProduto)

Local cDirServer := "\produtos_anexos\"
Local cRet    	 := ""
Local aSufixo 	 := { "PDF", "COM", "FCT", "MNL", "RVT", "DXF" }
Local nX      	 := 0
Local cXSPRE     := ""

If !EMPTY(cXSPRE := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XSPRE"))
	cRet := ";"+X3Combo("B1_XSPRE",cXSPRE)
Else
	cRet := ";"
EndIf

For nX := 1 To Len(aSufixo)
	If LEN(Directory(cDirServer+RTRIM(cProduto)+aSufixo[nX]+"*.*", "F")) > 0
		cRet += ";"+aSufixo[nX]
	Else
		cRet += ";"+SPACE(4)
	EndIf
Next

Return cRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EXPExcel  ³ Autor ³ Montes               ³ Data ³ 11.10.24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para exportatacao de dados para Excel               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias                                              ³±±
±±³          ³ ExpA2 : Array com as Descricoes do Cabecalho               ³±±
±±³          ³ ExpA3 : Array com os parametros (perguntes) da rotina      ³±±
±±³          ³ ExpN4 : Opcao executada                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M04M10                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExpExcel(aHeader,aCols)

	Local aCabXcel      := {}
	Local aItenXcel     := {}	
	Local aArea			:= GetArea()
	Local nX			:= 0
	Local nC			:= 0
	Local cTexto		:= ""

	If Len(aCols) > 0

		If .F. //! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado')
		Else

			For nC := 1 To Len(aHeader)
				AADD(aCabXcel,{aHeader[nC][2],aHeader[nC][8],aHeader[nC][4],aHeader[nC][5]})
			Next
			AADD(aCabXcel,{"","C",1,0})

			For nX := 1 to Len(aCols)
				aLinha := {}
				For nC := 1 To Len(aHeader)
					AADD(aLinha,aCols[nX][nC])
				Next
				AADD(aLinha,"")
				AADD(aItenXcel,aLinha)
			Next nX

			cTexto := OemToAnsi("Resumo de Importação")

			MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS",cTexto,aCabXcel,aItenXcel}})})
		EndIf

	Endif

	RestArea(aArea)

Return
