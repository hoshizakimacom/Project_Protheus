#INCLUDE 'PROTHEUS.CH'
#Include 'Parmtype.ch'
#Include 'TopConn.ch'

#DEFINE ENTER Chr(13)+Chr(10)

/*-----------------------------------------------------------------------------------------------------------
PROGRAMA: M04R10.PRW
DESCRIÇÃO: RELATÓRIO DE MOVIMENTAÇÃO INTERNA SD3
AUTOR: ÉDER FONSECA MORAES 
VEPTO SOLICITANTE: ACOS MACOM
DATA: 19/11/2022

Verificar o saldo antes do dia 07/03, verificar o ajuste de inventario feito no dia 07/03
realizar o calculo de ambos
gerar um excel com os campos:
FILIAL COD.PRODUTO DESCR.PRODUTO ARMAZEM SALDO DATA
-----------------------------------------------------------------------------------------------------------*/
//----FUNÇÃO PRINCIPAL
USER FUNCTION M04R03() 
    
    Local cPerg   := Padr("M04R10",10)

	//Inclui/Altera as perguntas na tabela SX1
	AjustaSX1(cPerg)

	//chama o pergunte para a impressão do relatório
	Pergunte(cPerg,.T.)

	PROCESSA({|| RUNEXCEL() }, "Gerando Excel (Movimentos Internos - Benq)...")

RETURN()

//----FUNÇÃO RESPONSÁVEL PELA CRIAÇÃO DO ARQUIVO EXCEL
STATIC FUNCTION RUNEXCEL()

	Local cQuery := ""
	Local nX := 0
	Local aStruTMP := {}
	Local cCampos := 'EMISSAO|FILIAL|ARMAZEM|PRODUTO|NOME|ARMAZEM|DATA_SALDO|SALDO|TIPO_MOVIMENTO|DOCUMENTO|QTD'
	local aItens := {}
	Private aXLSCabec := {}
	Private aXLSItens := {}

    cQuery := " SELECT "
	cQuery += ENTER + " (substring(D3_EMISSAO,7,2) + '/' + substring(D3_EMISSAO,5,2) + '/' + substring(D3_EMISSAO,1,4)) EMISSAO, "
	cQuery += ENTER + " D3_FILIAL FILIAL, "
	cQuery += ENTER + " D3_LOCAL ARMAZEM, "
	cQuery += ENTER + " D3_COD PRODUTO, "
	cQuery += ENTER + " B1_DESC NOME, "
	cQuery += ENTER + " (substring(B9_DATA,7,2) + '/' + substring(B9_DATA,5,2) + '/' + substring(B9_DATA,1,4)) DATA_SALDO, "
	cQuery += ENTER + " B9_VINI1 SALDO, "
	cQuery += ENTER + " D3_TM TIPO_MOVIMENTO, "
	cQuery += ENTER + " D3_DOC DOCUMENTO, "
	cQuery += ENTER + " D3_QUANT QTD "
    cQuery += ENTER + " FROM "
    cQuery += ENTER + " SD3010 D3 (NOLOCK) "
	cQuery += ENTER + " INNER JOIN SB1010 ON B1_COD = D3_COD "
	cQuery += ENTER + " INNER JOIN SB9010 ON B9_FILIAL = D3_FILIAL AND B9_COD = D3_COD AND B9_LOCAL = D3_LOCAL "
    cQuery += ENTER + " WHERE D3.D_E_L_E_T_='' and D3_TM IN ('999','499') "
	cQuery += ENTER + " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND  '"+DTOS(mv_par02)+"' "
	cQuery += ENTER + " AND D3_COD BETWEEN '"+mv_par03+"' AND  '"+mv_par04+"' "
	cQuery += ENTER + " AND D3_LOCAL BETWEEN '"+mv_par05+"' AND  '"+mv_par06+"' "
	cQuery += ENTER + " AND B9_DATA = '"+DTOS(mv_par07)+"' "
	cQuery += ENTER + " ORDER BY FILIAL, PRODUTO "


	IF SELECT("TMP") > 0
		TMP->(DbCloseArea())
	ENDIF
	MEMOWRITE( "C:\MICROSIGA\M04R10.SQL", cQuery )
	
	Conout("M04R10 (SQL): " + cQuery)

	processa({|| DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.) }, "Selecionando Dados para o Excel...")

	aStruTMP := TMP->( DBStruct() )

	DbSelectArea("TMP")
	DbGoTop()

	While !TMP->(Eof())

		aItens := Array(Len(aStruTMP))

		For nX := 01 To len(aStruTMP)

			If alltrim(aStruTMP[nX][01]) $ cCampos
				aItens[nX] := AllToChar(TMP->&( aStruTMP[nX][01] )) //DtoC(Stod(TMP->&( aStruTMP[nX][01] )))
			Else
				aItens[nX] := TMP->&( aStruTMP[nX][01] )
			Endif

		Next nX

		aAdd( aXLSItens, aItens )

		TMP->( DbSkip() )

	End

    for nX:= 01 to Len(aStruTMP)

		aAdd(aXLSCabec, aStruTMP[nX][01])	

	Next nX

	TMP->(DbCloseArea())
	
	If len(aXLSItens) > 0
		gExcel(aXLSCabec, aXLSItens)
	Else
		Alert("Não foram encontrados dados com os Parametros informados!!!")
	EndIf

