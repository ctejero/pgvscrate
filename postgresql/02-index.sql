
-- Indices de claves primarias
ALTER TABLE NATION   ADD PRIMARY KEY (N_NATIONKEY);
ALTER TABLE REGION   ADD PRIMARY KEY (R_REGIONKEY);
ALTER TABLE PART     ADD PRIMARY KEY (P_PARTKEY);
ALTER TABLE SUPPLIER ADD PRIMARY KEY (S_SUPPKEY);
ALTER TABLE PARTSUPP ADD PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY);
ALTER TABLE CUSTOMER ADD PRIMARY KEY (C_CUSTKEY);
ALTER TABLE ORDERS   ADD PRIMARY KEY (O_ORDERKEY);
ALTER TABLE LINEITEM ADD PRIMARY KEY (L_ORDERKEY, L_LINENUMBER);

-- Indices de claves foraneas
CREATE INDEX IDX_NATION_REGIONKEY    ON NATION (N_REGIONKEY);
CREATE INDEX IDX_SUPPLIER_NATION_KEY ON SUPPLIER (S_NATIONKEY);
CREATE INDEX IDX_PARTSUPP_PARTKEY    ON PARTSUPP (PS_PARTKEY);
CREATE INDEX IDX_PARTSUPP_SUPPKEY    ON PARTSUPP (PS_SUPPKEY);
CREATE INDEX IDX_CUSTOMER_NATIONKEY  ON CUSTOMER (C_NATIONKEY);
CREATE INDEX IDX_ORDERS_CUSTKEY      ON ORDERS (O_CUSTKEY);
CREATE INDEX IDX_LINEITEM_ORDERKEY   ON LINEITEM (L_ORDERKEY);
CREATE INDEX IDX_LINEITEM_PART_SUPP  ON LINEITEM (L_PARTKEY,L_SUPPKEY);

-- Indices adicionales
CREATE INDEX IDX_LINEITEM_SHIPDATE    ON LINEITEM (L_SHIPDATE, L_DISCOUNT, L_QUANTITY);
CREATE INDEX IDX_LINEITEM_RECEIPTDATE ON LINEITEM (L_RECEIPTDATE, L_SHIPMODE);
CREATE INDEX IDX_ORDERS_ORDERDATE     ON ORDERS (O_ORDERDATE);
CREATE INDEX IDX_NATION_NAME          ON NATION (N_NAME);
CREATE INDEX IDX_PART_BRAND           ON PART (P_BRAND, P_TYPE, P_SIZE);

