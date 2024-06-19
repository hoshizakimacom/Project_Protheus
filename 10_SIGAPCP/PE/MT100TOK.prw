#Include "Protheus.ch"

User Function MT100TOK()
Local lRet := .T.
    
    // Restrição para validações não serem chamadas duas vezes ao utilizar o importador da ConexãoNF-e, 
	// mantendo a chamada apenas no final do processo, quando a variável l103Auto estiver .F.
    If !FwIsInCallStack('U_GATI001') .Or. IIf(Type('l103Auto') == 'U',.T.,!l103Auto)
		//If
		//	Regra existente
		//	[...]
		//EndIf
	EndIf
    
    If lRet
        // Ponto de chamada ConexãoNF-e sempre como última instrução.
        //lRet := U_GTPE005() 
    EndIf
    
Return lRet
