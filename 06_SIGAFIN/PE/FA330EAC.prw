#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------
//	Utilizado na exclusão de compensação de contas a receber, antes da contabilização
//+----------------------------------------------------------------------------------------
User Function FA330EAC()
	Local _aArea		:= GetArea()
	Local _aAreaSE5     := SE5->(GetArea())
	Local _cRAPre		:= 'PVA'
	Local _nValor		:= 0
	Local nRegSE5	    := 0
	//Local nX
	Local nTamPref := TamSX3("E1_PREFIXO")[1]
	Local nTamNum := TamSX3("E1_NUM")[1]
	Local nTamParc := TamSX3("E1_PARCELA")[1]
	Local nTamTipoT := TamSX3("E1_TIPO")[1]
	//Local nTamLoja := TamSX3("E1_LOJA")[1]

	// Retira saldo a compensar do PVA
	If SE5->E5_PREFIXO == _cRAPre .AND. SE5->E5_TIPODOC $ '|CP|ES|' .AND. SE5->E5_MOTBX = 'CMP'

		DbSelectArea('SE1')
		SE1->(DbGoTop())
		SE1->(DbSetOrder(1))	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		If SE1->(DbSeek(xFilial('SE1') + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
			_nValor := IIf(Type('nValorBaixa') == 'N',nValorBaixa,SE5->E5_VALOR)
			U_M06A01('-',_nValor)
		EndIf
	
	EndIf

	/*

	Se registro do estorno verifica se o registro original fora contabilizado se não, marca os dois como "Contabilizados"

	*/
	If SE5->E5_MOTBX = "CMP" .AND. SE5->E5_TIPODOC $ '|BA|CP|'

		nRegSE5    := SE5->(RECNO())
		lContabil  := (SE5->E5_LA = "S")
		cDocumento := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA)
		dDataAdt   := SE5->E5_DATA
		cDocuAdt   := SE5->E5_DOCUMEN
		cFornAdt   := SE5->E5_FORNADT
		cLojaAdt   := SE5->E5_LOJAADT
		cTpDocAdt  := IIF(SE5->E5_TIPODOC="BA","CP","BA") // Se for BA o documento original é CP
		cSeq       := SE5->E5_SEQ

		If !lContabil //Se não tiver contabilizado, marca como contabilizado para não contabilizar mais pois fora estornado
			RecLock("SE5",.F.)
			SE5->E5_LA := "S"
			MsUnLock()
		EndIf

		dbSelectArea("SE5")
		dbSetOrder(2) // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ
		If dbSeek(xFilial("SE5")+"ES"+cDocumento+cSeq)

			If !lContabil //Se não tiver contabilizado, marca como contabilizado para não contabilizar mais pois fora estornado
				RecLock("SE5",.F.)
				SE5->E5_LA := "S"
				MsUnLock()
			EndIf

		EndIf

		dbSelectArea("SE5")
		dbSetOrder(2) // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ
		If dbSeek(xFilial("SE5")+cTpDocAdt+LEFT(cDocuAdt,nTamPref+nTamNum+nTamParc+nTamTipoT)+DTOS(dDataAdt)+cFornAdt+cLojaAdt+cSeq)

			If !lContabil //Se não tiver contabilizado, marca como contabilizado para não contabilizar mais pois fora estornado
				RecLock("SE5",.F.)
				SE5->E5_LA := "S"
				MsUnLock()
			EndIf

		EndIf

		dbSelectArea("SE5")
		dbSetOrder(2) // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ
		If dbSeek(xFilial("SE5")+"ES"+LEFT(cDocuAdt,nTamPref+nTamNum+nTamParc+nTamTipoT)+DTOS(dDataAdt)+cFornAdt+cLojaAdt+cSeq)

			If !lContabil //Se não tiver contabilizado, marca como contabilizado para não contabilizar mais pois fora estornado
				RecLock("SE5",.F.)
				SE5->E5_LA := "S"
				MsUnLock()
			EndIf

		EndIf

		SE5->(dbGoTo(nRegSE5))

	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSE5)
Return
