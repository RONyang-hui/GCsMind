
-- count表的制作
CREATE TABLE mimiciv_derived.d_icd_diagnoses_count AS
SELECT icd_code, icd_version, long_title, COUNT(icd_code) AS code_count
FROM mimiciv_hosp.d_icd_diagnoses
GROUP BY icd_code, icd_version, long_title;


-- 获取icd_code编码可以从这两张表中获取diagnoses_icd,d_icd_diagnoses
-- 但是无法判断具体是哪一个icd_code，所以可以从整理的汇总表中获取


-- 从汇总表中获取所有疾病的诊断总数
SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC
LIMIT 10;

1. 确诊为sepsis的患者 (n = 32971) √
/*
    This query selects patients from the mimiciv_derived.sepsis3 table
    where sepsis3 = t. It groups the patients by stay_id and sofa score.
*/
2. 至少接受血管加压治疗的患者 (n = 4397)




3. 年龄大于18且小于100的患者 (n = 4112)



--确诊为sepsis的患者
--查询18-60岁之间的患者
--查询患者的首次入ICU记录
CREATE VIEW sepsis_patients AS
SELECT *
FROM mimiciv_derived.sepsis3 AS s
JOIN mimiciv_derived.icustay_detail AS icu USING (subject_id, stay_id)
WHERE icu.admission_age >= 18 AND icu.admission_age <= 80
    AND icu.first_icu_stay = TRUE;


SELECT sp.*, dia.icd_code
FROM sepsis_patients AS sp
JOIN mimiciv_hosp.diagnoses_icd AS dia USING (hadm_id)
WHERE dia.icd_code IN ('7100', '7140', '7200');

在此基础上和 mimiciv_hosp.diagnoses_icd 表与sepsis_patients对比（using stay_id）,查询icd_code in ('7100','7140','7200')

-- 4.1.从汇总表icd_cod查询icd_code '5715','5712'
SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 过滤出long_title包含'myocardial infarction'的记录
WHERE d_icd_diagnoses.icd_code ILIKE '%7100%'
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC;
		
-- 4.2.从汇总表long_title查询'%Cirrhosis of liver%'
SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 过滤出long_title包含'myocardial infarction'的记录
WHERE d_icd_diagnoses.long_title ILIKE '%Ankylosing spondylitis%'
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC;

-- 5.汇总所有的查询结果
-- 从汇总表查询免疫类的icd_code '7100', '7140', '7200'
SELECT DISTINCT (ICUD.hadm_id) AS HADM_ID
FROM mimiciv_derived.age as age,
     mimiciv_derived.icustay_detail as ICUD,
     mimiciv_hosp.diagnoses_icd as dia
     where dia.hadm_id = age.hadm_id and age.hadm_id = icud.hadm_id
     -- 查询患有心肌梗死的患者
     and dia.icd_code in ('7100', '7140', '7200')
     -- 查询患有肝脏疾病的的患者
     and dia.icd_code not in ('5717','5712')
    -- 筛查年龄患者
     and age.age >= 18 AND age.age <= 60
    -- 只获取患者的首次入院记录
    and icud.first_icu_stay = True





'7100', Systemic lupus erythematosus
'M329', Systemic lupus erythematosus, unspecified
'7200', Ankylosing spondylitis
'M459', Ankylosing spondylitis of unspecified sites in spine
'340', Multiple sclerosis
'G35', Multiple sclerosis（多发性硬化症）
'7140', Rheumatoid arthritis（类风湿性关节炎）
'M069', Rheumatoid arthritis, unspecified（未明确的类风湿性关节炎）
'M0600', Rheumatoid arthritis without rheumatoid factor, unspecified site（未明确部位的无类风湿因子的类风湿性关节炎）
'71430', Polyarticular juvenile rheumatoid arthritis, chronic or unspecified（多关节型青少年类风湿性关节炎，慢性或未明确）
'5569', Ulcerative colitis, unspecified（未明确的溃疡性结肠炎）
'5568', Other ulcerative colitis（其他溃疡性结肠炎）
'K5190', Ulcerative colitis, unspecified, without complications（未明确的溃疡性结肠炎，无并发症）
'G7000','35800' Myasthenia gravis without (acute) exacerbation（无（急性）恶化的重症肌无力）
'57142', Autoimmune hepatitis（自身免疫性肝炎）
'E063', Autoimmune thyroiditis（自身免疫性甲状腺炎）
'7102', 'M3500' Sicca syndromee（干燥综合征）
'6960', Psoriatic arthropathy（银屑病关节炎）
'4460', Polyarteritis nodosa（结节性多动脉炎）
'57142','K754', Autoimmune hepatitis（自身免疫性肝炎）
'E063', Autoimmune thyroiditis




---选择有免疫疾病的患者保存为immunpatients
CREATE MATERIALIZED VIEW immunpatients AS
WITH filtered_patients AS (
    SELECT DISTINCT ICUD.hadm_id AS sp_hadm_id, d_icd_diagnoses.long_title
    FROM mimiciv_derived.age AS age,
         mimiciv_derived.icustay_detail AS ICUD,
         mimiciv_hosp.diagnoses_icd AS dia,
         mimiciv_hosp.d_icd_diagnoses AS d_icd_diagnoses
    WHERE dia.hadm_id = age.hadm_id 
      AND age.hadm_id = icud.hadm_id
      AND dia.icd_code IN ('7100', 'M329', '7140', '7200', 'M459', '340', 'G35', '5569', '5568', 'K5190', 'G7000', '35800', '57142', 'E063', '7102', 'M3500', '6960', '4460', 'K754')
      AND dia.icd_code NOT IN ('5717', '5712')
      AND age.age >= 18 AND age.age <= 60
      AND icud.first_icu_stay = TRUE
      AND dia.icd_code = d_icd_diagnoses.icd_code
)
SELECT fp.sp_hadm_id, fp.long_title, sp.*
FROM filtered_patients fp
RIGHT JOIN mimiciv_derived.sepsis_patients sp ON fp.sp_hadm_id = sp.hadm_id;


---选择有免疫疾病的患者immunpatients，且注射了皮质醇激素的
---计算生存时间
WITH drug_data AS (
    SELECT p.subject_id, p.hadm_id,
           MAX(CASE WHEN p.drug LIKE '%Dexamethasone%' OR p.drug LIKE '%Hydrocortisone%' OR p.drug LIKE '%Methylprednisolone%' THEN 1 ELSE 0 END) AS drug_IV
    FROM mimiciv_hosp.prescriptions AS p
    WHERE p.route = 'IV'
    GROUP BY p.subject_id, p.hadm_id
),
patient_data AS (
    SELECT d.subject_id, d.hadm_id, d.drug_IV, im.*,
           CASE WHEN im.dod IS NOT NULL THEN 1 ELSE 0 END AS death,
           CASE
               WHEN im.dod IS NOT NULL AND (im.dod - im.icu_outtime) <= INTERVAL '28 days' THEN 1
               ELSE 0
           END AS died_within_28_days,
           CASE WHEN im.dod IS NOT NULL THEN EXTRACT(DAY FROM (im.dod - im.icu_outtime)) ELSE NULL END AS survival_days
    FROM drug_data AS d
    JOIN mimiciv_derived.immunpatients AS im ON d.hadm_id = im.hadm_id
    WHERE im.first_icu_stay = True
)
SELECT *
FROM patient_data;
---在脓毒症患者中
--确诊为sepsis的患者
--查询18-60岁之间的患者
--查询患者的首次入ICU记录
--注射了皮质醇激素的
--(im.dod - im.icu_outtime) <= INTERVAL '28 days' 

