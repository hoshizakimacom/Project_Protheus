#INCLUDE "PROTHEUS.CH"

/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
���Programa  �MATA907 �Autor  � Cleber Maldonado   � Data �  25/03/2017 ���
�����������������������������������������������������������������������͹��
���Desc.     �Cadastro de Follow Up                                     ���
�����������������������������������������������������������������������͹��
���Uso       �SIGAFIS                                                   ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
User Function M05A33()
   
Local	aCores		:= {	{'ZA9_XFUST=="1"'	,'BR_CINZA'		},;	// "Projeto Cancelado"
							{'ZA9_XFUST=="2"'	,'DISABLE'		},;	// "Projeto Perdido"
							{'ZA9_XFUST=="3"'	,'ENABLE'   	},;	// "Projeto em Andamento"
							{'ZA9_XFUST=="4"'	,'BR_AZUL'   	} }	// "Substitu�do"

Private cCadastro	:= "Registro Follow Up"
Private aRotina		:= MenuDef()

dbSelectArea("ZA9")
ZA9->(dbsetorder(1))

mBrowse( 6, 1,22,75,"ZA9",,,,,,aCores)

ZA9->(dbCloseArea())

Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �01/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()
     
Private aRotina := {	{"Pesquisar"	,"AxPesqui"		, 0 , 1, 0,.F.},;          
						{ "Visualizar" 	,"AxVisual"		, 0 , 2, 0,NIL},;          
						{ "Incluir" 	,"U_M5A33Inc"	, 0 , 3, 0,NIL},;        
						{ "Alterar" 	,"U_M5A33Alt"	, 0 , 4, 2,NIL},;     
						{ "Excluir" 	,"U_M5A33Del"	, 0 , 5, 0,NIL},;
						{ "Legenda"		,"U_M5A33Leg"	, 0 , 6, 0,NIL} }  

Return(aRotina)

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33INC �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Efetua a inclus�o do registro de follow up.               ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33Inc()

Local nGravou	:= 0 
Local cAlias	:= "ZA9"
Private nOpc		:= 1
Private nReg		:= ZA9->(recno())

Private cCadastro	:= "Registro Follow Up"

If IsInCallStack("MATA415")
	If SCJ->CJ_STATUS <> "A" .AND. SCJ->CJ_STATUS <> "D"
		Aviso("ATEN��O","Esse or�amento n�o est� em aberto. O cadastro de Follow Up � reservado para Or�amentos em aberto.",{"OK"})
		Return
	Endif
Endif

Begin Transaction
	nGravou := 	AxInclui(cAlias,,,,,,/*"U_M5A33ChkInc()"*/)
	End Transaction

	If nGravou == 1 .And. ZA9->ZA9_XFUST <> "3"
	dbSelectArea("SCJ")
	dbSetOrder(1)
	If MsSeek(xFilial("SCJ")+ZA9->ZA9_XNUMOR)
		Reclock("SCJ",.F.)
		SCJ->CJ_STATUS := "C"
		MsUnlock()
		Aviso("ATEN��O","Or�amento cancelado!",{"OK"})
	Else
		Aviso("ATEN��O","Or�amento n�o encontrado!",{"OK"})
	Endif
Endif

Return
/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33ALT �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Efetua a altera��o do registro de follow up.              ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33Alt()
Local nAltera	:= 0
Local nOpc	 	:= 4
Local cAlias 	:= "ZA9"
Local nReg	 	:= ZA9->(recno())

Private cCadastro	:= "Registro Follow Up"

Begin Transaction
	nAltera := AxAltera( cAlias, nReg, nOpc,,,,,/*'U_M5A33ChkInc()'*/)
End Transaction

If nAltera == 1 .And. ZA9->ZA9_XFUST <> "3"
	dbSelectArea("SCJ")
	dbSetOrder(1)
	If MsSeek(xFilial("SCJ")+ZA9->ZA9_XNUMOR)
		Reclock("SCJ",.F.)
		SCJ->CJ_STATUS := "C"
		MsUnlock()
		Aviso("ATEN��O","Or�amento cancelado!",{"OK"})
	Else
		Aviso("ATEN��O","Or�amento n�o encontrado!",{"OK"})
	Endif
Endif
	
Return(.T.)

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33DEL �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Efetua a exclus�o do registro de follow up.               ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33Del()

Local cAlias	:= "ZA9"
Local nOpc		:= 5
Local nDeleta	:= 0
Private nRet		:= 0
Private nReg		:= ZA9->(Recno())

