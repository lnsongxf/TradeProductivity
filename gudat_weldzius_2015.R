################################################################################
#################     The Competitive Effects of Trade       ###################
#################     Liberalization in North America        ###################
#################       Nils Gudat and Ryan Weldzius         ###################
################################################################################

rm(list=ls())
path = "/Users/tew207/Dropbox/Trade Paper/Data/Raw/"

# Working directory and packages
setwd(path)
require(data.table)
require(foreign)
require(plm)
require(stargazer)


# Basic parameters of analysis:
start <- 1981       
end   <- 2014
industries <- c(15,17,20,21,23,26,27,28,36)
ind_ISIC3 <-  c(31,32,33,34,35,36,37,38,39)
#industries4d<-c(3111,3112,3113,3114,3115,3116,3117,3118,3119,3121,3122,3131,
#                3132,3133,3134,3211,3212,3213,3214,3215,3219,3220,3231,3232,
#                3233,3240,3311,3312,3319,3320,3411,3412,3419,3420,3511,3512,
#                3513,3521,3522,3523,3529,3530,3540,3551,3559,3560,3610,3620,
#                3691,3692,3699,3710,3720,3811,3812,3813,3819,3821,3822,3823,
#                3824,3825,3829,3831,3832,3833,3839,3841,3842,3843,3844,3845,
#                3849,3851,3852,3853,3901,3902,3903,3909)
countries <- c("can", "usa", "mex")
years <- (start:end)
year <- rep(years ,length(industries)*3)                
id <- rep((1:(3*length(industries))), each=length(years)) 
industry <- rep(rep(industries,each=length(years)),3)               
market_h <- rep(c("can","can","mex"), each=length(years)*length(industries))
market_f <- rep(c("mex","usa","usa"), each=length(years)*length(industries))

data <- data.table(id, year, industry, market_h, market_f)

rm(industry, market_h, market_f, year, years, start, end, id)

################################################################################
############################## IMPORT DATA #####################################
################################################################################

# 1. Price Data
ppi_can <- read.csv(paste0(path, "prices/ppi_can.csv"))
ppi_mex <- read.csv(paste0(path, "prices/ppi_mex.csv"))
ppi_usa <- read.csv(paste0(path, "prices/ppi_usa.csv"))
cpi_can <- read.csv(paste0(path, "prices/cpi_can.csv"))
cpi_mex <- read.csv(paste0(path, "prices/cpi_mex.csv"))
cpi_usa <- read.csv(paste0(path, "prices/cpi_usa.csv"))

# 2. Markup Data
markup_can <- read.csv(paste0(path, "markup/markup_can.csv"))
markup_mex <- read.csv(paste0(path, "markup/markup_mex.csv"))
markup_usa <- read.csv(paste0(path, "markup/markup_usa.csv"))

# 3. Productivity Data
productivity_can <- read.csv(paste0(path, "productivity/productivity_can.csv"))
productivity_mex <- read.csv(paste0(path, "productivity/productivity_mex.csv"))
productivity_usa <- read.csv(paste0(path, "productivity/productivity_usa.csv"))

# 4. Tariff Data
tariffs <- read.csv(paste0(path, "tariffs/tariffs_final.csv"), 
                    stringsAsFactors=FALSE)
tariffs[tariffs=="Canada"] <- "can"
tariffs[tariffs=="Mexico"] <- "mex"
tariffs[tariffs=="United States"] <- "usa"
names(tariffs)[names(tariffs)=="good"] <- "industry"
names(tariffs)[names(tariffs)=="obs_id"] <- "id"
for (i in 1:length(industries)) {
  tariffs[tariffs==ind_ISIC3[i]] <- industries[i]
}

# 5. Openness Data
openness_can <- read.csv(paste0(path, "openness/openness_can.csv"))
openness_mex <- read.csv(paste0(path, "openness/openness_mex.csv"))
openness_usa <- read.csv(paste0(path, "openness/openness_usa.csv"))
open_ind_can <- read.csv(paste0(path, "openness/open_ind_can.csv"))
open_ind_mex <- read.csv(paste0(path, "openness/open_ind_mex.csv"))
open_ind_usa <- read.csv(paste0(path, "openness/open_ind_usa.csv"))

# 6. Market Size Data 
gdp_can <- read.csv(paste0(path, "market size/gdp_can.csv"))
gdp_mex <- read.csv(paste0(path, "market size/gdp_mex.csv"))
gdp_usa <- read.csv(paste0(path, "market size/gdp_usa.csv"))
employment_can <- read.csv(paste0(path, "market size/employment_can.csv"))
employment_mex <- read.csv(paste0(path, "market size/employment_mex.csv"))
employment_usa <- read.csv(paste0(path, "market size/employment_usa.csv"))

