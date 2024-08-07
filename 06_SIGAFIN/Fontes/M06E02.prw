#Include "PROTHEUS.Ch"
#include "TOPCONN.Ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M06E01   ³ Autor ³ Marcos Rocha          ³ Data ³ 07/08/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Status do pedido de Venda                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// Numero Pedido
User Function M06E02(cPedido)

Local aArea    := GetArea()
Local cRetorno := ""
Local cQuery  := ""

If !Empty(SE1->E1_PEDIDO)

    cRetorno := "Encerrado"

    cQuery  := "SELECT SUM(C6_QTDVEN) QTDVEN, SUM(C6_QTDVEN - C6_QTDENT) SALDO "
    cQuery  += " FROM " + RetSqlName("SC6") + " "
    cQuery  += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
    cQuery  += " AND C6_NUM = '"+SE1->E1_PEDIDO+"'"
    cQuery  += " AND C6_BLQ <> 'R' "
    cQuery  += " AND D_E_L_E_T_ = '' "

    TCQUERY cQuery NEW ALIAS "TRBSC6"

    dbSelectArea("TRBSC6")
    TRBSC6->(DbGoTop())

    While TRBSC6->(!eof())
        If TRBSC6->SALDO > 0 .And. TRBSC6->SALDO <> TRBSC6->QTDVEN
            cRetorno := "Atend.Parcial"
        ElseIf TRBSC6->SALDO == TRBSC6->QTDVEN
            cRetorno := "Aberto"
        EndIf
        TRBSC6->(DbSkip())
    Enddo
    TRBSC6->(dbCloseArea())

EndIf

RestArea(aArea)

Return cRetorno
