#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICONN.CH"
 
User Function M10A05()
 
Local PARAMIXB1 := {}
Local PARAMIXB2 := {}
Local aGets     := {}
Local lOK       := .T.
Local cString   := ''
 
Private lMsErroAuto := .F.
 
Default PARAMIXB3 := 4
 
//------------------------//| Abertura do ambiente |//----------------------------
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "PCP" TABLES "SB1","SG1","SG5"
ConOut(Repl("-",80))
ConOut(PadC("Teste de rotina automatica para estrutura de produtos",80))
//------------------------//| Teste de Inclusao |//-------------------------------
 
dbSelectArea("SB1")
dbSetOrder(1)
 
If !SB1->(MsSeek(xFilial("SB1")+"11728607ME"))
    lOk := .F.
    ConOut("Cadastrar produto acabado: 11728607ME")
EndIf
 
If !SB1->(MsSeek(xFilial("SB1")+"CHI304022-01"))
    lOk := .F.
    ConOut("Cadastrar produto intermediario: CHI304022-01")
EndIf
 
If PARAMIXB3==4
    PARAMIXB1 := {  {"G1_COD","11728607ME",NIL},;
                    {"G1_QUANT",1,NIL},;
                    {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
    aGets := {}
    aadd(aGets,{"G1_COD","11728607ME",NIL})
    aadd(aGets,{"G1_COMP","CHI304022-01",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",3.1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    
 
    If lOk
        ConOut("Teste de Inclusao")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)
        //Inclusao
        ConOut("Fim: "+Time())
    EndIf
Else
    //--------------- Exemplo de Exclusao ------------------------------------
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('11728607ME',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","11728607ME",NIL},;
        {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo 11728607ME")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)
        //Exclusao
        lOk := !lMsErroAuto
        ConOut("Fim: "+Time())
    EndIf
 
    If lOk
        SG1->(dbSetOrder(1))
        SG1->(dbSeek(xFilial("SG1")+PadR('CHI304022-01',Len(SG1->G1_COD))))
        PARAMIXB1 := {{"G1_COD","CHI304022-01",NIL},; 
        {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular
        // ou nao a estrutura
        ConOut("Teste de Exclusao do codigo CHI304022-01")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)
        //Exclusao
        lOk := !lMsErroAuto
        ConOut("Fim: "+Time())
    EndIf
 
    If lMsErroAuto
        If IsBlind()
            If IsTelnet()
                VTDispFile(NomeAutoLog(),.t.)
            Else
                cString := MemoRead(NomeAutoLog())
                Aviso("Aviso de Erro:",cString)
            EndIf
        Else
            MostraErro()
        EndIf
    Else
        If lOk
            Aviso("Aviso","Operacao efetuada com sucesso",{"Ok"})
        Else
            Aviso("Aviso","Fazer os devidos cadastros",{"Ok"})
        EndIf
    Endif
Endif
 
Return
