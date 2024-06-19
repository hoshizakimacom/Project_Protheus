#Include "Protheus.ch"

User Function MT100TOK()
Local lRet := .T.
    
    // Restri��o para valida��es n�o serem chamadas duas vezes ao utilizar o importador da Conex�oNF-e, 
	// mantendo a chamada apenas no final do processo, quando a vari�vel l103Auto estiver .F.
    If !FwIsInCallStack('U_GATI001') .Or. IIf(Type('l103Auto') == 'U',.T.,!l103Auto)
		//If
		//	Regra existente
		//	[...]
		//EndIf
	EndIf
    
    If lRet
        // Ponto de chamada Conex�oNF-e sempre como �ltima instru��o.
        //lRet := U_GTPE005() 
    EndIf
    
Return lRet
