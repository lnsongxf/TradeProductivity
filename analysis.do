clear
clear matrix
set scrollbufsize 2048000
capture log close
set more off

/*  Project:          MO International Trade Model with heterogenous firms; NAFTA  Authors           Nils Gudat, Ryan Weldzius  File location:    Documents/Research/Economic_Geography/trade_competition/data/OECD/Stata_files*/

log using /Users/ryanweldzius/Dropbox/GudatWeldzius_NAFTA_Paper/Data/Full_Dataset/analysis.log, replace
use /Users/ryanweldzius/Dropbox/GudatWeldzius_NAFTA_Paper/Data/Full_Dataset/data_full.dta

replace ppi_h = ppi_h/100 if market_h=="MEX"
*replace labprod_h = labprod_h*exchrate_h
*replace labprod_f = labprod_f*exchrate_f
drop group_industryid
egen group_industryid = group(id industry)
sort group_industryid year
xtset group_industryid year, yearly

*REPLACE ZEROS BEFORE TAKING LOGS*
replace tau_* = 0.0001 if tau_s_h == 0


*LOG LINEARIZE VARIABLES*

gen lntau_sh = ln(tau_s_h)
label variable lntau_sh "Log Tariff (Simple Avg)"
gen dlntau_sh = d.lntau_sh
label variable dlntau_sh "$\Delta$ Log Domestic Tariff"
gen Llntau_sh = L.lntau_sh
label variable Llntau_sh "Log Domestic Tariff (t-1)"
gen lntau_sh_KKM = ln(tau_s_h_KKM)
label variable lntau_sh_KKM "Log Tariff (Simple Avg) KKM"
gen dlntau_sh_KKM = d.lntau_sh_KKM
label variable dlntau_sh_KKM "$\Delta$ Log Domestic Tariff KKM"
gen Llntau_sh_KKM = L.lntau_sh_KKM
label variable Llntau_sh_KKM "Log Domestic Tariff (t-1) KKM"

gen lntau_sf = ln(tau_s_f)
label variable lntau_sf "Log Tariff (Simple Avg)"
gen dlntau_sf = d.lntau_sf
label variable dlntau_sf "$\Delta$ Log Foreign Tariff"
gen Llntau_sf = L.lntau_sf
label variable Llntau_sf "Log Foreign Tariff (t-1)"
gen lntau_sf_KKM = ln(tau_s_f_KKM)
label variable lntau_sf_KKM "Log Tariff (Simple Avg) KKM"
gen dlntau_sf_KKM = d.lntau_sf_KKM
label variable dlntau_sf_KKM "$\Delta$ Log Foreign Tariff KKM"
gen Llntau_sf_KKM = L.lntau_sf_KKM
label variable Llntau_sf_KKM "Log Foreign Tariff (t-1) KKM"

gen lntau_sht = ln(tau_s_ht)
label variable lntau_sht "Log Domestic-Third Country Tariff"
gen dlntau_sht = D.lntau_sht
label variable dlntau_sht "$\Delta$ Log Domestic-Third Country Tariff"
gen Llntau_sht = L.lntau_sht
label variable Llntau_sht "Log Domestic-Third Country Tariff (t-1)"
gen lntau_sht_KKM = ln(tau_s_ht_KKM)
label variable lntau_sht_KKM "Log Domestic-Third Country Tariff KKM"
gen dlntau_sht_KKM = D.lntau_sht_KKM
label variable dlntau_sht_KKM "$\Delta$ Log Domestic-Third Country Tariff KKM"
gen Llntau_sht_KKM = L.lntau_sht_KKM
label variable Llntau_sht_KKM "Log Domestic-Third Country Tariff (t-1) KKM"

gen lntau_sth = ln(tau_s_th)
label variable lntau_sth "Log Third Country-Domestic Tariff"
gen dlntau_sth = d.lntau_sth
label variable dlntau_sth "$\Delta$ Log Third Country-Domestic Tariff"
gen Llntau_sth = L.lntau_sth
label variable Llntau_sth "Log Third Country-Domestic Tariff (t-1)"
gen lntau_sth_KKM = ln(tau_s_th_KKM)
label variable lntau_sth_KKM "Log Third Country-Domestic Tariff KKM"
gen dlntau_sth_KKM = d.lntau_sth_KKM
label variable dlntau_sth_KKM "$\Delta$ Log Third Country-Domestic Tariff KKM"
gen Llntau_sth_KKM = L.lntau_sth_KKM
label variable Llntau_sth_KKM "Log Third Country-Domestic Tariff (t-1) KKM"

