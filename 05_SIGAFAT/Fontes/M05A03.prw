#Include 'Protheus.ch'

//+-----------------------------------------------------------------------------
// Calcula pre�o * quantidade considerando descontos
//+-----------------------------------------------------------------------------
User Function M05A03(_cFunc)

	Local _nPerDesc	:= 0
	Local _nQtd		:= 0
	Local _nVlToBr	:= 0
	Local _nVlUnBr	:= 0
	Local _nValor	:= 0
	Local _nPrcVen	:= 0
	Local _nPS2		:= 0
	Local _nSol		:= 0
	Local _nCF2		:= 0
	Local _nDIF		:= 0
	Local _nIPI		:= 0
	Local _nICM		:= 0
	Local _nICMOri	:= 0
	Local _nICMDes	:= 0
	Local _nTot		:= 0
	
	Local nPercFrete:= 0
	Local nPercInsta:= 0
	Local _nValFret	:= 0
	Local nValInsta	:= 0
	Private _nValDesc	:= 0

	GetValue(_cFunc,@_nPrcVen,@_nQtd,@_nPS2,@_nCF2,@_nDIF,@_nIPI,@_nICM,@_nICMOri,@_nICMDes,@_nTot,@_nVlToBr,@_nVlUnBr,@_nSol,@nPercFrete,@nPercInsta)

	//+-------------------------------------------------------
	// Aplica desconto do cabe�alho em cascata
	//+-------------------------------------------------------
	_nPerDesc	:= A410Arred(U_M05A04(_cFunc),'C6_DESCONT')

	SetDesc(_nPerDesc,@_nPrcVen,@_nPS2,@_nCF2,@_nDIF,@_nIPI,@_nICM,@_nICMOri,@_nICMDes,@_nTot,@_nVlToBr,@_nVlUnBr,@_nSol)


	//+-------------------------------------------------------
	// Aplica desconto do item
	//+-------------------------------------------------------
	_nPDesc := GetDescIte(_cFunc)

	SetDesc(_nPDesc,@_nPrcVen,@_nPS2,@_nCF2,@_nDIF,@_nIPI,@_nICM,@_nICMOri,@_nICMDes,@_nTot,@_nVlToBr,@_nVlUnBr,@_nSol)


	//+-------------------------------------------------------
	// Multiplica quantidade
	//+-------------------------------------------------------
	SetQtd(_nQtd,@_nPrcVen,@_nPS2,@_nCF2,@_nDIF,@_nIPI,@_nICM,@_nICMOri,@_nICMDes,@_nTot,@_nVlToBr,_nVlUnBr,@_nValor,@_nSol,@_nValFret,nPercFrete,@nValInsta,nPercInsta)


	//+-------------------------------------------------------
	// Atualiza valores
	//+-------------------------------------------------------
	SetValue(_cFunc,_nPrcVen,_nValor,_nVlToBr,_nVlUnBr,_nIPI,_nICM,_nICMOri,_nICMDes,_nPS2,_nCF2,_nDIF,_nTot,_nSol,_nValFret,nValInsta)

Return

//+-----------------------------------------------------------------------------
Static Function GetDescIte(_cFunc)
	Do Case
	Case _cFunc == 'PV'
		_nPDesc		:= (1 - (GdFieldGet('C6_DESCONT',n) / 100)) * (1 + (GdFieldGet('C6_XACRESC',n) / 100))
	Case _cFunc == 'OV'
		_nPDesc		:= (1 - (TMP1->(FieldGet(FieldPos('CK_XDESCON'))) / 100)) * (1 + (TMP1->(FieldGet(FieldPos('CK_XACRESC'))) / 100))
	EndCase

Return _nPDesc

