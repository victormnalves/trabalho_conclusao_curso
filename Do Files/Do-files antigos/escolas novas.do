use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear
bysort codigo_escola: egen m_ice=mean(d_ice)
sort codigo_escola ano
br codigo_escola nome_escola codigo_uf ano_ice input_ano ice_seg d_ice m_ice if m_ice==1

