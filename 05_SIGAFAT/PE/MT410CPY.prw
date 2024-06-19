USER FUNCTION MT410CPY()

//+-------------------------------------------------------------+
//| Ponto de entrada na cópia do pedido.                        |
//| nas operações de simples faturamento é necessário zerar     |
//| os descontos do cabeçalho do pedido de vendas sem processar |
//| os descontos para não alterar o valor do pedido de vendas.  |
//+-------------------------------------------------------------+

Local lRet := .T.

M->C5_DESC1 	:= 0
M->C5_DESC2 	:= 0
M->C5_DESC3 	:= 0
M->C5_DESC4 	:= 0
M->C5_XSTSFIN	:= "1"
M->C5_XPCONPG	:= 70

//M->C5_XSTSFIN  := IIF(SC5->C5_CLIENTE == '002953' .Or. SC5->C5_CLIENTE == '000001','2','1')
M->C5_XSTSFIN  := IIF(SC5->C5_CLIENTE == AllTrim(GetMv("AM_CLIMCD") ),'2','1')

RETURN lRet
