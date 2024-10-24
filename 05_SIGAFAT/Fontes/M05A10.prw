#Include 'Protheus.ch'

Static _lErro   := .F.

//+---------------------------------------------------------------------------------------------------------
//| Rotina chamada do PE M460FIM para descontar titulos de prefixo PVA
//| do valor total de titulos a gerar
//+---------------------------------------------------------------------------------------------------------
User Function M05A10(_nRecSC5,_nRecSF2)
    Local _nRA            := 0
    Private _aArea        := GetArea()
    Private _aAreaSE1     := SE1->(GetArea())
    Private _aAreaSF2     := SF2->(GetArea())
    Private _aAreaSD2     := SD2->(GetArea())
    Private _aAreaSC5     := SC5->(GetArea())
    Private _aAreaSC6     := SC6->(GetArea())
    Private _cPedido      := SC5->C5_NUM
    Private _cSF2Num      := SF2->F2_DUPL
    Private _aRA          := {}
    Private _cRAPre       := 'PVA'
    Private _nRATotal     := 0
    Private _nNFTotal     := 0
    Private _cNFNum       := ''
    Private _cNFPre       := SF2->F2_SERIE
    Private _cNFPar       := 'A'
    Private _cNFTip       := 'NF '
    Private _cNFNat       := ''
    Private _cNFCli       := ''
    Private _cNFLoj       := ''
    Private _dNFVenc      := CToD('  /  /  ')
    Private _dNFVenR      := CToD('  /  /  ')
    Private _nNFValor     := 0
    Private _cNFTitPed    := ''
    Private _cNFPedido    := ''
    Private _cNFVend      := ''
    Private _nNFComis1	:= 0
    Private _nSaldo       := 0
    Private _dNFEmis      := CToD('  /  /  ')
    Private _nRecnoSC5   := _nRecSC5
    Private _nRecnoSF2   := _nRecSF2

    //+----------------------------------------------------
    // Valida CFOP antes de gerar os titulos
    //+----------------------------------------------------
    If MA10Valid(_cPedido,_cRAPre,@_aRA,@_nRATotal)

        BeginTran()     // Controle de transa��o

            //+----------------------------------------------------
            // Retorna total de titulos gerados no faturamento
            //  atual do pedido NF e os deleta
            //+----------------------------------------------------
            MA10DelTit(_cSF2Num,@_nNFTotal,@_cNFNum,_cNFPre,_cNFTip,@_cNFNat,@_cNFCli,@_cNFLoj,@_dNFVenc,@_dNFVenR,@_nNFValor,@_cNFTitPed,@_cNFPedido,@_cNFVend,@_nNFComis1)

            //+----------------------------------------------------
            // Percorre RA e cria titulo NF correspondente caso
            //  ainda n�o possua e inclui titulo correspondente ao
            //  PVA
            //+----------------------------------------------------
            If !_lErro
                For _nRA := 1 To Len(_aRA)

                    If _nNFTotal > 0
                        MA10PutRA(_aRA[_nRA],@_nNFTotal,@_cNFPar,_cNFNum,_cNFPre,_cNFTip,_cNFNat,_cNFCli,_cNFLoj,_cNFTitPed,_cNFPedido,_cNFVend,_nNFComis1)
                    EndIf

                    If _lErro;Exit;EndIf
                Next
            EndIf

            //+------------------------------------------------------------------------
            // Gera Titulo da diferen�a entre o valor da NF e dos adiantamentos
            // utilizando a condi��o de pagamento do PV
            //+------------------------------------------------------------------------
            If !_lErro
                MA10PutNF()
            EndIf

            //+----------------------------------------------------
            // Retorna procedimentos caso ocorra erro
            //+----------------------------------------------------
            If _lErro
                DisarmTransaction()
            Else
                EndTran()
            EndIf

        MsUnLockAll()       // Fim do controle de transa��o
    EndIf

    RestArea(_aAreaSC6)
    RestArea(_aAreaSC5)
    RestArea(_aAreaSD2)
    RestArea(_aAreaSF2)
    RestArea(_aAreaSE1)
    RestArea(_aArea)
