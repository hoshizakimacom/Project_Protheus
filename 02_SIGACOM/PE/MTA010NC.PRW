//Relaciona campos que não deve ser copiados na inclusão de um novo cadastro de produto.

User Function MTA010NC() 
    Local aCpoNC  := {}
    Local _aAreaTu:= GetArea()

    AAdd( aCpoNC, 'B1_CUSTD' )
    AAdd( aCpoNC, 'B1_MSBLQL' )
    AAdd( aCpoNC, 'B1_XINMETR' )
    AAdd( aCpoNC, 'B1_XURL' )
    AAdd( aCpoNC, 'B1_XFCICOD' )
    AAdd( aCPoNC, 'B1_TIPO' )
    AAdd( aCPoNC, 'B1_XITDESE') //#4347
    AAdd( aCPoNC, 'B1_XDTITDS') //#4347
    AAdd( aCPoNC, 'B1_XUSUALT') //#4347

    RestArea(_aAreaTu)

Return (aCpoNC)
