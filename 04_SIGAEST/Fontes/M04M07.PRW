#include "Protheus.Ch"
#include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M04M07    �Autor  �Marcos Rocha	     � Data �  17/01/23   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Requisicao de Mao de Obra no SD3 conforme o custo     ���
���          � dos itens requisitados .                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Macom 		                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M04M07()

Private d_DataRf 		:= ''
Private c_Perg       := 'M04M07'
Private c_TipoMO 		:= ''
Private c_TM    	 	:= ''
Private n_QuantBase	:= 0
Private n_QuantG1   	:= 0

//��������������������������������������������������������������Ŀ
//� Guarda parametros necessarios p/ o processamento.            �
//����������������������������������������������������������������
d_DataRf := GetMv("MV_ULMES")
c_TipoMO := "MO"

MsgStop("Rotina fora de uso")

Return

ValidPerg()
If !Pergunte(c_Perg, .T.)
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Valida data inicial informada no parametro                   �
//����������������������������������������������������������������
While MV_PAR01 < d_DataRf
	msgAlert("A data inicial n�o pode ser menor que a do �ltimo fechamento " + DtoC(d_DataRf), "Aten��o")
	If !Pergunte(c_Perg, .T.)
		Return
	EndIf
EndDo

//��������������������������������������������������������������Ŀ
//� Valida data final informada no parametro                     �
//����������������������������������������������������������������
While MV_PAR01 > MV_PAR02
	msgAlert("A data final n�o pode ser menor que a inicial.", "Aten��o")
	If !Pergunte(c_Perg, .T.)
		Return
	EndIf
EndDo

c_TM  := mv_par03

//��������������������������������������������������������������������������������������Ŀ
//�Cancela as Movimentacoes de MODs Geradas                                              �
//����������������������������������������������������������������������������������������
Processa({||DelMODs()},"Excluindo poss�veis movimentos gerados !!!")

Processa({||GeraMOD()},"Gerando Movimentos de Requisi��o de MOD !")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraMOD   �Autor  �                    � Data �  01/29/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera as movimentacoes das MODs.                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraMOD()   // MOD da estrutura mesmo
 
local cEOL	  := Chr(10)+Chr(13)
Local cQry	  := " "
//Local nProc
Local nCstTot := 0

// Busca o Custo total dos materiais das OP's
/*/
cQry := "SELECT SUM(D3_CUSTO1) CSTTOT "+cEOL
cQry += " FROM "+RetSqlName("SD3")+" SD3 "+cEOL
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D3_OP <> ' ' AND SUBSTRING(D3_CF,1,2)='PR' AND D3_ESTORNO<>'S' "+cEOL
cQry += " AND D_E_L_E_T_ <> '*' "+cEOL
If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)
dbSelectArea("TRB_SD3")
TRB_SD3->(dbGoTop())

ProcRegua(2)

While TRB_SD3->(!Eof())

	IncProc("Calculando Custo Total OPS...")

	nCstTot += TRB_SD3->CSTTOT

	dbSelectArea("TRB_SD3")
	TRB_SD3->(dbSkip())
EndDo
/*/

//MsgStop("CUSTO TOTAL DAS OPS..."+Transform(nCstTot,"@E 999,999,999.9999"))

// Busca as produ��es
cQry := "SELECT D3_FILIAL, D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ,SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1, "+cEOL

cQry += "  ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) "
cQry += "    FROM "+RetSqlName("SD3")+" SD32 "
cQry += "    WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQry += "    AND SD32.D3_OP = SD3.D3_OP"
cQry += "    AND LEFT(SD32.D3_COD,3) <> 'MO-'" // MENOS MOD
cQry += "    AND SD32.D3_EMISSAO <= '"+Dtos(FirstDay(MV_PAR01)-1)+"' " 
cQry += "    AND SD32.D3_CF IN ('RE0','RE1','DE0','DE1')" 
cQry += "    AND SD32.D_E_L_E_T_ <> '*' ),0) CSTREQANT, "

