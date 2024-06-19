#Include 'Totvs.ch'

Static _cOP         := ''
Static _cProd       := ''
Static _cEtapaDes   := ''
Static _cUsrEtapa   := ''
Static _nClrStd     := 0
Static _nInat       := 0
Static _cTime       := 0
Static _aCodZA3     := {}

//+---------------------------------------------------------------------------------
// Rotina responsavel pelo apontamento de etapa de produção
//+---------------------------------------------------------------------------------
User Function M10A01()
    Private _oDlg         := Nil
    Private _oLayer       := FWLayer():New()
    Private _oPnlAll      := Nil
    Private _oCodBar      := Nil
    Private _oTFont       := TFont():New('Verdana',0/*nWidth*/,-30/*nHeight*/,,.F./*lBold*/,,,,,.F./*lUnderline*/,.F./*lItalic*/)
    Private _oTSayOP      := Nil
    Private _oTSayOPInf   := Nil
    Private _oTSayES      := Nil
    Private _oTSayESInf   := Nil
    Private _oTSayUsr     := Nil
    Private _oTSayUsrInf  := Nil
    Private _oTSayCB      := Nil
    Private _oTGetCB      := Nil
    Private _oTSayCom     := Nil
    Private _oTimer       := Nil
    Private _bTimer       := {|| M10ASetCl( _oPnlAll,_oTimer, .F.)  }
    Private _bConf        := {||( M10AProc(_oPnlAll,_oTimer),M10ASetVa())}
    Private _nRecnoSC6    := 0
    Private _nRecnoSC2    := 0
    Private _nRecnoZA3    := 0
    Private _cC6xEtapa    := ' '
   
    //+--------------------------------------------------------
    // Inicializa variáveis static
    //+--------------------------------------------------------
    M10ASetVa(.F.)

    M10AGetPa()

    //+--------------------------------------------------------
    // Busca etapa e local de transferência
    //  Caso grupo do usuário logado não possua etapa,
    //  não permite apontamento
    //+--------------------------------------------------------
    M10AGetEt()

    If Empty(_cEtapaDes)
        M10AMsg("Usuário sem permissão para acessar essa rotina.",'Atenção',.F.)
    Else

        DEFINE MSDIALOG _oDlg FROM 0,0 TO 350,800 TITLE "Apontamento de Etapas de Produção" PIXEL

            _oPnlAll            := TPanel():New(0,0,"",_oDlg,,,,,,0,0)
            _oPnlAll:Align      := 5

            _nClrStd            := _oPnlAll:nClrPane
            _oTimer             := TTimer():New(_nInat, _bTimer, _oDlg )

            _oTSayUsr           := TSay():New(020,020,{||"Usuário:"}    ,_oPnlAll,,_oTFont,.F.,.F.,.F.,.T.,0,,200,020,.F.,.T.,.F.,.F.,.F.,.F. )
            _oTSayUsrInf        := TSay():New(020,140,{||_cUsrEtapa }   ,_oPnlAll,,_oTFont,.F.,.F.,.F.,.T.,0,,400,020,.F.,.T.,.F.,.F.,.F.,.F. )

            _oTSayCom           := TSay():New(050,020,{||"Etapa:"}      ,_oPnlAll,,_oTFont,.F.,.F.,.F.,.T.,0,,200,020,.F.,.T.,.F.,.F.,.F.,.F. )
            _oTSayComInf        := TSay():New(050,140,{||_cEtapaDes }   ,_oPnlAll,,_oTFont,.F.,.F.,.F.,.T.,0,,400,020,.F.,.T.,.F.,.F.,.F.,.F. )

            _oTSayCB            := TSay():New(105,020,{||"Cód. Barras:"},_oPnlAll,,_oTFont,.F.,.F.,.F.,.T.,0,,200,020,.F.,.T.,.F.,.F.,.F.,.F. )
            _oTGetCB            := TGet():New(100,140,{ | u | If( PCount() == 0, _cOP, _cOP := u ) },_oPnlAll,130,020,"@!",,0,,_oTFont,.F.,,.T.,,.F.,,.F.,.F.,{|| },.F.,.F.,,'_cOP',,,, )

            _oTGetCB:bLostFocus := {|| IIF(!Empty(_cOP), {Eval(_bConf),_oTGetCB:SetFocus()}, )}

            @100,600 BUTTON ""  SIZE 070, 025 PIXEL OF _oDlg ACTION ()
            @140,150 BUTTON "Sair"  SIZE 070, 025 PIXEL OF _oDlg ACTION ( M10ASair(_oDlg) )

        ACTIVATE MSDIALOG _oDlg CENTERED ON INIT _oTimer:Activate()
    EndIf

    //+--------------------------------------------------------
    // Limpa variáveis static
    //+--------------------------------------------------------
    M10ASetVa(.T.)
