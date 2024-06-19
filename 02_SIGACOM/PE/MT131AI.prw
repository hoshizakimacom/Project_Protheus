#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function MT131AI()
Local aItem := {}
//Local cNumSc
//Local cItSc  

//cNumSc := Posicione("SC8",1,xFilial("SC8")+SC8->C8_NUM,"C8_NUMSC")    // Será retornado em projeto futuro
//cItSc  := Posicione("SC8",1,xFilial("SC8")+SC8->C8_NUM,"C8_ITEMSC")   // Será retornado em projeto futuro

//aADD(aItem,{'It.cNumSc'     ,cNumSc})          // Numero da SC
//aaDD(aItem,{'It.cItSc'      ,cItSc})           // Item da SC 
aADD(aItem,{'It.cCodPro'    ,SB1->B1_COD})     // Código do Produto #4288
aADD(aItem,{'It.cUm'        ,SB1->B1_UM})      // Unidade de Medida #4288

//aAAD(aItem,{'It.cDtPrev'   ,SC1->C1_DATPRF}) // Data Prevista (Solicitada no comento da elaboração da Solicitação)

return aItem
