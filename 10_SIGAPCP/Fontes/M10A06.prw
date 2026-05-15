#INCLUDE "TOTVS.CH"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'
#Include "Protheus.ch"
#include "Topconn.ch"
 
/*/{Protheus.doc} M10A06
Função Gerar o número de série e etiquetas para a O.P.
Alterei o fonte para criação de tela através do componente oDlg
Chamado 2123
@author Graziella Baicnchin
@since 07/12/2022
@version 1.0
@type function
*/

User Function M10A06()                        
	Local _oDlg		:= Nil
	Local _cTitulo	:= 'Gera N.S. e Etiquetas dos Produtos da O.P.'

	Local _cCodOpi	:= Space(11)
	Local cCodOpf	:= Space(11)
	Local nComboBo1 := '1'
	
	DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

	@ 002,002 TO 200, 400 OF _oDlg PIXEL

	@ 020,010 SAY 'O.P. Inicial:' SIZE 55, 07 OF _oDlg PIXEL
	@ 020,070 MSGET _cCodOpi SIZE 80, 11 F3 'SC2' Picture '@!' OF _oDlg PIXEL

	@ 040,010 SAY 'O.P. Final..:' SIZE 55, 07 OF _oDlg PIXEL
	@ 040,070 MSGET cCodOpf SIZE 80, 11 F3 'SC2'OF _oDlg Picture '@!' PIXEL
	
    @ 053, 009 SAY "Gera Numero de Serie e Etiqueta?" SIZE 043, 015 OF _oDlg PIXEL
    @ 057, 070 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1-Sim","2-Não"} SIZE 072, 015 OF _oDlg PIXEL

	DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION U_M10A06G(@_cCodOpi,@cCodOpf,SUBSTRING(@nComboBo1,1,1)) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION _oDlg:End() ENABLE OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED
Return


User Function M10A06G(cGet1,cGet2,nComboBo1)

Local _cDeOP   	:= cGet1
Local _cAteOP  	:= cGet2
Local _cTpGera 	:= nComboBo1
Local _nRegSC2 	:= 0
Local _cQuery  	:= ""
Local _nRegZAB  := 0
Local _cNumSer  := ""
Private _cOp	 := ""
Private _cItem	 := ""
Private _cSequen := ""
Private aRet     := {}
Private cAviso   := ""

_cDeOP   := Alltrim(cGet1)
_cAteOP  := Alltrim(cGet2)
_cTpGera := nComboBo1
_cQuery  := ""
_nRegSC2 := 0
_nRegZAB := 0

   	If _cTpGera = '1' // gera numero de serie e imprime etiquetas
		_cQuery:= "SELECT C2_FILIAL, C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_PRODUTO, C2_QUANT,C2_QUJE "
		_cQuery+= "FROM "+RetSqlName("SC2")+" SC2 "
		_cQuery+= "WHERE C2_FILIAL = '"+xFilial("SC2")+"' "
		_cQuery+= "AND C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+_cDeOP +"' " 
		_cQuery+= "AND C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+_cAteOP+"' "
		_cQuery+= "AND D_E_L_E_T_ = '' "

   		TcQuery _cQuery New Alias (cAlias := GetNextAlias())
		(cAlias)->(DbEval({|| _nRegSC2 ++ }))
		(cAlias)->(DbGoTop())

		While ! (cAlias)->(Eof())
			
			cProduto 	:= (cAlias)->C2_PRODUTO
			_nQtdOP		:= (cAlias)->C2_QUANT
			_nQtdJE		:= (cAlias)->C2_QUJE
			_cOp		:= (cAlias)->C2_NUM
			_cItem		:= (cAlias)->C2_ITEM
			_cSequen	:= (cAlias)->C2_SEQUEN

			DbSelectArea("ZAB")
			DbSetOrder(2) //ZAB_FILIAL, ZAB_NUMOP, ZAB_ITEMOP, ZAB_SEQOP, R_E_C_N_O_, D_E_L_E_T_
			If !(ZAB->(MSSeek(xFILIAL("ZAB")+_cOp+_cItem+_cSequen)))

				FWMsgRun(, {|| aRet := U_M10AETQ(cProduto,_nQtdOP,_nQtdJE, _cOp, _cItem, _cSequen,.T./*lImprime*/,.F. /*lCtrlImp*/)},,'Gerando Números de série ...')

				_lRet  := aRet[1]
				cAviso += aRet[2]
			Else
				//Aviso("Geração de Número de Série","Números de Série já gerados para a O.P. em questão " +  _cOp+_cItem+_cSequen +  ". ",{"Ok"},3)
				cAviso += "Números de Série já gerados para a O.P. em questão " +  _cOp+_cItem+_cSequen +  ". "+CHR(13)+CHR(10)
			Endif
		    (cAlias)->(DbSkip())
		Enddo
		(cAlias)->(DbCloseArea())

		If !EMPTY(cAviso)
			Aviso("ATENÇÃO",cAviso,{"Ok"},3)
		EndIf

    Else // imprime somente as etiquetas

		_cQuery:= " SELECT ZAB.R_E_C_N_O_ RECZAB, ZAB.* "
		_cQuery+= "FROM "+RetSqlName("ZAB")+" ZAB "
		_cQuery+= "WHERE ZAB_FILIAL = '"+xFILIAL("ZAB")+"' "
		_cQuery+= "  AND ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP >= '"+_cDeOP +"' " 
		_cQuery+= "  AND ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP <= '"+_cAteOP+"' "
		_cQuery+= "  AND D_E_L_E_T_ = '' "

		TcQuery _cQuery New Alias (cAlias := GetNextAlias())
		//(cAlias)->(DbEval({|| _nRegZAB ++ }))
		(cAlias)->(DbGoTop())

		While ! (cAlias)->(Eof())

			cProduto 	:= (cAlias)->ZAB_CODPRO
			_nQtdOP		:= Posicione("SC2",1, xFilial("SC2") + (cAlias)->ZAB_NUMOP+ (cAlias)->ZAB_ITEMOP+(cAlias)->ZAB_SEQOP,"C2_QUANT")
//			_cOP		:= (cAlias)->(ZAB_NUMOP+ZAB_ITEMOP+ZAB_SEQOP)
			_cOP		:= (cAlias)->(ZAB_NUMOP)
			_cItem		:= (cAlias)->(ZAB_ITEMOP)
			_cSequen	:= (cAlias)->(ZAB_SEQOP)

			//For _nRegZAB := 1 to _nQtdOP

			dbSelectArea("ZAB")
			dbGoTo((cAlias)->RECZAB)

			_cNumSer	:= (cAlias)->ZAB_NUMSER

			U_M10EPrin(cProduto,_nQtdOP,_cNumSer,.F./*lCtrlImp*/) //MA650TOK.PRW
			U_M10EPri1(cProduto,_nQtdOP,_cNumSer,.F./*lCtrlImp*/) //MA650TOK.PRW
			U_M10EPri1(cProduto,_nQtdOP,_cNumSer,.F./*lCtrlImp*/) //MA650TOK.PRW

			(cAlias)->(DbSkip())
			//Next
		Enddo	

		(cAlias)->(DbCloseArea())
    Endif
Return
