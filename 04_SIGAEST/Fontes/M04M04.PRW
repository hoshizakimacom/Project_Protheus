#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
#INCLUDE "Rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M04M04  � Autor � Marcos Eduardo Rocha � Data � 30/03/2023 ���
�������������������������������������������������������������������������͹��
���Desc.     � Importa Invent�rio                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Macom                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M04M04

Private cCadastro := OemToAnsi("Importa��o de Inventario")
Private aRotina	:= MenuDef()

mBrowse(06,01,22,75,"SB7")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M04A041  � Autor � Marcos Eduardo Rocha  � Data �24/04/2023���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M041(cAlias,nReg,nOpcx)

Private nHdl	:= 0
Private aStruct := {}
Private aLog	:= {}

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
cType    := "Arquivos nao Processados | *.CSV | Arquivos ja Processados | *.PRC "

//���������������������������������������������������������������������Ŀ
//� Seleciona o arquivo                                                 �
//�����������������������������������������������������������������������
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo de interface"),1,"",.F.,GETF_LOCALHARD + GETF_NETWORKDRIVE)

//���������������������������������������������������������������������Ŀ
//� Valida se o arquivo existe                                          �
//�����������������������������������������������������������������������
If !File(cArq)
	Aviso("Aten��o !","Arquivo selecionado nao Localizado !",{"Ok"})
	Return
EndIf

Processa({|| U_M04M042(cArq) },"Processando Leitura...")

