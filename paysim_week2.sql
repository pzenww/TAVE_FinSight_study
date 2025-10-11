-- RFM 분석 !!!!!!

-- table 살펴보기
select * from paysim; -- columns 확인


-- 현재 step (가장 큰 step값)
select max(step) from paysim;



-- 고객별 R/F값 분포 확인을 위한 DB 설계
select 
	nameOrig as sender_id,
    count(nameOrig) as trade_cnt,
    max(step) as recent_step,
    ((select max(step) from paysim) - max(step)) as recency
from paysim
group by nameOrig;

-- isFraud로 나누어 R값 분포 확인
select 
	nameOrig as sender_id, 
    count(nameOrig) as trade_cnt, 
    max(step) as recent_step, 
    ((select max(step) from paysim) - max(step)) as recency, 
    isFraud 
    from paysim 
    where isFraud = 0 -- 사기 아닌거 
    group by nameOrig;


select 
	nameOrig as sender_id, 
    count(nameOrig) as trade_cnt, 
    max(step) as recent_step, 
    ((select max(step) from paysim) - max(step)) as recency, 
    isFraud 
    from paysim 
    where isFraud = 1 -- 사기
    group by nameOrig;



-- 고객별 M값 분포 확인을 위한 DB 설계
select 
	nameOrig as sender_id,
    round(sum(amount),2) as sum_amount,
    round(avg(amount),2) as avg_amount
from paysim
group by nameOrig; 

# amount 분포를 알기 위해 피벗팅

WITH sent_amount AS (
    SELECT 
        nameOrig AS sender_id,
        ROUND(SUM(amount),2) AS sum_amount,
        ROUND(AVG(amount),2) AS avg_amount
    FROM paysim
    GROUP BY nameOrig
)
SELECT 
    CASE 
        WHEN sum_amount < 10000 THEN '~10000'
        WHEN sum_amount < 50000 THEN '~50000'
        WHEN sum_amount < 100000 THEN '~100000'
        WHEN sum_amount < 150000 THEN '~150000'
        WHEN sum_amount < 200000 THEN '~200000'
        WHEN sum_amount < 250000 THEN '~250000'
        WHEN sum_amount < 300000 THEN '~300000'
        WHEN sum_amount < 350000 THEN '~350000'
        WHEN sum_amount < 400000 THEN '~400000'
        WHEN sum_amount < 450000 THEN '~450000'
        WHEN sum_amount < 500000 THEN '~500000'
        WHEN sum_amount < 550000 THEN '~550000'
        WHEN sum_amount < 600000 THEN '~600000'
        WHEN sum_amount < 650000 THEN '~650000'
        WHEN sum_amount < 700000 THEN '~700000'
        WHEN sum_amount < 750000 THEN '~750000'
        WHEN sum_amount < 800000 THEN '~800000'
        WHEN sum_amount < 850000 THEN '~850000'
        WHEN sum_amount < 900000 THEN '~900000'
        WHEN sum_amount < 950000 THEN '~950000'
        WHEN sum_amount < 1000000 THEN '~1000000'
        WHEN sum_amount < 1010000 THEN '~1010000'
        WHEN sum_amount < 1050000 THEN '~1050000'
        WHEN sum_amount < 1100000 THEN '~1100000'
        WHEN sum_amount < 1150000 THEN '~1150000'
        WHEN sum_amount < 1200000 THEN '~1200000'
        WHEN sum_amount < 1250000 THEN '~1250000'
        WHEN sum_amount < 1300000 THEN '~1300000'
        WHEN sum_amount < 1350000 THEN '~1350000'
        WHEN sum_amount < 1400000 THEN '~1400000'
        WHEN sum_amount < 1450000 THEN '~1450000'
        WHEN sum_amount < 1500000 THEN '~1500000'
        WHEN sum_amount < 1550000 THEN '~1550000'
        WHEN sum_amount < 1600000 THEN '~1600000'
        WHEN sum_amount < 1650000 THEN '~1650000'
        WHEN sum_amount < 1700000 THEN '~1700000'
        WHEN sum_amount < 1750000 THEN '~1750000'
        WHEN sum_amount < 1800000 THEN '~1800000'
        WHEN sum_amount < 1850000 THEN '~1850000'
        WHEN sum_amount < 1900000 THEN '~1900000'
        WHEN sum_amount < 1950000 THEN '~1950000'
        WHEN sum_amount < 2000000 THEN '~2000000'
        WHEN sum_amount < 3000000 THEN '~3000000'
        ELSE '3M+' 
    END AS amount_range,
    COUNT(*) AS account_count
FROM sent_amount
GROUP BY amount_range
ORDER BY MIN(sum_amount);

