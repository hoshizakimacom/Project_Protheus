#Include 'Protheus.ch'

//+------------------------------------------------------------------------
	//	Relatório de Pesquisa Fábrica
//+------------------------------------------------------------------------
User Function M10R02()
	Local _oReport		:= Nil	
	Local _cPerg  		:= 'M10R02    '
	Local _lOk				:= .F.

	AtuSX1(_cPerg)

	_lOk := M0RValid()

	If _lOk .And. FindFunction('TRepInUse') .And. TRepInUse(.F.)	//verifica se relatorios personalizaveis esta disponivel
		If Pergunte(_cPerg, .T.)
			_oReport := ReportDef(_oReport, _cPerg)
			_oReport:PrintDialog()
		EndIf
	EndIf
Return

//+------------------------------------------------------------------------
Static Function ReportDef(_oReport, _cPerg)
	Local _cTitle  	:= 'Relatório de Pesquisa Fábrica'
	Local _cHelp   	:= 'Permite gerar relatório de Pesquisa Fábrica'
	Local _cAlias  	:= GetNextAlias()
	Local _oOP			:= Nil

	_oReport	:= TReport():New('M10R02   ',_cTitle,_cPerg,{|_oReport| ReportPrint(_oReport,_cAlias)},_cHelp)

	//+-------------------------------------------
	//|	Secao dos itens do Pedido de Vendas
	//+-------------------------------------------
	_oOP := TRSection():New(_oReport,'PESQUISA FÁBRICA',{_cAlias})
//	_oOP:lHeaderVisible := .T.
	TRcell():New(_oOP,'TIPO_VENDA'      , _cAlias)		// TIPO DE VENDA - GMUD 0002 #3881
	TRcell():New(_oOP,'ITEM_DESENV'     , _cAlias)      // ITEM DESENVOVLIDO - GMUD 0002 #3881
	TRCell():New(_oOP,'OF'				, _cAlias)		// OF
	TRCell():New(_oOP,'CHAVE'			, _cAlias)		// CHAVE
	TRCell():New(_oOP,'DATA_'			, _cAlias)		// DATA
	TRCell():New(_oOP,'TIPO'			, _cAlias)		// TIPO
	TRCell():New(_oOP,'PEDIDO'			, _cAlias)		// PEDIDO
	TRCell():New(_oOP,'CLIENTE'			, _cAlias)		// CLIENTE
	TRCell():New(_oOP,'NOME_FANTASIA'	, _cAlias)		// NOME_FANTASIA
	TRCell():New(_oOP,'ITEM'			, _cAlias)		// ITEM
	TRCell():New(_oOP,'CODIGO'			, _cAlias)		// COD
	TRCell():New(_oOP,'MEDIDAS'			, _cAlias)		// MEDIDAS
	TRCell():New(_oOP,'DESC'			, _cAlias)		// DESC
	TRCell():New(_oOP,'DESC_OF'			, _cAlias)		// DESC_OF
	TRCell():New(_oOP,'QTDE'			, _cAlias)		// QTDE
	TRCell():New(_oOP,'USR_ENG_SAI'		, _cAlias)		// USR_ENG_SAI
	TRCell():New(_oOP,'COMPLEMENTO'		, _cAlias)		// COMPLEMENTO
	TRCell():New(_oOP,'PRAZO'			, _cAlias)		// PRAZO
	TRCell():New(_oOP,'EMISSAO_OP'		, _cAlias)		// DATA_ENTRADA ALTERADO CHAMADO 975
	TRCell():New(_oOP,'ENG_S'			, _cAlias)		// DATA_OF ALTERADO CHAMADO 975
	TRCell():New(_oOP,'PCP_E'			, _cAlias)		// PCP_E
	TRCell():New(_oOP,'PCP_S'			, _cAlias)		// PCP_S
	TRCell():New(_oOP,'PRO_E'			, _cAlias)		// PRO_E 
	TRCell():New(_oOP,'PRO_S'			, _cAlias)		// DATA_LIBERACAO ALTERADO CHAMADO 975
	
	TRCell():New(_oOP,'SEP_E'			, _cAlias)		// SEP-E	#5175
	TRCell():New(_oOP,'SEP_S'			, _cAlias)		// SEP-S	#5175

	TRCell():New(_oOP,'CPC_E'			, _cAlias)		// CPC-E
	TRCell():New(_oOP,'CPC_S'			, _cAlias)		// CPC-S
	
	TRCell():New(_oOP,'DOB_E'			, _cAlias)		// DOB-E	#5175
	TRCell():New(_oOP,'DOB_S'			, _cAlias)		// DOB-S	#5175
	
	TRCell():New(_oOP,'TRI_E'			, _cAlias)		// PER_E 	#4542	#5175 TRI_E
	TRCell():New(_oOP,'TRI_S'			, _cAlias)		// PER_S 	#4542	#5175 TRI_S
	
	TRCell():New(_oOP,'PER_E'			, _cAlias)		// PER_E 	#5175
	TRCell():New(_oOP,'PER_S'			, _cAlias)		// PER_S 	#5175
	
	TRCell():New(_oOP,'MON_E'			, _cAlias)		// MON-E
	TRCell():New(_oOP,'MON_S'			, _cAlias)		// MON-S
	TRCell():New(_oOP,'INS_E'			, _cAlias)		// QUA_E	#4542
	TRCell():New(_oOP,'INS_S'			, _cAlias)		// QUA_S	#4542
	TRCell():New(_oOP,'EMB_E'			, _cAlias)		// EMB_E 	#4226
	TRCell():New(_oOP,'EMB_S'			, _cAlias)		// EMB_S	#4226

	TRCell():New(_oOP,'SUP_E'			, _cAlias)		// SUP_E 	#5175
	TRCell():New(_oOP,'SUP_S'			, _cAlias)		// SUP_S 	#5175


	TRCell():New(_oOP,'STATUS'			, _cAlias)		// STATUS
	TRCell():New(_oOP,'VALOR'			, _cAlias)		// VALOR

	TRCell():New(_oOP,'PICKINGLIST'		, _cAlias)		// PICKING LIST	#5706	

	_oOP:oReport:cFontBody 			:= 'Calibri'
	_oOP:oReport:nFontBody			:= 11

