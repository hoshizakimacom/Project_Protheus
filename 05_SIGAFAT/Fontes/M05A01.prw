#Include 'Protheus.ch'

//------------------------------------------------------------------------------
//	Rotina de calcualo de preço
//------------------------------------------------------------------------------
User Function M05A01(_cFunc,lAtuOper)
    Local _nPrecoVend	:= 0
    Local _cTipo		:= ''
    Local _cTipoCli		:= ''

    Local _nXPrcTab		:= 0
    Local _cProduto		:= ''
    Local _cTES			:= ''

    Local _nAliqImp		:= 0
    Local _nPis			:= 0
    Local _nCofins		:= 0
    Local _nICMS		:= 0
    Local _nICMOri		:= 0
    Local _nICMDes		:= 0
    Local _nIPI			:= 0

    Local _nAliqICM		:= 0
    Local _nAliqFCP		:= 0
    Local _nXVlrImp		:= 0

    Local _cClient		:= ''
    Local _cLoja		:= ''
    Local _nQtd			:= 0
    Local _nBasICM      := 0

    Local _nSol         := 0

    Default lAtuOper    := .T.


    SetPrcTab(_cFunc)		// Atualiza preço de tabela


    If lAtuOper
        SetOper(_cFunc)			// Atualiza tipo de operação
    EndIf

    If lAtuOper
        SetTES(_cFunc)			// Atualiza TES
    EndIf

    MaFisEnd()

    GetValueIt(_cFunc,@_cProduto,@_cTES,@_nXPrcTab,@_nQtd,@_nBasICM)
    GetValueCa(_cFunc,@_cTipo,@_cTipoCli,@_cClient,@_cLoja)	// retorna tipo do cliente

    //+---------------------------------------------------------------
    // CALCULA VALOR DE VENDA
    //+---------------------------------------------------------------
    MaFisIni(_cClient,_cLoja,_cTipo,"N",_cTipoCli,Nil,Nil,Nil,Nil,"MATA410")

    MaFisAdd(_cProduto,_cTES,1,_nXPrcTab -  0,0,"","",Nil,0,0,0,0,_nXPrcTab,0)

    _nAliqICM	:= MaFisRet(1,'IT_ALIQICM')
    _nPis		:= GetPis('ALIQ')					// Aliquota PIS
    _nCofins	:= GetCofins('ALIQ')				// Aliquota Cofins
    _nICMS		:= GetICM('ALIQ',_cTES,_nAliqICM)	// Aliquota ICMS
    _nICMOri	:= GetICMOri('ALIQ',_nAliqICM) 		// ICMS Complementar
    _nICMDes	:= GetICMDes('ALIQ',_nAliqICM) 		// ICMS Complementar
    _nAliqFCP	:= GetFCP('ALIQ')				// ICMS Fundo de Apoio e Combate a Pobreza
    _nIPI		:= GetIPI('ALIQ',_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_cTES,_cProduto,_cTipoCli)
    _nSol       := GetSol('ALIQ')                // Aliquota ICM Sol

    MaFisEnd()

    _nAliqImp				:= _nPis + _nCofins + _nICMS + _nICMOri + _nICMDes + _nIPI + _nAliqFCP
    _nPrecoVend				:= A410Arred(_nXPrcTab / ( ((_nAliqImp / 100) -1)  * (-1)),'C6_PRCVEN')

    SetPrcVen(_cFunc,_nPrecoVend)
    SetAliImp(_cFunc,_nPis,_nCofins,_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_nIPI,_nAliqImp,_nSol)

    //+---------------------------------------------------------------
    // CALCULA VALOR IMPOSTOS
    //+---------------------------------------------------------------
    MaFisIni(_cClient,_cLoja,_cTipo,"N",_cTipoCli,Nil,Nil,Nil,Nil,"MATA410")

    MaFisAdd(_cProduto,_cTES,1,_nPrecoVend -  0,0,"","",Nil,0,0,0,0,_nPrecoVend * 1,0)

    _nPis		:= GetPis('VLR')
    _nCofins 	:= GetCofins('VLR')
    _nICMS		:= GetICM('VLR')
    _nICMOri	:= GetICMOri('VLR',_nAliqICM)
    _nICMDes	:= GetICMDes('VLR',_nAliqICM)
    _nAliqFCP	:= GetFCP('VLR')
    _nIPI		:= GetIPI('VLR',_nICMS,_nICMOri,_nICMDes,_nAliqFCP,'','',_cTipoCli)
    _nXVlrImp 	:= MaFisRet(,'NF_TOTAL')
    _nSol       := GetSol('VLR')


    SetPrcImp(_cFunc,_nPis,_nCofins,_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_nIPI,_nXVlrImp,_nBasICM,_nSol)
    SetVlUnit(_cFunc,_nPrecoVend,_nQtd)

    MaFisEnd()

    // Calcula valores totais com desconto/acrescimo
    U_M05A03(_cFunc)

