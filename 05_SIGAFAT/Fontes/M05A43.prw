#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} M05A43

MONITOR DE EXPEDIÇÃO

@author Marcos Antonio Montes
@since 12/03/2026
@return Nil Nulo
/*/

User Function M05A43()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			:= GetArea()
Local cFilSC9		:= ""
Local cFiltroSC9	:= ""
Local cCondicao		:= ""

Private cCadastro := OemToAnsi("MONITOR DE EXPEDIÇÃO")

Private nTempo := 30000 //10.000 milissegundos e igual a 10 segundos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa??o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina	:= MenuDef()

	dbSelectArea("SC9")
	dbSetOrder(1)
	cFilSC9	:= xFilial("SC9")

	cFiltroSC9	:= If(Empty(cFiltroSC9),".T.",cFiltroSC9)
	cCondicao	:= "C9_FILIAL=='"+cFilSC9+"'.And."
	cCondicao	+= "((C9_BLEST=='  '.And.C9_BLCRED=='  ').Or."
	cCondicao	+= "(C9_BLEST=='10'.And.C9_DATALIB=='"+DTOS(dDataBase)+"')).And."
	cCondicao	+= cFiltroSC9

    bTimer   := {|| (oBrowse:Refresh(.T.)) }
     
    //Instânciando FWMBrowse, setando a tabela, a descrição
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC9")
    oBrowse:SetDescription(cCadastro)
     
    //Filtrando os dados
    oBrowse:SetFilterDefault(cCondicao)


	/*
	oBrowse:AddLegend("C9_BLEST=='  '.And.C9_BLCRED=='  '.And.(C9_BLWMS>='05'.OR.C9_BLWMS='  ').And.Iif(SC9->((ColumnPos('C9_BLTMS') > 0)), Empty(C9_BLTMS), .T.)","ENABLE","","Item Liberado",.F.)
	oBrowse:AddLegend("C9_BLCRED == '70'",'BR_VIOLETA',"","Item bloqueado - GRR",.F.)
	oBrowse:AddLegend("C9_BLCRED == '80' .Or. C9_BLCRED == '92'",'BR_BRANCO',"","Em análise Risk - Totvs Mais Negócios",.F.)
	oBrowse:AddLegend("C9_BLCRED == '90' .Or. C9_BLCRED == '91'" ,'BR_CINZA',"","Bloqueado por regras Risk - Totvs Mais Negócios",.F.)
	oBrowse:AddLegend("(C9_BLCRED =='10' .And. C9_BLEST  == '10').Or.C9_BLCRED =='ZZ' .And. C9_BLEST  == 'ZZ'",'DISABLE',"","Item Faturado",.F.)
	oBrowse:AddLegend("!C9_BLCRED=='  '.And. C9_BLCRED <> '09'.And. C9_BLCRED <> '10'.And. C9_BLCRED <> 'ZZ'",'BR_AZUL',"","Item Bloqueado - Credito",.F.)
	oBrowse:AddLegend("!C9_BLEST =='  '.And. C9_BLCRED <> '09'.And. C9_BLEST  <> '10'.And. C9_BLEST  <> 'ZZ'",'BR_PRETO',"","Item Bloqueado - Estoque",.F.)
	oBrowse:AddLegend("C9_BLWMS <='05'  .And. !C9_BLWMS == '  '",'BR_AMARELO',"","Item Bloqueado - WMS",.F.)
	oBrowse:AddLegend("C9_BLCRED == '09' .And. C9_BLCRED <> '10'.And. C9_BLCRED <> 'ZZ'",'BR_MARROM',"","Item Rejeitado",.F.)
	oBrowse:AddLegend("Iif(SC9->((ColumnPos('C9_BLTMS') > 0)), !Empty(C9_BLTMS), .F.)"  ,'BR_LARANJA',"","Item Bloqueado - TMS",.F.)
	*/

	//FWMBrowse():AddLegend(< xCondition >, < cColor >, [< cTitle >], [< cID >], [< lFilter >])-> NIL
	oBrowse:AddLegend("C9_BLEST=='  '.And.C9_BLCRED=='  '.And.(C9_BLWMS>='05'.OR.C9_BLWMS='  ').And.Iif(SC9->((ColumnPos('C9_BLTMS') > 0)), Empty(C9_BLTMS), .T.)","ENABLE","Item Liberado","1",.T.)
	oBrowse:AddLegend("C9_BLCRED == '70'",'BR_VIOLETA',"Item bloqueado - GRR","1",.F.)
	oBrowse:AddLegend("C9_BLCRED == '80' .Or. C9_BLCRED == '92'",'BR_BRANCO',"Em análise Risk - Totvs Mais Negócios","1",.F.)
	oBrowse:AddLegend("C9_BLCRED == '90' .Or. C9_BLCRED == '91'" ,'BR_CINZA',"Bloqueado por regras Risk - Totvs Mais Negócios","1",.F.)
	oBrowse:AddLegend("(C9_BLCRED =='10' .And. C9_BLEST  == '10').Or.C9_BLCRED =='ZZ' .And. C9_BLEST  == 'ZZ'",'DISABLE',"Item Faturado","1",.T.)
	oBrowse:AddLegend("!C9_BLCRED=='  '.And. C9_BLCRED <> '09'.And. C9_BLCRED <> '10'.And. C9_BLCRED <> 'ZZ'",'BR_AZUL',"Item Bloqueado - Credito","1",.F.)
	oBrowse:AddLegend("!C9_BLEST =='  '.And. C9_BLCRED <> '09'.And. C9_BLEST  <> '10'.And. C9_BLEST  <> 'ZZ'",'BR_PRETO',"Item Bloqueado - Estoque","1",.F.)
	oBrowse:AddLegend("C9_BLWMS <='05'  .And. !C9_BLWMS == '  '",'BR_AMARELO',"Item Bloqueado - WMS","1",.F.)
	oBrowse:AddLegend("C9_BLCRED == '09' .And. C9_BLCRED <> '10'.And. C9_BLCRED <> 'ZZ'",'BR_MARROM',"Item Rejeitado","1",.F.)
	oBrowse:AddLegend("Iif(SC9->((ColumnPos('C9_BLTMS') > 0)), !Empty(C9_BLTMS), .F.)"  ,'BR_LARANJA',"Item Bloqueado - TMS","1",.F.)

	oBrowse:SetUseFilter(.T.)

	oBrowse:SetTimer(bTimer, nTempo ) // 60.000 aproximadamente 1 Minuto

    //Ativando a navegação
    oBrowse:Activate()
     
RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Montes	            ³ Data ³12/03/2026³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Private aRotina	:= {{"Prep.DOCs"      , "MATA460A",   0, 2, 0, .T.},;	
               	    {"Visualiza DOC"  , "Ma461View",  0, 2, 0, .T.},;	
               	    {"Impressão DANFE", "U_M05A43I",  0, 2, 0, .T.},;	
               	    {"Legenda"        , "A450Legend", 0, 8, 0, .F.},;	
               	    {"Pesquisar"      , "PesqBrw",    0, 1, 0, .F.}}	

Return(aRotina)

User Function M05A43I()

Local aArea      := GetArea()
Local lFErase    := .F.
Local nTimes     := 0
Local cFileDanfe := ""
Local cDrive     := ""
Local cCaminho   := ""
Local cFileName  := ""
Local cExtensao  := ""

//Aviso("Aviso","Impressão da DANFE")
//SpedDanfe()

dbSelectArea("SF2")
dbSetOrder(1)
If !EMPTY(SC9->C9_NFISCAL) .And. dbSeek(xFilial("SF2",SC9->C9_FILIAL)+SC9->C9_NFISCAL+SC9->C9_SERIENF) .And. RTRIM(SF2->F2_ESPECIE) == "SPED"

	cFileDanfe := GetDanfe(SF2->F2_FILIAL,SF2->F2_SERIE,SF2->F2_DOC)

    If !EMPTY(cFileDanfe) .And. File(cFileDanfe)
        //Copiando o arquivo do servidor para o cliente
        If CpyS2T(cFileDanfe,GetTempPath())

			cDrive    := ""
			cCaminho  := ""
			cFileName := ""
			cExtensao := ""
			SPLITPATH( cFileDanfe, @cDrive, @cCaminho, @cFileName, @cExtensao )

			ShellExecute("open",GetTempPath()+cFileName+cExtensao,"","",5) // 5=SW_SHOW

            Aviso("Visualizar","Arquivo aberto no visualizador padrão.",{"Fechar"})
            
            //Apaga arquivo após visualização
			lFErase := .F.
			nTimes := 0
			While( !lFErase .And. nTimes < 10)
				lFErase := (FERASE(GetTempPath()+cFileDanfe) <> -1)
				If(!lFErase)
					nTimes++
					Sleep(500)
				Else
					Exit
				EndIf    
			EndDo

        EndIf
    EndIf

EndIf

RestArea(aArea)

Return 


/*/{Protheus.doc} GetDANFE
    Função responsável por gerar a danfe em PDF
    @type  Function
    @author Montes
    @since 01/05/2024
    @version 12.1.2310
    @param cFilial
    @param cNota
    @return cFileDanfe
/*/
Static Function GetDANFE(cFilDoc,cSerie,cDoc)

