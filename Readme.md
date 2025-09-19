# dbops-project

## Создание БД 

```sql
CREATE DATABASE store;
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$STORE_USER') THEN
    CREATE ROLE "$STORE_USER" LOGIN PASSWORD '$STORE_PASS';
  ELSE
    ALTER ROLE "$STORE_USER" LOGIN PASSWORD '$STORE_PASS';
  END IF;
END\$\$;
GRANT CONNECT ON DATABASE store TO "$STORE_USER";
```

## Права в самой БД

```sql
GRANT USAGE, CREATE ON SCHEMA public TO "$STORE_USER";
ALTER ROLE "$STORE_USER" SET search_path TO public;
```

Пароль берётся из секретов