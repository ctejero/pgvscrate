
COPY part TO '/tmp/cpart.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE (p_name,p_mfgr,p_brand,p_type,p_container,p_comment));
COPY region TO '/tmp/cregion.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(r_name,r_comment));
COPY nation TO '/tmp/cnation.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(n_name,n_comment));
COPY supplier TO '/tmp/csupplier.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(s_name,s_address,s_phone,s_comment));
COPY customer TO '/tmp/ccustomer.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(c_name,c_address,c_phone,c_mktsegment,c_comment));
COPY partsupp TO '/tmp/cpartsupp.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(ps_comment));
COPY orders TO '/tmp/corders.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(o_orderstatus,o_orderdate,o_orderpriority,o_clerk,o_comment));
COPY lineitem TO '/tmp/clineitem.csv' WITH (FORMAT csv, HEADER TRUE, QUOTE '"', FORCE_QUOTE(l_returnflag,l_linestatus,l_shipdate,l_commitdate,l_receiptdate,l_shipinstruct,l_shipmode,l_comment));
