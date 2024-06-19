#INCLUDE 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

//+----------------------------------------------------------------------------------------------
// Rotina responsável pela impressão da OP
//  Chamada através do PE MA650BUT
//+----------------------------------------------------------------------------------------------
User Function M10R01()
    Local _cOP          := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD)

    Processa({||u_M10RProc(_cOP)},,,.T.)
Return

//+----------------------------------------------------------------------------------------------
User Function M10RProc (_cOP)
    Local _oPrinter     := Nil
    Local _oBrush       := TBrush():New( , RGB( 240 ,240 ,240))
    Local _oFont0       := TFont():New('Arial',,29,.T.,.T.)
    Local _oFont1       := TFont():New('Arial',,17,.T.,.T.)
    Local _oFont2       := TFont():New('Arial',,16)
    Local _oFont3       := TFont():New('Arial',,12,.T.,.T.)
    Local _oFont4       := TFont():New('Arial',,12)
    Local _oFont5       := TFont():New('Arial',,20,.T.,.T.)


    Local _nRow         := 0001
    Local _nColIni      := 0100
    Local _nColFim      := 0
    Local _nRowFim      := 0

    Local _cCliNome     := ''
    Local _cSigla       := ''
    Local _cRoteiro     := ''
    Local _aCliente     := {''}

    Local _cAlias       := GetNextAlias()
    Public _aCliente    := ""

    _oPrinter := FWMSPrinter():New('M10R002' + StrTran(Time(),':',''), IMP_PDF, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.)

    _oPrinter:SetResolution(78)
    _oPrinter:SetPortrait()
    _oPrinter:SetMargin(20,20,20,20)

    _oPrinter:StartPage()

    _nColFim := _oPrinter:nPageWidth
    _nRowFim := _oPrinter:nPageHeight

    // Seleciona dados da OP
    u_M10RGetC2(@_cAlias,_cOP)

    While (_cAlias)->(!EOF())
        // Retorna Roteiro
        u_M10RGetRo(_cAlias,@_cSigla,@_cRoteiro)



        // Imprime relatório
        u_M10RPrOP(_cAlias,_oPrinter,_oBrush,_oFont0,_oFont1,_oFont2,_oFont4,@_nRow,_nColIni,_nColFim,_aCliente,_cCliNome,_cSigla)
        u_M10RPrPro(_cAlias,_oPrinter,_oBrush,_oFont1,_oFont2,@_nRow,_nColIni,_nColFim,_nRowFim,_aCliente)
        u_M10RPrCom(_oPrinter,_oFont1,_oFont3,@_nRow,_nColIni,_nColFim,_cAlias,_oFont2)
        u_M10RPrIte(_cAlias,_oPrinter,_oFont4,@_nRow,_nColIni)
        u_M10RPrRot(_cAlias,_oPrinter,_oFont0,_oFont1,_oFont3,_oFont4,_oFont5,_nColIni,_nColFim,_nRowFim,_cRoteiro)

        _oPrinter:EndPage()
        _oPrinter:Print()

        (_cAlias)->(DbSkip())
    EndDo
    FreeObj(_oPrinter)
Return

