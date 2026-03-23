/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M05A42   ³ Autor ³ Wallace Manzini      ³ Data ³ 30/07/25 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funções Complementares - Numeração Abetura de OP WIP       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAEST - MATA650                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

User Function M04M14()

	Local aArea	    := FWGetArea()
	Local cSeqAtu	:= ""
    Local cTpProd   := SC2->C2_XAVULSA
	
//Busca Sequencia Atual
	cSeqAtu 	:= GetMV("AM_SQSC2")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd == "1" .and. Empty(cSeqAtu)
		cSeqAtu		:= "PR0000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu		:= Soma1(cSeqAtu)
	
//Atualiza o Parâmetro
	PutMV("AM_SQSC2", cSeqAtu)

	FWRestArea(aArea)
Return cSeqAtu


//Troca para a sequência das OPs de Beneficiamento

User Function M04M14A()

	Local aArea2	    := FWGetArea()
	Local cSeqAtu2		:= ""
    Local cTpProd2		:= SC2->C2_XBENEF

//Busca Sequencia Atual
	cSeqAtu2 	:= GetMV("AM_SQBNF")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd2 == "1" .and. Empty(cSeqAtu2)
		cSeqAtu2		:= "BN0000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu2	:= Soma1(cSeqAtu2)
	
//Atualiza o Parâmetro
	PutMV("AM_SQBNF", cSeqAtu2)

	FWRestArea(aArea2)
Return cSeqAtu2


//Troca para a sequência das OPs de Kanban

User Function M04M14C()

	Local aArea4	    := FWGetArea()
	Local cSeqAtu4		:= ""
    Local cTpProd4		:= SC2->C2_XKANBAN

//Busca Sequencia Atual
	cSeqAtu4 	:= GetMV("AM_SQKBN")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd4 == "1" .and. Empty(cSeqAtu4)
		cSeqAtu4		:= "KB0000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu4	:= Soma1(cSeqAtu4)
	
//Atualiza o Parâmetro
	PutMV("AM_SQKBN", cSeqAtu4)

	FWRestArea(aArea4)
Return cSeqAtu4


//Troca para a sequência das OPs de Perca

User Function M04M14B()

	Local aArea3	    := FWGetArea()
	Local cSeqAtu3		:= ""
    Local cTpProd3		:= SC2->C2_XPERCA

//Busca Sequencia Atual
	cSeqAtu3 	:= GetMV("AM_SQPRC")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd3 == "1" .and. Empty(cSeqAtu3)
		cSeqAtu3		:= "PP0000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu3	:= Soma1(cSeqAtu3)
	
//Atualiza o Parâmetro
	PutMV("AM_SQPRC", cSeqAtu3)

	FWRestArea(aArea3)
Return cSeqAtu3


//Troca para a sequência das OPs de Melhoria
User Function M04M14D()

	Local aArea5	    := FWGetArea()
	Local cSeqAtu5		:= ""
    Local cTpProd5		:= SC2->C2_XMELHOR

//Busca Sequencia Atual
	cSeqAtu5 	:= GetMV("AM_SQMEL")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd5 == "1" .and. Empty(cSeqAtu5)
		cSeqAtu5		:= "MEL000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu5	:= Soma1(cSeqAtu5)
	
//Atualiza o Parâmetro
	PutMV("AM_SQMEL", cSeqAtu5)

	FWRestArea(aArea5)
Return cSeqAtu5


//Troca para a sequência das OPs de Retalho
User Function M04M14E()

	Local aArea6	    := FWGetArea()
	Local cSeqAtu6		:= ""
    Local cTpProd6		:= SC2->C2_XRETAL

//Busca Sequencia Atual
	cSeqAtu6 	:= GetMV("AM_SQRET")
	
//Se não estiver vazio, define um valor inicial
	Do Case
	    Case cTpProd6 == "1" .and. Empty(cSeqAtu6)
		cSeqAtu6		:= "RET000"
	EndCase

//Incrementa a sequência em +1
	cSeqAtu6	:= Soma1(cSeqAtu6)
	
//Atualiza o Parâmetro
	PutMV("AM_SQRET", cSeqAtu6)

	FWRestArea(aArea6)
Return cSeqAtu6
