#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Include "RESTFUL.Ch"

#DEFINE cEnt Chr(10)+ Chr(13)

//*************
// PostAdiantamento
//*************

WsRestFul PostAdiantamento Description "Metodo Responsavel por fazer inserções dos títulos de adiantamento"

	WsData cIdRotina As String

	WsMethod Post Description "Inserção de adiantamento" WsSyntax "/PostAdiantamento"

End WsRestFul

WsMethod Post WsReceive cIdRotina WsService PostAdiantamento

	Local nValTot	:= 0
	Local _nErro	:= 0
	Local cBody     := ::GetContent()
	Local aContas	:= {}
	Local aPercs	:= {}
	Local aRecs		:= {}
	Local cJson 	:= ""
	Local aArray	:= {}

	Private lMsHelpAuto		:= .T.
	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile 	:= .T.
	Private oJsoAux

	RpcSetEnv("01","01")

	If Empty(cBody)
		cJson := '{"error": "Conteudo Json invalido.","lret":false}'
		::SetResponse( cJson )
		Return .T.
	EndIf

	FWJsonDeserialize(cBody, @oJsoAux)

	Pergunte("FIN050",.F.)
	MV_PAR01 := 2
	MV_PAR04 := 2

	DbSelectArea("SA2")
	SA2->(DbsetOrder(3))

	IF SA2->(DBSEEK(xFilial("SA2") + oJsoAux:cpf))

		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))

		//Se ja existir titulo aborta o processo
		If SE2->(DbSeek(xFilial("SE2") + "CDP" + cvaltochar(oJsoAux:idrelatoriodespesa) ))
			cJson := '{"message": "Titulo já incluso.","lret":true}'
			::SetResponse( cJson )
			Return(.T.)
		EndIf

		aAdd(aArray,{ "E2_PREFIXO"  , "CDP"                                           	, NIL })
		aAdd(aArray,{ "E2_NUM"      , cvaltochar(oJsoAux:idrelatoriodespesa)       		, NIL })
		aAdd(aArray,{ "E2_TIPO"     , "PA"                                            	, NIL })
		aAdd(aArray,{ "E2_NATUREZ"  , SA2->A2_NATUREZ                                  	, NIL })
		aAdd(aArray,{ "E2_FORNECE"  , SA2->A2_COD                                     	, NIL })
		aAdd(aArray,{ "E2_EMISSAO"  , ctod(oJsoAux:datadespesaaprovacaoformatada) 		, NIL })
		aAdd(aArray,{ "E2_VENCTO"   , ctod(oJsoAux:vencimento)                         	, NIL })
		aAdd(aArray,{ "E2_VENCREA"  , DataValida(ctod(oJsoAux:vencimento), .T.)    		, NIL })
		aAdd(aArray,{ "E2_VLCRUZ"	, oJsoAux:valordespesa                        		, NIL })
		aAdd(aArray,{ "E2_FORBCO"	, SA2->A2_BANCO                                   	, NIL })
		aAdd(aArray,{ "E2_FORAGE"	, SA2->A2_AGENCIA                                 	, NIL })
		aAdd(aArray,{ "E2_FAGEDV"	, SA2->A2_DVAGE                                   	, NIL })
		aAdd(aArray,{ "E2_FORCTA"	, SA2->A2_NUMCON                                  	, NIL })
		aAdd(aArray,{ "E2_FCTADV"	, SA2->A2_DVCTA                                   	, NIL })
		aAdd(aArray,{ "E2_HIST" 	, oJsoAux:historico           						, Nil })
		aAdd(aArray,{ "E2_CCUSTO"	, oJsoAux:centrodecusto                    			, NIL })
		aAdd(aArray,{ "E2_VALOR"    , oJsoAux:valordespesa                        		, NIL })
		aAdd(aArray,{ "E2_XIDADT"   , cValToChar(oJsoAux:iddespesa)                		, NIL })
		aAdd(aArray,{ "AUTBANCO" 	, SA2->A2_BANCO2         							, NIL })
		aAdd(aArray,{ "AUTAGENCIA" 	, avKey(SA2->A2_AGENCI2,"A6_AGENCIA")             	, NIL })
		aAdd(aArray,{ "AUTCONTA" 	, avKey(SA2->A2_NUMCO2,"A6_NUMCON")		           	, NIL })

		aArea := FWGetArea()

		lMsErroAuto := .F.
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)

		If lMsErroAuto

			_cStrErro	:= ""
			_aErros 	:= GetAutoGRLog()
			_nErro   	:= Ascan(_aErros, {|x| "INVALIDO" $ AllTrim(Upper(x))  } )

			If _nErro > 0
				_cStrErro += _aErros[ _nErro ]

			Else
				For _nErro := 1 To Len( _aErros )
					_cStrErro += ( _aErros[ _nErro ] + cEnt )
				Next _nErro

			EndIf

			_cStrErro := Alltrim(_cStrErro)

			cJson := '{'
			cJson += '"message":"' + "Erro de ExecAuto Id = " + _cStrErro + '",'
			cJson += '"lret":false'
			cJson += "}"

		Else

			cJson := '{'
			cJson += '"message":"Título incluso com sucesso: ' + SE2->E2_NUM + '",'
			cJson += '"lret":true'
			cJson += "}"

		EndIf

	Else

		cJson := '{'
		cJson += '"message":"Fornecedor não localizado.",'
		cJson += '"lret":false'
		cJson += "}"

	EndIf

	aContas 		:= {}
	aRecs 			:= {}
	aPercs			:= {}
	nValTot			:= 0
	lMsErroAuto 	:= .F.

	If DecodeUtf8(cJson) <> Nil
		cJson := DecodeUtf8(cJson)
	EndIf

	::SetResponse( cJson )