//+-----------------------------------------------------------------------------
Static Function SetValue(_cFunc,_nPrcVen,_nValor,_nVlToBr,_nVlUnBr,_nIPI,_nICM,_nICMOri,_nICMDes,_nPS2,_nCF2,_nDIF,_nTot,_nSol,_nValFret,nValInsta)

	Do Case
	Case _cFunc == 'PV'
		GdFieldPut('C6_PRCVEN'	,_nPrcVen		,n)
		GdFieldPut('C6_PRUNIT'	,_nPrcVen		,n)
		GdFieldPut('C6_VALOR'	,_nValor		,n)
		GdFieldPut('C6_XVLTBRU'	,_nVlToBr		,n)
		GdFieldPut('C6_XVLTIPI'	,_nIPI			,n)
		GdFieldPut('C6_XVLTICM'	,_nICM			,n)
		GdFieldPut('C6_XVLTICO'	,_nICMOri		,n)
		GdFieldPut('C6_XVLTICD'	,_nICMDes		,n)
		GdFieldPut('C6_XVLTSOL'	,_nSol			,n)
		GdFieldPut('C6_XVLTPS2'	,_nPS2			,n)
		GdFieldPut('C6_XVLTCF2'	,_nCF2			,n)
		GdFieldPut('C6_XVLTFCP'	,_nDIF			,n)
		GdFieldPut('C6_XVLTIMP'	,_nTot			,n)
		GdFieldPut('C6_XFRETE'	,_nValFret   	,n)
		GdFieldPut('C6_XINSTA'	,nValInsta   	,n)
		GdFieldPut('C6_VALDESC'	,0				,n)

	Case _cFunc == 'OV'
		TMP1->(FieldPut(FieldPos('CK_PRCVEN')	,_nPrcVen))
		TMP1->(FieldPut(FieldPos('CK_PRUNIT')	,_nPrcVen))
		TMP1->(FieldPut(FieldPos('CK_VALOR')	,_nValor))
		TMP1->(FieldPut(FieldPos('CK_XVLTBRU')	,_nVlToBr))
		TMP1->(FieldPut(FieldPos('CK_XVLTIPI')	,_nIPI))
		TMP1->(FieldPut(FieldPos('CK_XVLTICM')	,_nICM))
		TMP1->(FieldPut(FieldPos('CK_XVLTICO')	,_nICMOri))
		TMP1->(FieldPut(FieldPos('CK_XVLTICD')	,_nICMDes))
		TMP1->(FieldPut(FieldPos('CK_XVLTSOL')	,_nSol))
		TMP1->(FieldPut(FieldPos('CK_XVLTPS2')	,_nPS2))
		TMP1->(FieldPut(FieldPos('CK_XVLTCF2')	,_nCF2))
		TMP1->(FieldPut(FieldPos('CK_XVLTFCP')	,_nDIF))
		TMP1->(FieldPut(FieldPos('CK_XVLTIMP')	,_nTot))
		TMP1->(FieldPut(FieldPos('CK_XFRETE')	,_nValFret))
		TMP1->(FieldPut(FieldPos('CK_XINSTA')	,nValInsta))
		TMP1->(FieldPut(FieldPos('CK_VALDESC')	,0))
		TMP1->(FieldPut(FieldPos('CK_DESCONT')	,TMP1->(FieldGet(FieldPos('CK_XDESCON')))))
	EndCase
Return

//+-----------------------------------------------------------------------------
Static Function SetQtd(_nQtd,_nPrcVen,_nPS2,_nCF2,_nDIF,_nIPI,_nICM,_nICMOri,_nICMDes,_nTot,_nVlToBr,_nVlUnBr,_nValor,_nSol,_nValFret,nPercFrete,nValInsta,nPercInsta)

	Private	_nVlToBrBKP := _nVlToBr
	
	// +----------------------------------------------------------+
    // | Ajuste efetuado quando � zerado o percentual de desconto |
    // | no cabe�alho do pedido de vendas.                        |
    // +----------------------------------------------------------+
