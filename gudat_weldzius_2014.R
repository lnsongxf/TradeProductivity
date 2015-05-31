#######################################################
#######################################################
#####     The Competitive Effects of Trade       ######
#####     Liberalization in North American       ######
#####       Nils Gudat and Ryan Weldzius         ######
#######################################################
#######################################################


path = "/Users/Nils/Dropbox/Trade Paper/Data2014/Excel_Files/"

# Working directory and packages
setwd(path)
require(foreign)
require(plm)
require(stargazer)


# Basic parameters of analysis:
starting_year <- 1981       
end_year <- 2012
industries <- c(15,17,20,21,23,26,27,28,36)
countries <- c("CAN","MEX","USA")

combs <- outer(countries, countries, paste, sep=" ")               # Creates all combinations of the strings found in countries (as a square matrix)
combs <- combs[upper.tri(combs)]                                   # Picks the unique combinations from the matrix (upper triangular entries)
no_combs <- length(combs)                                          # Count number of country pairs combinations
years <- seq(starting_year,end_year,1)                             # Construct the year vector
year <- rep(years,length(industries)*no_combs)                     # Constructs the 'year' variable
id <- rep(seq(1, no_combs*length(industries)), each=length(years)) # Constructs a unique ID for each country combination
f1 <- function(s) strsplit(s," ")[[1]][1]                          # function to use in sapply
market_h <- t(sapply(combs,f1))                                    # Pick the first element of each unique market combination as market_h 
market_h <- rep(market_h[1:length(market_h)],each=length(industries)*length(years))  # replicate market_h industry*year times
f2 <- function(s) strsplit(s," ")[[1]][2]                          # function to use in sapply
market_f <- t(sapply(combs,f2))                                    # Pick the second element of each unique market combination as market_f
market_f <- rep(market_f[1:length(market_f)],each=length(industries)*length(years))  # replicate market_f industry*year times
industry <- rep(rep(industries,each=length(years)),no_combs)       # repeat the industry vector years*combinations times

data <- data.frame(id,year,industry,market_h,market_f)             # bind id,year,market_h and market_f together to form the basic structure of the data 

rm(combs, countries, f1, f2, industry, market_h, market_f, years,year)


#####################
#### DATA IMPORT ####
#####################

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
tau_can <- read.csv(paste0(path, "Tariffs/tariffs_can.csv"))
tau_mex <- read.csv(paste0(path, "Tariffs/tariffs_mex.csv"))
tau_usa <- read.csv(paste0(path, "Tariffs/tariffs_usa.csv"))

# 5. Openness Data
# open_can <- read.csv(paste0(path, "Openness/open_can.csv"))
# open_mex <- read.csv(paste0(path, "Openness/open_mex.csv"))
# open_usa <- read.csv(paste0(path, "Openness/open_usa.csv"))
open_ind_can <- read.csv(paste0(path, "Openness/open_ind_can.csv"))
open_ind_mex <- read.csv(paste0(path, "Openness/open_ind_mex.csv"))
open_ind_usa <- read.csv(paste0(path, "Openness/open_ind_usa.csv"))

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

# 8. Import /Export Data
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
fxrate_usa_can <- read.csv(paste0(path, "XRat/fxrate_USA_CAN.csv"))
fxrate_usa_mex <- read.csv(paste0(path, "XRat/fxrate_USA_MEX.csv"))

tau_romalis <- read.csv("/Users/tew207/Desktop/tau_romalis.csv")
names(tau_romalis) <- c("year", 10:27)


#####################
# CONSTRUCT DATASET #
#####################
variables <- as.data.frame(matrix(data = NA, nrow = dim(data)[1], ncol=41))

names(variables) <- c("ppi_h", "ppi_f", "prod_h", "prod_f", "prod_h", "prod_f",
                      "tau_hf", "tau_ht", "tau_fh", "tau_ft", "tau_th", "tau_tf",
                      "tau_hf_w", "tau_ht_w", "tau_fh_w", "tau_ft_w", "tau_th_w", "tau_tf_w", 
                      "open_hf", "open_ht", "open_fh", "open_ft", "open_th", "opentf",
                      "open_ind_h", "open_ind_f", "open_ind_t", "firms_h", "firms_f",
                      "gdp_h", "gdp_f", "emp_h", "emp_f", "imp_h", "imp_f", "exp_h", "exp_f",
                      "wage_h", "wage_f", "cpi_h", "cpi_f")

