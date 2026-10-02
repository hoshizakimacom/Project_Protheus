#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} EMP650

Ponto de entrada na geracao dos empenhos 

@author Marcos Antonio Montes
@since 01/10/2026
@return Nil Nulo
/*/

User Function EMP650()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local nPCod     := aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})
Local nPDelet   := IIF(LEN(aCols)>0,LEN(aCols[1]),0)
Local nProc     := 0
Local cComp     := ""

For nProc := 1 To Len(aCols)

    cComp := aCols[nProc,nPCod]

    If POSICIONE("SB1",1,xFilial("SB1")+cComp,"B1_TIPO") $ "MF/" //Nào empenho produto tipo MF
        aCols[nProc,nPDelet] := .T.
    EndIf

Next

RestArea(aAreaSB1)
RestArea(aArea)

Return Nil
