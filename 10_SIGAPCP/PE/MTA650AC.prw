#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MTA650AC
Inclusão de campo no aCols dos empenhos
@author Montes
@since 16/01/2025
@version 1.0
@type function
/*/
User Function MTA650AC()

Local aArray := {}

aadd(aArray,{"Ansul", "D4_XANSUL", "", TamSX3("D4_XANSUL")[1], TamSX3("D4_XANSUL")[2], "", .T., "C", "", " "})
aadd(aArray,"SG1->G1_XANSUL")

RETURN aArray


