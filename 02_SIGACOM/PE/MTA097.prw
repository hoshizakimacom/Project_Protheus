#include 'TOPCONN.CH'
#include "rwmake.ch"
#include "ap5mail.ch"
/*/
�����������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������Ŀ��
���Programa  �MTA097    � Autor � Graziella Souza                 � Data � 06/10/2022 ���
�������������������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para verificar o n�vel de aprova��o e 
���            se for a ultima aprova��o disparar email para comprador                ���
�������������������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                               ���
�������������������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                     ���
�������������������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS/FNC         �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������������������Ĵ��
���                                                                                   ���
��������������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������*/
User Function MT097APR()
Local lRet    := .T.
Local cNumPed := SCR->CR_NUM
Local cComUsr := SC7->C7_USER
Local cQuery  := ""
Local nTotReg, nEtapa := 0
Local _aAreaTu:= GetArea()

	cQuery  := "SELECT CR_TIPO,CR_NIVEL, CR_STATUS "
	cQuery  += "FROM " + RETSQLNAME("SCR") + " "
	cQuery  += "WHERE CR_NUM = '" + Alltrim(cNumPed) + "' "
	cQuery  += "AND D_E_L_E_T_ = ''

	TCQUERY cQuery NEW ALIAS "TrbSCR"

	nTotReg := Contar("TrbSCR","!Eof()")

	DbSelectArea("TrbSCR")
	("TrbSCR")->(DbGoTop())
	If nTotReg <> 0

		While ("TrbSCR")->(!eof())

			if ("TrbSCR")->CR_STATUS $ '0305'
				nEtapa  ++
			Endif

			("TrbSCR")->(DbSkip())

		Enddo

		If nTotReg = nEtapa .And. nTotReg <> 0
			//Rotina que envia o email
			u_ENVMAIL(Alltrim(cNumPed),Alltrim(cComUsr))
			lRet    := .T.
		Endif
	Endif
	("TrbSCR")->(DBCLOSEAREA())
	//Validacao do usuario para interromper a liberacao ....

RestArea(_aAreaTu)

Return(  lRet ) 


/*
***********************************************
* Progrma: EnvMail      Autor: Eduardo Pessoa *
* Descri��o: Rotina para envio de emails.     *
* Data: 06/12/2007                            *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 

User Function ENVMAIL(cNumPed,cComUsr)

Local _nAux
Local _pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc

// Variaveis da fun��o
//**************************************************************
Private _nTentativas := 0
Private _cSMTPServer := GetMV("MV_WFSMTP")
Private _cAccount    := GetMV("MV_WFMAIL")
Private _cPassword   := GetMV("MV_WFPASSW")
Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))



// Valida��o dos campos do email
//**************************************************************
If _pcBcc == NIL
	_pcBcc := ""
EndIf

_pcBcc := StrTran(_pcBcc," ","")

If _pcOrigem == NIL
	_pcOrigem := "protheus@acosmacom.com.br"
EndIf

_pcOrigem := StrTran(_pcOrigem," ","")

If _pcDestino == NIL
	_pcDestino := UsrRetMail(cComUsr)
EndIf

_pcDestino := StrTran(_pcDestino," ","")

If _pcSubject == NIL
	_pcSubject := "Pedidos Aprovados"
EndIf

If _pcBody == NIL
	//_pcBody := "O pedido de n�mero " + Alltrim(cNumPed) + " acaba de ser aprovado, voc� j� pode dar in�cio ao processo de compras."
	_pcBody := ""
	_pcBody += "O pedido de n�mero " + Alltrim(cNumPed) + " acaba de ser aprovado, " 
	_pcBody += "possibilitando assim o in�cio do processo de compras."+ Chr(13) + Chr(10) + " "
	_pcBody += "Att.," + Chr(13) + Chr(10) + " "
	_pcBody += "Adm Protheus"
EndIf

If _pcArquivo == NIL
	_pcArquivo := ""
EndIf

For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
Next

If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf

// Executa a fun��o, mostrando a tela de envio (.T.) ou n�o (.F.)
//**************************************************************
EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)


If !_plAutomatico
	If !_lEnviado
		MsgStop("Aten��o: Erro no envio de EMail!!!")
	EndIf
Else
	ConOut("Aten��o: Erro no envio de Email!")
Endif

Return _lEnviado


/*
***********************************************
* Progrma: EnviaEmail   Autor: Eduardo Pessoa *
* Descri��o: Subrotina para envio de email.   *
* Data: 06/12/2007                            *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
Static Function EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Veriaveis da fun��o
//**************************************************************
Local _nTentMax := 50  // Tentativas m�ximas
Local _nSecMax  := 30  // Segundos m�ximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nTentativas:=0

Local _cMailS   := GetMv("MV_RELSERV")
Local _cAccount := GetMV("MV_RELACNT") //IIf(_cConta=Nil,GetMV("MV_RELACNT"),_cConta)
Local _cPass    := GetMV("MV_RELFROM") //IIf(_cSenha=Nil,GetMV("MV_RELFROM"),_cSenha)
Local _cSenha2  := GetMV("MV_RELPSW")
Local _cUsuario2:= GetMV("MV_RELACNT")
Local lAuth     := GetMv("MV_RELAUTH",,.F.)

// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax

If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf

// Exibe mensagem no console/Log
//**************************************************************
ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	ConOut("ENVMAIL=> ***** Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
	
	//CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	Connect Smtp Server _cMailS Account _cAccount Password _cPass RESULT _lEnviado

	If lAuth // Autenticacao da conta de e-mail

		_lEnviado := MailAuth(_cUsuario2, _cSenha2)
	
		If !_lEnviado
			ConOut("Nao foi possivel autenticar a conta - " + _cUsuario2)
			Return()
		EndIf

	EndIf

	If _lEnviado 
		If Empty(_pcBcc)
			Send Mail From _cAccount To _pcDestino CC _pcBcc Subject _pcSubject Body _pcBody RESULT _lEnviado//FORMAT TEXT
		Else
			//SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Send Mail From _cAccount To _pcDestino CC _pcBcc Subject _pcSubject Body _pcBody RESULT _lEnviado //FORMAT TEXT 
		EndIf
		DISCONNECT SMTP SERVER
	EndIf
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf
Next

ConOut("ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

Return
