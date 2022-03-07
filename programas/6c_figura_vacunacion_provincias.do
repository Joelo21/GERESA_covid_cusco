
use "${datos}\output\base_vacunados", clear
merge m:1 ubigeo using "${datos}\output\ubigeos"

drop if EdadGE < 5
drop if missing(EdadGE)
drop if EdadGE > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if EdadGE >=  5 & EdadGE <= 11
replace grupo_edad = 2 if EdadGE >= 12 & EdadGE <= 17
replace grupo_edad = 3 if EdadGE >= 18 & EdadGE <= 29
replace grupo_edad = 4 if EdadGE >= 30 & EdadGE <= 39
replace grupo_edad = 5 if EdadGE >= 40 & EdadGE <= 49
replace grupo_edad = 6 if EdadGE >= 50 & EdadGE <= 59
replace grupo_edad = 7 if EdadGE >= 60 & EdadGE <= 79
replace grupo_edad = 9 if EdadGE >= 80 
label variable grupo_edad "Grupo de EdadGE"
label define grupo_edad 1 "5 a 11 años" 2 "12-17 años" 3 "18-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-79 años" 8 "80 a más años"	
label values grupo_edad grupo_edad
tab grupo_edad

* Añadir el distrito de Kimpirushiato a LC
replace provincia = "LA CONVENCION" if ubigeo == "080915"

gen provincia_residencia =.
replace provincia_residencia = 1 if provincia == "ACOMAYO"
replace provincia_residencia = 2 if provincia == "ANTA"
replace provincia_residencia = 3 if provincia == "CALCA"
replace provincia_residencia = 4 if provincia == "CANAS"
replace provincia_residencia = 5 if provincia == "CANCHIS"
replace provincia_residencia = 6 if provincia == "CHUMBIVILCAS"
replace provincia_residencia = 7 if provincia == "CUSCO"
replace provincia_residencia = 8 if provincia == "ESPINAR"
replace provincia_residencia = 9 if provincia == "LA CONVENCION"
replace provincia_residencia = 10 if provincia == "PARURO"
replace provincia_residencia = 11 if provincia == "PAUCARTAMBO"
replace provincia_residencia = 12 if provincia == "QUISPICANCHI"
replace provincia_residencia = 13 if provincia == "URUBAMBA"
label variable provincia_residencia "provincia de residencia"
label define provincia_residencia 1 "Acomayo" 2 "Anta" 3 "Calca" 4 "Canas" 5 "Canchis" 6 "Chumbivilcas" 7 "Cusco" 8 "Espinar" 9 "La Convención" 10 "Paruro" 11 "Paucartambo" 12 "Quispicanchi" 13 "Urubambda"
label values provincia_residencia provincia_residencia

gen numero = _n

replace dosis = 2 if dosis == 3

save "${datos}\output\base_vacunados_variables.dta", replace

*use "${datos}\output\base_vacunados_variables.dta", clear

forvalues i = 1/2 {

forvalues j=1/9 {
preserve
keep if dosis == `i'
keep if grupo_edad == `j'

collapse (count) numero, by(provincia_residencia)

*tsset fecha_resultado, daily
*tsfill 

rename numero numero_`i'_`j'

save "${datos}\temporal\vacunados_`i'_`j'.dta", replace

restore

}

}

forvalues i=1/2 {

	use "${datos}\temporal\vacunados_`i'_1.dta", clear

		forvalues j = 2/9 {

		merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_`i'_`j'.dta", nogen

		}

	save "${datos}\temporal\vacunados_`i'.dta", replace

}

use "${datos}\temporal\vacunados_1.dta", clear

merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_2.dta", nogen

* Crear los objetivos
gen objetivo_1 = .
replace objetivo_1 = 2753 if provincia_residencia == 1
replace objetivo_1 = 7196 if provincia_residencia == 2
replace objetivo_1 = 8824 if provincia_residencia == 3
replace objetivo_1 = 3963 if provincia_residencia == 4
replace objetivo_1 = 12796 if provincia_residencia == 5
replace objetivo_1 = 9130 if provincia_residencia == 6
replace objetivo_1 = 64943 if provincia_residencia == 7
replace objetivo_1 = 9077 if provincia_residencia == 8
replace objetivo_1 = 26267 if provincia_residencia == 9
replace objetivo_1 = 2968 if provincia_residencia == 10
replace objetivo_1 = 7291 if provincia_residencia == 11
replace objetivo_1 = 13915 if provincia_residencia == 12
replace objetivo_1 = 8838 if provincia_residencia == 13


gen objetivo_2 = .
replace objetivo_2 = 3451 if provincia_residencia == 1
replace objetivo_2 = 6052 if provincia_residencia == 2
replace objetivo_2 = 8191 if provincia_residencia == 3
replace objetivo_2 = 4384 if provincia_residencia == 4
replace objetivo_2 = 11607 if provincia_residencia == 5
replace objetivo_2 = 10032 if provincia_residencia == 6
replace objetivo_2 = 49224 if provincia_residencia == 7
replace objetivo_2 = 7710 if provincia_residencia == 8
replace objetivo_2 = 22727 if provincia_residencia == 9
replace objetivo_2 = 3615 if provincia_residencia == 10
replace objetivo_2 = 7072 if provincia_residencia == 11
replace objetivo_2 = 13304 if provincia_residencia == 12
replace objetivo_2 = 7433 if provincia_residencia == 13