//+----------------------------------------------------------------------------------------------
User Function M10RGetC2(_cAlias,_cOP)

    BeginSql Alias _cAlias
        Column C2_EMISSAO AS DATE
        Column C2_DATPRF AS DATE
        SELECT   SC6.R_E_C_N_O_ AS C6_RECNO
                ,SC2.R_E_C_N_O_ AS C2_RECNO
                ,SC5.R_E_C_N_O_ AS C5_RECNO
                ,SC6.C6_PRODUTO
                ,SC6.C6_ITEM
                ,SC6.C6_NUM
                ,SC5.C5_CONDPAG
                ,B1_COD
                ,CASE C2_ITEMPV WHEN '' THEN RTRIM(B1_DESC) ELSE 'IT: ' + RTRIM(C2_ITEMPV) + ' - ' + RTRIM(B1_DESC) END AS B1_DESC
                ,B1_XFAMILI
                ,C2_NUM,C2_ITEM
                ,C2_SEQUEN
                ,C2_PRODUTO
                ,C2_QUANT
                ,C2_PEDIDO
                ,C2_ITEMPV
                ,C2_EMISSAO
                ,C2_DATPRF
                ,C2_ITEMGRD
                ,C2_LOCAL
                ,CASE RTRIM(C2_PEDIDO) WHEN '' THEN 'EXPEDIÇÃO' ELSE  C5_CLIENTE + ' / ' + RTRIM(C5_LOJACLI) + ' - ' + RTRIM(A1_NOME) END AS A1_NOME
                ,A1_NREDUZ
                ,C2_XOBSENG
                ,C2_XRESPON
        FROM %Table:SC2% SC2
            INNER JOIN %Table:SB1% SB1 ON SB1.%NotDel% AND B1_FILIAL = %xFilial:SB1% AND B1_COD     = C2_PRODUTO
            LEFT  JOIN %Table:SC6% SC6 ON SC6.%NotDel% AND C6_FILIAL = %xFilial:SC6% AND C6_ITEM    = C2_ITEMPV AND C6_NUM = C2_PEDIDO // AND C6_PRODUTO = C2_PRODUTO
            LEFT  JOIN %Table:SC5% SC5 ON SC5.%NotDel% AND C5_FILIAL = %xFilial:SC5% AND C5_NUM     = C6_NUM
            LEFT  JOIN %Table:SA1% SA1 ON SA1.%NotDel% AND A1_FILIAL = %xFilial:SA1% AND A1_COD     = C5_CLIENTE AND A1_LOJA = C5_LOJACLI
        WHERE SC2.%NotDel% AND C2_FILIAL = %xFilial:SC2% AND C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD = %Exp:_cOP%
    EndSql

Return

//+----------------------------------------------------------------------------------------------
User Function M10RGetRo(_cAlias,_cSigla,_cRoteiro)
    Local _aRoteiros    := StrTokArr(GetMv('MV_X10A009',.T.,''),'{}')
    Local _aRoteiro := {}
    Local _nX           := 0

    For _nX := 1 To Len(_aRoteiros)
        _aRoteiro := StrTokArr(_aRoteiros[_nX],',')

        If _aRoteiro[1] == (_cAlias)->B1_XFAMILI
            _cSigla     := _aRoteiro[2]
            _cRoteiro   := _aRoteiro[3]

            Exit
        EndIf
    Next
Return