Return

//+---------------------------------------------------------------------------------
Static Function M10ASair(_oDlg)
    If MsgYesNo('Deseja sair?')
        _oDlg:End()
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M10AProc( _oPnlAll,_oTimer)
    Local _lValid       := .T.
    Private _lOk          := .T.
    Private _lErro        := .F.
    Private _lSaldoIni    := .F.
    Private _lRet         := .F.

    M10ASetCl( _oPnlAll,_oTimer, .T. )
    _cTime              := Time()   // guarda tempo inicial para controlar inatividade

    //+--------------------------------------------------------
    // Retorna dados da OP e do PV
    //+--------------------------------------------------------
    _lValid     := M10AGetOP()

    //+--------------------------------------------------------
    //  Valida Etapa
    //+--------------------------------------------------------
    If _lValid
        _lValid     := M10AVlEtp()
    EndIf

    //+--------------------------------------------------------
    // Ambiente posicionado na OP informada (SC2)
    //+--------------------------------------------------------
    If _lValid
        BeginTran()

            If !Empty(ZA3->ZA3_LOCAL)
                //+--------------------------------------------------------
                // Cria saldo inicial se necessário
                // Cria movimento interno para alimentar estoque
                //+--------------------------------------------------------
                SC2->(DbGoTo(_nRecnoSC2))

                If Empty(SC2->C2_XLOCAL)
                    _lErro  := !M10ASetSa()
                
                    If !_lErro
                        _lErro  := !M10APrD3M() // alimenta estoque por movimento interno
                    EndIf

                //+--------------------------------------------------------
                // Cria saldo inicial se necessário
                // Cria transferencia
                //+--------------------------------------------------------
                Else
                    _lErro  := !M10ASetSa()

//                  If !_lErro
//                      _lErro := !M10APrD3T()      // cria Transferência
//                  EndIf
                EndIf
            EndIf

            //+--------------------------------------------------------
            //  Atualiza Status do PV
            //+--------------------------------------------------------
            If ! _lErro
                M10ASetSt()
            EndIf

        //+--------------------------------------------------------
        //  Somente efetiva movimentação se não houver erro
        //+--------------------------------------------------------
        If _lErro
            DisarmTransaction()
        Else
            EndTran()
        EndIf

        MsUnLockAll()

        If !_lErro
            M10AMsg(I18N('Apontamento de #1 realizado com sucesso!',{AllTrim(ZA3->ZA3_DESCRI)}),'Atenção',.T.)
        EndIf
    EndIf

    // Verifica se altera cor por inatividade
    _cTime := ElapTime(_cTime,Time())

     If _nInat < ((Val(SubStr(_cTime,1,2)) * 60 * 60 ) + (Val(SubStr(_cTime,4,2)) * 60 ) + Val(SubStr(_cTime,7,2))) * 1000
        M10ASetCl( _oPnlAll,_oTimer, .F. )
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M10APrSB9()
    Local _aVet         := {}
    Local _cErro        := ''

    lMsErroAuto         := .F.

    AAdd(_aVet      ,{'B9_COD'      ,_cProd             ,Nil})
    AAdd(_aVet      ,{'B9_LOCAL'    ,ZA3->ZA3_LOCAL     ,Nil})
    AAdd(_aVet      ,{'B9_QINI' ,0                      ,Nil})

    _aVet := FWVetByDic(_aVet,'SB9')

    //MSExecAuto({|x,y| mata220(x,y)},_aVet,3)

    If lMsErroAuto
        _cErro  := M10AGetEr()

        M10AMsg('Erro ao incluir Saldo Inicial.' + CRLF + _cErro,"ERRO",.F.)
    EndIf
