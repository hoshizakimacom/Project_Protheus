#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------------------------
//  Utilizado nos lançamentos CT5
//+----------------------------------------------------------------------------------------------------------
User Function M34L01(_cOpcao)
    Local _nret     := 0
    Local _cCCFO    := ''

    _cCCFO += '|1102|2102|1403|2403|'                           // Revenda
    _cCCFO += '|1407|2407|1653|2653|1556|2556|'                 // Uso e Consumo
    _cCCFO += '|1406|2406|1551|2551|'                           // Ativo
    _cCCFO += '|1901|2901|1902|2902|1903|2903|1915|2915|1916|2916|1920|2920|1921|2921|1923|2923|1924|2924|1925|2925|1910|2910|1911|2911|1912|2912|1913|2913|1917|2917|1918|2918|1919|2919|1949|2949|'       // Remessa/Retorno

    Do Case
        Case _cOpcao = 'D'   //650 - 001

            If !(Alltrim(SF1->F1_ESPECIE) $ 'NFS|NFPS|NFL' ) .And. (!Alltrim(SD1->D1_CF) $ _cCCFO) .And. SD1->D1_RATEIO <> '1'
                _nret   := SD1->(D1_TOTAL - D1_VALIMP5 - D1_VALIMP6 - D1_VALICM + D1_ICMSRET + D1_VALFRE + D1_SEGURO + D1_DESPESA - D1_VALDESC ) + SF1->F1_VALPEDG + SF1->F1_DESCONT
            Else
                _nret   := 0
            EndIf

        Case _cOpcao = 'C'   //650 - 002
            If !(Alltrim(SF1->F1_ESPECIE) $ 'NFS|NFPS|NFL' ) .AND.(!Alltrim(SD1->D1_CF)$ _cCCFO)
                _nret   := SD1->(D1_TOTAL + D1_ICMSRET + D1_VALIPI + D1_VALFRE + D1_SEGURO + D1_DESPESA) + SF1->F1_VALPEDG
            Else
                _nret   := 0
            EndIf
    EndCase
Return _nret

