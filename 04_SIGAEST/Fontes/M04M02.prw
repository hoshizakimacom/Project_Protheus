#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"
#Include 'RptDef.ch'
#Include 'FWPrintSetup.ch

//Constantes
//#Define STR_PULA    Chr(13)+Chr(10)
User Function M04M02()

Local cPerg    := "M04M02"

ValidPerg(cPerg)
If Pergunte(cPerg)
    FWMsgRun(, {|| _lRet := U_M04M02Ger()},,'Gerando Estruturas.CSV ...')
Endif

Return

User Function M04M02Ger(dDataDe,nTipoVi)

Local nH
Local nQtde := 0
Local cArq  := Mv_par04

nH := fCreate(cArq)

If nH == -1
    MsgStop("Falha ao criar arquivo - Erro "+str(ferror()))
    Return
Endif

cQuery := "SELECT ZG1_COD PRODUTO, "
cQuery += " (SELECT MAX(B1_TIPO) FROM " + RetsqlName("SB1") + " SB1 WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = ZG1_COD AND D_E_L_E_T_ <> '*') TIPO_COD,
cQuery += " ZG1_COMP COMPONENTE, 
cQuery += " (SELECT MAX(B1_TIPO) FROM " + RetsqlName("SB1") + " SB1 WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = ZG1_COMP AND D_E_L_E_T_ <> '*') TIPO_COMP,
cQuery += " ZG1_QUANT QUANT"
cQuery += " FROM " + RetsqlName("ZG1") + " ZG1 "
cQuery += " WHERE ZG1_FILIAL = '"+xFilial("ZG1")+"' "
cQuery += " AND ZG1_DTINCL = '"+Dtos(mv_par01)+"' "
cQuery += " AND ZG1_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
cQuery += " AND LEFT(ZG1_COD,3) <> 'MO-'
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZG1_COD, ZG1_COMP "

TcQuery cQuery New Alias (cAlias := GetNextAlias())
(cAlias)->(DbEval({|| nQtde ++ }))
(cAlias)->(DbGoTop())
    
// Escreve o texto mais a quebra de linha CRLF
fWrite(nH,"Codigo;Tipo_Cod;Componente;Tipo_Comp;Quant"+ chr(13)+chr(10) )        

While ! (cAlias)->(Eof())

    //Criando as Linhas
    //fWrite(nH,"Segunda linha"+chr(13)+chr(10))
    fWrite(nH,  Alltrim((cAlias)->PRODUTO)+";"+;
                (cAlias)->TIPO_COD+";"+;
                Alltrim((cAlias)->COMPONENTE)+";"+;
                (cAlias)->TIPO_COMP+";"+;
                Transform((cAlias)->QUANT,"@E 999999999.999999")+ chr(13)+chr(10) )

    (cAlias)->(DbSkip())
Enddo

FWAlertInfo("Arquivo gerado com Sucesso : " + cArq, "Geração de arquivos")

(cAlias)->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ValidPerg º Autor ³ 				     º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg(c_Perg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := PADR(c_Perg,Len(SX1->X1_GRUPO))

//              Grupo /Ordem /Pergunta               /PERSPA  / PERENG/Variavel/Tipo   /Tamanho  /Decimal/Presel /GSC /Valid/Var01      /Def01      /DEFSPA1 /DEFENG1 /Cnt01 /Var02     /Def02           /DEFSPA2 /DEFENG2 /Cnt02 /Var03     /Def03          /DEFSPA3 /DEFENG3 /Cnt03 /Var04     /Def04          /DEFSPA4 /DEFENG4 /Cnt04 /Var05     /Def05          /DEFSPA5/DEFENG5  /Cnt05 /F3   /PYME/GRPSXG
Aadd(aRegs,{c_Perg,"01","Data Referencia ?"	    ,"","","mv_ch1","D",08,0,0,"G","",	"MV_PAR01","",	"","","",	"","",	"","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{c_Perg,"02","Do Produto ?"	        ,"","","mv_ch2","C",15,0,0,"G","",	"MV_PAR02","",	"","","",	"","",	"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{c_Perg,"03","Ate o Produto ?"       ,"","","mv_ch3","C",15,0,0,"G","",	"MV_PAR03","",	"","","",	"","",	"","","","","","","","","","","","","","","","","","","SB1","","","","" })
Aadd(aRegs,{c_Perg,"04","Local/Arquivo .CSV ?"  ,"","","mv_ch4","C",50,0,0,"G","",	"MV_PAR04","",	"","","",	"","",	"","","","","","","","","","","","","","","","","","","","","","","" })

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf	
Next

dbSelectArea(_sAlias)

Return Nil
