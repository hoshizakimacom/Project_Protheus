#Include 'Totvs.ch'
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch'
#include 'TBICONN.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M04E01()

Local aArea         := GetArea()
Local _nQtd			:= 1
Local _nQtdImp		:= 2
Local _cNota    	:=""
Private _cCodProd	:= ZAB->ZAB_CODPRO
Private _cNumSer	:= ZAB->ZAB_NUMSER
Private cNumOpx     := ZAB->ZAB_NUMOP
Private _oDlg		:= Nil
Private _nOpca		:= 0
Private _cTitulo	:= 'Etiqueta Estoque'
Private cImprimeS 	:= "N"

/*DEFINE MSDIALOG _oDlg TITLE _cTitulo Style DS_MODALFRAME FROM 000,000 TO 303,318 PIXEL

@ 002,002 TO 148, 157 OF _oDlg PIXEL

@ 020,010 SAY 'Código Produto' 	SIZE 55, 07 OF _oDlg PIXEL
@ 020,070 MSGET _cCodProd SIZE 80, 11 F3 'SB1' Picture '@!' OF _oDlg PIXEL

@ 040,010 SAY 'Quantidade' SIZE 55, 07 OF _oDlg PIXEL
@ 040,070 MSGET _nQtd SIZE 80, 11 OF _oDlg Picture '@E 99999.99' PIXEL

@ 060,010 SAY 'Num. de Série' SIZE 55, 07 OF _oDlg PIXEL
@ 060,070 MSGET _cNumSer SIZE 80, 11 OF _oDlg Picture '@!' PIXEL

@ 080,010 SAY 'Quantidade Etiquetas' SIZE 55, 07 OF _oDlg PIXEL
@ 080,070 MSGET _nQtdImp SIZE 80, 11 OF _oDlg Picture '@E 99999' PIXEL

DEFINE SBUTTON FROM 125, 45 TYPE 1 ACTION (_nOpca := 1,(M04EMain(@_cCodProd,@_nQtd,@_cNota,@_nQtdImp, @_cNumSer))) ENABLE OF _oDlg
DEFINE SBUTTON FROM 125, 85 TYPE 2 ACTION (_nOpca := 2,_oDlg:End()) ENABLE OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED*/

/*If ZAB->ZAB_ETQLOG > 0
	MsgAlert("Etiqueta já impressa!","Atenção")
Else*/

// *** Verifica se o produto tem Apontamento na Produção *** //
cImprimeS:= MtaQrySD3()     // *** Valdemir - 01/02/2023 *** // 
if cImprimeS == "S"         // *** Valdemir - 02/02/2023 *** // 
	M04EMain(@_cCodProd,@_nQtd,@_cNota,@_nQtdImp, @_cNumSer)
else
	MsgInfo("Este produto "+alltrim(_cCodProd)+" de Serie numero "+alltrim(_cNumSer)+", nao esta apontado, portanto não pode ser Impresso","Atencao")
endif
//EndIf

RestArea(aArea)

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EMain(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)

	BeginTran()
	M04EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	EndTran()
	MsUnlockAll()

Return

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EValid(_cCodProd,_nQtd,_cNota,_nQtdImp)

	Local _lRet := .T.

	If !(_lRet := !Empty(_cCodProd))
		MsgInfo('É obrigatório informar o código do produto.','Atenção!')
		_lRet := .F.
	EndIf

	If _lRet .And. !(_lRet := _nQtd > 0)
		MsgInfo('Quantidade deve ser maior que zero.','Atenção!')
		_lRet := .F.
	EndIf
	
	If _lRet .And. !(_lRet := _nQtdImp > 0)
		MsgInfo('Quantidade de etiquetas a imprimir deve ser maior que zero.','Atenção!')
	EndIf

	If _lRet
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())

		If !(_lRet := SB1->(DbSeek( xFilial('SB1') + _cCodProd )))
			MsgInfo('Produto não localizado !','Atenção')
		EndIf
	EndIf
Return _lRet

