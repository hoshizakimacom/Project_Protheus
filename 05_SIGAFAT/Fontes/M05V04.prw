#Include 'Protheus.ch'

//+---------------------------------------------------------------------------------------------------------------------------------------------
//| Validação SC5/SC6
//+---------------------------------------------------------------------------------------------------------------------------------------------
User Function M05V04(cField,nvalor)
    Local aArea     := GetArea()
    Local lRet      := .T.
    Private nDesc     := 0
    Private nDescFam  := 0

    Default cField  := ''

    Do Case
    Case cField == 'C5_TIPOCLI'
        If !Empty(M->C5_TIPOCLI)
            lRet := MsgYesNo('Deseja alterar o conteúdo do campo Tipo Cliente?' + CRLF + CRLF + "Esta alteração pode influenciar no preço final do pedido.","Atenção!")
        EndIf

    Case cField $ 'C5_CLIENTE|C5_LOJACLI|C5_CLIENT|C5_LOJAENT|'
        If !Empty(M->C5_TIPOCLI)
            If Posicione("SA1",1,xFilial("SA1")+M->(C5_CLIENTE + C5_LOJACLI),"A1_TIPO") <> M->C5_TIPOCLI
                lRet := MsgYesNo('Deseja alterar o conteúdo do campo Tipo Cliente?' + CRLF + CRLF + "Esta alteração pode influenciar no preço final do pedido.","Atenção!")
            EndIf
        EndIf

    // Valida desconto total
    Case cField $ 'C5_DESC1|C5_DESC2|C5_DESC3|C5_DESC4|C5_DESCONT|'
        lRet := U_M05A28('PV',.F.)

    Case cField $ 'C6_DESCONT'
        lRet := U_M05A28('PV',.T.,nvalor)
        
    Case cField $ 'CK_DESCONT'
        lRet := U_M05A28('OV',.T.,nvalor)        

    Case cField == 'C6_PRODUTO'
        lRet   := MV05Prod(M->C6_PRODUTO)

    EndCase

    RestArea(aArea)
Return lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
Static Function MV05Prod(_cProduto)
    Local _lRet         := .T.
    Local _aAreaSB1     := {}

    If __lComerc .And. !Empty(_cProduto)
        _aAreaSB1     := SB1->(GetArea())

        _lRet := Posicione('SB1',1,xFilial('SB1') + _cProduto,'B1_TIPO') $ 'PA-ME'

        If !_lRet
            MsgInfo(I18N('Produto #1 não localizado.' + CRLF + 'Verifique!',{_cProduto}),'Atenção')
        EndIf

        RestArea(_aAreaSB1)
    EndIf
Return _lRet

//+---------------------------------------------------------------------------------------------------------------------------------------------