Return !lMsErroAuto

//+---------------------------------------------------------------------------------
Static Function M10APrD3M()
    Local _aVet         := {}
    Local _cErro        := ''
    Local _cUM          := Posicione('SB1',1,xFilial('SB1') + _cProd,'B1_UM')

    lMsErroAuto         := .F.

    // somente transfere se local origem diferente de local destino
    SC2->(DbGoTo(_nRecnoSC2))

    If SC2->C2_XLOCAL <> ZA3->ZA3_LOCAL

        AAdd(_aVet      ,{'D3_TM'           ,ZA3->ZA3_TMOV      ,Nil})
        AAdd(_aVet      ,{'D3_COD'          ,_cProd             ,Nil})
        AAdd(_aVet      ,{'D3_UM'           ,_cUM               ,Nil})
        AAdd(_aVet      ,{'D3_LOCAL'        ,ZA3->ZA3_LOCAL     ,Nil})
        AAdd(_aVet      ,{'D3_QUANT'        ,SC2->C2_QUANT      ,Nil})
        AAdd(_aVet      ,{'D3_EMISSAO'      ,dDataBase          ,Nil})

        _aVet := FWVetByDic(_aVet,'SD3')

        //MSExecAuto({|x,y| mata240(x,y)},_aVet,3)

        If lMsErroAuto
            _cErro  := M10AGetEr()
            M10AMsg('Erro ao incluir movimento interno:' + CRLF + _cErro,'Erro',.F.)
        EndIf
    EndIf
Return !lMsErroAuto

