#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
USER FUNCTION M06A13()

LOCAL ASIZE := {}
LOCAL ACAMPOS := {}
LOCAL CALIAS := ""
LOCAL CCPOOK := ""
LOCAL ODLG := NIL
LOCAL OMAINWND := NIL
LOCAL NOPCAO := 0
LOCAL LINVERTE :=  .F. 
LOCAL CPERG := "FIN980"
LOCAL CMARCA := GETMARK()
Local cAliasX3 := GetNextAlias()
Local _cQry := ""

PRIVATE OMARK := NIL

IF !(PERGUNTE(CPERG, .T. ))
    RETURN NIL
ENDIF

IF MV_PAR03==1
    CALIAS := "SE2"
    CCPOOK := "E2_OK"
ELSE 
    CALIAS := "SE1"
    CCPOOK := "E1_OK"
ENDIF

F980GERTMP(CALIAS)
DBSELECTAREA(CALIAS)

IF (CALIAS)->(EOF())
    MSGINFO("NÃO EXISTEM DADOS A SEREM EXIBIDOS. VERIFIQUE AS INFORMAÇÕES NECESSÁRIAS PARA CONFIGURAÇÃO DOS PARÂMETROS.","ATENÇÃO")
ELSE 
    cMvCampo := IIF(MV_PAR03==1,"E2_FILIAL","E1_FILIAL")
    AADD(ACAMPOS,{CCPOOK,"","  ",""})
    IF (!(EMPTY(FWFILIAL(CALIAS)))) .OR. (X3USO(GetSX3Cache(cMvCampo, "X3_USADO")) .AND. CNIVEL>=GetSX3Cache(cMvCampo, "X3_NIVEL"))
        AADD(ACAMPOS,{cMvCampo,"", ALLTRIM(GetSX3Cache(cMvCampo, "X3_TITULO")),GetSX3Cache(cMvCampo, "X3_PICTURE")})
        SX3->(DBSKIP())
    ENDIF

    _cQry += " SELECT X3_CAMPO X7CAMPO,X3_USADO X3_USADO, X3_NIVEL X3NIVEL, X3_TITULO X3TITULO, X3_PICTURE X3PICTURE, X3_CONTEXT X3CONTEXT "
    _cQry += " FROM " + RetSQLName("SX3") + " SX3 "
    _cQry += " WHERE    SX3.D_E_L_E_T = ' ' AND X3_ARQUIVO = '"+CALIAS+"' "

    If Select(cAliasX3) > 0
        DBSelectArea(cAliasX3)
        (cAliasX3)->(DbCloseArea())
    EndIf

    DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), cAliasX3, .T., .T.)

    DBSelectArea(cAliasX3)
    While !(cAliasX3)->(EOF())

        IF X3USO(cAliasX3->X3USADO) .AND. CNIVEL>=cAliasX3->X3NIVEL .AND. cAliasX3->X3CONTEXT<>"V"
            AADD(ACAMPOS,{cAliasX3->X3CAMPO,"", ALLTRIM(cAliasX3->X3TITULO),cAliasX3->X3PICTURE})
        ENDIF

        (cAliasX3)->(dbSkip())
    EndDo
    /*DBSELECTAREA("SX3")
    SX3->(DBSETORDER(1))
    SX3->(DBSEEK(CALIAS))

    IF (!(EMPTY(FWFILIAL(CALIAS)))) .OR. (X3USO(X3_USADO) .AND. CNIVEL>=X3_NIVEL)
        AADD(ACAMPOS,{X3_CAMPO,"", ALLTRIM(X3TITULO()),X3_PICTURE})
        SX3->(DBSKIP())
    ENDIF

    WHILE !(EOF()) .AND. X3_ARQUIVO==CALIAS
    
        IF X3USO(X3_USADO) .AND. CNIVEL>=X3_NIVEL .AND. X3_CONTEXT<>"V"
            AADD(ACAMPOS,{X3_CAMPO,"", ALLTRIM(X3TITULO()),X3_PICTURE})
        ENDIF
        SX3->(DBSKIP())
    ENDDO*/

    DBSELECTAREA(CALIAS)
    (CALIAS)->(DBGOTOP())

    BOK1 := {||F980NATUR(CALIAS,CMARCA,CCPOOK),ODLG:END(),(CALIAS)->(DBCLOSEAREA())}
    BOK2 := {||ODLG:END,(CALIAS)->(DBCLOSEAREA)}

    ASIZE := MSADVSIZE()
    ODLG := MSDIALOG():NEW(ASIZE[7],0,ASIZE[6],ASIZE[5],"RECLASSIFICAÇÃO DE NATUREZA FINANCEIRA",,, .F. ,,,,,OMAINWND, .T. ,,, .F. )
    ODLG:LMAXIMIZED :=  .T. 

    OMARK := MSSELECT():NEW(CALIAS,CCPOOK,,ACAMPOS,@LINVERTE,@CMARCA,{50,ODLG:NLEFT,ODLG:NBOTTOM,ODLG:NRIGHT})
    OMARK:OBROWSE:ALIGN := 5

    OMARK:BAVAL := {||F980MARK(CALIAS,CCPOOK,CMARCA)}
    OMARK:OBROWSE:LHASMARK :=  .T. 
    OMARK:OBROWSE:LCANALLMARK :=  .T. 
    OMARK:OBROWSE:BALLMARK := {||F980INVERT(CMARCA,CALIAS,CCPOOK)}
    OMARK:OBROWSE:ALIGN := 5

    ODLG:ACTIVATE(ODLG:BLCLICKED,ODLG:BMOVED,ODLG:BPAINTED, .T. ,,,{|SELF|ENCHOICEBAR(ODLG,{||IIF(F980VLDMRK(CALIAS,CMARCA,CCPOOK),EVAL(BOK1),)},{||EVAL(BOK2)},,)},ODLG:BRCLICKED,)
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980GERTMP(CALIAS)

