#Include "Totvs.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ M185GRV³ Autor ³ Moovegestao             ³ Data ³ 25/04/25 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Atualiza campo D3_DOC para os movimentos de req. de SA     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Macom                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M185GRV()

Local aArea    := GetArea()
Local cLocProc := GETMV("MV_LOCPROC",.F.,"99")
Local cEndProc := GETMV("MV_ENDPROC",.F.,"")

Reclock("SD3",.F.)
SD3->D3_DOC := "SA"+SCP->CP_NUM
SD3->(MsUnlock())

dbSelectArea("SDA")
dbsetOrder(1)

If SDA->(DbSeek(xFilial("SDA")+SD3->D3_COD+cLocProc+SD3->D3_NUMSEQ))
    
	RecLock("SDA",.F.)
    SDA->DA_DOC := SD3->D3_DOC
    MsUnlock()

    dbSelectArea("SB2")
    dbSetorder(1)
    dbSeek(xFilial("SB2")+SD3->D3_COD+cLocProc)
    dbSelectArea("SD3")

    A100DISTRI(SD3->D3_COD,cLocProc,SD3->D3_NUMSEQ,SD3->D3_DOC,,,,cEndProc,,SD3->D3_QUANT,SD3->D3_LOTECTL,SD3->D3_NUMLOTE)

EndIf

RestArea(aArea)

Return

/*
#INCLUDE "TBICONN.CH"
User Function M185TST()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SDA","SD3","SG1"

dbSelectArea("SCP")
dbGoTo(5255)

dbSelectArea("SD3")
dbGoTo(3844318)

U_M185GRV()

RESET ENVIRONMENT 

Return Nil
*/
