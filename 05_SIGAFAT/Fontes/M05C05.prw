#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#include "Fileio.ch"

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ M05C05   ³ Autor ³ Cleber Maldonado      ³ Data ³ 20/03/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtro para consulta padrão. Retorna somente os contatos   ³±±
±±³          ³ relacionados ao cliente informado no pedido de vendas.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Campo C5_XCONT                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M05C05()

Local _cFiltro      := ''
Local _cCodCont		:= ''
Local _cAliasCont   := GetNextAlias()
Local _cChave		:= M->CJ_CLIENTE+M->CJ_LOJA

BeginSql Alias _cAliasCont
	SELECT 
		AC8_FILIAL,AC8_FILENT,AC8_ENTIDA,AC8_CODENT,AC8_CODCON
	FROM
		%Table:AC8% AC8
	WHERE
		AC8_CODENT = %Exp:_cChave% AND
		AC8.%NotDel%
EndSql

While (_cAliasCont)->(!EOF())	

	_cCodCont    += "'" + (_cAliasCont)->(AC8_CODCON) + "',"
	
	(_cAliasCont)->(DbSkip())
	 
End

_cFiltro	:= "@U5_CODCONT IN (" + _cCodCont + "' ')"  		
	
Return _cFiltro
