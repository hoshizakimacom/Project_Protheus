#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------------------------------
//  PE que habilita campos na atualização dos Ativos Imobilizados
//+--------------------------------------------------------------------------------------------------------------------------------
User Function AT010SN1()
    Local aArea     := GetArea()
    Local aCposSN1  := paramixb[1]

    AAdd(aCposSN1,'N1_VLAQUIS')

    RestArea(aArea)
Return AClone(aCposSN1)