Local aArea         := GetArea()
Local cFileDanfe    := ""
local oDanfe        := nil
local oSetup        := nil    
local cBarra        := if(isSrvUnix(),"/","\")
local cFolderFiles  := cBarra + "temp" + cBarra 
local lFile         := .F.
local lIsLoja       := .F. 
local cProg		    := iif(existBlock("DANFEProc"),"U_DANFEProc",iif(isRdmPad("DANFEProc"),"DANFEProc", ""))
Local lDanfe        := !empty(cProg)
local nTimes        := 0
local aPerg         := {}
local lExistNfe     := .F.

Local cSavFil       := cFilAnt
Local aAreaSM0      := SM0->(GetArea())

cFilAnt := cFilDoc
SM0->(dbSeek(cEmpAnt+cFilAnt))

cFileDanfe := "danfe_"+RTRIM(SM0->M0_CGC)+"_"+RTRIM(cDoc)+".pdf"

If !(lFile := FILE(cFolderFiles+cFileDanfe)) .And. !EMPTY(cDoc)

    cIdEnt := GetIdEnt()

    oDANFE := FWMSPrinter():New(cFileDanfe, IMP_PDF, .F. /*lAdjustToLegacy*/,cFolderFiles/*cPathInServer*/,.T.,/*lTReport*/,/*oPrintSetup*/,/*cPrinter*/,/*lServer*/,/*lPDFAsPNG*/,/*lRaw*/,.F.,/*nQtdCopy*/)
    oDanfe:SetResolution(78)
    oDanfe:SetPortrait()
    oDanfe:SetPaperSize(DMPAPER_A4)
    oDanfe:SetMargin(60,60,60,60)
    oDanfe:lServer := .T.
    oDanfe:nDevice := IMP_PDF
    oDanfe:cPathPDF := cFolderFiles
    oDANFE:SetCopies( 1 )
                            
    //alimenta parametros da tela de configuracao da impressao da DANFE
    aPerg := {}
    Pergunte("NFSIGW", .F.,,,,, @aPerg)
    MV_PAR01 := cDoc
    MV_PAR02 := cDoc
    MV_PAR03 := cSerie
    MV_PAR04 := 0 //[Operacao] NF de Entrada / Saida
    MV_PAR05 := 2 //[Frente e Verso] Nao
    MV_PAR06 := 2 //[DANFE simplificado] Nao
//    MV_PAR07 := Ctod("") // //[Data] Inicio
//    MV_PAR08 := Ctod("") // //[Data] Fim
    MV_PAR07 := dDataBase - 300
    MV_PAR08 := dDataBase + 300

    __SaveParam("NFSIGW", aPerg)

    oDanfe:lInJob := .T.
    If !lDanfe
        PRTMSG( "Fonte de impressao de DANFE nao compilado! Acesse o portal do cliente, baixe os fontes DANFEII.PRW, DANFEIII.PRW e compile em seu ambiente", LOG_ERROR )
        FERASE(cFolderFiles+cFileDanfe)    
        return ""
    Else
        &cProg.(@oDanfe, nil, cIdEnt, nil, nil, @lExistNfe, lIsLoja)
        if !oDanfe:Preview()
            PRTMSG( "Nao foi possivel gerar a DANFE para Empresa: "+ cEmpAnt + cFilDoc + " nota: " + alltrim(cDoc), LOG_PRINT )
            FERASE(cFolderFiles+cFileDanfe)    
            return ""
        EndIf
        if !lExistNfe
//            PRTMSG( "Nao foi gerado a DANFE para Empresa: "+ cEmpAnt + cFilDoc+ " nota: " + alltrim(cDoc), LOG_ERROR )
            MsgStop( "Nao foi gerado a DANFE para Empresa: "+ cEmpAnt + cFilDoc+ " nota: " + alltrim(cDoc))
            FERASE(cFolderFiles+cFileDanfe)
            Return ""
        endif
    EndIf

    While( !lFile .And. nTimes < 10)
        lFile := file(cFolderFiles+cFileDanfe)
        If(!lFile)
            nTimes++
            Sleep(500)
        Else
            Exit
        Endif    
    Enddo

    fwFreeObj(oSetup)
    fwFreeObj(oDanfe)
    oSetup := nil
    oDanfe := nil

EndIf

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

If !lFile
    cFileDanfe := ""
Else
    cFileDanfe := cFolderFiles+cFileDanfe
EndIf

RESTAREA(aArea)

Return cFileDanfe

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³                       ³ Data ³01/10/2023³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOMECOM   //SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)
