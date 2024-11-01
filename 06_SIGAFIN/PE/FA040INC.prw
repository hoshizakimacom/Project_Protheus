#Include "Protheus.ch"

/*/{Protheus.doc} FA040INC
    A finalidade do ponto de entrada FA040INCé permitir validações de usuário
    na inclusão do Contas a Receber (FINA040), localizado no TudoOK da rotina.
    @return lRet - lógico, .T. valida a inclusão e continua o processo,
    caso contrário .F. e interrompe o processo.
    @type method
    @author Renan Camargo
    @since 18/10/2024
/*/
User Function FA040INC()

Local aArea := GetArea()
Local lRet     := .T.
MsgStop ('PE,Atenção')
If !IsInCallStack("ClassTituloCRA")

    // Validaçaõ de campo E1_TIPO 
    If SE1->E1_TIPO == "CRA"
        MsgStop("Não é permitido inclusão de tipo de título 'CRA' manualmente !", "Aviso")
        lRet := .F.
        MsgStop ('retorna F,Atenção')

      EndIf
EndIf

RestArea(aArea)

Return lRet 
