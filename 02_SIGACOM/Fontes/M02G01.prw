#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------------------------------------
//| rotina chamada de gatilhos no cadastro de fornecedor - SA2
//+--------------------------------------------------------------------------------------------------------------------------------------
User Function M02G01(cField)
    Local aArea     := GetArea()
    Local xRet      := Nil

    Default cField  := ''

    Do Case


    Case cField == 'A2_COD'
        xRet    := FWFldGet('A2_COD')  //&('M->' + cField)

        MG01SetCod(@xRet)  // Preenche com zeros a esquerda
        MG01SetLj(xRet)    // Retorna a proxima loja para o codigo

    Case cField $ 'A2_TIPO|A2_TPESSOA|'
        xRet    := FWFldGet(cField)

        MG01CCont()

    EndCase

    RestArea(aArea)
Return xRet

//+--------------------------------------------------------------------------------------------------------------------------------------
Static Function MG01CCont()
    Local cConta    := Space(TamSX3('A2_CONTA')[2])
    Local cPartRel  := GetMV('AM_02G01_A',,'')

    If FWfldGet('A2_COD') + FWFldGet('A2_LOJA') $ cPartRel
        cConta  := '2110600003'
    Else
        If !Empty(FWFldGet('A2_TIPO')) .And. !Empty(FWFldGet('A2_TPESSOA'))
            Do Case

            Case FWFldGet('A2_TIPO') $ 'F|J' .And. FWFldGet('A2_TPESSOA') $ 'CI|PF'
                cConta  := '2110600001'

            Case FWFldGet('A2_TIPO') $ 'F|J' .And. FWFldGet('A2_TPESSOA') == 'OS'
                cConta  := '2110600004'

            Case FWFldGet('A2_TIPO') $ 'X'
                cConta  := '2110600002'
            EndCase
        EndIf
    EndIf

    FWFldPut('A2_CONTA',cConta)
Return

//+--------------------------------------------------------------------------------------------------------------------------------------
Static Function MG01SetCod(cCod)

    If !Empty(cCod)
        cCod := PadL(AllTrim(cCod),6,'0')
    EndIf
        
Return

//+--------------------------------------------------------------------------------------------------------------------------------------
Static Function MG01SetLj(cCod)
    Local _cAlias   := GetNextAlias()
    Local cLoja     := StrZero(1,4)

    If !Empty(cCod)
        BeginSql Alias _cAlias
            Select A2_LOJA
            FROM %Table:SA2% SA2
            WHERE SA2.%NotDel%
            AND A2_FILIAL = %xFilial:SA2%
            AND A2_COD = %Exp:cCod%
            ORDER BY A2_LOJA DESC
        EndSql

        If (_cAlias)->(!EOf())
            cLoja := Soma1(PadL(AllTrim( (_cAlias)->A2_LOJA ),4,'0'))
        EndIf
    EndIf

    FWFldPut('A2_LOJA',cLoja)
Return

//+--------------------------------------------------------------------------------------------------------------------------------------