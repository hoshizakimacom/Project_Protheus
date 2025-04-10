#INCLUDE "RWMAKE.CH

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF130QRY   บAutor  ณ Marcos Rocha       บ Data ณ  08/04/25   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para filtro via query no reltorio de contasบฑฑ
ฑฑบ          ณa receber.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Acos Macom                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F130QRY()

Local cQuery  	:= ""

If !MsgYesNo('Deseja usar regra especํfica BOL/NF ?',"Aten็ใo")
    Return(cQuery)
EndIf

cQuery  += " AND ( E1_TIPO NOT IN ('NF ','BOL') OR "

// NF e nใo tem BOL
cQuery  += "( E1_TIPO = 'NF ' AND (SELECT COUNT(*) "
cQuery  += "  FROM " + RetSqlName("SE1") + " SE12 "
cQuery  += "  WHERE SE12.E1_FILIAL = E1_FILIAL "
cQuery  += " AND SE12.E1_PEDIDO = E1_PEDIDO AND SE12.E1_CLIENTE = E1_CLIENTE AND SE12.E1_LOJA = E1_LOJA "
cQuery  += " AND SE12.E1_TIPO = 'BOL' "
cQuery  += " AND SE12.D_E_L_E_T_ = '' "
cQuery  += " ) = 0  ) "

cQuery  += " OR "

// NF e Pedido estแ encerrado
cQuery  += " ( E1_TIPO = 'NF '  AND (SELECT COUNT(*) "
cQuery  += " FROM " + RetSqlName("SC6") + " SC6 "
cQuery  += " WHERE C6_FILIAL = E1_FILIAL "
cQuery  += " AND E1_PEDIDO = C6_NUM AND E1_CLIENTE = C6_CLI AND E1_LOJA = C6_LOJA "
cQuery  += " AND C6_BLQ <> 'R' "
cQuery  += " AND C6_QTDVEN > C6_QTDENT " 
cQuery  += " AND SC6.D_E_L_E_T_ = '' "
cQuery  += " ) = 0  ) "

cQuery  += " OR " 

// BOL e Pedido em aberto
cQuery  += " ( E1_TIPO = 'BOL' AND (SELECT COUNT(*) "
cQuery  += " FROM " + RetSqlName("SC6") + " SC6 "
cQuery  += " WHERE C6_FILIAL = E1_FILIAL "
cQuery  += " AND E1_PEDIDO = C6_NUM AND E1_CLIENTE = C6_CLI AND E1_LOJA = C6_LOJA "
cQuery  += " AND C6_BLQ <> 'R' "
cQuery  += " AND C6_QTDVEN > C6_QTDENT " 
cQuery  += " AND SC6.D_E_L_E_T_ = '' "
cQuery  += " ) > 0 ) " 

cQuery  += " ) " 

//MsgStop(cQuery)

Return(cQuery)
