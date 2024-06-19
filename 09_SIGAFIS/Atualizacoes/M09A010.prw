#INCLUDE "Protheus.ch"
#include "Fileio.ch"

//+---------------------------------------------------------------------------
// Rotina de ajuste de grupo de tributação por Origem, Ex NCM e NCM
//+---------------------------------------------------------------------------
User Function M09A010()
	Local	_aSays			:= {}
	Local	_aButton		:= {}
	Local	_cTitulo		:= Substr(FunName(),3,20)
	Private _lSimulacao	:= .T.

	_lSimulacao := MsgYesNo('Deseja executar em modo SIMULAÇÃO?')

	If _lSimulacao
		AADD(_aSays,OemToAnsi('!!! SIMULAÇÃO !!! '											))
	EndIf

	AADD(_aSays,OemToAnsi("Processar todos os produtos de acordo com o POSIPI e EX_NCM: " 	))
	AADD(_aSays,OemToAnsi(" - acertar informação de Grupo de tributacao (B1_GRTRIB)"		))
	AADD(_aSays,OemToAnsi(" REGRAS:"														))
	AADD(_aSays,OemToAnsi(" - se ORIGEM IGUAL a 1, atualizar utilizando YD_GRPIMP"			))
	AADD(_aSays,OemToAnsi(" - se ORIGEM IGUAL a 2,3 ou 8, atualizar utilizando YD_GRPREVE"	))
	AADD(_aSays,OemToAnsi(" - DEMAIS atualizar utilizando YD_GRPTRIB"						))

	aAdd( _aButton, { 1, .T., {|| Processa( {|| M09010Proc() }, "Aguarde...", "",.F.),FechaBatch()}}	)
	aAdd( _aButton, { 2, .T., {|| FechaBatch()					}}	)

	FormBatch( _cTitulo, _aSays, _aButton )
Return

//+---------------------------------------------------------------------------
Static Function M09010Proc()
//Local cTmpB1YD	:= GetNextAlias()
//Local cQuery		:= ""
//Local _nRec		:= 0
Local _cAlias		:= GetNextAlias()
Local _nReg		:= 0
Local _nRegAlt	:= 0

Local _cLog		:= ''
Local _cArq		:=  cGetFile('*.TXT'	,'Informe diretorio'	,0,'',.T.			,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T. )

Local _cMsg		:= 'Total de produtos alterados: #1 .' + CRLF
Local _nHandle	:= 0
Local _cGrTrib	:= ''

Private _nTotal	:= 0

If !Empty(_cArq)
	_cArq += (StrTran(Time(),':','')) + '.TXT'

	BeginSql Alias _cAlias
		SELECT	 B1_COD		,B1_ORIGEM		,B1_GRTRIB		,SB1.R_E_C_N_O_ AS B1_RECNO
				,B1_POSIPI		,B1_EX_NCM		,B1_TIPO
				,YD_TEC		,YD_XGRTRIB	,YD_XGRIMP		,YD_PER_IPI
				,YD_XGRREVE
		FROM  %Table:SB1% SB1
		INNER JOIN %Table:SYD% SYD
			ON	SYD.%NotDel%
			AND YD_FILIAL = %xFilial:SYD%
			AND B1_POSIPI = YD_TEC
			AND B1_EX_NCM = YD_EX_NCM
		WHERE	SB1.%NotDel%
			AND B1_FILIAL = %xFilial:SB1%
			AND B1_ORIGEM <> ''
		ORDER BY B1_COD
	EndSql

	Count To _nTotal
	ProcRegua(_nTotal)

	(_cAlias)->(DBGoTop())

	If (_cAlias)->(!EOF())
			
		_nHandle	:= FCREATE(_cArq)
				
		While  (_cAlias)->(!EOF())
			IncProc('Atualizando produto ' + CValToChar(++_nReg) + ' de ' + CValToChar(_nTotal) + '.')
			_cLog := ""
			SB1->(DbGoTo( (_cAlias)->B1_RECNO ))

			If SB1->(!EOF())
				Do Case
					Case (_cAlias)->B1_ORIGEM == '1'
						_cGrTrib 	:= (_cAlias)->YD_XGRIMP
					Case (_cAlias)->B1_ORIGEM $ '2|3|8'
						_cGrTrib 	:=  (_cAlias)->YD_XGRREVE   //(_cAlias)->YD_GRPREVE
					OtherWise
						_cGrTrib	:= (_cAlias)->YD_XGRTRIB
				EndCase

				If AllTrim((_cAlias)->B1_GRTRIB) <> AllTrim(_cGrTrib)
					_nRegAlt++
					If !_lSimulacao
						RecLock('SB1',.F.)
							SB1->B1_GRTRIB := _cGrTrib
						SB1->(MsUnLock())
					EndIf
						_cLog 	+= 'Produto: ' 			+ SB1->B1_COD;
								+ ' Tipo: '	 			+ SB1->B1_TIPO;
								+ ' Origem: '	 		+ SB1->B1_ORIGEM;
								+ ' NCM: '				+ (_cAlias)->B1_POSIPI;
								+ ' EX NCM: '			+ (_cAlias)->B1_EX_NCM;						
								+ ' Grp. Trib.: ' 		+ (_cAlias)->B1_GRTRIB ;
								+ ' Grp. Trib. NOVO: ' 	+ _cGrTrib;
								+ CRLF
			        FWrite(_nHandle, _cLog)					
					EndIf
			EndIf
				(_cAlias)->(DbSkip())
		EndDo
//			_nHandle	:= FCREATE(_cArq)
			If _nHandle = -1
		 	_cMsg 	+= " Erro ao criar arquivo - ferror " + Str(Ferror())
	    Else
	        _cMsg += ' Verifique arquivo de log gerado: ' + CRLF + '#2 ' + CRLF
//		        FWrite(_nHandle, _cLog)
	        FClose(_nHandle)
	    EndIf
	EndIf
		Aviso('Atenção',I18N( _cMsg,{_nRegAlt,_cArq}),{'OK'},3)
EndIf
Return
