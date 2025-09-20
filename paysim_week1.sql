CREATE DATABASE paysim_study;
USE paysim_study;

## 분석 전에 확인할 것

-- 테이블 구조 및 데이터 사이
select * from paysim;
select count(*) from paysim;

-- 거래 유형 분포
select
	type,
    count(*) as cnt
from paysim
group by type
order by cnt desc;

## <type>
## CASH-IN: 현금을 계좌에 입금
## CASH-OUT: 계좌에서 현금을 인출
## TRANSFER: 계좌 간 송금 P2P
## PAYMENT: 상품/서비스 구매 지불
## DEBIT: 계좌에서 바로 인출 (자동이체)

-- Fraud 비율
select
	sum(isFraud) as fraud_cnt,
    count(*) as cnt,
    round(sum(isFraud)/count(*)*100,2) as fraud_pct
from paysim;

-- flagged fraud 비율
select
	sum(isFlaggedFraud) as flagged_cnt,
    count(*) as cnt,
    round(sum(isFlaggedFraud)/count(*)*100,2) as flagged_pct
from paysim;

-- detectio 비율
select
    sum(isFlaggedFraud) as flagged_cnt,
    sum(isFraud) as fraud_cnt,
    round(sum(isFlaggedFraud)/sum(isFraud)*100,2) as fraud_pct
from paysim;