WITH sent_amount AS (
    SELECT 
        nameOrig AS sender_id,
        ROUND(SUM(amount),2) AS sum_amount,
        ROUND(AVG(amount),2) AS avg_amount
    FROM paysim
    GROUP BY nameOrig
)
SELECT 
    CASE 
        WHEN avg_amount < 10000 THEN '~10000'
        WHEN avg_amount < 50000 THEN '~50000'
        WHEN avg_amount < 100000 THEN '~100000'
        WHEN avg_amount < 150000 THEN '~150000'
        WHEN avg_amount < 200000 THEN '~200000'
        WHEN avg_amount < 250000 THEN '~250000'
        WHEN avg_amount < 300000 THEN '~300000'
        WHEN avg_amount < 350000 THEN '~350000'
        WHEN avg_amount < 400000 THEN '~400000'
        WHEN avg_amount < 450000 THEN '~450000'
        WHEN avg_amount < 500000 THEN '~500000'
        WHEN avg_amount < 550000 THEN '~550000'
        WHEN avg_amount < 600000 THEN '~600000'
        WHEN avg_amount < 650000 THEN '~650000'
        WHEN avg_amount < 700000 THEN '~700000'
        WHEN avg_amount < 750000 THEN '~750000'
        WHEN avg_amount < 800000 THEN '~800000'
        WHEN avg_amount < 850000 THEN '~850000'
        WHEN avg_amount < 900000 THEN '~900000'
        WHEN avg_amount < 950000 THEN '~950000'
        WHEN avg_amount < 1000000 THEN '~1000000'
        WHEN avg_amount < 1010000 THEN '~1010000'
        WHEN avg_amount < 1050000 THEN '~1050000'
        WHEN avg_amount < 1100000 THEN '~1100000'
        WHEN avg_amount < 1150000 THEN '~1150000'
        WHEN avg_amount < 1200000 THEN '~1200000'
        WHEN avg_amount < 1250000 THEN '~1250000'
        WHEN avg_amount < 1300000 THEN '~1300000'
        WHEN avg_amount < 1350000 THEN '~1350000'
        WHEN avg_amount < 1400000 THEN '~1400000'
        WHEN avg_amount < 1450000 THEN '~1450000'
        WHEN avg_amount < 1500000 THEN '~1500000'
        WHEN avg_amount < 1550000 THEN '~1550000'
        WHEN avg_amount < 1600000 THEN '~1600000'
        WHEN avg_amount < 1650000 THEN '~1650000'
        WHEN avg_amount < 1700000 THEN '~1700000'
        WHEN avg_amount < 1750000 THEN '~1750000'
        WHEN avg_amount < 1800000 THEN '~1800000'
        WHEN avg_amount < 1850000 THEN '~1850000'
        WHEN avg_amount < 1900000 THEN '~1900000'
        WHEN avg_amount < 1950000 THEN '~1950000'
        WHEN avg_amount < 2000000 THEN '~2000000'
        WHEN avg_amount < 3000000 THEN '~3000000'
        ELSE '3M+' 
    END AS amount_range,
    COUNT(*) AS account_count
FROM sent_amount
GROUP BY amount_range
ORDER BY MIN(avg_amount);

-- fraud인 경우
select 
	nameOrig as sender_id,
    round(sum(amount),2) as sum_amount,
    round(avg(amount),2) as avg_amount
from paysim
where isfraud = 1
group by nameOrig;

# amount 분포를 알기 위해 피벗팅

WITH sent_amount_fraud AS (
    SELECT 
        nameOrig AS sender_id,
        ROUND(SUM(amount),2) AS sum_amount,
        ROUND(AVG(amount),2) AS avg_amount
    FROM paysim
    WHERE isfraud = 1
    GROUP BY nameOrig
)
SELECT 
    CASE 
        WHEN sum_amount < 10000 THEN '~10000'
        WHEN sum_amount < 50000 THEN '~50000'
        WHEN sum_amount < 100000 THEN '~100000'
        WHEN sum_amount < 150000 THEN '~150000'
        WHEN sum_amount < 200000 THEN '~200000'
        WHEN sum_amount < 250000 THEN '~250000'
        WHEN sum_amount < 300000 THEN '~300000'
        WHEN sum_amount < 350000 THEN '~350000'
        WHEN sum_amount < 400000 THEN '~400000'
        WHEN sum_amount < 450000 THEN '~450000'
        WHEN sum_amount < 500000 THEN '~500000'
        WHEN sum_amount < 550000 THEN '~550000'
        WHEN sum_amount < 600000 THEN '~600000'
        WHEN sum_amount < 650000 THEN '~650000'
        WHEN sum_amount < 700000 THEN '~700000'
        WHEN sum_amount < 750000 THEN '~750000'
        WHEN sum_amount < 800000 THEN '~800000'
        WHEN sum_amount < 850000 THEN '~850000'
        WHEN sum_amount < 900000 THEN '~900000'
        WHEN sum_amount < 950000 THEN '~950000'
        WHEN sum_amount < 1000000 THEN '~1000000'
        WHEN sum_amount < 1010000 THEN '~1010000'
        WHEN sum_amount < 1050000 THEN '~1050000'
        WHEN sum_amount < 1100000 THEN '~1100000'
        WHEN sum_amount < 1150000 THEN '~1150000'
        WHEN sum_amount < 1200000 THEN '~1200000'
        WHEN sum_amount < 1250000 THEN '~1250000'
        WHEN sum_amount < 1300000 THEN '~1300000'
        WHEN sum_amount < 1350000 THEN '~1350000'
        WHEN sum_amount < 1400000 THEN '~1400000'
        WHEN sum_amount < 1450000 THEN '~1450000'
        WHEN sum_amount < 1500000 THEN '~1500000'
        WHEN sum_amount < 1550000 THEN '~1550000'
        WHEN sum_amount < 1600000 THEN '~1600000'
        WHEN sum_amount < 1650000 THEN '~1650000'
        WHEN sum_amount < 1700000 THEN '~1700000'
        WHEN sum_amount < 1750000 THEN '~1750000'
        WHEN sum_amount < 1800000 THEN '~1800000'
        WHEN sum_amount < 1850000 THEN '~1850000'
        WHEN sum_amount < 1900000 THEN '~1900000'
        WHEN sum_amount < 1950000 THEN '~1950000'
        WHEN sum_amount < 2000000 THEN '~2000000'
        WHEN sum_amount < 3000000 THEN '~3000000'
        ELSE '3M+' 
    END AS amount_range,
    COUNT(*) AS account_count
