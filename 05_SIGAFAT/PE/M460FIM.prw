#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------
//| Ponto de entrada chamado apos a Gravacao da NF de Saida, e fora da transa��o (MATA461)
//+---------------------------------------------------------------------------------------------------------
User Function M460FIM()

Local _aArea	 := GetArea()
Local oTituloCRA := Nil
Local cPedido    := SC5->C5_NUM

    //+----------------------------------------------------------------------
    //  Rotina customizada para descontar os t�tulos de prefixo PVA antes de
    //  gerar duplicatas a receber. Deve estar posicionado na SC5
    //+----------------------------------------------------------------------

    FwMsgRun(,{|| U_M05A10(SC5->(Recno()),SF2->(Recno()))},,"Verificando adiantamentos (PVA)..." )

    // Verifica bloqueio de cr�dito, se estava desbloqueado, bloqueia novamente
    U_M05A26_C()

    //+---------------------------------------------------------------------------------
    //  Verifica a existencia do titulo CRA / NF para compensa��o autom�tica pelo Pedido
    //+---------------------------------------------------------------------------------
	oTituloCRA := ClassTituloCRA():New()
	If !oTituloCRA:Compensa(cPedido)
		Aviso("M460FIM_CRA",oTituloCRA:RetError(),{"Fechar"})
	EndIf
 
    MsgInfo('T�rmino da gera��o do documento de sa�da.','Aten��o')

	RestArea(_aArea)

Return
