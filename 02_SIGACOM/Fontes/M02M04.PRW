 #INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M02M04   ³ Autor ³ Marcos Rocha '  	    ³ Data ³ 16/10/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email de Autorizacao de Entrega                      ³±±
±±³          ³ Especifico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M02M04()

Processa({|| U_M02M04E() },"Enviando email de Autorização de Entrega...")

RETURN

User Function M02M04E()

Local cMailEnv   := ""
Local cAnexo     := ""
Local aArea      := GetArea()
Local aAreaSC7   := SC7->(GetArea())
Local cEmailFor  := ""
Local lEnvFor    := .F.

ProcRegua(2)

IncProc("Enviando...")

If File("samples/wf/M02M04_Mail001.html")

    U_M02R07(.T.)   // Impressao do Pedido de Compra

    cBody := U_M02M04Ger(SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA)

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

	//cMailEnv := cMailEnv+If(!Empty(cMailEnv),";","")+AllTrim(GetMv("AM_EMAILCO"))
	cMailEnv := "marcos.rocha@wikitec.com.br"

	MsgStop("Emails Envio "+cMailEnv)
    cAnexo   := 'AE' + SC7->C7_NUM + '_'+DToS(Date())+".pdf"
    cDirPDF    := "\SPOOL\"

    cAnexo   := AllTrim(cDirPDF)+cAnexo
	//If File(cAnexo)
	//	MsgStop("Arquivo Localizado ")
	//Else
	//	MsgStop("Arquivo Não Localizado ")
	//Endif 

    If U_MTSendMail({cMailEnv},OemToAnsi("Autorização de Entrega"),cBody,cAnexo)

//		cPedCompra := SC7->C7_NUM		
//		If 	lEnvFor
//			dbSelectArea("SC7")
//			dbSetOrder(1)
//			dbSeek(xFilial("SC7")+cPedCompra)
//			While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedCompra
//				RecLock("SC7",.F.)
//				SC7->C7_XENVFOR := dDataBase
//				MsUnLock()
//				dbSkip()
//			EndDo
//		EndIf

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
User Function M02M04Ger(cNumPed, cDtEmiPed, cFornece, cLojafor)

Local cRet	     := ""

Local cHTMLSrc 	 := "samples/wf/M02M04_Mail001.html"
Local cHTMLDst	 := "samples/wf/M02M04_Mail001.htm" //Destino deve ser .htm pois o metodo :SaveFile salva somente neste formato.
Local oHTMLBody  := TWFHTML():New(cHTMLSrc)

oHTMLBody:ValByName('cNumPed',cNumPed)

oHTMLBody:SaveFile(cHTMLDst)
cRet:= MtHTML2Str(cHTMLDst)
FErase(cHTMLDst)

Return cRet