//	If ReadVar() $ 'M->C5_DESC1|M->C5_DESC2|M->C5_DESC3|M->C5_DESC4'
//		If GdFieldGet('C6_XOPER',n) $ "03|04"
//			_nPrcVen := _nVlUnBr
//		Endif
//	ElseIf ReadVar()=='M->C6_OPER' .And. SC5->C5_DESC1 <> 0 .And. GdFieldGet('C6_XOPER',n) $ "03|04"
//		_nPrcVen := _nVlUnBr	
//	Endif
	
	_nValor		:= A410Arred(_nPrcVen 		* _nQtd,'C6_VALOR')
	_nSol		:= A410Arred(_nSol			* _nQtd,'C6_XVLTSOL')
	_nPS2		:= A410Arred(_nPS2			* _nQtd,'C6_XVLTPS2')
	_nCF2		:= A410Arred(_nCF2			* _nQtd,'C6_XVLTCF2')
	_nDIF		:= A410Arred(_nDIF			* _nQtd,'C6_XVLTFCP')
	_nIPI		:= A410Arred(_nIPI			* _nQtd,'C6_XVLTIPI')
	_nICM		:= A410Arred(_nICM		 	* _nQtd,'C6_XVLTICM')

	_nICMOri	:= A410Arred(_nICMOri		* _nQtd,'C6_XVLUICO')
	_nICMDes	:= A410Arred(_nICMDes		* _nQtd,'C6_XVLUICD')

	_nTot		:= A410Arred(_nTot 			* _nQtd,'C6_XVLTIMP')
	_nVlToBr	:= A410Arred(_nVlUnBr 		* _nQtd,'C6_XVLTBRU')
	_nValFret	:= A410Arred((_nVlUnBr 		* _nQtd) * ( nPercFrete / 100),'C6_XFRETE')
	nValInsta	:= A410Arred((_nVlUnBr 		* _nQtd) * ( nPercInsta / 100),'C6_XINSTA')
	
    //+--------------------------------------------------------------+
    //|  Ajuste efetuado atentendo solicita��o da usu�ria            |
    //|  Cibele para ajuste autom�tico do valor unit�rio             |
    //|  nas opera��es :                                             |
    //|  03 - Venda Entrega Futura                                   |
    //|  04 - Revenda Entrega Futura                                 |
    //|  27 - Lan�amento a T�tulo de Simples Faturamento             |
    //|  44 - Simples Faturamento - Opera��o Revenda                 |
    //|  Nestes casos, restauro o valor original do campo C6_XVLTBRU |
    //+--------------------------------------------------------------+
//	If IsInCallStack("MATA410")
//		If GdFieldGet('C6_XOPER',n) $ "03|04|27|44" .And. !ReadVar() $ 'M->C5_DESC1|M->C5_DESC2|M->C5_DESC3|M->C5_DESC4' .And. SC5->C5_DESC1 == 0
//			_nPrcVen := _nVlToBrBKP
//		Endif
//	Endif
	//+-----------------+
	//|  Fim do ajuste  |
	//+-----------------+

Return


//+-----------------------------------------------------------------------------
Static Function GetValue(_cFunc,_nPrcVen,_nQtd,_nPS2,_nCF2,_nDIF,_nIPI,_nICM,_nICMOri,_nICMDes,_nTot,_nVlToBr,_nVlUnBr,_nSol,nPercFrete,nPercInsta)

	Do Case
	Case _cFunc == 'PV'
		_nPrcVen		:= GdFieldGet('C6_XVLULIQ',n)
		_nQtd			:= GdFieldGet('C6_QTDVEN',n)
		_nSol			:= GdFieldGet('C6_XVLUSOL',n)
		_nPS2			:= GdFieldGet('C6_XVLUPS2',n)
		_nCF2			:= GdFieldGet('C6_XVLUCF2',n)
		_nDIF			:= GdFieldGet('C6_XVLUFCP',n)
		_nIPI			:= GdFieldGet('C6_XVLUIPI',n)

		_nICM			:= GdFieldGet('C6_XVLUICM',n)
		_nICMOri		:= GdFieldGet('C6_XVLUICO',n)
		_nICMDes		:= GdFieldGet('C6_XVLUICD',n)

		_nTot			:= GdFieldGet('C6_XVLUIMP',n)
		_nVlToBr		:= GdFieldGet('C6_XVLTBRU',n)
		_nVlUnBr		:= GdFieldGet('C6_XVLUBRU',n)
		nPercFrete		:= M->C5_XFRETE
		nPercInsta		:= M->C5_XINSTA
		
	    //+--------------------------------------------------------------+
    	//|  Ajuste efetuado atentendo solicita��o da usu�ria            |
	    //|  Cibele para ajuste autom�tico do valor unit�rio             |
	    //|  nas opera��es :                                             |
	    //|  03 - Venda Entrega Futura                                   |
	    //|  04 - Revenda Entrega Futura                                 |
	    //|  27 - Lan�amento a T�tulo de Simples Faturamento             |
	    //|  44 - Simples Faturamento - Opera��o Revenda                 |
	    //|  Nestes casos, restauro o valor original do campo C6_PRCVEN  |
	    //+--------------------------------------------------------------+
