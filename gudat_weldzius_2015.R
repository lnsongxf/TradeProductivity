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
start <- 1988       
end   <- 2014
#industries <- c(15,17,20,21,23,26,27,28,36)
#ind_ISIC3 <-  c(31,32,33,34,35,36,37,38,39)
industries <- c(3111,3112,3113,3114,3115,3116,3118,3119,3121,3132,3133,3149,3152,
                3159,3169,3211,3212,3219,3221,3222,3231,3241,3251,3254,3255,3256,
                3259,3262,3271,3273,3274,3279,3312,3313,3314,3315,3321,3322,3323,
                3324,3325,3326,3327,3329,3331,3332,3333,3334,3335,3336,3339,3342,
                3344,3345,3351,3352,3353,3359,3362,3363,3371,3372,3379,3399)
countries <- c("can", "usa", "mex")
pairs = c("can-mex", "can-usa", "mex-usa")
years <- (start:end)
year <- rep(years ,length(industries)*3)                
id <- rep((1:(3*length(industries))), each=length(years)) 
pair_id <- rep((1:3), each = length(years)*length(industries))
industry <- rep(rep(industries,each=length(years)),3)               
market_h <- rep(c("can","can","mex"), each=length(years)*length(industries))
market_f <- rep(c("mex","usa","usa"), each=length(years)*length(industries))

data <- data.table(id, pair_id, year, industry, market_h, market_f)

rm(industry, market_h, market_f, year, years, start, end, id, pair_id)

################################################################################
############################## IMPORT DATA #####################################
################################################################################

# 1. Price Data
ppi_can <- data.table(fread(paste0(path, "prices/ppi_can.csv")))
ppi_mex <- data.table(fread(paste0(path, "prices/ppi_mex.csv")))
ppi_usa <- data.table(fread(paste0(path, "prices/ppi_usa.csv")))
ppi_can <- ppi_can[(industry %in% industries)]
ppi_mex <- ppi_mex[(industry %in% industries)]
ppi_usa <- ppi_usa[(industry %in% industries)]
#cpi_can <- fread(paste0(path, "prices/cpi_can.csv"))
#cpi_mex <- fread(paste0(path, "prices/cpi_mex.csv"))
#cpi_usa <- fread(paste0(path, "prices/cpi_usa.csv"))

# 2. Markup Data
#markup_can <- fread(paste0(path, "markup/markup_can.csv"))
#markup_mex <- fread(paste0(path, "markup/markup_mex.csv"))
#markup_usa <- fread(paste0(path, "markup/markup_usa.csv"))

# 3. Productivity Data
#productivity_can <- fread(paste0(path, "productivity/productivity_can.csv"))
#productivity_mex <- fread(paste0(path, "productivity/productivity_mex.csv"))
#productivity_usa <- fread(paste0(path, "productivity/productivity_usa.csv"))

# 4. Tariff Data
#tariffs <- fread(paste0(path, "tariffs/Other Tariff Data/tariffs_final.csv"), 
#                    stringsAsFactors=FALSE)
#tariffs[tariffs=="Canada"] <- "can"
#tariffs[tariffs=="Mexico"] <- "mex"
#tariffs[tariffs=="United States"] <- "usa"
#names(tariffs)[names(tariffs)=="good"] <- "industry"
#names(tariffs)[names(tariffs)=="obs_id"] <- "id"
#for (i in 1:length(industries)) {
#  tariffs[tariffs==ind_ISIC3[i]] <- industries[i]
#}
tariffs_can <- data.table(fread(paste0(path, "tariffs/tariffs_can.csv")))
tariffs_mex <- data.table(fread(paste0(path, "tariffs/tariffs_mex.csv")))
tariffs_usa <- data.table(fread(paste0(path, "tariffs/tariffs_usa.csv")))
tariffs_can <- tariffs_can[(industry %in% industries)]
tariffs_mex <- tariffs_mex[(industry %in% industries)]
tariffs_usa <- tariffs_usa[(industry %in% industries)]