cQry += "  ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) "
cQry += "    FROM "+RetSqlName("SD3")+" SD32 "
cQry += "    WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQry += "    AND SD32.D3_OP = SD3.D3_OP"
cQry += "    AND LEFT(SD32.D3_COD,3) = 'MO-'" // SO MOD
cQry += "    AND SD32.D3_EMISSAO <= '"+Dtos(FirstDay(MV_PAR01)-1)+"' " 
cQry += "    AND SD32.D3_CF IN ('RE0','RE1','DE0','DE1')" 
cQry += "    AND SD32.D_E_L_E_T_ <> '*' ),0) REQMODANT, "

cQry += "  ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) "
cQry += "    FROM "+RetSqlName("SD3")+" SD32 "
cQry += "    WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQry += "    AND SD32.D3_OP = SD3.D3_OP"
cQry += "    AND SD32.D3_EMISSAO <= '"+Dtos(MV_PAR02)+"' " 
cQry += "    AND SD32.D3_TM = '503' "
cQry += "    AND SD32.D_E_L_E_T_ <> '*' ),0) CSTRETRAB, "

cQry += "  ISNULL((SELECT SUM( (CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END)) "
cQry += "    FROM "+RetSqlName("SD3")+" SD32 "
cQry += "    WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQry += "    AND SD32.D3_OP = SD3.D3_OP"
cQry += "    AND SD32.D3_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " 
cQry += "    AND LEFT(SD32.D3_COD,3) <> 'MO-'" // MENOS MOD
cQry += "    AND SD32.D3_CF IN ('RE0','RE1','DE0','DE1')" 
cQry += "    AND SD32.D_E_L_E_T_ <> '*' ),0) CSTREQMES, "

cQry += " ISNULL((SELECT SUM(D3_CUSTO1) "
cQry += "  FROM "+RetSqlName("SD3")+" SD32 "
cQry += "  WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' "
cQry += "  AND SD32.D3_OP = SD3.D3_OP "
cQry += "  AND SD32.D3_EMISSAO <= '"+Dtos(FirstDay(MV_PAR01)-1)+"' " // MES ANTERIOR
cQry += "  AND SD32.D3_CF IN ('PR0','PR1') "
cQry += "  AND SD32.D_E_L_E_T_ <> '*' ),0) CSTPRODANT, "

cQry += " ISNULL((SELECT SUM(D3_QUANT) "
cQry += "  FROM "+RetSqlName("SD3")+" SD32 "
cQry += "  WHERE SD32.D3_FILIAL = '"+xFilial("SD3")+"' "
cQry += "  AND SD32.D3_OP = SD3.D3_OP "
cQry += "  AND SD32.D3_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " 
cQry += "  AND SD32.D3_CF IN ('PR0','PR1') "
cQry += "  AND SD32.D_E_L_E_T_ <> '*' ),0) QTDPRODMES "

cQry += " FROM "+RetSqlName("SD3")+" SD3 "+cEOL
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D3_OP <> ' ' AND SUBSTRING(D3_CF,1,2)='PR' AND D3_ESTORNO<>'S' "+cEOL

// Testes t
//cQry += " AND D3_OP = '14891210001' "+cEOL

cQry += " AND D_E_L_E_T_ <> '*' "+cEOL
cQry += " GROUP BY D3_FILIAL,D3_COD, D3_TIPO, D3_EMISSAO, D3_NUMSEQ, D3_OP, D3_DOC "+cEOL
cQry += " ORDER BY D3_FILIAL,D3_COD"+cEOL
If Select("TRB_SD3") > 0
	dbSelectArea("TRB_SD3")
	dbCloseArea()
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_SD3", .F., .T.)
dbSelectArea("TRB_SD3")
TRB_SD3->(dbGoTop())

ProcRegua(1000)

nQtdMod := 0
nCstTot := 0

While TRB_SD3->(!Eof())

	IncProc("Incluindo MOD's Filial: "+TRB_SD3->D3_FILIAL)

	dbSelectArea("SB1")
	dbSetOrder(1)
	If !MsSeek(xFilial("SB1")+TRB_SD3->D3_COD) .Or. TRB_SD3->CSTRETRAB > 0 // Ignorar OP de Retrabalho
		dbSelectArea("TRB_SD3")
		TRB_SD3->(dbSkip())
		Loop
	EndIf

	nQtdMod ++

