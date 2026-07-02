#!/bin/bash
# Este script roda automaticamente na primeira inicialização do container
# postgres-flags-targeting (via docker-entrypoint-initdb.d, executado em
# ordem alfabética -- por isso o prefixo "00-").
#
# Motivo de existir: o entrypoint oficial da imagem postgres só cria
# automaticamente UM banco (o definido em POSTGRES_DB = flags_db). Como o
# desafio pede bancos independentes para flag-service e targeting-service,
# este script:
#   1. Cria o banco targeting_db manualmente.
#   2. Aplica o schema (tabela "flags") no banco flags_db.
#   3. Aplica o schema (tabela "targeting_rules") no banco targeting_db.
#
# Os arquivos .sql de cada serviço (flag-service/db/init.sql e
# targeting-service/db/init.sql) são copiados para dentro da imagem do
# Postgres pelo docker-compose.yml e referenciados aqui via \i.

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE targeting_db'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'targeting_db')\gexec
EOSQL

echo ">> Aplicando schema do flag-service no banco flags_db..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "flags_db" \
     -f /docker-entrypoint-initdb.d/flag-service-init.sql

echo ">> Aplicando schema do targeting-service no banco targeting_db..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "targeting_db" \
     -f /docker-entrypoint-initdb.d/targeting-service-init.sql

echo ">> Bancos flags_db e targeting_db prontos."
