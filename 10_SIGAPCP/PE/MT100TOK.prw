#Include "Protheus.ch"

User Function MT100TOK()
Local lRet := .T.
Local nPosPed := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
Local I

    // Restrição para validações não serem chamadas duas vezes ao utilizar o importador da ConexãoNF-e, 
	// mantendo a chamada apenas no final do processo, quando a variável l103Auto estiver .F.
    If !FwIsInCallStack('U_GATI001') .Or. IIf(Type('l103Auto') == 'U',.T.,!l103Auto)
		//If
		//	Regra existente
		//	[...]
		//EndIf
	EndIf

	//Validacao condição de pagamento //#MONTES20250325
	For I := 1 To Len(aCols)
		If aCols[I,Len(aHeader)+1]
			Loop
		EndIf
		
		dbSelectArea("SC7")
		dbSetOrder(1)		
		If dbSeek(xFilial("SC7")+aCols[I,nPosPed])
			If !( PADR(cCONDICAO,TAMSX3("C7_COND")[1]) == SC7->C7_COND )
				Aviso("Atenção !","A condição de pagamento do pedido de compra não pode ser alterada! Condição:"+SC7->C7_COND,{"Ok"})
				lRet := .F.	
                Exit
			EndIf
		EndIf
	Next
    
    If lRet
        // Ponto de chamada ConexãoNF-e sempre como última instrução.
        //lRet := U_GTPE005() 
    EndIf
    
Return lRet
