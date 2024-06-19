#INCLUDE "PROTHEUS.CH"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  � M34A01  �Autor  ��der Fonseca Moraes�    Data: 02/01/2023  ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Cadastro de Buget e importa��o de csv			            ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � ACOS MACOM                                                 ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

User Function M34A01()

	Private cCadastro 	:= "Cadastro de Budget" 

	Private cDelFunc	:= ".T." 
	Private cAlias 	:= "SZA"
	Private  _cArqCsv
	Private  _aLinhas
	Private	 cFile		:= ""
	Private cEnd		:= "C:\Windows\Temp\"
	Private cDtHr 		:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
	Private cNomeLog	:=	"Logbudget"+cDtHr+"_Log.txt"
	Private cArq		:=	cEnd+cNomeLog
	Private _cLinha


	//------------------------------------------------------------------+
	// Monta um aRotina. 												|
	// Menus de Ação na tela											|
	// Utilizando a função padrão AxCadastro							|
	//------------------------------------------------------------------+
	Private aRotina := { {"Pesquisar", "AxPesqui",0,1},; 
						 {"Visualizar","AxVisual",0,2} ,;
						 {"Incluir","AxInclui",0,3} ,;
						 {"Alterar","AxAltera",0,4} ,;
						 {"Excluir","AxDeleta",0,5} ,;
						 {"Import .CSV","u_IMPCSV",0,3}}
						
	//--------------------------------------+
	//Selecionando a tabela a ser utilizada |
	//--------------------------------------+
	dbSelectArea("SZA")
	dbSetOrder(1)

	dbSelectArea(cAlias)
	mBrowse(6,1,22,75,cAlias)


Return


//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �IMPCSV  �Autor  ��der Fonseca Moraes�    Data:   02/01/2023 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fun��o IMPCSV .csv na tabela SZA	    		            ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � ACOS MACOM                                                 ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

User Function IMPCSV()

	Local lOk 	:= .T.
	Local cArq 	:= ""
	
	cArq := GetPlan() 
	
	If !Empty(cArq)
	
		If MsgYesNo( "Deseja mesmo importar a planilha?", "Aten��o!" )
		
			MsgRun("Processando","Importa��o da planilha",{|| Processa(cArq) })	
			
		Else
			lOk := .F.	
		EndIf
		
	Else
		lOk := .F.	
	EndIf
	
Return lOk

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �GetPlan  �Autor  ��der Fonseca Moraes�    Data: 02/01/2023	���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fun��o busca arquivo .csv no diret�rio    		            ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � ACOS MACOM                                                 ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

Static Function GetPlan()
	
	Local cCadastro	:= "Budget"
	Local cArq		:= ""
	Local nOpca		:= 0
	
	Local aSays		:= {}
	Local aButtons	:= {}
	
	aAdd(aSays, "Esta rotina tem por objetivo efetuar a importa��o ")
	aAdd(aSays, "de arquivo .csv de Budget")
	
	aAdd(aButtons, { 14,.T.,{|| cArq 	:= cGetFile("Arquivo CSV (*.csv) | *.csv|", "",,,.f., GETF_LOCALHARD+GETF_NETWORKDRIVE,.f., .T.)}} )
	aAdd(aButtons, { 1,.T. ,{|| nOpca   := 1, FechaBatch() 																				}} )
	aAdd(aButtons, { 2,.T. ,{|| FechaBatch() 																							}} )
	
	FormBatch( cCadastro, aSays, aButtons)
	
	If nOpca == 1
		
		If Empty(cArq)			
			Alert("Arquivo inv�lido!.",FunName())		
		EndIf
			
    Else
    	Alert(" Importa��o cancelada")
    EndIf
		
Return cArq 

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �Processa  �Autor  ��der Fonseca Moraes�    Data: 02/01/2023	���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fun��o Processa .csv na tabela SZA			                ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � ACOS MACOM                                                 ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

