#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------------------------
//  Utilizado nos lançamentos CT5
//+----------------------------------------------------------------------------------------------------------
User Function M34L02()
    Local _aArea        := GetArea()
    Local _aAreaSRV     := SRV->(GetArea())
    Local _cHIST        := ''

    SRV->(DbSetOrder(1))

    If SRV->(DbSeek( xFilial('SRV') + SRZ->RZ_PD ))
        _cHIST := AllTrim(SRV->RV_COD) + ' ' + AllTrim(SRV->RV_DESC) + ' REF. ' ;
                            + StrZero(Month(dDataBase),2) + '/' + CValToChar(Year(dDataBase))
    EndIf

    RestArea(_aAreaSRV)
    RestArea( _aArea )
Return _cHIST