data <- cbind(data, variables)
rm(variables, starting_year, end_year, no_combs, industries)


# For country-level data, we merge by year

data <- merge(data, gdp_can, by = c("year"), all=TRUE)
data <- merge(data, gdp_mex, by = c("year"), all=TRUE)
data <- merge(data, gdp_usa, by = c("year"), all=TRUE)
data["gdp_h"][data["market_h"]=="CAN"] <- data["gdp_can"][data["market_h"]=="CAN"]
data["gdp_f"][data["market_f"]=="CAN"] <- data["gdp_can"][data["market_f"]=="CAN"]
data["gdp_h"][data["market_h"]=="MEX"] <- data["gdp_mex"][data["market_h"]=="MEX"]
data["gdp_f"][data["market_f"]=="MEX"] <- data["gdp_mex"][data["market_f"]=="MEX"]
data["gdp_f"][data["market_f"]=="USA"] <- data["gdp_usa"][data["market_f"]=="USA"]

# data <- merge(data, cpi_can, by = c("year"), all=TRUE)
# data <- merge(data, cpi_mex, by = c("year"), all=TRUE)
# data <- merge(data, cpi_usa, by = c("year"), all=TRUE)
# data["cpi_h"][data["market_h"]=="CAN"] <- data["cpi_can"][data["market_h"]=="CAN"]
# data["cpi_f"][data["market_f"]=="CAN"] <- data["cpi_can"][data["market_f"]=="CAN"]
# data["cpi_h"][data["market_h"]=="MEX"] <- data["cpi_mex"][data["market_h"]=="MEX"]
# data["cpi_f"][data["market_f"]=="MEX"] <- data["cpi_mex"][data["market_f"]=="MEX"]
# data["cpi_f"][data["market_f"]=="USA"] <- data["cpi_usa"][data["market_f"]=="USA"]

data <- merge(data, open_ind_can, by = c("year"), all=TRUE)
data <- merge(data, open_ind_mex, by = c("year"), all=TRUE)
data <- merge(data, open_ind_usa, by = c("year"), all=TRUE)
data["open_ind_h"][data["market_h"]=="CAN"] <- data["open_ind_can"][data["market_h"]=="CAN"]
data["open_ind_f"][data["market_f"]=="CAN"] <- data["open_ind_can"][data["market_f"]=="CAN"]
data["open_ind_h"][data["market_h"]=="MEX"] <- data["open_ind_mex"][data["market_h"]=="MEX"]
data["open_ind_f"][data["market_f"]=="MEX"] <- data["open_ind_mex"][data["market_f"]=="MEX"]
data["open_ind_f"][data["market_f"]=="USA"] <- data["open_ind_usa"][data["market_f"]=="USA"]


# For industry-level data, we merge by year and industry

# data <- merge(data, ppi_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, ppi_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, ppi_usa, by = c("year", "industry"), all=TRUE)
# data["ppi_h"][data["market_h"]=="CAN"] <- data["ppi_can"][data["market_h"]=="CAN"]
# data["ppi_h"][data["market_h"]=="MEX"] <- data["ppi_mex"][data["market_h"]=="MEX"]
# data["ppi_f"][data["market_f"]=="MEX"] <- data["ppi_mex"][data["market_f"]=="MEX"]
# data["ppi_f"][data["market_f"]=="USA"] <- data["ppi_usa"][data["market_f"]=="USA"]

# data <- merge(data, markup_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, markup_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, markup_usa, by = c("year", "industry"), all=TRUE)
# data["markup_h"][data["market_h"]=="CAN"] <- data["markup_can"][data["market_h"]=="CAN"]
# data["markup_h"][data["market_h"]=="MEX"] <- data["markup_mex"][data["market_h"]=="MEX"]
# data["markup_f"][data["market_f"]=="MEX"] <- data["markup_mex"][data["market_f"]=="MEX"]
# data["markup_f"][data["market_f"]=="USA"] <- data["markup_usa"][data["market_f"]=="USA"]