Processa({|| U_M04M043() },"Processando Grava��o...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M04M042  � Autor � Marcos Eduardo Rocha  � Data �24/04/2023���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M042(cArq)

Local lContinua := .T.
Local nProc
Local cCodProd   := ""
Local cCodEnd    := ""
Local nQtdInv    := 0
Local cContagem  := ""
Local cLocal     := ""
Local cDocumento := ""
Local cDataInv   := Ctod("  /  /  ")

//���������������������������������������������������������������������Ŀ
//� Abre o arquivo texto                                                �
//�����������������������������������������������������������������������
nHdl := FT_FUSE(cArq)

//���������������������������������������������������������������������Ŀ
//� Valida se conseguiu abrir o arquivo texto                           �
//�����������������������������������������������������������������������
If nHdl <> Nil .and. nHdl <= 0
	
	Aviso("Aten��o !","N�o foi poss�vel a abertura do arquivo "+Alltrim(cArq)+" !",{"Ok"})
	
	//���������������������������������������������������������������������Ŀ
	//� Fecha o arquivo texto                                               �
	//�����������������������������������������������������������������������
	FT_FUSE()
	
	Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Executa a leitura sequencial do arquivo                             �
//�����������������������������������������������������������������������
ProcRegua(FT_FLASTREC())

FT_FGOTOP()
lPrimLinha := .T.

While !FT_FEOF()
	
	IncProc("Analisando arquivo...")
	
	//���������������������������������������������������������������������Ŀ
	//� Armazena na variavel cBuffer a linha do arquivo texto               �
	//�����������������������������������������������������������������������
	cBuffer := Alltrim(FT_FREADLN())
	cBuffer := Upper(cBuffer)
	
	//���������������������������������������������������������������������Ŀ
	//� Alimenta variaveis de controle                                      �
	//�����������������������������������������������������������������������
	cBuffer := StrTran(cBuffer,'"','')
	
	aCampos := {}
	For nProc := 1 To 8

		nPos := At(";",cBuffer)

		// Quando a primeira coluna n�o for uma letra
		If lPrimLinha .And. nProc == 1 .And. !Left(Alltrim(Left(cBuffer,nPos-1)),1)$"ABCDEFGHI" 
			MsgStop(OemToAnsi("Diverg�ncia de LayOut na primeira coluna ! Favor Verificar ! "))
			lContinua := .F.
			Exit
		EndIf

		// Quando a primeira coluna n�o for uma letra
		If nPos == 0 .And. nProc <> 8
			MsgStop(nProc)
			MsgStop(OemToAnsi("Erro na importa��o do arquivo ! Diverg�ncia de quantidade de colunas !"))
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
	
	//�����������������������������Ŀ
	//� Busca e Valida produto PAI. �
	//�������������������������������
	//cFilSB7    := AllTrim(aCampos[01])
	cCodProd   := AllTrim(aCampos[02])
	cCodEnd    := AllTrim(aCampos[03])
	nQtdInv    := Val(StrTran(aCampos[04],",","."))
	cContagem  := AllTrim(aCampos[05])
	cLocal     := AllTrim(aCampos[06])
	cDocumento := AllTrim(aCampos[07])
	cDataInv   := Ctod(AllTrim(aCampos[08]))
	
	//����������������������������Ŀ
	//� Busca e Valida produto MP. �
	//������������������������������
	dbSelectArea("SB1")
	dbSetOrder(1)
	If Empty(cCodProd) .And.  !lPrimLinha
		MsgStop(OemToAnsi("C�digo de Produto em Branco ! C�digo : ")+cCodProd)
		Aadd(aLog,"C�digo de Produto em Branco. C�digo : "+cCodProd)
		FT_FSKIP()
		Loop

	ElseIf !lPrimLinha .And. !dbSeek(xFilial("SB1")+cCodProd)
		MsgStop(OemToAnsi("C�digo de Produto n�o encontrado, solicitar inclus�o ao Depto de Cadastro.. C�digo : ")+cCodProd)
		Aadd(aLog,"Codigo da Produto n�o encontrado .. C�digo : "+cCodProd)
		FT_FSKIP()
		Loop

	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Alimenta a Matri	z com a Estrutura.                                  �
	//�����������������������������������������������������������������������
	If !lPrimLinha

		cDocumento := Left(cDocumento+Space(9),Len(SB7->B7_DOC))

		dbSelectArea("SB7")
		dbSetOrder(4)
		If dbSeek(xFilial("SB7")+cDocumento+Dtos(cDataInv))
			MsgStop(OemToAnsi("Documento : "+cDocumento+" j� importado na data : "+Dtoc(cDataInv)))
			Aadd(aLog,"Documento : "+cDocumento+" j� importado na data : "+Dtoc(cDataInv))
			FT_FSKIP()
			Loop
		EndIf	

		Aadd(aStruct,{cCodProd, cCodEnd, nQtdInv, cContagem, cLocal, cDocumento, cDataInv})
	EndIf
	lPrimLinha := .F.

	//���������������������������������������������������������������������Ŀ
	//� Posiciona na proxima linha                                          �
	//�����������������������������������������������������������������������
	FT_FSKIP()
EndDo

//���������������������������������������������������������������������Ŀ
//� Fecha o arquivo texto                                               �
//�����������������������������������������������������������������������
FT_FUSE()

If !lContinua
	Return
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � M04M043  � Autor � Marcos Eduardo Rocha  � Data �24/04/2023���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M043()

Local cProduto
Local nProc

dbSelectArea("SB7")
dbSetOrder(1)

ProcRegua(Len(aStruct))

//�������������������������������������������������������������������������Ŀ
//� Verificacao de Estrutura ja existente para cada SubEstruturas           �
//���������������������������������������������������������������������������
For nProc := 1 To Len(aStruct)
	
	IncProc("Gravando Inventario...")
	
	cProduto    := Left(aStruct[nProc,1]+Space(15),15)
//	lCria       := .T.

//	If lCria
		RecLock("SB7",.T.)
		SB7->B7_FILIAL  := xFilial("SB7")
		SB7->B7_COD     := cProduto
		SB7->B7_XENDERE := aStruct[nProc,2]
		SB7->B7_QUANT   := aStruct[nProc,3]
		SB7->B7_CONTAGE := aStruct[nProc,4]
		SB7->B7_LOCAL   := aStruct[nProc,5]
		SB7->B7_DOC     := aStruct[nProc,6]
		SB7->B7_DATA    := aStruct[nProc,7]
		SB7->B7_TIPO    := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TIPO")
		SB7->B7_ORIGEM  := "M04M04"
		SB7->B7_XCODUSR := SubStr(cUsuario,7,15)
//		    SB7->B7_DTVALID :=
//			SB7->B7_LOCALIZ := 
		MsUnLock()
//	EndIf

Next

//���������������������������������������������������������������������Ŀ
//� Grava o arquivo de log                                              �
//�����������������������������������������������������������������������
If Len(aLog) > 0
	MsgStop(OemToAnsi("Aten��o ! Relat�rio de inconsist�ncias na importa��o !"))
	U_M04M04IMP()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RESTA05IMP� Autor � Marcos Eduardo Rocha  � Data �11/06/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M04IMP()

//+--------------------------------------------------------------+
//� Define Variaveis Ambientais                                  �
//+--------------------------------------------------------------+
Local nProc

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
tamanho   := "P"
limite    := 80
titulo    := PADC("Importacao Estrutura",74)
cDesc1    := PADC("Este programa ira emitir o Log de importacao de Invent�rio",74)
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2,1,"",1 }
nomeprog  := "M04M04"
cPerg     := "M04M04"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "M04M04"
aOrd      := {}
nTam := 66     // Apenas Informativo

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT                        �
//+--------------------------------------------------------------+
cString := ""
wnrel   := SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
EndIf

//+--------------------------------------------------------------+
//� Verifica Posicao do Formulario na Impressora                 �
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marcos	            � Data �17/05/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina   := { { "Pesquisar"  ,   "AxPesqui"     , 0, 1 },;
{ "Visualizar"      , "AxVisual"     , 0, 2 },;
{ "Importar"        , 'U_M04M041'   , 0, 3 }}

Return(aRotina)
