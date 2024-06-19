#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------------------------------
//  PREENCHE NOME DO APROVADOR
//  USO : SCR 
//+------------------------------------------------------------------------------------------------------------------------

User Function WFW120P()

    Local aArea := GetArea()
    Local cNome := POSICIONE("SAK",1,XFILIAL("SAK")+SCR->CR_APROV,"AK_NOME")                                                                           
    Local cDoc  := SCR->CR_NUM
     
     //Copia nome do aprovador do pedido para a tabela SCR
     dbSelectArea("SCR")
     dbsetorder(2) //six - CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
     dbseek(xfilial("SCR") + "PC" + cDoc)
     if found()
          RecLock("SCR",.F.)
          SCR->CR_XNAPRV := cNome
          SCR->(MsUnLock())
          
      endif
    RestArea(aArea)
Return