Return(.T.)

//*************
// PostDespesa
//*************

WsRestFul PostDespesa Description "Metodo Responsavel por fazer inserções dos títulos de despesas"

	WsData cIdRotina As String

	WsMethod Post Description "Inserção de despesas" WsSyntax "/PostDespesa"

End WsRestFul

WsMethod Post WsReceive cIdRotina WsService PostDespesa

Local cBody     := ::GetContent()
Local nValTot	:= 0
Local _nErro	:= 0
Local aContas	:= {}
Local aPercs	:= {}
Local aRecs		:= {}
Local cJson     := ""
Local aSE2      := {}
Local nZ        := 0
Local nH 		:= 0
Local cCusto	:= ""
Local dDtGuard	:= dDataBase

Private lMsHelpAuto		:= .T.
Private lMsErroAuto 	:= .F.
Private lAutoErrNoFile 	:= .T.
Private nValor      := 0
Private aRatAll     := {}
Private oJsoAux

	If Empty(cBody)
		cJson := '{"error": "Conteudo Json invalido.","lret":false}'
		::SetResponse( cJson )
		Return .T.
	EndIf

	FWJsonDeserialize(cBody, @oJsoAux)

	Pergunte("FIN050",.F.)
	MV_PAR01 := 2
	MV_PAR04 := 2

	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))

	//Se ja existir titulo aborta o processo
	If SE2->(DbSeek(xFilial("SE2") + oJsoAux:prefixo  + cvaltochar(oJsoAux:idRelatorio) ))
		cJson := '{"message": "Titulo já incluso.","lret":true}'
		::SetResponse( cJson )
		Return(.T.)
	EndIf

	dDataBase := CTOD(oJsoAux:emissao)

	dbSelectArea("SA2")
	SA2->(dbSetOrder(3))

	SA2->(dbGoTop())
	If SA2->( DbSeek(xFilial("SA2") + oJsoAux:cpf ))

		nPosNat		:= 0
		nValTot  	:= 0
		cAuxNat		:= ""
		nEntAux		:= 0
		nPrcAux 	:= 0
		aRatEvEz	:= {}
		aAuxEz		:= {}
		aRatEz		:= {}
		lDespesas	:= .T.

		//Se não for array de despesas
		If AttIsMemberOf(oJsoAux, "despesas")

			//Monta o valor total do título
			For nZ := 1 To Len(oJsoAux:despesas)

				nValTot += oJsoAux:despesas[nZ]:VALORDESPESA

			Next nZ

			For nZ := 1 To Len(oJsoAux:despesas)

				nPercent := (oJsoAux:despesas[nZ]:VALORDESPESA	* 100) / nValtot

				aAuxEv	:= {}

				nEntAux := oJsoAux:despesas[nZ]:VALORDESPESA
				nPrcAux := nPercent

				aadd( aAuxEv ,{"EV_NATUREZ" , oJsoAux:despesas[nZ]:natureza			, Nil })//natureza a ser rateada 400212, 400214
				aadd( aAuxEv ,{"EV_VALOR" 	, oJsoAux:despesas[nZ]:VALORDESPESA		, Nil })//valor do rateio na natureza
				aadd( aAuxEv ,{"EV_PERC" 	, nPercent								, Nil })//percentual do rateio na natureza
				aadd( aAuxEv ,{"EV_RATEICC" , "1"									, Nil })//indicando que hÃ¡ rateio por centro de custo

				aCusto := Strtokarr2( oJsoAux:despesas[nZ]:CENTROCUSTO, ";", .T.)

				lPassou := .F.
				
				For nH := 1 to len(aCusto)

					If Empty(aCusto[nH])
						Loop
					EndIf
				
					cAux		:= StrTran(aCusto[nH], ";" ,"")
					cCusto		:= SUBSTR(cAux, 1, at('-', cAux) - 1)
					nRatPerc	:= Val(SUBSTR(cAux, at('-', cAux) + 1, Len(cAux)))

					aAuxEz := {}

					aadd( aAuxEz ,{"EZ_CONTA"	, oJsoAux:despesas[nZ]:CONTACONTABIL										, Nil })//conta contÃ¡bil na natureza   322020019 ,322020017 ,322020006
					aadd( aAuxEz ,{"EZ_CCUSTO"	, SUBSTR(cAux, 1, at('-', cAux) - 1)										, Nil })//centro de custo na natureza 50502001, 50502001, 50502001

					If nRatPerc <> 100	
						aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100) , Nil })//valor do rateio neste centro de custo
					Else
						aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA, Nil })//valor do rateio neste centro de custo
					EndIf
					
					aadd( aAuxEz ,{"CHAVE"		, oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1)	, Nil })//Chave auxiliar para não repetir entidades

					If AttIsMemberOf(oJsoAux:despesas[nZ], "ITEM")
						
						If !Empty(oJsoAux:despesas[nZ]:ITEM)
							
							aItem := Strtokarr2( oJsoAux:despesas[nZ]:ITEM, ";", .T.)
							
							aadd( aAuxEz ,{"EZ_ITEMCTA"	, aItem[nH], Nil }) //item contabil
							
						EndIf

					EndIf

					aadd(aRatEz,aAuxEz)

					If len(aRatEvEz) > 0

						nPosNat := aScan(aRatEvEz, {|x| Alltrim(x[1][2]) == oJsoAux:despesas[nZ]:natureza})

						If nPosNat > 0

							//Se for uma posição só não pode passar novamente
							If nZ > 1
							
								If nRatPerc <> 100
									aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100)
								Else	
									aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA
								EndIf

							EndIf
							
							If !lPassou
								aRatEvEz[nPosNat][3][2] += nPercent
								lPassou := .T.
							EndIf

							nPosChv := aScan(aRatEvEz[nPosNat][5][2], {|x| Alltrim(x[4][2]) == oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1) })

							If nPosChv > 0
								If nRatPerc <> 100
									aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100)
								Else	
									aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA
								EndIf
							Else
								AADD(aRatEvEz[nPosNat][5][2], aAuxEz)
							EndIf

							aRatEz := {}

						Else
							
							aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
							
							If nRatPerc <> 100	
								
								nValNat := aScan(aAuxEv, {|x| Alltrim(x[1]) == "EV_VALOR"})

								aAuxEv[nValNat][2] := aAuxEv[nValNat][2] * (nRatPerc / 100)

							EndIf

							aAdd(aRatEvEz,aAuxEv)

							lPassou := .T.

							aRatEz := {}

						EndIf

					Else
						aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
						aAdd(aRatEvEz,aAuxEv)
						aRatEz := {}
						lPassou := .T.
					EndIf

				Next nH

				cAuxNat := oJsoAux:despesas[nZ]:natureza

			Next nZ

		Else
			nValTot		:= oJsoAux:valorDespesa
			lDespesas 	:= .F.
		EndIf

		aAdd(aSE2, {"E2_FILIAL" , FWxFilial("SE2")          					, Nil})
		aAdd(aSE2, {"E2_NUM"    , oJsoAux:idRelatorio     						, Nil})
		aAdd(aSE2, {"E2_PREFIXO", oJsoAux:prefixo		        				, Nil})
		aAdd(aSE2, {"E2_PARCELA", oJsoAux:parcela         						, Nil})
		aAdd(aSE2, {"E2_TIPO"   , oJsoAux:tipo            						, Nil})
		aAdd(aSE2, {"E2_NATUREZ", oJsoAux:natureza        						, Nil})
		aAdd(aSE2, {"E2_FORNECE", SA2->A2_COD               					, Nil})
		aAdd(aSE2, {"E2_LOJA"   , SA2->A2_LOJA              					, Nil})
		aAdd(aSE2, {"E2_NOMFOR" , SA2->A2_NOME              					, Nil})
		aAdd(aSE2, {"E2_EMISSAO", CTOD(oJsoAux:emissao)        					, Nil})
		aAdd(aSE2, {"E2_VENCTO" , ctod(oJsoAux:vencimento)     					, Nil})
		aAdd(aSE2, {"E2_VENCREA", DataValida(ctod(oJsoAux:vencimento), .T.)		, Nil})
		aAdd(aSE2, {"E2_VALOR"  , nValTot                     					, Nil})
		aAdd(aSE2, {"E2_HIST" 	, oJsoAux:historico           					, Nil})
		aAdd(aSE2, {"E2_CCUSTO" , cCusto			           					, Nil})
		aAdd(aSE2, {"E2_MOEDA"  , 1                         					, Nil})
		aAdd(aSE2, {"E2_MULTNAT", "1"                        					, Nil})
		aAdd(aSE2, {"E2_XIDREL"	, oJsoAux:idRelatorio     						, Nil})

		If lDespesas
			aAdd(aSE2,{"AUTRATEEV", aRatEvEz, Nil}) //adicionando ao vetor aCab o vetor do rateio
		EndIf

		aSE2 := FWVetByDic(aSE2,"SE2",.F.)
		//Execução da operação de inclusão no FINA050
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 3)

		If lMsErroAuto

			_cStrErro	:= ""
			_aErros 	:= GetAutoGRLog()
			_nErro   	:= Ascan(_aErros, {|x| "INVALIDO" $ AllTrim(Upper(x))  } )

			If _nErro > 0
				_cStrErro += _aErros[ _nErro ]

			Else
				For _nErro := 1 To Len( _aErros )
					_cStrErro += ( _aErros[ _nErro ] + cEnt )
				Next _nErro

			EndIf

			_cStrErro := Alltrim(_cStrErro)

			cJson := '{'
			cJson += '"message":"' + "Erro de ExecAuto Id = " + _cStrErro + '",'
			cJson += '"lret":false'
			cJson += "}"

		Else

			cJson := '{'
			cJson += '"message":"Título incluso com sucesso: ' + SE2->E2_NUM + '",'
			cJson += '"lret":true'
			cJson += "}"

		EndIf
	Else

		cJson := '{'
		cJson += '"message":"Fornecedor não localizado.",'
		cJson += '"lret":false'
		cJson += "}"

	EndIF

	aContas 		:= {}
	aRecs 			:= {}
	aPercs			:= {}
	nValTot			:= 0
	lMsErroAuto 	:= .F.

	If DecodeUtf8(cJson) <> Nil
		cJson := DecodeUtf8(cJson)
	EndIf

	::SetResponse( cJson )

	dDataBase := dDtGuard

