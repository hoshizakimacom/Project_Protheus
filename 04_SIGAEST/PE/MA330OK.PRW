#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA330OK  �Autor  � Marcos Rocha       � Data � 22/05/2024  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para acerto da apropria��o de Custo       ���
���          � de OPS com Requisic�o ou Apontamento Parcial               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Macom                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA330OK()

//������������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                                      �
//��������������������������������������������������������������������������������
Local aArea	:= GetArea()
Local lRet  := .T.

If a330ParamZX[1] > LastDay(dInicio)
   Aviso("ATEN��O","Data de processamento superior ao ultima dia do mes subsequente ao ultimo fechamento! Verifique os parametros.",{"Ok"},,"Data Inv�lida!")
   lRet := .F.
EndIf

//MsgStop("Inicio do Ponto de Entrada MA330OK - Atualiza��o D3_RATEIO ! ")

//MV_PRODPR0 == '2'  - Usa a Proporcao de Rateio do Campo D3_RATEIO  

//����������������������������������������������������������������������������������������Ŀ
//�Realiza Query para calcular os rateios subentendendo que tudo � requisitado de uma vez. �
//������������������������������������������������������������������������������������������

cQry := " SELECT OP, D3_EMISSAO, RECSD3, QUANT_PROD, QTD_OP, QTD_PROD_MES_ANT, QTD_PROD_MES, "+CRLF
cQry += " (CASE WHEN QUANT_PROD >= QTD_OP THEN 100 "+CRLF
cQry += " WHEN QTD_PROD_MES >= QTD_OP THEN (QUANT_PROD / QTD_PROD_MES) * 100 "+CRLF
cQry += " WHEN (QTD_PROD_MES_ANT + QTD_PROD_MES) >= QTD_OP THEN (QUANT_PROD / QTD_PROD_MES) * 100 "+CRLF
cQry += "  ELSE (QUANT_PROD / QTD_OP) * 100 END ) RATEIO "+CRLF
cQry += " FROM ( "+CRLF

cQry += " SELECT D3_OP OP, D3_EMISSAO, R_E_C_N_O_ RECSD3, D3_QUANT QUANT_PROD, "+CRLF

cQry += " ISNULL((SELECT MAX(C2_QUANT) "+CRLF
cQry += "	   FROM "+RetSqlName("SC2")+" SC2 "+CRLF
cQry += "	   WHERE SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF 
cQry += "	   AND C2_NUM+C2_ITEM+C2_SEQUEN = LEFT(D3_OP,11) "+CRLF
cQry += "	   AND SC2.D_E_L_E_T_ <> '*' ),0) QTD_OP, "+CRLF

cQry += " ISNULL((SELECT SUM(D3_QUANT) "+CRLF
cQry += "     FROM "+RetSqlName("SD3")+" SD32 "+CRLF
cQry += "        WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
cQry += "        AND SD32.D3_OP = SD3.D3_OP "+CRLF
cQry += "        AND SD32.D3_EMISSAO < '"+Dtos(Firstday(a330ParamZX[1]))+"' "+CRLF
cQry += "        AND SD32.D3_CF IN ('PR0','PR1') "+CRLF
cQry += "		  AND SD32.D3_ESTORNO <> 'S'  "+CRLF
cQry += "        AND SD32.D_E_L_E_T_ <> '*' ),0) QTD_PROD_MES_ANT, "+CRLF

cQry += " ISNULL((SELECT SUM(D3_QUANT) "+CRLF
cQry += " FROM "+RetSqlName("SD3")+" SD32 "+CRLF
cQry += "        WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
cQry += "        AND SD32.D3_OP = SD3.D3_OP "+CRLF
cQry += "        AND SD32.D3_EMISSAO BETWEEN '"+Dtos(Firstday(a330ParamZX[1]))+"' AND '"+Dtos(LASTDAY(a330ParamZX[1]))+"' "+CRLF
cQry += "		  AND SD32.D3_ESTORNO<>'S' "+CRLF
cQry += "        AND SD32.D3_CF IN ('PR0','PR1') "+CRLF
cQry += "        AND SD32.D_E_L_E_T_ <> '*' ),0) QTD_PROD_MES"+CRLF

cQry += " FROM "+RetSqlName("SD3")+" SD3" +CRLF
cQry += " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
cQry += " AND SD3.D3_ESTORNO <> 'S' "+CRLF
cQry += " AND SUBSTRING(SD3.D3_CF,1,2)='PR' "+CRLF
cQry += " AND SD3.D3_EMISSAO BETWEEN '"+Dtos(Firstday(a330ParamZX[1]))+"' AND '"+Dtos(LASTDAY(a330ParamZX[1]))+"'"
cQry += " AND SD3.D_E_L_E_T_ <> '*' ) TAB "+CRLF
cQry += " ORDER BY OP "+CRLF

//�����������������������������������������������Ŀ
//�Verifica se o UPDATE foi realizado.            �
//�������������������������������������������������
If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)

dbSelectArea("TRB_SD3")
TRB_SD3->(dbGoTop())

While TRB_SD3->(!Eof())

   nRateio := TRB_SD3->RATEIO

/*/
   If TRB_SD3->QUANT_PROD >= TRB_SD3->QTD_OP  // Quantidade Apontada for o total da OP
      nRateio := 100

   ElseIf TRB_SD3->QTD_PROD_MES >= TRB_SD3->QTD_OP  // Quantidade Total produzida no m�s, mas em varios apontamentos
      nRateio := (TRB_SD3->QUANT_PROD / TRB_SD3->QTD_PROD_MES) * 100

   ElseIf TRB_SD3->QTD_PROD_MES_ANT + TRB_SD3->QTD_PROD_MES >= QTD_OP  // Soma do mes anterior + Atual fecha a qtd 
      nRateio := (TRB_SD3->QUANT_PROD / TRB_SD3->QTD_PROD_MES) * 100

   Else      // Apropria Parcial - Total da Op x Apontado
      nRateio := (TRB_SD3->QUANT_PROD / TRB_SD3->QTD_OP) * 100

   EndIf
/*/

   //��������������������������������������Ŀ
   //� Atualiza campo D3_RATEIO.            �
   //����������������������������������������
   SD3->(dbGoto(TRB_SD3->RECSD3))
   RecLock("SD3",.F.)
   SD3->D3_RATEIO := nRateio
   MsunLock()
   
   dbSelectArea("TRB_SD3")
	dbSkip()
EndDo

If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf

//MsgStop("Final do Ponto de Entrada MA330OK - Atualiza��o D3_RATEIO ! ")

RestArea(aArea)

Return lRet
