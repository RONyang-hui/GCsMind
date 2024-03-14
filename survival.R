# 引用包
library(survival)
library(survminer)
library(readxl)

# 读取Excel文件数据
data <- read_excel("C:\\Users\\yanghui\\Desktop\\dod.xlsx")

# 将survival_days中的缺失值设为NA
data$survival_days[data$survival_days == ""] <- NA

# 将survival_days转换为数值型
data$survival_days <- as.numeric(data$survival_days)

# 创建生存对象
surv_obj <- Surv(time = data$survival_days, event = data$death)

# 绘制生存曲线
surv_fit <- survfit(surv_obj ~ Group, data = data)

# 自定义颜色
color_palette <- c("#E7B800", "#2E9FDF")

# 绘制并美化生存曲线
ggsurvplot(
  surv_fit, 
  data = data, 
  risk.table = TRUE, 
  pval = TRUE, 
  conf.int = TRUE,
  palette = color_palette,
  risk.table.height = 0.2,
  risk.table.col = "strata",
  ggtheme = theme_minimal(),
  title = "Survival Analysis",
  xlab = "Time in Days",
  ylab = "Survival Probability",
  legend.title = "Group",
  legend.labs = c("High Risk", "Low Risk"),
  surv.median.line = "hv"
)

# 保存图表为PDF文件
ggsave("survival_plot.pdf", width = 8, height = 6)



#简化版本
# 引用包
library(survival)
library(survminer)
library(readxl)

# 读取Excel文件数据
data <- read_excel("C:\\Users\\yanghui\\Desktop\\dod.xlsx")

# 将survival_days中的缺失值设为NA
data$survival_days[data$survival_days == ""] <- NA

# 将survival_days转换为数值型
data$survival_days <- as.numeric(data$survival_days)

# 创建生存对象
surv_obj <- Surv(time = data$survival_days, event = data$death)

# 绘制生存曲线
surv_fit <- survfit(surv_obj ~ Group, data = data)
ggsurvplot(surv_fit, data = data, risk.table = TRUE)