//+----------------------------------------------------------------------------------------------------------------
Static Function M04EPrint(_cCodProd,_nQtd,_cNota,_nQtdImp,_cNumSer)
	Local _oPrinter		:= Nil
	Local _nRow 		:= 1

	Local _oFontP 		:= TFont():New('Arial',,12)
	Local _oFontM 		:= TFont():New('Arial',,15,.T.,.T.)	
	Local _oFontMI		:= TFont():New('Arial',,15,.T.,.T.,,,,,.F.,.T.)
	
	Local _oFontGG		:= TFont():New('Arial',,56,.T.,.T.)

	Local _nCol01		:= 020
	Local _nCol02		:= _nCol01 + 700
	Local _nCol03		:= _nCol01 + 2000
	Local _nNextLin		:= 50
	Local _cDescPro		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_DESC")
	Local _cDescPro1	:= ""
	Local _cDescPro2	:= ""
	Local _cDescPro3	:= ""
	Local _cUsers		:= Getmv("MV_XPALB08")  //"000247|000228|000131|000151|000251|000203|000298"
	Local _cQRCode		:= AllTrim(Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_XURL"))
	Private _oFontG 		:= TFont():New('Arial',,18,.T.,.T.)
	Private _lRetusr		:= .T.
	Private _cUnid		:= Posicione("SB1",1,xFilial("SB1")+_cCodProd,"B1_UM")

	// *** Verifica se tem Apontamentos para esta Ordem de Produção *** //
	If !RetCodUsr() $ _cUsers
		lRetusr	:= .F.
		MsgStop("Não é possível emitir a etiqueta, usuário não autorizado","Atenção")
	Else
		_oPrinter := FWMSPrinter():New('M04E01' + StrTran(Time(),':',''), IMP_SPOOL, .T./*_lAdjustToLegacy*/, /*cPathInServer*/, .T.,/*[ lTReport]*/, /*[ @oPrintSetup]*/, /*[ cPrinter]*/, /*[ lServer]*/, /*[ lPDFAsPNG]*/, /*[ lRaw]*/, /*[ lViewPDF]*/,_nQtdImp)

		_oPrinter:SetResolution(78)
		_oPrinter:SetLandscape()
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:StartPage()

		_oPrinter:SayBitMap( _nRow + 110 , 100 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)
		_oPrinter:SayBitMap( _nRow + 110 , 1500 ,GetSrvProfString("Startpath","") + "M10E001.bmp", 100 * 4.0 , 30 * 4.0)

		_nRow += _nNextLin * 2.6

		_nRow += _nNextLin * 0.9
	
		_oPrinter:Say(_nRow + 85 ,_nCol01 + 150 , "Grupo HOSHIZAKI",_oFontMI)
		_oPrinter:Say(_nRow + 85 ,_nCol01 + 1550 , "Grupo HOSHIZAKI",_oFontMI)
	
		_oPrinter:Say(_nRow ,_nCol02 , "Aços Macom Ind. e Com. Ltda",_oFontM)
		_oPrinter:Say(_nRow ,_nCol03 + 95 , "Aços Macom Ind. e Com. Ltda",_oFontM)
	
		_oPrinter:Say(_nRow + _nNextLin ,_nCol02 , "CNPJ: 43.553.668/0001-79",_oFontM)
		_oPrinter:Say(_nRow + _nNextLin ,_nCol03 + 95 , "CNPJ: 43.553.668/0001-79",_oFontM)
	
		_oPrinter:Say(_nRow + _nNextLin + 50 ,_nCol02 , "Tel.: (11) 2085-7000",_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 50 ,_nCol03 + 95 , "Tel.: (11) 2085-7000",_oFontM)

		If Len(_cDescPro) > 45
			_cDescPro1 := Substr(_cDescPro,1,44)
			_cDescPro2 := Alltrim(Substr(_cDescPro,45,54))
			_cDescPro3 := AllTrim(Substr(_cDescPro,99,54))
			_oPrinter:Say(_nRow + _nNextLin + 150,_nCol01 + 100 ,"Desc.: " + _cDescPro1,_oFontM)
			_oPrinter:Say(_nRow + _nNextLin + 150,_nCol01 + 1500 ,"Desc.: " + _cDescPro1,_oFontM)
			_oPrinter:Say(_nRow + _nNextLin + 200,_nCol01 + 100 ,_cDescPro2,_oFontM)		
			_oPrinter:Say(_nRow + _nNextLin + 200,_nCol01 + 1500 ,_cDescPro2,_oFontM)
			_oPrinter:Say(_nRow + _nNextLin + 250,_nCol01 + 100 ,_cDescPro3,_oFontM)
			_oPrinter:Say(_nRow + _nNextLin + 250,_nCol01 + 1500 ,_cDescPro3,_oFontM)
		Else
			_oPrinter:Say(_nRow + _nNextLin + 150 ,_nCol01 + 100 , "Desc.: " + _cDescPro,_oFontM)
			_oPrinter:Say(_nRow + _nNextLin + 150 ,_nCol01 + 1500 , "Desc.: " + _cDescPro,_oFontM)
		Endif	
	
		_oPrinter:Say(_nRow + _nNextLin + 400 ,_nCol01 + 100 , AllTrim(_cCodProd),_oFontGG)
		_oPrinter:Say(_nRow + _nNextLin + 400 ,_nCol01 + 1500 , AllTrim(_cCodProd),_oFontGG)

		_oPrinter:FWMSBAR('CODE128',15.0/*nRow*/,13/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
		_oPrinter:FWMSBAR('CODE128',15.0/*nRow*/,45/*nCol*/,AllTrim(_cCodProd),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	
		_oPrinter:Say(_nRow + _nNextLin + 755 ,_nCol01 + 75 , "Serial: " + _cNumSer,_oFontM)
		_oPrinter:Say(_nRow + _nNextLin + 755 ,_nCol01 + 1520 , "Serial: " + _cNumSer,_oFontM)
	
		_oPrinter:FWMSBAR('CODE128',22.0/*nRow*/,2.0/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
		_oPrinter:FWMSBAR('CODE128',22.0/*nRow*/,36/*nCol*/,AllTrim(_cNumSer),_oPrinter,.F./*lCheck*/,/*Color*/,/*lHorz*/, /*0.025 nWidth*/,1.0/* 1.5 nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F.,0.5,0.5,/*lCmtr2Pix*/)
	
		//_oPrinter:Say(_nRow + _nNextLin + 980 ,_nCol01 + 75 , "FGQ-009 Rev.01",_oFontM)	#5006
		//_oPrinter:Say(_nRow + _nNextLin + 980 ,_nCol01 + 1520 , "FGQ-009 Rev.01",_oFontM)	#5006

		_oPrinter:Say(_nRow + _nNextLin + 970 ,_nCol01 + 75 , "FGQ-FB-011 Rev.00",_oFontM)		//#5006
		_oPrinter:Say(_nRow + _nNextLin + 970 ,_nCol01 + 1520 , "FGQ-FB-011 Rev.00",_oFontM)	//#5006

		_oPrinter:Say(_nRow + _nNextLin + 970 ,_nCol01 + 955 , "MANUAL ONLINE",_oFontP)
		_oPrinter:Say(_nRow + _nNextLin + 970 ,_nCol01 + 2355 , "MANUAL ONLINE",_oFontP)

		_oPrinter:QrCode(1150,1080,_cQRCode, 085)
		
		If SB1->B1_XINMETR=="1"
			_oPrinter:SayBitMap( _nRow + 800 , 650 ,GetSrvProfString("Startpath","") + "M10E002.bmp", 50 * 4.0 , 50 * 4.0)
			_oPrinter:SayBitMap( _nRow + 800 , 2100 ,GetSrvProfString("Startpath","") + "M10E002.bmp", 50 * 4.0 , 50 * 4.0)
		End if
	
		_oPrinter:SetDevice(IMP_SPOOL)
		_oPrinter:cPrinter 		:= 'ZEBRA_S4M'

		_oPrinter:EndPage()
		_oPrinter:Print()

		FreeObj(_oPrinter)
	
	    //DBSELECTAREA("ZAB")
		//RecLock("ZAB", .F.)
		//ZAB->ZAB_ETQLOG := (ZAB->ZAB_ETQLOG + 1)
		//MsUnlock()
	EndIf	
Return


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MtaQrySD3   |Autor | VALDEMIR MIRANDA   | Data | 01/02/2023  ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Query para Validacao de Impressão de Etiquetas              ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MtaQrySD3()

Local axAreax:=GetArea()

cQry := "SELECT D3_FILIAL, D3_OP "
cQry += " FROM "+ RetSqlName("SD3") + " SD3 "
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'" 
cQry += " AND SD3.D3_COD = '"+ _cCodProd + "' "
cQry += " AND SubString(SD3.D3_OP,1,6)   = '"+ substr(cNumOpx,1,6) + "' " 
cQry += " AND SD3.D3_XNSERIE = '"+ _cNumSer + "' "
cQry += " AND SD3.D3_CF = 'PR0' "  
cQry += " AND SD3.D_E_L_E_T_ = '' " 
cQry += " ORDER BY SD3.D3_FILIAL,SD3.D3_COD,SD3.D3_OP,SD3.D3_TM,SD3.D3_XNSERIE ASC "

cAliasSD3	:= GetNextAlias() 
If Select(cAliasSD3) > 0
   dbSelectArea(cAliasSD3)
   dbCloseArea()
EndIf

cQry3 := ChangeQuery(cQry)
dbUseArea(.T.,'TOPCONN', TCGENQRY(,,cQry3), cAliasSD3, .F., .T.)

dbSelectArea(cAliasSD3) 
dbGoTop()
While !Eof()
    cImprimes:="S"
	dbskip()   
EndDo

dbSelectArea(cAliasSD3) 
(cAliasSD3)->(DBCLOSEAREA())

Restarea(axAreax)

Return(cImprimes)
