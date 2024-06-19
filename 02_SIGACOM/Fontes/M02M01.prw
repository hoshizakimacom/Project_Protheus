#INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M06M01   ³ Autor ³ Marcos Rocha '  	    ³ Data ³ 16/10/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email de Pedido de Compra                            ³±±
±±³          ³ Especifico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M02M01()

Processa({|| U_M02M01E() },"Enviando email de Pedido de Compra...")

RETURN

User Function M02M01E()

Local cMailEnv   := ""
Local cAnexo     := ""
Local aArea      := GetArea()
Local aAreaSC7   := SC7->(GetArea())
Local cEmailFor  := ""
Local lEnvFor    := .F.

ProcRegua(2)

IncProc("Enviando...")

If File("samples/wf/M02M01_Mail001.html")

    U_M02R02(.T.)   // Impressao do Pedido de Compra

    cBody := U_M02M01Ger(SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA)

	dbSelectArea("SA2")
	dbSetOrder(1)
	If (SA2->(DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)))
		cEmailFor := AllTrim(SA2->A2_EMAIL)
	EndIf

	If Empty(cEmailFor)
		MsgStop("Email do Fornecedor não preenchido !")
	EndIf

    If MsgYesNo('Envia Email para Fornecedor ?',"Atenção")
  		cMailEnv := cEmailFor
		lEnvFor  := .T.
    EndIf

	cMailEnv := cMailEnv+If(!Empty(cMailEnv),";","")+AllTrim(GetMv("AM_EMAILCO"))

	MsgStop("Emails Envio "+cMailEnv)
    cAnexo   := 'PC' + SC7->C7_NUM + '_'+DToS(Date())+".pdf"
    cDirPDF    := "\SPOOL\"

    cAnexo   := AllTrim(cDirPDF)+cAnexo
	//If File(cAnexo)
	//	MsgStop("Arquivo Localizado ")
	//Else
	//	MsgStop("Arquivo Não Localizado ")
	//Endif 

    If U_MTSendMail({cMailEnv},OemToAnsi("Pedido de Compra"),cBody,cAnexo)

		cPedCompra := SC7->C7_NUM		

		If 	lEnvFor
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+cPedCompra)
			While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
				RecLock("SC7",.F.)
				SC7->C7_XENVFOR := dDataBase
				MsUnLock()
				dbSkip()
			EndDo
		EndIf

	EndIf
EndIf

IncProc("Enviando e-mail...")

RestArea(aAreaSC7)
RestArea(aArea)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} A131GerMail()
Gera corpo do e-mail de pedido
/*/
//-------------------------------------------------------------------
User Function M02M01Ger(cNumPed, cDtEmiPed, cFornece, cLojafor)

Local cRet	     := ""

Local cHTMLSrc 	 := "samples/wf/M02M01_Mail001.html"
Local cHTMLDst	 := "samples/wf/M02M01_Mail001.htm" //Destino deve ser .htm pois o metodo :SaveFile salva somente neste formato.
Local oHTMLBody  := TWFHTML():New(cHTMLSrc)

oHTMLBody:ValByName('cNumPed',cNumPed)

oHTMLBody:SaveFile(cHTMLDst)
cRet:= MtHTML2Str(cHTMLDst)
FErase(cHTMLDst)

Return cRet

//-------------------------------------------------------------------
/*/
Copia da Funcao de envio de email - Incluido parametro de anexo.
/*/
//-------------------------------------------------------------------
User Function MTSendMail(aMailPara,cMailAssun,cMailTexto,cAnexo)

// - Variaveis para conexão ao servidor de e-mail.
Local cMailServer	:= AllTrim(SuperGetMv("MV_RELSERV"))
Local cMailConta 	:= AllTrim(SuperGetMv("MV_RELACNT"))
Local cMailSenha 	:= AllTrim(SuperGetMv("MV_RELPSW"))
Local lAuth		:= SuperGetMv("MV_RELAUTH",,.F.)

//PARA ATENTICAR NO SERVIDOR DE EMAIL
Local cUsrAutent  	:= SuperGetMv("MV_RELAUSR")
Local cPswAutent  	:= SuperGetMv("MV_RELAPSW")

// - Variaveis para log de Erros relacionados ao envio.
Local lMsgError	:= SuperGetMv("MV_QMSGERM", .T., .T.)
Local cError		:= ""

// - Variaveis para controle de fluxo.
Local nI := 0
Local lRet	:= .T.
Local cEnvia := ""

If Len(aMailPara) == 0
	lRet := .F.
EndIf

If lRet .And. !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	//- Realiza validações para envio de e-mail
	For nI := 1 To Len(aMailPara)
    	If !Empty(aMailPara[nI])
    		cEnvia += aMailPara[nI]+"; "
    	EndIf
    Next
    cEnvia := SubStr(cEnvia,1,Len(cEnvia)-2)

    //- Conexão com o servidor SMTP
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lRet

	If lRet .And. lAuth
	//- Autenticacao da conta de e-mail
		lRet := MailAuth(cUsrAutent,cPswAutent)
		If !lRet
			If lMsgError
				GET MAIL ERROR cError
				MsgInfo(cError,OemToAnsi("Erro de Autenticação do usuario no servidor de E-Mail")) // "Erro de Autenticação do usuario no servidor de E-Mail"
			Endif
			lRet := .F.
		Endif
	Else
		If !lRet
			If lMsgError
				GET MAIL ERROR cError
				MsgInfo(cError,OemToAnsi("Erro de Conexão com servidor de E-Mail"))	//"Erro de Conexão com servidor de E-Mail"
			Endif
			lRet := .F.
		Endif
	EndIf

	If lRet
	//- Processa envio de e-mail
		SEND MAIL FROM cMailConta TO cEnvia SUBJECT cMailAssun BODY cMailTexto ATTACHMENT cAnexo RESULT lRet
		//SEND MAIL FROM cMailConta TO cEnvia SUBJECT cMailAssun BODY cMailTexto RESULT lRet
		If !lRet
			If lMsgError
				GET MAIL ERROR cError
				MsgInfo(cError,OemToAnsi("Erro ao enviar E-Mail"))	//"Erro ao enviar E-Mail"
			Endif
		EndIf
	EndIf
	DISCONNECT SMTP SERVER
Else
	MsgInfo(OemToAnsi("Envio OK"))
EndIf

Return lRet