gen lntau_sft = ln(tau_s_ft)
label variable lntau_sft "Log Foreign-Third Country Tariff"
gen dlntau_sft = d.lntau_sft
label variable dlntau_sft "$\Delta$ Log Foreign-Third Country Tariff"
gen Llntau_sft = L.lntau_sft
label variable Llntau_sft "Log Foreign-Third Country Tariff (t-1)"
gen lntau_sft_KKM = ln(tau_s_ft_KKM)
label variable lntau_sft_KKM "Log Foreign-Third Country Tariff KKM"
gen dlntau_sft_KKM = d.lntau_sft_KKM
label variable dlntau_sft_KKM "$\Delta$ Log Foreign-Third Country Tariff KKM"
gen Llntau_sft_KKM = L.lntau_sft_KKM
label variable Llntau_sft_KKM "Log Foreign-Third Country Tariff (t-1) KKM"

gen lntau_stf = ln(tau_s_tf)
label variable lntau_stf "Log Third Country-Foreign Tariff"
gen dlntau_stf = d.lntau_stf
label variable dlntau_stf "$\Delta$ Log Third Country-Foreign Tariff"
gen Llntau_stf = L.lntau_stf
label variable Llntau_stf "Log Third Country-Foreign Tariff (t-1)"
gen lntau_stf_KKM = ln(tau_s_tf_KKM)
label variable lntau_stf_KKM "Log Third Country-Foreign Tariff KKM"
gen dlntau_stf_KKM = d.lntau_stf_KKM
label variable dlntau_stf_KKM "$\Delta$ Log Third Country-Foreign Tariff KKM"
gen Llntau_stf_KKM = L.lntau_stf_KKM
label variable Llntau_stf_KKM "Log Third Country-Foreign Tariff (t-1) KKM"

gen lnopen_h = ln(open_h)
label variable lnopen_h "Log Domestic Openness"
gen dlnopen_h = d.lnopen_h
label variable dlnopen_h "$\Delta$ Log Domestic Openness"
gen Llnopen_h = L.lnopen_h
label variable Llnopen_h "Log Domestic Openness (t-1)"

gen lnopen_f = ln(open_f)
label variable lnopen_f "Log Foreign Openness"
gen dlnopen_f = d.lnopen_f
label variable dlnopen_f "$\Delta$ Log Foreign Openness"
gen Llnopen_f = L.lnopen_f
label variable Llnopen_f "Log Foreign Openness (t-1)"

gen lnopen_t = ln(open_t)
label variable lnopen_t "Log Third Country Openness"
gen dlnopen_t = d.lnopen_t
label variable dlnopen_t "$\Delta$ Log Third Country Openness"
gen Llnopen_t = L.lnopen_t
label variable Llnopen_t "Log Third Country Openness (t-1)"

gen lnwage_h = ln(wage_h)
label variable lnwage_h "Log Domestic Wages"
gen dlnwage_h = d.lnwage_h
label variable dlnwage_h "$\Delta$ Log Domestic Wages"
gen llnwage_h = L.lnwage_h
label variable llnwage_h "Log Domestic Wages (t-1)"

gen lnwage_f = ln(wage_f)
label variable lnwage_f "Log Foreign Wages"
gen dlnwage_f = d.lnwage_f
label variable dlnwage_f "$\Delta$ Log Foreign Wages"
gen llnwage_f = L.lnwage_f
label variable llnwage_f "Log Foreign Wages (t-1)"

gen lneconomy_h = ln(employment_h)
label variable lneconomy_h "Log Domestic Market Size"
gen dlneconomy_h = d.lneconomy_h
label variable dlneconomy_h "$\Delta$ Log Domestic Market Size"
gen Llneconomy_h = L.lneconomy_h
label variable Llneconomy_h "Log Domestic Market Size (t-1)"

