#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M34A01()

PRIVATE CCADASTRO := "CADASTRO DE BUDGET"

PRIVATE CDELFUNC := ".T."
PRIVATE CALIAS := "SZA"
PRIVATE _CARQCSV
PRIVATE _ALINHAS
PRIVATE CFILE := ""
PRIVATE CEND := "C:\WINDOWS\TEMP\"
PRIVATE CDTHR := DTOS(DDATABASE)+"-"+ SUBSTR(TIME(),1,2)+"-"+ SUBSTR(TIME(),4,2)+"-"+ SUBSTR(TIME(),7,2)
PRIVATE CNOMELOG := "LOGBUDGET"+CDTHR+"_LOG.TXT"
PRIVATE CARQ := CEND+CNOMELOG
PRIVATE _CLINHA

PRIVATE AROTINA := {{"PESQUISAR","AXPESQUI",0,1},{"VISUALIZAR","AXVISUAL",0,2},{"INCLUIR","AXINCLUI",0,3},{"ALTERAR","AXALTERA",0,4},{"EXCLUIR","AXDELETA",0,5},{"IMPORT .CSV","U_IMPCSV",0,3}}

DBSELECTAREA("SZA")
DBSETORDER(1)

DBSELECTAREA(CALIAS)
MBROWSE(6,1,22,75,CALIAS)

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION IMPCSV()

LOCAL LOK :=  .T. 
LOCAL CARQ := ""

CARQ := GETPLAN()

IF !(EMPTY(CARQ))

    IF MSGYESNO("DESEJA MESMO IMPORTAR A PLANILHA?","ATENÇÃO!")

        MSGRUN("PROCESSANDO","IMPORTAÇÃO DA PLANILHA",{||PROCESSA(CARQ)})
    ELSE 

        LOK :=  .F. 
    ENDIF
ELSE 

    LOK :=  .F. 
ENDIF

RETURN LOK

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION GETPLAN()

LOCAL CCADASTRO := "BUDGET"
LOCAL CARQ := ""
LOCAL NOPCA := 0

LOCAL ASAYS := {}
LOCAL ABUTTONS := {}

AADD(ASAYS,"ESTA ROTINA TEM POR OBJETIVO EFETUAR A IMPORTAÇÃO ")
AADD(ASAYS,"DE ARQUIVO .CSV DE BUDGET")

AADD(ABUTTONS,{14, .T. ,{||CARQ := CGETFILE("ARQUIVO CSV (*.CSV) | *.CSV|","",,, .F. ,48+0, .F. , .T. )}})
AADD(ABUTTONS,{1, .T. ,{||NOPCA := 1,FECHABATCH()}})
AADD(ABUTTONS,{2, .T. ,{||FECHABATCH()}})

FORMBATCH(CCADASTRO,ASAYS,ABUTTONS)

IF NOPCA==1

    IF EMPTY(CARQ)
        ALERT("ARQUIVO INVÁLIDO!.",FUNNAME())
    ENDIF
ELSE 

    ALERT(" IMPORTAÇÃO CANCELADA")
ENDIF

RETURN CARQ

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION PROCESSA(CARQ)

LOCAL LOK :=  .T. 
LOCAL NTDOC := 0

LOCAL NLINHA := 0

LOCAL ALINHA := {}

LOCAL CLINHA := ""
LOCAL CERRO := ""

CARQ := IIF(CARQ==NIL,"",CARQ)

IF !(EMPTY(CARQ))

    NTDOC := FT_FUSE(CARQ)

    IF NTDOC=- (1)
        LOK :=  .F. 
    ELSE 

        FT_FGOTOP()

        WHILE !(FT_FEOF())
        
            IF NLINHA==0
                FT_FSKIP()
            ENDIF

            ALINHA := {}

            CLINHA := FT_FREADLN()
            NLINHA++

            ALINHA := STRTOKARR2(CLINHA,";", .T. )

            IF !(IMPDADOS(ALINHA))
                CERRO +=  ALLTRIM(STR(NLINHA)) + CRLF
            ENDIF

            FT_FSKIP()
            ENDDO

        FCLOSE(NTDOC)
    ENDIF
ELSE 

    LOK :=  .F. 
ENDIF

ALERT("PLANILHA IMPORTADA COM SUCESSO!")

RETURN LOK

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION IMPDADOS(ALINHA)

LOCAL LRET :=  .T. 
LOCAL NTOTAL :=  VAL(ALINHA[4])
LOCAL NJAN :=  VAL(ALINHA[5])
LOCAL NFEV :=  VAL(ALINHA[6])
LOCAL NMAR :=  VAL(ALINHA[7])
LOCAL NABR :=  VAL(ALINHA[8])
LOCAL NMAI :=  VAL(ALINHA[9])
LOCAL NJUN :=  VAL(ALINHA[10])
LOCAL NJUL :=  VAL(ALINHA[11])
LOCAL NAGO :=  VAL(ALINHA[12])
LOCAL NSET :=  VAL(ALINHA[13])
LOCAL NOUT :=  VAL(ALINHA[14])
LOCAL NNOV :=  VAL(ALINHA[15])
LOCAL NDEZ :=  VAL(ALINHA[16])

LOCAL LSEEK := ""

ALINHA := IIF(ALINHA==NIL,{},ALINHA)

IF  LEN(ALINHA)>=0

    (SZA)->(DBSETORDER(1))
    LSEEK := (SZA)->(DBSEEK(XFILIAL("SZA")+PADR(ALINHA[2],TAMSX3("ZA_CCUSTO")[1])+PADR(ALINHA[3],TAMSX3("ZA_CONTAB")[1])+PADR(ALINHA[1],TAMSX3("ZA_ANOBUDT")[1])))

    IF LSEEK

        RECLOCK("SZA", .F. )
        SZA->ZA_BUDTOTA := NTOTAL
        SZA->ZA_VALJANE := NJAN
        SZA->ZA_VALFEVE := NFEV
        SZA->ZA_VALMARC := NMAR
        SZA->ZA_VALABRI := NABR
        SZA->ZA_VALMAIO := NMAI
        SZA->ZA_VALJUNH := NJUN
        SZA->ZA_VALJULH := NJUL
        SZA->ZA_VALAGOS := NAGO
        SZA->ZA_VALSETE := NSET
        SZA->ZA_VALOUTU := NOUT
        SZA->ZA_VALNOVE := NNOV
   SZA->ZA_VALDEZE := NDEZ
    ELSE 

        RECLOCK("SZA", .T. )
        SZA->ZA_FILIAL := XFILIAL("SZA")
        SZA->ZA_CCUSTO := ALINHA[2]
        SZA->ZA_CONTAB := ALINHA[3]
        SZA->ZA_ANOBUDT := ALINHA[1]
        SZA->ZA_BUDTOTA := NTOTAL
        SZA->ZA_VALJANE := NJAN
        SZA->ZA_VALFEVE := NFEV
        SZA->ZA_VALMARC := NMAR
        SZA->ZA_VALABRI := NABR
        SZA->ZA_VALMAIO := NMAI
        SZA->ZA_VALJUNH := NJUN
        SZA->ZA_VALJULH := NJUL
        SZA->ZA_VALAGOS := NAGO
        SZA->ZA_VALSETE := NSET
        SZA->ZA_VALOUTU := NOUT
        SZA->ZA_VALNOVE := NNOV
        SZA->ZA_VALDEZE := NDEZ
    ENDIF

    (SZA)->(MSUNLOCK())
ELSE 

    LRET :=  .F. 
ENDIF

RETURN LRET