Return _nPrecoVend

//+----------------------------------------------------------------------------------------------------
Static Function SetVlUnit(_cFunc,_nPrecoVend,_nQtd)
    Local _nTotalSol	:= 0
    Local _nTotalPS2	:= 0
    Local _nTotalCF2	:= 0
    Local _nTotalDIF	:= 0
    Local _nTotalIPI	:= 0
    Local _nTotalICM	:= 0
    Local _nTotICOri	:= 0
    Local _nTotICDes	:= 0
    Local _nTotalImp	:= 0

    Do Case
    Case _cFunc == 'PV'
        _nTotalSol	:= A410Arred( GdFieldGet('C6_XVLUSOL'	,n) * _nQtd ,'C6_XVLTSOL')
        _nTotalPS2	:= A410Arred( GdFieldGet('C6_XVLUPS2'	,n) * _nQtd ,'C6_XVLTPS2')
        _nTotalCF2	:= A410Arred( GdFieldGet('C6_XVLUCF2'	,n) * _nQtd ,'C6_XVLTCF2')
        _nTotalDIF	:= A410Arred( GdFieldGet('C6_XVLUFCP'	,n) * _nQtd ,'C6_XVLTFCP')
        _nTotalIPI	:= A410Arred( GdFieldGet('C6_XVLUIPI'	,n) * _nQtd ,'C6_XVLTIPI')
        _nTotalICM	:= A410Arred( GdFieldGet('C6_XVLUICM'	,n) * _nQtd ,'C6_XVLTICM')
        _nTotICOri	:= A410Arred( GdFieldGet('C6_XVLUICO'	,n) * _nQtd ,'C6_XVLTICO')
        _nTotICDes	:= A410Arred( GdFieldGet('C6_XVLUICD'	,n) * _nQtd ,'C6_XVLTICD')
        _nTotalImp	:= A410Arred( GdFieldGet('C6_XVLUIMP'	,n) * _nQtd ,'C6_XVLTIMP')

    Case _cFunc == 'OV'

        _nTotalSol	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUSOL'))) * _nQtd ,'CK_XVLTSOL')
        _nTotalPS2	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUPS2'))) * _nQtd ,'CK_XVLTPS2')
        _nTotalCF2	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUCF2'))) * _nQtd ,'CK_XVLTCF2')
        _nTotalDIF	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUFCP'))) * _nQtd ,'CK_XVLTFCP')
        _nTotalIPI	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUIPI'))) * _nQtd ,'CK_XVLTIPI')
        _nTotalICM	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUICM'))) * _nQtd ,'CK_XVLTICM')
        _nTotICOri	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUICO'))) * _nQtd ,'CK_XVLTICO')
        _nTotICDes	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUICD'))) * _nQtd ,'CK_XVLTICD')
        _nTotalImp	:= A410Arred( TMP1->(FieldGet(FieldPos('CK_XVLUIMP'))) * _nQtd ,'CK_XVLTIMP')

    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function SetPrcImp(_cFunc,_nPis,_nCofins,_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_nIPI,_nXVlrImp,_nBasICM,_nSol)

    Do Case
    Case _cFunc == 'PV'

        GdFieldPut('C6_XVLUSOL'	,_nSol					,n)
        GdFieldPut('C6_XVLUIPI'	,_nIPI					,n)
        GdFieldPut('C6_XVLUICM'	,_nICMS					,n)
        GdFieldPut('C6_XVLUICO'	,_nICMOri				,n)
        GdFieldPut('C6_XVLUICD'	,_nICMDes				,n)
        GdFieldPut('C6_XVLUPS2'	,_nPis					,n)
        GdFieldPut('C6_XVLUCF2'	,_nCofins				,n)
        GdFieldPut('C6_XVLUFCP'	,_nAliqFCP				,n)
        GdFieldPut('C6_XVLUBRU'	,_nXVlrImp				,n)
        GdFieldPut('C6_XVLUIMP'	,(_nPis + _nCofins + _nICMS + _nICMOri + _nICMDes + _nAliqFCP + _nIPI)			,n)

        GdFieldPut('C6_XBASICM' ,_nBasICM              ,n)

    Case _cFunc == 'OV'
        TMP1->(FieldPut(FieldPos('CK_XVLUSOL')	,_nSol))
        TMP1->(FieldPut(FieldPos('CK_XVLUIPI')	,_nIPI))
        TMP1->(FieldPut(FieldPos('CK_XVLUICM')	,_nICMS))
        TMP1->(FieldPut(FieldPos('CK_XVLUICO')	,_nICMOri))
        TMP1->(FieldPut(FieldPos('CK_XVLUICD')	,_nICMDes))
        TMP1->(FieldPut(FieldPos('CK_XVLUPS2')	,_nPis))
        TMP1->(FieldPut(FieldPos('CK_XVLUCF2')	,_nCofins))
        TMP1->(FieldPut(FieldPos('CK_XVLUFCP')	,_nAliqFCP))
        TMP1->(FieldPut(FieldPos('CK_XVLUBRU')	,_nXVlrImp))
        TMP1->(FieldPut(FieldPos('CK_XVLUIMP')	,(_nPis + _nCofins + _nICMS + _nICMOri + _nICMDes + _nAliqFCP + _nIPI)))
    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function SetAliImp(_cFunc,_nPis,_nCofins,_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_nIPI,_nAliqImp,_nSol)

    Do Case
    Case _cFunc == 'PV'
        GdFieldPut('C6_XALQIPI'	,_nIPI				,n)
        GdFieldPut('C6_XALQICM'	,_nICMS				,n)
        GdFieldPut('C6_XALQICO'	,_nICMOri  			,n)
        GdFieldPut('C6_XALQICD'	,_nICMDes			,n)
        GdFieldPut('C6_XALQPS2'	,_nPis				,n)
        GdFieldPut('C6_XALQCF2'	,_nCofins			,n)
        GdFieldPut('C6_XALQFCP'	,_nAliqFCP			,n)
        GdFieldPut('C6_XALQIMP'	,_nAliqImp			,n)
        GdFieldPut('C6_XALQSOL'	,_nSol			    ,n)

    Case _cFunc == 'OV'
        TMP1->(FieldPut(FieldPos('CK_XALQIPI')	,_nIPI))
        TMP1->(FieldPut(FieldPos('CK_XALQICM')	,_nICMS))
        TMP1->(FieldPut(FieldPos('CK_XALQICO')	,_nICMOri))
        TMP1->(FieldPut(FieldPos('CK_XALQICD')	,_nICMDes))
        TMP1->(FieldPut(FieldPos('CK_XALQPS2')	,_nPis))
        TMP1->(FieldPut(FieldPos('CK_XALQCF2')	,_nCofins))
        TMP1->(FieldPut(FieldPos('CK_XALQFCP')	,_nAliqFCP))
        TMP1->(FieldPut(FieldPos('CK_XALQIMP')	,_nAliqImp))
        TMP1->(FieldPut(FieldPos('CK_XALQSOL')	,_nSol))
    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function SetPrcVen(_cFunc,_nRet,lAtuValor)

    Default lAtuValor := .F.

    Do Case
    Case _cFunc == 'PV'

        GdFieldPut('C6_PRCVEN'	,_nRet				,n)
        GdFieldPut('C6_PRUNIT'	,_nRet				,n)
        GdFieldPut('C6_XVLULIQ'	,_nRet				,n)

        If lAtuValor
            GdFieldPut('C6_VALOR'	,_nRet	* GdFieldGet('C6_QTDVEN'   ,n)			,n)
        EndIf

    Case _cFunc == 'OV'
        TMP1->(FieldPut(FieldPos('CK_PRCVEN')	,_nRet))
        TMP1->(FieldPut(FieldPos('CK_PRUNIT')	,_nRet))
        TMP1->(FieldPut(FieldPos('CK_XVLULIQ')	,_nRet))

        If lAtuValor
            TMP1->(FieldPut(FieldPos('CK_VALOR')	,_nRet * TMP1->(FieldGet(FieldPos('CK_QTDVEN'))) ))
        EndIf
    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function GetValueIt(_cFunc,_cProduto,_cTES,_nXPrcTab,_nQtd,_nBasICM)

    Do Case
    Case _cFunc == 'PV'
        _cProduto		:= GdFieldGet('C6_PRODUTO'	,n)
        _cTES			:= GdFieldGet('C6_TES'		,n)
        _nXPrcTab		:= GdFieldGet('C6_XVLUTAB'	,n)
        _nQtd			:= GdFieldGet('C6_QTDVEN'	,n)

        _nBasICM     := Posicione('SF4',1,xFilial('SF4') + _cTES ,'F4_BASEICM')

    Case _cFunc == 'OV'
        _cProduto		:= TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
        _cTES			:= TMP1->(FieldGet(FieldPos('CK_TES')))
        _nXPrcTab		:= TMP1->(FieldGet(FieldPos('CK_XVLUTAB')))
        _nQtd			:= TMP1->(FieldGet(FieldPos('CK_QTDVEN')))

         _nBasICM     := Posicione('SF4',1,xFilial('SF4') + _cTES ,'F4_BASEICM')
    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function GetValueCa(_cFunc,_cTipo,_cTipoCli,_cClient,_cLoja)

    Do Case
    Case _cFunc == 'PV'
        _cClient	:= M->C5_CLIENTE
        _cLoja		:= M->C5_LOJACLI

        If M->C5_TIPO <> "B"
            _cTipo	 	:= "C" 				//Cliente
            _cTipoCli 	:= Posicione("SA1",1,xFilial("SA1") + _cClient + _cLoja,"A1_TIPO")
        Else
            _cTipo	 	:= "F" 				//Fornecedor
            _cTipoCli 	:= Posicione("SA2",1,xFilial("SA2") + _cClient + _cLoja,"A2_TIPO")
        EndIf

    Case _cFunc == 'OV'
        _cClient		:= M->CJ_CLIENT
        _cLoja			:= M->CJ_LOJA
        _cTipo	 		:= "C" 				//Cliente
        _cTipoCli 		:= Posicione("SA1",1,xFilial("SA1") + _cClient + _cLoja,"A1_TIPO")
    EndCase