//+---------------------------------------------------------------------------------
Static Function M10APrD3T()
    Local _aVet         := {}
    Local _aAux         := {}
    Local _cErro        := ''
    Local _cDoc         := NextNumero('SD3',2,'D3_DOC',.T.)
    Local _cDesc        := Posicione('SB1',1,xFilial('SB1') + _cProd,'B1_DESC')
    Local _cUM          := Posicione('SB1',1,xFilial('SB1') + _cProd,'B1_UM')

    lMsErroAuto         := .F.

    // somente transfere se local origem diferente de local destino
    SC2->(DbGoTo(_nRecnoSC2))

    If SC2->C2_XLOCAL <> ZA3->ZA3_LOCAL
        AAdd(_aAux      ,_cDoc)
        AAdd(_aAux      ,dDataBase)
        AAdd(_aVet      ,AClone(_aAux))

        _aAux := {}

        AAdd(_aAux,{"D3_COD",	  _cProd,				 Nil})	//  Produto Origem
        AAdd(_aAux,{"D3_DESCRI",  _cDesc,				 Nil})  //  Descrição
        AAdd(_aAux,{"D3_UM",	  _cUM,					 Nil})  //  Unid. Medida
        AAdd(_aAux,{"D3_LOCAL",   SC2->C2_XLOCAL,		 Nil})	//  Armazem origem
        AAdd(_aAux,{"D3_LOCALIZ", CriaVar('D3_LOCALIZ'), Nil})  //  Endereço Origem
        AAdd(_aAux,{"D3_COD", 	  _cProd,				 Nil})  //  Produto Destino
        AAdd(_aAux,{"D3_DESCRI",  _cDesc, 				 Nil})  //  Descrição
        AAdd(_aAux,{"D3_UM",	  _cUM,					 Nil})  //  Unid. Medida
        AAdd(_aAux,{"D3_LOCAL",	  ZA3->ZA3_LOCAL,		 Nil})	//  Armazém destino
        AAdd(_aAux,{"D3_LOCALIZ", CriaVar('D3_LOCALIZ'), Nil})  //  Endereço Destino
        AAdd(_aAux,{"D3_NUMSERI", CriaVar('D3_NUMSERI'), Nil})  //  Num. Serie
        AAdd(_aAux,{"D3_LOTECTL", CriaVar('D3_LOTECTL'), Nil})  //  Lote Origem
        AAdd(_aAux,{"D3_NUMLOTE", CriaVar('D3_NUMLOTE'), Nil})  //  Sub-Lote Origem
        AAdd(_aAux,{"D3_DTVALID", CriaVar('D3_DTVALID'), Nil})  //  Validade
        AAdd(_aAux,{"D3_POTENCI", CriaVar('D3_POTENCI'), Nil})  //  Potencia
        AAdd(_aAux,{"D3_QUANT",	  SC2->C2_QUANT,		 Nil})  //  Quantidade
        AAdd(_aAux,{"D3_QTSEGUM", CriaVar('D3_QTSEGUM'), Nil})  //  Qtde 2ª UM
        AAdd(_aAux,{"D3_ESTORNO", CriaVar('D3_ESTORNO'), Nil})  //  Estornado
        AAdd(_aAux,{"D3_NUMSEQ",  CriaVar('D3_NUMSEQ'),	 Nil})  //  Seq.
        AAdd(_aAux,{"D3_LOTECTL", CriaVar('D3_LOTECTL'), Nil})  //  Lote Dest.
        AAdd(_aAux,{"D3_NUMLOTE", CriaVar('D3_NUMLOTE'), Nil})	//  Sub-Lote Destino
        AAdd(_aAux,{"D3_DTVALID", CriaVar('D3_DTVALID'), Nil}) 	//  Validade do Lote Destino
        AAdd(_aAux,{"D3_ITEMGRD", SC2->C2_ITEMGRD,		 Nil})	//  Item Grade
        AAdd(_aAux,{"D3_CODLAN",  CriaVar('D3_CODLAN'),	 Nil})	//  CAT83 Prod. Origem
        AAdd(_aAux,{"D3_CODLAN",  CriaVar('D3_CODLAN'),	 Nil})	//  CAT83 Prod. Destino         
        AAdd(_aAux,{"D3_IDDCF",	  CriaVar('D3_IDDCF'),	 Nil}) 	//  Id DCF
        AAdd(_aAux,{"D3_OBSERVA", CriaVar('D3_OBSERVA'), Nil})	//	Observação

        AAdd(_aVet      ,AClone(_aAux))

        //MSExecAuto({|x,y| mata261(x,y)},_aVet,3)

        If lMsErroAuto
            _cErro  := M10AGetEr()
            M10AMsg('Erro ao incluir transferência:' + CRLF + _cErro,'Erro',.F.)
        EndIf
    EndIf
Return !lMsErroAuto

