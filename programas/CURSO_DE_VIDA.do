********************************************************************************
*CURSO DE VIDA - TASA DE LETALIDAD POR 
********************************************************************************
******2020
/*
use "${datos}\output\base_covid.dta", clear
**Generando Curso de Vida
gen grupo_edad=.
replace grupo_edad = 1 if edad >= 0 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 59
replace grupo_edad = 5 if edad >= 60
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "Niños" 2 "Adolescente" 3 "Joven" 4 "Adulto" 5 "Adulto Mayor"
label values grupo_edad grupo_edad

drop if fecha_resultado >= d(01jan2021)
keep if grupo_edad !=.
sort fecha_resultado grupo_edad

*Fecha Resultado
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad

*Datos Por Region
*Letalidad
gen letalidad= defuncion / positivo * 100
format letalidad %9.2g
*Mortalidad
gen mortalidad = (defuncion / 1357498) * 1000000
format mortalidad %9.2g
*Incidencia
gen pobl_regional = 1357498
gen incidencia = positivo / pobl_regional * 1000000
format incidencia %9.2g

*Totales
gen total_def = sum(defuncion)
gen total_pos = sum(positivo)

save "${datos}\output\letalidad_curso_vida_2020.dta", replace

******2021
use "${datos}\output\base_covid.dta", clear
**Generando Curso de Vida
gen grupo_edad=.
replace grupo_edad = 1 if edad >= 0 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 59
replace grupo_edad = 5 if edad >= 60
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "Niños" 2 "Adolescente" 3 "Joven" 4 "Adulto" 5 "Adulto Mayor"
label values grupo_edad grupo_edad

drop if fecha_resultado < d(01jan2021) | fecha_resultado > d(01jan2022)
keep if grupo_edad !=.
sort fecha_resultado grupo_edad

*Fecha Resultado
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad

*Datos Por Region
*Letalidad
gen letalidad= defuncion / positivo * 100
format letalidad %9.2g
*Mortalidad
gen mortalidad = (defuncion / 1357498) * 1000000
format mortalidad %9.2g
*Incidencia
gen pobl_regional = 1357498
gen incidencia = positivo / pobl_regional * 1000000
format incidencia %9.2g

*Totales
gen total_def = sum(defuncion)
gen total_pos = sum(positivo)

save "${datos}\output\letalidad_curso_vida_2021.dta", replace
*/
******2022
use "${datos}\output\base_covid.dta", clear


**Generando Curso de Vida
gen grupo_edad=.
replace grupo_edad = 1 if edad >= 0 & edad <= 11
replace grupo_edad = 2 if edad >= 12 & edad <= 17
replace grupo_edad = 3 if edad >= 18 & edad <= 29
replace grupo_edad = 4 if edad >= 30 & edad <= 59
replace grupo_edad = 5 if edad >= 60
label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "Niños" 2 "Adolescente" 3 "Joven" 4 "Adulto" 5 "Adulto Mayor"
label values grupo_edad grupo_edad

/*
**Generando Curso de Vida
gen grupo_edad=.
replace grupo_edad = 1 if edad >= 0 & edad <= 4
replace grupo_edad = 2 if edad >= 5 & edad <= 8
replace grupo_edad = 3 if edad >= 9 & edad <= 12
replace grupo_edad = 4 if edad >= 13 & edad <= 16


label variable grupo_edad "Grupo Edad"
label define grupo_edad 1 "0-4 años" 2 "5-8 años" 3 "9-13 años" 4 "13-16 años" 
label values grupo_edad grupo_edad
*/

*Limpiando Base
drop if fecha_resultado < d(01jan2022)
keep if grupo_edad !=.
sort grupo_edad fecha_resultado


*Fecha Resultado
collapse (count) positivo defuncion, by (grupo_edad)
sort grupo_edad

*Datos Por Region
*Letalidad
gen letalidad= defuncion / positivo * 100
format letalidad %9.2g
*Mortalidad
gen mortalidad = (defuncion / 1357498) * 1000000
format mortalidad %9.2g
*Incidencia
gen pobl_regional = 1357498
gen incidencia = positivo / pobl_regional * 1000000
format incidencia %9.2g

*Totales
gen total_def = sum(defuncion)
gen total_pos = sum(positivo)

*TOTALES
*Coger ultimos datos "(Totales)"
gen letalidad_total = total_def / total_pos * 100
gen mortalidad_total = total_def / 1357498 * 1000000
gen incidencia_total = total_pos / 1357498 * 1000000

save "${datos}\output\letalidad_curso_vida_2022.dta", replace