//+----------------------------------------------------------------------------------------------
User Function M10RPrOP(_cAlias,_oPrinter,_oBrush,_oFont0,_oFont1,_oFont2,_oFont4,_nRow,_nColIni,_nColFim,_aCliente,_cCliNome,_cSigla)
    Local _nCol2        := _nColIni + 400
    Local _nCol3        := _nColIni + 0900
    Local _nCol4        := _nColIni + 1300
    Local _nCol5        := _nColIni + 1700
    Local _nCol6        := _nColIni + 2050
    Local _nNext        := 90
    Local _nX           := 0
    Local _cxtpven      := ''
    Local _cxtpven1     := ''
    Local _cUserImpress := PswChave(RetCodUsr())  //4510

    _aCliente := M10RDescr((_cAlias)->A1_NOME,70)

    _oPrinter:Box(_nRow - 45    ,_nCol3+200 ,_nRow + 130,_nCol3 + 500)
    _oPrinter:Say(_nRow + 80    ,_nCol3 + 50, _cSigla   ,_oFont0)

    _nRow += 5
    _oPrinter:Say(_nRow         ,_nColIni   + 215,'OP: ' + (_cAlias)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)       ,_oFont0)

    _nRow  += 90
    _oPrinter:Say(_nRow         ,_nColIni   + 2,'PEDIDO: ' + (_cAlias)->C2_PEDIDO        ,_oFont0)
    
    _oPrinter:FWMSBAR('CODE128', -60/*nRow*/ , 34.5 ,(_cAlias)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.75/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.7,0.7,/*lCmtr2Pix*/)
    
    _oPrinter:Say(_nRow +50     ,_nColIni   + 2,'Impresso por: ' + _cUserImpress          ,_oFont4) //4510
   
    _oPrinter:Say(_nRow +50     ,_nColIni   + 1850,(_cAlias)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)      ,_oFont4)
   
    _nRow += 40
    _nRow += _nNext
    _oPrinter:Box(_nRow - 50,_nColIni - 5,_nRow + 20,_nColFim + 5)
    _oPrinter:FillRect({_nRow - 45,_nColIni,_nRow + 13,_nColFim},_oBrush,'-2')

    _oPrinter:Say(_nRow     ,_nColIni   ,'Pedido/Seq.:'                 ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol2 ,(_cAlias)->C2_PEDIDO + ' / ' + (_cAlias)->C2_ITEMPV        ,_oFont1)

    _oPrinter:Say(_nRow     ,_nCol3 ,'Data Emissão:'                                ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol4 ,DToC((_cAlias)->C2_EMISSAO,'DD/MM/YYY')            ,_oFont2)

    _oPrinter:Say(_nRow     ,_nCol5 ,'Data Prevista:'                               ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol6 ,DToC((_cAlias)->C2_DATPRF,'DD/MM/YYY')     ,_oFont2)

    _nRow += _nNext
    _oPrinter:Box(_nRow - 50,_nColIni - 5,(_nRow + IIF(Len(_aCliente) > 1,_nNext * 2,_nNext)) + 20,_nColFim + 5)
    _oPrinter:FillRect({_nRow - 45,_nColIni,(_nRow + IIF(Len(_aCliente) > 1,_nNext * 2,_nNext)) + 13,_nColFim},_oBrush,'-2')

    _oPrinter:Say(_nRow         ,_nColIni   ,'Cliente / Loja:'                              ,_oFont1)

    For _nX := 1 To Len(_aCliente)
        If _nX > 1
            _nRow += _nNext - 20
        EndIf

        _oPrinter:Say(_nRow         ,_nCol2 ,  _aCliente[_nX]               ,_oFont2)
    Next

    If Len(_aCliente) == 1
        _nRow -= 20
    EndIf

    _nRow += _nNext + 20
    _oPrinter:Say(_nRow         ,_nColIni   ,'Nome Fant.:'                      ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol2 ,Rtrim((_cAlias)->A1_NREDUZ)                            ,_oFont2)

    _nRow += _nNext
    _oPrinter:Box(_nRow - 50,_nColIni - 5,_nRow + 20,_nColFim + 5)
    _oPrinter:FillRect({_nRow - 45,_nColIni,_nRow + 13,_nColFim},_oBrush,'-2')

    _oPrinter:Say(_nRow     ,_nColIni   ,'Resp. Eng.:'                  ,_oFont1)

    SC2->(DbGoTo( (_cAlias)->C2_RECNO ))
    _oPrinter:Say(_nRow         ,_nCol2 ,(_cAlias)->C2_XRESPON ,_oFont2)

    //solicitação feita por milena CHAMADO 2103
    _cxtpven:= AllTrim(Posicione('SC5',1,xFilial('SC5') + (_cAlias)->C2_PEDIDO,'C5_XTPVEN'))

//	U_BusTpVen(cTpVen) //Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN
    
    Do Case
		Case AllTrim(_cxtpven) == "1" 
			_cxtpven1		:= "1 - Projeto"
		Case AllTrim(_cxtpven) == "2"
			_cxtpven1		:= "2 - Venda Unitaria"
		Case AllTrim(_cxtpven) == "3"
			_cxtpven1		:= "3 - Dealer"			
		Case Alltrim(_cxtpven) == "4"
			_cxtpven1		:= "4 - E-Commerce"
		Case Alltrim(_cxtpven) == "5"
			_cxtpven1		:= "5 - Pronta Entrega"
		Case Alltrim(_cxtpven) == "6"
			_cxtpven1		:= "6 - Projeto-Dealer"
		Case Alltrim(_cxtpven) == "7"
			_cxtpven1		:= "7 - Venda Pecas"
		Case Alltrim(_cxtpven) == "8"
			_cxtpven1		:= "8 - Sup.Tecnico"
		Case Alltrim(_cxtpven) == "9"
			_cxtpven1		:= "9 - ARE"
		Case Alltrim(_cxtpven) == "10"
			_cxtpven1		:= "10 - Serv"
		Case Alltrim(_cxtpven) == "11"
			_cxtpven1		:= "11 - Itens Falta"
		Case Alltrim(_cxtpven) == "12"
			_cxtpven1		:= "12 - SAC"
		Case Alltrim(_cxtpven) == ""
			_cxtpven1		:= ""
	EndCase

    _oPrinter:Say(_nRow         ,_nCol5 , "Tipo Venda: "+_cxtpven1,_oFont2)

    _nRow += _nNext + 20
