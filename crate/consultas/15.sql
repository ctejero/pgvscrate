-- $ID$
-- TPC-H/TPC-R Top Supplier Query (Q15)
-- Functional Query Definition
-- Approved February 1998
-- using 1554216773 as a seed to the RNG
create view revenue0 as
	select
		l_suppkey AS supplier_no,
		sum(l_extendedprice * (1 - l_discount)) AS total_revenue
	from
		lineitem
	where
		l_shipdate >= '1993-09-01'
		and l_shipdate < '1993-12-01'
	group by
		l_suppkey;


select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue0
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue0
	)
order by
	s_suppkey
limit 1;

drop view revenue0;