Return

//+----------------------------------------------------------------------------------------------------
Static Function GetPis(_cRef)
    Local _nRet	:= 0

    If _cRef == 'ALIQ'
        _nRet	:= MaFisRet(1,'IT_ALIQPS2')
    Else
        _nRet	:= MaFisRet(1,'IT_VALPS2')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetCofins(_cRef)
    Local _nRet	:= 0

    If _cRef == 'ALIQ'
        _nRet	:= MaFisRet(1,'IT_ALIQCF2')
    Else
        _nRet	:= MaFisRet(1,'IT_VALCF2')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetSol(_cRef)
    Local _nRet	:= 0

    If _cRef == 'ALIQ'
        _nRet	:= MaFisRet(1,'IT_ALIQSOL')
    Else
        _nRet	:= MaFisRet(1,'IT_VALSOL')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetICM(_cRef,_cTES,_nAliqICM)
    Local _nRet			:= 0
    Local _nPerICM		:= 0


    If _cRef == 'ALIQ'
        _nPerICM		:= Posicione('SF4',1,xFilial('SF4') + _cTES ,'F4_BASEICM') / 100

        If _nPerICM > 0
            _nRet := _nAliqICM * _nPerICM
        Else
            _nRet	:= _nAliqICM
        EndIf
    Else
        _nRet	:= MaFisRet(1,'IT_VALICM')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetICMDes(_cRef,_nAliqICM)
    Local _nRet	:= 0

    If _cRef == 'ALIQ'
        _nRet 		:= (MaFisRet(1,'IT_DIFAL') * 100) / MaFisRet(1,'IT_BASEICM')
    Else
        _nRet		:= MaFisRet(1,'IT_DIFAL')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetICMOri(_cRef,_nAliqICM)
    Local _nRet	:= 0

    If _cRef == 'ALIQ'
        _nRet 		:= MaFisRet(1,'IT_VALCMP') * 100 / MaFisRet(1,'IT_BASEICM')
    Else
        _nRet		:= MaFisRet(1,'IT_VALCMP')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------

