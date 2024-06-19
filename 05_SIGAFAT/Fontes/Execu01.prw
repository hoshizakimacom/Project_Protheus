#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "TBICONN.CH"   // Necessario para o Prepare Environment
#INCLUDE "topconn.CH"   // Necessario para o Prepare Environment
#include "Fileio.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#include "parmtype.ch"
#include "totvs.ch"
//#include 'tryexception.ch'

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Programa  |Execu01    |Autor | Valdemir Miranda     | Data | 30/01/2023 ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|| Desc.     | Exdecuta programas ADVPL									   ||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
User Function Execu01()

	Local oDlg
	Local cTit := ""
	Local oGet
	Local cExec := Space(200) 
	Local oBtnExec
	Local oBtnCanc

	DEFINE MSDIALOG oDlg TITLE cTit FROM 0,0 TO 100,300 PIXEL

	@ 10,10 SAY "Funcao com os (): " OF oDlg PIXEL
	@ 08,55 GET oGet VAR cExec SIZE 80,10 PICTURE "@!" OF oDlg PIXEL

	@ 30,30 BUTTON oBtnExec PROMPT "Exec"   SIZE 40,10 ACTION &( AllTrim(cExec) ) OF oDlg PIXEL
	@ 30,90 BUTTON oBtnCanc PROMPT "Cancel" SIZE 40,10 ACTION oDlg:End() OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return()
