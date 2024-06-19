#INCLUDE "rwmake.ch"

/*/
// Validacao para a data de entrega do pedido de compras nao
//  ser inferior a data de emissao ou database
/*/
User Function M02V01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da Rotina                                                 ³                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Local lRet		:= .T. 

If ReadVar() == "M->C7_DATPRF"
	If Dtos(&(ReadVar())) < Dtos(DA120EMIS) .Or. Dtos(&(ReadVar())) < Dtos(dDatabase)
		lRet := .F.
		Help(" ",1,"Inconsistência",,"A data de entrega não pode ser inferior a data de emissão ou database.",4)
	EndIf
EndIf

Return(lRet)	
