#!/bin/bash
psql template1 -h db -c "create user smalljobs" || true
psql template1 -h db -c 'CREATE DATABASE "smalljobs_development";' || true
psql template1 -h db -c 'GRANT ALL PRIVILEGES ON DATABASE "smalljobs_development" to smalljobs;' || true
psql template1 -h db -c 'CREATE DATABASE "smalljobs_test";' || true
psql template1 -h db -c 'GRANT ALL PRIVILEGES ON DATABASE "smalljobs_test" to smalljobs;' || true
psql template1 -h db -c 'ALTER DATABASE "smalljobs_development" OWNER TO smalljobs;' || true
psql template1 -h db -c 'ALTER DATABASE "smalljobs_test" OWNER TO smalljobs;' || true
psql smalljobs_development -h db -c 'CREATE EXTENSION "uuid-ossp"'
# psql smalljobs_development -h db -c 'CREATE EXTENSION pgcrypto' || true
# psql smalljobs_test -h db -c 'CREATE EXTENSION pgcrypto' || true
# psql smalljobs_development -h db -c 'CREATE EXTENSION hstore' || true
# psql smalljobs_test -h db -c 'CREATE EXTENSION hstore' || true
exit