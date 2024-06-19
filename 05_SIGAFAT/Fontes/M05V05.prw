#Include 'Protheus.ch'

//+-----------+--------------------------------------------------------+------------+
//|  M05V05   |                    A�OS MACOM                          | 30/03/2017 |
//+-----------+--------------------------------------------------------+------------+
//|                  Fun��o de valida��o da altera��o de NCM.                       |
//|                                                                                 |
//| Objetivo : N�o permitir altera��o do c�digo NCM caso o produto j� for faturado. |
//|                                                                                 |
//+---------------------------------------------------------------------------------+
//| Uso : Gen�rico - Cadastro de Produtos.                                          |
//+---------------------------------------------------------------------------------+

User Function M05V05()

Local lRet := .T.
Local cProduto := M->B1_COD

If ALTERA
	dbSelectArea("SD2")
	dbSetOrder(1)

	If MsSeek(xFilial("SD2")+cProduto)
		lRet := .F.
	Endif

	If !lRet
		Aviso("Aten��o!","Este  NCM  j�  foi  utilizado  em  produto  j�  faturado. Altera��o  n�o  permitida! ",{"OK"})
	Endif
Endif
Return lRet
