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
	Local cCusto	:= ""

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

				cAux	:= StrTran(oJsoAux:despesas[nZ]:CENTROCUSTO, ";" ,"")
				cCusto	:= SUBSTR(cAux, 1, at('-', cAux) - 1)

				aAuxEz := {}

				aadd( aAuxEz ,{"EZ_CONTA"	, oJsoAux:despesas[nZ]:CONTACONTABIL										, Nil })//conta contÃ¡bil na natureza   322020019 ,322020017 ,322020006
				//aadd( aAuxEz ,{"EZ_ITEMCTA"	, oJsoAux:despesas[nZ]:ITEM													, Nil })//item contabil
				aadd( aAuxEz ,{"EZ_CCUSTO"	, SUBSTR(cAux, 1, at('-', cAux) - 1)										, Nil })//centro de custo na natureza 50502001, 50502001, 50502001
				aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA											, Nil })//valor do rateio neste centro de custo
				aadd( aAuxEz ,{"CHAVE"		, oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1)	, Nil })//Chave auxiliar para não repetir entidades

				aadd(aRatEz,aAuxEz)

				If len(aRatEvEz) > 0

					nPosNat := aScan(aRatEvEz, {|x| Alltrim(x[1][2]) == oJsoAux:despesas[nZ]:natureza})

					If nPosNat > 0

						aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA
						aRatEvEz[nPosNat][3][2] += nPercent

						nPosChv := aScan(aRatEvEz[nPosNat][5][2], {|x| Alltrim(x[4][2]) == oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1) })

						If nPosChv > 0
							aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA
						Else
							AADD(aRatEvEz[nPosNat][5][2], aAuxEz)
						EndIf

						aRatEz := {}

					Else
						aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
						aAdd(aRatEvEz,aAuxEv)
						aRatEz := {}
					EndIf

				Else
					aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
					aAdd(aRatEvEz,aAuxEv)
					aRatEz := {}
				EndIf

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
		aAdd(aSE2, {"E2_EMISSAO", dDataBase                  					, Nil})
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
	Local cCusto	:= ""

	Private lMsHelpAuto		:= .T.
	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile 	:= .T.
	Private nValor      := 0
	Private aRatAll     := {}
	Private oJsoAux
	cString := 'reembolso ANDRÃ‰ LOPES GUERRA           '

	DecodeUtf8(cString)

	RpcSetEnv("01","01")

	If Empty(cBody)
		cJson := '{"error": "Conteudo Json invalido.","lret":false}'
		//::SetResponse( cJson )
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
		//::SetResponse( cJson )
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

				cAux	:= StrTran(oJsoAux:despesas[nZ]:CENTROCUSTO, ";" ,"")
				cCusto	:= SUBSTR(cAux, 1, at('-', cAux) - 1)

				aAuxEz := {}

				aadd( aAuxEz ,{"EZ_CONTA"	, oJsoAux:despesas[nZ]:CONTACONTABIL										, Nil })//conta contÃ¡bil na natureza   322020019 ,322020017 ,322020006
				aadd( aAuxEz ,{"EZ_CCUSTO"	, SUBSTR(cAux, 1, at('-', cAux) - 1)										, Nil })//centro de custo na natureza 50502001, 50502001, 50502001
				aadd( aAuxEz ,{"EZ_VALOR"	, oJsoAux:despesas[nZ]:VALORDESPESA											, Nil })//valor do rateio neste centro de custo
				aadd( aAuxEz ,{"CHAVE"		, oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1)	, Nil })//Chave auxiliar para não repetir entidades

				aadd(aRatEz,aAuxEz)

				If len(aRatEvEz) > 0

					nPosNat := aScan(aRatEvEz, {|x| Alltrim(x[1][2]) == oJsoAux:despesas[nZ]:natureza})

					If nPosNat > 0

						aRatEvEz[nPosNat][2][2] += oJsoAux:despesas[nZ]:VALORDESPESA
						aRatEvEz[nPosNat][3][2] += nPercent

						nPosChv := aScan(aRatEvEz[nPosNat][5][2], {|x| Alltrim(x[4][2]) == oJsoAux:despesas[nZ]:CONTACONTABIL + SUBSTR(cAux, 1, at('-', cAux) - 1) })

						If nPosChv > 0
							aRatEvEz[nPosNat][5][2][nPosChv][3][2] += oJsoAux:despesas[nZ]:VALORDESPESA
						Else
							AADD(aRatEvEz[nPosNat][5][2], aAuxEz)
						EndIf

						aRatEz := {}

					Else
						aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
						aAdd(aRatEvEz,aAuxEv)
						aRatEz := {}
					EndIf

				Else
					aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })
					aAdd(aRatEvEz,aAuxEv)
					aRatEz := {}
				EndIf

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
		aAdd(aSE2, {"E2_EMISSAO", dDataBase                  					, Nil})
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
		lMsErroAuto 	:= .F.
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

	cBody := '{"natureza":"51030182","historico":"reembolso ANDRÉ LOPES GUERRA","prefixo":"DES","idRelatorio":"3767612","cpf":"33945693888","empresa":"0101","parcela":"1","tipo":"DP","vencimento":"22/08/2023","solicitante":"000014","despesas":[{"url":" ","codigoDespesa":33270873,"contaContabil":"51030906","centroCusto":"201001-100;","natureza":"51030182","valorDespesa":15},{"url":" ","codigoDespesa":33270887,"contaContabil":"51030910","centroCusto":"201001-100;","natureza":"51030119","valorDespesa":20}]}''

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
