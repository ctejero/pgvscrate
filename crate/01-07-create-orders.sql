
CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                       O_CUSTKEY        INTEGER NOT NULL,
                       O_ORDERSTATUS    STRING NOT NULL,
                       O_TOTALPRICE     DOUBLE NOT NULL,
                       O_ORDERDATE      TIMESTAMP NOT NULL,
                       O_ORDERPRIORITY  STRING NOT NULL,  
                       O_CLERK          STRING NOT NULL, 
                       O_SHIPPRIORITY   INTEGER NOT NULL,
                       O_COMMENT        STRING NOT NULL );