Return

//+----------------------------------------------------------------------------------------------
User Function M10RPrPro(_cAlias,_oPrinter,_oBrush,_oFont1,_oFont2,_nRow,_nColIni,_nColFim,_nRowFim,_aCliente)
    Local _nCol2        := _nColIni + 400
    Local _nNext        := 60
    Local _nX           := 0
    Local _cB5Descr     := Posicione("SB5",1,xFilial("SB5")+(_cAlias)->B1_COD,"B5_CEME")
    Local _aDescri      := ""//M10RDescr((_cAlias)->B1_DESC,61)
    Local _aC6ObsEng    := M10RForm((_cAlias)->C6_RECNO,'SC6','C6_XOBSENG')
    //Local _aC6ObsCom    := U_MR10GetDes((_cAlias)->C5_RECNO,(_cAlias)->B1_DESC,75)
    Local _aC6ObsCom    := ''
    Local _aC2Obs       := M10RForm(,,(_cAlias)->C2_XOBSENG)
    Local _cVendedor	:= Posicione("SC5",1,xFilial("SC5")+(_cAlias)->C2_PEDIDO,"C5_VEND1")
    Local _cClasse		:= ''
    Private _nPos         := 0
    
    If Empty(_cB5Descr)
        _aDescri := M10RDescr((_cAlias)->B1_DESC,61)
    Else
        _aDescri := M10RDescr(_cB5Descr,61)
    Endif

	If SB5->(MsSeek(xFilial("SB5")+AllTrim((_cAlias)->B1_COD)))
		_aC6ObsCom    := U_MR10GetDes((_cAlias)->C5_RECNO, SB5->B5_CEME ,70)
	Else
		_aC6ObsCom    := U_MR10GetDes((_cAlias)->C5_RECNO,(_cAlias)->B1_DESC,75)
	Endif		

    If _cVendedor == '000007'
		_cClasse := 'REDES'
	ElseIf _cVendedor == '000008'
		_cClasse := 'SUPORTE TECNICO'
	Else
		_cClasse := 'GASTRONOMIA'
	Endif
                                                  
    _nRow += 20
    _oPrinter:Say(_nRow         ,_nColIni   ,'Produto'                          ,_oFont1)
    _nRow += 20

    _oPrinter:Line(_nRow,_nColIni, _nRow, _nColFim)
    _nRow += _nNext

    _oPrinter:Say(_nRow     ,_nColIni   ,'Quantidade'                   ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol2 ,CValToChar((_cAlias)->C2_QUANT)            ,_oFont2)
    _nRow += _nNext

    _oPrinter:Say(_nRow     ,_nColIni   ,'Código'               ,_oFont1)
    _oPrinter:Say(_nRow         ,_nCol2 ,(_cAlias)->C2_PRODUTO      ,_oFont2)
    _nRow += _nNext + 10
    
    If Len(_aCliente) > 1
	    _oPrinter:FWMSBAR('CODE128', 18.5/*nRow*/ , 33 ,(_cAlias)->C2_PRODUTO,_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.75/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.7,0.7,/*lCmtr2Pix*/)
	Else
		_oPrinter:FWMSBAR('CODE128', 16.5/*nRow*/ , 33 ,(_cAlias)->C2_PRODUTO,_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,0.75/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.7,0.7,/*lCmtr2Pix*/)
	Endif		
    
    _oPrinter:Say(_nRow     ,_nColIni   ,'Armazem'              ,_oFont1)
    _oPrinter:Say(_nRow     ,_nCol2 	,(_cAlias)->C2_LOCAL    ,_oFont2)
    _oPrinter:Say(_nRow		,_nCol2+500 ,'[ ' + _cClasse + ' ]' ,_oFont2)
    _nRow += _nNext + 10

    _oPrinter:Say(_nRow     ,_nColIni ,'Descrição'          ,_oFont1)

    For _nX := 1 To Len(_aDescri)
        If _nX > 1;_nRow += _nNext; EndIf

        _oPrinter:Say(_nRow         ,_nCol2 ,_aDescri[_nX]              ,_oFont1)
    Next

    // Descrição pedido
    _nRow += _nNext
    _nRow += 30

    _oPrinter:Say(_nRow     ,_nColIni ,'Descr. Pedido'  ,_oFont1)
    _oPrinter:FillRect({_nRow - _nNext,_nCol2 - 5,_nRow + (_nNext * (Len(_aC6ObsCom) -1) ) + 20,_nColFim + 5},_oBrush,'-2')

    For _nX := 1 To Len(_aC6ObsCom)
        _oPrinter:Say(_nRow         ,_nCol2 ,_aC6ObsCom[_nX]                ,_oFont2)
        _nRow += _nNext
    Next

    // Observação Engenharia
    _nRow += _nNext
    _nRow += 10

    _oPrinter:Say(_nRow  ,_nColIni ,'Obs. Engenharia'    ,_oFont1)
    _oPrinter:FillRect({_nRow - _nNext,_nCol2 - 5,_nRow + (_nNext * (Len(_aC6ObsEng) -1) ) + 20,_nColFim },_oBrush,'-2')

    For _nX := 1 To Len(_aC6ObsEng)
        _oPrinter:Say(_nRow         ,_nCol2 ,_aC6ObsEng[_nX]                ,_oFont2)
        _nRow += _nNext
    Next

    // Obs. OP
    _nRow += _nNext
    _oPrinter:FillRect({_nRow - _nNext,_nCol2 - 5,_nRow + (_nNext * (Len(_aC2Obs) -1) ) + 20,_nColFim + 5},_oBrush,'-2')

    For _nX := 1 To Len(_aC2Obs)
        _oPrinter:Say(_nRow         ,_nCol2 ,_aC2Obs[_nX]               ,_oFont2)
        _nRow += _nNext
    Next

    _nRow += _nNext
