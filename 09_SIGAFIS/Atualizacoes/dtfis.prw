User Function dtfis()
	

Local aPergs   := {}
  
Local cCampo := Space(8) // tamanho do campo
	 


	aAdd(aPergs, {1, "Data ultimo fechamento fiscal. Formato - AAAAMMDD",cCampo, "", ".T.", "",    ".T.", 8, .T.})


	
  
		If ParamBox(aPergs, "PARAMETRO FECHAMENTO FISCAL")
	   
	   
			PUTMV("MV_DATAFIS", MV_PAR01)	
  
		
		EndIf

Return