Return()

Static Function gExcel(aXLSCabec, aXLSItens)

	Local oFWMsExcelEx
	Local oExcel
	local aItens   := {}
	local cAba     := "Dados"
	Local cTabela  := " "
	Local cHora    := Time()
	Local cArquivo := GetTempPath()+'MOV_INTERNOS_MACOM'+AllTrim(StrTran(cHora,":",""))+'_.xml'
	Local nX		:= 0
	Local nY		:= 0

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcelEx := FWMSExcelEx():New()
	cTabela:= "Movimentos Internos MACOM"

	//Aba 01 - Teste
	oFWMsExcelEx:AddworkSheet(cAba) //Não utilizar número junto com sinal de menos. Ex.: 1-
	//Criando a Tabela
	oFWMsExcelEx:AddTable(cAba, cTabela)

	for nX := 01 to len(aXLSCabec)
		oFWMsExcelEx:AddColumn(cAba, cTabela, aXLSCabec[nX] ,1,1,.F.)
	next nX

	for nX := 01 to len(aXLSItens)

		aItens := Array(len(aXLSItens[nX]))

		for nY := 01 to len(aXLSItens[nX])
			aItens[nY] := aXLSItens[nX][nY]
		next nY

		oFWMsExcelEx:AddRow(cAba, cTabela, aItens)

	next nY

	//Ativando o arquivo e gerando o xml
	oFWMsExcelEx:Activate()
	oFWMsExcelEx:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) //Abre uma planilha
	oExcel:SetVisible(.T.) //Visualiza a planilha
	oExcel:Destroy() //Encerra o processo do gerenciador de tarefas

Return()

//----FUNÇÃO DE CRIAÇÃO DE PERGUNTAS
Static Function AjustaSx1(cPerg)

	Local aRegs := {}
	Local nX    := 0
	Local nY    := 0

	//A função aAdd adiciona um novo elemento no final do array
	aAdd(aRegs,{cPerg,"01","Data De?"       ,"","","mv_ch1" ,"D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data Até?"      ,"","","mv_ch2" ,"D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Produto De?"    ,"","","mv_ch3" ,"C",15,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Produto Até?"   ,"","","mv_ch4" ,"C",15,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Armazem De?"    ,"","","mv_ch5" ,"C",02,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Armazem Até?"   ,"","","mv_ch6" ,"C",02,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Saldo na data?" ,"","","mv_ch7" ,"D",08,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))

	For nX := 1 To Len(aRegs)

		If !DbSeek(cPerg + aRegs[nX,7])

			RecLock("SX1",.T.)

			For nY := 1 To FCount()

				If nY <= Len(aRegs[nX])
					FieldPut(nY,aRegs[nX,nY])
				EndIf

			Next nY

			MsUnlock()

		EndIf

	Next nX

Return
