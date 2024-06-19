/* ####################################################################### *\
|| #           PONTO DE ENTRADA UTILIZADO PELO IMPORTADOR CONEXÃONFE     # ||
|| #                                                                     # ||
|| #    É EXECUTADO NO FINAL DA INCLUSÃO DE UMA PRÉ-NOTA PARA ATUALIZAR  # ||
|| #     A SITUAÇÃO DO XML E GERAR O ARQUIVO JSON COM CONEXÃONF-E        # ||
\* ####################################################################### */

User Function MT140SAI()

    // Deve ser chamado como primeira instrução. 
    U_GTPE016()

    // Regras já existentes ou novas devem ficar abaixo deste ponto. 

Return Nil 
