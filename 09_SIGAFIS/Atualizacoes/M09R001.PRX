#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE 'PARMTYPE.CH'


User Function M09R001()

Private cAlias   := CriaTrab(,.F.)
Private cPerg 	 := "M09R001"


Pergunte(cPerg,.F.)
oReport:= M09R1RPTDEF()
oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
Função responsável por estruturar as seções e campos que darão forma ao relatório, bem como outras características.
Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionados
@type function
@author Graziella Bianchin
@since 13/10/2022
@version 1.0
/*/
Static Function M09R1RPTDEF()

Local oReport		
Local oSection1	

Public cNome := ""
Public cCGC := ""
Public cInscr := ""
Public cTipo := ""
Public cGrptrib := ""
Public cEst := ""

oReport := TReport():New("M09R001"," Relatório - Notas Fiscais ",cPerg,{|oReport| M09R1PRTRPT(oReport)}," Relatório de Notas Fiscais ")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELATÓRIO SERÁ EM PAISAGEM

//Define a secao1 do relatorio, informando que o arquivo principal utlizado eh o SQL
oSection1 := TRSection():New(oReport,"Relatório de Notas Fscais",{"SQL"},)

//Define as celulas que irao aparecer na secao1
TRCell():New(oSection1,"FT_FILIAL" 	    ,cAlias,"Filial"					,PesqPict("SFT","FT_FILIAL" )	,TAMSX3("FT_FILIAL")[1]      ,NIL,{|| FT_FILIAL 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ENTRADA" 	,cAlias,"Entrada"					,PesqPict("SFT","FT_ENTRADA")	,TAMSX3("FT_ENTRADA")[1]     ,NIL,{|| FT_ENTRADA 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_EMISSAO" 	,cAlias,"Emissão"					,PesqPict("SFT","FT_EMISSAO")	,TAMSX3("FT_EMISSAO")[1]     ,NIL,{|| FT_EMISSAO 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_NFISCAL" 	,cAlias,"Nota Fiscal"				,PesqPict("SFT","FT_NFISCAL")	,TAMSX3("FT_NFISCAL")[1]     ,NIL,{|| FT_NFISCAL 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_SERIE" 	    ,cAlias,"Série" 					,PesqPict("SFT","FT_SERIE" 	)	,TAMSX3("FT_SERIE")[1]       ,NIL,{|| FT_SERIE 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_TIPOMOV" 	,cAlias,"Tp. Movimento"				,PesqPict("SFT","FT_TIPOMOV")	,TAMSX3("FT_TIPOMOV")[1]     ,NIL,{|| FT_TIPOMOV    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CLIEFOR" 	,cAlias,"Clie\For" 					,PesqPict("SFT","FT_CLIEFOR")	,TAMSX3("FT_CLIEFOR")[1]     ,NIL,{|| FT_CLIEFOR    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_LOJA" 	    ,cAlias,"Loja" 					    ,PesqPict("SFT","FT_LOJA" 	)	,TAMSX3("FT_LOJA")[1]        ,NIL,{|| FT_LOJA 	    },,,,,,,,,.T.)

TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_NOME","A1_NOME") 	    ,cAlias,"Nome" 					    ,PesqPict("SA1","A1_NOME" 	)	,TAMSX3("A1_NOME")[1]        ,NIL,{|| cNome    	},,,,,,,,,.T.)
TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_CGC","A1_CGC")  	    ,cAlias,"CNPJ" 					    ,PesqPict("SA1","A1_CGC" 	)	,TAMSX3("A1_CGC")[1]         ,NIL,{|| cCGC    	},,,,,,,,,.T.)
TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_INSCR","A1_INSCR")    ,cAlias,"Insc.Estadual"				,PesqPict("SA1","A1_INSCR" 	)	,TAMSX3("A1_INSCR")[1]       ,NIL,{|| cInscr    },,,,,,,,,.T.)
TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_TIPO","A1_TIPO") 	    ,cAlias,"Tp.Cli\For"				,PesqPict("SA1","A1_TIPO" 	)	,TAMSX3("A1_TIPO")[1]        ,NIL,{|| cTipo    	},,,,,,,,,.T.)
TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_GRPTRIB","A1_GRPTRIB"),cAlias,"Grp.Trib" 					,PesqPict("SA1","A1_GRPTRIB")	,TAMSX3("A1_GRPTRIB")[1]     ,NIL,{|| cGrptrib 	},,,,,,,,,.T.)
TRCell():New(oSection1,iif(Alltrim(str(MV_PAR05))="2","A2_EST","A1_EST")  	    ,cAlias,"UF" 					    ,PesqPict("SA1","A1_EST" 	)	,TAMSX3("A1_EST")[1]         ,NIL,{|| cEst     	},,,,,,,,,.T.)

TRCell():New(oSection1,"FT_PRODUTO" 	,cAlias,"Produto" 					,PesqPict("SFT","FT_PRODUTO")	,TAMSX3("FT_PRODUTO")[1]     ,NIL,{|| FT_PRODUTO 	},,,,,,,,,.T.)
TRCell():New(oSection1,"B1_DESC" 	    ,cAlias,"Descrição"					,PesqPict("SB1","B1_DESC" 	)	,TAMSX3("B1_DESC")[1]        ,NIL,{|| B1_DESC 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"B1_UM" 	        ,cAlias,"Unid.Medida"				,PesqPict("SB1","B1_UM" 	)	,TAMSX3("B1_UM")[1]          ,NIL,{|| B1_UM 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"B1_TIPO" 	    ,cAlias,"Tp.Produto"				,PesqPict("SB1","B1_TIPO" 	)	,TAMSX3("B1_TIPO")[1]        ,NIL,{|| B1_TIPO 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"B1_ORIGEM" 	    ,cAlias,"Origem" 					,PesqPict("SB1","B1_ORIGEM" )	,TAMSX3("B1_ORIGEM")[1]      ,NIL,{|| B1_ORIGEM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"B1_POSIPI" 	    ,cAlias,"NCM"   					,PesqPict("SB1","B1_POSIPI" )	,TAMSX3("B1_POSIPI")[1]      ,NIL,{|| B1_POSIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"B1_EX_NCM" 	    ,cAlias,"NCM EX" 					,PesqPict("SB1","B1_EX_NCM" )	,TAMSX3("B1_EX_NCM")[1]      ,NIL,{|| B1_EX_NCM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_TES" 	    ,cAlias,"TES"   					,PesqPict("SFT","FT_TES" 	)	,TAMSX3("FT_TES")[1]         ,NIL,{|| FT_TES 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"F4_TEXTO" 	    ,cAlias,"Descrição TES"				,PesqPict("SF4","F4_TEXTO" 	)	,TAMSX3("F4_TEXTO")[1]       ,NIL,{|| F4_TEXTO 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CONTA" 	    ,cAlias,"Conta Contábil"			,PesqPict("SFT","FT_CONTA" 	)	,TAMSX3("FT_CONTA")[1]       ,NIL,{|| FT_CONTA 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"CT1_DESC01" 	,cAlias,"Descrição CC"				,PesqPict("CT1","CT1_DESC01")	,TAMSX3("CT1_DESC01")[1]     ,NIL,{|| CT1_DESC01 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CFOP"        ,cAlias,"CFOP"  					,PesqPict("SF4","F4_CF" 	)	,TAMSX3("F4_CF")[1]          ,NIL,{|| FT_CFOP 	    },,,,,,,,,.T.)

TRCell():New(oSection1,"FT_QUANT" 	    ,cAlias,"Quantidade"				,PesqPict("SFT","FT_QUANT" 	)	,TAMSX3("FT_QUANT")[1]       ,NIL,{|| FT_QUANT 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_PRCUNIT" 	,cAlias,"Prc.Unitário"				,PesqPict("SFT","FT_TOTAL" 	)	,TAMSX3("FT_TOTAL" 	)[1]     ,NIL,{|| FT_TOTAL 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_FRETE" 	    ,cAlias,"Frete"						,PesqPict("SFT","FT_FRETE" 	)	,TAMSX3("FT_FRETE" 	)[1]     ,NIL,{|| FT_FRETE 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_SEGURO" 	    ,cAlias,"Seguro"					,PesqPict("SFT","FT_SEGURO" )	,TAMSX3("FT_SEGURO" )[1]     ,NIL,{|| FT_SEGURO 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_DESPESA" 	,cAlias,"Despesa"					,PesqPict("SFT","FT_DESPESA")	,TAMSX3("FT_DESPESA")[1]     ,NIL,{|| FT_DESPESA 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_DESCONT" 	,cAlias,"Desconto"					,PesqPict("SFT","FT_DESCONT")	,TAMSX3("FT_DESCONT")[1]     ,NIL,{|| FT_DESCONT 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALCONT" 	,cAlias,"Vl.Contábil"				,PesqPict("SFT","FT_VALCONT")	,TAMSX3("FT_VALCONT")[1]     ,NIL,{|| FT_VALCONT 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CLASFIS" 	,cAlias,"Sit.Trib."					,PesqPict("SFT","FT_CLASFIS")	,TAMSX3("FT_CLASFIS")[1]     ,NIL,{|| FT_CLASFIS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_BASEICM" 	,cAlias,"Base ICMS"					,PesqPict("SFT","FT_BASEICM")	,TAMSX3("FT_BASEICM")[1]     ,NIL,{|| FT_BASEICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ALIQICM" 	,cAlias,"Aliq.ICMS"					,PesqPict("SFT","FT_ALIQICM")	,TAMSX3("FT_ALIQICM")[1]     ,NIL,{|| FT_ALIQICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALICM" 	    ,cAlias,"Vlr. ICMS"					,PesqPict("SFT","FT_VALICM" )	,TAMSX3("FT_VALICM" )[1]     ,NIL,{|| FT_VALICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_OBSICM" 	    ,cAlias,"OBS ICMS"					,PesqPict("SFT","FT_OBSICM" )	,TAMSX3("FT_OBSICM" )[1]     ,NIL,{|| FT_OBSICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CTIPI" 	    ,cAlias,"Cod.IPI"					,PesqPict("SFT","FT_CTIPI" 	)	,TAMSX3("FT_CTIPI" 	)[1]     ,NIL,{|| FT_CTIPI 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_BASEIPI" 	,cAlias,"Base IPI"					,PesqPict("SFT","FT_BASEIPI")	,TAMSX3("FT_BASEIPI")[1]     ,NIL,{|| FT_BASEIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ALIQIPI" 	,cAlias,"Aliq. IPI"					,PesqPict("SFT","FT_ALIQIPI")	,TAMSX3("FT_ALIQIPI")[1]     ,NIL,{|| FT_ALIQIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALIPI" 	    ,cAlias,"Vlr. IPI"					,PesqPict("SFT","FT_VALIPI" )	,TAMSX3("FT_VALIPI" )[1]     ,NIL,{|| FT_VALIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_IPIOBS" 	    ,cAlias,"OBS IPI"					,PesqPict("SFT","FT_IPIOBS" )	,TAMSX3("FT_IPIOBS" )[1]     ,NIL,{|| FT_IPIOBS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_BASERET" 	,cAlias,"Base ICMS Sol"				,PesqPict("SFT","FT_BASERET")	,TAMSX3("FT_BASERET")[1]     ,NIL,{|| FT_BASERET 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ALIQSOL" 	,cAlias,"Aliq.ICMS Sol"				,PesqPict("SFT","FT_ALIQSOL")	,TAMSX3("FT_ALIQSOL")[1]     ,NIL,{|| FT_ALIQSOL 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ICMSRET" 	,cAlias,"Vlr.ICMS Sol"				,PesqPict("SFT","FT_ICMSRET")	,TAMSX3("FT_ICMSRET")[1]     ,NIL,{|| FT_ICMSRET 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CSTPIS" 	    ,cAlias,"Cod. PIS"					,PesqPict("SFT","FT_CSTPIS" )	,TAMSX3("FT_CSTPIS" )[1]     ,NIL,{|| FT_CSTPIS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_BASEPIS" 	,cAlias,"Base PIS"					,PesqPict("SFT","FT_BASEPIS")	,TAMSX3("FT_BASEPIS")[1]     ,NIL,{|| FT_BASEPIS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ALIQPIS" 	,cAlias,"Aliq.PIS"					,PesqPict("SFT","FT_ALIQPIS")	,TAMSX3("FT_ALIQPIS")[1]     ,NIL,{|| FT_ALIQPIS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALPIS" 	    ,cAlias,"Vlr. PIS"					,PesqPict("SFT","FT_VALPIS" )	,TAMSX3("FT_VALPIS" )[1]     ,NIL,{|| FT_VALPIS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CSTCOF" 	    ,cAlias,"Cod.COFINS"				,PesqPict("SFT","FT_CSTCOF" )	,TAMSX3("FT_CSTCOF" )[1]     ,NIL,{|| FT_CSTCOF 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_BASECOF" 	,cAlias,"Base COFINS"				,PesqPict("SFT","FT_BASECOF")	,TAMSX3("FT_BASECOF")[1]     ,NIL,{|| FT_BASECOF 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ALIQCOF" 	,cAlias,"Aliq.COFINS"				,PesqPict("SFT","FT_ALIQCOF")	,TAMSX3("FT_ALIQCOF")[1]     ,NIL,{|| FT_ALIQCOF 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALCOF" 	    ,cAlias,"Vlr.COFINS"				,PesqPict("SFT","FT_VALCOF" )	,TAMSX3("FT_VALCOF" )[1]     ,NIL,{|| FT_VALCOF 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_DIFAL" 	    ,cAlias,"Vlr.DIFAL"					,PesqPict("SFT","FT_DIFAL" 	)	,TAMSX3("FT_DIFAL" 	)[1]     ,NIL,{|| FT_DIFAL 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_VALFECP" 	,cAlias,"Vlr.FECP"					,PesqPict("SFT","FT_VALFECP")	,TAMSX3("FT_VALFECP")[1]     ,NIL,{|| FT_VALFECP 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CODISS" 	    ,cAlias,"Cod. ISS"					,PesqPict("SFT","FT_CODISS" )	,TAMSX3("FT_CODISS" )[1]     ,NIL,{|| FT_CODISS 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ISENICM" 	,cAlias,"Isento ICMS"				,PesqPict("SFT","FT_ISENICM")	,TAMSX3("FT_ISENICM")[1]     ,NIL,{|| FT_ISENICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_OUTRICM" 	,cAlias,"Outros ICMS"				,PesqPict("SFT","FT_OUTRICM")	,TAMSX3("FT_OUTRICM")[1]     ,NIL,{|| FT_OUTRICM 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_ISENIPI" 	,cAlias,"Isento IPI"				,PesqPict("SFT","FT_ISENIPI")	,TAMSX3("FT_ISENIPI")[1]     ,NIL,{|| FT_ISENIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_OUTRIPI" 	,cAlias,"Outros IPI"				,PesqPict("SFT","FT_OUTRIPI")	,TAMSX3("FT_OUTRIPI")[1]     ,NIL,{|| FT_OUTRIPI 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_CHVNFE" 	    ,cAlias,"Chave NFE"					,PesqPict("SFT","FT_CHVNFE" )	,TAMSX3("FT_CHVNFE" )[1]     ,NIL,{|| FT_CHVNFE 	},,,,,,,,,.T.)
TRCell():New(oSection1,"FT_TIPO" 	    ,cAlias,"Tp.Nota Livro"				,PesqPict("SFT","FT_TIPO" 	)	,TAMSX3("FT_TIPO" 	)[1]     ,NIL,{|| FT_TIPO 	    },,,,,,,,,.T.)
TRCell():New(oSection1,"FT_OBSERV" 	    ,cAlias,"Observações Livro"			,PesqPict("SFT","FT_OBSERV" )	,TAMSX3("FT_OBSERV" )[1]     ,NIL,{|| FT_OBSERV 	},,,,,,,,,.T.)

Return oReport

Static Function M09R1PRTRPT(oReport)
Local oSection1 := oReport:Section(1)
Local cQuery := ''

//INICIO DA QUERY
cQuery := "SELECT	FT_FILIAL, FT_ENTRADA, FT_EMISSAO, FT_NFISCAL, FT_SERIE, FT_TIPOMOV, FT_CLIEFOR, FT_LOJA, "

If Alltrim(str(MV_PAR05)) = "2"
    cQuery += "A1_NOME, A1_CGC, A1_INSCR, A1_TIPO, A1_GRPTRIB, A1_EST, "
else
    cQuery += "A2_NOME, A2_CGC, A2_INSCR, A2_TIPO, A2_GRPTRIB, A2_EST, "
Endif 

cQuery += "FT_PRODUTO, B1_DESC, B1_UM, B1_TIPO, B1_ORIGEM, B1_POSIPI, B1_EX_NCM,  "
cQuery += "FT_TES, F4_TEXTO, "
cQuery += "FT_CONTA, CT1_DESC01, FT_CFOP, "
cQuery += "FT_QUANT, FT_PRCUNIT, FT_TOTAL, FT_FRETE, FT_SEGURO, FT_DESPESA, FT_DESCONT, FT_VALCONT,"
cQuery += "FT_CLASFIS, FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_OBSICM, "
cQuery += "FT_CTIPI, FT_BASEIPI, FT_ALIQIPI, FT_VALIPI, FT_IPIOBS, "
cQuery += "FT_BASERET, FT_ALIQSOL,	FT_ICMSRET, "
cQuery += "FT_CSTPIS, FT_BASEPIS, FT_ALIQPIS, FT_VALPIS, "
cQuery += "FT_CSTCOF, FT_BASECOF, FT_ALIQCOF, FT_VALCOF, "
cQuery += "FT_DIFAL, FT_VALFECP, FT_CODISS, "
cQuery += "FT_ISENICM, FT_OUTRICM, "
cQuery += "FT_ISENIPI, FT_OUTRIPI, "
cQuery += "FT_CHVNFE, "
cQuery += "FT_TIPO, "
cQuery += "FT_OBSERV "

cQuery += "FROM "+RETSQLNAME("SFT")+" SFT "

If Alltrim(str(MV_PAR05)) = "2"
    cQuery += "INNER JOIN "+RETSQLNAME('SA1')+" SA1 ON A1_FILIAL = '"+FWxFilial("SA1")+"' AND A1_COD    = FT_CLIEFOR AND A1_LOJA = FT_LOJA AND SA1.D_E_L_E_T_ = '' "
else
    cQuery += "INNER JOIN "+RETSQLNAME('SA2')+" SA2 ON A2_FILIAL = '"+FWxFilial("SA2")+"' AND A2_COD    = FT_CLIEFOR AND A2_LOJA = FT_LOJA AND SA2.D_E_L_E_T_ = '' "    
Endif

cQuery += "INNER JOIN "+RETSQLNAME('SB1')+" SB1 ON B1_FILIAL = '"+FWxFilial("SB1")+"' AND B1_COD    = FT_PRODUTO AND SB1.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RETSQLNAME('SF4')+" SF4 ON F4_FILIAL = '"+FWxFilial("SF4")+"' AND F4_CODIGO = FT_TES     AND SF4.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RETSQLNAME('CT1')+" CT1 ON CT1_FILIAL= '"+FWxFilial("CT1")+"' AND CT1_CONTA = FT_CONTA   AND CT1.D_E_L_E_T_ = '' "

cQuery += "WHERE FT_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

cQuery += "AND FT_ENTRADA BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' " // #4498

cQuery += "  AND FT_NFISCAL BETWEEN '"+MV_PAR03+ "' AND '"+MV_PAR04+"' "
cQuery += "  AND FT_TIPOMOV = '"+ iif(Alltrim(str(MV_PAR05))="1","E","S") +"' "
cQuery += "  AND FT_FILIAL = '"+FWxFilial("SFT")+"' " // #4498
cQuery += "  AND SFT.D_E_L_E_T_ = '' "


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)
//FIM DA QUERY

DbSelectArea(cAlias)
DbGoTop()
While !oReport:Cancel() .AND. (cAlias)->(!EOF())
    If Alltrim(str(MV_PAR05)) = "2"
        cNome   := (cAlias)->A1_NOME
        cCGC    := (cAlias)->A1_CGC
        cInscr  := (cAlias)->A1_INSCR
        cTipo   := (cAlias)->A1_TIPO
        cGrptrib:= (cAlias)->A1_GRPTRIB
        cEst    := (cAlias)->A1_EST
    Else
        cNome   := (cAlias)->A2_NOME
        cCGC    := (cAlias)->A2_CGC
        cInscr  := (cAlias)->A2_INSCR
        cTipo   := (cAlias)->A2_TIPO
        cGrptrib:= (cAlias)->A2_GRPTRIB
        cEst    := (cAlias)->A2_EST    
    Endif
    oSection1:Init()
    oSection1:PrintLine()
    oReport:IncMeter()
    oReport:SkipLine(1) 
    (cAlias)->(dbskip())
EndDo

oSection1:Finish()
//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 