Static Function Processa(cArq)

	Local lOk 	 := .T.
	Local nTdoc	 := 0
	
	Local nLinha := 0
		
	Local aLinha := {}
	
	Local cLinha := "" 
	Local cErro  := ""
	
	Default cArq 	:= ""
		
	If !Empty(cArq)
	
		nTdoc := FT_FUse(cArq) //funcao que abre um arquivo
		
		If nTdoc = -1
			lOk := .F.	
		Else
				
				FT_FGOTOP()
				
				While !FT_FEOF()
					
					If nLinha == 0 //pular cabe�alho
						FT_FSKIP()	
					EndIf

					aLinha := {}
					
					cLinha := FT_FREADLN()
					nLinha ++
					
					aLinha := StrTokArr2(cLinha,";",.T.)

					If !ImpDados(aLinha)
						cErro += AllTrim(Str(nLinha)) + Chr(13) + Chr(10)
					EndIf
	
					FT_FSKIP()	
				EndDo

			FClose(nTdoc)
		EndIf	
		
	Else
		lOk := .F.
	EndIf
	
	Alert ("Planilha importada com sucesso!")
	//Alert ("Linhas com erros e/ou nao impressas:" + MostraErro(cErro))
	
Return lOk

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ImpDados �Autor  ��der Fonseca Moraes�    Data:  14/02/2019	���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fun��o Importa dados							            ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � Prox	                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
Static Function ImpDados(aLinha)

	

	Local lRet 	:= .T.
	Local nTotal := Val(aLinha[4])
	Local nJan	 := Val(aLinha[5])
	Local nFev	 := Val(aLinha[6])
	Local nMar	 := Val(aLinha[7])
	Local nAbr	 := Val(aLinha[8])
	Local nMai	 := Val(aLinha[9])
	Local nJun	 := Val(aLinha[10])
	Local nJul	 := Val(aLinha[11])
	Local nAgo	 := Val(aLinha[12])
	Local nSet	 := Val(aLinha[13])
	Local nOut	 := Val(aLinha[14])
	Local nNov	 := Val(aLinha[15])
	Local nDez	 := Val(aLinha[16])

	Local lseek := ""
	
	Default aLinha := {}
	
	If Len(aLinha) >= 0 //.And. Len(aLinha) = 16 //se tiver o ; 

		SZA->(DbSetOrder(1))
		lseek := SZA->(DbSeek(xFilial("SZA") + Padr(aLinha[2],TamSX3("ZA_CCUSTO")[1]) + Padr(aLinha[3],TamSX3("ZA_CONTAB")[1]) + Padr(aLinha[1],TamSX3("ZA_ANOBUDT")[1])))

		IF lseek

			Reclock("SZA",.F.)
			SZA->ZA_BUDTOTA		:= nTotal
			SZA->ZA_VALJANE		:= nJan
			SZA->ZA_VALFEVE		:= nFev
			SZA->ZA_VALMARC		:= nMar
			SZA->ZA_VALABRI		:= nAbr
			SZA->ZA_VALMAIO		:= nMai
			SZA->ZA_VALJUNH		:= nJun
			SZA->ZA_VALJULH		:= nJul
			SZA->ZA_VALAGOS		:= nAgo
			SZA->ZA_VALSETE		:= nSet
			SZA->ZA_VALOUTU		:= nOut
			SZA->ZA_VALNOVE		:= nNov
			SZA->ZA_VALDEZE		:= nDez
			
		Else

			Reclock("SZA",.T.) 
			SZA->ZA_FILIAL		:= xFilial("SZA")
			SZA->ZA_CCUSTO		:= aLinha[2]
			SZA->ZA_CONTAB		:= aLinha[3]
			SZA->ZA_ANOBUDT 	:= aLinha[1]
			SZA->ZA_BUDTOTA		:= nTotal
			SZA->ZA_VALJANE		:= nJan
			SZA->ZA_VALFEVE		:= nFev
			SZA->ZA_VALMARC		:= nMar
			SZA->ZA_VALABRI		:= nAbr
			SZA->ZA_VALMAIO		:= nMai
			SZA->ZA_VALJUNH		:= nJun
			SZA->ZA_VALJULH		:= nJul
			SZA->ZA_VALAGOS		:= nAgo
			SZA->ZA_VALSETE		:= nSet
			SZA->ZA_VALOUTU		:= nOut
			SZA->ZA_VALNOVE		:= nNov
			SZA->ZA_VALDEZE		:= nDez

		ENDIF

		SZA->(MsUnLock())
	
	Else
		lRet := .F.
	EndIf 

Return lRet
