User Function RskFinGrv()

Local aRet := PARAMIXB


If Len(aRet) >=2 

    If ( aRet[1] =='SE1'.and. Alltrim(aRet[2]) $'INCTITSUPP') // Validação  do evento

        AADD(aRet[3], {"E1_XBNDES" ,"2" ,Nil})
// Inclusão do campo customizado.

    EndIf

EndIf

 

RETURN aRet