Return

//+-----------------------------------------------------------------------------------------------
// Valida se deve executar rotina de acerto de duplicadas
//+-----------------------------------------------------------------------------------------------
Static Function MA10Valid(_cPedido,_cRAPre,_aRA,_nRATotal)
    Local _lRet := .T.

    _lRet   := MA10VldCF(_cPedido)

    If _lRet
        _lRet   := MA10VldPag(_cPedido)
    EndIf

    //+----------------------------------------------------
    // Retorna total de titulos gerados antes do
    //  faturamento do pedido PVA
    //+----------------------------------------------------
    If _lRet
        MA10SelRA(_cPedido,_cRAPre,@_aRA,@_nRATotal)

        _lRet := Len(_aRA) > 0
    EndIf
Return _lRet

//+-----------------------------------------------------------------------------------------------
// Somente considera os titulos gerados antes do faturamento do pedido
// caso nenhum dos itens possua CFOP igual ao do parametro AM_05A1001
//+-----------------------------------------------------------------------------------------------
Static Function MA10VldCF(_cPedido)
    Local _lRet := .T.
    Local _cAlias   := GetNextAlias()
    Local _cCFOP    := AlLTrim(GetMv('AM_05A1001',.F.,'5922;6922'))

    If !Empty(_cCFOP)

        BeginSql Alias _cAlias
            SELECT COUNT(*) AS EXIST
            FROM %Table:SC6% SC6
            WHERE   C6_FILIAL  = %xFilial:SC6%
                AND SC6.%NotDel%
                AND C6_NUM  = %Exp:_cPedido%
                AND %Exp:_cCFOP% LIKE C6_CF
        EndSql

        (_cAlias)->(DbGoTop())

        _lRet := !( (_cAlias)->(!EOF()) .And. (_cAlias)->EXIST > 0)

        (_cAlias)->(DbCloseArea())
    EndIf
Return _lRet

//+-----------------------------------------------------------------------------------------------
// Somente considera condi��o de pagamento diferente de 9
//+-----------------------------------------------------------------------------------------------
Static Function MA10VldPag(_cPedido)
    Local _lRet := .T.

    If SC5->(C5_FILIAL + C5_NUM) <> xFilial('SC5') + _cPedido
        SC5->(DbGoTop())
        SC5->(DbSetOrder(1))

        _lRet := SC5->(DbSeek( xFilial('SC5') + _cPedido))
    EndIf

    If _lRet
        SE4->(DbGoTop())
        SE4->(DbSetOrder(1))

        If SE4->(DbSeek(xFilial('SE4') + SC5->C5_CONDPAG))
            _lRet := SE4->E4_TIPO <> '9'
        EndIf
    EndIf

Return _lRet

//+-----------------------------------------------------------------------------------------------
// Retorna total de titulos gerados antes do faturamento do pedido
//+-----------------------------------------------------------------------------------------------
Static Function MA10SelRA(_cPedido,_cRAPre,_aRA,_nRATotal)
    Local _cAlias   := GetNextAlias()

    BeginSql Alias _cAlias
        SELECT E1_VALOR
                ,SE1.R_E_C_N_O_ AS SE1_RECNO
        FROM %Table:SE1% SE1
        WHERE   E1_FILIAL  = %xFilial:SE1%
            AND SE1.%NotDel%
            AND E1_PEDIDO  = %Exp:_cPedido%
            AND E1_PREFIXO = %Exp:_cRAPre%
        ORDER BY E1_EMISSAO
    EndSql

    (_cAlias)->(DbGoTop())

    While (_cAlias)->(!EOF())
        _nRATotal   += (_cAlias)->E1_VALOR

        AAdd(_aRA,(_cAlias)->SE1_RECNO)

        (_cAlias)->(DbSkip())
    EndDo

    (_cAlias)->(DbCloseArea())