Return(.T.)

//*************
// GetBaixa
//*************

WsRestFul GetBaixaExp Description "Metodo Responsavel por Retornar os tï¿½tulos baixados"

	WsData cCgcEmp 	As String Optional
	WsData nOpcao 	As Integer

	WsMethod Get Description "Consulta de baixas" WsSyntax "/GetBaixaExp"

End WsRestFul

WsMethod Get WsReceive cCgcEmp,nOpcao WsService GetBaixaExp

	Local cQuery	:= ""
	Local cAlsQry	:= ""
	Local cJson		:= ""
	Local cTamFil	:= cValToChar(TamSX3("EZ_FILIAL")[1])
	Local nOpcao	:= IIf(::nOpcao <> Nil, ::nOpcao, 1)

	cAlsQry := CriaTrab(Nil,.F.)

	cQuery := " SELECT E2_XIDADT AS IDEXPENSE, E2_XIDREL AS IDREL, PR2.R_E_C_N_O_ RECNO FROM " + RetSqlName("PR2") + " PR2 "
	cQuery += " INNER JOIN " + RetSqlName("SE2") + " SE2 "
	cQuery += " ON E2_FILIAL = SUBSTRING(PR2_CHAVE,1," + cTamFil + ") AND E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO = PR2_CHAVE "
	cQuery += " WHERE "
	cQuery += " PR2_STINT = 'P' AND PR2_ALIAS = 'SE2' "

	If nOpcao == 1
		cQuery += " AND E2_XIDREL <> ' ' "
	Else
		cQuery += " AND E2_XIDADT <> ' ' "
	EndIf

	cQuery += " AND PR2.D_E_L_E_T_ = ' ' "


	If Select(cAlsQry) > 0; (cAlsQry)->(dbCloseArea()); Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsQry,.T.,.T.)

	If !(cAlsQry)->(Eof())
		cJson += '{"baixas":['
		While !(cAlsQry)->(Eof())

			cJson += '{'
			cJson += '"idAdt":"' + Alltrim((cAlsQry)->IDEXPENSE) + '",'
			cJson += '"idRel":"' + Alltrim((cAlsQry)->IDREL) + '",'
			cJson += '"RECNO":"' + cValToChar((cAlsQry)->RECNO) + '",'
			cJson += '"data":"' + FWTimeStamp(1, dDataBase) + '"'
			cJson += '},'

			(cAlsQry)->(DbSkip())

		End

		cJson := Left(cJson, Rat(",", cJson)-1)

		cJson += ']}'
	Else

		cJson := "[]"


	Endif

	::SetContentType("application/json")
	::SetResponse(cJson)

