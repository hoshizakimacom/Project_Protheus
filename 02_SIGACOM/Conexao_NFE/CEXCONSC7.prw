#Include "Totvs.ch"

/*/{Protheus.doc} CEXCONSC7
@description 	Ponto de entrada na conversao do fator do produto
@obs			Validar segunda unidade de medida do produto para fazer ou nao a conversao
@author 		Xavier /Pedro
@since 			12/20192023
@version		1.0
@return			Nil
@type 			Function
/*/
User Function CEXCONSC7()

	Local nxPosQtd	 := Ascan( aHeader, { |x| Alltrim( x[ 2 ] ) == "D1_QUANT" 	} ) //Posição da quantidade ja convertida
	Local nxPosAcols := Paramixb[3] //Posição do Acols
	Local nxRetQtd	 := 0
	
	nxRetQtd := aCols[ nxPosAcols ][ nxPosQtd ] //Pega quantidade do Acols para o retorno do ponto de entrada
	
Return nxRetQtd

