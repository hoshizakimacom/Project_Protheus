#INCLUDE "PROTHEUS.CH"

//----------------------------------------------------
/*/{Protheus.doc} MC030IDMV
Ponto de Entrada para tratar o campo de IDENT da Movimentação na 
consulta do Kardex do Produto

@autor Montes
@since 24/01/2025
@param PARAMIXB[1] := SD3->D3_OP
@param PARAMIXB[2] := SD3->D3_CC
@return string
/*/
//----------------------------------------------------
User Function MC030IDMV()

Local cOP      := PARAMIXB[1]
Local cCC      := PARAMIXB[2]
Local lFuncMnt := FindFunction( 'MNTDESCOS' )
Local cIdent   := IIf( Empty( cOP ), cCC, fIdentOS( cOP, lFuncMnt ) )

/*

Quando for movimento de transferencia para Processo - Informado o numero da OP para separação do Picking

*/
If SD3->(FIELDPOS("D3_XOP")) > 0 .And. !EMPTY( SD3->D3_XOP )
   cIdent := "P:"+SD3->D3_XOP
EndIf

Return cIdent

//----------------------------------------------------
/*/{Protheus.doc} fIdentOS
Retorna descrição referente a OP ou Ordem de serviço

@autor Maria Elisandra de Paula
@since 15/07/2021
@param cOp, string, número da ordem de produção
@param lFuncMnt, boolean, se existe função
@return string
/*/
//----------------------------------------------------
Static Function fIdentOS( cOp, lFuncMnt )
Local aArea := {}
Local cRet  := cOp

If lFuncMnt
	If SubStr(cOP,7,2) == "OS"
		aArea := GetArea()

		dbSelectArea('STJ')
		dbSetOrder(1)
		If dbSeek( xFilial('STJ') + SubStr(cOp,1,6) )
			cRet := MNTDESCOS( STJ->TJ_ORDEM, STJ->TJ_CCUSTO, .F. )
		EndIf

		RestArea( aArea )
	EndIf
EndIf

Return cRet