LOCAL CDATAINI := ""
LOCAL CDATAFIM := ""
LOCAL CFILTRO := ""
LOCAL CCHAVE := ""
LOCAL NCARTEIRA := MV_PAR03
LOCAL CNATURINI := MV_PAR04
LOCAL CNATURFIM := MV_PAR05
LOCAL CINDEX := CRIATRAB(NIL, .F. )

CDATAINI := STR(YEAR(MV_PAR01),4)+ STRZERO(MONTH(MV_PAR01),2)+ STRZERO(DAY(MV_PAR01),2)
CDATAFIM := STR(YEAR(MV_PAR02),4)+ STRZERO(MONTH(MV_PAR02),2)+ STRZERO(DAY(MV_PAR02),2)

IF NCARTEIRA==1

    CFILTRO := 'E2_FILIAL == "'+XFILIAL("SE2")+'" .AND. '
    CFILTRO += '(DTOS(E2_EMISSAO) >= "'+CDATAINI+'" .AND. DTOS(E2_EMISSAO) <= "'+CDATAFIM+'") .AND. '
    CFILTRO += '(E2_NATUREZ >= "'+CNATURINI+'" .AND. E2_NATUREZ <= "'+CNATURFIM+'") .AND. '
    CFILTRO += '!(E2_TIPO $ "'+MVABATIM+"|"+MVTAXA+"|"+MVTXA+"|"+MVINSS+"|"+'SES|CID")'

    CCHAVE := "E2_FILIAL+E2_EMISSAO"
ELSE 

    CFILTRO := 'E1_FILIAL == "'+XFILIAL("SE1")+'" .AND. '
    CFILTRO += '(DTOS(E1_EMISSAO) >= "'+CDATAINI+'" .AND. DTOS(E1_EMISSAO) <= "'+CDATAFIM+'") .AND. '
    CFILTRO += '(E1_NATUREZ >= "'+CNATURINI+'" .AND. E1_NATUREZ <= "'+CNATURFIM+'") .AND. '
    CFILTRO += '!(E1_TIPO $ "'+MVABATIM+"|"+MVINABT+"|"+MVIRABT+"|"+MVCSABT+"|"+MVCFABT+"|"+MVPIABT+'")'

    CCHAVE := "E1_FILIAL+E1_EMISSAO"
