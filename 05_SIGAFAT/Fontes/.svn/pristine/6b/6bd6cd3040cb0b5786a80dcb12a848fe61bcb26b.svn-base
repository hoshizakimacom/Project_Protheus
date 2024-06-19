#Include 'Protheus.ch'

//+----------------------------------------------------------------------------------------------------------
// Rotina que recebe o estado e retorna a região correspondente
//+----------------------------------------------------------------------------------------------------------
User Function M05A30(cEst,cReg,cRegDes)
    Default cEst    := ''
    Default cReg    := ''
    Default cRegDes := ''

    Do Case
        Case cEst $ 'DF-GO-MT-MS'                   // 005 - Centro Oeste
            cReg    := '005'
            cRegDes := 'CENTRO OESTE'

        Case cEst $ 'AL-BA-CE-MA-PB-PE-PI-RN-SE'    // 004 - Nordeste
            cReg    := '004'
            cRegDes := 'NORDESTE'


        Case cEst $ 'AC-AP-AM-PA-RO-RR-TO'          // 001 - Norte
            cReg    := '001'
            cRegDes := 'NORTE'


        Case cEst $ 'ES-MG-RJ-SP'                   // 003 - Sudeste
            cReg    := '003'
            cRegDes := 'SUDESTE'


        Case cEst $ 'PR-RS-SC'                      // 002 - Sul
            cReg    := '002'
            cRegDes := 'SUL'


        Case cEst $ 'EX'                            // 006 - Exportacao
            cReg    := '006'
            cRegDes := 'EXPORTACAO'

    EndCase

Return