# data <- merge(data, prod_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, prod_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, prod_usa, by = c("year", "industry"), all=TRUE)
# data["prod_h"][data["market_h"]=="CAN"] <- data["prod_can"][data["market_h"]=="CAN"]
# data["prod_h"][data["market_h"]=="MEX"] <- data["prod_mex"][data["market_h"]=="MEX"]
# data["prod_f"][data["market_f"]=="MEX"] <- data["prod_mex"][data["market_f"]=="MEX"]
# data["prod_f"][data["market_f"]=="USA"] <- data["prod_usa"][data["market_f"]=="USA"]

data <- merge(data, tau_can, by = c("year", "industry"), all=TRUE)
data <- merge(data, tau_mex, by = c("year", "industry"), all=TRUE)
data <- merge(data, tau_usa, by = c("year", "industry"), all=TRUE)
data["tau_hf"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_can_mex"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_hf"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_can_usa"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_hf"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_mex_usa"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_ht"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_can_usa"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_ht"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_can_mex"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_ht"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_mex_can"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_fh"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_mex_can"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_fh"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_usa_can"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_fh"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_usa_mex"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_ft"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_mex_usa"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_ft"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_usa_mex"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_ft"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_usa_can"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_th"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_usa_can"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_th"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_mex_can"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_th"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_can_mex"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_tf"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_s_usa_mex"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_tf"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_s_mex_usa"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_tf"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_s_can_usa"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_hf_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_can_mex"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_hf_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_can_usa"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_hf_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_mex_usa"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_ht_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_can_usa"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_ht_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_can_mex"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_ht_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_mex_can"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_fh_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_mex_can"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_fh_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_usa_can"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_fh_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_usa_mex"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_ft_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_mex_usa"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_ft_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_usa_mex"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_ft_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_usa_can"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_th_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_usa_can"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_th_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_mex_can"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_th_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_can_mex"][data["market_h"]=="MEX" & data["market_f"]=="USA"]
data["tau_tf_w"][data["market_h"]=="CAN" & data["market_f"]=="MEX"] <- data["tau_w_usa_mex"][data["market_h"]=="CAN" & data["market_f"]=="MEX"]
data["tau_tf_w"][data["market_h"]=="CAN" & data["market_f"]=="USA"] <- data["tau_w_mex_usa"][data["market_h"]=="CAN" & data["market_f"]=="USA"]
data["tau_tf_w"][data["market_h"]=="MEX" & data["market_f"]=="USA"] <- data["tau_w_can_usa"][data["market_h"]=="MEX" & data["market_f"]=="USA"]

# data <- merge(data, open_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, open_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, open_usa, by = c("year", "industry"), all=TRUE)
# data["open_h"][data["market_h"]=="CAN"] <- data["open_can"][data["market_h"]=="CAN"]
# data["open_h"][data["market_h"]=="MEX"] <- data["open_mex"][data["market_h"]=="MEX"]
# data["open_f"][data["market_f"]=="MEX"] <- data["open_mex"][data["market_f"]=="MEX"]
# data["open_f"][data["market_f"]=="USA"] <- data["open_usa"][data["market_f"]=="USA"]

# data <- merge(data, firms_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, firms_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, firms_usa, by = c("year", "industry"), all=TRUE)
# data["firms_h"][data["market_h"]=="CAN"] <- data["firms_can"][data["market_h"]=="CAN"]
# data["firms_h"][data["market_h"]=="MEX"] <- data["firms_mex"][data["market_h"]=="MEX"]
# data["firms_f"][data["market_f"]=="MEX"] <- data["firms_mex"][data["market_f"]=="MEX"]
# data["firms_f"][data["market_f"]=="USA"] <- data["firms_usa"][data["market_f"]=="USA"]

