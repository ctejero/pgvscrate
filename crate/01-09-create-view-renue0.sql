
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
