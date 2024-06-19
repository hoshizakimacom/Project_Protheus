User Function dtfin()
	

Local aPergs   := {}
  
Local cCampo := Space(8) // tamanho do campo
	 


	aAdd(aPergs, {1, "Data ultimo fechamento financeiro. Formato - AAAAMMDD",cCampo, "", ".T.", "",    ".T.", 8, .T.})


	
  
		If ParamBox(aPergs, "PARAMETRO FECHAMENTO FINANCEIRO")
	   
	   
			PUTMV("MV_DATAFIN", MV_PAR01)	
  
		
		EndIf

Return