#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#include "Fileio.ch"

User Function M145ARDEL()
Local lRet := .T.

    // Ponto de chamada Conex�oNF-e sempre como primeira instru��o 
    lRet := U_GTPE018()

    //If
    //    Regra existente
    //    [...]
    //EndIf

Return lRet
