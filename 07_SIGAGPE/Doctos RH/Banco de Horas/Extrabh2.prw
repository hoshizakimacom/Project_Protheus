#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH" 
#include "Fileio.ch"  
#INCLUDE "EXTRABH.CH"                                                                                                                      

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF	
/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |          |       |                       |      |          |||
|||Programa  | Extrabh2 | Autor | Valdemir Miranda      | Data |09/04/2013|||
|||          |          |       |                       |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Descri��o | Calcular Saldo de Banco de Horas por Per�odo e atualizar   |||  
|||          | Folha de Pagamento por per�odo                             |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||| Uso      | Gest�o Pessoal / Recussos Humanos                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||           ATUALIZA��ES SOFRIDAS DESDE A CONSTRU��O INICIAL            |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Programador | Data   | BOPS |  Motivo da Alteracao                     |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||            |        |      |                                          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function Extrabh2( lTerminal , cFilTerminal , cMatTerminal  )

Local aOrd		:= { "Matricula",  "Centro de Custo", "Nome", "Turno" , "C.Custo + Nome" } //'Matricula'###'Centro de Custo'###'Nome'###'Turno'###'C.Custo + Nome'
Local cHtml		:= "" 
Local cAviso		
Local cDesc1    := "Extrato Banco de Horas"	//'Extrato de Banco de Horas'
Local cDesc2    := "Ser� impresso de acordo com os parametros solicitados pelo"	//'Ser� impresso de acordo com os parametros solicitados pelo'
Local cDesc3    := "usuario."	//'usuario.'
Local cString	:= 'SRA' 	//-- Alias do arquivo principal (Base)
Local lEnd		:= .F.  
//-- Tratamento dos arquivos envolvidos no Fechamento Mensal (Para evitar que o processo nao seja finalizado)
Local aFilesOpen :={"SP5", "SPN", "SP8", "SPG","SPB","SPL","SPC", "SPH", "SPF"}
Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }

Private aReturn  := { "Zebrado" , 1, "Administra��o" , 2, 2, 1, '',1 } //'Zebrado'###'Administra��o'
Private nomeprog := 'EXTRBH'
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := 'EXTRBH'
Private Titulo   := 'Extrato de Banco de Horas'
Private cCabec   := ''
Private AT_PRG   := 'EXTRBH'
Private wCabec0  := 1
Private wCabec1  := ''
Private CONTFL   := 1
Private LI       := 1 //Inicializa Li com 1 para Nao Imprimir Cabecalho Padrao.
Private nTamanho := 'M'
Private aInfo    := {}
Private wnrel
Private nOrdem 
Private xarquivo  :=""
Private xwhorax	  :=LEFT(TIME(),2)+SUBSTR(TIME(),4,2)
Private _nTotSaldo:=0.00
Private _nOrdemx1 :=0  
/*/
Private STR0001	:="Zebrado"
Private STR0002	:="Administra��o"
Private STR0003	:="Extrato Banco de Horas"
Private STR0004	:="Ser� impresso de acordo com os parametros solicitados pelo"
Private STR0005	:="usuario."
Private STR0006	:="Matricula" 
Private STR0007	:="Centro de Costos" 
Private STR0008	:="Nome" 
Private STR0009	:="Turno"
Private STR0010	:="C.Custo + Nome"  
Private STR0011	:="Extrato Banco de Horas"
Private STR0012   :="Assinatura do Funcionario"  
Private STR0013	:="Emp...:"
Private STR0014	:=" Matr..: "
Private STR0015	:="  Chapa : "
Private STR0016   :="End...: "
Private STR0017   :=" Nome..: " 
Private STR0018   := "CGC...: "
Private STR0019   := "Funcao: "
/*/

lTerminal := IF( lTerminal == NIL , .F. , lTerminal )

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte( cPerg , .F. )

IF !lTerminal

	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	wnrel := 'EXTRBH' //-- Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho)

EndIF	

