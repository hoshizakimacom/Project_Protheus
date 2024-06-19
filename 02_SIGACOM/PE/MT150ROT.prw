#INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "TBICONN.CH"
#DEFINE NTAMARRAY	4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT150ROT ³ Autor ³ Marcos Rocha '  	    ³ Data ³ 29/09/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para adicionar botoes especificos na te-  ³±±
±±³          ³ la de atualisa cotacoes.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT150ROT()

AAdd( aRotina, { "Envia Cotação", "U_Mt150EV()", 0, 25 } )

Return aRotina

User Function Mt150EV()

Processa({|| U_Mt150EV2() },"Enviando email de Cotação...")

RETURN

User Function Mt150EV2()

Local cMailEnv   := ""

ProcRegua(2)

IncProc("Enviando...")

//Local cDirDoc	:= AllTrim(GetMV("ES_DIRATCT",, "Compras_At_Cot"))
//Envio de e-mail - Event Messenger 003
//If nLastRecno > 0
  //  SC8->(MsGoto(nLastRecno))
    //MaAvalCOT("SC8",1,,,,,.T.)
    //SC8->(DbSkip())
//Endif 

If File("samples/wf/MATA131_Mail001.html")
 //   For nI := 1 To Len(aCots)
   //     For nJ := 1 to Len(aCots[nI][3])
     //       If !Empty(aCots[nI][3][nJ][3])
//                cBody := U_A131GerMail(aCots[nI][1],aCots[nI][2],aCots[nI][3][nJ])

                cBody := U_A131Ger(SC8->C8_NUM,SC8->C8_EMISSAO,SC8->C8_FORNECE,SC8->C8_LOJA)
                 cMailEnv := Alltrim(SC8->C8_FORMAIL)+";compras@acosmacom.com.br"

//               MTSendMail({aCots[nI][3][nJ][3]},OemToAnsi("Solicitacoes"),cBody)
                MTSendMail({cMailEnv},OemToAnsi("Solicitacoes"),cBody)
       //     EndIf
      //  Next nJ
  //  Next nI
EndIf

//U_RECDocum(	Alias()	, SC8->C8_FILIAL	, SC8->C8_NUM	, SC8->C8_FILIAL + SC8->C8_NUM	, 1,; .F.		, cDirDoc )

IncProc("Enviando...")

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} A131GerMail()
Gera corpo do e-mail enviado para informar disponibilidade de retirada
de itens da S.A no armazem.
@author israel.escorizza
@since 24/02/2015
@version P12
/*/
//-------------------------------------------------------------------

User Function A131Ger(cNumCot, cDtEmiCot, cFornece, cLojafor)

//Local nI 	     := 0
//Local nY	     := 0
Local cRet	     := ""
Local aArea      := GetArea()
Local aAreaSC8   := SC8->(GetArea())
Local cHTMLSrc 	 := "samples/wf/MATA131_Mail001.html"
Local cHTMLDst	 := "samples/wf/MATA131_MTmp001.htm" //Destino deve ser .htm pois o metodo :SaveFile salva somente neste formato.
Local oHTMLBody  := TWFHTML():New(cHTMLSrc)
Local aRetCot    := {}
Local nI
//Local aItem      := {}
//Local lMT131AI   := ExistBlock("MT131AI")
//Local nTamCot    := TamSX3("C1_COTACAO")[1]
//Local nTamProd   := TamSX3("C1_PRODUTO")[1]
//Local nTamIdent  := TamSX3("C1_IDENT")[1]

oHTMLBody:ValByName('cNumCot',cNumCot)

//- Cabeçalho do informe.
oHTMLBody:ValByName('cNomeCli'	, allTrim(SM0->M0_NOMECOM))
oHTMLBody:ValByName('cDataEmis'	, cDtEmiCot)
oHTMLBody:ValByName('cCNPJCli'	, SM0->M0_CGC)
oHTMLBody:ValByName('cEndeCli'	, allTrim(SM0->M0_ENDENT)+" - "+allTrim(SM0->M0_CIDENT)+" - "+allTrim(SM0->M0_ESTENT))
oHTMLBody:ValByName('cCepCli'	, SM0->M0_CEPENT)
oHTMLBody:ValByName('cFoneCli'	, allTrim(SM0->M0_TEL))

DbSelectArea("SA2")
DbSetOrder(1)
If(SA2->(DBSeek(xFilial("SA2")+cFornece+cLojafor)))
    oHTMLBody:ValByName('cNomeFor',allTrim(SA2->A2_NOME))
    oHTMLBody:ValByName('cCNPJFor',allTrim(SA2->A2_CGC))
EndIf

cQuery := " SELECT C8_NUM, C8_ITEM, R_E_C_N_O_ RECSC8 "
cQuery += " FROM "+RetSqlName("SC8")+" SC8 "
cQuery += " WHERE SC8.C8_FILIAL = '"+xFilial("SC8")+"'"
cQuery += " AND SC8.C8_NUM  = '"+cNumCot+"'"
cQuery += " AND SC8.C8_FORNECE  = '"+cFornece+"'"
cQuery += " AND SC8.C8_LOJA  = '"+cLojafor+"'"
cQuery += " AND SC8.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY C8_NUM, C8_ITEM "
aRetCot  := U_QryArr(cQuery)
	
//- Detalhamento dos itens
For nI := 1 to Len(aRetCot)

    dbSelectArea("SC8")
    dbGoto(aRetCot[nI,3])

    dbSelectArea("SB1")
    If (SB1->(DBSeek(xFilial("SB1")+SC8->C8_PRODUTO)))
        aADD(oHTMLBody:ValByName('It.cProDesc')	,allTrim(SB1->B1_DESC))
        aADD(oHTMLBody:ValByName('It.cQuant')	,SC8->C8_QUANT)
        aADD(oHTMLBody:ValByName('It.cDtEnt')	,"  /  /  ")
        aADD(oHTMLBody:ValByName('It.cCodPro')	,allTrim(SB1->B1_COD))
        aADD(oHTMLBody:ValByName('It.cUm')      ,allTrim(SB1->B1_UM))
    EndIf

Next 

oHTMLBody:SaveFile(cHTMLDst)
cRet:= MtHTML2Str(cHTMLDst)
FErase(cHTMLDst)
RestArea(aAreaSC8)
RestArea(aArea)

Return cRet