//+-----------------------------------------------------------------------------------------------
Static Function M10ASetVa(_lEnd)
    Default _lEnd   := .F.

    _cOP        := Space( TamSx3('C2_NUM')[1] + TamSx3('C2_ITEM')[1] + TamSx3('C2_SEQUEN')[1] + TamSx3('C2_ITEMGRD')[1] )
    _cProd      := Space( TamSx3('B1_COD')[1])
    _nRecnoSC2  := 0
    _nRecnoSC6  := 0
    _cC6xEtapa  := ' '
    _nRecnoZA3  := 0
    
    If _lEnd
        _cEtapaDes  := ''
        _cUsrEtapa  := ''
        _cTime      := ''
        _nInat      := 0
        _nClrStd    := 0
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M10ASetSt()
    Local _lOk  := .T.

    //+--------------------------------------------------------
    //  Posiciona na OP
    //  Grava data/etapa na tabela de OP
    //+--------------------------------------------------------
    SC2->(DbGoTop())
    SC2->(DbGoTo(_nRecnoSC2))

    If SC2->(!EOF())

        ZA3->(DbGoto(_nRecnoZA3))

        //+--------------------------------------------------------
        // Atualiza campos de data na OP
        //+--------------------------------------------------------
        M10ASetC2()

        //+--------------------------------------------------------
        // Verifica hierarquia da etapa
        //+--------------------------------------------------------
         _lOk := U_M05A22(ZA3->ZA3_CODIGO,SC2->C2_PEDIDO,SC2->C2_ITEMPV,'')

         If _lOk
            //+--------------------------------------------------------
            //  Atualiza status do item do PV
            //+--------------------------------------------------------
            M10ASetC6()

            //+--------------------------------------------------------
            //  Atualiza status do PV
            //+--------------------------------------------------------
            M10ASetC5()
        EndIf
    EndIf
Return

//+---------------------------------------------------------------------------------
Static Function M10AGetSI()
    Local _lRet     := .T.

    SB2->(DbGoTop())
    SB2->(DbSetOrder(1))        // B2_FILIAL+B2_COD+B2_LOCAL

    _lRet   := SB2->(DbSeek( xFilial('SB2') + _cProd + ZA3->ZA3_LOCAL))
Return _lRet

//+---------------------------------------------------------------------------------
Static Function M10AGetEr()
    Local _cRet         := ''
    Local _cFileError   := NomeAutoLog()
    Local _cMemo        := MemoRead( _cFileError )
    Local _nY           := 0
    Local _cAux         := ''
    Local _lTitulo      := .T.

    For _nY := 1 To MLCount(_cMemo)
        _cAux := AllTrim(MemoLine(_cMemo,,_nY))

        If Len(_cAux) > 0 .And. _lTitulo
            _cRet += _cAux + " "
        Else
            If At("< --", _cAux) > 0
                _cRet += " | " + _cAux
            EndIf
            _lTitulo    := .F.
        EndIf
    Next _nY

    Ferase(_cFileError)
Return _cRet

//+---------------------------------------------------------------------------------
Static Function M10AGetEt()
    
    Local _cCodGru      := ''
    Local _aCodGru      := UsrRetGrp(UsrRetName(RetCodUsr()))
    Local _nGrupo       := 0
    Local _lExit        := .F.
    Private _cUsuario     := RetCodUsr()
    Private _nX           := 0
    Private _nY           := 0
    Private _aParam       := {}
    Private _aAux         := {}
    Private _aAux2        := {}
    

    _cUsrEtapa          := Upper(AllTrim(UsrRetName(RetCodUsr())))

    // Guarda os grupos parametrizados
    For _nGrupo := 1 To Len(_aCodGru)
        _cCodGru := AllTrim(_aCodGru[_nGrupo])

        If !Empty(_cCodGru)
            ZA3->(DbSetOrder(1))
            ZA3->(DbGotop())

            While ZA3->(!EOF())

                If _cCodGru == AllTrim(ZA3->ZA3_GRUPO)
                    If Empty(_cEtapaDes)
                        _cEtapaDes  := AllTrim(ZA3->ZA3_DESCRI)
                    Else
                        _cEtapaDes  += '  /  ' + AllTrim(ZA3->ZA3_DESCRI)
                    EndIf

                    AAdd(_aCodZA3, ZA3->ZA3_CODIGO)

                    _lExit := .T.
                EndIf

                ZA3->(DbSkip())
            EndDo

            If _lExit; Exit; EndIf
        EndIf
    Next
Return

