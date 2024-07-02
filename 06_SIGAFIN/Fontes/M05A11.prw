#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------
//| Atualiza campos ao incluir/copiar pedido de venda
//| Chamado do PE executado ao clicar no botão OK do pedido de venda
//+---------------------------------------------------------------------------------------------------------------------------------
User Function M05A11(_nOpc)
    Local _lRet     := .T.
    Local _cAlias   := GetNextAlias()
    Local _cPicture := '@E 9,999,999,999,999.99'
    Local _cMsg     := 'Não é possível excluir o pedido #2 pois possui títulos a receber vinculados.' + CRLF + 'Exclua os títulos antes de excluir o pedido.' + CRLF + CRLF + ' #2'
    Local _cTitulos := ''
    Local _cPedido  := SC5->C5_NUM

    Do Case

        //+-------------------------------------
        //| Exclusao
        //+-------------------------------------
        Case _nOpc == 1
            BeginSql Alias _cAlias
                SELECT       E1_TIPO
                            ,E1_PREFIXO
                            ,E1_NUM
                            ,E1_PARCELA
                            ,E1_VALOR
                FROM %Table:SE1% SE1
                WHERE   E1_PREFIXO = 'PVA'
                    AND SE1.%NotDel%
                    AND E1_FILIAL = %xFilial:SE1%
                    AND E1_PEDIDO = %Exp:_cPedido%
            EndSql

            If !(_lRet := (_cAlias)->(EOF()))
                While (_cAlias)->(!EOF())
                    _cTitulos += CRLF + (_cAlias)->E1_TIPO + ' ' + (_cAlias)->E1_PREFIXO + ' ' + (_cAlias)->E1_NUM + ' ' + (_cAlias)->E1_PARCELA + ' ' + Transform((_cAlias)->E1_VALOR,_cPicture)
                    (_cAlias)->(DbSkip())
                EndDo

                MsgAlert(I18N(_cMsg,{_cPedido,_cTitulos}),'Atenção')
            EndIf
            (_cAlias)->(dbCloseArea())

        //+-------------------------------------
        //| Inclusão / Alteração
        //+-------------------------------------
        Case _nOpc == 3

            If SC5->(FieldPos('C5_XINCLUI')) > 0
                M->C5_XINCLUI := Upper(UsrFullName(RetCodUsr())) + ' | ' + DToC(Date()) + ' ' + Time()
	            M->C5_XDTAPRV	:= Date()
	            M->C5_XHRAPRV	:= Time()                
            EndIf
            
            If IsInCallStack('MATA416') .And. M->C5_DESC1 > 10
	            M->C5_XAPROV 	:= Upper(UsrFullName(RetCodUsr())) // UsrFullName(RetCodUsr())
	            M->C5_XDTAPRV	:= Date()
	            M->C5_XHRAPRV	:= Time()
			Endif            	

        //+-------------------------------------
        //| Alteração
        //+-------------------------------------
         Case _nOpc == 4

            If SC5->(FieldPos('C5_XALTERA')) > 0
                M->C5_XALTERA := Upper(UsrFullName(RetCodUsr())) + ' | ' + DToC(Date()) + ' ' + Time()
            EndIf

            /*

            Ao alterar o pedido ajusta os campos de comissão do titulo PVA gerado que ainda não fora baixado
            #MONTES20240425 - Solicitação THAIS

            */
            BeginSql Alias _cAlias
                SELECT SE1.R_E_C_N_O_ RECSE1
                FROM %Table:SE1% SE1
                WHERE   E1_PREFIXO = 'PVA'
                    AND SE1.%NotDel%
                    AND E1_FILIAL = %xFilial:SE1%
                    AND E1_PEDIDO = %Exp:_cPedido%
                    AND E1_SALDO = E1_VALOR
            EndSql

            While (_cAlias)->(!EOF())

                SE1->(dbGoTo((_cAlias)->RECSE1))

                If SE1->(!EOF())

                    RecLock("SE1",.F.)
                    SE1->E1_VEND1  := SC5->C5_VEND1
                    SE1->E1_COMIS1 := SC5->C5_COMIS1
                    SE1->E1_VEND2  := SC5->C5_VEND2
                    SE1->E1_COMIS2 := SC5->C5_COMIS2
                    SE1->E1_VEND3  := SC5->C5_VEND3
                    SE1->E1_COMIS3 := SC5->C5_COMIS3
                    SE1->E1_VEND4  := SC5->C5_VEND4
                    SE1->E1_COMIS4 := SC5->C5_COMIS4
                    SE1->E1_VEND5  := SC5->C5_VEND5
                    SE1->E1_COMIS5 := SC5->C5_COMIS5
                    MsUnLock()

                EndIf

                (_cAlias)->(DbSkip())
            EndDo
            (_cAlias)->(dbCloseArea())

    EndCase
Return _lRet