//		If GdFieldGet('C6_XOPER',n) $ "03|04|27|44" .And. SC5->C5_DESC1 == 0
//			_nPrcVen	:= GdFieldGet('C6_PRCVEN',n) 
//		Endif
//		If GdFieldGet('C6_XOPER',n) $ "27|44"
//			_nVlUnBr	:=	GdFieldGet('C6_XVLTBRU',n) / _nQtd
//			GdFieldPut('C6_XVLUBRU'	,_nVlUnBr      ,n)
//			_nPrcVen += GdFieldGet('C6_XVLUSOL',n) // C6_XVLUSOL
//		Endif
		//+-----------------+
		//|  Fim do ajuste  | 
		//+-----------------+
	Case _cFunc == 'OV'
		_nPrcVen		:= TMP1->(FieldGet(FieldPos('CK_XVLULIQ')))
		_nQtd			:= TMP1->(FieldGet(FieldPos('CK_QTDVEN')))
		_nSol			:= TMP1->(FieldGet(FieldPos('CK_XVLUSOL')))
		_nPS2			:= TMP1->(FieldGet(FieldPos('CK_XVLUPS2')))
		_nCF2			:= TMP1->(FieldGet(FieldPos('CK_XVLUCF2')))
		_nDIF			:= TMP1->(FieldGet(FieldPos('CK_XVLUFCP')))
		_nIPI			:= TMP1->(FieldGet(FieldPos('CK_XVLUIPI')))

		_nICM			:= TMP1->(FieldGet(FieldPos('CK_XVLUICM')))
		_nICMOri		:= TMP1->(FieldGet(FieldPos('CK_XVLUICO')))
		_nICMDes		:= TMP1->(FieldGet(FieldPos('CK_XVLUICD')))

		_nTot			:= TMP1->(FieldGet(FieldPos('CK_XVLUIMP')))
		_nVlToBr		:= TMP1->(FieldGet(FieldPos('CK_XVLTBRU')))
		_nVlUnBr		:= TMP1->(FieldGet(FieldPos('CK_XVLUBRU')))
		nPercFrete      := M->CJ_XFRETE
		nPercInsta      := M->CJ_XINSTA
	EndCase
Return

//+-----------------------------------------------------------------------------
// Aplica descontos
//+-----------------------------------------------------------------------------
Static Function SetDesc(_nDesc,_nPrcVen,_nPS2,_nCF2,_nDIF,_nIPI,_nICM,_nICMOri,_nICMDes,_nTot,_nVlToBr,_nVlUnBr,_nSol)

	_nPrcVen	:= A410Arred(_nPrcVen 	* _nDesc,'C6_VALOR')
	_nSol		:= A410Arred(_nSol 		* _nDesc,'C6_XVLTSOL')
	_nPS2		:= A410Arred(_nPS2 		* _nDesc,'C6_XVLTPS2')
	_nCF2		:= A410Arred(_nCF2		* _nDesc,'C6_XVLTCF2')
	_nDIF		:= A410Arred(_nDIF		* _nDesc,'C6_XVLTFCP')
	_nIPI		:= A410Arred(_nIPI		* _nDesc,'C6_XVLTIPI')
	_nICM		:= A410Arred(_nICM		* _nDesc,'C6_XVLTICM')

	_nICMOri	:= A410Arred(_nICMOri	* _nDesc,'C6_XVLUICO')
	_nICMDes	:= A410Arred(_nICMDes	* _nDesc,'C6_XVLUICD')

	_nTot		:= A410Arred(_nTot		* _nDesc,'C6_XVLTIMP')
	_nVlToBr	:= A410Arred(_nVlToBr	* _nDesc,'C6_XVLTBRU')
	_nVlUnBr	:= A410Arred(_nVlUnBr	* _nDesc,'C6_XVLTBRU')

Return
