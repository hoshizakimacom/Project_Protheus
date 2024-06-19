User Function MT140LOK()
Local lRet := .T.

    // Ponto de chamada ConexãoNF-e sempre como primeira instrução.
    lRet := U_GTPE012()

    // Restrição para validações não serem chamadas duas vezes ao utilizar o importador da ConexãoNF-e,
    // mantendo a chamada apenas no final do processo, quando a variavel l103Auto estiver .F.
    //If lRet .And. !FwIsInCallStack('U_GATI001') .Or. !l103Auto
    //    If
    //        Regra existente
    //        [...]
    //    EndIf
    //EndIf

Return lRet