Return

//+-----------------------------------------------------------------------------------------------
// Retorna total de titulos gerados antes do faturamento do pedido
//+-----------------------------------------------------------------------------------------------
Static Function MA10SelTot(_cRaOri)
    Local _cAlias       := GetNextAlias()
    Local _nRet     := 0

    BeginSql Alias _cAlias
        SELECT SUM(E1_VALOR) AS E1_VALOR
        FROM %Table:SE1% SE1
        WHERE   E1_FILIAL  = %xFilial:SE1%
            AND SE1.%NotDel%
            AND E1_XRAORI  = %Exp:_cRaOri%
    EndSql

    (_cAlias)->(DbGoTop())

    If (_cAlias)->(!EOF())
        _nRet   := (_cAlias)->E1_VALOR
    EndIf

    (_cAlias)->(DbCloseArea())
Return _nRet

//+-----------------------------------------------------------------------------------------------
// Retorna total de titulos gerados no faturamento do pedido
//+-----------------------------------------------------------------------------------------------
Static Function MA10DelTit(_cSF2Num,_nNFTotal,_cNFNum,_cNFPre,_cNFTip,_cNFNat,_cNFCli,_cNFLoj,_dNFVenc,_dNFVenR,_nNFValor,_cNFTitPed,_cNFPedido,_cNFVend,_nNFComis1)
    Local _cAlias       := GetNextAlias()
    Local _nX           := 0
    Local _nOpc     	:= 5 // Exclus�o
    Local _aNf          := {}

    // Chave unica: E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

    BeginSql Alias _cAlias
        SELECT E1_VALOR
                ,SE1.R_E_C_N_O_ AS SE1_RECNO
        FROM %Table:SE1% SE1
        WHERE   E1_FILIAL  = %xFilial:SE1%
            AND SE1.%NotDel%
            AND E1_NUM     = %Exp:_cSF2Num%
            AND E1_PREFIXO = %Exp:_cNFPre%
            AND E1_TIPO    = %Exp:_cNFTip%
    EndSql

    (_cAlias)->(DbGoTop())

    While (_cAlias)->(!EOF())
        _nNFTotal   += (_cAlias)->E1_VALOR

        AAdd(_aNF,(_cAlias)->SE1_RECNO)

        (_cAlias)->(DbSkip())
    EndDo

    (_cAlias)->(DbCloseArea())

    //+----------------------------------------------------
    // Deleta Titulos gerados
    //+----------------------------------------------------
    For _nX := 1 To Len(_aNF)
        SE1->(DbGoTo(_aNF[_nX]))

        //+----------------------------------------------------
        // Guarda informa��es para gera��o de NF por RA
        //+----------------------------------------------------
        _cNFNum     := SE1->E1_NUM
        _cNFPre     := SE1->E1_PREFIXO
        _cNFTip     := SE1->E1_TIPO
        _cNFNat     := SE1->E1_NATUREZ
        _cNFCli     := SE1->E1_CLIENTE
        _cNFLoj     := SE1->E1_LOJA
        _dNFVenc    := SE1->E1_VENCTO  			//IIF(SE1->E1_VENCTO < dDataBase, dDatabase,SE1->E1_VENCTO) 
        _dNFVenR    := SE1->E1_VENCREA			//IIF(SE1->E1_VENCREA < dDataBase, dDataBase, SE1->E1_VENCREA)
        _nNFValor   := SE1->E1_VALOR
        _cNFPedido  := SE1->E1_PEDIDO
        _cNFVend    := SE1->E1_VEND1
        _nNFComis1	:= SE1->E1_COMIS1

        If SE1->(!EOF())
            _lErro := !M05ExecAut(  _nOpc   ,SE1->E1_PREFIXO    ,SE1->E1_NUM    ,SE1->E1_PARCELA    ,SE1->E1_TIPO)
        EndIf
        If _lErro;Exit;EndIf
    Next

