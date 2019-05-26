
CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,
                        L_PARTKEY     INTEGER NOT NULL,
                        L_SUPPKEY     INTEGER NOT NULL,
                        L_LINENUMBER  INTEGER NOT NULL,
                        L_QUANTITY    DOUBLE NOT NULL,
                        L_EXTENDEDPRICE  DOUBLE NOT NULL,
                        L_DISCOUNT    DOUBLE NOT NULL,
                        L_TAX         DOUBLE NOT NULL,
                        L_RETURNFLAG  STRING NOT NULL,
                        L_LINESTATUS  STRING NOT NULL,
                        L_SHIPDATE    TIMESTAMP NOT NULL,
                        L_COMMITDATE  TIMESTAMP NOT NULL,
                        L_RECEIPTDATE TIMESTAMP NOT NULL,
                        L_SHIPINSTRUCT STRING NOT NULL,
                        L_SHIPMODE     STRING NOT NULL,
                        L_COMMENT      STRING NOT NULL);

