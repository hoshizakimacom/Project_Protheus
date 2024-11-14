#Include "TOTVS.ch"

/*/{Protheus.doc} MTA010MNU

Ponto de entrada utilizado para inserir novas opcoes no array aRotina

@author Desconhecido
@since 01/01/1980
@return Nil Nulo 
/*/
User Function MTA010MNU()
    Local aRotAnexos := {}

    AAdd(aRotina, {"Log Importação",    "CFGA650()", 0, 2, 0, NIL})

    AAdd(aRotAnexos, {"Envia Anexo",       "U_M04M10(1)", 0, 2, 0, NIL})
    AAdd(aRotAnexos, {"Visualiza Anexo",   "U_M04M10(2)", 0, 2, 0, NIL})
    AAdd( aRotina, { "Anexos" ,aRotAnexos, 0 , 2})

Return (NIL)

