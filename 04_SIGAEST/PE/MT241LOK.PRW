User Function MT241LOK()

//Local n         := ParamIxb[1]
//Local _cTipPro  := Posicione("SB1",1,xFilial("SB1")+Alltrim(aCols[n,1]),"B1_TIPO")
Local _lRet     := .T.
Local _cCodUsr  := RetCodusr()

Do Case
	Case DA241DATA > DATE() .Or. DA241DATA > DDATABASE
		_lRet := .F.
		MsgInfo("Data do movimento inválida. Não é permitido realizar baixas com data futura.","ATENCAO")

	//Case _cTipPro $ "ME|PA" .And. CTM <> "503"
    //	_lRet := .F.
	//    MsgStop("Movimentação não permitida! Informe a controladoria.","ATENCAO")

	Case CTM == "503" .And. ! _cCodUsr $  GETMV("MV_XPALB01")//"000151|000203|000260|000361" //trocado por MV_XPALB01
        _lRet := .F.
	    MsgStop("Operador não autorizado a efetuar movimentos de baixas para transformação!","ATENCAO")

    Case CTM == "503" .And. Empty(GDFIELDGET("D3_XNUMSER")) .And. Empty(GDFIELDGET("D3_OP"))
        _lRet := .F.
    	MsgAlert("Para movimentos de transformação, é necessário informar o numero de série e o numero da ordem de produção do produto final.","ATENCAO")

	Case CTM == "501" .Or. CTM == "101"
		If ! _cCodUsr $ GETMV("MV_XPALB02")//"000053|000058|000099|000124|000251|000231|000263|000296|000297|000298|000323|000260|000374|000366|000414|000131|000361|000420|000475"// trocado por MV_XPALB02
			_lRet := .F.
	    	MsgStop("Operador não autorizado a efetuar movimentos de baixas ou devoluções ao estoque!","ATENCAO")
		Endif

    Case CTM == "002"
		If ! _cCodUsr $ GETMV("MV_XPALB03")//"000203|000251|000124|000298|000260"//trocado por MV_XPALB03
			_lRet := .F.
	    	MsgStop("Operador não autorizado a efetuar apontamento de produção!","ATENCAO")
		Endif

	Case CTM == "499" .Or. CTM == "999"
		If ! _cCodUsr $ GETMV("MV_XPALB04")//"000053|000251|000058|000296|000263|000297|000231|000124|000099|000203|000260" //trocado por MV_XPALB04
			_lRet := .F.
	    	MsgStop("Operador não autorizado a efetuar movimentos de transferencia!","ATENCAO")
		Endif

	Case CTM == "499" .Or. CTM == "999"
		If ! _cCodUsr $ GETMV("MV_XPALB05")//"000109|000260" //trocado por MV_XPALB05
			_lRet := .F.
	    	MsgStop("Operador não autorizado a efetuar movimentos de baixas ou devoluções para fabrica !","ATENCAO") 
		Endif	    
EndCase

Return _lRet
