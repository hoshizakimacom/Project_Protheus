#include"topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA330MOD  �Autor  �Marcos Rocha        � Data �  30/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o saldo do centro de custo de MOD                   ���
�������������������������������������������������������������������������͹��
���Uso       � Macom                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA330MOD()

//��������������������������������������������������������������������������������Ŀ
//�Declaracao de variaveis                                                         �
//����������������������������������������������������������������������������������
PRIVATE lCusUnif := GetMV("MV_CUSFIL",.F.) // Identifica qdo utiliza custo por Filial

//��������������������������������������������������������������Ŀ
//� Quantidade do produto nesse armazem                          �
//����������������������������������������������������������������
DbSelectArea("ZAH")
DbSetOrder(1)
DbSeek(xFilial("ZAH")+Left(Dtos(ddatabase),6),.F.)
While !Eof() .And. ZAH->ZAH_FILIAL+ZAH->ZAH_ANOMES == xFilial("ZAH")+Left(Dtos(ddatabase),6)

	cCodAtu := ZAH->ZAH_CODMOD
	cLocEst := "01"
//	nQtdMOD := ZAH->ZAH_QUANT
	nQtdMOD := 0
	mCstMod := ZAH->ZAH_VALOR

	//Busca a Quantidade de requisi��es do Mes para preencher o SB2 e  rateio ficar correto 
	cQry := " SELECT D3_COD CODMOD, SUM(D3_QUANT) QTD_REQ_OP "
	cQry += " FROM "+RetSqlName("SD3")+" SD3 "
	cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQry += " AND D3_EMISSAO BETWEEN '"+Dtos(FirstDay(dDataBase))+"' AND '"+Dtos(LastDay(dDataBase))+"'"
	cQry += " AND D3_COD = '"+cCodAtu+"'"
	cQry += " AND D3_OP <>  ' '   "
	cQry += " AND D3_CF IN ('RE0','RE1') "
	cQry += " AND SD3.D_E_L_E_T_ <> '*'
	cQry += " GROUP BY D3_COD "

	If Select("TRB_SD3") > 0
		dbSelectArea("TRB_SD3")
		dbCloseArea()
	EndIf
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)

	dbSelectArea("TRB_SD3")
	TRB_SD3->(dbGoTop())

	While TRB_SD3->(!Eof())
		nQtdMOD += TRB_SD3->QTD_REQ_OP
		dbSkip()
	EndDo

	If Select("TRB_SD3") > 0
		dbSelectArea("TRB_SD3")
		dbCloseArea()
	EndIf

	DbSelectArea("SB2")
	DbSetOrder(1)
//	DbSeek(xFilial("SB2")+cCodAtu+cLocEst,.F.)
//	While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL == xFilial("SB2")+cCodAtu+cLocEst
	DbSeek(xFilial("SB2")+cCodAtu,.F.)
	While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD == xFilial("SB2")+cCodAtu

		DbSelectArea("SB2")
		RecLock("SB2",.F.)
		SB2->B2_VFIM1  := mCstMod
		SB2->B2_QFIM   := nQtdMOD
		SB2->B2_CM1    := mCstMod/Abs(nQtdMOD)
		SB2->B2_CMFIM1 := mCstMod/Abs(nQtdMOD)
		MsUnlock()

		TTFimComMO({SB2->B2_VFIM1,SB2->B2_VFIM2,SB2->B2_VFIM3,SB2->B2_VFIM4,SB2->B2_VFIM5})
		TTFimQtdMO()
		
		DbSelectArea("SB2")
		DbSkip()
	EndDo

	dbSelectArea("ZAH")
	dbSkip()
EndDo

//MsgStop("MA330MOD - FIM")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TTFimComMO� Autor �Rodrigo de A. Sartorio � Data � 13/11/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o saldo final do TRT (VFIM) baseado no val. da MOD���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TTFimComMO(ExpA1)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os custos da MOD                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TTFimComMO(aCusto)

LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
LOCAL aArea:=GetArea()
IF lCusUnif == "F"  // Filial

	//�������������������������������������������������������Ŀ
	//� Posiciona no local a ser atualizado                   �
	//���������������������������������������������������������
	dbSelectArea("TRT")
   If !dbSeek(cFilAnt+SB2->B2_COD)
      CriaTRT(cFilAnt,SB2->B2_COD)
	EndIf
	RecLock("TRT",.F.)
	//�������������������������������������������������������Ŀ
	//� Pega o custo do campo e soma o custo da entrada       �
	//���������������������������������������������������������
	If aCusto <> NIL
		//�������������������������������������������������������Ŀ
		//� Pega o custo do campo e soma o custo da entrada       �
		//���������������������������������������������������������
		For nX := 1 to 5
			aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX)) + aCusto[nX]
		Next nX
	EndIf
	Replace TRB_VFIM1 With aVFim[01]
	Replace TRB_VFIM2 With aVFim[02]
	Replace TRB_VFIM3 With aVFim[03]
	Replace TRB_VFIM4 With aVFim[04]
	Replace TRB_VFIM5 With aVFim[05]
	MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TTFimQtdMO� Autor �Rodrigo de A. Sartorio � Data � 13/11/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza a quantidade final do TRT baseado nos movimentos  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TTFimQtdMO()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA330                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TTFimQtdMO()
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
LOCAL aArea:=GetArea()

IF lCusUnif == "F"  // Filial

	//�������������������������������������������������������Ŀ
	//� Posiciona no local a ser atualizado                   �
	//���������������������������������������������������������
	dbSelectArea("TRT")
   If !dbSeek(cFilAnt+SB2->B2_COD)
      CriaTRT(cFilAnt,SB2->B2_COD)
	EndIf
	RecLock("TRT",.F.)
	Replace TRB_QFIM  With TRB_QFIM + SB2->B2_QFIM
	aCM[01] := TRB_CM1
	aCM[02] := TRB_CM2
	aCM[03] := TRB_CM3
	aCM[04] := TRB_CM4
	aCM[05] := TRB_CM5
	For nX := 1 to 5
		//�������������������������������������������������������Ŀ
		//� Pega o custo final do campo correto                   �
		//���������������������������������������������������������
		aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX))
		aCM[nX]   := aVFIM[nX]/ABS(TRB_QFIM)
	Next nX
	Replace TRB_CM1 With aCM[01]
	Replace TRB_CM2 With aCM[02]
	Replace TRB_CM3 With aCM[03]
	Replace TRB_CM4 With aCM[04]
	Replace TRB_CM5 With aCM[05]
	MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)

Return
