
use "${datos}\output\base_vacunados", clear

drop if EdadGE < 5
drop if missing(EdadGE)
drop if EdadGE > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if EdadGE >=  5 & EdadGE <= 11
replace grupo_edad = 2 if EdadGE >= 12 & EdadGE <= 19
replace grupo_edad = 3 if EdadGE >= 20 & EdadGE <= 29
replace grupo_edad = 4 if EdadGE >= 30 & EdadGE <= 39
replace grupo_edad = 5 if EdadGE >= 40 & EdadGE <= 49
replace grupo_edad = 6 if EdadGE >= 50 & EdadGE <= 59
replace grupo_edad = 7 if EdadGE >= 60 & EdadGE <= 69
replace grupo_edad = 8 if EdadGE >= 70 & EdadGE <= 79
replace grupo_edad = 9 if EdadGE >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "5 a 11 años" 2 "12-19 años" 3 "20-29 años" 4 "30-39 años" 5 "40-49 años" 6 "50-59 años" 7 "60-69 años" 8 "70-79 años" 9 "80 a más años"
label values grupo_edad grupo_edad
tab grupo_edad

* Contar cuántos son
* IMPORTANTE: Las personas con tres dosis se cuentan en personas con dos dosis
replace dosis = 2 if dosis == 3

preserve 
gen numero = _n
collapse (count) numero if dosis == 1, by(grupo_edad)
rename numero uno
save "${datos}\temporal\vacunados_primera", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 2, by(grupo_edad)
rename numero dos
save "${datos}\temporal\vacunados_segunda", replace
restore

/*
preserve 
gen numero = _n
collapse (count) numero if dosis == 3, by(grupo_edad)
rename numero tres
save "datos\temporal\vacunados_tercera", replace
restore 
*/

use "${datos}\temporal\vacunados_primera", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_segunda", nogen
**merge 1:1 grupo_edad using "datos\temporal\vacunados_tercera", nogen

gen objetivo = .
replace objetivo = 178438 if grupo_edad == 1
replace objetivo = 208903 if grupo_edad == 2
replace objetivo = 263801 if grupo_edad == 3
replace objetivo = 223780 if grupo_edad == 4
replace objetivo = 181824 if grupo_edad == 5
replace objetivo = 139437 if grupo_edad == 6
replace objetivo = 91654 if grupo_edad == 7
replace objetivo = 51166 if grupo_edad == 8
replace objetivo = 27404 if grupo_edad == 9

gen dos_dosis = dos/objetivo*100
gen brecha_primera_segunda = uno/objetivo*100
*gen tres_dosis = tres/objetivo*100
*gen faltante = 100 - dos_dosis - brecha_primera_segunda - tres_dosis
gen faltante = 100 - dos_dosis - brecha_primera_segunda

*format dos_dosis brecha_primera_segunda tres_dosis faltante %4.1f
format dos_dosis brecha_primera_segunda faltante %4.1f

* Gráfica
graph hbar dos_dosis brecha_primera_segunda faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)


/*
graph hbar dos_dosis brecha_primera_segunda tres_dosis faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(outside) color(black)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor1")) ///
bar(4, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "Tres dosis") label(4 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)
*/
* Exportar figura
graph export "figuras\vacunacion_grupo_edad.png", as(png) replace
graph export "figuras\vacunacion_grupo_edad.pdf", as(pdf) replace
