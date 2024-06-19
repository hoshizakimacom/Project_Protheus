#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³DigNNum³ Efetua o cálculo do dígito verificador do nosso número - Bradescoº±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 08.06.11 ³ Microsiga                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                        

User Function DigNNum()   

SetPrvt("_N1,_N2,_N3,_N4,_N5,_N6,_N7,_N8,_N9,_N10,_N11,_N12,_N13")
SetPrvt("_RETORNO,_MULT,_RESTO,_DIG,_NNUM,_BANCO")
         
   

_cNNum := STRZERO(VAL(SEE->EE_SUBCTA),3)+SE1->E1_NUMBCO
_N1 := Substr(_cNNum,2,1)// Carteira 
_N2 := Substr(_cNNum,3,1)// Carteira
_N3 := Substr(_cNNum,4,1)// Nosso Numero
_N4 := Substr(_cNNum,5,1)// Nosso Numero
_N5 := Substr(_cNNum,6,1)// Nosso Numero
_N6 := Substr(_cNNum,7,1)// Nosso Numero
_N7 := Substr(_cNNum,8,1)// Nosso Numero
_N8 := Substr(_cNNum,9,1)// Nosso Numero
_N9 := Substr(_cNNum,10,1)// Nosso Numero
_N10 := Substr(_cNNum,11,1)// Nosso Numero
_N11 := Substr(_cNNum,12,1)// Nosso Numero
_N12 := Substr(_cNNum,13,1)// Nosso Numero 
_N13 := Substr(_cNNum,14,1)// Nosso Numero


_Mult := (VAL (_N1) * 2) + (VAL(_N2) * 7) + (VAL(_N3) * 6) + (VAL(_N4) * 5) + (VAL(_N5) * 4) + (VAL(_N6) * 3) + (VAL(_N7) * 2) + (VAL(_N8) * 7) + (VAL(_N9) * 6) + (VAL(_N10) * 5) + (VAL(_N11) * 4) + (VAL(_N12) * 3) + (VAL(_N13) * 2)
_Resto := INT(_Mult % 11)
_Dig := INT(11 - _Resto)
_Retorno := IF(_Resto == 0,"0",IF(_Resto == 1,"P",_Dig))

Return(_Retorno)