gen lneconomy_f = ln(employment_f)
label variable  lneconomy_f "Log Foreign Market Size"
gen dlneconomy_f = d.lneconomy_f
label variable  dlneconomy_f "$\Delta$ Log Foreign Market Size"
gen Llneconomy_f = L.lneconomy_f
label variable  Llneconomy_f "Log Foreign Market Size (t-1)"

gen lnfirms_h = ln(firms_h)
label variable lnfirms_h "Log Domestic Firms"
gen dlnfirms_h = d.lnfirms_h
label variable dlnfirms_h "$\Delta$ Log Domestic Firms"

gen lnfirms_f = ln(firms_f)
label variable lnfirms_f "Log Foreign Firms"
gen dlnfirms_f = d.lnfirms_f
label variable dlnfirms_f "$\Delta$ Log Foreign Firms"

gen lngdp_h = ln(gdp_h)
label variable lngdp_h "Log Domestic Real GDP (PPP)"
gen dlngdp_h = d.lngdp_h
label variable dlngdp_h "$\Delta$ Log Domestic Real GDP (PPP)"
gen Llngdp_h = L.lngdp_h
label variable Llngdp_h "Log Domestic Real GDP (t-1)"

gen lngdp_f = ln(gdp_f)
label variable lngdp_f "Log Foreign Real GDP (PPP)"
gen dlngdp_f = d.lngdp_f
label variable dlngdp_f "$\Delta$ Log Foreign Real GDP (PPP)"
gen Llngdp_f = L.lngdp_f
label variable Llngdp_f "Log Foreign Real GDP (t-1)"

gen lngdp_t = ln(gdp_t)
label variable lngdp_t "Log Third Country Real GDP (PPP)"
gen dlngdp_t = d.lngdp_t
label variable dlngdp_t "$\Delta$ Log Third Country Real GDP (PPP)"
gen Llngdp_t = L.lngdp_t
label variable Llngdp_t "Log Third Country Real GDP (PPP, t-1)"

gen lnopen_ind_h = ln(open_ind_h)
label variable lnopen_ind_h "Log Domestic Openness Index (Nominal)"
gen dlnopen_ind_h = d.lnopen_ind_h
label variable dlnopen_ind_h "$\Delta$ Log Domestic Openness Index (Nominal)"
gen Llnopen_ind_h = L.lnopen_ind_h
label variable Llnopen_ind_h "Log Domestic Openness Index (Nominal, t-1)"

gen lnopen_ind_f = ln(open_ind_f)
label variable lnopen_ind_f "Log Foreign Openness Index (Nominal)"
gen dlnopen_ind_f = d.lnopen_ind_f
label variable dlnopen_ind_f "$\Delta$ Log Foreign Openness Index (Nominal)"
gen Llnopen_ind_f = L.lnopen_ind_f
label variable Llnopen_ind_f "Log Foreign Openness Index (Nominal, t-1)"

gen lnopen_ind_t = ln(open_ind_t)
label variable lnopen_ind_t "Log Third Country Openness Index (Nominal)"
gen dlnopen_ind_t = d.lnopen_ind_t
label variable dlnopen_ind_t "$\Delta$ Log Third Country Openness Index (Nominal)"
gen Llnopen_ind_t = L.lnopen_ind_t
label variable Llnopen_ind_t "Log Third Country Openness Index (Nominal, t-1)"

gen lnopen_ind_r_h = ln(open_ind_r_h)
label variable lnopen_ind_r_h "Log Domestic Openness Index (Real)"
gen dlnopen_ind_r_h = d.lnopen_ind_r_h
label variable dlnopen_ind_r_h "$\Delta$ Log Domestic Openness Index (Real)"
gen Llnopen_ind_r_h = L.lnopen_ind_r_h
label variable Llnopen_ind_r_h "Log Domestic Openness Index (Real, t-1)"

gen lnopen_ind_r_f = ln(open_ind_r_f)
label variable lnopen_ind_r_f "Log Foreign Openness Index (Real)"
gen dlnopen_ind_r_f = d.lnopen_ind_r_f
label variable dlnopen_ind_r_f "$\Delta$ Log Foreign Openness Index (Real)"
gen Llnopen_ind_r_f = L.lnopen_ind_r_f
label variable Llnopen_ind_r_f "Log Foreign Openness Index (Real, t-1)"

