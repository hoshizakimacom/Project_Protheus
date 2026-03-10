#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M04M06()

PRIVATE DULMES := GETMV("MV_ULMES")
PRIVATE DDATAINI := CTOD("")
PRIVATE CPERG := "M04M06"
PRIVATE CFILFABR := "01"
//VALIDPERG()

IF !(PERGUNTE(CPERG, .T. ))
    RETURN 
ENDIF

ODLG2 := MSDIALOG():NEW(0,0,180,460,OEMTOANSI(OEMTOANSI("ATUALIZAÇÃO DE CUSTO DAS NOTAS FISCAIS DE ENTRADA DE TRANSF. ")),,,,,,,,, .T. ,,,)

TSAY():NEW(12,12,{||OEMTOANSI(" ESTE PROGRAMA TEM O OBJETIVO DE ATUALIZAR O CUSTO DAS NOTAS ")},,,, .F. , .F. , .F. , .F. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
TSAY():NEW(22,12,{||OEMTOANSI(" FISCAIS DE ENTRADA DE TRANSFERÊNCIA ENTRE FILIAIS,")},,,, .F. , .F. , .F. , .F. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
TSAY():NEW(32,12,{||OEMTOANSI(" QUANDO A ORIGEM NÃO É A FÁBRICA.")},,,, .F. , .F. , .F. , .F. ,,,,, .F. , .F. , .F. , .F. , .F. , .F. )
SBUTTON():NEW(12,200,5,{||PERGUNTE(CPERG, .T. )},,)
SBUTTON():NEW(32,200,1,{||PROCOK()},,)
SBUTTON():NEW(52,200,2,{||ODLG2:END()},,)

ODLG2:ACTIVATE(ODLG2:BLCLICKED,ODLG2:BMOVED,ODLG2:BPAINTED, .T. ,,,,ODLG2:BRCLICKED,)

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION PROCOK()

LOCAL LRET :=  .T. 

DDATAINI := MV_PAR01

LRET := CTBDTCOMP(3,DDATAINI,"01")

IF !(LRET)
    MSGALERT(OEMTOANSI("CALENDÁRIO CONTÁBIL BLOQUEADO !!"),)
    RETURN 
ENDIF

IF DDATAINI<=DULMES
    MSGALERT(OEMTOANSI("DATA INVÁLIDA !!! FECHAMENTO DO ESTOQUE JÁ PROCESSADO !!!"),)
    RETURN 
ENDIF

PROCESSA({||ATUCSTTRA(DDATAINI,SM0->M0_CODFIL)},"AGUARDE A ATUALIZAÇAO DO CUSTO DE TRANSFERÊNCIA !!!")

ODLG2:END()

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION ATUCSTTRA(DDATA,CCODFIL)

LOCAL CQUERY := ""

LOCAL NQTDNFALT := 0

IF SELECT("TRB")>1
    DBSELECTAREA("TRB")
    DBCLOSEAREA()
ENDIF

CCFOPTRAN := "151/152"

CQUERY := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_TIPO, D1_FORNECE, D1_LOJA, D1_QUANT, R_E_C_N_O_ SD1RECNO"
CQUERY += " FROM "+RETSQLNAME("SD1")+" SD1"
CQUERY += " WHERE SD1.D1_FILIAL='"+CCODFIL+"'"
CQUERY += " AND SUBSTRING(D1_CF,2,3) IN "+FORMATIN( ALLTRIM(CCFOPTRAN),"/")
CQUERY += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
CQUERY += " AND SD1.D1_TIPO = 'N' "
CQUERY += " AND SD1.D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"

CQUERY += " AND SD1.D_E_L_E_T_ = ''"
CQUERY += " ORDER BY D1_FILIAL, D1_DOC, D1_SERIE "

MEMOWRITE("\QUERYSYS\RESTA03.SQL",CQUERY)

DBUSEAREA( .T. ,"TOPCONN",TCGENQRY(,,CQUERY),"TRB", .T. , .T. )
TCSETFIELD("TRB","D1_QUANT","N",14,4)

DBSELECTAREA("TRB")
PROCREGUA(LASTREC())

WHILE !(EOF())
 
    CFILNF := TRB->D1_FILIAL
    CDOC := TRB->D1_DOC
    CSERIE := TRB->D1_SERIE
    CFORNEC := TRB->D1_FORNECE
    
    CFILORI := FLOCFILORI(TRB->D1_FORNECE,TRB->D1_LOJA)
    
    DBSELECTAREA("SA1")
    DBSETORDER(3)
    
    IF !(DBSEEK(XFILIAL("SA1")+SM0->M0_CGC))
        DBSELECTAREA("TRB")
        DBSKIP()
        LOOP 
    ENDIF
    
    NQTDNFALT++
    
    IF CFILORI=="01"
        CTIPVLR := "M"
    ELSE 
        CTIPVLR := "F"
    ENDIF
    
    DBSELECTAREA("TRB")
    
    WHILE !(EOF()) .AND. TRB->D1_FILIAL==CFILNF .AND. TRB->D1_DOC==CDOC .AND. TRB->D1_SERIE==CSERIE .AND. TRB->D1_FORNECE==CFORNEC
    
        INCPROC(" NOTA/SERIE : "+TRB->D1_DOC+"/"+TRB->D1_SERIE)
        
        DBSELECTAREA("SD1")
        DBGOTO(TRB->SD1RECNO)
        
        IF CTIPVLR=="M"
            
            DBSELECTAREA("SD2")
            DBSETORDER(3)
            
            LFOUNDNF :=  .F. 
            CSERIORI := "1  "
            
            IF DBSEEK(CFILORI+SD1->D1_DOC+CSERIORI+SA1->A1_COD+SA1->A1_LOJA+SD1->D1_COD)
                LFOUNDNF :=  .T. 
            ENDIF
            
            IF LFOUNDNF
                DBSELECTAREA("SD1")
                RECLOCK("SD1", .F. )
                SD1->D1_CUSTO :=  ROUND(((SD2->D2_CUSTO1) * (SD1->D1_QUANT)) / (SD2->D2_QUANT),4)
                MSUNLOCK()
            ELSE 
                
                MSGSTOP(OEMTOANSI("NÃO LOCALIZADO NOTA + PRODUTO NA FILIAL DE ORIGEM. PRODUTO ")+SD1->D1_COD+" - DOCUMENTO "+SD1->D1_DOC,)
            ENDIF
        ELSE 
            
            DDTFECANT := FIRSTDAY(SD1->D1_DTDIGIT)-1
            
            CQUERY := "SELECT B9_FILIAL B9_FILIAL, SUM(B9_VINI1) B9_VINI1, SUM(B9_QINI) B9_QINI "
            CQUERY += " FROM "+RETSQLNAME("SB9")+" SB9"
            CQUERY += " WHERE B9_FILIAL='"+CFILORI+"'"
            CQUERY += " AND B9_COD = '"+SD1->D1_COD+"'"
            CQUERY += " AND B9_DATA = '"+DTOS(DDTFECANT)+"'"
            CQUERY += " AND D_E_L_E_T_ = ''"
            CQUERY += " GROUP BY B9_FILIAL"
            CQUERY := CHANGEQUERY(CQUERY)
            DBUSEAREA( .T. ,"TOPCONN",TCGENQRY(,,CQUERY),"TRBSB9", .F. , .T. )
            
            LACHOUCST :=  .F. 
            
            DBSELECTAREA("TRBSB9")
            DBGOTOP()
            WHILE !(EOF())
            
                IF TRBSB9->B9_VINI1>1 .AND. TRBSB9->B9_QINI>0
                    LACHOUCST :=  .T. 
                    EXIT 
                ENDIF
                
                DBSKIP()
                ENDDO
            
            IF (!(LACHOUCST)) 
            
            ELSE 
                
                DBSELECTAREA("SD1")
                RECLOCK("SD1")
                SD1->D1_CUSTO :=  ROUND(((TRBSB9->B9_VINI1) * (SD1->D1_QUANT)) / (TRBSB9->B9_QINI),4)
                MSUNLOCK()
            ENDIF
            
            DBSELECTAREA("TRBSB9")
            DBCLOSEAREA()
        ENDIF
        
        DBSELECTAREA("TRB")
        DBSKIP()
        ENDDO
        ENDDO

DBSELECTAREA("TRB")
DBCLOSEAREA()

DBSELECTAREA("SB9")
DBSETORDER(1)

AVISO(OEMTOANSI("ATUALIZAÇÃO NF TRANSFERÊNCIA !"),OEMTOANSI("ATUALIZAÇÃO DE CUSTO DE "+ ALLTRIM(STR(NQTDNFALT,4))+" NOTA(S) FISCAI(S) DE ENTRADA DE TRANSFERÊNCIA !"),{"OK"},1)

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
//STATIC FUNCTION VALIDPERG()
//
//LOCAL _SALIAS := ALIAS()
//LOCAL AREGS := {}
//LOCAL I,J
//
//DBSELECTAREA("SX1")
//DBSETORDER(1)
//
//CPERG := PADR(CPERG, LEN(SX1->X1_GRUPO))
//
//AADD(AREGS,{CPERG,"01","DATA INICIAL ?     ","","","MV_CH1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(AREGS,{CPERG,"02","DATA FINAL ?       ","","","MV_CH2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(AREGS,{CPERG,"03","PRODUTO DE ?       ","","","MV_CH3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(AREGS,{CPERG,"04","PRODUTO ATE  ?     ","","","MV_CH4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
//
//FOR I := 1 TO  LEN(AREGS)
//    
//    IF !(DBSEEK(CPERG+AREGS[I][2]))
//        RECLOCK("SX1", .T. )
//        FOR J := 1 TO FCOUNT()
//            
//            IF J<= LEN(AREGS[I])
//                FIELDPUT(J,AREGS[I][J])
//            ENDIF
//        NEXT
//        MSUNLOCK()
//    ENDIF
//NEXT

DBSELECTAREA(_SALIAS)

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION FLOCFILORI(CFORNEC,CLOJA)

LOCAL CFILORI := ""
LOCAL AAREAATU := GETAREA()
LOCAL AAREASM0 := SM0->(GETAREA())
LOCAL CCGCORI := ""
LOCAL CEMPRESA := SM0->M0_CODIGO

CCGCORI := POSICIONE("SA2",1,XFILIAL("SA2")+CFORNEC+CLOJA,"A2_CGC")

DBSELECTAREA("SM0")
DBSEEK(CEMPRESA)
WHILE !(EOF()) .AND. SM0->M0_CODIGO==CEMPRESA
 
    IF SM0->M0_CGC==CCGCORI
        CFILORI := SM0->M0_CODFIL
        EXIT 
    ENDIF
    
    DBSKIP()
    ENDDO

RESTAREA(AAREASM0)
RESTAREA(AAREAATU)

RETURN CFILORI
