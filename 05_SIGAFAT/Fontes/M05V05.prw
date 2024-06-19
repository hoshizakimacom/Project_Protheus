#Include 'Protheus.ch'

//+-----------+--------------------------------------------------------+------------+
//|  M05V05   |                    AÇOS MACOM                          | 30/03/2017 |
//+-----------+--------------------------------------------------------+------------+
//|                  Função de validação da alteração de NCM.                       |
//|                                                                                 |
//| Objetivo : Não permitir alteração do código NCM caso o produto já for faturado. |
//|                                                                                 |
//+---------------------------------------------------------------------------------+
//| Uso : Genérico - Cadastro de Produtos.                                          |
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
		Aviso("Atenção!","Este  NCM  já  foi  utilizado  em  produto  já  faturado. Alteração  não  permitida! ",{"OK"})
	Endif
Endif
Return lRet
