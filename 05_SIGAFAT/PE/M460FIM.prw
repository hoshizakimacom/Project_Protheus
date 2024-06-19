#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//| Ponto de entrada chamado apos a Gravacao da NF de Saida, e fora da transação (MATA461)
//+---------------------------------------------------------------------------------------------------------
User Function M460FIM()

Local _aArea	 := GetArea()
Local oTituloCRA := Nil
Local cPedido    := SC5->C5_NUM

    //+----------------------------------------------------------------------
    //  Rotina customizada para descontar os títulos de prefixo PVA antes de
    //  gerar duplicatas a receber. Deve estar posicionado na SC5
    //+----------------------------------------------------------------------

    FwMsgRun(,{|| U_M05A10(SC5->(Recno()),SF2->(Recno()))},,"Verificando adiantamentos (PVA)..." )

    // Verifica bloqueio de crédito, se estava desbloqueado, bloqueia novamente
    U_M05A26_C()

    //+---------------------------------------------------------------------------------
    //  Verifica a existencia do titulo CRA / NF para compensação automática pelo Pedido
    //+---------------------------------------------------------------------------------
	oTituloCRA := ClassTituloCRA():New()
	If !oTituloCRA:Compensa(cPedido)
		Aviso("M460FIM_CRA",oTituloCRA:RetError(),{"Fechar"})
	EndIf
 
    MsgInfo('Término da geração do documento de saída.','Atenção')

	RestArea(_aArea)

Return
