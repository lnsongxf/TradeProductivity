
################################################################################
#################     The Competitive Effects of Trade       ###################
#################     Liberalization in North America        ###################
#################       Nils Gudat and Ryan Weldzius         ###################
################################################################################

rm(list=ls())
path = "/Users/tew207/Dropbox/Trade Paper/Data2014/Excel_Files/"

# Working directory and packages
setwd(path)
require(data.table)
require(foreign)
require(plm)
require(stargazer)


# Basic parameters of analysis:
start <- 1981       
end   <- 2012
industries <- c(15,17,20,21,23,26,27,28,36)
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
#ppi_can <- read.csv(paste0(path, "Prices/ppi_can.csv"))
ppi_mex <- read.csv(paste0(path, "Prices/ppi_mex.csv"))
#ppi_usa <- read.csv(paste0(path, "Prices/ppi_usa.csv"))
#cpi_can <- read.csv(paste0(path, "Prices/cpi_can.csv"))
#cpi_mex <- read.csv(paste0(path, "Prices/cpi_mex.csv"))
#cpi_usa <- read.csv(paste0(path, "Prices/cpi_usa.csv"))

# 2. Markup Data
# markup_can <- read.csv(paste0(path, "Markups/markup_can.csv"))
# markup_mex <- read.csv(paste0(path, "Markups/markup_mex.csv"))
# markup_usa <- read.csv(paste0(path, "Markups/markup_usa.csv"))

# 3. Productivity Data
# prod_can <- read.csv(paste0(path, "Productivity/prod_can.csv"))
# prod_mex <- read.csv(paste0(path, "Productivity/prod_mex.csv"))
# prod_usa <- read.csv(paste0(path, "Productivity/prod_usa.csv"))

# 4. Tariff Data
#tau_can <- read.csv(paste0(path, "Tariffs/tariffs_can.csv"))
#tau_mex <- read.csv(paste0(path, "Tariffs/tariffs_mex.csv"))
#tau_usa <- read.csv(paste0(path, "Tariffs/tariffs_usa.csv"))

# 5. Openness Data
# open_can <- read.csv(paste0(path, "Openness/open_can.csv"))
# open_mex <- read.csv(paste0(path, "Openness/open_mex.csv"))
# open_usa <- read.csv(paste0(path, "Openness/open_usa.csv"))
#open_ind_can <- read.csv(paste0(path, "Openness/open_ind_can.csv"))
#open_ind_mex <- read.csv(paste0(path, "Openness/open_ind_mex.csv"))
#open_ind_usa <- read.csv(paste0(path, "Openness/open_ind_usa.csv"))

# 6. Market Size Data 
gdp_can <- read.csv(paste0(path, "Market Size/gdp_can.csv"))
gdp_mex <- read.csv(paste0(path, "Market Size/gdp_mex.csv"))
gdp_usa <- read.csv(paste0(path, "Market Size/gdp_usa.csv"))
# emp_can <- read.csv(paste0(path, "GDP/emp_can.csv"))
# emp_mex <- read.csv(paste0(path, "GDP/emp_mex.csv"))
# emp_usa <- read.csv(paste0(path, "GDP/emp_usa.csv"))

# 7. Firm Data
# firms_can <- read.csv(paste0(path, "Firms/firms_can.csv"))
# firms_mex <- read.csv(paste0(path, "Firms/firms_mex.csv"))
# firms_usa <- read.csv(paste0(path, "Firms/firms_usa.csv"))

# 8. Import/Export Data
imp_can <- read.csv(paste0(path, "ImExports/imp_can.csv"))
imp_mex <- read.csv(paste0(path, "ImExports/imp_mex.csv"))
imp_usa <- read.csv(paste0(path, "ImExports/imp_usa.csv"))
exp_can <- read.csv(paste0(path, "ImExports/exp_can.csv"))
exp_mex <- read.csv(paste0(path, "ImExports/exp_mex.csv"))
exp_usa <- read.csv(paste0(path, "ImExports/exp_usa.csv"))

# 9. Wage Data
# wage_can<-read.csv(paste0(path, "Wages/wage_can.csv"))
# wage_mex<-read.csv(paste0(path, "Wages/wage_mex.csv"))
# wage_usa<-read.csv(paste0(path, "Wages/wage_can.csv"))

# 10. Exchange Rate Data
#fxrate_usa_can <- read.csv(paste0(path, "XRat/fxrate_USA_CAN.csv"))
#fxrate_usa_mex <- read.csv(paste0(path, "XRat/fxrate_USA_MEX.csv"))


################################################################################
########################### CONSTRUCT DATASET ##################################
################################################################################

variables <- 
  c("ppi_h","ppi_f", "prod_h","prod_f", "tau_hf", "tau_ht", "tau_fh","tau_ft",
    "tau_th","tau_tf","tau_hf_w", "tau_ht_w", "tau_fh_w", "tau_ft_w","tau_th_w", 
    "tau_tf_w", "open_hf", "open_ht", "open_fh", "open_ft", "open_th","opentf",
    "open_ind_h", "open_ind_f", "open_ind_t", "firms_h", "firms_f","gdp_h", 
    "gdp_f", "emp_h", "emp_f", "imp_h", "imp_f", "exp_h", "exp_f", "wage_h", 
    "wage_f", "cpi_h", "cpi_f")

data[, variables] <- as.double(NA)
rm(variables)