ENDIF

DBSELECTAREA(CALIAS)
CCHAVE := INDEXKEY()
INDREGUA(CALIAS,CINDEX,CCHAVE,,CFILTRO,"AGUARDE...")
NINDEX := RETINDEX(CALIAS)
(CALIAS)->(DBSETORDER(NINDEX+1))

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980VLDMRK(CALIAS,CMARCA,CCPOOK)

LOCAL LRETURN :=  .F. 
LOCAL AAREAALIAS := {}

DBSELECTAREA(CALIAS)
AAREAALIAS := (CALIAS)->(GETAREA())

(CALIAS)->(DBGOTOP())

WHILE !((CALIAS)->(EOF()))
 
    IF (CALIAS)->(&CCPOOK)==CMARCA
        LRETURN :=  .T. 
        EXIT 
    ENDIF

    (CALIAS)->(DBSKIP())
    ENDDO

IF !(LRETURN)
    MSGALERT(IIF((CPAISLOC) $ ("ANG|PTG"),"SELECCIONE AO MENOS UM TÍTULO PARA O PROCESSAMENTO DA RECLASSIFICAÇÃO.","SELECIONE AO MENOS UM TÍTULO PARA O PROCESSAMENTO DA RECLASSIFICAÇÃO."),"ATENÇÃO")
ENDIF

RESTAREA(AAREAALIAS)

RETURN LRETURN

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980NATUR(CALIAS,CMARCA,CCPOOK)

LOCAL ODLG2 := NIL
LOCAL OMEMO := NIL
LOCAL BPROCES := NIL
LOCAL LPROC :=  .F. 
LOCAL APROCES := {}
LOCAL CNATUREZA := CRIAVAR("ED_CODIGO", .F. )
LOCAL CTEXTO := ""
LOCAL NX := 0

ODLG2 := MSDIALOG():NEW(15,6,100,350,IIF((CPAISLOC) $ ("ANG|PTG"),"SELECCIONE A NATUREZA","SELECIONE A NATUREZA"),,, .F. ,,,,,, .T. ,,, .F. )

BPROCES := {||F980PROC(CNATUREZA,@LPROC,@APROCES,CALIAS,CMARCA,CCPOOK),ODLG2:END()}
ODLG2:LMAXIMIZED :=  .F. 

TSAY():NEW(10,15,{||"NATUREZA:"},ODLG2,,, .F. , .F. , .F. , .T. ,16711680,,23,7, .F. , .F. , .F. , .F. , .F. , .F. )
TGET():NEW(10,50,{ | U |IIF(PCOUNT()==0,CNATUREZA,CNATUREZA := U)},ODLG2,60,10,"@!",{||F980VLDNAT(CNATUREZA)},,,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F. ,"SED","CNATUREZA",,,, .T. )

SBUTTON():NEW(10,120,1,{||EVAL(BPROCES)},ODLG2, .T. ,,)

ODLG2:ACTIVATE(ODLG2:BLCLICKED,ODLG2:BMOVED,ODLG2:BPAINTED, .T. ,,,,ODLG2:BRCLICKED,)

