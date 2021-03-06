 
********************************************************************************
* 5. Unir las bases de datos
********UNIR 2022
use "${datos}\output\base_noticovid_2022", clear

* Juntar DATOS DEL 2022
append using "${datos}\output\base_siscovid_ag_2022", force
append using "${datos}\output\base_sinadef_2022", force


gen numero = _n

**********************************************
* 5.1 Generar los ubigeos de los departamentos, provincias, y distritos con los nombres bien escritos

replace distrito = upper(distrito)
replace provincia = upper(provincia)
replace departamento = upper(departamento)
replace provincia = "LA CONVENCIÓN" if provincia == "LA CONVENCIóN"
replace provincia = "LA CONVENCION" if provincia == "LA CONVENCIÓN"
replace provincia = "QUISPICANCHI" if provincia ==  "QUISPICANCHIS"
*
*replace distrito = upper(distrito)

*replace distrito = ustrregexra(ustrnormalize( distrito, "nfd" ) , "\p{Mark}", "" )

merge m:1 ubigeo using "${datos}\output\ubigeos.dta", nogen

destring ubigeo, replace force

replace ubigeo = . if ubigeo <80000 
replace ubigeo = . if ubigeo >81307

replace distrito = "" if ubigeo == .
replace provincia = "" if ubigeo == .

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
label define provincia_residencia 1 "ACOMAYO" 2 "ANTA" 3 "CALCA" 4 "CANAS" 5 "CANCHIS" 6 "CHUMBIVILCAS" 7 "CUSCO" 8 "ESPINAR" 9 "LA CONVENCION" 10 "PARURO" 11 "PAUCARTAMBO" 12 "QUISPICANCHI" 13 "URUBAMBA"
label values provincia_residencia provincia_residencia
*tab provincia_residencia if positivo == 1

replace provincia = "" if provincia_residencia == .

tostring ubigeo, replace
replace ubigeo = "0" + ubigeo 
replace ubigeo = "" if ubigeo == "0."

* Combinar distritos y ubigeo
*merge 	m:1 distrito using "datos\raw\ubigeo.dta"

* Generar diagnosticados en otras regionaes
gen 	dis_temp = distrito if ubigeo !=""
drop 	distrito
rename 	dis_temp distrito
replace	distrito = "OTRO" if distrito == ""
replace	provincia = "OTRO" if provincia == ""
replace	departamento = "OTRO" if departamento == ""

replace	ubigeo = "999999" if ubigeo == ""
replace	provincia_ubigeo = "9999" if provincia_ubigeo == ""
*replace	departamento_ubigeo = "99" if departamento_ubigeo == ""

***************************************************
* 5.2 Generar variables en común para PCR, PR, y AG

* Fecha 
gen fecha_resultado =.
replace fecha_resultado = fecha_pcr if positivo_pcr == 1 | positivo_pcr == 0
replace fecha_resultado = fecha_ag if positivo_ag == 1 | positivo_ag == 0
replace fecha_resultado = fecha_sinadef if defuncion == 1
format fecha_resultado %td

* Fecha de recuperación alta epidemeologica casos 
gen fecha_recuperado =.
replace fecha_recuperado = fecha_resultado + 14 if (positivo_pcr == 1 | positivo_ag == 1)
format fecha_recuperado %td

* Generar variables que tengan nombres más explícitos
gen positivo_molecular = positivo_pcr
gen positivo_antigenica = positivo_ag 
gen var_id = numero 

* Generar pruebas PCR - PR(RAPIDAS) - AG(ANTIGENAS)
gen prueba_pcr = .
replace prueba_pcr = 1 if positivo_pcr == 1 | positivo_pcr == 0
gen prueba_ag = .
replace prueba_ag = 1 if positivo_ag == 1 | positivo_ag == 0

*Generar Positivo PCR -PR(RAPIDAS) -AG(ANTIGENAS)
gen positivo_prueba_pcr =.
replace positivo_prueba_pcr = 1 if positivo_pcr == 1 
gen positivo_prueba_ag =.
replace positivo_prueba_ag = 1 if positivo_ag == 1

* Generar positivo Sala Covid Semanal
gen positivo = 1 if positivo_pcr == 1 | positivo_ag == 1

* Generar prueba
gen prueba = 1 if prueba_pcr == 1 | prueba_ag == 1 

* Generar una variable que tome valores de las tres pruebas
gen tipo_prueba = .
replace tipo_prueba = 1 if prueba_pcr == 1
replace tipo_prueba = 2 if prueba_ag == 1
label variable tipo_prueba "Tipo de Prueba"
label define tipo_prueba 1 "Molecular" 2 "Antigénica" 
label values tipo_prueba tipo_prueba

*****************************************************
* 5.3 Analizar la variable fecha de inicio de síntomas
* Identificar cuantos tienen fecha de inicio y fecha de resultado
gen tienen_inicio = .
replace tienen_inicio = 1 if fecha_resultado != . & fecha_inicio != .

* Identificar cuantos tienen fecha de inicio superior a la fecha de resultado y borrar su fecha de inicio (mantener su fecha de resultado)
gen mayor_inicio = .
replace mayor_inicio = 1 if fecha_inicio > fecha_resultado & fecha_resultado != . & fecha_inicio != .
replace fecha_inicio = . if mayor_inicio ==1

*Identificar cuantos tienen fecha de inicio menor o igual a la fecha de resultado
gen menor_igual_inicio = .
replace menor_igual_inicio = 1 if fecha_inicio <= fecha_resultado & fecha_resultado != . & fecha_inicio != .

* Identificar quienes reportan una fecha de inicio más alejado de 30 días y borrar su fecha de inicio (mantener sy fecha de resultado)
gen diferencia_mas_30 = .
replace diferencia_mas_30 = 1 if (fecha_resultado - fecha_inicio) > 30 & menor_igual_inicio ==1
replace fecha_inicio = . if diferencia_mas_30 == 1
replace fecha_inicio = . if sintomatico == 0 & fecha_inicio != .

*Eliminar fechas < al 2022

save "${datos}/output/base_covid_2022.dta", replace
