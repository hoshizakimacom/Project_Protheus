#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A952CONT  �Autor  �Denyse Telles       � Data �14/08/2024   ���
�������������������������������������������������������������������������͹��
���Desc.     �Contabiliza o credito do IPI na rotina de Apuracao          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Hoshizaki Macom                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

If ExistBlock("A952CONT")
aApuIPI:= FisApur(cImp,nAno,nMes,nApuracao,nPeriodo,cNrLivro,.F.,aApuIPI,nMoedTit,.F.,"")
Execblock("A952CONT",.F.,.F.,aApuIPI)
EndIf

*/

User Function A952CONT

Local lContab  :=(mv_par09==1)
Local aDados   := ParamIXB
Local cProgram	:= "MATA952"
Local nPos        := 0

Private VALOR006  := 0
Private VALOR013  := 0


nPos := aScan ( aDados , {|x| x[1]=="006" })
If nPos >= 0
   VALOR006 := aDados[nPos,3]
EndIf

nPos := aScan ( aDados , {|x| x[1]=="013" })
If nPos >= 0
   VALOR013 := aDados[nPos,3]
EndIf



If lContab
	//����������������������������������������Ŀ
	//� Efetua Lancamento Contabil             �
	//������������������������������������������	
	Begin Transaction
	If lContab
		LancCont("720",cProgram,lContab)
	Endif
	End Transaction
EndIf

Return