IF  LEN(APROCES)>0

    IF MV_PAR03==1

        CTEXTO := "TITULOS A PAGAR" + CRLF
        CTEXTO += "---------------------------------------------------------------" + CRLF

        CTEXTO += PADR("PRF",TAMSX3("E2_PREFIXO")[1]+1," ")
        CTEXTO += PADR(IIF((CPAISLOC) $ ("ANG|PTG"),"NR.","NUM"),TAMSX3("E2_NUM")[1]+2," ")
        CTEXTO += PADR("PC",TAMSX3("E2_PARCELA")[1]+2," ")
        CTEXTO += PADR("TP",TAMSX3("E2_TIPO")[1]+4," ")
        CTEXTO += PADR(IIF((CPAISLOC) $ ("ANG|PTG"),"FORN.","FORN"),TAMSX3("E2_FORNECE")[1]+1," ")
        CTEXTO += PADR(IIF((CPAISLOC) $ ("ANG|PTG"),"LJ.","LJ"),TAMSX3("E2_LOJA")[1]+3," ")
        CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"ESTADO","STATUS") + CRLF

    ELSEIF MV_PAR03=2

        CTEXTO := "TITULOS A RECEBER" + CRLF
        CTEXTO += "---------------------------------------------------------------" + CRLF

        CTEXTO += PADR("PRF",TAMSX3("E1_PREFIXO")[1]+1," ")
        CTEXTO += PADR(IIF((CPAISLOC) $ ("ANG|PTG"),"NR.","NUM"),TAMSX3("E1_NUM")[1]+2," ")
        CTEXTO += PADR("PC",TAMSX3("E1_PARCELA")[1]+2," ")
        CTEXTO += PADR("TP",TAMSX3("E1_TIPO")[1]+4," ")
        CTEXTO += PADR("CLT",TAMSX3("E1_CLIENTE")[1]+1," ")
        CTEXTO += PADR(IIF((CPAISLOC) $ ("ANG|PTG"),"LJ.","LJ"),TAMSX3("E1_LOJA")[1]+3," ")
        CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"ESTADO","STATUS") + CRLF
    ENDIF

    CTEXTO += "---------------------------------------------------------------" + CRLF

    FOR NX := 1 TO  LEN(APROCES)

        CTEXTO += APROCES[NX][1]+"-"+APROCES[NX][2]+"  "+APROCES[NX][3]+"  "+APROCES[NX][4]+"    "+APROCES[NX][5]+" "+APROCES[NX][6]

        IF APROCES[NX][7]=="0"
            CTEXTO += " - "+"NÃO PROCESSADO" + CRLF
        ELSE 
            CTEXTO += " - "+"PROCESSADO" + CRLF
        ENDIF
    NEXT

    CTEXTO += CHR(13)+CHR(10)+"---------------------------------------------------------------" + CRLF
    CTEXTO += " "
    CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"ATENÇÃO: OS REGISTOS NÃO PROCESSADOS POSSUEM NATUREZAS QUE NÃO CONDIZEM COM A INFORMADA.","ATENÇÃO: OS REGISTROS NÃO PROCESSADOS POSSUEM NATUREZAS QUE NÃO CONDIZEM COM A INFORMADA.")
    CTEXTO += " "
    CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"VERIFIQUE UMA NATUREZA COMPATÍVEL ANTES DA SELECÇÃO.","VERIFIQUE UMA NATUREZA COMPATÍVEL ANTES DA SELEÇÃO.")

    OFONT := TFONT():NEW("MONO AS",6,15, .F. ,,,,,,,,,,,,)
    ODLG2 := MSDIALOG():NEW(3,0,340,417,IIF((CPAISLOC) $ ("ANG|PTG"),"REGISTOS PROCESSADOS","REGISTROS PROCESSADOS"),,, .F. ,,,,,, .T. ,,, .F. )
    OMEMO := TMULTIGET():NEW(5,5,{ | U |IIF(PCOUNT()==0,CTEXTO,CTEXTO := U)},ODLG2,200,145,, .F. ,,,, .T. ,, .F. ,, .F. , .F. , .F. ,,, .F. ,,)
    OMEMO:BRCLICKED := {||ALLWAYSTRUE()}
    OMEMO:OFONT := OFONT

    PIXEL := SBUTTON():NEW(153,175,1,{||ODLG2:END()},ODLG2, .T. ,,)

    ODLG2:ACTIVATE(ODLG2:BLCLICKED,ODLG2:BMOVED,ODLG2:BPAINTED, .T. ,,,,ODLG2:BRCLICKED,)
ELSE 

    CTEXTO := IIF((CPAISLOC) $ ("ANG|PTG"),"NENHUM REGISTO FOI PROCESSADO","NENHUM REGISTRO FOI PROCESSADO.") + CRLF
    CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"A NATUREZA E/OU TÍTULOS SELECCIONADOS NÃO SÃO EQUIVALENTES","A NATUREZA E/OU TÍTULOS SELECIONADOS NÃO SÃO EQUIVALENTES") + CRLF
    CTEXTO += IIF((CPAISLOC) $ ("ANG|PTG"),"OU O PROCESSO FOI INTERROMPIDO PELO UTILIZADOR.","OU O PROCESSO FOI INTERROMPIDO PELO USUÁRIO.") + CRLF

    MSGINFO(CTEXTO,"ATENÇÃO")
