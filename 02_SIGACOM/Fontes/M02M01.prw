#INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M06M01   � Autor � Marcos Rocha '  	    � Data � 16/10/23 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envia email de Pedido de Compra                            ���
���          � Especifico Macom                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		MsgStop("Email do Fornecedor n�o preenchido !")
	EndIf

    If MsgYesNo('Envia Email para Fornecedor ?',"Aten��o")
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
	//	MsgStop("Arquivo N�o Localizado ")
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

// - Variaveis para conex�o ao servidor de e-mail.
Local cMailServer	:= AllTrim(SuperGetMv("MV_RELSERV"))
Local cMailConta 	:= AllTrim(SuperGetMv("MV_RELACNT"))
Local cMailSenha 	:= AllTrim(SuperGetMv("MV_RELPSW"))
Local lAuth		:= SuperGetMv("MV_RELAUTH",,.F.)
Local nSMTPPort 	:= GetNewPar("MV_PORSMTP",25)	// PORTA SMTP
	Local lAutentica	:= GetNewPar("MV_RELAUTH",.F.)	// VERIFICAR A NECESSIDADE DE AUTENTICACAO
	Local nSMTPTime 	:= GetNewPar("MV_RELTIME",60)	// TIMEOUT PARA A CONEXAO       
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
	//- Realiza valida��es para envio de e-mail
	For nI := 1 To Len(aMailPara)
    	If !Empty(aMailPara[nI])
    		cEnvia += aMailPara[nI]+"; "
    	EndIf
    Next
    cEnvia := SubStr(cEnvia,1,Len(cEnvia)-2)

    //- Conex�o com o servidor SMTP
//	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lRet
//
//	If lRet .And. lAuth
//	//- Autenticacao da conta de e-mail
//		lRet := MailAuth(cUsrAutent,cPswAutent)
//		If !lRet
//			If lMsgError
//				GET MAIL ERROR cError
//				MsgInfo(cError,OemToAnsi("Erro de Autentica��o do usuario no servidor de E-Mail")) // "Erro de Autentica��o do usuario no servidor de E-Mail"
//			Endif
//			lRet := .F.
//		Endif
//	Else
//		If !lRet
//			If lMsgError
//				GET MAIL ERROR cError
//				MsgInfo(cError,OemToAnsi("Erro de Conex�o com servidor de E-Mail"))	//"Erro de Conex�o com servidor de E-Mail"
//			Endif
//			lRet := .F.
//		Endif
//	EndIf
//
//	If lRet
//	//- Processa envio de e-mail
//		SEND MAIL FROM cMailConta TO cEnvia SUBJECT cMailAssun BODY cMailTexto ATTACHMENT cAnexo RESULT lRet
//		//SEND MAIL FROM cMailConta TO cEnvia SUBJECT cMailAssun BODY cMailTexto RESULT lRet
//		If !lRet
//			If lMsgError
//				GET MAIL ERROR cError
//				MsgInfo(cError,OemToAnsi("Erro ao enviar E-Mail"))	//"Erro ao enviar E-Mail"
//			Endif
//		EndIf
//	EndIf
//	DISCONNECT SMTP SERVER



//Objeto de Email
	oServer := tMailManager():New()




	nErr := oServer:init("",cMailServer,ACCOUNT,PASSWORD,,cMailSenha)
	If nErr <> 0	
		alert("Falha ao conectar:" + oServer:getErrorString(nErr)) // Falha ao conectar: 	
		Return(.F.)
	Endif


	If oServer:SetSMTPTimeout(nSMTPTime) != 0
		alert("Falha ao definir timeout") // Falha ao definir timeout
		Return(.F.)
	EndIf


	nErr := oServer:smtpConnect()
	If nErr <> 0	
		alert("Falha ao conectar:" + oServer:getErrorString(nErr)) // Falha ao conectar:		
		oServer:SMTPDisconnect()
		Return(.F.)
	EndIf



	// Realiza autenticacao no servidor
	If lAutentica
		nErr := oServer:smtpAuth(cMailTexto,cPswAutent)
		If nErr <> 0		
			alert("Falha ao autenticar: " + oServer:getErrorString(nErr)) // Falha ao autenticar: 
			oServer:SMTPDisconnect() 
		EndIf
	EndIf	


	// Cria uma nova mensagem (TMailMessage)
	oMessage := tMailMessage():new()
	oMessage:clear()        


	// Dados da mensagem		
	oMessage:cFrom		:= cMailConta  
	oMessage:cTo     	:=  cEnvia 
	oMessage:cSubject	:= cMailAssun
	oMessage:cBody   	:= cMailTexto



	nErr := oMessage:send(oServer)
	If nErr <> 0		
		alert("Falha ao Enviar MSg: " + oServer:getErrorString(nErr)) // Falha ao autenticar: 
		oServer:SMTPDisconnect() 
	EndIf

	// Desconecta do Servidor
	oServer:smtpDisconnect() 







Else
	MsgInfo(OemToAnsi("Envio OK"))
EndIf

Return lRet