Return(.T.)

//*************
// PostConf
//*************

WsRestFul PostConf Description "Metodo Responsavel por fazer a confirmação dos registros ja integrados"

	WsData cIdRotina As String

	WsMethod Post Description "Inserção de adiantamento" WsSyntax "/PostConf"

End WsRestFul

WsMethod Post WsReceive cIdRotina WsService PostConf

	Local cBody     := ::GetContent()
	Local oJsoAux   := Nil
	Local cJson		:= ""

	FWJsonDeserialize(cBody, @oJsoAux)

	DBSelectArea("PR2")

	PR2->(DbGoTo(oJsoAux:recno))

	PR2->(RecLock("PR2",.F.))

	PR2->PR2_STINT  := "I"


	PR2->(MsUnlock())

	cJson := "{"
	cJson += '"lret":true,'
	cJson += '"mensagem":"dados confirmados com sucesso"
	cJson += '}'

	::SetResponse(cJson)

Return(.T.)


User Function TestaDespesa()
	
Local cBody     := GetBody()
Local nValTot	:= 0
Local _nErro	:= 0
Local aContas	:= {}
Local aPercs	:= {}
Local aRecs		:= {}
Local cJson     := ""
Local aSE2      := {}
Local nZ        := 0
Local nH 		:= 0
Local cCusto	:= ""

