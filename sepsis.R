
install.packages("nortest")
install.packages("CBCgrps")
library(nortest)
library(CBCgrps)
library(readxl)
sepsis <- read_excel("C:/Users/lenovo/Desktop/sepsis.xlsx")
View(sepsis)
vec1 <- as.data.frame(sepsis)
tab1 <- twogrps(vec1, gvar = "drug_iv")




tab1 <- twogrps(vec1, gvar = "drug_iv", workspace = 50000)  # Increase workspace size to 20000
Error in fisher.test(table.sub, workspace = workspace, simulate.p.value = sim) : 
  FEXACT error 7(location). LDSTP=1620 is too small for this problem,
  (pastp=5.54518, ipn_0:=ipoin[itp=19]=714, stp[ipn_0]=5.8861).
Increase workspace or consider using 'simulate.p.value=TRUE'


write.csv(tab1, file = "C:/Users/lenovo/Desktop/tab1.csv")

install.packages("tableone")
# 加载所需的包
library(tableone)

# 读取数据集
data <- read.xls("sepsis.xls")
#所有的数据存在表格finaldata里面
#字段加上标签
label(finaldata$icd_chf)<-"CHF"
label(finaldata$icd_afib)<-"AFIB"
label(finaldata$icd_renal)<-"Renal"
label(finaldata$icd_liver)<-"Liver"
label(finaldata$icd_copd)<-"COPD"
label(finaldata$icd_cad)<-"CAD"
label(finaldata$icd_stroke)<-"Stroke"
label(finaldata$icd_malignancy)<-"Malignancy"
label(finaldata$saps)<-"SAPS score"
label(finaldata$sofa)<-"SOFA score"
label(finaldata$elix_score)<-"Elixhauser score"
label(finaldata$vent)<-"Mechanical ventilation use (1st 24h)"
label(finaldata$vaso)<-"Vasoperessor use (1st 24h)"
label(finaldata$sedative)<-"Sedative use (1st 24h)"
label(finaldata$vs_map_first)<-"MAP"
label(finaldata$vs_heart_rate_first)<-"Heart rate"
label(finaldata$vs_temp_first)<-"Temperature"
label(finaldata$vs_cvp_first)<-"CVP"
label(finaldata$lab_wbc_first)<-"WBC"
label(finaldata$lab_hemoglobin_first)<-"Hemoglobin"
label(finaldata$lab_platelet_first)<-"Platelet"
label(finaldata$lab_sodium_first)<-"Sodium"
label(finaldata$lab_potassium_first)<-"Potassium"
label(finaldata$lab_bicarbonate_first)<-"Bicarbonate"
label(finaldata$lab_chloride_first)<-"Chloride"
label(finaldata$lab_bun_first)<-"BUN"
label(finaldata$lab_lactate_first)<-"Lactate"
label(finaldata$lab_creatinine_first)<-"Creatinine"
label(finaldata$lab_ph_first)<-"PH"
label(finaldata$lab_po2_first)<-"PO2"
label(finaldata$lab_pco2_first)<-"PCO2"
label(finaldata$lab_bnp_flag)<-"BNP(tested)"
label(finaldata$lab_troponin_flag)<-"Troponin(tested)"
label(finaldata$lab_creatinine_kinase_flag)<-"Creatinine kinase(tested)"
label(finaldata$icu_adm_weekday)<-"Day of lCU admission"
#定义作图需要的变量
vars<-c("age","gender","weight","saps","sofa","elix_score","vent","vaso","sedative","icd_chf","icd_afib",
    "icd_renal","icd_liver","icd_copd","icd_cad","icd_stroke","icd_malignancy"
        ,"vs_map_first","vs_heart_rate_first","vs_temp_first","vs_cvp_first",
        "lab_wbc_first","lab_hemoglobin_first","lab_platelet_first","lab_sodium_first","lab_potassium_first",
    "lab_bicarbonate_first","lab_bun_first","lab_lactate_first","lab_creatinine_first","lab_ph_first","lab_po2_first",
        "lab_pco2_first","lab_bnp_flag","lab_troponin_flag","lab_creatinine_kinase_flag","icu_adm_weekday")、
#分类变量
catVar<-c("vent","vaso","sedative","icd_chf","icd_afib","icd_renal","icd_liver","icd_copd",
      "icd_cad","icd_stroke","icd_malignancy",
          "lab_bnp_flag","lab_troponin_flag","lab_creatinine_kinase_flag","icu_adm_weekday")
