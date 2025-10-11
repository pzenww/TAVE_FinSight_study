-- AARRR 분석 !!!

-- Activation

WITH users AS (
  SELECT
    nameOrig AS user_id,
    MIN(step) AS first_seen_step,  -- 최초 등장 시점  
    MAX(isActivation) AS is_activated_flag  -- 플래그 존재 여부
  FROM paysim
  GROUP BY nameOrig
)
SELECT *,
	ROUND(100 * AVG(is_activated_flag), 2) AS activation_rate_flag_pct  -- KPI
FROM users
GROUP BY user_id;

WITH users AS (
  SELECT
    nameOrig AS user_id,
    MIN(step) AS first_seen_step,     -- 최초 등장 시점
    MAX(isActivation) AS is_activated_flag  -- 플래그 존재 여부 (0/1)
  FROM paysim
  GROUP BY nameOrig
)
SELECT 
    is_activated_flag,
    COUNT(*) AS account_count
FROM users
GROUP BY is_activated_flag;


-- Revenue

-- 수익 정의 및 DB 설계
WITH users_flag AS
(
SELECT
  nameOrig AS user_id,
  MAX(isActivation) AS is_activated_flag,
  MIN(CASE WHEN isActivation = 1 THEN step END) AS first_flag_step
FROM paysim
GROUP BY nameOrig
)
SELECT t.*
FROM paysim t
JOIN users_flag u ON u.user_id = t.nameOrig
WHERE u.is_activated_flag = 1
  AND t.step >= u.first_flag_step
  AND t.type IN ('CASH_OUT','TRANSFER','PAYMENT','DEBIT'); -- 수익 정의: Activation 이후 송신 거래만

-- KPI 계산
WITH
users_flag AS (
  SELECT
    nameOrig AS user_id,
    MAX(isActivation) AS is_activated_flag,
    MIN(CASE WHEN isActivation = 1 THEN step END) AS first_flag_step
  FROM paysim
  GROUP BY nameOrig
),
tx_post_flag AS (
  SELECT t.*
  FROM paysim t
  JOIN users_flag u ON u.user_id = t.nameOrig
  WHERE u.is_activated_flag = 1
    AND t.step >= u.first_flag_step
    AND t.type IN ('CASH_OUT','TRANSFER','PAYMENT','DEBIT')  -- 송신 정의
),
params AS (SELECT 0.003 AS take_rate)  -- 수수료율 가정(0.3%)
SELECT
  ROUND(SUM(CASE WHEN isFraud = 0 THEN amount END), 2)                                      AS net_tpv_post_flag,  -- KPI #1
  ROUND((SELECT take_rate FROM params) * SUM(CASE WHEN isFraud = 0 THEN amount END), 2)     AS revenue_proxy,      -- KPI #2
  ROUND(100.0 * (1 - SUM(CASE WHEN isFraud = 0 THEN amount END) / NULLIF(SUM(amount), 0)), 2) AS fraud_loss_pct    -- KPI #3
FROM tx_post_flag;


-- Referral

WITH users_flag AS
(
SELECT
  nameOrig AS user_id,
  MAX(isActivation) AS is_activated_flag,
  MIN(CASE WHEN isActivation = 1 THEN step END) AS first_flag_step
FROM paysim
GROUP BY nameOrig
)
SELECT t.*
FROM paysim t
JOIN users_flag u ON u.user_id = t.nameOrig
WHERE u.is_activated_flag = 1
  AND t.step >= u.first_flag_step
  AND t.type IN ('CASH_OUT','TRANSFER','PAYMENT','DEBIT')
  AND isFraud = 0;

 
 -- Funnel
 
WITH v_users_flag_ref AS
(
SELECT
  nameOrig AS user_id,
  MAX(isActivation) AS is_activated_flag,              -- S1 판정
  MIN(CASE WHEN isActivation=1 THEN step END) AS first_flag_step,
  MAX(isReferral) AS is_referral
FROM paysim
GROUP BY nameOrig
),
v_tx_post_flag AS
(
SELECT t.*
FROM paysim t
JOIN v_users_flag_ref u ON u.user_id = t.nameOrig
WHERE u.is_activated_flag = 1
  AND t.step >= u.first_flag_step
  AND t.type IN ('CASH_OUT','TRANSFER','PAYMENT','DEBIT')
  ),
s1 AS (  -- S1: Activated(Flag)
  SELECT COUNT(*) AS n1
  FROM v_users_flag_ref
  WHERE is_activated_flag = 1
),
s2 AS (  -- S2: Revenue(플래그 이후 정상 거래≥1)
  SELECT COUNT(DISTINCT nameOrig) AS n2
  FROM v_tx_post_flag
  WHERE isFraud = 0
),
s3 AS (  -- S3: Referral(+Revenue)
  SELECT COUNT(DISTINCT t.nameOrig) AS n3
  FROM v_tx_post_flag t
  JOIN v_users_flag_ref u ON u.user_id = t.nameOrig
  WHERE t.isFraud = 0 AND u.is_referral = 1
),
counts AS (
  SELECT s1.n1, s2.n2, s3.n3 FROM s1 JOIN s2 JOIN s3
)
-- 시각화용 롱포맷 (막대 3개 + 전환/이탈 라벨)
SELECT
  stage_order,
  stage_key,
  stage_label,
  users,
  ROUND(100.0 * users / NULLIF(prev_users,0), 2) AS conv_from_prev_pct,
  ROUND(100.0 * users / NULLIF(n1,0), 2)         AS conv_from_start_pct,
  ROUND(100.0 - (100.0 * users / NULLIF(prev_users,0)), 2) AS dropoff_from_prev_pct
FROM (
  SELECT 1 AS stage_order, 'activated' AS stage_key, 'S1 Activated(Flag)' AS stage_label,
         n1 AS users, NULL AS prev_users, n1
  FROM counts
  UNION ALL
  SELECT 2, 'revenue', 'S2 Revenue(Net≥1)', n2, n1, n1
  FROM counts
  UNION ALL
  SELECT 3, 'referral', 'S3 Referral(+Revenue)', n3, n2, n1
  FROM counts
) f
ORDER BY stage_order;