# 7. Firm Data
firms_can <- read.csv(paste0(path, "firms/firms_can.csv"))
firms_mex <- read.csv(paste0(path, "firms/firms_mex.csv"))
firms_usa <- read.csv(paste0(path, "firms/firms_usa.csv"))

# 8. Import/Export Data
imp_can <- read.csv(paste0(path, "imports-exports/imp_can.csv"))
imp_mex <- read.csv(paste0(path, "imports-exports/imp_mex.csv"))
imp_usa <- read.csv(paste0(path, "imports-exports/imp_usa.csv"))
exp_can <- read.csv(paste0(path, "imports-exports/exp_can.csv"))
exp_mex <- read.csv(paste0(path, "imports-exports/exp_mex.csv"))
exp_usa <- read.csv(paste0(path, "imports-exports/exp_usa.csv"))

# 9. Wage Data
wage_can<-read.csv(paste0(path, "Wages/wage_can.csv"))
wage_mex<-read.csv(paste0(path, "Wages/wage_mex.csv"))
wage_usa<-read.csv(paste0(path, "Wages/wage_usa.csv"))

# 10. Exchange Rate Data
fxrate_can <- read.csv(paste0(path, "fxrate/fxrate_can.csv"))
fxrate_mex <- read.csv(paste0(path, "fxrate/fxrate_mex.csv"))


################################################################################
########################### CONSTRUCT DATASET ##################################
################################################################################

variables <- 
  c("ppi_h","ppi_f", "productivity_h","productivity_f", "tau_hf", "tau_ht", 
    "tau_fh","tau_ft","tau_th","tau_tf","tau_hf_w", "tau_ht_w", "tau_fh_w", 
    "tau_ft_w","tau_th_w", "tau_tf_w", "openness_hf", "openness_ht", 
    "openness_fh", "openness_ft", "openness_th","openness_tf",
    "open_ind_h", "open_ind_f", "open_ind_t", "firms_h", "firms_f","gdp_h", 
    "gdp_f", "employment_h", "employment_f", "imp_h", "imp_f", "exp_h", 
    "exp_f", "wage_h", "wage_f", "cpi_h", "cpi_f")

data[, variables] <- as.double(NA)
rm(variables)


# Country-level data (merge by year only)
for (i in countries) {
  for (j in c("gdp_", "cpi_", "open_ind_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year"), all=T)
    data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
    data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
    rm(list=paste0(j,i))
  }
}

# Industry-level data (merge by year, industry)
for (i in countries) {
  for (j in c("ppi_", "markup_", "firms_", "wage_", "exp_", "imp_", 
              "productivity_", "employment_", "openness_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year", "industry"), all=T)
    rm(list=paste0(j,i))
    data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
    data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
  }
}

# Third country variables (tariffs, openness)
data[, openness_hf := openness_h]
data[, openness_fh := openness_f]
data[market_h=="can" & market_f=="mex", open_ind_t :=
       data[market_h=="can" & market_f=="usa", open_ind_f]]
data[market_h=="can" & market_f=="usa", open_ind_t :=
       data[market_h=="can" & market_f=="mex", open_ind_f]]
data[market_h=="mex" & market_f=="usa", open_ind_t :=
       data[market_h=="can" & market_f=="mex", open_ind_h]]

data[market_h=="can" & market_f=="mex", openness_ht :=
       data[market_h=="can" & market_f=="usa", openness_h]]
data[market_h=="can" & market_f=="mex", openness_th :=
       data[market_h=="can" & market_f=="usa", openness_f]]
data[market_h=="can" & market_f=="mex", openness_ft :=
       data[market_h=="mex" & market_f=="usa", openness_h]]
data[market_h=="can" & market_f=="mex", openness_tf :=
       data[market_h=="mex" & market_f=="usa", openness_f]]

data[market_h=="can" & market_f=="usa", openness_ht :=
       data[market_h=="can" & market_f=="mex", openness_h]]
data[market_h=="can" & market_f=="usa", openness_th :=
       data[market_h=="can" & market_f=="mex", openness_f]]
data[market_h=="can" & market_f=="usa", openness_ft :=
       data[market_h=="mex" & market_f=="usa", openness_f]]
data[market_h=="can" & market_f=="usa", openness_tf :=
       data[market_h=="mex" & market_f=="usa", openness_h]]