# Country-level data (merge by year only)
for (i in countries) {
  for (j in c("gdp_"", cpi_", "open_ind_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year"), all=T)
    data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
    data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
    rm(list=paste0(j,i))
  }
}

# Industry-level data (merge by year, industry)
for (i in countries) {
  for (j in c("ppi_", "markup_", "prod_", "open_", "firms_", "wage_", 
              "exp_", "imp_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year", "industry"), all=T)
    data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
    data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
    rm(list=paste0(j,i))
  }
  data <- merge(data, get(paste0("tau_",i)), by=c("year", "industry"), all=T)
  for (j in countries) {
    t <- countries[!countries %in% c(j,k)]
    data[market_h==i & market_f==j, tau_hf := get(paste0("tau_",i,"_",j))]
    data[market_h==i & market_f==j, tau_ht := get(paste0("tau_",i,"_",t))]
    data[market_h==i & market_f==j, tau_fh := get(paste0("tau_",j,"_",i))]
    data[market_h==i & market_f==j, tau_ft := get(paste0("tau_",j,"_",t))]
  }
  rm(list=paste0("tau_",i))
}

# Order data by country pair/industry id
data <- data[order(id)]

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

#_______________________________________________________________________________
#_______________________________________________________________________________
#_______________________________________________________________________________

#############################################
#### DATA FROM GUDAT AND WELDZIUS (2014) ####
#############################################


# Read data:
datgw <- read.dta("data_nafta_final.dta")


##########################################
#### TABLE 1: PRICES (SHORT RUN - GW) ####
##########################################

gw.price.sr1 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("id"), model="within")
gw.price.sr2 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("group_industryid"), model="within")
gw.price.sr3 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + free_entry + 0, data=datgw, index=c("id"), model="within")
gw.price.sr4 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + free_entry + 0, data=datgw, index=c("group_industryid"), model="within")

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


###########################################
#### TABLE 2: prodS (SHORT RUN - GW) ####
###########################################

gw.mark.sr1 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("id"), model="within")
gw.mark.sr2 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("group_industryid"), model="within")
gw.mark.sr3 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("id"), model="within")
gw.mark.sr4 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) + 0, data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.mark.sr1, gw.mark.sr2, gw.mark.sr3, gw.mark.sr4,
          title="prods, Short Run",
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


################################################
#### TABLE 3: PRODUCTIVITY (SHORT RUN - GW) ####
################################################

gw.prod.sr1 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h + d_ln_firms_f + 0, data=datgw, index=c("id"), model="within")
gw.prod.sr2 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h + d_ln_firms_f + 0, data=datgw, index=c("group_industryid"), model="within")
gw.prod.sr3 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)), data=datgw, index=c("id"), model="within")
gw.prod.sr4 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)), data=datgw, index=c("group_industryid"), model="within")

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


#########################################
#### TABLE 4: PRICES (LONG RUN - GW) ####
#########################################

gw.price.lr1 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f)) +
                     + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("id"), model="within")
gw.price.lr2 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f)) +
                      + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("group_industryid"), model="within")
gw.price.lr3 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) +
                      + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("id"), model="within")
gw.price.lr4 <- plm(diff(rel_ppi) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f)) +
                      + lag(rel_ppi) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(firms_h)) + lag(log(firms_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("group_industryid"), model="within")

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


##########################################
#### TABLE 5: prodS (LONG RUN - GW) ####
##########################################

gw.mark.lr1 <- 
  plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) 
                               + diff(log(firms_h)) + diff(log(firms_f))
                               + lag(log(prod_h/prod_f)) + lag(lntau_sh)
                               + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("id"), model="within")
gw.mark.lr2 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f))
                   + lag(log(prod_h/prod_f)) + lag(lntau_sh) + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("group_industryid"), model="within")
gw.mark.lr3 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f))
                   + lag(log(prod_h/prod_f)) + lag(lntau_sh)+ lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("id"), model="within")
gw.mark.lr4 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + diff(log(firms_h)) + diff(log(firms_f))
                   + lag(log(prod_h/prod_f)) + lag(lntau_sh)+ lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("group_industryid"), model="within")

stargazer(gw.mark.lr1, gw.mark.lr2, gw.mark.lr3, gw.mark.lr4,
          title="prods, Long Run",
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


###############################################
#### TABLE 6: PRODUCTIVITY (LONG RUN - GW) ####
###############################################

gw.prod.lr1 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h + d_ln_firms_f
                      + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) + lag(log(wage_f)) + 0, data=datgw, index=c("id"), model="within")
gw.prod.lr2 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + d_ln_firms_h + d_ln_firms_f
                   + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) + lag(log(wage_f)) + 0, data=datgw, index=c("group_industryid"), model="within")
gw.prod.lr3 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + d_ln_firms_h + d_ln_firms_f
                   + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) + lag(log(wage_f)) + 0, data=datgw, index=c("id"), model="within")
gw.prod.lr4 <- plm(diff(rel_productivity) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(open_h)) + diff(log(open_f)) + d_ln_firms_h + d_ln_firms_f
                   + lag(rel_productivity) + lag(lntau_sh) + lag(lntau_sf) + lag(log(open_h)) + lag(log(open_f)) + lag(log(gdp_h)) + lag(log(gdp_f)) + lag(log(wage_h)) + lag(log(wage_f)) + 0, data=datgw, index=c("group_industryid"), model="within")

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
