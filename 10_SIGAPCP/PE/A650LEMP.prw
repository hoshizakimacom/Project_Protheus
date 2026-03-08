#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
 
User Function A650LEMP()

//Local aLinCol   := aClone(PARAMIXB)  //Conteudo da linha do aCols possicionado
//Local cRetLocal := aLinCol[3]        //Verifca se o produto é 'MP' e o Armazém é '87' altera conteúdo para '20'
//Local cTipo     := Posicione('SB1',1,xFilial('SB1')+aLinCol[1],'B1_TIPO') //Busca o contúedo do campo B1_TIPO
 
//If cTipo == 'MP' .And. (aLinCol[3] == '87')      
    cRetLocal := GetMv("MV_LOCPROC")   //'99'
//EndIf
 
Return cRetLocal
