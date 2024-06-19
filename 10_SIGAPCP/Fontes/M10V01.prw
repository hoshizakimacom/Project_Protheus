#include 'TBICONN.ch'
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

//+-------------------------------------------------------------------------
// Validacao de Número de Serie no apontamento da Ordem de Produção
// Tabela ZAB
// Renan Camargo - 17/11/23
//+-------------------------------------------------------------------------
User Function M10V01()

Local aArea       := GetArea()
Local lAchouNSer  := .F.

cQry := " SELECT COUNT(*) QTDZAB, 0 QTDSD3 "
cQry += " FROM "+ RetSqlName("ZAB") + " ZAB "
cQry += " WHERE ZAB_FILIAL = '"+xFilial("ZAB")+"'" 
cQry += " AND ZAB_CODPRO = '"+ M->D3_COD + "' "
cQry += " AND ZAB.ZAB_NUMOP = '"+ Left(M->D3_OP,6) + "' " 
cQry += " AND ZAB.ZAB_NUMSER = '"+ M->D3_XNSERIE + "' "
cQry += " AND ZAB.D_E_L_E_T_ = '' " 

// UNION ALL

//cQry := "SELECT 0 QTDZAB, COUNT(*)  QTDSD3 "
//cQry += " FROM "+ RetSqlName("SD3") + " SD3 "
//cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'" 
//cQry += " AND ZAB_CODPRO = '"+ M->D3_COD + "' "
//cQry += " AND SubString(SD3.D3_OP,1,6)   = '"+ substr(cNumOpx,1,6) + "' " 
//cQry += " AND SD3.D3_XNSERIE = '"+ _cNumSer + "' "
//cQry += " AND SD3.D3_CF = 'PR0' "  
//cQry += " AND SD3.D_E_L_E_T_ = '' " 
//cQry += " ORDER BY SD3.D3_FILIAL,SD3.D3_COD,SD3.D3_OP,SD3.D3_TM,SD3.D3_XNSERIE ASC "

//Private _cCodProd	:= ZAB->ZAB_CODPRO
//Private _cNumSer	:= ZAB->ZAB_NUMSER
//Private cNumOpx   := ZAB->ZAB_NUMOP

cAliasZAB	:= GetNextAlias() 
If Select(cAliasZAB) > 0
   dbSelectArea(cAliasZAB)
   dbCloseArea()
EndIf

cQry := ChangeQuery(cQry)
dbUseArea(.T.,'TOPCONN', TCGENQRY(,,cQry), cAliasZAB, .F., .T.)

dbSelectArea(cAliasZAB) 
dbGoTop()
While !Eof()
    iF (cAliasZAB)->QTDRET > 0
		lAchouNSer := .T.
	EndIf
	dbskip()   
EndDo

dbSelectArea(cAliasZAB) 
(cAliasZAB)->(DBCLOSEAREA())

iF !lAchouNSer
	MsgInfo("Este Num. Serie "+alltrim(M->D3_XNSERIE)+", nao pertence a este Produto/ Ordem de Produção ou não esta cadastrado na tabela de Num. Serie","Atenção")
EndIf

RestArea(aArea)

Return lAchouNSer 
