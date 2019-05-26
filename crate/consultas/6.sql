-- $ID$
-- TPC-H/TPC-R Forecasting Revenue Change Query (Q6)
-- Functional Query Definition
-- Approved February 1998
-- using 1554216773 as a seed to the RNG
select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= '1995-01-01'
	and l_shipdate < '1996-01-01'
	and l_discount between 0.05 and 0.07
	and l_quantity < 25
limit 1;