gen objetivo_3 = .
replace objetivo_3 = 6662 if provincia_residencia == 1
replace objetivo_3 = 14650 if provincia_residencia == 2
replace objetivo_3 = 17399 if provincia_residencia == 3
replace objetivo_3 = 10190 if provincia_residencia == 4
replace objetivo_3 = 25696 if provincia_residencia == 5
replace objetivo_3 = 19878 if provincia_residencia == 6
replace objetivo_3 = 101586 if provincia_residencia == 7
replace objetivo_3 = 15502 if provincia_residencia == 8
replace objetivo_3 = 45665 if provincia_residencia == 9
replace objetivo_3 = 7773 if provincia_residencia == 10
replace objetivo_3 = 12891 if provincia_residencia == 11
replace objetivo_3 = 24113 if provincia_residencia == 12
replace objetivo_3 = 16118 if provincia_residencia == 13

gen objetivo_4 = .
replace objetivo_4 = 3238 if provincia_residencia == 1
replace objetivo_4 = 10379 if provincia_residencia == 2
replace objetivo_4 = 11390 if provincia_residencia == 3
replace objetivo_4 = 5639 if provincia_residencia == 4
replace objetivo_4 = 17006 if provincia_residencia == 5
replace objetivo_4 = 10410 if provincia_residencia == 6
replace objetivo_4 = 85274 if provincia_residencia == 7
replace objetivo_4 = 9877 if provincia_residencia == 8
replace objetivo_4 = 35139 if provincia_residencia == 9
replace objetivo_4 = 4607 if provincia_residencia == 10
replace objetivo_4 = 7242 if provincia_residencia == 11
replace objetivo_4 = 15373 if provincia_residencia == 12
replace objetivo_4 = 13201 if provincia_residencia == 13

gen objetivo_5 = .
replace objetivo_5 = 3126 if provincia_residencia == 1
replace objetivo_5 = 8045 if provincia_residencia == 2
replace objetivo_5 = 9786 if provincia_residencia == 3
replace objetivo_5 = 4930 if provincia_residencia == 4
replace objetivo_5 = 13664 if provincia_residencia == 5
replace objetivo_5 = 8989 if provincia_residencia == 6
replace objetivo_5 = 69246 if provincia_residencia == 7
replace objetivo_5 = 7958 if provincia_residencia == 8
replace objetivo_5 = 28733 if provincia_residencia == 9
replace objetivo_5 = 4047 if provincia_residencia == 10
replace objetivo_5 = 6111 if provincia_residencia == 11
replace objetivo_5 = 12123 if provincia_residencia == 12
replace objetivo_5 = 10602 if provincia_residencia == 13

gen objetivo_6 = .
replace objetivo_6 = 2943 if provincia_residencia == 1
replace objetivo_6 = 7242 if provincia_residencia == 2
replace objetivo_6 = 7722 if provincia_residencia == 3
replace objetivo_6 = 4334 if provincia_residencia == 4
replace objetivo_6 = 11454 if provincia_residencia == 5
replace objetivo_6 = 7880 if provincia_residencia == 6
replace objetivo_6 = 48101 if provincia_residencia == 7
replace objetivo_6 = 6476 if provincia_residencia == 8
replace objetivo_6 = 22219 if provincia_residencia == 9
replace objetivo_6 = 3736 if provincia_residencia == 10
replace objetivo_6 = 4751 if provincia_residencia == 11
replace objetivo_6 = 9154 if provincia_residencia == 12
replace objetivo_6 = 7680 if provincia_residencia == 13

gen objetivo_7 = .
replace objetivo_7 = 3244 if provincia_residencia == 1
replace objetivo_7 = 8166 if provincia_residencia == 2
replace objetivo_7 = 8295 if provincia_residencia == 3
replace objetivo_7 = 5088 if provincia_residencia == 4
replace objetivo_7 = 12240 if provincia_residencia == 5
replace objetivo_7 = 9895 if provincia_residencia == 6
replace objetivo_7 = 48021 if provincia_residencia == 7
replace objetivo_7 = 7154 if provincia_residencia == 8
replace objetivo_7 = 22055 if provincia_residencia == 9
replace objetivo_7 = 4519 if provincia_residencia == 10
replace objetivo_7 = 4739 if provincia_residencia == 11
replace objetivo_7 = 9588 if provincia_residencia == 12
replace objetivo_7 = 7662 if provincia_residencia == 13

gen objetivo_8 = .
replace objetivo_8 = 894 if provincia_residencia == 1
replace objetivo_8 = 2145 if provincia_residencia == 2
replace objetivo_8 = 1813 if provincia_residencia == 3
replace objetivo_8 = 1098 if provincia_residencia == 4
replace objetivo_8 = 2690 if provincia_residencia == 5
replace objetivo_8 = 2280 if provincia_residencia == 6
replace objetivo_8 = 9093 if provincia_residencia == 7
replace objetivo_8 = 1561 if provincia_residencia == 8
replace objetivo_8 = 3752 if provincia_residencia == 9
replace objetivo_8 = 1198 if provincia_residencia == 10
replace objetivo_8 = 904 if provincia_residencia == 11
replace objetivo_8 = 2147 if provincia_residencia == 12
replace objetivo_8 = 1696 if provincia_residencia == 13

* Generar los porcentajes

forvalues i=1/9 {

gen dos_dosis_`i' = numero_2_`i' /objetivo_`i'*100
gen brecha_`i' = numero_1_`i'/objetivo_`i'*100
gen faltante_`i' = 100 - dos_dosis_`i' - brecha_`i'
}

* Formato
format dos_dosis_* brecha_* faltante_* %4.2f


forvalues i=1/9 {
graph hbar dos_dosis_`i' brecha_`i' faltante_`i', ///
over(provincia_residencia) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor7")) ///
bar(2, color("$mycolor6")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis")  label(3 "Faltante") size(*0.8) region(col(white))) name(provincia_`i', replace)

graph export "figuras\vacunacion_provincial_edad_`i'.png", as(png) replace
graph export "figuras\vacunacion_provincial_edad_`i'.pdf", as(pdf) replace
}