data[market_h=="mex" & market_f=="usa", openness_ht :=
       data[market_h=="can" & market_f=="mex", openness_f]]
data[market_h=="mex" & market_f=="usa", openness_th :=
       data[market_h=="can" & market_f=="mex", openness_h]]
data[market_h=="mex" & market_f=="usa", openness_ft :=
       data[market_h=="can" & market_f=="usa", openness_f]]
data[market_h=="mex" & market_f=="usa", openness_tf :=
       data[market_h=="can" & market_f=="usa", openness_h]]

data <- merge(data, tariffs, 
              by = c("year", "industry", "market_h", "market_f", "id"), all=T)

data[,tau_hf := tau_s_h]
data[,tau_fh := tau_s_f]
data[,tau_hf_w := tau_w_h]
data[,tau_fh_w := tau_w_f]

data[market_h=="can" & market_f=="mex", tau_ht :=
       data[market_h=="can" & market_f=="usa", tau_s_h]]
data[market_h=="can" & market_f=="mex", tau_th :=
       data[market_h=="can" & market_f=="usa", tau_s_f]]
data[market_h=="can" & market_f=="mex", tau_ft :=
       data[market_h=="mex" & market_f=="usa", tau_s_h]]
data[market_h=="can" & market_f=="mex", tau_tf :=
       data[market_h=="mex" & market_f=="usa", tau_s_f]]

data[market_h=="can" & market_f=="usa", tau_ht :=
       data[market_h=="can" & market_f=="mex", tau_s_h]]
data[market_h=="can" & market_f=="usa", tau_th :=
       data[market_h=="can" & market_f=="mex", tau_s_f]]
data[market_h=="can" & market_f=="usa", tau_ft :=
       data[market_h=="mex" & market_f=="usa", tau_s_f]]
data[market_h=="can" & market_f=="usa", tau_tf :=
       data[market_h=="mex" & market_f=="usa", tau_s_h]]

data[market_h=="mex" & market_f=="usa", tau_ht :=
       data[market_h=="can" & market_f=="mex", tau_s_f]]
data[market_h=="mex" & market_f=="usa", tau_th :=
       data[market_h=="can" & market_f=="mex", tau_s_h]]
data[market_h=="mex" & market_f=="usa", tau_ft :=
       data[market_h=="can" & market_f=="usa", tau_s_f]]
data[market_h=="mex" & market_f=="usa", tau_tf :=
       data[market_h=="can" & market_f=="usa", tau_s_h]]

data[market_h=="can" & market_f=="mex", tau_ht_w :=
       data[market_h=="can" & market_f=="usa", tau_w_h]]
data[market_h=="can" & market_f=="mex", tau_th_w :=
       data[market_h=="can" & market_f=="usa", tau_w_f]]
data[market_h=="can" & market_f=="mex", tau_ft_w :=
       data[market_h=="mex" & market_f=="usa", tau_w_h]]
data[market_h=="can" & market_f=="mex", tau_tf_w :=
       data[market_h=="mex" & market_f=="usa", tau_w_f]]

# Weighted tariffs
data[market_h=="can" & market_f=="usa", tau_ht_w :=
       data[market_h=="can" & market_f=="mex", tau_w_h]]
data[market_h=="can" & market_f=="usa", tau_th_w :=
       data[market_h=="can" & market_f=="mex", tau_w_f]]
data[market_h=="can" & market_f=="usa", tau_ft_w :=
       data[market_h=="mex" & market_f=="usa", tau_w_f]]
data[market_h=="can" & market_f=="usa", tau_tf_w :=
       data[market_h=="mex" & market_f=="usa", tau_w_h]]

data[market_h=="mex" & market_f=="usa", tau_ht_w :=
       data[market_h=="can" & market_f=="mex", tau_w_f]]
data[market_h=="mex" & market_f=="usa", tau_th_w :=
       data[market_h=="can" & market_f=="mex", tau_w_h]]
data[market_h=="mex" & market_f=="usa", tau_ft_w :=
       data[market_h=="can" & market_f=="usa", tau_w_f]]
data[market_h=="mex" & market_f=="usa", tau_tf_w :=
       data[market_h=="can" & market_f=="usa", tau_w_h]]

rm(tariffs)

# Add exchange rates
data <- merge(data, fxrate_can, by=("year"))
data <- merge(data, fxrate_mex, by=("year"))
rm(fxrate_can,fxrate_mex)

# Order data by country pair/industry id
data <- data[order(id)]
data[, c("X","X.1","X.2","X.3") := NULL]

