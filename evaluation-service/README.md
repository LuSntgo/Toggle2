# evaluation-service

Serviço de avaliação de flags do ToggleMaster (Go) — o "hot path" do
sistema. Decide se uma flag está ligada para um usuário específico,
combinando dados do `flag-service` e do `targeting-service` (com
cache em Redis) e publicando o resultado de cada avaliação numa fila
SQS para o `analytics-service` consumir.

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| GET | `/health` | Health check |
| GET | `/evaluate?user_id=<id>&flag_name=<nome>` | Avalia uma flag para um usuário |

## Variáveis de ambiente

| Nome | Obrigatória | Descrição |
|---|---|---|
| `REDIS_URL` | sim | Cache de flag/regra (ex: `redis://localhost:6379`) |
| `FLAG_SERVICE_URL` | sim | URL base do `flag-service` |
| `TARGETING_SERVICE_URL` | sim | URL base do `targeting-service` |
| `SERVICE_API_KEY` | sim | Chave usada para chamar flag-service/targeting-service |
| `AWS_SQS_URL` | não | Fila SQS de eventos de avaliação (opcional em dev local) |
| `AWS_REGION` | condicional | Obrigatória se `AWS_SQS_URL` estiver definida |
| `PORT` | não (default `8004`) | Porta HTTP |
