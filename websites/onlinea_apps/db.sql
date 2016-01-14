-- initdb -D db
-- postgres -D db
-- ~/onlinea/src/github.com/jirkadanek/onlinea/websites/onlinea_apps/db.sql

CREATE TABLE pages (
    id  serial,
    url text,
    text text,
    ctime timestamp DEFAULT current_timestamp
);