gen lnopen_ind_r_t = ln(open_ind_r_t)
label variable lnopen_ind_r_t "Log Third Country Openness Index (Real)"
gen dlnopen_ind_r_t = d.lnopen_ind_r_t
label variable dlnopen_ind_r_t "$\Delta$ Log Third Country Openness Index (Real)"
gen Llnopen_ind_r_t = L.lnopen_ind_r_t
label variable Llnopen_ind_r_t "Log Third Country Openness Index (Real, t-1)"



//Smooth jumps in Canadian firm data due to reclassification in 1999-2000 and 2003-2004

generate d_ln_firms_h = d.lnfirms_h
generate d_ln_firms_f = d.lnfirms_f
replace d_ln_firms_h = (d_ln_firms_h[_n-1]+d_ln_firms_h[_n+1])/2 if market_h=="CAN" & year==2000  /* replace jumps in Canadian firm data with averages */
replace d_ln_firms_h = (d_ln_firms_h[_n-1]+d_ln_firms_h[_n+1])/2 if market_h=="CAN" & year==2004
replace d_ln_firms_f = (d_ln_firms_f[_n-1]+d_ln_firms_f[_n+1])/2 if market_f=="CAN" & year==2000
replace d_ln_firms_f = (d_ln_firms_f[_n-1]+d_ln_firms_f[_n+1])/2 if market_f=="CAN" & year==2004
drop lnfirms_h lnfirms_f

label variable d_ln_firms_h "$\Delta$ Log Domestic Firms"
label variable d_ln_firms_f "$\Delta$ Log Foreign Firms"


*LOG RELATIVE VARIABLES*
gen rel_tau = ln(tau_s_h/tau_s_f)
label variable rel_tau "Log Relative Tariffs"
gen drel_tau = d.rel_tau
label variable drel_tau "$\Delta$ Log Relative Tariffs"
gen Lrel_tau = L.rel_tau
label variable Lrel_tau "Log Relative Tariffs (t-1)"
gen rel_tau_KKM = ln(tau_s_h_KKM/tau_s_f_KKM)
label variable rel_tau_KKM "Log Relative Tariffs KKM"
gen drel_tau_KKM = d.rel_tau_KKM
label variable drel_tau_KKM "$\Delta$ Log Relative Tariffs KKM"
gen Lrel_tau_KKM = L.rel_tau_KKM
label variable Lrel_tau_KKM "Log Relative Tariffs (t-1) KKM"

gen rel_ppi = ln(ppi_h/ppi_f)
label variable rel_ppi "Log Relative PPI"
gen drel_ppi = d.rel_ppi
label variable drel_ppi "$\Delta$ Log Relative PPI"
gen lrel_ppi = l.rel_ppi
label variable lrel_ppi "Log Relative PPI (t-1)"
gen dlrel_ppi = d.lrel_ppi
label variable dlrel_ppi "$\Delta$ Log Relative PPI (t-1)"

gen rel_markup = ln(markup_h/markup_f)
label variable rel_markup "Log Relative Markup"
gen drel_markup = d.rel_markup
label variable drel_markup "$\Delta$ Log Relative Markup"
gen lrel_markup = L.rel_markup
label variable lrel_markup "Log Relative Markup (t-1)"
gen dlrel_markup = d.lrel_markup
label variable dlrel_markup "$\Delta$ Log Relative Markup (t-1)"

gen rel_productivity = ln(productivity_h/productivity_f)
label variable rel_productivity "Log Relative Productivity"
gen drel_productivity = d.rel_productivity
label variable drel_productivity "$\Delta$ Log Relative Productivity"
gen lrel_productivity = L.rel_productivity
label variable lrel_productivity "Log Relative Productivity (t-1)"
gen dlrel_productivity = d.lrel_productivity
label variable dlrel_productivity "$\Delta$ Log Relative Productivity (t-1)"