Return(_oReport)

//+------------------------------------------------------------------------
Static Function ReportPrint(_oReport,_cAlias)
	Private _oSection 		:= _oReport:Section(1)
	Private _cChave			:= ''

	_oReport:Section(1):Init()
	_oReport:IncMeter()

	M10RGetSC2(_cAlias,_oReport)
	//+-------------------------------------------
	//|	Inicio da impressao
	//+-------------------------------------------

	While !_oReport:Cancel() .And. (_cAlias)->(!EOF())
		_oReport:Section(1):Cell('MEDIDAS'			):SetBlock( {||CValToChar((_cAlias)->B5_COMPRLC) + 'x' + CValToChar((_cAlias)->B5_LARGLC) + 'x' + CValToChar((_cAlias)->B5_ALTURLC)						})
		_oReport:Section(1):Cell('MEDIDAS'			):SetBlock( {||CValToChar((_cAlias)->B5_COMPRLC) + 'x' + CValToChar((_cAlias)->B5_LARGLC) + 'x' + CValToChar((_cAlias)->B5_ALTURLC)						})
		_oReport:Section(1):Cell('CHAVE'			):SetBlock( {|| SubStr((_cAlias)->OF,1,6) + ';' + SubStr((_cAlias)->OF,7,2) 						})
		_oReport:Section(1):Cell('STATUS'			):SetBlock( {|| IIF((_cAlias)->QTDE - (_cAlias)->QUJE == 0,'ENCERRADA','ABERTA')   })
		_oReport:Section(1):PrintLine()

		_oReport:IncMeter()
		(_cAlias)->(DbSkip())
	EndDo

	_oReport:Section(1):Finish()

	(_cAlias)->(dbCloseArea())