################################################################################
##########################      ESTIMATION       ###############################
################################################################################

# Transform data into plm format (double check!)
data <- plm.data(data, c("id","year"))

# Read data (This shoudld go once our dataset is assembled):
#datgw <- read.dta("data_nafta_final.dta")


#####################################
#### TABLE 1: PRICES (SHORT RUN) ####
#####################################

gw.price.sr1 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)), 
      data=datgw, index=c("id"), model="within")
gw.price.sr2 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)), 
      data=datgw, index=c("group_industryid"), model="within")
gw.price.sr3 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) 
      + free_entry , data=datgw, index=c("id"), model="within")
gw.price.sr4 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) 
      + free_entry , data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.price.sr1, gw.price.sr2,
          title="Prices, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log \\theta_t$",
                             "$\\Delta \\log \\theta_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "Free Entry"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p}{p^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat = c("adj.rsq", "f", "ser"),
          float=F, out="gw_price_sr.tex")


######################################
#### TABLE 2: MARKUPS (SHORT RUN) ####
######################################

gw.mark.sr1 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(firms_h)) + diff(log(firms_f)), 
      data=datgw, index=c("id"), model="within")
gw.mark.sr2 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(firms_h)) + diff(log(firms_f)), 
      data=datgw, index=c("group_industryid"), model="within")
gw.mark.sr3 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)), 
      data=datgw, index=c("id"), model="within")
gw.mark.sr4 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)), 
      data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.mark.sr1, gw.mark.sr2, gw.mark.sr3, gw.mark.sr4,
          title="Markups, Short Run",
          covariate.labels = c("$\\Delta \\log \\tau_t$",
                               "$\\Delta \\log \\tau_t^*$",
                               "$\\Delta \\log \\theta$",
                               "$\\Delta \\log \\theta^*$",
                               "$\\Delta \\log D_{t}$",
                               "$\\Delta \\log D_{t-1}$"),
          dep.var.labels = "$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          omit.stat = c("adj.rsq","f","ser"),
          notes = c("Fixed effects for country pair"),
          float = F, out = "gw_mark_sr.tex")


###########################################
#### TABLE 3: PRODUCTIVITY (SHORT RUN) ####
###########################################

gw.prod.sr1 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h 
      + d_ln_firms_f , 
      data=datgw, index=c("id"), model="within")
gw.prod.sr2 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h 
      + d_ln_firms_f , 
      data=datgw, index=c("group_industryid"), model="within")
gw.prod.sr3 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)), 
      data=datgw, index=c("id"), model="within")
gw.prod.sr4 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)), 
      data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.prod.sr1, gw.prod.sr2, gw.prod.sr3, gw.prod.sr4,
          title="Productivity, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log \\theta_t$",
                             "$\\Delta \\log \\theta_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{z}{z^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="gw_prod_sr.tex")


####################################
#### TABLE 4: PRICES (LONG RUN) ####
####################################

gw.price.lr1 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) 
      + diff(log(firms_f)) + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) 
      + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) 
      + lag(log(gdp_f)), 
      data=datgw, index=c("id"), model="within")
gw.price.lr2 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) 
      + diff(log(firms_f)) + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) 
      + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) 
      + lag(log(gdp_f)), 
      data=datgw, index=c("group_industryid"), model="within")
gw.price.lr3 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f))
      + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) 
      + lag(log(open_f)) + lag(log(firms_h)) + lag(log(firms_f)) 
      + lag(log(gdp_h)) + lag(log(gdp_f)), 
      data=datgw, index=c("id"), model="within")
gw.price.lr4 <- 
  plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) 
      + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f))
      + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) 
      + lag(log(open_f)) + lag(log(firms_h)) + lag(log(firms_f)) 
      + lag(log(gdp_h)) + lag(log(gdp_f)), 
      data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.price.lr1, gw.price.lr2, gw.price.lr3, gw.price.lr4,
          title="Prices, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log \\theta$",
                             "$\\Delta \\log \\theta^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{p_{t-1}}{p_{t-1}^*} \\right)$",
                             "$\\log \\tau_{t-1}$",
                             "$\\log \\tau_{t-1}^*$",
                             "$\\log \\theta_{t-1}$",
                             "$\\log \\theta_{t-1}^*$",
                             "$\\log D_{t-1}$",
                             "$\\log D_{t-1}^*$",
                             "$\\log L_{t-1}$",
                             "$\\log L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p_t}{p_t^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="gw_price_lr.tex")


