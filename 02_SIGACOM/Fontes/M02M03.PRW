 #INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M02M03   ³ Autor ³ Marcos Rocha '  	    ³ Data ³ 16/10/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email de Contrato de Parceria                        ³±±
±±³          ³ Especifico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M02M03()

Processa({|| U_M02M03E() },"Enviando email de Contrato de Parceria...")

Return

User Function M02M03E()

Local cMailEnv   := ""
Local cAnexo     := ""
Local aArea      := GetArea()
Local aAreaSC3   := SC3->(GetArea())
Local cEmailFor  := ""
Local lEnvFor    := .F.

ProcRegua(2)

IncProc("Enviando...")

If File("samples/wf/M02M03_Mail001.html")

    U_M02R06(.T.)   // Impressao do Contrato de Parceria

    cBody := U_M02M03Ger(SC3->C3_NUM,SC3->C3_EMISSAO,SC3->C3_FORNECE,SC3->C3_LOJA)

	dbSelectArea("SA2")
	dbSetOrder(1)
	If (SA2->(DBSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)))
		cEmailFor := AllTrim(SA2->A2_EMAIL)
	EndIf

	If Empty(cEmailFor)
		MsgStop("Email do Fornecedor não preenchido !")
	EndIf

    If MsgYesNo('Envia Email para Fornecedor ?',"Atenção")
  		cMailEnv := cEmailFor
		lEnvFor  := .T.
    EndIf

	//cMailEnv := cMailEnv+If(!Empty(cMailEnv),";","")+AllTrim(GetMv("AM_EMAILCO"))
	cMailEnv := "marcos.rocha@wikitec.com.br"

	MsgStop("Emails Envio "+cMailEnv)
    cAnexo   := 'CP' + SC3->C3_NUM + '_'+DToS(Date())+".pdf"
    cDirPDF    := "\SPOOL\"

    cAnexo   := AllTrim(cDirPDF)+cAnexo
	//If File(cAnexo)
	//	MsgStop("Arquivo Localizado ")
	//Else
	//	MsgStop("Arquivo Não Localizado ")
	//Endif 

    If U_MTSendMail({cMailEnv},OemToAnsi("Contrato de Parceria"),cBody,cAnexo)

		cCtrFornece := SC3->C3_NUM		

/*/
		If 	lEnvFor
			dbSelectArea("SC3")
			dbSetOrder(1)
			dbSeek(xFilial("SC3")+cCtrFornece)
			While !Eof() .And. SC3->C3_FILIAL+SC3->C3_NUM == xFilial("SC3")+cCtrFornece
				RecLock("SC3",.F.)
				SC3->C3_XENVFOR := dDataBase
				MsUnLock()
				dbSkip()
			EndDo
		EndIf
/*/

	EndIf
EndIf

IncProc("Enviando e-mail...")

RestArea(aAreaSC3)
RestArea(aArea)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} A131GerMail()
Gera corpo do e-mail de pedido
/*/
//-------------------------------------------------------------------
User Function M02M03Ger(cNumPed, cDtEmiPed, cFornece, cLojafor)

Local cRet	     := ""

Local cHTMLSrc 	 := "samples/wf/M02M03_Mail001.html"
Local cHTMLDst	 := "samples/wf/M02M03_Mail001.htm" //Destino deve ser .htm pois o metodo :SaveFile salva somente neste formato.
Local oHTMLBody  := TWFHTML():New(cHTMLSrc)

oHTMLBody:ValByName('cNumPed',cNumPed)

oHTMLBody:SaveFile(cHTMLDst)
cRet:= MtHTML2Str(cHTMLDst)
FErase(cHTMLDst)

Return cRet