return

//+------------------------------------------------------------------------
Static Function M10RGetSC2(_cAlias,_oReport)
	Local _nTotal			:= 0

	If MV_PAR05 = 1 // Abertas
		BeginSQL Alias _cAlias
			Column DATA_		 		as Date
			Column PRAZO		 		as Date
			Column EMISSAO_OP	 		as Date
			Column ENG_S 				as Date
			Column DATA_PRG 			as Date
			Column PCP_E				as Date
			Column PCP_S				as Date
			Column PRO_E		 		as Date	//#5175
			Column PRO_S		 		as Date
			Column SEP_E		 		as Date	//#5175
			Column SEP_S		 		as Date	//#5175
			Column CPC_E 				as Date
			Column CPC_S 				as Date		
			Column DOB_E 				as Date	//#5175
			Column DOB_S 				as Date	//#5175
			Column TRI_E				as Date // #4542 #5175
			Column TRI_S				as Date // #4542 #5175
			Column PER_E 				as Date	//#5175
			Column PER_S 				as Date	//#5175
			Column MON_E 				as Date
			Column MON_S 				as Date
			Column INS_E				as Date // #4542
			Column INS_S				as Date // #4542			
			Column EMB_E				as Date // #4226
			Column EMB_S				as Date // #4226
			Column SUP_E 				as Date	//#5175
			Column SUP_S 				as Date	//#5175

			Column EXPEDICAO 			as Date


			SELECT
					CASE //0002 #3881
						WHEN C5_XTPVEN = '1' THEN '1 - PROJETO'			
						WHEN C5_XTPVEN = '2' THEN '2 - VENDA UNITARIA'	
						WHEN C5_XTPVEN = '3' THEN '3 - DEALER'			
						WHEN C5_XTPVEN = '4' THEN '4 - E-COMMERCE'		
						WHEN C5_XTPVEN = '5' THEN '5 - PRONTA ENTREGA'	
						WHEN C5_XTPVEN = '6' THEN '6 - PROJETO-DEALER'	
						WHEN C5_XTPVEN = '7' THEN '7 - VENDA PECAS'		
						WHEN C5_XTPVEN = '8' THEN '8 - SUP TECNICO'		
						WHEN C5_XTPVEN = '9' THEN '9 - ARE'				
						WHEN C5_XTPVEN = '10' THEN '10 - SERVICO'		
						WHEN C5_XTPVEN = '11' THEN '11 - ITENS FALT'
						WHEN C5_XTPVEN = '12' THEN '12 - SAC'
						ELSE 'NÃO INDICADO ' 
					END AS 'TIPO_VENDA' 

					,B1_XITDESE										AS ITEM_DESENV 	//0002 #3881
					,C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		AS 'OF'
					,C5_EMISSAO 									AS DATA_
					,C5_NUM											AS PEDIDO
					,A1_NOME										AS CLIENTE
					,A1_NREDUZ										AS NOME_FANTASIA
					,C2_PRODUTO										AS CODIGO
					,B1_DESC										AS 'DESC'
					,C2_QUANT										AS QTDE
					,C2_QUJE										AS QUJE
					,C2_DATPRF										AS PRAZO
					,C2_EMISSAO										AS EMISSAO_OP
					,C2_XENGDTS										AS ENG_S
					,C2_XPPCDTE										AS PCP_E
					,C2_XPPCDTS										AS PCP_S
					,C2_XPCPDTE										AS PRO_E
					,C2_XPCPDTS										AS PRO_S
					,C2_XSEPDTE										AS SEP_E	//#5175
					,C2_XSEPDTS										AS SEP_S	//#5175
					,C2_XCPCDTE										AS CPC_E
					,C2_XCPCDTS										AS CPC_S
					,C2_XDOBDTE										AS DOB_E	//#5175
					,C2_XDOBDTS										AS DOB_S	//#5175
					,C2_XTRIDTE  									AS TRI_E	// #4542	#5175
					,C2_XTRIDTS 									AS TRI_S 	// #4542	#5175
					,C2_XPERDTE										AS PER_E	//#5175
					,C2_XPERDTS										AS PER_S	//#5175
					,C2_XMONDTE										AS MON_E
					,C2_XMONDTS										AS MON_S
					,C2_XQLDDTE 									AS INS_E 	// #4542
					,C2_XQLDDTS 									AS INS_S 	// #4542
					,C2_XEMBDTE										AS EMB_E 	// #4226
					,C2_XEMBDTS										AS EMB_S 	// #4226
					,C2_XSUPDTE										AS SUP_E	//#5175
					,C2_XSUPDTS										AS SUP_S	//#5175

					,C2_XEXPDT										AS EXPEDICAO
					,'PADRÃO'										AS TIPO
					,C6_ITEM
					,C5_NUM
					,B5_COMPRLC
					,B5_LARGLC
					,B5_ALTURLC
					,CK_XITEMP										
					,C2_ITEM										AS ITEM
					,C2_XOBSENG                                     AS DESC_OF
					,C2_XENGUSS										AS USR_ENG_SAI
					,C6_VALOR										AS VALOR
					
					
					,CASE
						WHEN B1_XPICLIS = '1'THEN '1 - SIM'
						WHEN B1_XPICLIS = '2' THEN '2 - NÃO'
						ELSE 'NÃO INDICADO'
					END AS PICKINGLIST


			FROM %Table:SC2% SC2

			LEFT JOIN %Table:SC6% SC6
					ON SC6.%NotDel%
					AND C6_FILIAL = %xFilial:SC6%
					AND C6_NUM = C2_PEDIDO
					AND C6_ITEM = C2_ITEMPV
			LEFT JOIN %Table:SC5% SC5
					ON SC5.%NotDel%
					AND C5_FILIAL = %xFilial:SC5%
					AND C5_NUM = C6_NUM
			LEFT JOIN %Table:SA1% SA1
					ON SA1.%NotDel%
					AND A1_FILIAL = %xFilial:SA1%
					AND A1_COD    = C5_CLIENTE
					AND A1_LOJA	= C5_LOJACLI
			LEFT JOIN %Table:SB1% SB1
					ON SB1.%NotDel%
					AND B1_FILIAL = %xFilial:SB1%
					AND B1_COD    = C2_PRODUTO
			LEFT JOIN %Table:SB5% SB5
					ON SB5.%NotDel%
					AND B5_FILIAL  = %xFilial:SB5%
					AND B5_COD = C2_PRODUTO
			LEFT JOIN %Table:SCK% SCK
					ON SCK.%NotDel%
					AND CK_FILIAL = %xFilial:ZCK%
					AND CK_NUMPV   = C5_NUM
					AND CK_PRODUTO = C2_PRODUTO
					AND CK_XITEMP  = C6_XITEMP
					AND C6_ITEM    = CK_ITEM
			WHERE 	SC2.%NotDel%
				AND C2_FILIAL    = %xFilial:SC2%
				AND C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND C2_EMISSAO 	BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				// Abertas
				AND C2_TPOP = 'F'
				AND C2_DATRF = ''
				AND C2_QUJE < C2_QUANT 

				ORDER BY 'OF'
		EndSql
	ElseIf MV_PAR05 = 2 // Fechadas
		BeginSQL Alias _cAlias
			Column DATA_		 		as Date
			Column PRAZO		 		as Date
			Column EMISSAO_OP	 		as Date
			Column ENG_S 				as Date
			Column DATA_PRG 			as Date
			Column PCP_E				as Date
			Column PCP_S				as Date
			Column PRO_E		 		as Date	//#5175
			Column PRO_S		 		as Date
			Column SEP_E		 		as Date	//#5175
			Column SEP_S		 		as Date	//#5175
			Column CPC_E 				as Date
			Column CPC_S 				as Date		
			Column DOB_E 				as Date	//#5175
			Column DOB_S 				as Date	//#5175
			Column TRI_E				as Date // #4542 #5175
			Column TRI_S				as Date // #4542 #5175
			Column PER_E 				as Date	//#5175
			Column PER_S 				as Date	//#5175
			Column MON_E 				as Date
			Column MON_S 				as Date
			Column INS_E				as Date // #4542
			Column INS_S				as Date // #4542			
			Column EMB_E				as Date // #4226
			Column EMB_S				as Date // #4226
			Column SUP_E 				as Date	//#5175
			Column SUP_S 				as Date	//#5175


			Column EXPEDICAO 			as Date
			
			SELECT
					CASE 														//0002 #3881
						WHEN C5_XTPVEN = '1' THEN '1 - PROJETO'			
						WHEN C5_XTPVEN = '2' THEN '2 - VENDA UNITARIA'	
						WHEN C5_XTPVEN = '3' THEN '3 - DEALER'			
						WHEN C5_XTPVEN = '4' THEN '4 - E-COMMERCE'		
						WHEN C5_XTPVEN = '5' THEN '5 - PRONTA ENTREGA'	
						WHEN C5_XTPVEN = '6' THEN '6 - PROJETO-DEALER'	
						WHEN C5_XTPVEN = '7' THEN '7 - VENDA PECAS'		
						WHEN C5_XTPVEN = '8' THEN '8 - SUP TECNICO'		
						WHEN C5_XTPVEN = '9' THEN '9 - ARE'				
						WHEN C5_XTPVEN = '10' THEN '10 - SERVICO'		
						WHEN C5_XTPVEN = '11' THEN '11 - ITENS FALT'	
						WHEN C5_XTPVEN = '12' THEN '12 - SAC'	
						ELSE 'NÃO INDICADO ' 
					END AS 'TIPO_VENDA'                                            
			
				
					,B1_XITDESE										AS ITEM_DESENV 	//0002 #3881
					,C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		AS 'OF'
					,C5_EMISSAO 									AS DATA_
					,C5_NUM											AS PEDIDO
					,A1_NOME										AS CLIENTE
					,A1_NREDUZ										AS NOME_FANTASIA
					,C2_PRODUTO										AS CODIGO
					,B1_DESC										AS 'DESC'
					,C2_QUANT										AS QTDE
					,C2_QUJE										AS QUJE
					,C2_DATPRF										AS PRAZO
					,C2_EMISSAO										AS EMISSAO_OP
					,C2_XENGDTS										AS ENG_S
					,C2_XPPCDTE										AS PCP_E
					,C2_XPPCDTS										AS PCP_S
					,C2_XPCPDTE										AS PRO_E
					,C2_XPCPDTS										AS PRO_S
					,C2_XSEPDTE										AS SEP_E	//#5175
					,C2_XSEPDTS										AS SEP_S	//#5175
					,C2_XCPCDTE										AS CPC_E
					,C2_XCPCDTS										AS CPC_S
					,C2_XDOBDTE										AS DOB_E	//#5175
					,C2_XDOBDTS										AS DOB_S	//#5175
					,C2_XTRIDTE  									AS TRI_E	// #4542	#5175
					,C2_XTRIDTS 									AS TRI_S 	// #4542	#5175
					,C2_XPERDTE										AS PER_E	//#5175
					,C2_XPERDTS										AS PER_S	//#5175
					,C2_XMONDTE										AS MON_E
					,C2_XMONDTS										AS MON_S
					,C2_XQLDDTE 									AS INS_E 	// #4542
					,C2_XQLDDTS 									AS INS_S 	// #4542
					,C2_XEMBDTE										AS EMB_E 	// #4226
					,C2_XEMBDTS										AS EMB_S 	// #4226
					,C2_XSUPDTE										AS SUP_E	//#5175
					,C2_XSUPDTS										AS SUP_S	//#5175

					,C2_XEXPDT										AS EXPEDICAO
					,'PADRÃO'										AS TIPO
					,C6_ITEM
					,C5_NUM
					,B5_COMPRLC
					,B5_LARGLC
					,B5_ALTURLC
					,CK_XITEMP										
					,C2_ITEM										AS ITEM
					,C2_XOBSENG                                     AS DESC_OF
					,C2_XENGUSS										AS USR_ENG_SAI
					,C6_VALOR										AS VALOR

					
					,CASE
						WHEN B1_XPICLIS = '1' THEN '1 - SIM'
						WHEN B1_XPICLIS = '2' THEN '2 - NÃO'
						ELSE 'NÃO INDICADO'
					END AS PICKINGLIST
			
					
			FROM %Table:SC2% SC2

			LEFT JOIN %Table:SC6% SC6
					ON SC6.%NotDel%
					AND C6_FILIAL = %xFilial:SC6%
					AND C6_NUM = C2_PEDIDO
					AND C6_ITEM = C2_ITEMPV
			LEFT JOIN %Table:SC5% SC5
					ON SC5.%NotDel%
					AND C5_FILIAL = %xFilial:SC5%
					AND C5_NUM = C6_NUM
			LEFT JOIN %Table:SA1% SA1
					ON SA1.%NotDel%
					AND A1_FILIAL = %xFilial:SA1%
					AND A1_COD    = C5_CLIENTE
					AND A1_LOJA	= C5_LOJACLI
			LEFT JOIN %Table:SB1% SB1
					ON SB1.%NotDel%
					AND B1_FILIAL = %xFilial:SB1%
					AND B1_COD    = C2_PRODUTO
			LEFT JOIN %Table:SB5% SB5
					ON SB5.%NotDel%
					AND B5_FILIAL  = %xFilial:SB5%
					AND B5_COD = C2_PRODUTO
			LEFT JOIN %Table:SCK% SCK
					ON SCK.%NotDel%
					AND CK_FILIAL = %xFilial:ZCK%
					AND CK_NUMPV   = C5_NUM
					AND CK_PRODUTO = C2_PRODUTO
					AND CK_XITEMP  = C6_XITEMP
					AND C6_ITEM    = CK_ITEM
			WHERE 	SC2.%NotDel%
				AND C2_FILIAL    = %xFilial:SC2%
				AND C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND C2_EMISSAO 	BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				
				AND C2_TPOP = 'F'
				AND C2_DATRF <> ''
				AND C2_QUANT - C2_QUJE = 0

				ORDER BY 'OF'
		EndSql
	Else
		BeginSQL Alias _cAlias
			
			Column DATA_		 		as Date
			Column PRAZO		 		as Date
			Column EMISSAO_OP	 		as Date
			Column ENG_S 				as Date
			Column DATA_PRG 			as Date
			Column PCP_E				as Date
			Column PCP_S				as Date
			Column PRO_E		 		as Date	//#5175
			Column PRO_S		 		as Date
			Column SEP_E		 		as Date	//#5175
			Column SEP_S		 		as Date	//#5175
			Column CPC_E 				as Date
			Column CPC_S 				as Date		
			Column DOB_E 				as Date	//#5175
			Column DOB_S 				as Date	//#5175
			Column TRI_E				as Date // #4542 #5175
			Column TRI_S				as Date // #4542 #5175
			Column PER_E 				as Date	//#5175
			Column PER_S 				as Date	//#5175
			Column MON_E 				as Date
			Column MON_S 				as Date
			Column INS_E				as Date // #4542
			Column INS_S				as Date // #4542			
			Column EMB_E				as Date // #4226
			Column EMB_S				as Date // #4226
			Column SUP_E 				as Date	//#5175
			Column SUP_S 				as Date	//#5175
			Column EXPEDICAO 			as Date

			SELECT
					CASE //0002 #3881
						WHEN C5_XTPVEN = '1' THEN '1 - PROJETO'			
						WHEN C5_XTPVEN = '2' THEN '2 - VENDA UNITARIA'	
						WHEN C5_XTPVEN = '3' THEN '3 - DEALER'			
						WHEN C5_XTPVEN = '4' THEN '4 - E-COMMERCE'		
						WHEN C5_XTPVEN = '5' THEN '5 - PRONTA ENTREGA'	
						WHEN C5_XTPVEN = '6' THEN '6 - PROJETO-DEALER'	
						WHEN C5_XTPVEN = '7' THEN '7 - VENDA PECAS'		
						WHEN C5_XTPVEN = '8' THEN '8 - SUP TECNICO'		
						WHEN C5_XTPVEN = '9' THEN '9 - ARE'				
						WHEN C5_XTPVEN = '10' THEN '10 - SERVICO'		
						WHEN C5_XTPVEN = '11' THEN '11 - ITENS FALT'	
						WHEN C5_XTPVEN = '12' THEN '12 - SAC'	
						ELSE 'NÃO INDICADO ' 
					END AS 'TIPO_VENDA'     

							
					,B1_XITDESE										AS ITEM_DESENV 	//0002 #3881
					,C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		AS 'OF'
					,C5_EMISSAO 									AS DATA_
					,C5_NUM											AS PEDIDO
					,A1_NOME										AS CLIENTE
					,A1_NREDUZ										AS NOME_FANTASIA
					,C2_PRODUTO										AS CODIGO
					,B1_DESC										AS 'DESC'
					,C2_QUANT										AS QTDE
					,C2_QUJE										AS QUJE
					,C2_DATPRF										AS PRAZO
					,C2_EMISSAO										AS EMISSAO_OP
					,C2_XENGDTS										AS ENG_S
					,C2_XPPCDTE										AS PCP_E
					,C2_XPPCDTS										AS PCP_S
					,C2_XPCPDTE										AS PRO_E
					,C2_XPCPDTS										AS PRO_S
					,C2_XSEPDTE										AS SEP_E	//#5175
					,C2_XSEPDTS										AS SEP_S	//#5175
					,C2_XCPCDTE										AS CPC_E
					,C2_XCPCDTS										AS CPC_S
					,C2_XDOBDTE										AS DOB_E	//#5175
					,C2_XDOBDTS										AS DOB_S	//#5175
					,C2_XTRIDTE  									AS TRI_E	// #4542	#5175
					,C2_XTRIDTS 									AS TRI_S 	// #4542	#5175
					,C2_XPERDTE										AS PER_E	//#5175
					,C2_XPERDTS										AS PER_S	//#5175
					,C2_XMONDTE										AS MON_E
					,C2_XMONDTS										AS MON_S
					,C2_XQLDDTE 									AS INS_E 	// #4542
					,C2_XQLDDTS 									AS INS_S 	// #4542
					,C2_XEMBDTE										AS EMB_E 	// #4226
					,C2_XEMBDTS										AS EMB_S 	// #4226
					,C2_XSUPDTE										AS SUP_E	//#5175
					,C2_XSUPDTS										AS SUP_S	//#5175

					,C2_XEXPDT										AS EXPEDICAO
					,'PADRÃO'										AS TIPO
					,C6_ITEM
					,C5_NUM
					,B5_COMPRLC
					,B5_LARGLC
					,B5_ALTURLC
					,CK_XITEMP										
					,C2_ITEM										AS ITEM
					,C2_XOBSENG                                     AS DESC_OF
					,C2_XENGUSS										AS USR_ENG_SAI
					,C6_VALOR										AS VALOR

					
					,CASE
						WHEN B1_XPICLIS = '1' THEN '1 - SIM'
						WHEN B1_XPICLIS = '2' THEN '2 - NÃO'
						ELSE 'NÃO INDICADO'
					END AS PICKINGLIST		
					
			FROM %Table:SC2% SC2

			LEFT JOIN %Table:SC6% SC6
					ON SC6.%NotDel%
					AND C6_FILIAL = %xFilial:SC6%
					AND C6_NUM = C2_PEDIDO
					AND C6_ITEM = C2_ITEMPV
			LEFT JOIN %Table:SC5% SC5
					ON SC5.%NotDel%
					AND C5_FILIAL = %xFilial:SC5%
					AND C5_NUM = C6_NUM
			LEFT JOIN %Table:SA1% SA1
					ON SA1.%NotDel%
					AND A1_FILIAL = %xFilial:SA1%
					AND A1_COD    = C5_CLIENTE
					AND A1_LOJA	= C5_LOJACLI
			LEFT JOIN %Table:SB1% SB1
					ON SB1.%NotDel%
					AND B1_FILIAL = %xFilial:SB1%
					AND B1_COD    = C2_PRODUTO
			LEFT JOIN %Table:SB5% SB5
					ON SB5.%NotDel%
					AND B5_FILIAL  = %xFilial:SB5%
					AND B5_COD = C2_PRODUTO
			LEFT JOIN %Table:SCK% SCK
					ON SCK.%NotDel%
					AND CK_FILIAL = %xFilial:ZCK%
					AND CK_NUMPV   = C5_NUM
					AND CK_PRODUTO = C2_PRODUTO
					AND CK_XITEMP  = C6_XITEMP
					AND C6_ITEM    = CK_ITEM
			WHERE 	SC2.%NotDel%
				AND C2_FILIAL    = %xFilial:SC2%
				AND C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD 		BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND C2_EMISSAO 	BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%

				ORDER BY 'OF'
		EndSql
	Endif

	// Atualiza regua de processamento
	(_cAlias)->( dbEval( {|| _nTotal++ } ) )
	(_cAlias)->( dbGoTop() )

	_oReport:SetMeter(_nTotal)