Return

//+----------------------------------------------------------------------------------------------
User Function M10RPrCom(_oPrinter,_oFont1,_oFont3,_nRow,_nColIni,_nColFim,_cAlias,_oFont2)
    Local _nCol2        := _nColIni + 100
    Local _nCol3        := _nColIni + 390
    Local _nCol4        := _nColIni + 610
    Local _nNext        := 60
    Local _nDiasLead	:= (_cAlias)->C2_DATPRF - (_cAlias)->C2_EMISSAO
    Local _dDatEng		:= (_cAlias)->C2_EMISSAO + (0.25 * _nDiasLead)
    Local _dDatProg		:= _dDatEng + (0.25 * _nDiasLead)
    Local _dDatCPC		:= _dDatProg + (0.25 * _nDiasLead)
    Local _dDatMont		:= _dDatCPC + (0.25 * _nDiasLead)    

    _oPrinter:Say(_nRow -6  ,_nColIni	   ,'Componentes'                  				,_oFont1)
    _oPrinter:Say(_nRow -6	,_nColIni+440  ,'|  Eng. : ' + DTOC(_dDatEng,'DD/MM/YYY') 	,_oFont3)
    _oPrinter:Say(_nRow -6	,_nColIni+720  ,'|  Prog. : ' + DTOC(_dDatProg,'DD/MM/YYY') 	,_oFont3)    
	_oPrinter:Say(_nRow -6	,_nColIni+1030 ,'|  C.P.C. : ' + DTOC(_dDatCPC,'DD/MM/YYY') 	,_oFont3)
	_oPrinter:Say(_nRow -6	,_nColIni+1350 ,'|  Mont. : ' + DTOC(_dDatMont,'DD/MM/YYY')	,_oFont3)
	_oPrinter:Say(_nRow -6	,_nColIni+1980 ,'|  Lead Time : ' + ALLTRIM(STR(_nDiasLead)) + ' dias.' 	,_oFont3)

    _oPrinter:Line(_nRow,_nColIni, _nRow, _nColFim+45)
    _nRow += _nNext

    _oPrinter:Say(_nRow     ,_nColIni   ,'Seq.'           ,_oFont3)
    _oPrinter:Say(_nRow     ,_nCol2 	,'Componente'     ,_oFont3)
    _oPrinter:Say(_nRow     ,_nCol3 	,'Quantidade'     ,_oFont3)
    _oPrinter:Say(_nRow     ,_nCol4 	,'Descrição'      ,_oFont3)

