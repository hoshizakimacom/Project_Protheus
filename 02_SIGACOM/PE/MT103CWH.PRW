User Function MT103CWH()
Local _aAreaTu  := GetArea()
Local lRetorno := .T. 
        // Ponto de chamada Conex�oNF-e
    //lRetorno := U_GTPE006()

    RestArea(_aAreaTu)    

Return lRetorno