# 5. Openness Data
#openness_can <- fread(paste0(path, "openness/openness_can.csv"))
#openness_mex <- fread(paste0(path, "openness/openness_mex.csv"))
#openness_usa <- fread(paste0(path, "openness/openness_usa.csv"))
#open_ind_can <- fread(paste0(path, "openness/open_ind_can.csv"))
#open_ind_mex <- fread(paste0(path, "openness/open_ind_mex.csv"))
#open_ind_usa <- fread(paste0(path, "openness/open_ind_usa.csv"))

# 6. Market Size Data 
gdp_can <- data.table(fread(paste0(path, "Market_Size/gdp_can.csv")))
gdp_mex <- data.table(fread(paste0(path, "Market_Size/gdp_mex.csv")))
gdp_usa <- data.table(fread(paste0(path, "Market_Size/gdp_usa.csv")))
#employment_can <- fread(paste0(path, "Market_Size/employment_can.csv"))
#employment_mex <- fread(paste0(path, "Market_Size/employment_mex.csv"))
#employment_usa <- fread(paste0(path, "Market_Size/employment_usa.csv"))

# 7. Firm Data
firms_can <- data.table(fread(paste0(path, "firms/firms_can.csv")))
firms_mex <- data.table(fread(paste0(path, "firms/firms_mex.csv")))
firms_usa <- data.table(fread(paste0(path, "firms/firms_usa.csv")))
# Only keep observations in our industry list
firms_can <- firms_can[(industry %in% industries)]
firms_mex <- firms_mex[(industry %in% industries)]
firms_usa <- firms_usa[(industry %in% industries)]

# 8. Import/Export Data
#imp_can <- fread(paste0(path, "imports-exports/imp_can.csv"))
#imp_mex <- fread(paste0(path, "imports-exports/imp_mex.csv"))
#imp_usa <- fread(paste0(path, "imports-exports/imp_usa.csv"))
#exp_can <- fread(paste0(path, "imports-exports/exp_can.csv"))
#exp_mex <- fread(paste0(path, "imports-exports/exp_mex.csv"))
#exp_usa <- fread(paste0(path, "imports-exports/exp_usa.csv"))

# 9. Wage Data
#wage_can<-fread(paste0(path, "Wages/wage_can.csv"))
#wage_mex<-fread(paste0(path, "Wages/wage_mex.csv"))
#wage_usa<-fread(paste0(path, "Wages/wage_usa.csv"))

# 10. Exchange Rate Data
#fxrate_can <- fread(paste0(path, "fxrate/fxrate_can.csv"))
#fxrate_mex <- fread(paste0(path, "fxrate/fxrate_mex.csv"))


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

dim.data.frame(data)
# Country-level data (merge by year only)
for (i in countries) {
  for (j in c("gdp_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year"), all=T)
    data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
    data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
    rm(list=paste0(j,i))
  }
}

# Industry-level data (merge by year, industry)
for (i in countries) {
  for (j in c("ppi_", "firms_", "tariffs_")) {
    data <- merge(data, get(paste0(j,i)), by = c("year", "industry"), all=T)
    rm(list=paste0(j,i))
    if (j != "tariffs_") {
      data[market_h==i, paste0(j,"h") := get(paste0(j,i))]
      data[market_f==i, paste0(j,"f") := get(paste0(j,i))]
    }
  }
}

