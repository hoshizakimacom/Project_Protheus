#Include 'PROTHEUS.CH'
#Include 'PARMTYPE.CH'


User Function F340SE5()

Local aArea	    := GetArea()
Local aArray 	:= aClone(ParamIXB[1])
Local nI

DbSelectArea("PR2")
PR2->(DbSetOrder(1))

For nI := 1 to Len(aArray)

	SE5->(DbGoTo(aArray[nI]))
	
	If Alltrim(SE5->E5_TIPO) == 'NF'
		
		If SE2->(DBSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) ))

			If SE2->E2_SALDO <= 0 .And. !Empty(SE2->E2_XIDREL)
				
				If !PR2->(DbSeek( SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO) )) 
				
					RECLOCK("PR2",.T.)

						PR2->PR2_FILIAL := xFilial("PR2")
						PR2->PR2_ALIAS  := "SE2"
						PR2->PR2_RECNO  := SE2->(Recno()) 
						PR2->PR2_TIPREQ := "1"
						PR2->PR2_STINT  := "P"
						PR2->PR2_CHAVE  := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

					PR2->(MsUnlock())

				Endif
			
			Endif  

		Endif 

	Endif 

Next nI

//Verifico o saldo do adiantamento, se for zerado mando pra tabela integradora
If val(cSaldo) - nValtot <= 0 
		
	If SE2->(DBSeek(SE5->(E5_FILIAL+cPrefixo+cNum+cParcela+'PA ') ))
		
		If !Empty(SE2->E2_XIDADT)
		
			If !PR2->(DbSeek( SE2->(E2_FILIAL+cPrefixo+cNum+cParcela+'PA '))) 

				RECLOCK("PR2",.T.)

					PR2->PR2_FILIAL := xFilial("PR2")
					PR2->PR2_ALIAS  := "SE2"
					PR2->PR2_RECNO  := SE2->(Recno()) 
					PR2->PR2_TIPREQ := "1"
					PR2->PR2_STINT  := "P"
					PR2->PR2_CHAVE  := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

				PR2->(MsUnlock())
	
			Endif 

		EndIf
		
	EndIf
Endif 

RestArea(aArea)

Return
