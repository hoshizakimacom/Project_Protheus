#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"
#include "topconn.ch" 
#include "TbiCode.ch"
#INCLUDE "FILEIO.CH"
#include "colors.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#include "parmtype.ch"

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |M10R17     |Autor |Valdemir Miranda          | Data | 04/02/2023 ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Relacao de Numeros de Série dos Itens do Pedido de Revenda       ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function M10R17() 

Private TMPSD1    :=""
Private cxPedido1 :=Space(6)
Private cxPedido2 :=Space(6)
Private dDtEmisDe :=ctod("")
Private dDtEmisAte:=ctod("")
Private cProd     :=space(15)
Private cDesc     :=space(40)
Private nMaximox  :=0
Private cNumSer   :=space(6)
Private cNum      :=space(6)
Private cItem     :=space(3) 
Private dData     :=ctod("")
Private cString   :="ZA0"
Private aPergs    :={}
Private aRet      :={}
Private TMPZA0

Private cPlanilha := "Numeros de Série de Revenda"  // *** Nome da Pasta que sera' criada no arquivo Excel               *** //
Private cTabela   := "Relacao de Numeros de Série dos Itens do Pedido de Revenda"  // *** Nome do Titulo do Relatorio que sera' criado no arquivo Excel *** //
Private aCabecEx  :={}             // *** Vetor que armazenara' o Cabecalho do Arquivo Wxcel            *** //
Private aLinha    :={}             // *** Vetor que armazenara' a Linha Delhalhe do arquivo Excel       *** //
Private cAlfabeto :="a/A/b/B/c/C/d/D/e/E/f/F/g/G/h/H/i/I/j/J/k/K/l/L/m/M/n/N/o/O/p/P/q/Q/r/R/s/S/t/T/u/U/v/V/w/W/x/X/y/Y/z/Z"
Private cTipArq   :="CSV"          // *** Determina tipo de Arquivo Texto a ser Gerado (TXT ou CSV)     *** //

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Definição da Linha de Cabeçalho do Relatorio de Ranking de Compras do periodo por Produto ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| 1-Nome da Pasta que sera' criada no arquivo Excel                                         ||
|| 2-Nome do Titulo do Relatorio que sera' criado no arquivo Excel                           ||
|| 3-Vetor / Arrey, Contendo o nome dos Campos da Planilha Excel / Relatório                 ||            
|| 4-Campo                                                                                   ||     
|| 5-Posicionamento( 1-Left,2-Center,3-Right )                                               ||
|| 6-Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )                      ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
// ***        Nome da Aba Titulo   Campo     


// *** Lista de Campos do Relatorio *** //'      
aadd(aCabecEx,"Cod.Produto")
aadd(aCabecEx,"Descricao Produto")
aadd(aCabecEx,"Num.Serie")
aadd(aCabecEx,"Num.Pedido")
aadd(aCabecEx,"Item Pedido")
aadd(aCabecEx,"Data de Emissao")
aadd(aCabecEx,"Num.Ped.Venda") 