Private	cCadastro	:= "Registro de Follow Up"

nDeleta := AxDeleta(cAlias,nReg,nOpc)

/*If nDeleta == 2
	nRet := Aviso("ATEN��O","Deseja  restaurar  o  status  do  or�amento? ",{"Aberto","Aprovado","N�o Or�ado","N�o Restaura"})
	If nRet <> 5
		dbSelectArea("SCJ")
		dbSetOrder(1)
		If MsSeek(xFilial("SCJ")+ZA9->ZA9_XNUMOR)
			Reclock("SCJ",.F.)
			If nRet == 1
				SCJ->CJ_STATUS := "A"
			ElseIf nRet == 2
				SCJ->CJ_STATUS := "B"
			ElseIf nRet == 3
				SCJ->CJ_STATUS := "D"
			Endif
			MsUnlock()
			Aviso("ATEN��O","Status do Or�amento Restaurado!",{"OK"})
		Endif
	Endif
Endif */

Return

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33LEG �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Efetua a exclus�o do registro de follow up.               ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33Leg()

Local aLegenda := {}

aAdd(aLegenda, {"BR_CINZA"  , "Projeto Cancelado" 	})
aAdd(aLegenda, {"DISABLE"	, "Projeto Perdido"   	})
aAdd(aLegenda, {"ENABLE"	, "Projeto em Andamento"})
aAdd(aLegenda, {"BR_AZUL"   , "Substitu�do"			})

BrwLegenda("Registro de Follow Up","Legenda",aLegenda)

Return .T.

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33LEG �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Efetua a exclus�o do registro de follow up.               ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/                  
User Function M5A33ChkInc()

Local lRet := .T.

dbSelectArea("ZA9")
dbSetOrder(3)

If MsSeek(xFilial("ZA9")+M->ZA9_XNUMOR+DTOS(M->ZA9_XFUFEC)+DTOS(M->ZA9_XFUULT)+M->ZA9_XFUUSR)
	Aviso("J� Gravado","Registro de Follow Up j� registrado.",{"OK"})
	lRet := .F.
Endif

Return lRet

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33LEG �Autor �Cleber Maldonado    � Data �  19/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Posiciona registro para visualiza��o de campos Virtuais   ���
��           � no Or�amento de Venda.                                    ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33POS(cCampo)

Local cRet	:= " "
Local aArea	:= GetArea()

If !INCLUI
	dbSelectArea("ZA9")
	dbSetOrder(1)

	If MsSeek(xFilial("ZA9")+SCJ->CJ_NUM)
		While ZA9->ZA9_XNUMOR == SCJ->CJ_NUM   
			If cCampo == "CJ_XFWUST"
				cRet := ZA9->ZA9_XFUST
			ElseIf cCampo == "CJ_XFWUMOT"
				cRet := ZA9->ZA9_XFUMOT
			ElseIf cCampo == "CJ_XFWUCON"
				cRet := ZA9->ZA9_XFUCON
			ElseIf cCampo == "CJ_XFWUFEC"
				cRet := ZA9->ZA9_XFUFEC
			ElseIf cCampo == "CJ_XFWUPRX"
				cRet := ZA9->ZA9_XFUPRX 
			ElseIf cCampo == "CJ_XFWUULT"
				cRet := ZA9->ZA9_XFUULT
			ElseIf cCampo == "CJ_XFWUUSR"
				cRet := USRFULLNAME(ZA9->ZA9_XFUUSR)
			ElseIf cCampo == "CJ_XFWUOBS"
				cRet := ZA9->ZA9_XFUOBS			
			Endif   
			ZA9->(dbSkip())			
		End
	Endif
Endif

RestArea(aArea)
ZA9->(dbCloseArea())

Return cRet

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Funcao    � M5A33MOT �Autor �Cleber Maldonado    � Data �  26/04/17   ���
������������������������������������������������������������������������͹��
���Desc.     � Valida a informa��o gravada no campo Status do Follow Up  ���
��           � para altera��o do status do Or�amento de Venda.           ���
������������������������������������������������������������������������͹��
���Uso       � M05A33 - Registro de Follow Up                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function M5A33ST()

Local lRet := .T.
Local nOpc := 0

If M->ZA9_XFUST <> "3"
	nOpc := Aviso("ATEN��O","Ao selecionar as op��es: Projeto Cancelado, Perdido ou Substitu�do, o or�amento ser� cancelado! Deseja Continuar?",{"Sim","N�o"})
Endif

If nOpc == 2
	lRet := .F.
Endif

Return lRet
