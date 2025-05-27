//Relaciona campos que não devem ser copiados na inclusão de um novo cadastro de produto.

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

    AAdd( aCPoNC, 'B1_XPDF')    //#8187
    AAdd( aCPoNC, 'B1_XDFX')    //#8187
    AAdd( aCPoNC, 'B1_XESTR')   //#8187
    AAdd( aCPoNC, 'B1_XESPLIB') //#8187
    AAdd( aCPoNC, 'B1_XPADRAO') //#8187
    AAdd( aCPoNC, 'B1_XSPRE')   //#8187
    AAdd( aCPoNC, 'B1_XESPES')  //#8187
    AAdd( aCPoNC, 'B1_XMAT')    //#8187
    AAdd( aCPoNC, 'B1_XMDOBRA') //#8187
    AAdd( aCPoNC, 'B1_XDTLIB')  //#8228
    AAdd( aCPoNC, 'B1_XREPENG') //#8228
    
    //AAdd( aCPoNC,  'B1_XFAMILI') //Solicitado por Cibele via e-mail em 15/05/2025
    //AAdd( aCPoNC,  'B1_GRUPO') //Solicitado por Cibele via e-mail em 15/05/2025
    //AAdd( aCPoNC,  'B1_POSIPI') //Solicitado por Cibele via e-mail em 15/05/2025
    //AAdd( aCPoNC,  'B1_ORIGEM') //Solicitado por Cibele via e-mail em 15/05/2025
    
    /*If M->B1_MSBLQL <> '2'
   	    M->B1_MSBLQL := "1" 
    EndIf*/         
	 
        
    
    RestArea(_aAreaTu)

Return (aCpoNC)
