/*/
�����������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������Ŀ��
���Programa  � MTULTNFE  � Autor � Marcos Rocha                   � Data � 10/09/2023 ���
�������������������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para Colocar a Observacao de Beneficiamento           ���
���            na consulta historico NF no Pedido de Compras.                         ���
�������������������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Acos Macom                                                  ���
��������������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������*/
User Function MTULTNFE()

Local aArea    := GetArea()
Local aAreaSD1 := SD1->(GetArea())
Local nProc
Local aDados     := PARAMIXB
Local aNotas     := aDados[1]
Local aRecSD1    := aDados[2]
Local cCfopBenef := AllTrim(GetMv("MV_XCFOBEN"))

For nProc := 1 To Len(aNotas)

	dbSelectArea("SD1")
	dbGoto(aRecSD1[nProc])
	If AllTrim(SD1->D1_CF) $ cCfopBenef  
    	aNotas[nProc,5] := "BENEF. : "+aNotas[nProc,5]
	EndIf
Next

RestArea(aAreaSD1)
RestArea(aArea)

Return({aNotas,nil})
