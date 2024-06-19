User Function TITICMST

Local cOrigem  := PARAMIXB[1]
Local cTipoImp := PARAMIXB[2]
Local lDifal   := PARAMIXB[3]

//EXEMPLO 1 (cOrigem)
/*/
If AllTrim(cOrigem)='MATA954' //Apuracao de ISS
    SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
    SE2->E2_VENCTO := DataValida(dDataBase+30,.T.)
    SE2->E2_VENCREA := DataValida(dDataBase+30,.T.)
    SE2->E2_NATUREZ := 'EXEMPLO1'
EndIf
/*/

//EXEMPLO 2 (cTipoImp)
If AllTrim(cTipoImp)='1' // ICMS ST
    //SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
    SE2->E2_VENCTO  := DataValida(SE2->E2_EMISSAO,.T.)
    SE2->E2_VENCREA := DataValida(SE2->E2_EMISSAO,.T.)
    //SE2->E2_NATUREZ := 'EXEMPLO2'
EndIf

//EXEMPLO 3 (lDifal)
If lDifal // DIFAL
    //SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
    SE2->E2_VENCTO  := DataValida(SE2->E2_EMISSAO,.T.)
    SE2->E2_VENCREA := DataValida(SE2->E2_EMISSAO,.T.)
    //SE2->E2_NATUREZ := 'EXEMPLO3'
EndIf
  
Return {SE2->E2_NUM,SE2->E2_VENCTO}
