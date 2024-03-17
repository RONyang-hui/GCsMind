
#载入包
# Load required libraries
library(Matching)
library(twang)

# Define the formula for matching variable selection
fml <- 'echo_int ~ first_careunit + age + gender + weight + saps + sofa + elix_score + vent + vaso + icu_adm_weekday + icu_adm_hour + icd_chf + icd_afib + icd_renal + icd_liver + icd_copd + icd_cad + icd_stroke + icd_malignancy + vs_temp_first + vs_map_first + vs_heart_rate_first + lab_chloride_first + lab_creatinine_first + lab_platelet_first + lab_potassium_first + lab_po2_first + lab_lactate_first + lab_hemoglobin_first + lab_sodium_first + lab_ph_first + lab_bicarbonate_first + lab_wbc_first + lab_bun_first + lab_pco2_first + sedative + vs_cvp_flag + lab_troponin_flag + lab_creatinine_kinase_flag + lab_bnp_flag'

# Calculate weights using gbm method
echo_ps_ate <- ps(as.formula(fml),
                  data = data,
                  interaction.depth = 2,
                  shrinkage = 0.01,
                  perm.test.iters = 0,
                  estimand = "ATE",
                  verbose = FALSE,
                  stop.method = c("es.mean", "es.max", "ks.mean", "ks.max"),
                  n.trees = 10000,
                  train.fraction = 0.8,
                  cv.folds = 3,
                  n.cores = 8,
                  version = "legacy")

# Get predicted propensity scores
pred <- echo_ps_ate$ps$es.mean.ATE

# Add propensity scores to the finaldata dataframe
finaldata <- finaldata %>% mutate(ps = pred)

# Calculate weights for propensity score matching
finaldata <- finaldata %>% mutate(ps_weight = get.weights(echo_ps_ate, stop.method = "es.mean"))
# saveRDS(finaldata, file = file.path(data_dir, "full_data_ps.rds"))


# Perform matching on a subset of data
set.seed(4958)
ps_matches <- Match(Y = finaldata$mort_28_day,
                    Tr = finaldata$echo_int,
                    X = finaldata$ps,
                    M = 1,
                    estimand = "ATT",
                    caliper = 0.01,
                    exact = FALSE,
                    replace = FALSE,
                    ties = FALSE)




ft_importance <- summary(echo_ps_ate$gbm.obj,
                         n.trees = echo_ps_ate$desc$es.mean.ATE$n.trees,
                         plot = FALSE)



                         
ft_importance %>% 
rename(cov = var, inf = rel.inf) %>%
mutate(cov = str_replace_all(cov, "_", " ")) %>%
mutate(cov_ = cov) %>%
mutate(cov = str_replace_all(cov, "lab|vs|flag|icd|first", "")) %>%
mutate(cov = str_replace_all(cov, "\\s+$|^\\s+", "")) %>%
mutate(cov = case_when(
    grepl("icd|lab", cov_) ~ toupper(cov),
    TRUE ~ tools::toTitleCase(cov)
)) %>%
mutate(cov = case_when(
    cov == "Careunit" ~ "Service Unit",
    cov == "Weight" ~ "Weight",
    cov == "Elix Score" ~ "Elixhauser Score",
    cov == "Saps" ~ "SAPS Score",
    cov == "Sofa" ~ "SOFA Score",
    cov == "Vent" ~ "Ventilation Use (1st 24 Hrs)",
    cov == "Vaso" ~ "Vasopressor Use (1st 24 Hrs)",
    cov == "Sedative" ~ "Sedative Use (1st 24 Hrs)",
    cov == "Icu Adm Weekday" ~ "Day of ICU Admission",
    cov == "Icu Adm Hour" ~ "Hour of ICU Admission",
    cov == "Temp" ~ "Temperature",
    cov == "Map" ~ "MAP",
    cov == "Cvp" ~ "CVP (measured)",
    cov %in% c("TROPONIN", "BNP", "CREATININE KINASE") ~ paste(cov, "(tested)"),
    TRUE ~ cov
)) %>%
select(-cov_)




ft_importance %>%
ggplot() +
geom_col(aes(x = cov, y = inf), width = .5,
         fill = rgb(66, 139, 202, maxColorValue = 255)) +
scale_x_discrete(limits = importance$cov) +
scale_y_continuous(breaks = seq(0, 18, 2)) +
labs(x = "", y = "") +
theme_bw() +
theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5),
      panel.grid.minor.x = element_blank(), panel.grid.major.x = element_blank())



      
#多因素回归是最简单的
#表读入到full_data
#Y为28天死亡率mort_28day
#X为主要观察变量echo及其他协变量
fml<-'mort_28_day ~ echo + first_careunit + age + gender + weight + saps + sofa + vent + icu_adm_weekday + icu_adm_hour + icd_chf + icd_afib + icd_renal + icd_liver + icd_copd + icd_cad + icd_stroke + icd_malignancy + vs_temp_first + vs_map_first + vs_heart_rate_first + lab_chloride_first + lab_creatinine_first + lab_platelet_first + lab_potassium_first + lab_po2_first + lab_lactate_first + lab_hemoglobin_first + lab_sodium_first + lab_ph_first + lab_bicarbonate_first + lab_wbc_first + lab_bun_first + lab_pco2_first + sedative + vs_cvp_flag + lab_troponin_flag + lab_creatinine_kinase_flag + lab_bnp_flag + elix_score + vaso'
#构建回归模型fit
fit<-glm(as.formula(fml), data = full_data, family = binomial, na.action = na.exclude)
#打印各变量的OR值及95%可信区间
exp(cbind(OR = coef(fit),confit(fit)))


#保存结果
saveRDS(finaldata, file = file.path(data_dir, "full_data_ps.rds"))
#读入结果
full_data_ps<-readRDS("full_data_ps.rds")
#logistic回归
#回归公式只纳入结局变量和观察变量
primary_ipw <- glm(mort_28_day ~ echo, data = full_data_ps,
                   #使用权重系数
                   weights = full_data_ps$ps_weight, 
                   family = binomial)
summary(primary_ipw)
#显示OR值
exp(cbind(OR = coef(primary_ipw), confint(primary_ipw)))