# Third country variables (tariffs, openness)
# data[, openness_hf := openness_h]
# data[, openness_fh := openness_f]
# data[market_h=="can" & market_f=="mex", open_ind_t :=
#        data[market_h=="can" & market_f=="usa", open_ind_f]]
# data[market_h=="can" & market_f=="usa", open_ind_t :=
#        data[market_h=="can" & market_f=="mex", open_ind_f]]
# data[market_h=="mex" & market_f=="usa", open_ind_t :=
#        data[market_h=="can" & market_f=="mex", open_ind_h]]
# 
# data[market_h=="can" & market_f=="mex", openness_ht :=
#        data[market_h=="can" & market_f=="usa", openness_h]]
# data[market_h=="can" & market_f=="mex", openness_th :=
#        data[market_h=="can" & market_f=="usa", openness_f]]
# data[market_h=="can" & market_f=="mex", openness_ft :=
#        data[market_h=="mex" & market_f=="usa", openness_h]]
# data[market_h=="can" & market_f=="mex", openness_tf :=
#        data[market_h=="mex" & market_f=="usa", openness_f]]
# 
# data[market_h=="can" & market_f=="usa", openness_ht :=
#        data[market_h=="can" & market_f=="mex", openness_h]]
# data[market_h=="can" & market_f=="usa", openness_th :=
#        data[market_h=="can" & market_f=="mex", openness_f]]
# data[market_h=="can" & market_f=="usa", openness_ft :=
#        data[market_h=="mex" & market_f=="usa", openness_f]]
# data[market_h=="can" & market_f=="usa", openness_tf :=
#        data[market_h=="mex" & market_f=="usa", openness_h]]
# 
# data[market_h=="mex" & market_f=="usa", openness_ht :=
#        data[market_h=="can" & market_f=="mex", openness_f]]
# data[market_h=="mex" & market_f=="usa", openness_th :=
#        data[market_h=="can" & market_f=="mex", openness_h]]
# data[market_h=="mex" & market_f=="usa", openness_ft :=
#        data[market_h=="can" & market_f=="usa", openness_f]]
# data[market_h=="mex" & market_f=="usa", openness_tf :=
#        data[market_h=="can" & market_f=="usa", openness_h]]

#data <- merge(data, tariffs, 
#              by = c("year", "industry", "market_h", "market_f", "id"), all=T)


for (i in pairs) {
  h = unlist(strsplit(i,"-"))[1]
  f = unlist(strsplit(i,"-"))[2]
  t = countries[!(countries %in% c(h,f))]
  print(paste0("Now merging",h,f,t))
  data[market_h==h & market_f==f, tau_hf := get(paste0("tau_s_",h,"_",f))]
  data[market_h==h & market_f==f, tau_fh := get(paste0("tau_s_",f,"_",h))]
  data[market_h==h & market_f==f, tau_ht := get(paste0("tau_s_",h,"_",t))]
  data[market_h==h & market_f==f, tau_th := get(paste0("tau_s_",t,"_",h))]
  data[market_h==h & market_f==f, tau_ft := get(paste0("tau_s_",f,"_",t))]
  data[market_h==h & market_f==f, tau_tf := get(paste0("tau_s_",t,"_",f))]
}


# data[market_h=="can" & market_f=="mex", tau_hf := tau_s_can_mex]]
# data[market_h=="can" & market_f=="mex", tau_th :=
#        data[market_h=="can" & market_f=="usa", tau_s_f]]
# data[market_h=="can" & market_f=="mex", tau_ft :=
#        data[market_h=="mex" & market_f=="usa", tau_s_h]]
# data[market_h=="can" & market_f=="mex", tau_tf :=
#        data[market_h=="mex" & market_f=="usa", tau_s_f]]
# 
# data[market_h=="can" & market_f=="usa", tau_ht :=
#        data[market_h=="can" & market_f=="mex", tau_s_h]]
# data[market_h=="can" & market_f=="usa", tau_th :=
#        data[market_h=="can" & market_f=="mex", tau_s_f]]
# data[market_h=="can" & market_f=="usa", tau_ft :=
#        data[market_h=="mex" & market_f=="usa", tau_s_f]]
# data[market_h=="can" & market_f=="usa", tau_tf :=
#        data[market_h=="mex" & market_f=="usa", tau_s_h]]
# 
# data[market_h=="mex" & market_f=="usa", tau_ht :=
#        data[market_h=="can" & market_f=="mex", tau_s_f]]
# data[market_h=="mex" & market_f=="usa", tau_th :=
#        data[market_h=="can" & market_f=="mex", tau_s_h]]
# data[market_h=="mex" & market_f=="usa", tau_ft :=
#        data[market_h=="can" & market_f=="usa", tau_s_f]]
# data[market_h=="mex" & market_f=="usa", tau_tf :=
#        data[market_h=="can" & market_f=="usa", tau_s_h]]
# 
# data[market_h=="can" & market_f=="mex", tau_ht_w :=
#        data[market_h=="can" & market_f=="usa", tau_w_h]]
# data[market_h=="can" & market_f=="mex", tau_th_w :=
#        data[market_h=="can" & market_f=="usa", tau_w_f]]
# data[market_h=="can" & market_f=="mex", tau_ft_w :=
#        data[market_h=="mex" & market_f=="usa", tau_w_h]]
# data[market_h=="can" & market_f=="mex", tau_tf_w :=
#        data[market_h=="mex" & market_f=="usa", tau_w_f]]
# 
# # Weighted tariffs
# data[market_h=="can" & market_f=="usa", tau_ht_w :=
#        data[market_h=="can" & market_f=="mex", tau_w_h]]
# data[market_h=="can" & market_f=="usa", tau_th_w :=
#        data[market_h=="can" & market_f=="mex", tau_w_f]]
# data[market_h=="can" & market_f=="usa", tau_ft_w :=
#        data[market_h=="mex" & market_f=="usa", tau_w_f]]
# data[market_h=="can" & market_f=="usa", tau_tf_w :=
#        data[market_h=="mex" & market_f=="usa", tau_w_h]]
# 
# data[market_h=="mex" & market_f=="usa", tau_ht_w :=
#        data[market_h=="can" & market_f=="mex", tau_w_f]]
# data[market_h=="mex" & market_f=="usa", tau_th_w :=
#        data[market_h=="can" & market_f=="mex", tau_w_h]]
# data[market_h=="mex" & market_f=="usa", tau_ft_w :=
#        data[market_h=="can" & market_f=="usa", tau_w_f]]
# data[market_h=="mex" & market_f=="usa", tau_tf_w :=
#        data[market_h=="can" & market_f=="usa", tau_w_h]]
# 
# rm(tariffs)

