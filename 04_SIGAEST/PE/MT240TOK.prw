User Function MT240TOK()

Local lRet   := .T.
Local cUsers := "000024|000247|000259" 
Local cFamili	:= Posicione("SB1",1, xFilial("SB1") + M->D3_COD, "B1_XFAMILI")

If RetCodUsr() $ cUsers .And. M->D3_TM == "002" .Or. M->D3_TM == "004"
	lRet := .F.	
	MsgAlert("Apontamento de produçao bloqueado para este usuário !","ATENÇÃO")
Endif
//-------------------------------------------------------------------------

aArea := GetArea()
dbSelectArea("SD3")
dbSetOrder(18) // ZA0_FILIAL+ZA0_SERIE

If M->D3_TM $ "501|502" .and. cFamili $ "000001|000002|000003" .and. M->D3_QUANT <> 1
		MsgAlert("A quantidade ser transformada deve ser igual a 1 e informar o número de série","Atenção")
		lRet := .F.
EndIf

If  cFamili $ "000001|000002|000003" .and. Empty(M->D3_XNSERIE)
		MsgAlert("Para produtos da Família Refrigeração e Cocção, deve ser informado o número de série","Atenção")
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
    		MsgStop("Numero de série já transformado ou OP de origem igual !","ATENÇÃO")
    		lRet := .F.
    	EndIf
    ElseIf cFamili $ "000001|000002|000003"
    	MsgStop("Numero de série não encontrado !","ATENÇÃO")
    	lRet := .F.
    Endif

EndIf


    

Return(lRet) 