//��������������������������������������������������������������Ŀ
//� Retorna a Ordem do Relatorio.                                �
//����������������������������������������������������������������
nOrdem    := IF( !lTerminal , aReturn[8] , 1 )

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
Private FilialDe  := IF( !lTerminal , mv_par01 , cFilTerminal	)	//Filial  De
Private FilialAte := IF( !lTerminal , mv_par02 , cFilTerminal	)	//Filial  Ate
Private CcDe      := IF( !lTerminal , mv_par03 , SRA->RA_CC		)	//Centro de Custo De
Private CcAte     := IF( !lTerminal , mv_par04 , SRA->RA_CC		)	//Centro de Custo Ate
Private TurDe     := IF( !lTerminal , mv_par05 , SRA->RA_TNOTRAB)	//Turno De
Private TurAte    := IF( !lTerminal , mv_par06 , SRA->RA_TNOTRAB)	//Turno Ate
Private MatDe     := IF( !lTerminal , mv_par07 , cMatTerminal	)	//Matricula De
Private MatAte    := IF( !lTerminal , mv_par08 , cMatTerminal	)	//Matricula Ate
Private NomDe     := IF( !lTerminal , mv_par09 , SRA->RA_NOME	)	//Nome De
Private NomAte    := IF( !lTerminal , mv_par10 , SRA->RA_NOME	)	//Nome Ate
Private RegDe     := IF( !lTerminal , mv_par11 , SRA->RA_REGRA	)	//Regra De
Private RegAte    := IF( !lTerminal , mv_par12 , SRA->RA_REGRA	)	//Regra Ate
Private dDtIni    := IF( !lTerminal , mv_par13 , SRA->RA_ADMISSA)	//Data Inicial
Private dDtFim    := IF( !lTerminal , mv_par14 , dDataBase		)	//Data Final
Private cSit      := IF( !lTerminal , mv_par15 , fSituacao(,.F.))	//Situacao
Private cCat      := IF( !lTerminal , mv_par16 , fCategoria(,.F.))	//Categoria
Private nHoras    :=  2  //IF( !lTerminal , mv_par17 , 1				)	//Horas Normais/Valorizadas
Private nCopias   :=  1  //IF( !lTerminal , mv_par18 , 1				)	//Numero de Copias
Private nSalBH	  := IF( !lTerminal , mv_par19 , 1				)	//Imprimir com Saldo(Result/Credor/Devedor)
Private nTpEvento := IF( !lTerminal , mv_par20 , 1				)	//Imprimir Eventos(Autoriz/N.Autoriz/Ambos)

//||||||||||||||||||||||||||||
//||Cria Ordem de Grava��o  ||
//||||||||||||||||||||||||||||
c1Area:=getarea()
DbSelectarea("SZF")
DBSETORDER(1)
DBGOTTOM()
_nOrdemx1:=VAL(SZF->ZF_ORDEM)+1
Restarea(c1Area)
         
// ***
IF lTerminal

	//-- Verifica se foi possivel abrir os arquivos sem exclusividade
	If Pn090Open(@cHtml, @cAviso)
		cHtml := ""	
		cHtml := ImpExtraBh( @lEnd , wNRel , cString , lTerminal  ) 
	    /*
		��������������������������������������������������������������Ŀ
		� Apos a obtencao da consulta solicitada fecha os arquivos     �
		� utilizados no fechamento mensal para abertura exclusiva      �
		����������������������������������������������������������������*/
	    Aeval(aFilesOpen, bCloseFiles)
	Else
	   cHtml := HtmlDefault( cAviso , cHtml )   
	Endif
	
ElseIF !( nLastKey == 27 )              



	SetDefault( aReturn , cString )

	IF !( nLastKey == 27 )

	    RptStatus( { |lEnd| ImpExtAbix( @lEnd , wNRel , cString ) } , Titulo )

	EndIF

EndIF

Return( cHtml )

Static Function ImpExtAbix( lEnd, wNRel, cString , lTerminal )

Local cAcessaSRA	:= &("{ || " + ChkRH("EXTRABH","SRA","2") + "}")
Local cHtml			:= ""
Local cFil       	:= ''
Local cMat       	:= ''
Local cTno       	:= ''
Local cFilTmp    	:= '��'
Local cTnoAnt    	:= '���'
Local lLoop      	:= .F.
Local nX         	:= 0
Local nY         	:= 0
Local nCount		:= 0

lTerminal := IF( lTerminal == NIL , .F. , lTerminal )

lEnd:=.F.

dbSelectArea('SRA')
dbSetOrder(nOrdem)
If nOrdem == 1 .or. lTerminal
	cInicio  := 'RA_FILIAL + RA_MAT'
	IF !lTerminal
		dbSeek(FilialDe + MatDe,.T.)
		cFim     := FilialAte + MatAte
	Else
		cFim     := &( cInicio )
	EndIF		