/*
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Definição das Pergundas que seram utilizadas nos Filtros da Query                        ||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
aAdd( aPergs ,{1,"Pedido      De :",cxPedido1  ,"@!","","SM0",".T.",2,.F.})
aAdd( aPergs ,{1,"Pedido      Ate:",cxPedido2  ,"@!","","SM0",".T.",2,.T.})
aAdd( aPergs ,{1,"Dt.Emissão  De :",dDtEmisDe  ,"","","","",50,.F.}) 
aAdd( aPergs ,{1,"Dt.Emissão  Ate:",dDtEmisAte ,"","","","",50,.T.}) 

If ParamBox(aPergs ,"Relacao de Numeros de Série dos Itens do Pedido de Revenda",aRet)
   
   // ***
   cxPedido1  :=MV_PAR01
   cxPedido2  :=MV_PAR02
   dDtEmisDe  :=MV_PAR03
   dDtEmisAte :=MV_PAR04

   // *** Acessa função para montagem da Query *** //
   Processa( {||MtQueryZA0() } )
   Processa({||ProcLinZA0()}, "Relacao de Numeros de Série dos Itens do Pedido de Revenda  - "+time() ) 

Else
   MsgInfo("Processo cancelado pelo Operador","Atencao")
EndIf

Return

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |ProcLinDet     |Autor |Valdemir Miranda      | Data | 04/02/2023 ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Relacao de Numeros de Série dos Itens do Pedido de Revenda       ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function ProcLinZA0()

Private cFileCSV := "pro_"+Lower(AllTrim(FunName()))+"_pcp_.csv"
Private cCSV     := "Cod.Produto;Descricao Produto;Num.Serie;Num.Pedido;Item Pedido;Data de Emissao"+CHR(13)+CHR(10)
Private cDir     := SuperGetMV("MV_RELT")
Private nTotal   := 0
Private nperc    := 0

// *** Pega Quantidade de Registros para ProcRegua *** //
dbSelectArea("TMPZA0")
dbGotop()
do while .not. eof()
   dbskip(30)
   if !eof()
      nTotal:= Recno()
    endif
enddo

// ***
dbSelectArea("TMPZA0")
ProcRegua(nTotal)
dbGoTop() 

// ***
While !Eof() //.and. nPerc <= mv_PAR06

    //cFilName := FWFilialName()
    cxSerie:=TMPZA0->ZA0_SERIE
    IncProc("Documento: " + TMPZA0->ZA0_PV+" - "+TMPZA0->ZA0_PROD+" - "+TMPZA0->B1_DESC)
    aadd(aLinha,{TMPZA0->ZA0_PROD,TMPZA0->B1_DESC, cxSerie,TMPZA0->ZA0_PV,TMPZA0->ZA0_ITEMPV,TMPZA0->C5_EMISSAO,TMPZA0->C5_NUM})   
       
    // ***
    dbSelectArea("TMPZA0")
    dbSkip()
Enddo

// *** Fecha query *** //
dbSelectArea("TMPZA0")
dbCloseArea()

// *** Imprime Documento em Planilha Excel *** //
if len(aLinha) > 0
   
    U_GERAEXCELN(cPlanilha,cTabela,aCabecEx,aLinha)

endif

Return(.T.)

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |MontQryZA0  |Autor |Valdemir Miranda          | Data | 04/02/2023||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     |Geracao de Query de Processamento                                ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function MtQueryZA0()

// ***
cQuery := "SELECT DISTINCT ZA0.ZA0_PV,ZA0.ZA0_ITEMPV,ZA0.ZA0_SERIE,ZA0.ZA0_PROD,SC5.C5_EMISSAO,SC5.C5_NUM,SB1.B1_COD,SB1.B1_DESC "
cQuery += " FROM " + RetSqlName("ZA0") + " ZA0 "

cQuery += " INNER JOIN "+RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL = '01' AND SC5.C5_NUM = ZA0.ZA0_PV  and SC5.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.B1_COD = ZA0.ZA0_PROD AND SB1.D_E_L_E_T_ = ' ' "

cQuery += " WHERE ZA0.ZA0_PV BETWEEN   '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " AND SC5.C5_EMISSAO  BETWEEN   '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "

cQuery += " AND ZA0.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY ZA0.ZA0_PV,ZA0.ZA0_ITEMPV,ZA0.ZA0_SERIE,ZA0.ZA0_PROD,SC5.C5_EMISSAO,SC5.C5_NUM,SB1.B1_COD,SB1.B1_DESC "
cQuery += " ORDER BY ZA0.ZA0_PV,ZA0.ZA0_ITEMPV,ZA0.ZA0_SERIE,ZA0.ZA0_PROD,SC5.C5_EMISSAO,SC5.C5_NUM,SB1.B1_COD,SB1.B1_DESC ASC "

cQuery := ChangeQuery(cQuery)
TcQUERY CQUERY NEW ALIAS "TMPZA0"
dbSelectArea("TMPZA0")
REturn