gen rel_economy = ln(employment_h/employment_f)
label variable rel_economy "Log Relative Size of Economy (Emp)"
gen drel_economy = d.rel_economy
label variable drel_economy "$\Delta$ Log Relative Size of Economy (Emp)"
gen Lrel_economy = L.rel_economy
label variable Lrel_economy "Log Relative Size of Economy (Emp, t-1)"

gen rel_gdp = ln(gdp_h/gdp_f)
label variable rel_gdp "Log Relative Size of Economy (GDP)"
gen drel_gdp = d.rel_gdp
label variable drel_gdp "$\Delta$ Log Relative Size of Economy (GDP)"
gen lrel_gdp = L.rel_gdp
label variable lrel_gdp "Log Relative Size of Economy (GDP, t-1)"

gen rel_open = ln(open_h/open_f)
label variable rel_open "Log Relative Openness"
gen drel_open = d.rel_open
label variable drel_open "$\Delta$ Log Relative Openness"
gen Lrel_open = L.rel_open
label variable Lrel_open "Log Relative Openness (t-1)"

gen rel_open_ind = ln(open_ind_h/open_ind_f)
label variable rel_open_ind "Log Relative Openness Index (Nominal)"
gen drel_open_ind = d.rel_open_ind
label variable drel_open_ind "$\Delta$ Log Relative Openness Index (Nominal)"
gen lrel_open_ind = L.rel_open_ind
label variable lrel_open_ind "Log Relative Openness Index (Nominal, t-1)"

gen rel_open_ind_r = ln(open_ind_r_h/open_ind_r_f)
label variable rel_open_ind_r "Log Relative Openness Index (Real)"
gen drel_open_ind_r = d.rel_open_ind_r
label variable drel_open_ind_r "$\Delta$ Log Relative Openness Index (Real)"
gen Lrel_open_ind_r = L.rel_open_ind_r
label variable Lrel_open_ind_r "Log Relative Openness Index (Real, t-1)"

gen rel_wage = ln(wage_h/wage_f)
label variable rel_wage "Log Relative Wage"
gen drel_wage = d.rel_wage
label variable drel_wage "$\Delta$ Log Relative Wage"
gen lrel_wage = L.rel_wage
label variable lrel_wage "Log Relative Wage (t-1)"

gen free_entry=0
replace free_entry=1 if industry==20 | industry==28 | industry==36
gen no_entry=0
replace no_entry=1 if industry==15 | industry==21 | industry==23

save /Users/ryanweldzius/Dropbox/GudatWeldzius_NAFTA_Paper/Data/Full_Dataset/data_nafta_final.dta, replace

sort group_industryid year
tsset group_industryid year, yearly


*dfuller rel_ppi
*dfuller rel_markup
*dfuller rel_labprod


/*
**************************************************
*			 UNIT ROOT TESTS					 *
**************************************************
xtunitroot llc tau_s_h
xtunitroot ips tau_s_h
xtunitroot breitung tau_s_h

xtunitroot llc open_h if year<=2006
xtunitroot ips open_h if year<=2006
xtunitroot breitung open_h if year<=2006

xtunitroot llc ppi_h
xtunitroot ips ppi_h
xtunitroot breitung ppi_h

xtunitroot llc markup_h if year<=2005
xtunitroot ips markup_h if year<=2005
xtunitroot breitung markup_h if year<=2005

xtunitroot llc productivity_h if year<=2006
xtunitroot ips productivity_h if year<=2006
xtunitroot breitung productivity_h if year<=2006
*/

*XTGLS Models with AR(1) Process; FE on Country/Industry Pair*

**************************************************
* TABLE 1: PRICES (SHORT RUN), ALL COUNTRY PAIRS *
**************************************************
keep if year>=1994

//ALL COUNTRY PAIRS
// Original Chen et al Regression with tariffs and openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") replace
// Third country included
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append
// As above, with openness index instead of openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append
// Relative variables as regressors
xtgls drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
//outreg2 dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_1.tex, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1.tex, nocons label ctitle(" ") append


***************************************************
* TABLE 2: MARKUPS (SHORT RUN), ALL COUNTRY PAIRS *
***************************************************