//+---------------------------------------------------------------------------------
Static Function M10AGetOP()
    Local _lOk          := .T.

    SC2->(DbGoTop())
    SC2->(DbSetOrder(1)) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD

    _lOk := SC2->(DbSeek( xFilial('SC2') +  AllTrim(_cOP )))

    If _lOk
        _cProd          := SC2->C2_PRODUTO
        _nRecnoSC2      := SC2->(Recno())
        _nRecnoSC6      := Posicione('SC6',1,xFilial('SC6') + SC2->(C2_PEDIDO+C2_ITEMPV+C2_PRODUTO),'Recno()' )
    Else
        M10AMsg(I18N('Ordem de Produção #1 não encontrada.',{AllTrim(_cOP)}),'Atenção',.F.)
        M10ASetVa(.F.)
    EndIf
Return _lOk

//+---------------------------------------------------------------------------------
Static Function M10AGetPa()
    _nInat      := (60 / SuperGetMv('AM_10A01_A',.T.,1)) * 60000
Return

//+---------------------------------------------------------------------------------
Static Function M10ASetSa()
    Local _lSaldoIni    := .T.
    Local _lOk          := .T.

    //+--------------------------------------------------------
    //  Verifica se existe saldo inicial no armazém origem
    //  Caso nao exista saldo inicial, cria
    //+--------------------------------------------------------
    _lSaldoIni      := M10AGetSI()

    If !_lSaldoIni
        _lOk := M10APrSB9()
    EndIf
Return _lOk

//+---------------------------------------------------------------------------------
Static Function M10AVlEtp()
    
    Local _lOk          := .T.
    Local _nZA3         := 0
    Private _cAtuDes      := ''
    Private _cItemSt      := ''

    //+--------------------------------------------------------
    //  Verifica se etapa já foi apontada anteriormente
    //+--------------------------------------------------------
    If _lOk
        SC2->(DbGoTo(_nRecnoSC2))

        // Verifica se etapa já apontada anteriormente
        For _nZA3 := 1 To Len(_aCodZA3)
            ZA3->(DbSetOrder(1))
            ZA3->(DbGoTop())
            ZA3->(DbSeek(xFilial('ZA3') + _aCodZA3[_nZA3]))

            If Empty(SC2->&( ZA3->ZA3_LOGDT ))
                _nRecnoZA3 := ZA3->(Recno())
                Exit
            EndIf
        Next

        If _nRecnoZA3 == 0
            M10AMsg('Etapa já apontada para esta Ordem de Produção.','Atenção',.F.)
            _lOk := .F.
        EndIf
    EndIf
Return _lOk

//+-------------------------------------------------------------------------------------------
Static Function M10ASetC2()

    RecLock('SC2',.F.)
        If AllTrim(ZA3->ZA3_CODIGO) == '2'
            SC2->C2_XRESPON := Upper(UsrRetName(RetCodUsr()))
        EndIf

        // Data
        If SC2->(FieldPos(ZA3->ZA3_LOGDT)) > 0
            SC2->&(ZA3->ZA3_LOGDT)  := dDataBase
        EndIf

        // Hora
        If SC2->(FieldPos(ZA3->ZA3_LOGHR)) > 0
            SC2->&(ZA3->ZA3_LOGHR)  := Time()
        EndIf

        // Usuario
        If SC2->(FieldPos(ZA3->ZA3_LOGUS)) > 0
            SC2->&(ZA3->ZA3_LOGUS)  := _cUsrEtapa
        EndIf

        // Local
        If SC2->(FieldPos('C2_XLOCAL')) > 0
            SC2->C2_XLOCAL      := IIF(Empty(ZA3->ZA3_LOCAL),SC2->C2_XLOCAL,ZA3->ZA3_LOCAL)
        EndIf
    SC2->(MsUnLock())

    SC2->(DbGoTo(_nRecnoSC2))
Return

