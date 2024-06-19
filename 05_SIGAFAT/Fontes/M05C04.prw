#Include 'Protheus.ch'

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M05C04   � Autor � Cleber Maldonado      � Data � 20/03/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtro para consulta padr�o. Retorna somente os contatos   ���
���          � relacionados ao cliente informado no pedido de vendas.     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � #M05C04()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Campo C5_XCONT                                             ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M05C04()

Local _cFiltro      := ''
Local _cCodCont		:= ''
Local _cAliasCont   := GetNextAlias()
Local _cChave		:= M->C5_CLIENTE+M->C5_LOJACLI

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