ENDIF

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980PROC(CNATUREZA,LPROC,APROCES,CALIAS,CMARCA,CCPOOK)

LOCAL ACONFNAT := {}
LOCAL AREGISTRO := {}

LOCAL NX := 0
LOCAL NCARTEIRA := MV_PAR03

LOCAL CCPONAT := ""
LOCAL CCPOSOUT := "APURPIS|APURCOF|PCAPPIS|PCAPCOF|IRRFCAR|INSSCAR"
LOCAL CCAMPO := ""

LOCAL LNATVLD :=  .T. 

LOCAL CNATORIG := ""
LOCAL CPREFORIG := ""
LOCAL CNUMORIG := ""
LOCAL CPARCORIG := ""
LOCAL CTIPORIG := ""
LOCAL CCFORIG := ""
LOCAL CLOJORIG := ""

LOCAL CFILTRO := ""
LOCAL NRECNO := ""
LOCAL AAREA := {}
Local cAliasX3 := GetNextAlias()
Local _cQry := ""

CNATUREZA := IIF(VALTYPE(CNATUREZA)=="U","",CNATUREZA)
CALIAS := IIF(VALTYPE(CALIAS)=="U","",CALIAS)
CMARCA := IIF(VALTYPE(CMARCA)=="U","",CMARCA)
CCPOOK := IIF(VALTYPE(CCPOOK)=="U","",CCPOOK)
APROCES := IIF(VALTYPE(APROCES)=="U",{},APROCES)
LPROC := IIF(VALTYPE(LPROC)=="U", .F. ,LPROC)

    _cQry += " SELECT X3_CAMPO X3CAMPO,X3_USADO X3_USADO, X3_NIVEL X3NIVEL, X3_TITULO X3TITULO, X3_PICTURE X3PICTURE, X3_CONTEXT X3CONTEXT "
    _cQry += " FROM " + RetSQLName("SX3") + " SX3 "
    _cQry += " WHERE    SX3.D_E_L_E_T = ' ' AND X3_ARQUIVO = 'SED' "

    If Select(cAliasX3) > 0
        DBSelectArea(cAliasX3)
        (cAliasX3)->(DbCloseArea())
    EndIf

    DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), cAliasX3, .T., .T.)

    DBSelectArea(cAliasX3)
    While !(cAliasX3)->(EOF())
        IF X3USO(cAliasX3->X3USADO) .AND. CNIVEL>=cAliasX3->X3NIVEL .AND. cAliasX3->X3CONTEXT<>"V" .AND. ((( SUBSTR(cAliasX3->X3CAMPO,4,4)) $ ("CALC|PERC|BASE")) .OR. (( SUBSTR(cAliasX3->X3CAMPO,4,3)=="DED") .OR. (( SUBSTR(cAliasX3->X3CAMPO,4,7)) $ (CCPOSOUT))))
            AADD(ACONFNAT,{cAliasX3->X3CAMPO,CRIAVAR(cAliasX3->X3CAMPO, .F. )})
        ENDIF
    End
/*DBSELECTAREA("SX3")
SX3->(DBSETORDER(1))
SX3->(DBSEEK("SED"))

AADD(ACONFNAT,{"ED_FILIAL",CRIAVAR("ED_FILIAL", .F. )})

WHILE !(EOF()) .AND. X3_ARQUIVO=="SED"
 
    IF X3USO(X3_USADO) .AND. CNIVEL>=X3_NIVEL .AND. X3_CONTEXT<>"V" .AND. ((( SUBSTR(X3_CAMPO,4,4)) $ ("CALC|PERC|BASE")) .OR. (( SUBSTR(X3_CAMPO,4,3)=="DED") .OR. (( SUBSTR(X3_CAMPO,4,7)) $ (CCPOSOUT))))
        AADD(ACONFNAT,{X3_CAMPO,CRIAVAR(X3_CAMPO, .F. )})
    ENDIF
    SX3->(DBSKIP())
ENDDO**/

