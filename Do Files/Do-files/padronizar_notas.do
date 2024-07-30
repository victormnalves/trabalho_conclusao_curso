**Padronizacao Estados

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao2326_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==23|codigo_uf==26)
}
capture egen enem_nota_redacao2326_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==23|codigo_uf==26)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao2326_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva2326_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==23|codigo_uf==26)
}

gen enem_nota_objetivab2326=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==23|codigo_uf==26)
capture egen enem_nota_objetivab2326_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==23|codigo_uf==26)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab2326_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)

}


***
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao3552_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==35|codigo_uf==52)
}
capture egen enem_nota_redacao3552_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao3552_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva3552_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==35|codigo_uf==52)
}

gen enem_nota_objetivab3552=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==35|codigo_uf==52)
capture egen enem_nota_objetivab3552_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab3552_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)

}

foreach x in "apr_em" "rep_em"  "aba_em" "dist_em" {
egen `x'3552_std=std(`x') if (codigo_uf==35|codigo_uf==52) 
egen `x'2326_std=std(`x') if (codigo_uf==23|codigo_uf==26)
}