#连续变量
nonormalVar<-c('age','gender','weight','saps','sofa','elix_score','vs_map_first','vs_heart_rate_first',
        'vs_temp_first','vs_cvp_first','lab_wbc_first','lab_hemoglobin_first','lab_platelet_first',
        'lab_sodium_first','lab_potassium_first','lab_bicarbonate_first','lab_bun_first','lab_lactate_first',
        'lab_creatinine_first','lab_ph_first','lab_po2_first','lab_pco2_first')
#制作Table1
tab1<-CreateTableOne(vars=vars,strata = "echo",data=data,factorVars = catVar)
print(tab1,smd = TRUE,varLabels = TRUE,showAllLevels = TRUE,test = FALSE)


# 加载所需的包
install.packages("labelled")
library(tableone)
library(labelled)

# 读取数据集
data <- read.xls("sepsis.xls")

# 添加变量标签
var_label(data$drug_iv) <- "Drug IV"
var_label(data$cns) <- "CNS"
var_label(data$renal) <- "Renal"
var_label(data$gender) <- "Gender"
var_label(data$los_hospital) <- "Length of Stay (Hospital)"
var_label(data$admission_age) <- "Admission Age"
var_label(data$race) <- "Race"
var_label(data$los_icu) <- "Length of Stay (ICU)"
var_label(data$death) <- "Death"
var_label(data$died_within_28_days) <- "Died Within 28 Days"
var_label(data$survival_days) <- "Survival Days"
var_label(data$long_title) <- "Long Title"
var_label(data$sofa_score) <- "SOFA Score"
var_label(data$respiration) <- "Respiration"
var_label(data$coagulation) <- "Coagulation"
var_label(data$liver) <- "Liver"
var_label(data$cardiovascular) <- "Cardiovascular"

# 定义作图需要的变量
vars <- c("drug_iv", "cns", "renal", "gender", "los_hospital", "admission_age", "race", "los_icu",
          "death", "died_within_28_days", "survival_days", "sofa_score", "respiration", "coagulation",
          "liver", "cardiovascular")

# 分类变量
catVar <- c("drug_iv", "cns", "renal", "gender", "race", "death", "died_within_28_days", "respiration",
            "coagulation", "liver", "cardiovascular")


# 创建Table 1
table1 <- CreateTableOne(vars = vars,
                         data = data,
                         factorVars = catVar,
                         test = FALSE,
                         includeNA = TRUE
)

# 打印Table 1结果，并设置smd、varLabels、showAllLevels和test参数
print(tab1, smd = TRUE, varLabels = TRUE, showAllLevels = TRUE, test = FALSE)


# 提取Table 1结果并保存为CSV文件
table1_output <- print(tab1,smd = TRUE, nonnormal = c(), showAllLevels = TRUE) , printToggle = FALSE
write.table(table1_output, file = "C:/Users/yanghui/Desktop/table1.csv", sep = ",", col.names = TRUE, quote = FALSE)



-------
# 定义需要比较的变量列表
vars1 <- c("cns", "renal", "gender", "los_hospital", "admission_age", "race", "los_icu",
           "death", "died_within_28_days", "survival_days", "sofa_score", "respiration", "coagulation",
           "liver", "cardiovascular")
# 进行两组间比较
tabletwo <- CreateTableOne(vars = vars1, strata = c("drug_iv"), data = sepsis)

# 打印 Table 2 结果
table2_output <- print(tabletwo, nonnormal = c(), showAllLevels = TRUE)
# 将结果保存为 CSV 文件
write.table(table2_output, file = "C:/Users/yanghui/Desktop/table2.csv", sep = ",", col.names = TRUE, quote = FALSE)



--------
install.packages("survival") 
install.packages("tableone") 
library(tableone) 
library(survival) 
library(broom) 
pancer<-read.csv("pancer.csv")

fvars<-c(“sex”,”trt”,”bui”,”ch”,”p”,”stage”) 
pancer[fvars] <- lapply(pancer[fvars], factor)

vars<- c("age","sex","trt","bui","ch","p","stage","censor","time")
tableOne<- CreateTableOne(vars = vars, data = pancer)
table1<-print(tableOne,nonnormal = c("time"),showAllLevels = TRUE)
write.csv(table1,file="table1.csv") #形成统计分析的excel表


4）接着进行分组比较
---通过以下R语言即可完成执行，同样是CreateTableOne（）函数看，在参数设置中增加了”strata = ”，就可以分组进行分析了
vars1<- c("age","sex","bui","ch","p","stage")
tabletwo<- CreateTableOne(vars = vars1, strata = c("trt"), data = pancer)
table2<-print(tabletwo,nonnormal = c( ),showAllLevels = TRUE)
write.csv(table2,file="table2.csv") #形成统计分析的excel表

