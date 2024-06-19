#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120LOK  บAutor ณ Renan Camargo        บ Data ณ  08/02/24  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada - Acerta Descri็ใo da Condicao de Pagto   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Macom                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT120LOK()

Local nPosDtEnt    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_DATPRF'})
Local nPosItem     := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
Local nPosQuant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_QUANT'})
Local nPosCond     := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XDESCPG'})
local nQtJaEnt     := 0
Local lRetorno     := .T.

// Atualiza Descrica da Condicao de Pagamento
aCols[n][nPosCond] := Posicione("SE4",1,xFilial("SE4")+cCondicao,"E4_DESCRI")

IF aCols[n][nPosDtEnt] < dDataBase .And. !aCols[n][Len(aHeader)+1]  // Ignota Deletados
    If ALTERA 
        nQtJaEnt     := Posicione("SC7",1,xFilial("SC7")+cA120Num+aCols[n][nPosItem],"C7_QUJE")
    EndIF

    If nQtJaEnt < aCols[n][nPosQuant] // Item Com Saldo a atender
        MsgAlert ("Data de entrega nใo pode ser inferior a Data Base","Aten็ใo")
        lRetorno      := .F.
    EndIF
    
EndIF

Return lRetorno