DBSELECTAREA("SED")
SED->(DBSETORDER(1))

IF SED->(DBSEEK(XFILIAL("SED")+CNATUREZA))

    FOR NX := 1 TO  LEN(ACONFNAT)
        CCAMPO := ACONFNAT[NX][1]
        ACONFNAT[NX][2] := SED->(&CCAMPO)
    NEXT
ENDIF

IF NCARTEIRA==1
    CCPONAT := "E2_NATUREZ"
ELSEIF NCARTEIRA==2
    CCPONAT := "E1_NATUREZ"
ENDIF

DBSELECTAREA(CALIAS)
(CALIAS)->(DBGOTOP())

WHILE !((CALIAS)->(EOF()))
 
    INCPROC("PROCESSANDO...")

    IF (CALIAS)->(&CCPOOK)==CMARCA

        IF NCARTEIRA==1
  CNATORIG := CALIAS->E2_NATUREZ
            CPREFORIG := CALIAS->E2_PREFIXO
            CNUMORIG := CALIAS->E2_NUM
            CPARCORIG := CALIAS->E2_PARCELA
            CTIPORIG := CALIAS->E2_TIPO
            CCFORIG := CALIAS->E2_FORNECE
            CLOJORIG := CALIAS->E2_LOJA

        ELSEIF NCARTEIRA==2
            CNATORIG := CALIAS->E1_NATUREZ
            CPREFORIG := CALIAS->E1_PREFIXO
            CNUMORIG := CALIAS->E1_NUM
            CPARCORIG := CALIAS->E1_PARCELA
            CTIPORIG := CALIAS->E1_TIPO
            CCFORIG := CALIAS->E1_CLIENTE
            CLOJORIG := CALIAS->E1_LOJA
        ENDIF

        IF SED->(DBSEEK(XFILIAL("SED")+CNATORIG))

            FOR NX := 1 TO  LEN(ACONFNAT)
                CCAMPO := ACONFNAT[NX][1]
                
                IF SED->(&CCAMPO)<>ACONFNAT[NX][2]
                    LNATVLD :=  .F. 
                    EXIT 
                ENDIF
            NEXT
        ENDIF

        AREGISTRO := ARRAY(7)

AREGISTRO[1] := CPREFORIG
        AREGISTRO[2] := CNUMORIG
        AREGISTRO[3] := CPARCORIG
        AREGISTRO[4] := CTIPORIG
        AREGISTRO[5] := CCFORIG
        AREGISTRO[6] := CLOJORIG

        IF LNATVLD

            RECLOCK(CALIAS, .F. )
            (CALIAS)->(&CCPONAT) := CNATUREZA
            (CALIAS)->(MSUNLOCK())

            DBSELECTAREA("SE5")
            SE5->(DBSETORDER(7))

            IF SE5->(DBSEEK(XFILIAL("SE5")+CPREFORIG+CNUMORIG+CPARCORIG+CTIPORIG+CCFORIG+CLOJORIG))

                WHILE !(SE5->(EOF())) .AND. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==XFILIAL("SE5")+CPREFORIG+CNUMORIG+CPARCORIG+CTIPORIG+CCFORIG+CLOJORIG
                
                    IF SE5->E5_NATUREZ<>CNATUREZA
                        RECLOCK("SE5", .F. )
                        SE5->E5_NATUREZ := CNATUREZA
                        SE5->(MSUNLOCK())
                    ENDIF

                    SE5->(DBSKIP())
                    ENDDO
            ENDIF

            DBSELECTAREA(CALIAS)
            AAREA := (CALIAS)->(GETAREA())
            NRECNO := (CALIAS)->(RECNO())
            CFILTRO := (CALIAS)->(DBFILTER())

            IF NCARTEIRA==1
                (CALIAS)->(DBSETORDER(6))
            ELSEIF NCARTEIRA==2
                (CALIAS)->(DBSETORDER(2))
            ENDIF

            (CALIAS)->(DBCLEARFILTER())

            IF (CALIAS)->(DBSEEK(XFILIAL(CALIAS)+CCFORIG+CLOJORIG+CPREFORIG+CNUMORIG+CPARCORIG+"AB-"))
                
                IF (CALIAS)->(&CCPONAT)==CNATORIG

                    RECLOCK(CALIAS, .F. )
                    (CALIAS)->(&CCPONAT) := CNATUREZA
                    (CALIAS)->(MSUNLOCK())
                ENDIF
            ENDIF

            IF (EMPTY(CFILTRO)) 
            DBCLEARFILTER()
            ELSE
            DBSETFILTER({||&CFILTRO},CFILTRO)
            ENDIF
            RESTAREA(AAREA)

            AREGISTRO[7] := "1"
        ELSE 

            AREGISTRO[7] := "0"
        ENDIF

        AADD(APROCES,AREGISTRO)
        LNATVLD :=  .T. 
    ENDIF

    (CALIAS)->(DBSKIP())
    ENDDO

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980INVERT(CMARCA,CALIAS,CCAMPO)

