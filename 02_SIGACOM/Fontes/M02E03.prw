#Include 'Totvs.ch'

//+----------------------------------------------------------------------------------------------------------------
// Permite alteracao da condicao de pagamento s� para usu�rios do financeiro caso tenha
// definido no cadastro do fornecedor. 
// Marcos - 21/03/24 
//+----------------------------------------------------------------------------------------------------------------
User Function M02E03()

If RetCodUsr() $ GetMv("AM_USRCOND")
	Return(.T.)
EndIf

cCondFor :=  Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,"A2_COND")

//MsgStop(cCondFor)

If !Empty(cCondFor)
	cCondicao := cCondFor
EndIf

Return(.T.)