Static Function GetFCP(_cRef)
    Local _nRet := 0

    If _cRef == 'ALIQ'
        _nRet		:= MaFisRet(1,'IT_VFCPDIF') * 100  / MaFisRet(1,'IT_BASEICM')
    Else
        _nRet		:= MaFisRet(1,'IT_VFCPDIF')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------
Static Function GetIPI(_cRef,_nICMS,_nICMOri,_nICMDes,_nAliqFCP,_cTES,_cProduto,_cTipoCli)
    Local _cIncide	:= ''
    Local _cOrigem	:= ''
    Local _nRet		:= 0

    If _cRef == 'ALIQ'
        _cIncide	:= Posicione('SF4',1,xFilial('SF4') + _cTES ,'F4_INCIDE')
        _cOrigem	:= Posicione('SB1',1,xFilial('SB1') + _cProduto ,'B1_ORIGEM')

        If MaFisRet(1,'IT_VALIPI') > 0
            If _cTipoCli == 'F' .And. _cIncide == 'F' .and. _cOrigem == "0"
                _nRet := (_nICMS + _nICMOri + _nICMDes + _nAliqFCP) * (MaFisRet(1,'IT_ALIQIPI')/100)  // IPI e REDUÇÃO DE IPI NACIONAL
            ElseIf _cTipoCli == 'F' .And. _cIncide == 'F' .and. _cOrigem <> "0"
                _nRet := (_nICMS + _nICMOri + _nICMDes + _nAliqFCP) * (MaFisRet(1,'IT_ALIQIPI')/100)  // IPI e REDUÇÃO DE IPI IMPORTADO VDA
            EndIf
        EndIf
    Else
        _nRet := MaFisRet(1,'IT_VALIPI')
    EndIf