Private lMsHelpAuto		:= .T.
Private lMsErroAuto 	:= .F.
Private lAutoErrNoFile 	:= .T.
Private nValor      := 0
Private aRatAll     := {}
Private oJsoAux

	RpcSetEnv("01","01")

	If Empty(cBody)
		cJson := '{"error": "Conteudo Json invalido.","lret":false}'
		::SetResponse( cJson )
		Return .T.
	EndIf

	FWJsonDeserialize(cBody, @oJsoAux)

	Pergunte("FIN050",.F.)
	MV_PAR01 := 2
	MV_PAR04 := 2

	dDataBase := CTOD(oJsoAux:emissao)

	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))

	//Se ja existir titulo aborta o processo
	If SE2->(DbSeek(xFilial("SE2") + oJsoAux:prefixo  + cvaltochar(oJsoAux:idRelatorio) ))
		cJson := '{"message": "Titulo já incluso.","lret":true}'
		::SetResponse( cJson )
		Return(.T.)
	EndIf

	dbSelectArea("SA2")
	SA2->(dbSetOrder(3))

	SA2->(dbGoTop())
	If SA2->( DbSeek(xFilial("SA2") + oJsoAux:cpf ))

		nPosNat		:= 0
		nValTot  	:= 0
		cAuxNat		:= ""
		nEntAux		:= 0
		nPrcAux 	:= 0
		aRatEvEz	:= {}
		aAuxEz		:= {}
		aRatEz		:= {}
		lDespesas	:= .T.

		//Se não for array de despesas
		If AttIsMemberOf(oJsoAux, "despesas")

			//Monta o valor total do título
			For nZ := 1 To Len(oJsoAux:despesas)

				nValTot += oJsoAux:despesas[nZ]:VALORDESPESA

			Next nZ

			For nZ := 1 To Len(oJsoAux:despesas)

				nPercent := (oJsoAux:despesas[nZ]:VALORDESPESA	* 100) / nValtot

				aAuxEv	:= {}

				nEntAux := oJsoAux:despesas[nZ]:VALORDESPESA
				nPrcAux := nPercent

				aadd( aAuxEv ,{"EV_NATUREZ" , oJsoAux:despesas[nZ]:natureza			, Nil })//natureza a ser rateada 400212, 400214
				aadd( aAuxEv ,{"EV_VALOR" 	, oJsoAux:despesas[nZ]:VALORDESPESA		, Nil })//valor do rateio na natureza
				aadd( aAuxEv ,{"EV_PERC" 	, nPercent								, Nil })//percentual do rateio na natureza
				aadd( aAuxEv ,{"EV_RATEICC" , "1"									, Nil })//indicando que hÃ¡ rateio por centro de custo

				aCusto := Strtokarr2( oJsoAux:despesas[nZ]:CENTROCUSTO, ";", .T.)

				lPassou := .F.
				
				For nH := 1 to len(aCusto)

					If Empty(aCusto[nH])
						Loop
					EndIf
				
					cAux		:= StrTran(aCusto[nH], ";" ,"")
					cCusto		:= SUBSTR(cAux, 1, at('-', cAux) - 1)
					nRatPerc	:= Val(SUBSTR(cAux, at('-', cAux) + 1, Len(cAux)))

					aAuxEz := {}

					aadd( aAuxEz ,{"EZ_CONTA"	, oJsoAux:despesas[nZ]:CONTACONTABIL										, Nil })//conta contÃ¡bil na natureza   322020019 ,322020017 ,322020006
					aadd( aAuxEz ,{"EZ_CCUSTO"	, SUBSTR(cAux, 1, at('-', cAux) - 1)										, Nil })//centro de custo na natureza 50502001, 50502001, 50502001

					If nRatPerc <> 100	
						aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100) , Nil })//valor do rateio neste centro de custo
					Else
						aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA, Nil })//valor do rateio neste centro de custo
					EndIf
					
					aadd( aAuxEz ,{"CHAVE"		, oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1)	, Nil })//Chave auxiliar para não repetir entidades

					If AttIsMemberOf(oJsoAux:despesas[nZ], "ITEM")
						
						If !Empty(oJsoAux:despesas[nZ]:ITEM)
							
							aItem := Strtokarr2( oJsoAux:despesas[nZ]:ITEM, ";", .T.)
							
							aadd( aAuxEz ,{"EZ_ITEMCTA"	, aItem[nH], Nil }) //item contabil
							
						EndIf

					EndIf

					aadd(aRatEz,aAuxEz)

					If len(aRatEvEz) > 0

						nPosNat := aScan(aRatEvEz, {|x| Alltrim(x[1][2]) == oJsoAux:despesas[nZ]:natureza})

						If nPosNat > 0

							//Se for uma posição só não pode passar novamente
							If nZ > 1
							
								If nRatPerc <> 100
									aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100)
								Else	
									aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA
								EndIf

							EndIf
							
							If !lPassou
								aRatEvEz[nPosNat][3][2] += nPercent
								lPassou := .T.
							EndIf

							nPosChv := aScan(aRatEvEz[nPosNat][5][2], {|x| Alltrim(x[4][2]) == oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1) })

							If nPosChv > 0
								If nRatPerc <> 100
									aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA * (nRatPerc / 100)
								Else	
									aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA
								EndIf
							Else
								AADD(aRatEvEz[nPosNat][5][2], aAuxEz)
							EndIf

							aRatEz := {}

						Else
							
							aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
							
							If nRatPerc <> 100	
								
								nValNat := aScan(aAuxEv, {|x| Alltrim(x[1]) == "EV_VALOR"})

								aAuxEv[nValNat][2] := aAuxEv[nValNat][2] * (nRatPerc / 100)

							EndIf

							aAdd(aRatEvEz,aAuxEv)

							lPassou := .T.

							aRatEz := {}

						EndIf

					Else
						aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
						aAdd(aRatEvEz,aAuxEv)
						aRatEz := {}
						lPassou := .T.
					EndIf

				Next nH

				cAuxNat := oJsoAux:despesas[nZ]:natureza

			Next nZ

		Else
			nValTot		:= oJsoAux:valorDespesa
			lDespesas 	:= .F.
		EndIf

		aAdd(aSE2, {"E2_FILIAL" , FWxFilial("SE2")          					, Nil})
		aAdd(aSE2, {"E2_NUM"    , oJsoAux:idRelatorio     						, Nil})
		aAdd(aSE2, {"E2_PREFIXO", oJsoAux:prefixo		        				, Nil})
		aAdd(aSE2, {"E2_PARCELA", oJsoAux:parcela         						, Nil})
		aAdd(aSE2, {"E2_TIPO"   , oJsoAux:tipo            						, Nil})
		aAdd(aSE2, {"E2_NATUREZ", oJsoAux:natureza        						, Nil})
		aAdd(aSE2, {"E2_FORNECE", SA2->A2_COD               					, Nil})
		aAdd(aSE2, {"E2_LOJA"   , SA2->A2_LOJA              					, Nil})
		aAdd(aSE2, {"E2_NOMFOR" , SA2->A2_NOME              					, Nil})
		aAdd(aSE2, {"E2_EMISSAO", CTOD(oJsoAux:emissao)        					, Nil})
		aAdd(aSE2, {"E2_VENCTO" , ctod(oJsoAux:vencimento)     					, Nil})
		aAdd(aSE2, {"E2_VENCREA", DataValida(ctod(oJsoAux:vencimento), .T.)		, Nil})
		aAdd(aSE2, {"E2_VALOR"  , nValTot                     					, Nil})
		aAdd(aSE2, {"E2_HIST" 	, oJsoAux:historico           					, Nil})
		aAdd(aSE2, {"E2_CCUSTO" , cCusto			           					, Nil})
		aAdd(aSE2, {"E2_MOEDA"  , 1                         					, Nil})
		aAdd(aSE2, {"E2_MULTNAT", "1"                        					, Nil})
		aAdd(aSE2, {"E2_XIDREL"	, oJsoAux:idRelatorio     						, Nil})

		If lDespesas
			aAdd(aSE2,{"AUTRATEEV", aRatEvEz, Nil}) //adicionando ao vetor aCab o vetor do rateio
		EndIf

		aSE2 := FWVetByDic(aSE2,"SE2",.F.)
		//Execução da operação de inclusão no FINA050
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 3)

		If lMsErroAuto

			_cStrErro	:= ""
			_aErros 	:= GetAutoGRLog()
			_nErro   	:= Ascan(_aErros, {|x| "INVALIDO" $ AllTrim(Upper(x))  } )

			If _nErro > 0
				_cStrErro += _aErros[ _nErro ]

			Else
				For _nErro := 1 To Len( _aErros )
					_cStrErro += ( _aErros[ _nErro ] + cEnt )
				Next _nErro

			EndIf

			_cStrErro := Alltrim(_cStrErro)

			cJson := '{'
			cJson += '"message":"' + "Erro de ExecAuto Id = " + _cStrErro + '",'
			cJson += '"lret":false'
			cJson += "}"

		Else

			cJson := '{'
			cJson += '"message":"Título incluso com sucesso: ' + SE2->E2_NUM + '",'
			cJson += '"lret":true'
			cJson += "}"

		EndIf
	Else

		cJson := '{'
		cJson += '"message":"Fornecedor não localizado.",'
		cJson += '"lret":false'
		cJson += "}"

	EndIF

	aContas 		:= {}
	aRecs 			:= {}
	aPercs			:= {}
	nValTot			:= 0
	lMsErroAuto 	:= .F.

	If DecodeUtf8(cJson) <> Nil
		cJson := DecodeUtf8(cJson)
	EndIf

	//::SetResponse( cJson )