# Add exchange rates
#data <- merge(data, fxrate_can, by=("year"))
#data <- merge(data, fxrate_mex, by=("year"))
#rm(fxrate_can,fxrate_mex)

# Order data by country pair/industry id
data <- data[order(id)]

# Replace zero values by 0.001 for taking logs
data[data < 0.001] <- 0.001

# Create relative ppi as dependent variable
data$rel_ppi <- data$ppi_h/data$ppi_f

# Entry conditions by industry:
data[,free_entry := 0]

free_entry_list = c(3159:3163, 3211:3219, 3231, 3321:3329, 3331:3339, 3371:3379, 3339)
fixed_entry_list = c(3111:3129, 3221, 3222, 3241, 3251:3259, 3312:3315)

data[industry %in% free_entry_list, free_entry := 1]
data[industry %in% fixed_entry_list, free_entry := 2]

# Smooth out jumps in Canadian and Mexican firm data


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

# FE on country-industry 
price.sr1 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) + 
  diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

# FE on country pair
price.sr2 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) + 
  diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

# Free entry sample, country-industry FE
price.sr3 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) + 
  diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

# Fixed entry sample, country-industry FE
price.sr4 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) +
  diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

# Free entry sample, country pair FE
price.sr5 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) + 
  diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

# Fixed entry sample, country pair FE
price.sr6 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) +
  diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

stargazer(price.sr1, price.sr2, price.sr3, price.sr4, price.sr5, price.sr6,
          title="Prices, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "Free Entry"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p}{p^*} \\right)$",
          notes = c("(1),(3): Fixed effects country-industry \\\\ (2),(4): Fixed effects country pair"),
          omit.stat = c("adj.rsq", "f", "ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_price_sr.tex")


######################################
#### TABLE 2: MARKUPS (SHORT RUN) ####
######################################

mark.sr1 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

mark.sr2 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

mark.sr3 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

mark.sr4 <- <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

mark.sr5 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

mark.sr6 <- <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(mark.sr1, mark.sr2, mark.sr3, mark.sr4, mark.sr5, mark.sr6,
          title="Markups, Short Run",
          covariate.labels = c("$\\Delta \\log \\tau_t$",
                               "$\\Delta \\log \\tau_t^*$",
                               "$\\Delta \\log D_{t}$",
                               "$\\Delta \\log D_{t-1}$"),
          dep.var.labels = "$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          omit.stat = c("adj.rsq","f","ser"),
          notes = c("(1),(3),(4): Fixed effects country-industry; (2),(5),(6): Fixed effect country pair"),
          float = F, out = "C:/Users/tew207/Documents/GitHub/Thesis/gw_mark_sr.tex")


###########################################
#### TABLE 3: PRODUCTIVITY (SHORT RUN) ####
###########################################

prod.sr1 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

prod.sr2 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

prod.sr3 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

prod.sr4 <- <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

prod.sr5 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

prod.sr6 <- <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(prod.sr1, prod.sr2, prod.sr3, prod.sr4, prod.sr5, prod.sr6,
          title="Productivity, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{z}{z^*} \\right)$",
          notes = c("(1),(3),(4): Fixed effects country-industry; (2),(5),(6): Fixed effect country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_prod_sr.tex")


####################################
#### TABLE 4: PRICES (LONG RUN) ####
####################################

price.lr1 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data, index=c("id"), model="within")

price.lr2 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data, index=c("pair_id"), model="within")