//+-------------------------------------------------------------------------------------------
Static Function M10ASetC6()
    Private _cPedido  := SC2->C2_PEDIDO
    Private _cItemPV  := SC2->C2_ITEMPV

    SC6->(DbGoTop())
    SC6->(DbGoTo(_nRecnoSC6))

    If SC6->(!EOF())
        If SC6->(FieldPos('C6_XETAPA')) > 0
            RecLock('SC6',.F.)
                SC6->C6_XETAPA  := ZA3->ZA3_CODIGO
            SC6->(MsUnlock())
        EndIf
    EndIf
Return

//+-------------------------------------------------------------------------------------------
Static Function M10ASetC5()
    Local _lCancel  := .T.
    Local _lComplet := .T.

    //+--------------------------------------------------------
    // Caso etapa seja ultima de produção, verifica se o pedido
    // não está cancelado e atualiza seu status
    //+--------------------------------------------------------
    If ZA3->ZA3_ULTIMA == 'S'

        SC6->(DbGoTo(_nRecnoSC6))

        SC5->(DbGoTop())
        SC5->(DbSetOrder(1))    // C5_FILIAL+C5_NUM

        If SC5->(DbSeek( xFilial('SC5') + SC6->C6_NUM))
            _lCancel := SC5->C5_STATUS == '2' // 1=Ativo;2=Cancelado;3=Parcial;4=Completo
        EndIf

        //+--------------------------------------------------------
        // Caso o pedido não esteja cancelado, verifica se todos os
        //  itens estão com status 9 (em expedição)
        //+--------------------------------------------------------
        If !_lCancel

            While _lComplet .And. SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM) == xFilial('SC6') + SC5->C5_NUM
                _lComplet   := SC6->C6_XETAPA == ZA3->ZA3_CODIGO

                SC6->(DbSkip())
            EndDo

            RecLock('SC5',.F.)
                SC5->C5_STATUS := IIF(_lComplet,'4','3')    // 1=Ativo;2=Cancelado;3=Parcial;4=Completo
            SC5->(MsUnLock())
        EndIf
    EndIf
Return

//+-------------------------------------------------------------------------------------------
Static Function M10AMsg(cMsg,cTitle,_lTime)
    Local oDlg      := Nil
    Local oTimer    := Nil
    Local _oTSay    := Nil
    Local _oTFont   := TFont():New('Verdana',0/*nWidth*/,-30/*nHeight*/,,.F./*lBold*/,,,,,.F./*lUnderline*/,.F./*lItalic*/)
    Local _oTFontP  := TFont():New('Verdana',0/*nWidth*/,-20/*nHeight*/,,.F./*lBold*/,,,,,.F./*lUnderline*/,.F./*lItalic*/)
    Local _oPnl     := Nil
    Local nInterval := 750

    DEFINE MSDIALOG oDlg  FROM 0,0 TO 300 + IIF(_lTime,0,50) ,500 TITLE 'Aviso' FONT _oTFont PIXEL

        _oPnl           := TPanel():New(0,0,"",oDlg,,,,,,0,0)
        _oPnl:Align     := 5
        _oTSay          := TSay():New(030,030,{||cMsg}                                  ,_oPnl,,IIF( Len(AllTrim(cMsg)) > 75 ,_oTFontP,_oTFont) ,.F.,.F.,.F.,.T.,50,,200,200,.F.,.T.,.F.,.F.,.F.,.F. )

    If _lTime
        DEFINE TIMER oTimer INTERVAL nInterval ACTION (oDlg:End()) OF oDlg

        ACTIVATE MSDIALOG oDlg CENTERED ON INIT oTimer:Activate()
    Else
        ACTIVATE MSDIALOG oDlg CENTERED
    EndIf
Return

//+-------------------------------------------------------------------------------------------
Static Function M10ASetCl( oPanel,oTimer, _lDefault )
    If _lDefault
        oPanel:nClrPane := _nClrStd
        oTimer:DeActivate()
        oTimer:Activate()
    Else
        oPanel:nClrPane := RGB(  255,140,105 )
    EndIf
Return
