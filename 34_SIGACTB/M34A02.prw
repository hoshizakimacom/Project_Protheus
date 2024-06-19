#INCLUDE "PROTHEUS.CH"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  M34A02  �Autor  ��der Fonseca Moraes�    Data: 04/01/2023	���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fun��o para cadastrar Departamentos				            ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � ACOM MACOM                                                 ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

User Function M34A02()

	//Local cPerg	:= "RFATA001" // Pergunta sempre deve ter o nome da rotina para que seja simples buscala na SX1
	Private cCadastro 	:= "Cadastro de Departamentos" 

	Private cDelFunc	:= ".T." 
	Private cString 	:= "SZB"


	//------------------------------------------------------------------+
	// Monta um aRotina. 												|
	// Menus de Ação na tela											|
	// Utilizando a função padrão AxCadastro							|
	//------------------------------------------------------------------+
	Private aRotina := { {"Pesquisar", "AxPesqui",0,1},; 
						 {"Visualizar","AxVisual",0,2} ,;
						 {"Incluir","AxInclui",0,3} ,;
						 {"Alterar","AxAltera",0,4} ,;
						 {"Excluir","AxExclui",0,5}}
						
	//--------------------------------------+
	//Selecionando a tabela a ser utilizada |
	//--------------------------------------+
	dbSelectArea("SZB")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse(6,1,22,75,cString)

Return
