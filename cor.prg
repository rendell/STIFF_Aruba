'************Creating equations******************************
　
genr time= @trend
genr time2=time*time
genr oilf2=oilf * oilf
　
smpl 2010m01 2016m06
equation eqn_food.ls food  c  ar(1)
　
smpl 2000m12 2016m06
equation eqn_educ.ls d(education) c  ar(1) 
　
smpl 2000m12 2016m06
equation eqn_alco.ls alcohol_bev_tobacco c time ar(1)
　
smpl 2000m12 2016m06
equation eqn_tran.ls transport c time  ar(1)
　
smpl 2000m12 2016m06
equation eqn_recr.ls recr_culture c time time2 ar(1) ma(1) 
　
smpl 2000m12 2018m06
equation eqn_com.ls communications c time2 ar(1) ma(1)
　
smpl 2000m12 2018m06
equation eqn_misc.ls misc_goods_services c time time2 ar(1)
　
smpl 2000m12 2018m06
equation eqn_cloth.ls clothing_footwear c time time2 ar(2) ma(1) 
　
smpl 2000m12 2018m06
equation eqn_housop.ls hous_operation c time time2 ar(2) ma(1)
　
smpl 2008m1 2018m06
equation eqn_health.ls health c time ar(2) time2
　
smpl 2000m12 2018m06
equation eqn_hotel.ls rest_hotels c time ar(1) 
　
smpl 2000m12 2018m06
equation eqn_hous.ls housing housing(-1) ar(1)
　
smpl 2000m12 2018m06  
equation eqn_nonalco.ls nonalco c time ar(1)
　
smpl 2000m12 2018m08
equation eqn_gasol.ls d(gasol_diesel)  d(oilf(-1))
　
'component 'electricity and water are forecasted manually.
' gasoline is forecasted using the Brent Europe oil price forecast. 
'Found unit root for both depedenent and independent series so they are first differenced. 
　
'*********Second part of the model - forecasting**********************
　
smpl 2017m07 2018m12
　
eqn_alco.forecast alcof alcose
group al alcof (alcof+alcose) (alcof-alcose)
al.line
　
eqn_cloth.forecast clothf clothse
group cl clothf (clothf+clothse) (clothf-clothse)
cl.line
　
eqn_com.forecast comf comse
group co comf (comf+comse) (comf-comse)
co.line
　
eqn_educ.forecast educf educse
group ed educf (educf+educse) (educf-educse)
ed.line
　
eqn_food.forecast foodf foodse
group fo foodf (foodf+foodse) (foodf-foodse)
fo.line
　
eqn_health.forecast healthf healthse
group he healthf (healthf+healthse) (healthf-healthse)
he.line
　
eqn_hotel.forecast hotelf hotelse
group ho hotelf (hotelf+hotelse) (hotelf-hotelse)
ho.line
　
eqn_housop.forecast housopf housopse
group ho1 housopf (housopf+housopse) (housopf-housopse)
ho1.line
　
eqn_hous.forecast housf housse
group ho2 housf (housf+housse) (housf-housse)
ho2.line
　
eqn_misc.forecast miscf miscse
group mi miscf (miscf+miscse) (miscf-miscse)
mi.line
　
eqn_recr.forecast recrf recrse
group re recrf (recrf+recrse) (recrf-recrse)
re.line
　
eqn_tran.forecast tranf transe
group tr tranf (tranf+transe) (tranf-transe)
tr.line
　
eqn_nonalco.forecast nonalcof nonalcose
group nal nonalcof (nonalcof+nonalcose) (nonalcof-nonalcose)
nal.line
　
smpl 2000m12 2018m12
　
　
smpl 2017m09 2018m12
eqn_gasol.forecast gasolf gasolse
group gas gasolf (gasolf+gasolse) (gasolf-gasolse)
gas.line
smpl 2000m12 2018m12
　
'********************grouping**************************
　
' weights per component, according to the component excel file. 
vector(15) weights
weights.fill  1125.3, 81.9, 625.9, 1394.8, 741.3, 235.8, 1263.0, 706.3, 891.2, 83.0, 373.7, 767.0, 552.3, 437.3, 721.0
　
model stif
　
stif.append composite = (weights(1)*foodf + weights(2)*alcof + weights(3)*clothf + weights(4)*housf + weights(5)*housopf + weights(6)*healthf + weights(7)*tranf + weights(8)*comf + weights(9)*recrf + weights(10)*educf + weights(11)*hotelf + weights(12)*miscf+ weights(13)*gasolf+weights(14)*waterf+weights(15)*electricityf)/10000
　
smpl 2000m01 2018m12
stif.solve
　
'Core inflation index grouping
'total weight:
' 1394.8+1263.0+81.9+625.9+741.3+235.8+706.3+891.2+83+373.7+767.0=7163.9
　
genr core_index_f = ( weights(2)*alcof + weights(3)*clothf + weights(4)*housf + weights(5)*housopf + weights(6)*healthf + weights(7)*tranf + weights(8)*comf + weights(9)*recrf + weights(10)*educf + weights(11)*hotelf + weights(12)*miscf)/7163.9
　
genr index_ex_energy_f =(weights(1)*foodf + weights(2)*alcof + weights(3)*clothf + weights(4)*housf + weights(5)*housopf + weights(6)*healthf + weights(7)*tranf + weights(8)*comf + weights(9)*recrf + weights(10)*educf + weights(11)*hotelf + weights(12)*miscf)/(10000-552.3-437.3-721.0)
　
genr core_inflationf_12month =(@movav(core_index_f ,12)-@movav(core_index_f (-12),12))/@movav(core_index_f (-12),12)*100
　
genr inf_ex_energy_f_12m =(@movav(index_ex_energy_f ,12)-@movav(index_ex_energy_f  (-12),12))/@movav(index_ex_energy_f (-12),12)*100
　
'****************creating 12 month series****************
'oil 
genr oil_12month =@movav(oil,12)
genr oilf_12month =@movav(oilf,12)
　
'headline inflation
genr inflationf_12month =(@movav(composite_0,12)-@movav(composite_0(-12),12))/@movav(composite_0(-12),12)*100
genr official_12month =(@movav(official,12)-@movav(official(-12),12))/@movav(official(-12),12)*100
　
'component 12-month inflation
genr WA_foodf_12m = (((@movav(foodf,12)-@movav(foodf(-12),12))/@movav(foodf(-12),12)))*(weights(1)/10000)*100
　
genr WA_alcof_12m = (((@movav(alcof,12)-@movav(alcof(-12),12))/@movav(alcof(-12),12)))*(weights(2)/10000) *100
　
genr WA_clothf_12m = (((@movav(clothf,12)-@movav(clothf(-12),12))/@movav(clothf(-12),12)))*(weights(3)/10000) *100
　
genr WA_housf_12m = (((@movav(housf,12)-@movav(housf(-12),12))/@movav(housf(-12),12)))*(weights(4)/10000)*100
　
genr WA_housopf_12m = (((@movav(housopf,12)-@movav(housopf(-12),12))/@movav(housopf(-12),12)))*(weights(5)/10000)*100
　
genr WA_healthf_12m = (((@movav(healthf,12)-@movav(healthf(-12),12))/@movav(healthf(-12),12)))*(weights(6)/10000)*100
　
genr WA_tranf_12m = (((@movav(tranf,12)-@movav(tranf(-12),12))/@movav(tranf(-12),12)))*(weights(7)/10000)*100
　
genr WA_comf_12m = (((@movav(comf,12)-@movav(comf(-12),12))/@movav(comf(-12),12)))*(weights(8)/10000)*100
　
genr WA_recrf_12m = (((@movav(recrf,12)-@movav(recrf(-12),12))/@movav(recrf(-12),12)))*(weights(9)/10000)*100
　
genr WA_educf_12m = (((@movav(educf,12)-@movav(educf(-12),12))/@movav(educf(-12),12)))*(weights(10)/10000)*100
　
genr WA_hotelf_12m = (((@movav(hotelf,12)-@movav(hotelf(-12),12))/@movav(hotelf(-12),12)))*(weights(11)/10000)*100
　
genr WA_miscf_12m = (((@movav(miscf,12)-@movav(miscf(-12),12))/@movav(miscf(-12),12)))*(weights(12)/10000)*100
　
genr WA_gasolf_12m = (((@movav(gasolf,12)-@movav(gasolf(-12),12))/@movav(gasolf(-12),12)))*(weights(13)/10000)*100
　
genr WA_waterf_12m = (((@movav(waterf,12)-@movav(waterf(-12),12))/@movav(waterf(-12),12)))*(weights(14)/10000)*100
　
genr WA_electricityf_12m = (((@movav(electricityf,12)-@movav(electricityf(-12),12))/@movav(electricityf(-12),12)))*(weights(15)/10000)*100
　
　
'aggregate
genr WA_total_12m = (WA_foodf_12m +WA_alcof_12m + WA_clothf_12m + WA_housf_12m + WA_housopf_12m + WA_healthf_12m + WA_tranf_12m + WA_comf_12m + WA_recrf_12m + WA_educf_12m +WA_hotelf_12m + WA_miscf_12m + WA_gasolf_12m + WA_waterf_12m + WA_electricityf_12m)
　
genr WA_energyf_12m = WA_gasolf_12m + WA_waterf_12m + WA_electricityf_12m
　
genr WA_coref_12m = WA_alcof_12m + WA_clothf_12m + WA_housf_12m + WA_housopf_12m + WA_healthf_12m + WA_tranf_12m + WA_comf_12m + WA_recrf_12m + WA_educf_12m +WA_hotelf_12m + WA_miscf_12m
　
　
group core_elements WA_alcof_12m WA_clothf_12m WA_housf_12m WA_housopf_12m WA_healthf_12m WA_tranf_12m WA_comf_12m WA_recrf_12m WA_educf_12m WA_hotelf_12m WA_miscf_12m
core_elements.line
　
' generate end of period forecasts
genr endperiod_alcof = (alcof - alcof(-12)) / alcof(-12)*100
genr endperiod_clothf = (clothf - clothf(-12)) / clothf(-12)*100
genr endperiod_housf= (housf- housf(-12)) / housf(-12)*100
genr endperiod_housopf = (housopf - housopf(-12)) / housopf(-12)*100
genr endperiod_healthf = (healthf - healthf(-12)) / healthf(-12)*100
genr endperiod_tranf = (tranf - tranf(-12)) / tranf(-12)*100
genr endperiod_comf = (comf - comf(-12)) / comf(-12)*100
genr endperiod_recrf = (recrf - recrf(-12)) / recrf(-12)*100
genr endperiod_educf= (educf - educf(-12)) / educf(-12)*100
genr endperiod_hotelf= (hotelf- hotelf(-12)) / hotelf(-12)*100
genr endperiod_miscf = (miscf - miscf(-12)) / miscf(-12)*100
genr endperiod_foodf= (foodf - foodf(-12)) / foodf(-12)*100
genr endperiod_gasolf = (gasolf - gasolf(-12)) / gasolf(-12)*100
　
genr endperiod_waterf = (waterf - waterf(-12)) / waterf(-12)*100
genr endperiod_electricityf = (electricityf - electricityf(-12)) / electricityf(-12)*100
　
genr endperiod_totalf = (composite_0 - composite_0(-12)) / composite_0(-12)*100
　
　
STOP
　
