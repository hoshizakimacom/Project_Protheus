/* ####################################################################### *\
|| #           PONTO DE ENTRADA UTILIZADO PELO IMPORTADOR CONEX�ONFE     # ||
|| #                                                                     # ||
|| #    � EXECUTADO NO FINAL DA INCLUS�O DE UMA PR�-NOTA PARA ATUALIZAR  # ||
|| #     A SITUA��O DO XML E GERAR O ARQUIVO JSON COM CONEX�ONF-E        # ||
\* ####################################################################### */

User Function MT140SAI()

    // Deve ser chamado como primeira instru��o. 
    U_GTPE016()

    // Regras j� existentes ou novas devem ficar abaixo deste ponto. 

Return Nil 
