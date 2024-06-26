User Function MT250TOK()
  
Local lRet  	:= .T.
Local aArea 	:= {}
Local cFamili	:= Posicione("SB1",1, xFilial("SB1") + M->D3_COD, "B1_XFAMILI")



//+---------------------------------------+
//|| Efetua validação de quantidade única |
//+---------------------------------------+
If M->D3_QUANT <> 1 .And. cFamili $ "000001|000002|000003|000004"
	MsgStop("Quantidade apontada deve ser igual a 1","ATENÇÃO")
	lRet := .F.
Endif

//+----------------------------------------------+
//| Efetua validação do numero de série          |
//| verifica se o mesmo já existe na tabela ZA0. |
//+----------------------------------------------+ 
aArea := GetArea()
dbSelectArea("SD3")
dbSetOrder(18) // ZA0_FILIAL+ZA0_SERIE

If Len(RTRIM(M->D3_XNSERIE)) <> 9 .and. cFamili $ "000001|000002|000003|000004"
	MsgAlert("Numero de digitos do numero de série incompatível. Verifique se foi digitado numeros a mais, a menos ou espaços em branco !.","Atenção")
	lRet := .F.	
Endif

If  cFamili $ "000001|000002|000003|000004" .and. Empty(M->D3_XNSERIE)
		MsgAlert("Para produtos da Família Refrigeração, Cocção, Mobiliário e Maquina de Gelo fabricação Macom, deve ser informado o número de série","Atenção")
		lRet := .F.
EndIf

dbSelectArea("ZAB")
dbSetOrder(1)

If ZAB->(MsSeek(xFilial("ZAB")+ M->D3_XNSERIE)) .and. lRet
     If ZAB->ZAB_APONTA == "X"
		MsgAlert("Numero de série já apontado !","ATENÇÃO")
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
