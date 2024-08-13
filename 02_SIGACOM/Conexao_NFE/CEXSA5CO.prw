#Include "Totvs.ch"
#Include "Protheus.ch"

Static cxAlias := GetNextAlias()

/*/{Protheus.doc} CEXSA5CO
@description 	Ponto de entrada na conversao produto x fornecedor
@obs			(Utilizado na Central XML )
@obs		
@author 		Xavier 
@since 			10/2023
@version		1.0
@return			Nil
@type 			Function
/*/

//A5_X3TPOCV D=Divisor;M=multiplicador
//A5_X3FATOR
User Function CEXSA5CO()

	Local axParam   := PARAMIXB
	Local cxProdPro	:= axParam[1]	//Produto Protheus
	Local cxFornece	:= axParam[2]	//Fornecedor
	Local cxLoja	:= axParam[3]	//Loja
	Local cxCodAux	:= axParam[4]	//Codigo Referencia
	Local cxTerUN	:= axParam[5]	//Unidadae Nf
	Local axConver  := {'D',1}
	Local cxQuery   := ""

	cxQuery := " SELECT  A5_XTERUN, A5_X3TPOCV, A5_X3FATOR  "
	cxQuery += " FROM " + RetSqlName("SA5") + "(NOLOCK) SA5 "
	cxQuery += " INNER JOIN " + RetSqlName("SB1") + "(NOLOCK) SB1 ON B1_COD = A5_PRODUTO AND SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cxQuery += " WHERE SA5.D_E_L_E_T_ = '' " 	
	cxQuery += " AND A5_FILIAL  = '" + xFilial("SA5") + "' "
	cxQuery += " AND A5_PRODUTO = '" + cxProdPro      + "' "
	cxQuery += " AND A5_CODPRF  = '" + cxCodAux       + "' "
	cxQuery += " AND A5_FORNECE = '" + cxFornece      + "' "
	cxQuery += " AND A5_LOJA    = '" + cxLoja         + "' "
	cxQuery += " and A5_XTERUN  = '" + cxTerUN         + "' "

	Iif(Select(cxAlias)>0,(cxAlias)->(dbCloseArea()),Nil)
	MPSysOpenQuery( cxQuery, cxAlias )

	dbSelectArea(cxAlias)
	(cxAlias)->(dbGoTop()) 

	If (cxAlias)->(!EoF())	
	
			If (cxAlias)->A5_X3FATOR > 0				
				axConver[1] := (cxAlias)->A5_X3TPOCV //Fator de conversão
				axConver[2] := (cxAlias)->A5_X3FATOR  //Valor de conversão	
			Endif
	
		(cxAlias)->(dbCloseArea())	
	Endif
	if axConver[1]  =="D"
		axConver[1] :="M"
	ELSE 
		axConver[1] := "D"
	ENDIF 
Return axConver
