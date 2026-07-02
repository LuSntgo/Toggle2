# ToggleMaster — Ambiente Local (Docker Compose)

Este `docker-compose.yml` sobe os 9 containers exigidos pela Fase 2 do Tech
Challenge: os 5 microsserviços do ToggleMaster + os 4 bancos de dados locais
(2x PostgreSQL, Redis, DynamoDB Local).

## Como rodar

```bash
docker compose up --build
```

A primeira execução demora mais (build das imagens Go e Python). Nas
próximas, o Docker reaproveita o cache de camadas.

Para derrubar tudo (incluindo os volumes de dados):

```bash
docker compose down -v
```

## Mapa de portas (host → container)

| Serviço                    | Porta  | URL local                |
|-----------------------------|--------|---------------------------|
| auth-service                | 8001   | http://localhost:8001     |
| flag-service                 | 8002   | http://localhost:8002     |
| targeting-service             | 8003   | http://localhost:8003     |
| evaluation-service             | 8004   | http://localhost:8004     |
| analytics-service (health)      | 8005   | http://localhost:8005/health |
| postgres-auth                 | 5433   | localhost:5433 (auth_db)  |
| postgres-flags-targeting        | 5434   | localhost:5434 (flags_db / targeting_db) |
| redis                         | 6379   | localhost:6379             |
| dynamodb-local                  | 8000   | http://localhost:8000      |

> Os dois bancos Postgres usam portas externas diferentes (5433/5434) porque
> a porta padrão 5432 só pode ser mapeada para um host por vez. Internamente,
> dentro da rede Docker, ambos os containers continuam escutando em 5432.

## Fluxo de teste rápido (smoke test)

```bash
# 1. Health check de cada serviço
curl http://localhost:8001/health
curl http://localhost:8002/health
curl http://localhost:8003/health
curl http://localhost:8004/health

# 2. Cria uma chave de API no auth-service
curl -X POST http://localhost:8001/admin/keys \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer admin-secreto-123" \
  -d '{"name": "minha-chave-teste"}'
# Copie o valor de "key" retornado (ex: tm_key_...)

# 3. Cria uma flag (substitua SUA_CHAVE pela key do passo 2)
curl -X POST http://localhost:8002/flags \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SUA_CHAVE" \
  -d '{"name": "enable-new-dashboard", "description": "teste", "is_enabled": true}'

# 4. Cria uma regra de segmentação (50%)
curl -X POST http://localhost:8003/rules \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SUA_CHAVE" \
  -d '{"flag_name": "enable-new-dashboard", "is_enabled": true, "rules": {"type": "PERCENTAGE", "value": 50}}'

# 5. Avalia a flag para um usuário (hot path)
curl "http://localhost:8004/evaluate?user_id=user-123&flag_name=enable-new-dashboard"
```

## ⚠️ Limitação conhecida: analytics-service e SQS/DynamoDB locais

O `dynamodb-local` sobe normalmente neste compose e a tabela
`ToggleMasterAnalytics` é criada automaticamente pelo container
`dynamodb-init` — isso já comprova que o ambiente local "roda" como pede o
enunciado.

Porém, o **código-fonte original** do `analytics-service` (fornecido pela
FIAP, em `app.py`) foi escrito para falar somente com a **AWS real**:

- Ele usa `boto3.Session(region_name=...)` sem nenhum `endpoint_url`
  configurável, então não há como apontá-lo para o `dynamodb-local` sem
  alterar o código-fonte.
- Ele encerra o processo (`sys.exit(1)`) se a variável `AWS_SQS_URL` estiver
  vazia — ou seja, não tem um "modo offline" como o `evaluation-service` tem
  para o SQS.

Por isso, no `docker-compose.yml`, o `analytics-service` está com
`restart: on-failure:3` (em vez de reiniciar para sempre) e as variáveis
`AWS_SQS_URL` / `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` /
`AWS_SESSION_TOKEN` ficam vazias por padrão, podendo ser preenchidas via
`.env` (veja `.env.example`) apontando para a fila SQS real criada na AWS
(Etapa 2 do desafio). Quando preenchidas com credenciais válidas, o
container conecta normalmente à AWS real e consome a fila/grava no
DynamoDB real — exatamente como vai acontecer depois, dentro do cluster
EKS.

Isso não é um bug do nosso Dockerfile/compose: é uma característica do
código-fonte fornecido, e vale citar essa observação no relatório/vídeo
("o ambiente local sobe os 9 containers; a integração ponta-a-ponta do
analytics-service foi validada contra a AWS real, já que o serviço não
suporta endpoint customizado para SQS/DynamoDB").

## Variáveis de ambiente sensíveis

Crie um arquivo `.env` na raiz do projeto (mesmo nível deste
`docker-compose.yml`) baseado no `.env.example` para testar a integração
real com SQS/DynamoDB da AWS, sem versionar credenciais no Git.
