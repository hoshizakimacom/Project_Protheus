#Include "Protheus.ch"

User Function MT093VCR()

Local aArea    := GetArea() 
Local aAreaSBT := SBT->(GetArea())
Local cID      := PARAMIXB[1] //ID da fórmula (BQ_ID).
Local cCaract  := PARAMIXB[2] //Código da característica informada.
Local nProcRegra
Local lRet := .T. //Retorno do ponto de entrada.

//MsgStop("MT093VCR")

dbSelectArea("SBT")
dbSetOrder(1)
cBT_IDC1 := Space(Len(SBT->BT_IDC1))

If dbSeek(xFilial("SBT")+SBP->BP_BASE+cBT_IDC1+cId+cCaract)

//    MsgStop("Achou Regra "+SBT->BT_REGRA)
    cRegra := SBT->BT_REGRA

    If !Empty(cRegra)

//        cIdRegra := SubStr(cRegra,2,3)
//        cVarCpo  := "M->_"+a093IdRec(SBP->BP_BASE,cIdRegra)
//        cExecRegra := cVarCpo+SubStr(cRegra,5)
//        lExecRegra:= &cExecRegra 
//"@002 == "M" .or. @002 == "I"  "

        aTrocas := {}
        cRegra2 := cRegra

        For nProcRegra := 1 To 10

            If "@0" $ cRegra2
                nPosIni := At("@0",cRegra2)
                cReferen := SubStr(cRegra2,nPosIni,4)
                cTroca   := "M->_"+a093IdRec(SBP->BP_BASE,SubStr(cReferen,2,3))
                cRegra2  := SubStr(cRegra2,nPosIni+4)  // Corta a posicao já tratada 

                nPosRegr := Ascan(aTrocas,{|x,y|x[1] = cReferen})  
                If nPosRegr == 0
                    Aadd(aTrocas,{cReferen,cTroca})
                EndIf
            Else
                Exit
            EndIf
        Next

        cExecRegra := cRegra
        For nProcRegra := 1 To Len(aTrocas)
            cExecRegra := StrTran(cExecRegra,aTrocas[nProcRegra,1],aTrocas[nProcRegra,2])
        Next

        lExecRegra:= &cExecRegra 

        If !lExecRegra
            //cRegraHelp := ""
            //nPosIni := At("@0",cRegra)
            //If nPosIni <> 0 
            //    cRegraHelp := SubStr(cRegra,nPosIni)
            //EndIf
            lRet := .F.
            Help( ,, 'Help',, "Característica '"+cCaract+"' não pode ser utilizada para - Verificar Regra : "+cRegra , 1, 0 )
        EndIf
    EndIf

EndIf

//If AllTrim(cId) == "2" .And. AllTrim(cCaract) == "0000VERDE"

RestArea(aAreaSBT)
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³a093IdRec ³ Autor ³ Andre Anjos		    ³ Data ³ 10/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Transforma um ID de caracteristica no seu Recno		  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA093                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a093IdRec(cBase,cId)

Local aArea := GetArea()
Local cRet := 0
Local aAreaBQ := SBQ->(GetArea())

dbSelectArea("SBQ")
dbSetOrder(2)
dbSeek(xFilial("SBQ")+cBase+cId)
cRet := Right(AllTrim(Str(SBQ->(Recno()))),9)

RestArea(aAreaBQ)
RestArea(aArea)

Return cRet
