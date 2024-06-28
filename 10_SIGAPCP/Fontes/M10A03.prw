#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"
#Include "TOTVS.ch"
User Function M10A03()

Local _lOpc := .F.
Local _lRet   := .T.
Local _cUsers := GETMV("MV_XPALB06")//"000247|000228|000131|000151|000024|000259|000325|000305|000486" 

If .F. //!RetCodUsr() $ _cUsers
	_lRet := .T.	
	MsgAlert("Geração de número(s) de Série não Permitida para este usuário !","ATENÇÃO")
	Return(_lRet)

Else 

	_lOpc := MsgYesNo("Deseja gerar os números de série para a ordem de produção : " + SC2->C2_NUM +" ? ", "Geração de Números de Série")

	If _lOpc
		Fwmsgrun(,{|| U_M10A03B()},"Números de Série", "Processando...")
	EndIf 

EndIf

Return

//+----------------------------------------------------------------------------------------------------------------
// Rotina de impressão de etiqueta térmica (ZEBRA GC420t)
//	Substitui utilização da planilha SP02 / Etiqueta Identificação (Pedido/Seq)
//+----------------------------------------------------------------------------------------------------------------
User Function M10A03B()
Local _cNumSer 	:= ""
Local _cAno		:= ""
Local _cMes		:= ""
Local _nSerial 	:= GetMV("AM_NUMSER")
Local _nAno		:= year(ddatabase)
Local _nMes		:= month(ddatabase)
Local _nQtdOP	:= SC2->C2_QUANT
Local _nQtdJE	:= SC2->C2_QUJE
Local _cFamilia := Posicione("SB1",1, xFilial("SB1") + SC2->C2_PRODUTO,"B1_XFAMILI")
Local _nX		:= 0
Local _lErro	:= .F.

DBSelectArea("ZAB")
DBSetOrder(2)

If _nQtdJE <> 0
	MsgStop("Não é possível a geração de Número(s) de Série, para Ordem de Produção Encerrada ou Iniciada ", "Atenção")
Else
	If ! _cFamilia $ "000001|000002|000003|000004"
		MsgStop("Só é possível gerar Número(s) de Série para as Famílias Cocção, Mobiliário e Refrigeração ", "Atenção")
	Else
		If ZAB->(MSSeek(xFILIAL("ZAB")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
			MsgInfo("Número(s) de Série já gerados para esta Ordem de Produção - Número de Serie : "+ZAB->ZAB_NUMSER,"Atenção")
		Else
			Do Case
				Case _nAno == 2015
					_cAno := "A"
			 	Case _nAno == 2016
			 		_cAno := "B"
				Case _nAno == 2017
					_cAno := "C"
				Case _nAno == 2018
					_cAno := "D"
				Case _nAno == 2019
					_cAno := "E"
				Case _nAno == 2020
					_cAno := "F"
				Case _nAno == 2021
					_cAno := "G"
				Case _nAno == 2022
					_cAno := "H"
				Case _nAno == 2023
					_cAno := "I"
				Case _nAno == 2024
					_cAno := "J"		 
				Case _nAno == 2025
					_cAno := "K"
				Case _nAno == 2026
					_cAno := "L"
				Case _nAno == 2027
					_cAno := "M"
				Case _nAno == 2028
					_cAno := "N"
				Case _nAno == 2029
					_cAno := "O"
				Case _nAno == 2030
					_cAno := "P"
				Case _nAno == 2031
					_cAno := "Q"
				Case _nAno == 2032
					_cAno := "R"
				Case _nAno == 2033
					_cAno := "S"
				Case _nAno == 2034
					_cAno := "T"
				Case _nAno == 2035
					_cAno := "U"
				Case _nAno == 2036
					_cAno := "V"
				Case _nAno == 2037
					_cAno := "X"
				Case _nAno == 2038
					_cAno := "Y"
				Case _nAno == 2039
					_cAno := "W"
				Case _nAno == 2040
					_cAno := "Z"
			EndCase

			Do Case
				Case _nMes == 1
					_cMes := "A"
				Case _nMes == 2
					_cMes := "B"
				Case _nMes == 3
					_cMes := "C"
				Case _nMes == 4
					_cMes := "D"
				Case _nMes == 5
					_cMes := "E"
				Case _nMes == 6
					_cMes := "F"
				Case _nMes == 7
					_cMes := "G"
				Case _nMes == 8
					_cMes := "H"
				Case _nMes == 9
					_cMes := "I"
				Case _nMes == 10
					_cMes := "J"
				Case _nMes == 11
					_cMes := "K"
				Case _nMes == 12
					_cMes := "L"
			EndCase
			
			DBSelectArea("ZAB")
			DBSetOrder(1)

//			dbGoTo(Lastrec())
//			If Substr(ZAB->ZAB_NUMSER, 9,1) <> _cMes
//				_nSerial := "0"
//			EndIf
//			GetMV("AM_NUMSER"+_cMes)

			// Busca Ultimo Número de Série no Mês e Ano 
			cQuery := "SELECT MAX(ZAB_NUMSER) NUMSER"
			cQuery += " FROM "+RetSqlName("ZAB")+" ZAB "
			cQuery += " WHERE ZAB_FILIAL = '"+xFilial("ZAB")+"'"
			cQuery += " AND LEFT(ZAB_NUMSER,2) = '1"+_cAno+"' "
			cQuery += " AND SUBSTRING(ZAB_NUMSER,9,1) = '"+_cMes+"' "
			cQuery += " AND D_E_L_E_T_ <> '*' "

			TcQuery cQuery New Alias "QUERY"
			dbSelectArea("QUERY")
			QUERY->(dbGoTop())

			_nSerial := 0
			While !Eof() 
				_nSerial := Val(SubStr(QUERY->NUMSER,3,6))

				dbSkip()
			EndDo
			dbCloseArea()

			For _nX:=1 to _nQtdOP

				Sleep(500)				
				_nSerial ++ 
				_cNumSer := "1" + _cAno + StrZero(_nSerial,6) + _cMes

				If ZAB->(MSSeek(xFILIAL("ZAB")+ _cNumSer))
					MsgStop("Problemas na geração do Número de Série, entre em contato com o TI - "+ _cNumSer,"Atenção")
					_lErro := .T.
				Else

					MsgStop("Número de Série Gerado ! "+_cNumSer, "Atenção")

					Reclock("ZAB",.T.)
					ZAB->ZAB_FILIAL := xFilial("ZAB")
					ZAB->ZAB_NUMSER	:= _cNumSer
					ZAB->ZAB_CODPRO	:= SC2->C2_PRODUTO
					ZAB->ZAB_NUMOP	:= SC2->C2_NUM 
					ZAB->ZAB_ITEMOP	:= SC2->C2_ITEM
					ZAB->ZAB_SEQOP	:= SC2->C2_SEQUEN
					ZAB->(MsUnlock())
				
					DBSelectArea("SX6")
					GetMV("AM_NUMSER")
					//PutSX6("AM_NUMSER",lltrim(STR(_nSerial)))

					RecLock("SX6",.F.)
					SX6->X6_CONTEUD := Alltrim(STR(_nSerial))
					MsUnlock()
				EndIf
			Next _nX
			
			If !_lErro
				MsgInfo("Número(s) de Série gerado(s) com sucesso!","Número de Série")	
			EndIf
		Endif
	Endif
EndIf

Return