Return _nRet

//+----------------------------------------------------------------------------------------------------



//+------------------------------------------------------------------------------------------------
// Atualiza campo C6_XPRCTAB/CK_XPRCTAB com preço de tabela
//+------------------------------------------------------------------------------------------------
Static Function SetPrcTab(_cFunc)

    Local _nPrcTab	:= 0
    Local _cProduto	:= ''
    Local _dDataVig	:= CTOD("  /  /  ")
    Local _cCodUsr  := SuperGetMV( "AM_USRTABP", .F. , "000131|000151" )

    Do Case
    Case _cFunc == 'PV'  
    
    	_dDataVig	:= Posicione('DA1',1,xFilial('DA1') + M->C5_TABELA + GdFieldGet('C6_PRODUTO',n),'DA1_DATVIG')
    
    	If _dDataVig >= dDataBase .Or. RetCodUsr() $ _cCodUsr 
    		_nPrcTab	:= Posicione('DA1',1,xFilial('DA1') + M->C5_TABELA + GdFieldGet('C6_PRODUTO',n),'DA1_PRCVEN')
        Else
        	MsgAlert("Produto fora da vigência ! Entre em contato com o departamento comercial. Valor unitário não atualizado !","Atenção!")
    	Endif

        GdFieldPut('C6_XVLUTAB'	,_nPrcTab	,n)

    Case _cFunc == 'OV'
        _cProduto	:= TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
        _nPrcTab	:= Posicione('DA1',1,xFilial('DA1') + M->CJ_TABELA + _cProduto ,'DA1_PRCVEN')

        TMP1->(FieldPut(FieldPos('CK_XVLUTAB')	,_nPrcTab))
    EndCase
Return

//+------------------------------------------------------------------------------------------------
//	Responsável pelo peenchimento do tipo de operação
//+------------------------------------------------------------------------------------------------
Static Function SetOper(_cFunc)
    Local _cProduto		:= ''
    Local _cTipo		:= ''
    Local _cOper		:= ''
    Local _cTipoCli		:= ''

    Do Case
    Case _cFunc == 'PV'
        _cProduto		:= GdFieldGet('C6_PRODUTO',n)
        _cTipo			:= Posicione('SB1',1,xFilial('SB1') + _cProduto,'B1_TIPO')
        _cOper			:= U_M05A02(M->C5_TIPOCLI,_cTipo)

        GdFieldPut('C6_OPER',_cOper,n)
        GdFieldPut('C6_XOPER',_cOper,n)

    Case _cFunc == 'OV'
        _cProduto		:= TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
        _cTipo			:= Posicione('SB1',1,xFilial('SB1') + _cProduto,'B1_TIPO')
        _cTipoCli 		:= Posicione("SA1",1,xFilial("SA1") + M->CJ_CLIENT + M->CJ_LOJA,"A1_TIPO") //Fisico,Juridico,Xportacao
        _cOper			:= U_M05A02(_cTipoCli,_cTipo)

        TMP1->(FieldPut(FieldPos('CK_OPER'),_cOper))
        TMP1->(FieldPut(FieldPos('CK_XOPER'),_cOper))
    EndCase