#####################################
#### TABLE 5: MARKUPS (LONG RUN) ####
#####################################

gw.mark.lr1 <- 
  plm(diff(log(prod_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) 
      + lag(lntau_sh) + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)), 
      data=datgw, index=c("id"), model="within")
gw.mark.lr2 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) 
      + lag(lntau_sh) + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)), 
      data=datgw, index=c("group_industryid"), model="within")
gw.mark.lr3 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(lntau_sh) 
      + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h))
      + lag(log(gdp_f)), 
      data=datgw, index=c("id"), model="within")
gw.mark.lr4 <- 
  plm(diff(log(markup_h/markup_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) 
      + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(lntau_sh)
      + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h)) 
      + lag(log(gdp_f)), 
      data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.mark.lr1, gw.mark.lr2, gw.mark.lr3, gw.mark.lr4,
          title="Markups, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau$",
                             "$\\Delta \\log \\tau^*$",
                             "$\\Delta \\log \\theta$",
                             "$\\Delta \\log \\theta^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{\\mu_{t-1}}{\\mu_{t-1}^*} \\right)$",
                             "$\\tau_{t-1}$",
                             "$\\tau_{t-1}^*$",
                             "$\\log \\theta_{t-1}$",
                             "$\\log \\theta_{t-1}^*$",
                             "$L_{t-1}$",
                             "$L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="gw_mark_lr.tex")


##########################################
#### TABLE 6: PRODUCTIVITY (LONG RUN) ####
##########################################

gw.prod.lr1 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h 
      + d_ln_firms_f + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) 
      + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) 
      + lag(log(wage_f)), 
      data=datgw, index=c("id"), model="within")
gw.prod.lr2 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h 
      + d_ln_firms_f + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) 
      + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) 
      + lag(log(wage_f)), 
      data=datgw, index=c("group_industryid"), model="within")
gw.prod.lr3 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + d_ln_firms_h + d_ln_firms_f
      + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) 
      + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) 
      + lag(log(wage_f)), 
      data=datgw, index=c("id"), model="within")
gw.prod.lr4 <- 
  plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) 
      + diff(log(open_h)) + diff(log(open_f)) + d_ln_firms_h + d_ln_firms_f
      + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) 
      + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) 
      + lag(log(wage_f)), 
      data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.prod.lr1, gw.prod.lr2, gw.prod.lr3, gw.prod.lr4,
           title="Productivity, Long Run",
           covariate.labels=c("$\\Delta \\log \\tau_t$",
                              "$\\Delta \\log \\tau_t^*$",
                              "$\\Delta \\log \\theta$",
                              "$\\Delta \\log \\theta^*$",
                              "$\\Delta \\log D_t$",
                              "$\\Delta \\log D_t^*$",
                              "$\\log \\left(\\frac{z_{t-1}}{z_{t-1}^*} \\right)$",
                              "$\\log \\tau_{t-1}$",
                              "$\\log \\tau_{t-1}^*$",
                              "$\\log \\theta_{t-1}$",
                              "$\\log \\theta_{t-1}^*$",
                              "$\\log L_{t-1}$",
                              "$\\log L_{t-1}^*$",
                              "$\\log w_{t-1}$",
                              "$\\log w_{t-1}^*$"),
           dep.var.labels="$\\Delta \\log \\left(\\frac{z}{z^*} \\right)$",
           notes = c("Fixed effects for country pair or industry/country pair"),
           omit.stat=c("adj.rsq","f","ser"),
           float=F, OUt="gw_prod_lr.tex")


# Produce a table of summary statistics
noprint <- c("year", "id", "industry", "ppi_h", "ppi_f", "tau_hf", "tau_ht",
             "tau_fh", "tau_ft", "tau_th", "tau_tf", "tau_hf_w", "tau_ht_w",
             "tau_fh_w", "tau_ft_w", "tau_th_w", "tau_tf_w", "open_ind_h",
             "open_ind_f", "gdp_h", "gdp_f", "imp_h", "imp_f", "exp_h", "cpi_h",
             "cpi_f", "imp_can", "imp_mex", "imp_usa", "exp_can", "exp_mex",
             "exp_usa", "tau_w_can_usa", "tau_w_can_mex", "tau_w_mex_can",
             "tau_w_mex_usa", "tau_w_usa_can", "tau_w_usa_mex")

sumstats <- stargazer(data, title = "Summary Statistics", omit = noprint, 
                      float = F, float.env = "sidewaystable",
                      out=paste0(path,"sumstats.tex"))
