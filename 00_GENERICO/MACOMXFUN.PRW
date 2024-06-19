#Include "Totvs.ch"

//#DEFINE cSpecialCharacters (('";<;>;&;};{;´;`;*;%;$;#;@;!;/;*;|') + (";';+;¨;¬"))
#DEFINE cSpecialCharacters (('";<;>;&;};{;*;%;$;#;@;!;*;|') + (";';+;¨;¬")) // #4711 - Retirado / ´ `

/*/{Protheus.doc} MACOMXFUN
Função genérica 

@type function
@author	Jorge Heitor T. de Oliveira
@since 20/06/2023
@version P12
@database MSSQL

@history Fonte para contemplar funções genéricas utilizadas em diversos propósitos

/*/
User Function MACOMXFUN()

Return Nil

/*
    Função para remover caracteres especiais de uma string de Campos em MVC (Utilizar na validação do campo)
*/
User Function ClearText()
    Local cVariable     as character
    Local cField        as character
    Local bBlock        as block
    Local aCharacters   as array
    Local lNoMVC        as logical
    Local lReturn       as logical
    Local cString       := ""
    
    lNoMVC := (FWModelActive() == Nil)
    cVariable := ReadVar()
    cField := SubString(cVariable,At(">",cVariable)+1,Len(cVariable))
    If lNoMVC
        cString := &(cVariable)

    Else
        cString := FWFldGet(cField)
    EndIf
    
    // Tratamento - 29/08/23 #4358
    If cString == Nil
        Return .T.
    Else
        cString := AllTrim(cString)
    EndIf

    bBlock := {|char| cString := StrTran(cString,char,"")}
    aCharacters := Separa(cSpecialCharacters, ";")
    lReturn := .T.

    //Processa substituições
    aEval(aCharacters, bBlock)

    //Atualiza campo lido no "Valid"
    If lNoMVC
        &(cVariable) := FwNoAccent(cString)
    
    Else
        FWFldPut(cField,FwNoAccent(cString))

    EndIf

Return lReturn

/*
    Função para utilizar os tipo de vendas cadastrados no campo C5_XTPVEN
    exemplo: 1=Projeto;2=V.Unit.;3=Dealer;4=E-Commerce;5=P.Entrega;6=Proj.Dealer;7=Vnda Pecas;8=Sup.Tec.;9=ARE;10=Serv;11=Itens Falta;12=SAC 
*/

//U_BusTpVen(cTpVen)

User Function BusTpVen(cTpVen,cCampo)

Local aArea      := GetArea()
Local aAreaSX3   := SX3->(GetArea())
Local cDescTpVen := Space(10)

dbSelectArea("SX3")
dbSetOrder(2)
If SX3->(MsSeek(cCampo))
	cCombo := SX3->( X3CBox() )
	aCombo := StrTokArr ( cCombo , ';' )

    //1=Venda;2=Entrega
    nPos := Ascan(aCombo,{|X| Left(X[1],2) == cTpVen })
    If nPosArr <> 0
        cDescTpVen := aCombo[nPosArr]
    EndIf
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return(cDescTpVen)
