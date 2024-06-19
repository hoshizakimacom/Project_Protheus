#Include 'Protheus.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06A04   � Autor � Cleber Maldonado      � Data � 01/08/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua baixa manual da comiss�o.                           ���
���          � Esse programa efetua a baixa da comiss�o gravando o campo  ���
���          � E3_DATA. Na presente data, n�o existe integra��o com o     ���
���          � contas a pagar. Caso venha a existir a integra��o este     ���
���          � programa dever� ser ajustado para efetuar a baixa no t�tulo���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M06A05()

Local _lOpc			:= 0

_lOpc	:= MSGYESNO("Deseja efetuar a baixa da comiss�o ?","Baixa Manual da Comiss�o" )

If _lOpc
	RecLock("SE3",.F.)
	SE3->E3_DATA := dDataBase
	MsUnlock()
Endif

Return