// Original Chen et al. Regression
xtgls drel_markup dlntau_sh dlntau_sf  dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf  dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2.tex, nocons label ctitle(" ") replace
// Third country included
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2.tex, nocons label ctitle(" ") append
// As above, with openness index instead of openness
xtgls drel_markup dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2.tex, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2, nocons label ctitle(" ") append
// Relative variables as regressors
xtgls drel_markup dlrel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlrel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_2, nocons label ctitle(" ") append
xtgls drel_markup dlrel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlrel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_2, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_markup dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2.tex, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2, nocons label ctitle(" ") append


********************************************************
* TABLE 3: PRODUCTIVITY (SHORT RUN), ALL COUNTRY PAIRS *
********************************************************

//Original Chen et al. Regression
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") replace
//Third country included
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_productivity dlrel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlrel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_3,nocons label ctitle(" ") append
xtgls drel_productivity dlrel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlrel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_3, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3, nocons label ctitle(" ") append



**************************************************
* TABLE 4: PRICES (LONG RUN), ALL COUNTRY PAIRS  *
**************************************************

//Original Chen et al. regression
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") replace
//Third country included
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp using Table_4,nocons label ctitle(" ") append
xtgls drel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp using Table_4, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_4, nocons label ctitle(" ") append


**************************************************
* TABLE 5: MARKUPS (LONG RUN), ALL COUNTRY PAIRS *
**************************************************

//Original Chen et al regression
xtgls drel_markup dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") replace
//Third Country included
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_markup dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open lrel_gdp i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open lrel_gdp using Table_5, nocons label ctitle(" ") append
xtgls drel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open_ind lrel_gdp i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open_ind lrel_gdp using Table_5, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5, nocons label ctitle(" ") append


*******************************************************
* TABLE 6: PRODUCTIVITY (LONG RUN), ALL COUNTRY PAIRS *
*******************************************************

//Original Chen et al regression
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") replace
//Third Country included
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open lrel_gdp lrel_wage i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open lrel_gdp using Table_6, nocons label ctitle(" ") append
xtgls drel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open_ind lrel_gdp lrel_wage i.group_industryid, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open_ind lrel_gdp using Table_6, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6, nocons label ctitle(" ") append

*/

***************************************************************************************
* using alternative specification, splitting sample into high/low turnover industries *
***************************************************************************************

* Generate Dummy variables that assign industries Wood&Cork (20), Machinery and Transportation (28) and Manufacturing n.e.c. (36) to the long run sample and industries Food, Beverages, Tobacco (15), Chemicals, Plastics etc (23) and Paper and Printing (34) to the short run sample
gen free_entry=0
replace free_entry=1 if industry==20 | industry==28 | industry==36
gen no_entry=0
replace no_entry=1 if industry==15 | industry==21 | industry==23

//ALL COUNTRY PAIRS
// Original Chen et al Regression with tariffs and openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") replace
// Third country included
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append
// As above, with openness index instead of openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append
// Relative variables as regressors
xtgls drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using free_entry Table_1.tex, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry i.group_industryid, corr(psar1) force
outreg2 drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f free_entry using Table_1.tex, nocons label ctitle(" ") append



gen shortrun = 0
replace shortrun = 1 if industry==15 | industry==23 | industry==27

gen longrun = 0
replace longrun = 1 if industry==20 | industry==28 | industry==36


*****************************************************
* TABLE 1 (cont.): PRICES (SHORT RUN), SPLIT SAMPLE *
*****************************************************

// Original Chen et al Regression with tariffs and openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") replace
// Third country included
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append
// As above, with openness index instead of openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append
// Relative variables as regressors
xtgls drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 drel_ppi dlrel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlrel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_1sr.tex, tex(frag) se coefastr symb(***,**,*) rdec(3) bdec(3) r2 nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_1sr.tex, nocons label ctitle(" ") append



******************************************************
* TABLE 2 (cont.): MARKUPS (SHORT RUN), SPLIT SAMPLE *
******************************************************

// Original Chen et al Regression
xtgls drel_markup dlntau_sh dlntau_sf  dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf  dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2sr.tex, nocons label ctitle(" ") replace
// Third country included
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2sr.tex, nocons label ctitle(" ") append
// As above, with openness index instead of openness
xtgls drel_markup dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf  dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2sr.tex, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2sr, nocons label ctitle(" ") append
// Relative variables as regressors
xtgls drel_markup dlrel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlrel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_2sr, nocons label ctitle(" ") append
xtgls drel_markup dlrel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlrel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_2sr, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2sr.tex, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2sr, nocons label ctitle(" ") append


