#INCLUDE "MATR620.ch"
#Include "PROTHEUS.Ch"
                  
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M06E01   � Autor � Marcos Rocha          � Data � 13/11/23 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Informacoes do titulo no Rel. Relacao de Baixas    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

// Numero Pedido
User Function M06E01P(cChave)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cRetorno := ""

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+cChave)

cRetorno := SE1->E1_PEDIDO

RestArea(aAreaSE1)
RestArea(aArea)

Return cRetorno

//�������������������������������������������������������������������������Ŀ��
//�� Nome Vendedor
//�������������������������������������������������������������������������Ĵ��
User Function M06E01V(cChave)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cRetorno := ""

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+cChave)

cRetorno := Posicione("SA3",1,xFilial("SA3")+SE1->E1_VEND1,"A3_NOME")

RestArea(aAreaSE1)
RestArea(aArea)

Return cRetorno


//�������������������������������������������������������������������������Ŀ��
// Nome Gerente
//�������������������������������������������������������������������������Ĵ��
User Function M06E01G(cChave)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cRetorno := ""

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+cChave)

cCodGer  := Posicione("SA3",1,xFilial("SA3")+SE1->E1_VEND1,"A3_GEREN")
cRetorno := Posicione("SA3",1,xFilial("SA3")+cCodGer,"A3_NOME")

RestArea(aAreaSE1)
RestArea(aArea)

Return cRetorno

//�������������������������������������������������������������������������Ŀ��
// Descricao Cond Pagto
//�������������������������������������������������������������������������Ĵ��
User Function M06E01C(cChave)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cRetorno := ""

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+cChave)

cCodCond := Posicione("SC5",1,xFilial("SC5")+SE1->E1_PEDIDO,"C5_CONDPAG")
cRetorno := Posicione("SE4",1,xFilial("SE4")+cCodCond,"E4_DESCRI")

RestArea(aAreaSE1)
RestArea(aArea)

Return cRetorno

