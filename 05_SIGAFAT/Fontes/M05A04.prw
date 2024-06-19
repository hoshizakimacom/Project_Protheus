#Include 'Protheus.ch'

//+------------------------------------------------------------------------------------------------
// Retorna percentual de desconto do cabeçaho
//+------------------------------------------------------------------------------------------------
User Function M05A04(_cFunc)
	Local _aDesc	:= {}
	Local _nX		:= 0
	Local _nPerDesc	:= 1

	Do Case
	Case _cFunc == 'PV'
		AAdd(_aDesc, 1 - (M->C5_DESC1 / 100))
		AAdd(_aDesc, 1 - (M->C5_DESC2 / 100))
		AAdd(_aDesc, 1 - (M->C5_DESC3 / 100))
		AAdd(_aDesc, 1 - (M->C5_DESC4 / 100))
		AAdd(_aDesc, 1 + (M->C5_XACRESC / 100))
		AAdd(_aDesc, 1 + (M->C5_XFRETE / 100))
		AAdd(_aDesc, 1 + (M->C5_XINSTA / 100))

	Case _cFunc == 'OV'

		AAdd(_aDesc, 1 - (M->CJ_DESC1 / 100))
		AAdd(_aDesc, 1 - (M->CJ_DESC2 / 100))
		AAdd(_aDesc, 1 - (M->CJ_DESC3 / 100))
		AAdd(_aDesc, 1 - (M->CJ_DESC4 / 100))
		AAdd(_aDesc, 1 + (M->CJ_XACRESC / 100))
		AAdd(_aDesc, 1 + (M->CJ_XFRETE / 100))
		AAdd(_aDesc, 1 + (M->CJ_XINSTA / 100))
	EndCase

	For _nX	:= 1 to Len(_aDesc)
		_nPerDesc := _nPerDesc *_aDesc[_nX]
	Next _nX
Return _nPerDesc

