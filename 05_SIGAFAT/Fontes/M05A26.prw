#Include 'Protheus.ch'


//+------------------------------------------------------------------------------
// N�o permite efetivar or�amento para cliente com bloqueio de cr�dito
//+------------------------------------------------------------------------------
User Function M05A26_A()
    Local _nTotal   := 0
    Local _lRet     := .T.
    Local _cCodCli  := SCJ->CJ_CLIENTE
    Local _cLojCli  := SCJ->CJ_LOJA
    Local _cAlias   := GetNextAlias()
    Local _lDealer  := IIF(SCJ->CJ_XTPVEN == '3',.T.,.F.)
    Local _nLimDlr  := Posicione("SA1",1,xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,'A1_LC')

    //Excessao para quando utilizar cliente como fornecedor

    If _lRet .And. SCJ->CJ_XCRED == '1'
        _lRet := .F.
        MsgInfo('Opera��o n�o permitida pois cliente possui titulos vencidos.'  + CRLF + CRLF + 'Para concluir a opera��o ser� necess�ria a regulariza��o dos t�tulos ou aprova��o do setor financeiro',"Aten��o")
    EndIf

    If _lRet .And. SCJ->(FieldPos('CJ_XCRED')) > 0

        // Somente verifica pendencias se registros n�o estiver bloqueado ou liberado
        If SCJ->CJ_XCRED == '2'
//          RecLock('SCJ',.F.)
//              SCJ->CJ_XCRED   := '1'
//          SCJ->(MsUnLock())

            _lRet := .T.
        Else
            _lRet := !U_M05A09(SCJ->CJ_FILIAL,SCJ->CJ_CLIENTE,SCJ->CJ_LOJA)
        EndIf

        If !_lRet
            RecLock('SCJ',.F.)
                SCJ->CJ_XCRED   := '1'
            SCJ->(MsUnLock())

            MsgInfo('Opera��o n�o permitida pois cliente possui titulos vencidos.'  + CRLF + CRLF + 'Para concluir a opera��o ser� necess�ria a regulariza��o dos t�tulos ou aprova��o do setor financeiro.',"Aten��o")
        EndIf

        //+----------------------------------------------------------------------+
        //| An�lise de cr�dito para Or�amentos com o tipo de venda = 3 - Dealer  |
        //+----------------------------------------------------------------------+
        //| Verifico o limite de cr�dito estipulado no cadastro do cliente no    |
        //| campo A1_LC e efetuo a somat�ria dos itens do or�amento em aberto    |
        //| para o cliente, se o valor for maior que o limite, efetuo o bloqueio |
        //+----------------------------------------------------------------------+
        
        If _lDealer .And. _lRet 
            BeginSql Alias _cAlias
                
                SELECT  SCK.CK_FILIAL,SCK.CK_NUM,SCK.CK_CLIENTE,SCK.CK_LOJA,SCK.CK_VALOR,CK_XVLTBRU,SCJ.CJ_STATUS
                    FROM SCK010 SCK
                        LEFT JOIN SCJ010 AS SCJ ON
                               SCK.CK_NUM = SCJ.CJ_NUM
                    WHERE 
                         SCJ.CJ_STATUS = 'A' AND 
                         SCK.CK_CLIENTE = %Exp:_cCodCli% AND 
                         SCK.CK_LOJA = %Exp:_cLojCli% AND
                         SCK.%NotDel%
            EndSql

            While (_cAlias)->(!EOF())
                _nTotal += (_cAlias)->CK_XVLTBRU
                (_cAlias)->(dbSkip())
            End

            If _nTotal > _nLimDlr
                MsgAlert("A somat�ria dos or�amentos em aberto para o cliente no valor de R$ " + Alltrim(Str(_nTotal)) + " ultrapassa o limite de cr�dito estipulado para o Dealer de R$ " + Alltrim(Str(_nLimDlr)) + ".","ATEN��O")
                _lRet := .F.
                RecLock('SCJ',.F.)
                SCJ->CJ_XCRED   := '1'
                SCJ->(MsUnLock())
            Endif

            (_cAlias)->(DbCloseArea())
        Endif
            
    EndIf
Return _lRet

//+------------------------------------------------------------------------------
// N�o permite faturar cliente com bloqueio de cr�dito
//+------------------------------------------------------------------------------
User Function M05A26_B()
    Local _lRet := .T.

    //Excessao para quando utilizar cliente como fornecedor

    If SC5->C5_TIPO <> 'B'
        If _lRet .And. SC5->C5_XCRED == '1'
            _lRet := .F.
            MsgInfo('Opera��o n�o permitida pois cliente possui titulos vencidos.'  + CRLF + CRLF + 'Para concluir a opera��o ser� necess�ria a regulariza��o dos t�tulos ou aprova��o do setor financeiro',"Aten��o")
        EndIf

        If _lRet .And. SC5->(FieldPos('C5_XCRED')) > 0

            // Somente verifica pendencias se registros n�o estiver bloqueado ou liberado
            If SC5->C5_XCRED == '2'
