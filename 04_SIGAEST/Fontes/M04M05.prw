#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M04M05 � Autor � Marcos Rocha         � Data � 04/11/2023  ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para alterar os parametros solicitados              ���
�������������������������������������������������������������������������͹��
���Uso       � ACOS MACOM	    		                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M04M05()

Local aCampos := {}

Aadd(aCampos,{"MV_DATAFIN","Data Limite Financeiro:","99/99/99"})
Aadd(aCampos,{"MV_DATAFIS","Data Limite Fiscal:"	,"99/99/99"})
Aadd(aCampos,{"MV_DBLQMOV","Data de Bloqueio de Estoque","99/99/99"}) 

AltMv(aCampos,"Parametros de Datas de Fechamento")   

Return     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Funcao ALTMV                                               ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
Static Function ALTMV(aCampos,cTitulo)

Local _n
Private aParam 	:= {}

cTitulo 		:= If(cTitulo = Nil, "Alteracao de Parametros",cTitulo)

//�������������������������������������������������������������������������Ŀ
//� Valida o array                                                          �
//���������������������������������������������������������������������������
If Len(aCampos) == 0
	Aviso("Atencao !","Par�metros a serem alterados n�o informados !",{"Ok"})
	Return
EndIf

//�������������������������������������������������������������������������Ŀ
//� Monta macro dos titulos a serem exibidos                                �
//���������������������������������������������������������������������������
For _n := 1 To Len(aCampos)
	Aadd(aParam,{aCampos[_n,1],aCampos[_n,2],GetMv(aCampos[_n,1])})
Next

//�������������������������������������������������������������������������Ŀ
//� Monta a tela dos parametros                                             �
//���������������������������������������������������������������������������
@ 250,050 To 420,500 Dialog oDlgMV Title AllTrim(cTitulo)

@ 0.5,0.5 ListBox oListBox VAR cListBox Fields HEADER  "Par�metro","Descri��o","Conte�do" Size 190,75
oListBox:SetArray(aParam)
oListBox:bLine  	:= {||{aParam[oListBox:nAt,1],aParam[oListBox:nAt,2],aParam[oListBox:nAt,3]}}
oListBox:blDblClick := {|| cConTemp := aParam[oListBox:nAt,3], MsgGet( "Altera��o de Par�metros", "Informe o conte�do do par�metro "+aParam[oListBox:nAt,1]+":", @cConTemp, aCampos[oListBox:nAt,3]), aParam[oListBox:nAt,3] := cConTemp}

@ 010,200 BmpButton Type 01 Action U_GravaPar()
@ 025,200 BmpButton Type 02 Action Close(oDlgMV)

Activate Dialog oDlgMV Centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GRAVAPAR                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
User Function GRAVAPAR() 

Local _n

For _n := 1 to Len(aParam)

	If ValType(aParam[_n,3]) == "C"
		PutMv(aParam[_n,1],AllTrim(aParam[_n,3]))
	ElseIf ValType(aParam[_n,3]) == "N"
		PutMv(aParam[_n,1],AllTrim(Str(aParam[_n,3])))
	ElseIf ValType(aParam[_n,3]) == "D"
		PutMv(aParam[_n,1],AllTrim(Dtoc(aParam[_n,3])))
	EndIf
	
//	If aParam[_n,1] == "MV_DATAFIN"
//		dDataZZ4 := aParam[_n,3]
//	Endif

Next  

Close(oDlgMV)

Return
       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Funcao estilo msg com Get                                  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
Static Function MsgGet( cTitle, cText, uVar, cPict )

Local oDlg
Local uTemp 	:= uVar
Local lOk   	:= .f.

Default cText 	:= ""

Define Dialog oDlg From 10, 20 to 18, 59.5 Title cTitle

@ 0.6, 2 Say cText OF oDlg Size 250, 10
@ 1.6, 2 Get uTemp Size 120, 12 OF oDlg Picture cPict

@ 3.5,  5 Button "&Ok"  OF oDlg Size 35, 12 Action ( oDlg:End(), lOk := .t. ) Default
@ 3.5, 15 Button "&Cancel" OF oDlg Size 35, 12 Action ( oDlg:End(), lOk := .f. )

Activate Dialog oDlg Centered

If lOk
	uVar := uTemp
EndIf

Return lOk
