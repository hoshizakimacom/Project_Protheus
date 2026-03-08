#include "Totvs.Ch"
#define STR0001 "ATENCAO"
#define STR0002 "Este processo devera ser executado por GRUPO DE EMPRESA."
#define STR0003 "Deseja remover o relacionamento entre os campos R8_TIPOAFA (Tipo de Ausencias) e RCM_PD (Verba do Tipo de Ausencias)?"
#define STR0004 "Relacionamento removido com sucesso!"
#define STR0005 "Removendo relacionando no dicionario SX9 (Relacionamentos)..."

/*/{Protheus.doc} AtuSX9
Funcao responsavel por executar o processo de exclusao do relacionamento entre os campos R8_TIPOAFA(Lancamento de Ausencias) e RCM_TIPO (Tipo de Ausencias)
@author raquel.andrade
@since 20/08/2020
@version P12
@return lMsErroAuto, logic, retorna resultado da operação
/*/
User Function AtuSX9()
Private lMsErroAuto := .F.


If MsgYesNo( OemToAnsi( STR0002 + CRLF +  CRLF + STR0003), OemToAnsi( STR0001 ) )

    MsAguarde({|| MSExecAuto( {|| u_DelRel() }) },OemToAnsi( STR0005 ) ) 

    If lMsErroAuto
        
	If (!IsBlind()) // COM INTERFACE GR�FICA
	MostraErro() // TELA
Else // EM ESTADO DE JOB
	cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

	ConOut(PadC("Automatic routine ended with error", 80))
	ConOut("Error: "+ cError)
EndIf

    Else
        MsgInfo(OemToAnsi( STR0004 ), OemToAnsi( STR0001 ))
    EndIf

EndIf

Return !lMsErroAuto


/*/{Protheus.doc} DelRel
Funcao responsavel em alimentar os campos novos criados na tabela RJ1.
@author raquel.andrade
@since 03/08/2020
@version P12
@return lRet, logic, retorna resultado da operação
/*/
User Function DelRel()
Local aArea     := GetArea()
Local lRet		:= .F.
Local cAlias := GetNextAlias()
Local _cQry := ""

	_cQry += " SELECT X9_EXPDOM X9EXPDOM, X9_EXPCDOM as X9EXPCDOM, R_E_C_N_O_ RECNO "
	_cQry += " FROM " + RetSQLName("SX9") + " SX9 "
	_cQry += " WHERE    SX9.D_E_L_E_T = ' ' "
	_cQry += " AND X9_DOM    = 'SR8' "

	If Select(cAlias) > 0
		DBSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf

	DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQry), cAlias, .T., .T.)

	DBSelectArea(cAlias)
	While !(cAlias)->(EOF()) .And. !lRet

		If AllTrim(cAlias->X9EXPDOM) == "R8_TIPOAFA" .And. AllTrim(cAlias->X9EXPCDOM) == "RCM_PD" 
			DbSelectArea("SX9")
			SX9->(DbGoTo(cAlias->RECNO))
			RecLock( "SX9" , .F. )
			SX9->( dbDelete() )
			lRet	:= .T.
			MsUnLock()
		EndIf

		(cAlias)->(dbSkip())
	EndDo

    /*DbSelectArea("SX9")
    DbSetOrder(1)

	If SX9->(DbSeek("SR8"))
		While AllTrim(SX9->X9_DOM) == "SR8" .And. !lRet
			If AllTrim(SX9->X9_EXPDOM) == "R8_TIPOAFA" .And. AllTrim(SX9->X9_EXPCDOM) == "RCM_PD" 
				RecLock( "SX9" , .F. )
			    SX9->( dbDelete() )
				lRet	:= .T.
			    MsUnLock()
			EndIf
			SX9->(DbSkip())
		EndDo
	EndIf*/
    
    RestArea(aArea)   
 
Return lRet
