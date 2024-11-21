#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------

User Function M10E05()

	Private _oDlg		:= Nil
	Private _nOpca	    := 0
	Private _cTitulo	:= 'Etiqueta Picking List' 
	Private _nQtd		:= 1
	Private _nQtdImp	:= 1
	Private _cNota	    := Space(TamSX3('B1_COD')[1])
	Private _cNumSer	:= Space(TamSX3('ZA0_SERIE')[1])

    //Local _cNumOP      := SC2->C2_NUM                       //#7459
    //Local _nQtdOP      := SC2->C2_QUANT                     //#7459
  
			M02EMain(ZAB->ZAB_CODPROD,1,"", 1, ZAB->ZAB_NUMSER)
		
Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M02EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BeginTran()

			M10E05P(_cCodProd,_nQtd,_cNumSer)
	
	EndTran()
	MsUnlockAll()

Return

Static Function M10E05P(_cCodProd,_nQtd,_cNumSer)
    
    Local _cCodProd     := Posicione("SB1",1,xFilial("SB1")+ SC2->C2_PRODUTO,"B1_COD") //#7459
    Local _cNumOP       := SC2->C2_NUM                   //#7459
    Local _nQtdOP       := SC2->C2_QUANT                 //#7459
	Local _oPrinter	    := Nil
	Local _nRow 		:= 90
	
    Local _oFontPP 		:= TFont():New('Arial',,8)
	//Local _oFontP 		:= TFont():New('Arial',,12)
    Local _oFontMM 		:= TFont():New('Arial',,15)	
	Local _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Local _oFontGM		:= TFont():New('Arial',,20,.T.,.T.)

	Local _cDescPro		:= AllTrim(Substr(Posicione("SB1",1,xFilial("SB1")+AllTrim(aEstru[nX,3]),"B1_DESC"),1,84))
	Local _cDescPro1	:= SubStr(_cDescPro,1,48)
	Local _cDescPro2	:= SubStr(_cDescPro,49,84)

    Private nColBar     := 2.3    
    Private nRowStep    := 25
    Private nRowBar     := 60 //9.5

    //MsgStop("Exportação")
   
    _oPrinter:= FWMSPrinter():New('M10E05', IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)
    _oPrinter:SetResolution(78)
    _oPrinter:SetDevice(IMP_SPOOL)
    _oPrinter:StartPage()
    
    //Logo Macom
    _oPrinter:SayBitMap( _nRow -40 , 50 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0) 	                //Logo Macom
    
    //Informação Item		
    _oPrinter:Say(_nRow + 150 , 70,     "Código: "              ,_oFontM)															// Código
    _oPrinter:Say(_nRow + 150 , 250, 	AllTrim(aEstru[nX,3])   ,_OFontGM)											                // Código do item		
    _oPrinter:FWMSBAR('CODE128',6 /*nRow*/,1.6/*nCol*/,AllTrim(aEstru[nX,3]),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/,0.018/*0.025 nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.3*/,/*0.3,/*lCmtr2Pix*/)

    _oPrinter:Say(_nRow + 280 , 70,     _cDescPro1              ,_oFontMM)															//Descrição Produto
    _oPrinter:Say(_nRow + 320 , 70,     _cDescPro2              ,_oFontMM)															//Descrição Produto
    _oPrinter:Say(_nRow + 370 , 70,     "Qt.: "                 ,_oFontM)															//Quantidade
    _oPrinter:Say(_nRow + 370 , 250,    AllTrim(Transform(NoRound(aEstru[nX,7] * SC2->C2_QUANT,2) ,"@E 999999.99"))  ,_OFontGM)	    //Quantidade por OP			

    //Ordem de Produção
    _oPrinter:Say(_nRow + 430 , 70,     "OP: "                  ,_oFontM)														    //OP
    _oPrinter:Say(_nRow + 430 , 250,    _cNumOP                 ,_OFontGM)														    //Numero de Série
    _oPrinter:FWMSBAR('CODE128',13 /*nRow*/,1.6/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, 0.018/* nWidth*/,0.5/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,/*0.5*/,/*0.5*/,/*lCmtr2Pix*/) //Cod. Barra Número Série
    
    //Informação Produto PA
    _oPrinter:Say(_nRow + 600 , 70,     "Produto: "             ,_oFontM)										                    //Produto
    _oPrinter:Say(_nRow + 600 , 300,    Alltrim(_cCodProd)      ,_OFontGM)										                    //Código Produto PA
    _oPrinter:Say(_nRow + 650 , 70,     "Qt.Produto: "          ,_oFontM)										                    //QUantidade
    //_oPrinter:Say(_nRow + 650 , 300,    _nQtdOP                 ,_oFontM)										                    //Quantidade do produto a ser produzida
    _oPrinter:Say(_nRow + 650 , 300,    AllTrim(Transform(_nQtdOP,"@E 999,999,999.99"))                 ,_OFontGM)                  //Quantidade do produtoa ser produzida
    //Código Etiqueta		
    _oPrinter:Say(_nRow + 685 , 1050, "FGQ-FB-017 Rev.00"       ,_oFontPP)												            //Código FGQ Etiqueta

    //_oPrinter:SetDevice(IMP_SPOOL)
    _oPrinter:cPrinter 		:= 'ZEBRA'
    _oPrinter:EndPage()
    _oPrinter:Print()

    FreeObj(_oPrinter)

Return
