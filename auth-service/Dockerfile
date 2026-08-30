# ---- Stage 1: Build ----
FROM golang:1.24.13-alpine AS builder

RUN apk add --no-cache git ca-certificates

# Instala a ferramenta oficial para limpar imports fantasmas automaticamente
RUN go install golang.org/x/tools/cmd/goimports@v0.18.0

WORKDIR /app

COPY go.mod go.sum* ./
RUN go mod download

COPY . .

# Roda o goimports para remover imports não utilizados e formatar o código
RUN goimports -w .
# Sincroniza os módulos após a limpeza do código
RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/auth-service .

# ---- Stage 2: Runtime ----
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

RUN addgroup -S app && adduser -S app -G app
USER app

WORKDIR /app
COPY --from=builder /app/auth-service .

EXPOSE 8001

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8001/health || exit 1

ENTRYPOINT ["./auth-service"]