Return

//+----------------------------------------------------------------------------------------------
User Function M10RPrRot(_cAlias,_oPrinter,_oFont0,_oFont1,_oFont3,_oFont4,_oFont5,_nColIni,_nColFim,_nRowFim,_cRoteiro)
    Local _nCol     := _nColIni
    Local _nColTam  := 400
    Local _nRow     := _nRowFim - 250
    Local _nRowTam  := _nRowFim - 30
    Private _nColSep  := 120

    

    //+-------------------------------------------------
    // CPC / CORTE
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -600 ,_nCol   ,_nRowTam -450,_nCol + _nColTam )
    _oPrinter:Box(_nRow -500,_nCol    ,_nRowTam -550,_nCol + _nColTam )

    _oPrinter:Say(_nRow -530 ,_nCol + 40  ,'CPC / CORTE'      ,_oFont1)
    
    //+-------------------------------------------------
    // SOLDA
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -150 ,_nCol   ,_nRowTam    ,_nCol + _nColTam )
    _oPrinter:Box(_nRow -70  ,_nCol   ,_nRowTam -90,_nCol + _nColTam )

    _oPrinter:Say(_nRow -90  ,_nCol + 105  ,'SOLDA'      ,_oFont1)
    
    //+-------------------------------------------------
    // CPC / DOBRA
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -600 ,_nCol + 450   ,_nRowTam -450,_nCol + 850 )
    _oPrinter:Box(_nRow -500 ,_nCol + 450   ,_nRowTam -550,_nCol + 850 )

    _oPrinter:Say(_nRow -530 ,_nCol + 480  ,'CPC / DOBRA'      ,_oFont1)

    //+-------------------------------------------------
    // MONT. INICIAL
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -150 ,_nCol +450  ,_nRowTam    ,_nCol + 850 )
    _oPrinter:Box(_nRow -70  ,_nCol +450  ,_nRowTam -90,_nCol + 850 )

    _oPrinter:Say(_nRow -90  ,_nCol + 480  ,'MONT.INICIAL'      ,_oFont1)

    //+-------------------------------------------------
    // CPC / REBARBA
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -600 ,_nCol + 900   ,_nRowTam -450,_nCol + 1300 )
    _oPrinter:Box(_nRow -500 ,_nCol + 900   ,_nRowTam -550,_nCol + 1300 )

    _oPrinter:Say(_nRow -530 ,_nCol + 930  ,'CPC/REBARBA'      ,_oFont1)

    //+-------------------------------------------------
    // MONT. FINAL
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -150 ,_nCol +900  ,_nRowTam    ,_nCol + 1300 )
    _oPrinter:Box(_nRow -70  ,_nCol +900  ,_nRowTam -90,_nCol + 1300 )

    _oPrinter:Say(_nRow -90  ,_nCol + 950  ,'MONT.FINAL'      ,_oFont1)

    //+-------------------------------------------------
    // PRE-MONTAGEM 
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -600 ,_nCol + 1350   ,_nRowTam -450,_nCol + 1750 )
    _oPrinter:Box(_nRow -500 ,_nCol + 1350   ,_nRowTam -550,_nCol + 1750 )

    _oPrinter:Say(_nRow -530 ,_nCol + 1350  ,'PRE-MONTAGEM'      ,_oFont1)

    //+-------------------------------------------------
    // POLIMENTO  
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -150 ,_nCol +1350  ,_nRowTam    ,_nCol + 1750 )
    _oPrinter:Box(_nRow -70  ,_nCol +1350  ,_nRowTam -90,_nCol + 1750 )

    _oPrinter:Say(_nRow -90  ,_nCol + 1400  ,'POLIMENTO'      ,_oFont1)

    //+-------------------------------------------------
    // CARIMBOS  
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -1280 ,_nCol + 1800  ,_nRowTam -450,_nCol + 2350 )
    _oPrinter:Box(_nRow -1200 ,_nCol + 1800  ,_nRowTam -700,_nCol + 2350 )
    _oPrinter:Box(_nRow -1000 ,_nCol + 1800  ,_nRowTam -950,_nCol + 2350 )

    _oPrinter:Say(_nRow -1220 ,_nCol + 1940  ,'CARIMBOS'      ,_oFont1)
    _oPrinter:Say(_nRow -1160 ,_nCol + 1965  ,'ENGENHARIA'    ,_oFont3)
    _oPrinter:Say(_nRow  -960 ,_nCol + 1950  ,'PROGRAMAÇÃO'   ,_oFont3)
    _oPrinter:Say(_nRow  -690 ,_nCol + 2020  ,'LASER'		  ,_oFont3)
    _oPrinter:Say(_nRow  -440 ,_nCol + 2020  ,'DOBRA'		  ,_oFont3)
    
    //+-------------------------------------------------
    // QUALIDADE  
    //+-------------------------------------------------
    _oPrinter:Box(_nRow -150 ,_nCol +1800  ,_nRowTam    ,_nCol + 2350 )
    _oPrinter:Box(_nRow -70  ,_nCol +1800  ,_nRowTam -90,_nCol + 2350 )

    _oPrinter:Say(_nRow -90  ,_nCol + 1925  ,'QUALIDADE'      ,_oFont1)    

    _oPrinter:Say(_nRow  +250 ,_nCol + 105  ,'FGQ-FB-014'      ,_oFont3)        //#5006
    _oPrinter:Say(_nRow  +250 ,_nCol + 2100  ,'REV.:00'      ,_oFont3)          //#5006

