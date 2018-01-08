SELECT COUNT(*)
FROM patients;
-- 计数


SELECT DISTINCT(gender)
FROM patients;
-- 消除每一列中的重复值，只显示该列值的分类


SELECT COUNT(*)
FROM patients
WHERE gender = 'F';
-- 条件性选择，使用where语句作为判别条件，其后还可以跟like，及like‘%xxx%’等


SELECT gender, COUNT(*)
FROM patients
GROUP BY gender;
-- 将数据结果进行分组，group by作为分组条件，每一组下面分别进行group by之前的code


SELECT p.subject_id, p.dob, a.hadm_id,
    a.admittime, p.expire_flag
FROM admissions a
INNER JOIN patients p
ON p.subject_id = a.subject_id;
-- 通过inner join将两个不同table的数据放到一起，以ON后面的判别式作为连接条件
-- from和join分别声明数据来源


SELECT p.subject_id, p.dob, a.hadm_id,
    a.admittime, p.expire_flag,
    MIN (a.admittime) OVER (PARTITION BY p.subject_id) AS first_admittime
FROM admissions a
INNER JOIN patients p
ON p.subject_id = a.subject_id
ORDER BY a.hadm_id, p.subject_id;
-- min取变量的最小值
-- partition的意思是‘划分’，PARTITION BY的作用是将数据以某一条件划分分组
-- MIN (a.admittime) OVER (PARTITION BY p.subject_id) AS first_admittime的作用为：
-- 以病人id作为分组依据（PARTITION BY p.subject_id），找寻每个病人admittime的最小值（MIN (a.admittime) OVER），所得结果保存为first_admittime(as)
-- order by表示分组依据，默认为升序，降序在语句最后加desc，多个变量时，表示先以第一个变量排序，再以第二个变量排序


WITH first_admission_time AS
(
  SELECT
      p.subject_id, p.dob, p.gender
      , MIN (a.admittime) AS first_admittime
      , MIN( ROUND( (cast(admittime as date) - cast(dob as date)) / 365.242,2) )
          AS first_admit_age
  FROM patients p
  INNER JOIN admissions a
  ON p.subject_id = a.subject_id
  GROUP BY p.subject_id, p.dob, p.gender
  ORDER BY p.subject_id
)
SELECT
    subject_id, dob, gender
    , first_admittime, first_admit_age
    , CASE
        -- all ages > 89 in the database were replaced with 300
        WHEN first_admit_age > 89
            then '>89'
        WHEN first_admit_age >= 14
            THEN 'adult'
        WHEN first_admit_age <= 1
            THEN 'neonate'
        ELSE 'middle'
        END AS age_group
FROM first_admission_time
ORDER BY subject_id

-- with as可以看做一个临时表，with as括号中的语句创建了一个临时表
-- 我们可以利用with as语句对查询出的结果进行二次处理，比如汇总、分类、求平均数等
-- CAST函数用于将某种数据类型的表达式显式转换为另一种数据类型
-- ROUND 函数用于把数值字段舍入为指定的小数位数
-- group by 一般和聚合函数一起使用才有意义,比如 count sum avg等,使用group by的两个要素:
-- (1) 出现在select后面的字段 要么是是聚合函数中的,要么就是group by 中的.
-- (2) 要筛选结果 可以先使用where 再用group by 或者先用group by 再用having
-- group by后接多个条件时，从前至后依次分组
-- case when类似于if else语句。when类似于if
-- mimic将所有年龄大于90岁的患者年龄更改为了300岁

WITH first_admission_time AS
(
  SELECT
      p.subject_id, p.dob, p.gender
      , MIN (a.admittime) AS first_admittime
      , MIN( ROUND( (cast(admittime as date) - cast(dob as date)) / 365.242,2) )
          AS first_admit_age
  FROM patients p
  INNER JOIN admissions a
  ON p.subject_id = a.subject_id
  GROUP BY p.subject_id, p.dob, p.gender
  ORDER BY p.subject_id
)
, age as
(
  SELECT
      subject_id, dob, gender
      , first_admittime, first_admit_age
      , CASE
          -- all ages > 89 in the database were replaced with 300
          -- we check using > 100 as a conservative threshold to ensure we capture all these patients
          WHEN first_admit_age > 100
              then '>89'
          WHEN first_admit_age >= 14
              THEN 'adult'
          WHEN first_admit_age <= 1
              THEN 'neonate'
          ELSE 'middle'
          END AS age_group
  FROM first_admission_time
)
select age_group, gender
  , count(subject_id) as NumberOfPatients
from age
group by age_group, gender
-- 类似的语句



with icu_static as
(
select ie.subject_id,ie.hadm_id,ie.icustay_id,ie.intime,ie.outtime,
       ROUND((cast(ie.intime as date) - cast(pat.dob as date))/365.242, 2) AS age
from icustays ie
inner join patients pat
on ie.subject_id = pat.subject_id
)
, age_group as
(
    select subject_id,hadm_id,icustay_id,intime,outtime, age,   
    case
      when age<=1 then 'neonate'
      when age<=14 then 'middle'
      when age>89 then '>89'
      else 'adult'
      end as icustay_age_group
    from icu_static
)
select agg.subject_id, agg.hadm_id, agg.icustay_id,
    agg.intime, agg.outtime, adm.deathtime, adm.hospital_expire_flag
from age_group agg
inner join admissions adm
on agg.subject_id = adm.subject_id
where adm.hospital_expire_flag = 1;
-- 练习题

SELECT subject_id, MAX(los)
FROM icustays
GROUP BY subject_id
HAVING MAX(los) <= 10;
-- 当我们对变量进行运算的同时进行条件筛选，使用having函数

SELECT subject_id, icustay_id, intime,
    RANK() OVER (PARTITION BY subject_id ORDER BY intime)
FROM icustays;
-- 分组排序后对同一患者显示其顺序序号
-- 下述方法可实现同样的目的，只是不能显示器排列序号
-- SELECT subject_id, icustay_id, intime
-- FROM icustays
--     group by subject_id , icustay_id, intime
--     ORDER BY subject_id, intime
