User Function MT240TOK()

Local lRet   := .T.
Local cUsers := "000024|000247|000259" 
Local cFamili	:= Posicione("SB1",1, xFilial("SB1") + M->D3_COD, "B1_XFAMILI")

If RetCodUsr() $ cUsers .And. M->D3_TM == "002" .Or. M->D3_TM == "004"
	lRet := .F.	
	MsgAlert("Apontamento de produ�ao bloqueado para este usu�rio !","ATEN��O")
Endif
//-------------------------------------------------------------------------

aArea := GetArea()
dbSelectArea("SD3")
dbSetOrder(18) // ZA0_FILIAL+ZA0_SERIE

If M->D3_TM $ "501|502" .and. cFamili $ "000001|000002|000003" .and. M->D3_QUANT <> 1
		MsgAlert("A quantidade ser transformada deve ser igual a 1 e informar o n�mero de s�rie","Aten��o")
		lRet := .F.
EndIf

If  cFamili $ "000001|000002|000003" .and. Empty(M->D3_XNSERIE)
		MsgAlert("Para produtos da Fam�lia Refrigera��o e Coc��o, deve ser informado o n�mero de s�rie","Aten��o")
		lRet := .F.
Else
	dbSelectArea("ZAB")
    dbSetOrder(1)
    If MsSeek(xFilial("ZAB")+M->D3_XNSERIE)
    	If Empty(ZAB->ZAB_OPTRAN) .and. M->D3_OP <> ZAB->ZAB_NUMOP
    		Reclock("ZAB",.F.)
    		ZAB->ZAB_OPTRAN := Substr(M->D3_OP,1,6)
    		ZAB->ZAB_ITTRAN := Substr(M->D3_OP,7,2)
    		ZAB->ZAB_SQTRAN := Substr(M->D3_OP,9,3)
    		ZAB->(MsUnlock())
    	Else
    		MsgStop("Numero de s�rie j� transformado ou OP de origem igual !","ATEN��O")
    		lRet := .F.
    	EndIf
    ElseIf cFamili $ "000001|000002|000003"
    	MsgStop("Numero de s�rie n�o encontrado !","ATEN��O")
    	lRet := .F.
    Endif

EndIf


    

Return(lRet) 
