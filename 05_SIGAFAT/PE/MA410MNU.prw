#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//|	PE nas ações relacionadas do Pedido de Venda (MATA410)
//+---------------------------------------------------------------------------------------------------------
User Function MA410MNU()
	Local _aArea		:= GetArea()
	Local _cGrpApr      := GetMv('AM_05A0902',,'')
	Local _cGrpBlq      := GetMv('AM_05A0903',,'')
	Local cGrpExc       := GetMv('AM_05ACOM ',,'')
	Local _lAprov       := U_M00A01(_cGrpApr)
    Local _lBloq        := U_M00A01(_cGrpBlq)
	Local aSubRotina    := {}

    If type('__lComerc') <> 'L'
        Public __lComerc    := U_M00A01(cGrpExc)
    EndIf

    If type('__lRepres') <> 'L'
        Public __lRepres    := .F.
        Public __cEst       := '  '
    EndIf

	aAdd( aRotina,{ 'Compensacao de Recebimento'		,'U_M05A12(1)'		,0 ,6 ,0 ,Nil})
	aAdd( aRotina,{ 'Inclui Receb. Antecipado'	        ,'U_M05A08'		    ,0 ,6 ,0 ,Nil})
	aAdd( aRotina,{ 'Imprimir'	                        ,'U_M05R03(1)'      ,0 ,1 ,0 ,Nil})
	aAdd( aRotina,{ 'Imprimir Sem Valor'	            ,'U_M05R03(2)'	    ,0 ,1 ,0 ,Nil})
	aAdd( aRotina,{ 'Anexo Orc. - Visualizar'           ,'U_M05A25_E'       ,0 ,2 ,0 ,Nil})
	aAdd( aRotina,{ 'Anexo PV - Incluir'	            ,'U_M05A25_C'		,0 ,2 ,0 ,Nil})
	aAdd( aRotina,{ 'Anexo PV - Visualizar'	            ,'U_M05A25_D'		,0 ,2 ,0 ,Nil})
	Aadd( aRotina,{ 'Alt.Data Entrega'                  ,'U_M05A38'         ,0 ,2 ,0 ,Nil})

    If _lBloq
       AAdd( aRotina,{ "Crédito - Bloquear"            ,"U_M05A09_A(2)"     ,0 ,2 ,0 ,Nil})
    EndIf

	If _lAprov
	   AAdd( aRotina,{ "Crédito - Desbloquear"         ,"U_M05A09_B(2)"     ,0 ,2 ,0 ,Nil})
	EndIf

	aSubRotina := { { OemtoAnsi('Parametros')   ,'Pergunte("M06A11",.T.)'  , 0 ,2 },;
					{ OemtoAnsi('Envio e-mail') ,'U_M06A11()'              , 0 ,2 }}
	Aadd( aRotina,{ 'Env.Confirm.Pedido'               ,aSubRotina         ,0 ,2 ,0 ,Nil})


	RestArea(_aArea)
Return
