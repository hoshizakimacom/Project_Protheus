#Include 'Protheus.ch'

//+------------------------------------------------------------------------------
// Este ponto de entrada executado antes da gera��o do documento de sa�da
// MATA440
//+------------------------------------------------------------------------------
User Function M410PVNF()

Local _aArea        := GetArea()
Local _lRet         := .T.

//+-------------------------------------------------------
// Verifique se o cliente possui titulos em atraso
//+-------------------------------------------------------
_lRet := U_M05A26_B()

// +------------------------------------------------------------+
// | Verifica o usu�rio respons�vel pelo faturamento e o alerta |
// | Caso a condi��o de pagamento seja do tipo 9 e as datas e   |
// | parcelas estejam em branco.                                |
// +------------------------------------------------------------+
dbSelectArea("SE4")
dbSetOrder(1)
If MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	If SE4->E4_TIPO == "9"
		If Empty(SC5->C5_PARC1) .Or. Empty(SC5->C5_DATA1)
	        _lRet := .F.
   	        MsgStop('� obrigat�rio informar ao menos 1 data de vencimento e parcela para condi��o de pagamentco do tipo 9 ! (Pr�-fixadas)','Aten��o')
		Endif
	Endif
Endif

// +------------------------------------------------------------+
// | Verifica o status financeiro para identificar se o pedido  |
// | foi liberado pelo departamento financeiro                  |
// +------------------------------------------------------------+
If SC5->C5_XSTSFIN == '1'
	MsgStop('O pedido encontra-se com bloqueio financeiro. Solicite a libera��o financeira do pedido.','ATEN��O')
	_lRet := .F.
Endif

RestArea(_aArea)

//+------------------------------------------------------------------------
// Verifique se o os itens do pedido possuem etiqueta de identifica��o.
//+------------------------------------------------------------------------
_lRet := U_M05A26_D() 

Return _lRet
