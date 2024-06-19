#INCLUDE "PROTHEUS.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  M34A03  บAutor  ณษder Fonseca Moraesบ    Data: 04/01/2023	บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณUsuแrio X Departamentos				            			บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ ACOM MACOM                                                 บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function M34A03()

	Private cCadastro 	:= "Usuแrio X Departamentos" 

	Private cDelFunc	:= ".T." 
	Private cString 	:= "SZC"


	//------------------------------------------------------------------+
	// Monta um aRotina. 												|
	// Menus de Aรงรฃo na tela											|
	// Utilizando a funรงรฃo padrรฃo AxCadastro							|
	//------------------------------------------------------------------+
	Private aRotina := { {"Pesquisar", "AxPesqui",0,1},; 
						 {"Visualizar","AxVisual",0,2} ,;
						 {"Incluir","AxInclui",0,3} ,;
						 {"Alterar","AxAltera",0,4} ,;
						 {"Excluir","AxExclui",0,5}}
						
	//--------------------------------------+
	//Selecionando a tabela a ser utilizada |
	//--------------------------------------+
	dbSelectArea("SZC")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse(6,1,22,75,cString)

Return