//	nCstOp := TRB_SD3->D3_COD
	cProduto := "MO-GERAL"
	nCstRat  := TRB_SD3->CSTREQANT + TRB_SD3->CSTREQMES - (TRB_SD3->CSTPRODANT-TRB_SD3->REQMODANT) 
	nCstTot  += nCstRat
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)

	dbSelectArea("SD3")
	RecLock("SD3",.T.)
	SD3->D3_FILIAL   := xFilial("SD3")
	SD3->D3_CF		:= 'RE0'
	SD3->D3_TM		:= c_TM
	SD3->D3_EMISSAO	:= Stod(TRB_SD3->D3_EMISSAO)
	SD3->D3_COD     := SB1->B1_COD
//	SD3->D3_QUANT   := TRB_SD3->D3_CUSTO1 / 1000 
	SD3->D3_QUANT   := (nCstRat / TRB_SD3->QTDPRODMES) * TRB_SD3->D3_QUANT 
	SD3->D3_DOC     := TRB_SD3->D3_DOC
	SD3->D3_UM		:= SB1->B1_UM
	SD3->D3_SEGUM	:= SB1->B1_SEGUM
	SD3->D3_TIPO	:= SB1->B1_TIPO
	SD3->D3_LOCAL	:= SB1->B1_LOCPAD
	SD3->D3_CC		:= SB1->B1_CC
	SD3->D3_CONTA	:= SB1->B1_CONTA
	SD3->D3_GRUPO	:= SB1->B1_GRUPO
	SD3->D3_CHAVE	:= 'E0'
	SD3->D3_NUMSEQ	:= TRB_SD3->D3_NUMSEQ
	SD3->D3_OP		:= TRB_SD3->D3_OP
	SD3->D3_USUARIO	:= Alltrim(cUsername)
	MsUnLock()
		
	//��������������������������������������������������������������������������Ŀ
	//�Cria o SB2 se ele nao existir                                             �
	//����������������������������������������������������������������������������
	CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD) //U_CriaSB2Esp(SB1->B1_COD,SB1->B1_LOCPAD)

	dbSelectArea("TRB_SD3")
	TRB_SD3->(dbSkip())
EndDo

MsgStop("Criado(s) Movimentos de MOD para "+Transform(nQtdMod,"@E 999,999,999")+;
" OPs - Custo Req. menos Prod. Total R$ "+Transform(nCstTot,"@E 999,999,999"))

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelMODs   �Autor  �                    � Data �  01/29/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cancela possiveis movimentacoes geradas p/ o intervalo     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
'�����������������������������������������������������������������������������
*/
Static Function DelMODs()

Local cEOL	:= Chr(10)+Chr(13)
Local cQry	:= " "

cQry := "SELECT R_E_C_N_O_ RECNO1 FROM "+RetSqlName("SD3")
cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"+cEOL
cQry += " AND LEFT(D3_COD,3) IN ('MO-') "+cEOL
cQry += " AND D3_TIPO = '"+c_TipoMO+"'"+cEOL
cQry += " AND D3_TM = '"+c_TM+"' "+cEOL
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"+cEOL
cQry += " AND D_E_L_E_T_ <> '*' "+cEOL

If Select("TRB_DEL") > 0
	DbSelectArea("TRB_DEL")
	DbCloseArea()
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB_DEL", .F., .T.)
DbSelectArea("TRB_DEL")
TRB_DEL->(DbGotop())

ProcRegua(1000)

While TRB_DEL->(!EOF())
	SD3->(DbGoto(TRB_DEL->RECNO1))
	IncProc("Deletando MOD's. filial:"+SD3->D3_FILIAL)

	RecLock("SD3",.F.)
	DbDelete()
	MsUnLock()
	
	TRB_DEL->(DbSkip())
EndDo

If Select("TRB_DEL") > 0
	DbSelectArea("TRB_DEL")
	DbCloseArea()
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �ValidPerg � Autor � 				     � Data �  25/06/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

//              Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
aAdd(aRegs,{c_Perg,"01"  ,"Data de              ?",""      ,""     ,"MV_CH1","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"02"  ,"Data ate             ?",""      ,""     ,"MV_CH2","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{c_Perg,"03"  ,"Tipo de Movimento    ?",""      ,""     ,"MV_CH3","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         ,""      ,""      ,""   ,""         ,""             ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf	
Next

dbSelectArea(_sAlias)

Return Nil