*********************************************************
* TABLE 3 (cont.): PRODUCTIVITY (SHORT RUN), SPLIT SAMPLE
*********************************************************

//Original Chen et al Regression
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_3sr, nocons label ctitle(" ") replace
//Third country included
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_3sr, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3sr, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_3sr, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_productivity dlrel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlrel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f using Table_3,nocons label ctitle(" ") append
xtgls drel_productivity dlrel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f i.group_industryid, corr(psar1) force
outreg2 dlrel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f using Table_3sr, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f using Table_2sr.tex, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f i.group_industryid if shortrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f using Table_2sr, nocons label ctitle(" ") append



**************************************************
* TABLE 4 (cont.): PRICES (LONG RUN), SPLIT SAMPLE
**************************************************

//Original Chen et al regression
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") replace
//Third country included
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_ppi dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_ppi drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp using Table_4lr,nocons label ctitle(" ") append
xtgls drel_ppi drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_ppi Lrel_tau lrel_open_ind lrel_gdp using Table_4lr, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") append
xtgls drel_ppi dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_ppi Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_4lr, nocons label ctitle(" ") append



*****************************************************
* TABLE 5 (cont.): MARKUPS (LONG RUN), SPLIT SAMPLE *
*****************************************************

//Original Chen et al regression
xtgls drel_markup dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") replace
//Third Country included
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_markup dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_markup drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open lrel_gdp i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open lrel_gdp using Table_5lr, nocons label ctitle(" ") append
xtgls drel_markup drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open_ind lrel_gdp i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_markup Lrel_tau lrel_open_ind lrel_gdp using Table_5lr, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") append
xtgls drel_markup dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_markup Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f using Table_5lr, nocons label ctitle(" ") append



**********************************************************
* TABLE 6 (cont.): PRODUCTIVITY (LONG RUN), SPLIT SAMPLE *
**********************************************************

//Original Chen et al regression
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") replace
//Third Country included
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_h dlnopen_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_h Llnopen_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") append
//As above, with openness index instead of openness
xtgls drel_productivity dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh dlntau_sf dlntau_sht dlntau_sth dlntau_sft dlntau_stf dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh Llntau_sf Llntau_sht Llntau_sth Llntau_sft Llntau_stf Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") append
//Relative variables as regressors
xtgls drel_productivity drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open lrel_gdp lrel_wage i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open lrel_gdp using Table_6lr, nocons label ctitle(" ") append
xtgls drel_productivity drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open_ind lrel_gdp lrel_wage i.group_industryid if longrun==1, corr(psar1) force
outreg2 drel_tau drel_open_ind d_ln_firms_h d_ln_firms_f lrel_productivity Lrel_tau lrel_open_ind lrel_gdp using Table_6lr, tex(frag) nocons label ctitle(" ") append
// Robustness Check: Krebs, Krishna, Maloney (KKM) tariff data for Mexico 1989-1998
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh_KKM Llntau_sf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") append
xtgls drel_productivity dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f i.group_industryid if longrun==1, corr(psar1) force
outreg2 dlntau_sh_KKM dlntau_sf_KKM dlntau_sht_KKM dlntau_sth_KKM dlntau_sft_KKM dlntau_stf_KKM dlnopen_ind_h dlnopen_ind_f d_ln_firms_h d_ln_firms_f lrel_productivity Llntau_sh_KKM Llntau_sf_KKM Llntau_sht_KKM Llntau_sth_KKM Llntau_sft_KKM Llntau_stf_KKM Llnopen_ind_h Llnopen_ind_f Llngdp_h Llngdp_f llnwage_h llnwage_f using Table_6lr, nocons label ctitle(" ") append


bysort market_h: sum tau_s_h open_ind_h productivity_h markup_h
bysort market_f: sum tau_s_f open_ind_f productivity_f markup_f
bysort industry: sum tau_s_h open_ind_h productivity_h markup_h