Return(.T.)

Static Function GetBody()

	cBody := '{"vencimento":"08/07/2024","solicitante":"000014","prefixo":"EXP","natureza":"2000141","idRelatorio":"4316765","cpf":"42404467832","parcela":"1","tipo":"DES","historico":"FELIPE WESLEY DOS REIS MOREIRA","emissao":"26/06/2024","despesas":[{"url":"https://s3.amazonaws.com/expenseimagens/bb86d6e6-dc94-4af4-aa9e-daa54979b664.jpg","codigoDespesa":39663758,"contaContabil":"3110400058","centroCusto":"20901-100;","natureza":"2000141","valorDespesa":20,"item":"40000002830;"},{"url":"https://s3.amazonaws.com/expenseimagens/7eada02b-9293-4fd7-9589-5e82bf6fb9a9.jpg","codigoDespesa":39684744,"contaContabil":"3110400024","centroCusto":"10901-33;10901-33;20901-33;","natureza":"2000169","valorDespesa":25,"item":"40000002290;40000002290;40000002830;"},{"url":"https://s3.amazonaws.com/expenseimagens/23852a6a-3f28-4369-a4d8-2f43cedd6b57.jpg","codigoDespesa":39719065,"contaContabil":"3110400024","centroCusto":"20901-50;20901-50;","natureza":"2000169","valorDespesa":39,"item":"40000001924;40000002830;"},{"url":"https://s3.amazonaws.com/expenseimagens/acf4a52e-7d4c-4063-9783-9e7fb634082b.jpg","codigoDespesa":39719098,"contaContabil":"3110400024","centroCusto":"20901-50;20901-50;","natureza":"2000169","valorDespesa":65.5,"item":"40000002830;40000001924;"}]}'
	
	CtESTE := 'reembolso ANDRÃ‰ LOPES GUERRA           '
	CTESTE2 := 'reembolso ANDRÉ LOPES GUERRA'

	A := DecodeUtf8(CtESTE)
	B := DecodeUtf8(CTESTE2)
	C := B