Return

//+-----------------------------------------------------------------------------------------------
// Cria titulo correspondente ao RA recebido caso ainda n�o exista
//+-----------------------------------------------------------------------------------------------
Static Function MA10PutRA(_nRecnoRA,_nNFTotal,_cNFPar,_cNFNum,_cNFPre,_cNFTip,_cNFNat,_cNFCli,_cNFLoj,_cNFTitPed,_cNFPedido,_cNFVend,_nNFComis1)
    Local _nSaldoRA 	:= 0
    
    Local _nOpc     	:= 3 // inclus�o
    Local _nValor       := 0
    Local _cRAOri       := ''
    Local _dEmissao		:= CTOD("  /  /  ")
    Local _dVencto		:= CTOD("  /  /  ")
    Local _dVencRea		:= CTOD("  /  /  ")
    Private _nValorRA 	:= 0

    SE1->(DbGoTo(_nRecnoRA))
    
    _dEmissao	:= SE1->E1_EMISSAO
    _dVencto	:= SE1->E1_VENCTO
    _dVencRea	:= SE1->E1_VENCREA

    If SE1->(!EOF())
        _cRAOri := SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)
        _nSaldoRA   := SE1->E1_VALOR - MA10SelTot(_cRAOri)

        //+----------------------------------------------------
        // Se existir diferen�a entre PV e NF, gera titulo
        //  com valor correspondente
        //+----------------------------------------------------
        If  _nSaldoRA > 0

            If _nNFTotal >= _nSaldoRA
                 _nNFTotal -= _nSaldoRA
                 _nValor    := _nSaldoRA
            Else
                _nValor     := _nNFTotal
                _nNFTotal   := 0
            EndIf
            
	        //+----------------------------------------------------
    	    // Se a data de vencimento for menor que a emiss�o, 
        	// altero a data para a database do sistema para n�o 
        	// ocasionar erro na emiss�o da NFE.
        	//+----------------------------------------------------
            _dEmissao	:= IIF( SE1->E1_EMISSAO < dDataBase, dDataBase, _dEmissao)
            _dVencto	:= IIF( SE1->E1_VENCTO < dDataBase, dDataBase, _dVencto)
            _dVencRea	:= IIF( SE1->E1_VENCREA < dDataBase, dDataBase, _dVencRea)

            _lErro := !M05ExecAut(   _nOpc;
                                        ,_cNFPre;
                                        ,_cNFNum;
                                        ,_cNFPar;
                                        ,_cNFTip;
                                        ,_cNFNat;
                                        ,_cNFCli;
                                        ,_cNFLoj;
                                        ,_dEmissao;
                                        ,_dVencto;
                                        ,_dVencRea;
                                        ,_nValor;
                                        ,_cNFTitPed;
                                        ,_cNFPedido;
                                        ,_cNFVend;
                                        ,_nNFComis1;
                                        ,_cRAOri)

            _cNFPar := Soma1(_cNFPar)
        EndIf

    EndIf

Return

//+-----------------------------------------------------------------------------------------------
//  Cria titulo no contas a receber
//+-----------------------------------------------------------------------------------------------
Static Function MA10PutNF()
    Local _aCondPag     := {}
    Local _nX           := 0
    Local _nOpc     	:= 3
    Local _dData        := CToD('  /  /  ')

    SC5->(DbGoTo(_nRecnoSC5))
    SF2->(DbGoTo(_nRecnoSF2))

    If SC5->(!EOF()) .And. SF2->(!EOF())
        _aCondPag   := Condicao(_nNFTotal,SC5->C5_CONDPAG)

        For _nX := 1 To Len(_aCondPag)

            _dData		:= Lastday(_aCondPag[_nX][01],3)
                        
            _lErro := !M05ExecAut(   _nOpc;
                                        ,_cNFPre;
                                        ,_cNFNum;
                                        ,_cNFPar;
                                        ,_cNFTip;
                                        ,_cNFNat;
                                        ,_cNFCli;
                                        ,_cNFLoj;
                                        ,dDataBase;
                                        ,_aCondPag[_nX][01];
                                        ,_dData;
                                        ,_aCondPag[_nX][02];
                                        ,_cNFTitPed;
                                        ,_cNFPedido;
                                        ,_cNFVend;
                                        ,'')

            _cNFPar := Soma1(_cNFPar)
        Next
    EndIf