LOCAL NREG := (CALIAS)->(RECNO())

DBSELECTAREA(CALIAS)
(CALIAS)->(DBGOTOP())

WHILE !(EOF())
 
    RECLOCK(CALIAS, .F. )
    
    IF (CALIAS)->(&CCAMPO)==CMARCA
        (CALIAS)->(&CCAMPO) := "  "
    ELSE 
        (CALIAS)->(&CCAMPO) := CMARCA
    ENDIF
    (CALIAS)->(MSUNLOCK())
    (CALIAS)->(DBSKIP())
    ENDDO

(CALIAS)->(DBGOTO(NREG))

OMARK:OBROWSE:REFRESH( .T. )

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980MARK(CALIAS,CCAMPO,CMARCA)

LOCAL NREG := (CALIAS)->(RECNO())

DBSELECTAREA(CALIAS)

RECLOCK(CALIAS, .F. )
IF (CALIAS)->(&CCAMPO)<>CMARCA
    (CALIAS)->(&CCAMPO) := CMARCA
ELSE 
    (CALIAS)->(&CCAMPO) := ""
ENDIF
(CALIAS)->(MSUNLOCK())

OMARK:OBROWSE:REFRESH( .T. )

RETURN 

/////////////////////////////////////////////////////////////
// FONTE RECONSTRUIDO PELO TIME BSO ********************** //
/////////////////////////////////////////////////////////////
STATIC FUNCTION F980VLDNAT(CNATUREZA)

LOCAL LRETURN :=  .T. 
LOCAL ARESERV := {}

LOCAL NX := 0

IF EMPTY(CNATUREZA)
    MSGSTOP("INFORME UMA NATUREZA ANTES DE CONFIRMAR O PROCESSAMENTO.","ATENÇÃO")
    LRETURN :=  .F. 
ELSEIF !(EXISTCPO("SED",CNATUREZA))
    LRETURN :=  .F. 
ELSE 
    DBSELECTAREA("SED")
    SED->(DBSETORDER(1))
    
    AADD(ARESERV,STRTRAN(GETMV("MV_CIDE"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_COFINS"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_PISNAT"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_CSLL"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_INSS"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_IRF"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_ISS"),'"'))
    AADD(ARESERV,STRTRAN(GETMV("MV_SEST"),'"'))
    
    IF SED->(DBSEEK(XFILIAL("SED")+CNATUREZA))
        FOR NX := 1 TO  LEN(ARESERV)
            
            IF  ALLTRIM(SED->ED_CODIGO)== ALLTRIM(ARESERV[NX])
                MSGINFO(IIF((CPAISLOC) $ ("ANG|PTG"),"A NATUREZA INFORMADA É DE USO EXCLUSIVO DO SISTEMA OU NÃO PODE SER UTILIZADA POR ESTE PROCEDIMENTO.","A NATUREZA INFORMADA É DE USO EXCLUSIVO DO SISTEMA OU NÃO PODE SER UTILIZADA POR ESTA ROTINA."),"ATENÇÃO")
                LRETURN :=  .F. 
                EXIT 
            ENDIF
        NEXT
    ENDIF
ENDIF

RETURN LRETURN