Return

//+----------------------------------------------------------------------------------------------
User Function M10RPrIte(_cAlias,_oPrinter,_oFont4,_nRow,_nColIni)
    Local _cComp    := GetNextAlias()
    Local _nCol2        := _nColIni + 100
    Local _nCol3        := _nColIni + 390
    Local _nCol4        := _nColIni + 610
    Local _nNext        := 60

    BeginSql Alias _cComp
        SELECT  BH_SEQUENC
                ,BH_PRODUTO
                ,BH_CODCOMP
                ,BH_QUANT
                ,B1_DESC
        FROM %Table:SBH% SBH
            INNER JOIN %Table:SB1% SB1 ON SB1.%NotDel% AND B1_FILIAL = %xFilial:SB1% AND B1_COD = BH_CODCOMP
        WHERE   SBH.%NotDel% AND BH_FILIAL = %xFilial:SBH%
            AND BH_PRODUTO = %Exp:(_cAlias)->C2_PRODUTO%
        ORDER BY BH_SEQUENC
    EndSql

    While (_cComp)->(!EOF())
        _nRow += _nNext

        _oPrinter:Say(_nRow     ,_nColIni   ,(_cComp)->BH_SEQUENC           ,_oFont4)
        _oPrinter:Say(_nRow     ,_nCol2 ,(_cComp)->BH_CODCOMP           ,_oFont4)
        _oPrinter:Say(_nRow     ,_nCol3 ,Transform((_cComp)->BH_QUANT, X3Picture('BH_QUANT'))   ,_oFont4)

        _oPrinter:Say(_nRow         ,_nCol4 ,StrTran(AllTrim((_cComp)->B1_DESC),'  ',' ')               ,_oFont4)

        (_cComp)->(DbSkip())
    EndDo
Return

