#Include 'Protheus.ch'


//+------------------------------------------------------------------------------------------------
//  Fun��o chamada da valida��o dos campos da SA2
//+------------------------------------------------------------------------------------------------
User Function M06V02(_cField)
    Local _aArea        := GetArea()
    Local _lRet         := Nil

    Do Case
        Case _cField == 'E2_CODBAR'
            _lRet   := MG06CodBar()


    EndCase

    RestArea(_aArea)
Return _lRet


//+------------------------------------------------------------------------------------------------
Static Function MG06CodBar()

    LOCAL i
    Private LRET    := .F.
    Private CSTR
    Private NMULT
    Private NMODULO
    Private CCHAR
    Private CDIGITO
    Private CDV1
    Private CDV2
    Private CDV3
    Private CCAMPO1
    Private CCAMPO2
    Private CCAMPO3
    Private NVAL
    Private NCALC_DV1
    Private NCALC_DV2
    Private NCALC_DV3
    Private NREST


    if ValType(M->E2_CODBAR) == NIL
        Return(.t.)
    Endif

    cStr := M->E2_CODBAR

    i           := 0
    nMult       := 2
    nModulo     := 0
    cChar       := SPACE(1)
    cDigito     := SPACE(1)

    If len(AllTrim(cStr)) < 44

        cDV1    := SUBSTR(cStr,10, 1)
        cDV2    := SUBSTR(cStr,21, 1)
        cDV3    := SUBSTR(cStr,32, 1)

        cCampo1 := SUBSTR(cStr, 1, 9)
        cCampo2 := SUBSTR(cStr,11,10)
        cCampo3 := SUBSTR(cStr,22,10)

        /*/
        �����������������������������������������������������������������������������
        ��+-----------------------------------------------------------------------+��
        ���Descri��o � Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ���
        ���          � somente e utilizada como validacao do campo E2_CODBAR.     ���
        ���          � Verifica a digitacao do codigo de barras                   ���
        ��+-----------------------------------------------------------------------+��
        �����������������������������������������������������������������������������
        /*/
        // Calcula DV1
        nMult   := 2
        nModulo := 0
        nVal    := 0

        For i := Len(cCampo1) to 1 Step -1
            cChar := Substr(cCampo1,i,1)
            if isAlpha(cChar)
                Help(" ", 1, "ONLYNUM")
                Return(.f.)
            endif
            nModulo := Val(cChar)*nMult
            If nModulo >= 10
                nVal := NVAL + 1
                nVal := nVal + (nModulo-10)
            Else
                nVal := nVal + nModulo
            EndIf
            nMult:= if(nMult==2,1,2)
        Next
        nCalc_DV1 := 10 - (nVal % 10)
        nCalc_DV1 := IIF(nCalc_DV1==10,0,nCalc_DV1)

        // Calcula DV2
        nMult   := 2
        nModulo := 0
        nVal    := 0

        For i := Len(cCampo2) to 1 Step -1
            cChar := Substr(cCampo2,i,1)
            if isAlpha(cChar)
                Help(" ", 1, "ONLYNUM")
                Return(.f.)
            endif
            nModulo := Val(cChar)*nMult
            If nModulo >= 10
                nVal := nVal + 1
                nVal := nVal + (nModulo-10)
            Else
                nVal := nVal + nModulo
            EndIf
            nMult:= if(nMult==2,1,2)
        Next
        nCalc_DV2 := 10 - (nVal % 10)
        nCalc_DV2 := IIF(nCalc_DV2==10,0,nCalc_DV2)

        //
        // Calcula DV3
        //
        nMult := 2
        nModulo := 0
        nVal := 0

        For i := Len(cCampo3) to 1 Step -1
            cChar := Substr(cCampo3,i,1)
            if isAlpha(cChar)
                Help(" ", 1, "ONLYNUM")
                Return(.f.)
            endif
            nModulo := Val(cChar)*nMult
            If nModulo >= 10
                nVal := nVal + 1
                nVal := nVal + (nModulo-10)
            Else
                nVal := nVal + nModulo
            EndIf
            nMult:= if(nMult==2,1,2)
        Next
        nCalc_DV3 := 10 - (nVal % 10)
        nCalc_DV3 := IIF(nCalc_DV3==10,0,nCalc_DV3)

        if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
            Help(" ",1,"INVALCODBAR")
            lRet := .f.
        else
            lRet := .t.
        endif

    Else
        cDigito := SUBSTR(cStr,5, 1)
        cStr    := SUBSTR(cStr,1, 4)+ ;
            SUBSTR(cStr,6,39)

        /*/
        �����������������������������������������������������������������������������
        ��+-----------------------------------------------------------------------+��
        ���Descri��o � Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ���
        ���          � somente e utilizada como validacao do campo E2_CODBAR.     ���
        ���          � Verifica o codigo de barras grafico (Atraves de leitor)    ���
        ��+-----------------------------------------------------------------------+��
        �����������������������������������������������������������������������������
        /*/

        cStr := AllTrim(cStr)

        if Len(cStr) < 43
            Help(" ", 1, "FALTADG")
            Return(.f.)
        Endif

        For i := Len(cStr) to 1 Step -1
            cChar := Substr(cStr,i,1)
            if isAlpha(cChar)
                Help(" ", 1, "ONLYNUM")
                Return(.f.)
            endif
            nModulo := nModulo + Val(cChar)*nMult
            nMult:= if(nMult==9,2,nMult+1)
        Next
        nRest := 11 - (nModulo % 11)
        nRest := if(nRest==10 .or. nRest==11,1,nRest)
        if nRest <> Val(cDigito)
            Help(" ",1,"DgSISPAG")
            lRet := .f.
        else
            lRet := .t.
        endif
    Endif

Return(lRet)