FROM sent_amount_fraud
GROUP BY amount_range
ORDER BY MIN(sum_amount);

WITH sent_amount_fraud AS (
    SELECT 
        nameOrig AS sender_id,
        ROUND(SUM(amount),2) AS sum_amount,
        ROUND(AVG(amount),2) AS avg_amount
    FROM paysim
    WHERE isfraud = 1
    GROUP BY nameOrig
)
SELECT 
    CASE 
        WHEN avg_amount < 10000 THEN '~10000'
        WHEN avg_amount < 50000 THEN '~50000'
        WHEN avg_amount < 100000 THEN '~100000'
        WHEN avg_amount < 150000 THEN '~150000'
        WHEN avg_amount < 200000 THEN '~200000'
        WHEN avg_amount < 250000 THEN '~250000'
        WHEN avg_amount < 300000 THEN '~300000'
        WHEN avg_amount < 350000 THEN '~350000'
        WHEN avg_amount < 400000 THEN '~400000'
        WHEN avg_amount < 450000 THEN '~450000'
        WHEN avg_amount < 500000 THEN '~500000'
        WHEN avg_amount < 550000 THEN '~550000'
        WHEN avg_amount < 600000 THEN '~600000'
        WHEN avg_amount < 650000 THEN '~650000'
        WHEN avg_amount < 700000 THEN '~700000'
        WHEN avg_amount < 750000 THEN '~750000'
        WHEN avg_amount < 800000 THEN '~800000'
        WHEN avg_amount < 850000 THEN '~850000'
        WHEN avg_amount < 900000 THEN '~900000'
        WHEN avg_amount < 950000 THEN '~950000'
        WHEN avg_amount < 1000000 THEN '~1000000'
        WHEN avg_amount < 1010000 THEN '~1010000'
        WHEN avg_amount < 1050000 THEN '~1050000'
        WHEN avg_amount < 1100000 THEN '~1100000'
        WHEN avg_amount < 1150000 THEN '~1150000'
        WHEN avg_amount < 1200000 THEN '~1200000'
        WHEN avg_amount < 1250000 THEN '~1250000'
        WHEN avg_amount < 1300000 THEN '~1300000'
        WHEN avg_amount < 1350000 THEN '~1350000'
        WHEN avg_amount < 1400000 THEN '~1400000'
        WHEN avg_amount < 1450000 THEN '~1450000'
        WHEN avg_amount < 1500000 THEN '~1500000'
        WHEN avg_amount < 1550000 THEN '~1550000'
        WHEN avg_amount < 1600000 THEN '~1600000'
        WHEN avg_amount < 1650000 THEN '~1650000'
        WHEN avg_amount < 1700000 THEN '~1700000'
        WHEN avg_amount < 1750000 THEN '~1750000'
        WHEN avg_amount < 1800000 THEN '~1800000'
        WHEN avg_amount < 1850000 THEN '~1850000'
        WHEN avg_amount < 1900000 THEN '~1900000'
        WHEN avg_amount < 1950000 THEN '~1950000'
        WHEN avg_amount < 2000000 THEN '~2000000'
        WHEN avg_amount < 3000000 THEN '~3000000'
        ELSE '3M+' 
    END AS amount_range,
    COUNT(*) AS account_count
FROM sent_amount_fraud
GROUP BY amount_range
ORDER BY MIN(avg_amount);