Return

//+------------------------------------------------------------------------
Static Function M0RValid()
	Local _lExit 			:= .F.
	Local _aCpSC2			:= {'C2_XENGDTS','C2_XPCPDTE','C2_XPCPDTS','C2_XMONDTS','C2_XMONDTE','C2_XCPCDTS','C2_XCPCDTE','C2_XEXPDT'}
	Local _nX				:= 0


	For _nX := 1 To Len(_aCpSC2)
		If (_lExit := SC2->(FieldPos(_aCpSC2[_nX])) == 0 )
			MsgStop('Campo customizado ' + _aCpSC2[_nX] + ' não encontrado.' + CRLF + 'Relatório não pode ser executado!')
			Exit
		EndIf
	Next

Return !_lExit
//+------------------------------------------------------------------------
Static Function AtuSX1(_cPerg)
	Local _aAreaSX1 	:= SX1->(GetArea())

	SX1->(DbGoTop())
	SX1->(DbSetOrder(1))

	If !SX1->(DbSeek(_cPerg))
		PutSX1(_cPerg,'01','OP De ?'		,'OP De ?'			,'OP De ?'			,'mv_ch1','C',13,0, ,'G','','SC2',,,'mv_par01',,,,Space(13))
		PutSX1(_cPerg,'02','OP Ate ?'		,'OP Ate ?'			,'OP Ate ?'			,'mv_ch2','C',13,0, ,'G','','SC2',,,'mv_par02',,,,Replicate('Z',13))
		PutSX1(_cPerg,'03','Data De ?'		,'Data De ?'		,'Data De ?'		,'mv_ch3','D',08,0, ,'G','','   ',,,'mv_par03',,,,)
		PutSX1(_cPerg,'04','Data Ate ?'		,'Data Ate ?'		,'Data Ate ?'		,'mv_ch4','D',08,0, ,'G','','   ',,,'mv_par04',,,,)
	EndIf

	RestArea(_aAreaSX1)
Return
