#Include "Protheus.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   � MT461VCT  � Autor � Cleber Maldonado      � Data �05.07.2018	���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para altera��o do vencimento dos t�tulos.	���
���������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array de t�tulos.                                    	���
���������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      	���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function MT461VCT()

Local nX := 0 
Local aParamIXB := PARAMIXB[1]

// Devido os PVA's serem gerados baseados no pedido de vendas, no ato do 
// faturamento, algumas parcelas j� foram pagas, dessa forma o faturamento
// da NF-e 4.0 n�o permite datas de vencimento anteriores a emiss�o da nota fiscal
// sendo necess�rio efetuar o ajuste do vencimento dos t�tulos j� pagos.

For nX := 1 to Len(aParamIXB)
	If aParamIXB[nX,1] < dDataBase
		aParamIXB[nX,1] := dDataBase
	Endif
EndFor

Return aParamIXB  