Return

//+-----------------------------------------------------------------------------------------------
// Execu��o autom�tica FINA040 - inclus�o/exclus�o de titulos
//+-----------------------------------------------------------------------------------------------
Static Function M05ExecAut( _nOpc           ,_cPrefix       ,_cNum      ,_cParc     ,_cTipo;
                                ,_cNaturez      ,_cCliente      ,_cLoja ,_dEmiss        ,_dVencto;
                                ,_dVencRea      ,_nValor        ,_cTitPed   ,_cPedido       ,_cVend;
                                ,_nComis1,		_cRaOri)

    Local    _aTitulo       := {}
    Local	 _cXBNDES		:= ""
    
    If SE4->(FieldPos('E4_XBNDES')) > 0
    	_cXBNDES		:= Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_XBNDES")
    Endif

    lMsErroAuto         := .F.

    AAdd(_aTitulo, { 'E1_PREFIXO'   ,_cPrefix       ,Nil})
    AAdd(_aTitulo, { 'E1_NUM'       ,_cNum          ,Nil})
    AAdd(_aTitulo, { 'E1_PARCELA'   ,_cParc     	,Nil})
    AAdd(_aTitulo, { 'E1_TIPO'      ,_cTipo     	,Nil})

    If _nOpc == 3
        AAdd(_aTitulo, { 'E1_NATUREZ'   ,_cNaturez      ,Nil})
        AAdd(_aTitulo, { 'E1_CLIENTE'   ,_cCliente      ,Nil})
        AAdd(_aTitulo, { 'E1_LOJA'      ,_cLoja     	,Nil})
        AAdd(_aTitulo, { 'E1_EMISSAO'   ,_dEmiss        ,Nil})
        AAdd(_aTitulo, { 'E1_VENCTO'    ,_dVencto       ,Nil})
        AAdd(_aTitulo, { 'E1_VENCREA'   ,_dVencRea      ,Nil})
        AAdd(_aTitulo, { 'E1_VALOR'     ,_nValor        ,Nil})
        AAdd(_aTitulo, { 'E1_VEND1'     ,_cVend     	,Nil})
        AAdd(_aTitulo, { 'E1_COMIS1'	,_nComis1		,Nil})
        AAdd(_aTitulo, { 'E1_PEDIDO'    ,_cPedido       ,Nil})
        AAdd(_aTitulo, { 'E1_ORIGEM'    ,'MATA460 '     ,Nil})
        AAdd(_aTitulo, { 'E1_VENCORI'   ,_dVencto		,Nil})

        If SE1->(FieldPos('E1_XRAORI')) > 0
            AAdd(_aTitulo, { 'E1_XRAORI',_cRaOri        ,Nil})
        EndIf

        If SE1->(FieldPos('E1_XDTFAT')) > 0
            AAdd(_aTitulo, { 'E1_XDTFAT',dDataBase      ,Nil})
        EndIf
        
        If SE1->(FieldPos('E1_XBNDES')) > 0
        	AAdd(_aTitulo, { 'E1_XBNDES', _cXBNDES		,Nil})
        Endif

    EndIf

    MSExecAuto( {|x,y| FINA040(x,y) } , _aTitulo , _nOpc )

    If lMsErroAuto
       MostraErro()
    EndIf
Return !lMsErroAuto