ElseIf nOrdem == 2
   dbSeek(FilialDe + CcDe + MatDe,.T.)
   cInicio  := 'RA_FILIAL + RA_CC + RA_MAT'
   cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
   dbSeek(FilialDe + NomDe + MatDe,.T.)
   cInicio  := 'RA_FILIAL + RA_NOME + RA_MAT'
   cFim     := FilialAte + NomAte + MatAte
ElseIf nOrdem == 4
   dbSeek(FilialDe + TurDe + MatDe,.T.)
   cInicio  := 'RA_FILIAL + RA_TNOTRAB + RA_MAT'
   cFim     := FilialAte + TurAte + MatAte
ElseIf nOrdem == 5
   dbSetOrder(8)
   dbSeek(FilialDe + CcDe + NomDe,.T.)
   cInicio  := 'RA_FILIAL + RA_CC + RA_NOME'
   cFim     := FilialAte + CcAte + NomAte
Endif

//-- Inicializa R�gua de Impress�o
IF !lTerminal
	SetRegua(RecCount())
EndIF	

dbSelectArea("SRA")
While SRA->( !Eof() .and. &(cInicio) <= cFim )

   IF !lTerminal
   
	   //-- Incrementa a R�gua de Impress�o
	   IncRegua()
	
	   //-- Cancela a Impress�o case se pressione Ctrl + A
	   If lEnd
	      IMPR(cCancela,'C')
	      Exit
	   EndIF
	
	   //��������������������������������������������������������������Ŀ
	   //� Consiste Parametrizacao do Intervalo de Impressao            �
	   //����������������������������������������������������������������
	   If (SRA->RA_TNOTRAB < Turde) .Or. (SRA->RA_TNOTRAB > TurAte) .Or. ;
	      (SRA->Ra_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
	      (SRA->Ra_MAT < MatDe) .Or. (SRA->RA_MAT > MatAte)  .Or. ;
	      (SRA->Ra_CC < CCDe) .Or. (SRA->RA_CC > CCAte) .Or. ;
	      (SRA->Ra_REGRA < RegDe) .Or. (SRA->RA_REGRA > RegAte)
	      dbSkip()
	      Loop
	   Endif
	
	   //-- Consiste Preenchimento de Cracha e data de Demiss�o
	   If !Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEMISSA < dDtIni
	      DbSkip()
	      Loop
	   Endif
	
	   //-- Consiste Situacao e Categoria
	   If !(Sra->Ra_SitFolh $ cSit) .Or. ;
	      !(Sra->Ra_CatFunc $ cCat)
	      DbSkip()
	      Loop
	   Endif
	
		//��������������������������������������������������������������Ŀ
		//� Consiste controle de acessos e filiais validas               �
		//����������������������������������������������������������������
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
			Loop
		EndIf
	
	EndIF
	
	If SRA->RA_FILIAL #cFilTmp
		cFilTmp    := SRA->RA_Filial
		cTnoAnt    := '���'
		//-- Atualiza o Array de Informa��es sobre a Empresa.
		aInfo := {}
		fInfo(@aInfo, SRA->RA_Filial)
	Endif

	IF !lTerminal
		Set Device to Printer
	EndIF	

	//-- Carrega os Totais de Horas e Abonos.
	nSaldo   :=0
	nSaldoAnt:=0
	aDet     :={}

   // 1 - Data
   // 2 - Codigo do Evento
   // 3 - Descricao do Evento
   // 4 - Quantidade de Horas Debito
   // 5 - Quantidade de Horas Credito
   // 6 - Saldo
   // 7 - Status

   //��������������������������������������������������������������Ŀ
   //� Verifica lancamentos no Banco de Horas                       �
   //����������������������������������������������������������������
   dbSelectArea( "SPI" )
   dbSetOrder(2)
   dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
   While !Eof() .And. SPI->PI_FILIAL+SPI->PI_MAT == SRA->RA_FILIAL+SRA->RA_MAT
   
     if empty(SPI->PI_DTBAIX)
      // Totaliza Saldo Anterior
      If SPI->PI_STATUS == " " .And. SPI->PI_DATA < dDtIni
         If PosSP9( SPI->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" 
				If nHoras==1	// Horas Normais
	            nSaldoAnt:=SomaHoras(nSaldoAnt,SPI->PI_QUANT)
				Else
					nSaldoAnt:=SomaHoras(nSaldoAnt,SPI->PI_QUANTV)
				Endif
	      Else
				If nHoras==1
		         nSaldoAnt:=SubHoras(nSaldoAnt,SPI->PI_QUANT)
				Else
		         nSaldoAnt:=SubHoras(nSaldoAnt,SPI->PI_QUANTV)
				Endif
	      Endif
			nSaldo := nSaldoAnt
		Endif

		//��������������������������������������������������������������Ŀ
		//� Verifica os Lancamentos a imprimir                           �
		//����������������������������������������������������������������
		If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim
			dbSkip()
			Loop
		Endif

		//-- Verifica tipo de Evento quando for diferente de Ambos
		If nTpEvento <> 3
			If !fBscEven(SPI->PI_PD,2,nTpEvento)
				SPI->(dbSkip())
				Loop
			EndIf
		Else
			PosSP9( SPI->PI_PD ,SRA->RA_FILIAL )
		Endif

		//��������������������������������������������������������������Ŀ
		//� Acumula os lancamentos de Proventos/Desconto em Array        �
		//����������������������������������������������������������������

		If SP9->P9_TIPOCOD $ "1*3"
			nSaldo:=SomaHoras(nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		Else
			nSaldo:=SubHoras (nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		Endif

		aAdd(aDet,{padr(DTOC(SPI->PI_DATA),10),SPI->PI_PD,;
					  Left(DescPdPon(SPI->PI_PD,SPI->PI_FILIAL),20),;
					  Transform(If(SP9->P9_TIPOCOD $ "1*3",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)),"9999999.99"),;
					  Transform(If(SP9->P9_TIPOCOD $ "1*3",If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV),0),"9999999.99"),;
					  Transform(nSaldo,"99999999.99"),IF(SPI->PI_STATUS=="B","Baixado","Pendente") })  
					  
					  
		// *** Grava Saldo do Banco de Horas *** //
		/*
   		cArea2:=getarea() 
        DbSelectarea("SZF")
        Set filter to FILIAL == SRA->RA_FILIAL .AND. Matricula == SRA->RA_MAT .AND. ZF_ORDEM == STRZERO(_nOrdemx1,4)
        dbgotop()
        if eof()
           RecLock("SZF",.T.)
        else
           RecLock("SZF",.F.)
        endif
        
        // *** Rateia Saldo de Horas *** //
        nTotHoras:=nSaldo 
        _nTotSaldo:=_nTotSaldo+nSaldo
        nHrs50		:=0.00
        nHrs65		:=0.00 
        nHrs80      :=0.00
        if nTotHoras > 20.00
           nHrs50:=20.00
           nTotHoras:= nTotHoras - 20.00
           if nTotHoras > 40.00
              nTotHoras:= nTotHoras - 40.00 
              nHrs65:=40.00
              nHrs80:=nTotHoras
           else
              nHrs65:=nTotHoras
           endif
        else
           nHrs50:=nTotHoras
        endif
       
        // *** Grava Tabela *** //
        SZF->ZF_FILIAL		:= SRA->RA_FILIAL
   		SZF->ZF_MAT			:= SRA->RA_MAT 
	    SZF->ZF_NOME		:= SRA->RA_NOME
	    SZF->ZF_DTINI		:= dDtIni
	    SZF->ZF_DTFIM		:= dDtFim
	    SZF->ZF_SLDTOT 		:= nSaldo
	    SZF->ZF_VALOR50		:= nHrs50
	    SZF->ZF_VALOR65		:= nHrs65
	    SZF->ZF_VALOR80		:= nHrs80
	    SZF->ZF_ORDEM		:= STRZERO(_nOrdemx1,4)
	    SZF->(MsUnlock())
	    Set Filter to 
        restarea(cArea2)
		*/

     endif  
     dbSelectArea( "SPI" )
	 SPI->( dbSkip() )

	Enddo

   If Len(aDet) > 0 .OR. !EMPTY(nSaldo)
		If nSalBH == 1	.Or. (nSalBH == 2 .And. nSaldo >= 0) .Or.;
								  (nSalBH == 3 .And. nSaldo < 0)
      	//-- Imprime o Espelho para um Funcionario.
	      For nCount := 1 To nCopias
	          cHtml := fImpFun( lTerminal  )
	      Next
		Endif
	Endif

   dbSelectArea("SRA")
   dbSkip()

Enddo

IF !lTerminal

	//��������������������������������������������������������������Ŀ
	//� Termino do relatorio                                         �
	//����������������������������������������������������������������
	dbSelectArea('SPI')
	dbSetOrder(1)
	
	dbSelectArea('SRA')
	dbSetOrder(1)
	Set Filter To
	Set Device To Screen
	If aReturn[5] == 1
	   Set Printer To
	   dbCommit()
	   OurSpool(wnrel)
	Endif
	MS_FLUSH()

EndIF
                   
// ***
if _nTotSaldo > 0.00
   AtuMovtoMensal()
endif


Return( cHtml ) 


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |AtuMovtoMensal()  |Autor|Valdemir Miranda | Data |09/04/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descri��o | Fun��o para Atualizar Movimento da Folha               	  |||  
|||          | 					                                          |||
|||          | 						                                      |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function AtuMovtoMensal()  

// *** Prepara Arrey do MBROWSE *** //
Private _afields       :={}
Private cCadastro      := 'SALDO PARA FECHAMENTO DE BANCO DE HORAS'
Private cConfLancPadrao:="Fechamento de Banco de Horas"
Private aRotina        :={ {'Pesquisar','AxPesqui',0,1 },;
                           {'Visualizar','AxVisual',0,2 },;
						   {'Incluir','AxInclui',0,3 },;   
	     			       {'Altera','AxAltera',0,4 },; 
                    	   {'Excluir','AxExclui',0,5 },; 
                    	   {'Integra Folha','U_INTGFOL2',0,6 }}
                    	   //{'Arquivo em Excel','U_GERAEXCEL',0,7 }}
                    
AADD(_afields,{"ZF_FILIAL","","Filial"})
AADD(_afields,{"ZF_MAT","","Matricula"}) 
AADD(_afields,{"ZF_NOME","","Nome"})
AADD(_afields,{"ZF_DTINI","","Per�odo Inicial"})
AADD(_afields,{"ZF_DTFIM","","Per�odo Final"})
AADD(_afields,{"ZF_SLDTOT","","Saldo Total"})
AADD(_afields,{"ZF_VALOR50","","Hora Extra 50 %"}) 
AADD(_afields,{"ZF_VALOR65","","Hora Extra 65 %"}) 
AADD(_afields,{"ZF_VALOR80","","Hora Extra 80 %"})

// *** Exibe Browse *** //                    
DbSelectArea("SZF")
DbGotop()                     
MBROWSE( ,,,,'SZF',,,_afields,,,) 
//MBROWSE( ,,,,'BCH',,,,,,) 
CLOSEBROWSE()

// *** Apaga lan�amentos Tempor�rios *** //
cAraex1:=getarea()
DbSelectArea("SZF")
DbGotop()
Do While .not. eof()

   if ZF_ORDEM == STRZERO(_nOrdemx1,4) 
      RecLock("SZF",.F.)
      dele
      SZF->(MsUnlock())
   endif
   dbskip()
enddo
Restarea(cAraex1)
Return 

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                  |     |                 |      |          |||
|||Programa  |INTGFOL2()        |Autor|Valdemir Miranda | Data |09/04/2013|||
|||          |                  |     |                 |      |          |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||          |                                                            |||
|||Descri��o | Fun��o para Atualizar Movimento da Folha               	  |||  
|||          | 					                                          |||
|||          | 						                                      |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function INTGFOL2()

// ***        
cAraex2:=getarea()
DbSelectArea("SZF")
DbGotop()
Do While .not. eof()
   if ZF_ORDEM == STRZERO(_nOrdemx1,4) 
                         
      // *** 
      cAreaSra:=getarea()
      WCCUSTO:=""
      dbselectarea("SRA")
      DBSETORDER(1)
      DBSEEK(SZF->ZF_FILIAL+SZF->ZF_MAT)
      IF .NOT. EOF()
         WCCUSTO:=SRA->RA_CC
      ENDIF
      RESTAREA(cAreaSra)
      
      // ***
      for ix1x:=1 to 3
          
          // ***
          wverba:=""
          wvalor:=0.00
          if ix1x =1
             wverba:="104"
             wvalor:=SZF->ZF_VALOR50 
          elseif ix1x =2
      		 wverba:="105"
             wvalor:=SZF->ZF_VALOR65
          elseif ix1x =3
      		 wverba:="110"
             wvalor:=SZF->ZF_VALOR80
          endif
                
          // *** Atualiza Tabela de Movimento da Folha *** //
          if wvalor > 0.00
             cAraex3:=getarea()
             DBSELECTAREA("SRC")
             DBSETORDER(1)
             DBSEEK(xFilial()+SZF->SF_MAT+WVERBA)
             IF .NOT. EOF()
                RecLock("SRC",.F.)
                SRC->RC_FILIAL	:=SZF->ZF_FILIAL
                SRC->RC_MAT		:=SZF->ZF_MAT 
                SRC->RC_PD		:=WVWRBA
                SRC->RC_TIPO1	:="H" 
                SRC->RC_HORAS	:=WVALOR
                SRC->RC_CC		:=WCCUSTO
                SRC->RC_TIPO2	:="C"
                SRC->(MsUnlock())
             ENDIF
             Restarea(cAraex3)
          endif
      Next ix1x
   endif
   dbskip()
enddo
Restarea(cAraex2)
Return 

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FImpFun   � Autor � Equipe Advanced RH    � Data � 11.12.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o Extrato de Banco de Horas                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpFun( lTerminal  )

Local cHtml		:= ""
Local cDet      := ""
Local nX        := 0
Local nDet	  	:= 0	
Local lZebrado	:= .F.

//-- O valor inicial do Saldo passa a ser do Saldo Anterior ao Periodo Solicitado
nSaldo := nSaldoAnt
lTerminal := IF( lTerminal == NIL , .F. , lTerminal )

/*
-------------------------------------------------------------------------------
  Data     Evento                       Debito    Credito       Saldo  Status
-------------------------------------------------------------------------------
                      Saldo Anterior 999999.99       0,00        0,00
99/99/99   999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
*/

//-- Inicializa Li com 1 para n�o imprimir cabecalho padrao
Li := 01

IF lTerminal
	cHtml += HtmlProcId() + CRLF
	cHtml += '<html>'  + CRLF
	cHtml += 	'<head>'  + CRLF
	cHtml += 		'<title>RH Online</title>'  + CRLF
	cHtml +=		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'  + CRLF
	cHtml +=		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">'  + CRLF
	cHtml +=	'</head>'  + CRLF
	cHtml +=	'<body bgcolor="#FFFFFF" text="#000000">'  + CRLF
	cHtml +=		'<table width="515" border="0" cellspacing="0" cellpadding="0">'  + CRLF
  	cHtml +=			'<tr>'  + CRLF
    cHtml +=				'<td class="titulo">'  + CRLF
    cHtml +=					'<p>'  + CRLF
    cHtml +=						'<img src="'+TcfRetDirImg()+'/icone_titulo.gif" width="7" height="9">'  + CRLF
    cHtml +=							'<span class="titulo_opcao">'  + CRLF
    cHtml +=								STR0003 + CRLF	//'Extrato de Banco de Horas'
    cHtml +=							'</span>' + CRLF
    cHtml +=							'<br><br>' + CRLF
	cHtml +=					'</p>' + CRLF
	cHtml +=				'</td>' + CRLF
  	cHtml +=			'</tr>' + CRLF
  	cHtml +=			'<tr>' + CRLF
    cHtml +=				'<td>' + CRLF
    cHtml +=					'<p><img src="'+TcfRetDirImg()+'/tabela_conteudo.gif" width="515" height="12" align="center"></p>' + CRLF
    cHtml +=				'</td>' + CRLF
  	cHtml +=			'</tr>' + CRLF
  	cHtml +=			'<tr>' + CRLF
    cHtml +=				'<td>' + CRLF
    cHtml +=					'<table width="515" border="0" cellspacing="0" cellpadding="1">' + CRLF
    cHtml +=						'<tr>' + CRLF
    cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_1.gif" width="10">&nbsp;</td>' + CRLF
    cHtml +=							'<td class="titulo" width="498">' + CRLF
    cHtml +=								'<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
	cHtml +=									'<tr>' + CRLF
	cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="left">' + CRLF
    cHtml +=												STR0025 + CRLF	//"Data"
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="left">' + CRLF
    cHtml +=												STR0026 + CRLF	//"Evento"
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="right">' + CRLF
    cHtml +=												STR0027 + CRLF	//'D&eacute;bito'
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="right">' + CRLF
    cHtml +=												STR0028 + CRLF	//'Cr&eacute;dito'
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="right">' + CRLF
    cHtml +=												STR0029 + CRLF	//'Saldo'
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=										'<td class="etiquetas" bgcolor="#FAFBFC" nowrap>' + CRLF
    cHtml +=											'<div align="center">' + CRLF
    cHtml +=												STR0030 + CRLF	//'Status'
    cHtml +=											'</div>' + CRLF
    cHtml +=										'</td>' + CRLF
    cHtml +=									'</tr>' + CRLF
    cHtml +=									'<tr>' + CRLF
    cHtml +=										'<td colspan="06" class="etiquetas" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
    cHtml +=									'</tr>' + CRLF
EndIF

//-- Imprime Cabecalho Especifico.
IF !lTerminal
	Imp_Cabec() //aqui
EndIF	

//-- Imprime Marca��es
nDet := Len(aDet)
For nX := 1 To nDet
	lZebrado := ( nX%2 == 0.00 )
	IF nX > 1
		nSaldo := Val(aDet[nX-1,6])
	EndIF
	IF !lTerminal
		IF Li >57
			Li := 01
			Imp_Cabec()
		EndIF
		cDet :=	aDet[nX,1] + " "
		cDet +=	aDet[nX,2] + "-"
		cDet += aDet[nX,3] + " "
		cDet += aDet[nX,4] + " "
		cDet += aDet[nX,5] + " "
		cDet += aDet[nX,6] + "  "
		cDet += aDet[nX,7]
		Impr(cDet, 'C')
	Else
		IF lZebrado
			cHtml += '<tr bgcolor="#FAFBFC">' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
			cHtml +=	aDet[nX,1] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
			cHtml += 		aDet[nX,2] + " - " + Capital( AllTrim( aDet[nX,3] ) ) + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="right">' + CRLF
			cHtml += 		aDet[nX,4] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="right">' + CRLF
			cHtml += 		aDet[nX,5] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml +=	 '<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="right">' + CRLF
			cHtml +=		aDet[nX,6] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
			cHtml += 		aDet[nX,7] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += '<tr>' + CRLF
		Else
			cHtml += '<tr>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
			cHtml +=	aDet[nX,1] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="left">' + CRLF
			cHtml += 		aDet[nX,2] + " - " + Capital( AllTrim( aDet[nX,3] ) ) + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="right">' + CRLF
			cHtml += 		aDet[nX,4] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="right">' + CRLF
			cHtml += 		aDet[nX,5] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml +=	 '<td class="dados_2" nowrap><div align="right">' + CRLF
			cHtml +=		aDet[nX,6] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
			cHtml += 		aDet[nX,7] + CRLF
			cHtml += 	'</td>' + CRLF
			cHtml += '<tr>' + CRLF
		EndIF	
	EndIF
Next nx

IF !lTerminal

	//-- Atualiza saldo anterior para o ultimo registro lido
	//-- Senao, ao findar a pagina na ultima linha detalhe, o saldo anterior a se impresso
	//-- ira exibir o saldo anterior como o penultimo calculado. 
	nSaldo := iif(Empty(Len(aDet)),nSaldo,Val(aDet[Len(aDet),6]))
	If (Li+4) >57
		Li := 01
		Imp_Cabec()
	Endif
	Impr(__PrtThinLine(),'C') 
	Impr(' ','C')
	Impr(Space(55) +  Repl('_',31), 'C')
	Impr(Space(58) + STR0012 , 'C') //"Assinatura do Funcionario "
Else
	cHtml +=								'</table>'
	cHtml +=								'<br>'
	cHtml +=							'</td>'
    cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_2.gif" width="7">&nbsp;</td>'
    cHtml +=						'</tr>'
    cHtml +=					'</table>'
    cHtml +=				'</td>'
  	cHtml +=			'</tr>'
  	cHtml +=			'<tr>' 
    cHtml +=				'<td><img src="'+TcfRetDirImg()+'/tabela_conteudo_3.gif" "515" height="14" align="center"></td>'
  	cHtml +=			'</tr>'
	cHtml +=		'</table>'
	cHtml +=		'<p align="right"><a href="javascript:self.print()"><img src="'+TcfRetDirImg()+'/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>'
	cHtml +=	'</body>'
	cHtml += '</html>'
EndIF
	
Return( cHtml )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Imp_Cabec � Autor � Equipe Advanced RH    � Data � 11.12.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho do Extrato do Banco de horas           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � POR010IMP                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Imp_Cabec()

cDet      := ''
cDescCc   := ''


@ 0,0 PSAY AvalImp(132)
  


//-- Linha 01
//-- Emp...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Matr..: 99-999999  Chapa : 9999999999
cDet := STR0013 + Left( If(Len(aInfo)>0,aInfo[03],SM0->M0_NomeCom) + Space(44), 51) //'Emp...: '
cDet := cDet + STR0014 + SRA->RA_Filial + '-' + SRA->RA_Mat	//' Matr..: '
cDet := cDet + STR0015  + SRA->RA_ChapA //'  Chapa : '
Impr(cDet,'C')

//-- Linha 02
//-- End...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Nome..: XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
cDet := STR0016 + Left( If(Len(aInfo)>0,aInfo[04],SM0->M0_EndCob) + Space(43), 50) //'End...: '
cDet := cDet + STR0017 + Left(SRA->RA_Nome + Space(30), 30) //' Nome..: '
Impr(cDet,'C')

//-- Linha 03
//-- CGC...: 99.999.999/9999-99                Funcao: 9999-XXXXXXXXXXXXXXXXXXXX
cDet := STR0018 + Transform( If(Len(aInfo)>0,aInfo[08],SM0->M0_CGC),'@R 99.999.999/9999-99') + Space(33) //'CGC...: '
cDet := cDet + STR0019 + SRA->RA_CodFunc + '-' + Left(DescFun(SRA->RA_CodFunc , SRA->RA_Filial) + Space(20), 20) //'Funcao: '
Impr(cDet,'C')

//-- Linha 04
//-- C.C...: 99999999-XXXXXXXXXXXXXXXXXXXXXXX  Categ.: XXXXXXXXXXXXXXX
cDet := STR0020 + Left(SUBS(SRA->RA_CC,1,20) + '-' + Left(DescCc(SRA->RA_CC, SRA->RA_FILIAL,30) + Space(33), 33) + Space(50), 50) //'C.C...: '
cDet := cDet + STR0021 + DescCateg(SRA->RA_CatFunc,15) //' Categ.: '
Impr(cDet,'C')

//-- Linha 05
//-- Turno.: 999-XXXXXXXXXXXXXXXXXXXXX
cDescTno := Space(50)
cFil := If(Empty(xFilial('SR6')), xFilial('SR6'), SRA->RA_FILIAL)

dbSelectArea("SR6")
If dbSeek(cFil+SRA->RA_TNOTRAB,.F.)
   cDescTno := Left(AllTrim(SR6->R6_Desc),50)
EndIf
cDet := STR0022 + AllTrim(SRA->RA_TnoTrab) + '-' + cDescTno //'Turno.: '

Impr(cDet,'C')

//-- Monta e Imprime Cabecalho das Marcacoes
cDet := STR0023 //'  Data     Evento                       Debito    Credito       Saldo  Status'

Impr(__PrtThinLine(),'C') 
Impr(cDet, 'C')
Impr(__PrtThinLine(),'C') 

cDet := Space(43) + STR0024 + Transform(nSaldo,"99999999.99") //"Saldo Anterior "
Impr( cDet ,"C")

Return( NIL )

/*
*******************************************************************************

Data               Saldo Anterior     Debito    Credito       Saldo  Status
  Data   Evento                       Debito    Credito       Saldo  Status
*******************************************************************************
                                         Saldo Anterior 99999999,99
99/99/99 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Pendente
99/99/99 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
99/99/99                999999.99 9999999,99 9999999,99 99999999,99  Baixado

*******************************************************************************

Data                 Saldo Anterior     Debito    Credito       Saldo  Status
  Data     Evento                       Debito    Credito       Saldo  Status
*******************************************************************************
                                           Saldo Anterior 99999999,99
99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Pendente
99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
99/99/9999                999999.99 9999999,99 9999999,99 99999999,99  Baixado

*/
       
 
