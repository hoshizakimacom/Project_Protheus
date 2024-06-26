User Function MT250TOK()
  
Local lRet  	:= .T.
Local aArea 	:= {}
Local cFamili	:= Posicione("SB1",1, xFilial("SB1") + M->D3_COD, "B1_XFAMILI")

//+---------------------------------------+
//|| Efetua valida��o de quantidade �nica |
//+---------------------------------------+
If M->D3_QUANT <> 1 .And. cFamili $ "000001|000002|000003|000004"
	MsgStop("Quantidade apontada deve ser igual a 1","ATEN��O")
	lRet := .F.
Endif

//+----------------------------------------------+
//| Efetua valida��o do numero de s�rie          |
//| verifica se o mesmo j� existe na tabela ZA0. |
//+----------------------------------------------+ 
aArea := GetArea()
dbSelectArea("SD3")
dbSetOrder(18) // ZA0_FILIAL+ZA0_SERIE

If Len(RTRIM(M->D3_XNSERIE)) <> 9 .and. cFamili $ "000001|000002|000003|000004"
	MsgAlert("Numero de digitos do numero de s�rie incompat�vel. Verifique se foi digitado numeros a mais, a menos ou espa�os em branco !.","Aten��o")
	lRet := .F.	
Endif

If  cFamili $ "000001|000002|000003|000004" .and. Empty(M->D3_XNSERIE)
		MsgAlert("Para produtos da Fam�lia Refrigera��o, Coc��o, Mobili�rio e Maquina de Gelo fabrica��o Macom, deve ser informado o n�mero de s�rie","Aten��o")
		lRet := .F.
EndIf

dbSelectArea("ZAB")
dbSetOrder(1)

If ZAB->(MsSeek(xFilial("ZAB")+ M->D3_XNSERIE)) .and. lRet
     If ZAB->ZAB_APONTA == "X"
		MsgAlert("Numero de s�rie j� apontado !","ATEN��O")
		lRet := .F.
	EndIf
EndIf

If lRet
    If MsSeek(xFilial("ZAB")+M->D3_XNSERIE)
    	Reclock("ZAB",.F.)
    	ZAB->ZAB_APONTA := "X"
    	ZAB->(MsUnlock())
    Endif
Endif

RestArea(aArea)

Return lRet
