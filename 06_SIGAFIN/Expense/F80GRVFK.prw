#Include 'PROTHEUS.CH'
#Include 'PARMTYPE.CH'


User Function F80GRVFK()
	
Local aArea	    := GetArea()
Local cCampos   := PARAMIXB[1]

//Tabela integradora
DBSelectArea("PR2")
PR2->(DBSetOrder(1))

If !Empty(SE2->E2_XIDADT) .Or. !Empty(SE2->E2_XIDREL)

	If !PR2->(DBSeek( SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO) ))

		RECLOCK("PR2",.T.)

			PR2->PR2_FILIAL := xFilial("PR2")
			PR2->PR2_ALIAS  := "SE2"
			PR2->PR2_RECNO  := SE2->(Recno()) 
			PR2->PR2_TIPREQ := "1"
			PR2->PR2_STINT  := "P"
			PR2->PR2_CHAVE  := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

		PR2->(MsUnlock())

	EndIf

EndIf

RestArea(aArea)
	
Return(cCampos)