price.lr3 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==1], index=c("id"), model="within")

price.lr4 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==2], index=c("id"), model="within")

price.lr5 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==1], index=c("pair_id"), model="within")

price.lr6 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(price.lr1, price.lr2, price.lr3, price.lr4, price.lr5, price.lr6,
          title="Prices, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{p_{t-1}}{p_{t-1}^*} \\right)$",
                             "$\\log \\tau_{t-1}$",
                             "$\\log \\tau_{t-1}^*$",
                             "$\\log L_{t-1}$",
                             "$\\log L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p_t}{p_t^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_price_lr.tex")


#####################################
#### TABLE 5: MARKUPS (LONG RUN) ####
#####################################

mark.lr1 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data, index=c("id"), model="within")

mark.lr2 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data, index=c("pair_id"), model="within")

mark.lr3 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data[free_entry==1], index=c("id"), model="within")

mark.lr4 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==2], index=c("id"), model="within")

mark.lr5 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==1], index=c("pair_id"), model="within")

mark.lr6 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
  + lag(log(gdp_h)) + lag(log(gdp_f)), 
  data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(mark.lr1, mark.lr2, mark.lr3, mark.lr4, mark.lr5, mark.lr6,
          title="Markups, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau$",
                             "$\\Delta \\log \\tau^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{\\mu_{t-1}}{\\mu_{t-1}^*} \\right)$",
                             "$\\tau_{t-1}$",
                             "$\\tau_{t-1}^*$",
                             "$L_{t-1}$",
                             "$L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_mark_lr.tex")


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
           float=F, OUt="C:/Users/tew207/Documents/GitHub/Thesis/gw_prod_lr.tex")

#######################################
#### ADDING THIRD COUNTRY EFFECTS  ####
#######################################

#####################################
#### TABLE 1: PRICES (SHORT RUN) ####
#####################################

# FE on country-industry 
price.sr1 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

# FE on country pair
price.sr2 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh))
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

# Free entry sample, country-industry FE
price.sr3 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

# Fixed entry sample, country-industry FE
price.sr4 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh))
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

# Free entry sample, country pair FE
price.sr5 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh))  
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

# Fixed entry sample, country pair FE
price.sr6 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh))  
  + diff(log(tau_ht)) + diff(log(tau_th)) + diff(log(tau_ft)) + diff(log(tau_tf))
  + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

stargazer(price.sr1, price.sr2, price.sr3, price.sr4, price.sr5, price.sr6,
          title="Prices, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "Free Entry"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p}{p^*} \\right)$",
          notes = c("(1),(3): Fixed effects country-industry \\\\ (2),(4): Fixed effects country pair"),
          omit.stat = c("adj.rsq", "f", "ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_price_sr_third.tex")


######################################
#### TABLE 2: MARKUPS (SHORT RUN) ####
######################################

mark.sr1 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

mark.sr2 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

mark.sr3 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

mark.sr4 <- <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                   + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

mark.sr5 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

mark.sr6 <- <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                   + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(mark.sr1, mark.sr2, mark.sr3, mark.sr4, mark.sr5, mark.sr6,
          title="Markups, Short Run",
          covariate.labels = c("$\\Delta \\log \\tau_t$",
                               "$\\Delta \\log \\tau_t^*$",
                               "$\\Delta \\log D_{t}$",
                               "$\\Delta \\log D_{t-1}$"),
          dep.var.labels = "$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          omit.stat = c("adj.rsq","f","ser"),
          notes = c("(1),(3),(4): Fixed effects country-industry; (2),(5),(6): Fixed effect country pair"),
          float = F, out = "C:/Users/tew207/Documents/GitHub/Thesis/gw_mark_sr.tex")


###########################################
#### TABLE 3: PRODUCTIVITY (SHORT RUN) ####
###########################################

prod.sr1 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("id"), model="within")

