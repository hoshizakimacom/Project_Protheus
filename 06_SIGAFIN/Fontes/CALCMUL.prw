#INCLUDE "PROTHEUS.CH"

User Function CalcMul()

Local cValMul	:= 0
Local nValor	:= SE1->E1_VALOR
Local nInteiro	:= 0
Local cInteiro	:= ""
Local cDecimal	:= ""
Local nRetorno	:= 0
Local cRetorno	:= ""

nValMul	:= ( nValor * 0.1666 ) / 100

nInteiro := INT(Round(nValMul,2))
cInteiro := Alltrim(Str(nInteiro))

cDecimal := Alltrim(STR(Round(nValMul,2))) 

Do Case
	Case Len(cDecimal) == 4
		cDecimal	:= Substr(cDecimal,3,2)			
	Case Len(cDecimal) == 5
		cDecimal	:= Substr(cDecimal,4,2)
	Case Len(cDecimal) == 6
		cDecimal	:= Substr(cDecimal,5,2)
	Case Len(cDecimal) == 7	
		cDecimal	:= Substr(cDecimal,6,2)
EndCase
	
If Len(cDecimal) == 1
	cDecimal := cDecimal + "0"
Endif

cRetorno := cInteiro + cDecimal

nRetorno := Val(cRetorno)

cValMul := STRZERO(nRetorno,13,0)

Return cValMul