Return

//+------------------------------------------------------------------------------------------------
//	Atualiza TES com TES Inteligente
//+------------------------------------------------------------------------------------------------
Static Function SetTES(_cFunc)
    Local _cProduto			:= ''
    Local _cOper			:= ''
    Local _cTes				:= ''

    Do Case
    Case _cFunc == 'PV'
        _cProduto			:= GdFieldGet('C6_PRODUTO',n)
        _cOper				:= GdFieldGet('C6_OPER',n)
        _cTes 				:= MaTesInt(2,_cOper,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),_cProduto,"C6_TES")

        GdFieldPut('C6_TES',_cTes,n)

    Case _cFunc == 'OV'
        _cProduto			:= TMP1->(FieldGet(FieldPos('CK_PRODUTO')))
        _cOper				:= TMP1->(FieldGet(FieldPos('CK_OPER')))
        _cTes 				:= MaTesInt(2,_cOper,M->CJ_CLIENT,M->CJ_LOJA,'C',_cProduto,"CK_TES")

        TMP1->(FieldPut(FieldPos('CK_TES'),_cTes))
    EndCase
Return



//------------------------------------------------------------------------------
//  Rotina de calcualo de preço operacoes 03 04 e 36
//------------------------------------------------------------------------------
User Function M05A01_A(_cFunc)
    Local _nPrecoVend   := 0

    CalcPrcA(_cFunc,@_nPrecoVend)     // Busca valor do pedido original
    SetTES(_cFunc)                      // Atualiza TES
    SetPrcVen(_cFunc,_nPrecoVend,.T.)   // Atualiza valores do pedido
Return

//+--------------------------------------------------------------------------------------------------------------------
Static Function CalcPrcA(_cFunc,_nPrecoVend)
    Do Case
    Case _cFunc == 'PV'
        _nPrecoVend         := GdFieldGet('C6_XVLTBRU',n) / GdFieldGet('C6_QTDVEN',n)


    Case _cFunc == 'OV'
        _nPrecoVend           := TMP1->(FieldGet(FieldPos('CK_XVLTBRU'))) / TMP1->(FieldGet(FieldPos('CK_QTDVEN')))

    EndCase
Return

//------------------------------------------------------------------------------
//  Rotina de calcualo de preço operacoes 27 E 44
//------------------------------------------------------------------------------
User Function M05A01_B(_cFunc)
    Local _nPrecoVend   := 0

    CalcPrcB(_cFunc,@_nPrecoVend)     // Busca valor do pedido original
    SetTES(_cFunc)                      // Atualiza TES
    SetPrcVen(_cFunc,_nPrecoVend,.T.)   // Atualiza valores do pedido
Return

//+--------------------------------------------------------------------------------------------------------------------
/*Static Function CalcPrcB(_cFunc,_nPrecoVend)
    Do Case
    Case _cFunc == 'PV'
        _nPrecoVend         := GdFieldGet('C6_XVLTBRU',n) - GdFieldGet('C6_XVLTIPI',n) / GdFieldGet('C6_QTDVEN',n)


    Case _cFunc == 'OV'
        _nPrecoVend           := TMP1->(FieldGet(FieldPos('CK_XVLTBRU'))) - TMP1->(FieldGet(FieldPos('CK_XVLTIPI'))) / TMP1->(FieldGet(FieldPos('CK_QTDVEN')))

    EndCase
Return
*/

Static Function CalcPrcB(_cFunc,_nPrecoVend)
    Do Case
    Case _cFunc == 'PV'
    	If !GdFieldGet('C6_OPER',n) $ '27|44'
    		_nPrecoVend         := GdFieldGet('C6_PRCVEN',n) + GdFieldGet('C6_XVLUSOL',n)
    	Else
    		_nPrecoVend         := GdFieldGet('C6_PRCVEN',n)
    	Endif


    Case _cFunc == 'OV'
        _nPrecoVend           := TMP1->(FieldGet(FieldPos('CK_PRCVEN'))) + TMP1->(FieldGet(FieldPos('CK_XVLUSOL')))

    EndCase
Return