prod.sr2 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data, index=c("pair_id"), model="within")

prod.sr3 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("id"), model="within")

prod.sr4 <- <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                   + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("id"), model="within")

prod.sr5 <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==1], index=c("pair_id"), model="within")

prod.sr6 <- <- plm(diff(log(productivity_h/productvity_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                   + diff(log(firms_h)) + diff(log(firms_f)), data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(prod.sr1, prod.sr2, prod.sr3, prod.sr4, prod.sr5, prod.sr6,
          title="Productivity, Short Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{z}{z^*} \\right)$",
          notes = c("(1),(3),(4): Fixed effects country-industry; (2),(5),(6): Fixed effect country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_prod_sr.tex")


####################################
#### TABLE 4: PRICES (LONG RUN) ####
####################################

price.lr1 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data, index=c("id"), model="within")

price.lr2 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data, index=c("pair_id"), model="within")

price.lr3 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data[free_entry==1], index=c("id"), model="within")

price.lr4 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data[free_entry==2], index=c("id"), model="within")

price.lr5 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data[free_entry==1], index=c("pair_id"), model="within")

price.lr6 <- plm(diff(log(ppi_h/ppi_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                 + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(ppi_h/ppi_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                 + lag(log(gdp_h)) + lag(log(gdp_f)), 
                 data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(price.lr1, price.lr2, price.lr3, price.lr4, price.lr5, price.lr6,
          title="Prices, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau_t$",
                             "$\\Delta \\log \\tau_t^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{p_{t-1}}{p_{t-1}^*} \\right)$",
                             "$\\log \\tau_{t-1}$",
                             "$\\log \\tau_{t-1}^*$",
                             "$\\log L_{t-1}$",
                             "$\\log L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{p_t}{p_t^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_price_lr.tex")


#####################################
#### TABLE 5: MARKUPS (LONG RUN) ####
#####################################

mark.lr1 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data, index=c("id"), model="within")

mark.lr2 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data, index=c("pair_id"), model="within")

mark.lr3 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data[free_entry==1], index=c("id"), model="within")

mark.lr4 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data[free_entry==2], index=c("id"), model="within")

mark.lr5 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data[free_entry==1], index=c("pair_id"), model="within")

mark.lr6 <- plm(diff(log(markup_h/markup_f)) ~ diff(log(tau_hf)) + diff(log(tau_fh)) 
                + diff(log(firms_h)) + diff(log(firms_f)) + lag(log(markup_h/markup_f)) + lag(log(tau_hf)) + lag(log(tau_fh)) 
                + lag(log(gdp_h)) + lag(log(gdp_f)), 
                data=data[free_entry==2], index=c("pair_id"), model="within")

stargazer(mark.lr1, mark.lr2, mark.lr3, mark.lr4, mark.lr5, mark.lr6,
          title="Markups, Long Run",
          covariate.labels=c("$\\Delta \\log \\tau$",
                             "$\\Delta \\log \\tau^*$",
                             "$\\Delta \\log D_t$",
                             "$\\Delta \\log D_t^*$",
                             "$\\log \\left(\\frac{\\mu_{t-1}}{\\mu_{t-1}^*} \\right)$",
                             "$\\tau_{t-1}$",
                             "$\\tau_{t-1}^*$",
                             "$L_{t-1}$",
                             "$L_{t-1}^*$"),
          dep.var.labels="$\\Delta \\log \\left(\\frac{\\mu}{\\mu^*} \\right)$",
          notes = c("Fixed effects for country pair"),
          omit.stat=c("adj.rsq","f","ser"),
          float=F, out="C:/Users/tew207/Documents/GitHub/Thesis/gw_mark_lr.tex")


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
          float=F, OUt="C:/Users/tew207/Documents/GitHub/Thesis/gw_prod_lr.tex")


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
