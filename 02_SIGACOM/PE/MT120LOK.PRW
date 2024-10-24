#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor � Renan Camargo        � Data �  08/02/24  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada - Acerta Descri��o da Condicao de Pagto   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Macom                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
        MsgAlert ("Data de entrega n�o pode ser inferior a Data Base","Aten��o")
        lRetorno      := .F.
    EndIF
    
EndIF

Return lRetorno