# data <- merge(data, wage_can, by = c("year", "industry"), all=TRUE)
# data <- merge(data, wage_mex, by = c("year", "industry"), all=TRUE)
# data <- merge(data, wage_usa, by = c("year", "industry"), all=TRUE)
# data["wage_h"][data["market_h"]=="CAN"] <- data["wage_can"][data["market_h"]=="CAN"]
# data["wage_h"][data["market_h"]=="MEX"] <- data["wage_mex"][data["market_h"]=="MEX"]
# data["wage_f"][data["market_f"]=="MEX"] <- data["wage_mex"][data["market_f"]=="MEX"]
# data["wage_f"][data["market_f"]=="USA"] <- data["wage_usa"][data["market_f"]=="USA"]

data <- merge(data, imp_can, by = c("year", "industry"), all=TRUE)
data <- merge(data, imp_mex, by = c("year", "industry"), all=TRUE)
data <- merge(data, imp_usa, by = c("year", "industry"), all=TRUE)
data["imp_h"][data["market_h"]=="CAN"] <- data["imp_can"][data["market_h"]=="CAN"]
data["imp_h"][data["market_h"]=="MEX"] <- data["imp_mex"][data["market_h"]=="MEX"]
data["imp_f"][data["market_f"]=="MEX"] <- data["imp_mex"][data["market_f"]=="MEX"]
data["imp_f"][data["market_f"]=="USA"] <- data["imp_usa"][data["market_f"]=="USA"]

data <- merge(data, exp_can, by = c("year", "industry"), all=TRUE)
data <- merge(data, exp_mex, by = c("year", "industry"), all=TRUE)
data <- merge(data, exp_usa, by = c("year", "industry"), all=TRUE)
data["exp_h"][data["market_h"]=="CAN"] <- data["exp_can"][data["market_h"]=="CAN"]
data["exp_h"][data["market_h"]=="MEX"] <- data["exp_mex"][data["market_h"]=="MEX"]
data["exp_f"][data["market_f"]=="MEX"] <- data["exp_mex"][data["market_f"]=="MEX"]
data["exp_f"][data["market_f"]=="USA"] <- data["exp_usa"][data["market_f"]=="USA"]

# Order the data according to the id set at the beginning
# (This ensures ordering by country pair and industry)
data <- data[order(data["id"]), ]

# Produce a table of summary statistics
sumstats <- stargazer(data, 
                      title="Summary Statistics",
                      omit=c("year", "id", "industry", "ppi_h", "ppi_f", "tau_hf", "tau_ht", "tau_fh", "tau_ft",
                             "tau_th", "tau_tf", "tau_hf_w", "tau_ht_w", "tau_fh_w", "tau_ft_w", "tau_th_w", "tau_tf_w",
                             "open_ind_h", "open_ind_f", "gdp_h", "gdp_f", "imp_h", "imp_f", "exp_h", "cpi_h", "cpi_f",
                             "imp_can", "imp_mex", "imp_usa", "exp_can", "exp_mex", "exp_usa", "tau_w_can_usa", "tau_w_can_mex",
                             "tau_w_mex_can", "tau_w_mex_usa", "tau_w_usa_can", "tau_w_usa_mex"),
                      float = F,
                      float.env = "sidewaystable",
                      out="sumstats.tex")

#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________
#_____________________________________________________________________________________________

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
          float=F,
          out="gw_price_sr.tex")


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
          float = F,
          out = "gw_mark_sr.tex")


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
          float=F,
          out="gw_prod_sr.tex")


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
          float=F,
          out="gw_price_lr.tex")


##########################################
#### TABLE 5: prodS (LONG RUN - GW) ####
##########################################

gw.mark.lr1 <- plm(diff(log(prod_h/prod_f)) ~ diff(lntau_sh) + diff(lntau_sf) + diff(log(firms_h)) + diff(log(firms_f))
                   + lag(log(prod_h/prod_f)) + lag(lntau_sh)+ lag(lntau_sf) + lag(log(gdp_h)) + lag(log(gdp_f)) + 0, data=datgw, index=c("id"), model="within")
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
          float=F,
          out="gw_mark_lr.tex")


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
           float=F,
           out="gw_prod_lr.tex")
