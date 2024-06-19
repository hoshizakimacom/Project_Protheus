User Function MT103IPC()

Local _nItem := PARAMIXB[1]
Local _nPosCod := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local _nPosDes := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_XDESCR"})
Local _nPosNCM := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_TEC"})
Local _nOrigem := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_XORIGEM"})
Local _nTipo   := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_TP"})

    If _nPosCod > 0 .And. _nItem > 0
        aCols[_nItem,_nPosDes] := Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,_nPosCod],"B1_DESC")
        aCols[_nItem,_nPosNCM] := Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,_nPosCod],"B1_POSIPI")
        aCols[_nItem,_nOrigem] := Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,_nPosCod],"B1_ORIGEM")
        aCols[_nItem,_nTipo]   := Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,_nPosCod],"B1_TIPO")

    Endif
    
Return
