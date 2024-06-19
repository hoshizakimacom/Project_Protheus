//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zOpcoes
Função para retornar uma lista de opções em um campo combo
@author Cleber Maldonado
@since 12/06/2021
@version 1.0
@type function
/*/
 
User Function M10G01()
Local aArea   := GetArea()
Local cOpcoes := ""
 
//Montando as opcoes de retorno
cOpcoes += "1=Opcao 1;"
cOpcoes += "2=Opcao 2;"
cOpcoes += "3=Opcao 3;"
cOpcoes += "4=Opcao 4;"
cOpcoes += "5=Opcao 5;"
cOpcoes += "6=Opcao 6;"
cOpcoes += "7=Opcao 7;"
cOpcoes += "8=Opcao 8;"
cOpcoes += "9=Opcao 9;"
cOpcoes += "0=Opcao 0;"
cOpcoes += "A=Opcao A;"
cOpcoes += "B=Opcao B;"
cOpcoes += "C=Opcao C;"
cOpcoes += "D=Opcao D;"
cOpcoes += "E=Opcao E;"
cOpcoes += "F=Opcao F;"
cOpcoes += "G=Opcao G;"
 
RestArea(aArea)
Return cOpcoes