//                RecLock('SC5',.F.)
//                    SC5->C5_XCRED   := '1'
//                SC5->(MsUnLock())

                _lRet := .T.
            Else
                    _lRet := !U_M05A09(SC5->C5_FILIAL,SC5->C5_CLIENTE,SC5->C5_LOJACLI)
            EndIf

            If !_lRet
                RecLock('SC5',.F.)
                    SC5->C5_XCRED   := '1'
                SC5->(MsUnLock())

                MsgInfo('Opera��o n�o permitida pois cliente possui titulos vencidos.'  + CRLF + CRLF + 'Para concluir a opera��o ser� necess�ria a regulariza��o dos t�tulos ou aprova��o do setor financeiro.',"Aten��o")
            EndIf
        EndIf
    EndIf
Return _lRet

//+------------------------------------------------------------------------------
// Verifica bloqueio de cr�dito, se estava desbloqueado, bloqueia novamente
//+------------------------------------------------------------------------------
User Function M05A26_C()
    Local aAreaSC5  := SC5->(GetArea())

    If SC5->C5_XCRED == '2'
        RecLock('SC5',.F.)
//          SC5->C5_XCRED   := '1' 
            SC5->C5_XCRED   := ' '
        SC5->(MsUnLock())
    EndIf

    RestArea(aAreaSC5)
Return

//+------------------------------------------------------------------------------
// Verifica item do pedido possui etiqueta de reserva impressa na tabela de
// numeros de s�rie.
// Chamada : P.E. M410PVNF
//+------------------------------------------------------------------------------
User Function M05A26_D()

    Local _nX       := 0
    Local _cFamilia := ""
    Local _cLocal   := ""
    Local _lRet     := .T.
    Local _cAlias   := GetNextAlias()
    Local _aAreaSB1 := SB1->(GetArea())
    Local _aAreaSC6 := SC6->(GetArea())
    Local _aAreaSC9 := SC9->(GetArea())
    Local _cNumPed  := SC5->C5_NUM
    

    BeginSql Alias _cAlias
                
        SELECT  SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_PRODUTO,SC9.C9_QTDLIB
           FROM SC9010 SC9
                WHERE 
                   SC9.C9_FILIAL = '01' AND 
                   SC9.C9_PEDIDO = %Exp:_cNumPed% AND 
                   SC9.C9_NFISCAL = '         ' AND
                   SC9.%NotDel%
            ORDER BY SC9.C9_ITEM
    EndSql

    dbSelectArea("ZAB")
    dbSetOrder(3)

    While (_cAlias)->(!EOF())

        _cFamilia := Posicione("SB1",1, xFilial("SB1") + (_cAlias)->C9_PRODUTO,"B1_XFAMILI")
        _cLocal   := Posicione("SB1",1, xFilial("SB1") + (_cAlias)->C9_PRODUTO,"B1_LOCPAD")
        _cCfop    := Posicione("SC6",1, xFilial("SC6") + ALLtrim((_cAlias)->C9_PEDIDO) + ALLtrim((_cAlias)->C9_ITEM) + ALLtrim((_cAlias)->C9_PRODUTO),"C6_CF")  //ADD POR CLAUDIO AMBROSINI EM 270922 CHAMADO #1278

        If _cFamilia $ "000001|000002" .And. _lRet .And. _cLocal == "50"
            For _nX:= 1 to (_cAlias)->C9_QTDLIB
                If !alltrim(_cCfop) $ "5923|6923" //ADD POR CLAUDIO AMBROSINI EM 270922 CHAMADO #1278
                    If !ZAB->(MsSeek(xFilial("ZAB")+(_cAlias)->C9_PEDIDO+(_cAlias)->C9_ITEM))
                        _lRet := .F.
                        MsgStop("O produto :  " + ALLtrim((_cAlias)->C9_PRODUTO) +  " - Item :  " + ALLtrim((_cAlias)->C9_ITEM) + "  n�o possui etiqueta de identifica��o. Acione a expedi��o ! OBS: FONTE M05A26","ATENCAO")
                        Exit
                    Endif
                EndIf //ADD POR CLAUDIO AMBROSINI EM 270922 CHAMADO #1278
            Next _nX
        Endif

        (_cAlias)->(dbSkip())
    End
    (_cAlias)->(DbCloseArea())

    RestArea(_aAreaSB1)
    RestArea(_aAreaSC6)
    RestArea(_aAreaSC9) 

Return _lRet