//+----------------------------------------------------------------------------------------------
Static Function M10RForm(_nRecno,_cAlias,_cCpo,_nOriQt)
    Local _aRet     := {}
    Local _nQuant   := 0
    Local _nX       := 1
    Local _cLinha   := ''
    Local _lEmpty   := .T.

    Local _cCampo   := ''

    Default _nOriQt     := 85
    Default _nRecno     := 0
    Default _cAlias     := ''
    Default _cCpo       := ''

    If _nRecno > 0
        _cCampo := _cAlias + '->' + _cCpo

        DbSelectArea(_cAlias)
        DbGoTo(_nRecno)

        If Len(AllTrim(&(_cCampo))) > 0
            While _nX < Len(AllTrim(&(_cCampo)))
                _nQuant := _nOriQt

                While SubStr(AllTrim(&(_cCampo)),_nQuant, 1) <> ' ' .And. !(_nQuant < 0)
                    _nQuant--
                EndDo

                _cLinha := SubStr(AllTrim(&(_cCampo)),_nX, _nQuant)

                AAdd(_aRet, M10RNoCar(_cLinha) )

                _lEmpty := .F.
                _nX += _nQuant

                If _nQuant < 0
                    Exit
                EndIf
            EndDo
        EndIf
    ElseIf Empty(_cAlias)
        _cCampo := _cCpo

        If Len(AllTrim(_cCampo)) > 0
            While _nX < Len(AllTrim(_cCampo))
                _nQuant := _nOriQt

                While SubStr(AllTrim(_cCampo),_nQuant, 1) <> ' '
                    If Len(AllTrim(_cCampo)) < _nQuant
                        Exit
                    EndIf
                    _nQuant--
                EndDo

                _cLinha := SubStr(AllTrim(_cCampo),_nX, _nQuant)

                AAdd(_aRet,  M10RNoCar(_cLinha))

                _lEmpty := .F.
                _nX += _nQuant
            EndDo
        EndIf
    EndIf

    If _lEmpty
        _aRet   := {''}
    EndIf
Return AClone(_aRet)

//+----------------------------------------------------------------------------------------------
Static Function M10RNoCar(_cVar)
    _cVar := StrTran(_cVar,Chr(13) + Chr(10),' ')
    _cVar := StrTran(_cVar,Chr(13),' ')
    _cVar := StrTran(_cVar,Chr(10),' ')
    _cVar := StrTran(_cVar,Chr(9),' ')
Return _cVar

//+----------------------------------------------------------------------------------------------
User Function MR10GetDes(_nRecSC5,cDescSB1,nTam)
    Local aDescRet      := {}
    Private lDescom       := .T.

    If _nRecSC5 == 0
        aDescRet := {'*** OP sem pedido ***'}
    Else
        aDescRet := M10RDescr(cDescSB1,nTam )
    EndIf

Return aDescRet

//+----------------------------------------------------------------------------------------------
Static Function M10RDescr(cDesc,nTam)
    Local aRet      := {}
    Local cAux      := ""
    Local cLetras   := ""
    Local cRet      := ""
    Local i         := 0
    Local nIni      := 1
    Local nQuebra   := 1

    // Retira enter da descrição
    Replace( cDesc , chr(13) ," ")

    // Retira espaçoes duplicados
    For i := 1 to Len( cDesc ) - 1
        cLetras := Substr( cDesc , i , 2 )

        If cLetras <> "  "
            cRet += Left(cLetras,1)
        EndIf
    Next

    If i > 0 .and. cLetras <> "  "
        cRet += Right(cLetras,1)
    EndIf

    cDesc := cRet

    While Len(cDesc) > 0
        cAux    := SubString(cDesc,1,nTam)       // Quebra linha

        If nTam <= Len(cDesc)
            nQuebra := Rat(" ",cAux)                    // Tamanho da quebra

            AAdd(aRet, SubString(cDesc,1,nQuebra) )
        Else
            AAdd(aRet, cDesc )
            Exit
        EndIf

        nIni    := nQuebra++
        cDesc   := SubString(cDesc,nIni,Len(cDesc))
    EndDo
Return AClone(aRet)