Return cBody

uSER fUNCTION   GetBody()

	cBody := '{"natureza":"51030182","historico":"reembolso ANDRÉ LOPES GUERRA","prefixo":"DES","idRelatorio":"3767612","cpf":"33945693888","empresa":"0101","parcela":"1","tipo":"DP","vencimento":"22/08/2023","solicitante":"000014","despesas":[{"url":" ","codigoDespesa":33270873,"contaContabil":"51030906","centroCusto":"201001-100;","natureza":"51030182","valorDespesa":15},{"url":" ","codigoDespesa":33270887,"contaContabil":"51030910","centroCusto":"201001-100;","natureza":"51030119","valorDespesa":20}]}''

	CtESTE := 'reembolso ANDRÃ‰ LOPES GUERRA           '
	CTESTE2 := 'reembolso ANDRÉ LOPES GUERRA'

	A := DecodeUtf8(CtESTE)
	B := DecodeUtf8(CTESTE2)
	C := B

Return cBody




///--------------------------------------------------------------------------
/*{Protheus.doc} VldCharXML
 Retira todos os caracteres especiais de uma string

 @author     Eduardo Fernandes
 @since      10/12/2014
 @param	 	cString 		-> String a ser tratada
 @param	 	lImagem 		-> tratamento para imagem
 @param	 	lNoTags 		-> Valida se utiliza a funcao _NoTags
 @return     cString
 @version    P.10
*/
//--------------------------------------------------------------------------

Static Function VldChar(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"
	Local cTioU  := "ÃÕ"
	Local cCecid := "çÇ"
	Local cPontua := ":"

	Default lImagem:= .F.
	Default lNoTags:= .T.

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)

		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cTioU+cPontua
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf

			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf

			nY:= At(cChar,cTioU)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("AO",nY,1))
			EndIf

			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)

		If Asc(cChar) < 32 .Or. Asc(cChar) > 122
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX

Return cString
