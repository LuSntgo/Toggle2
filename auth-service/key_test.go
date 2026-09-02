package main

import (
	"strings"
	"testing"
)

func TestGenerateAPIKey(t *testing.T) {
	key, err := generateAPIKey()
	if err != nil {
		t.Fatalf("generateAPIKey() retornou erro: %v", err)
	}
	if !strings.HasPrefix(key, "tm_key_") {
		t.Errorf("generateAPIKey() = %q, esperado prefixo 'tm_key_'", key)
	}
	wantLen := len("tm_key_") + 64 // 32 bytes em hex = 64 caracteres
	if len(key) != wantLen {
		t.Errorf("generateAPIKey() tamanho = %d, esperado %d", len(key), wantLen)
	}
}

func TestGenerateAPIKey_Unique(t *testing.T) {
	key1, err := generateAPIKey()
	if err != nil {
		t.Fatalf("generateAPIKey() retornou erro: %v", err)
	}
	key2, err := generateAPIKey()
	if err != nil {
		t.Fatalf("generateAPIKey() retornou erro: %v", err)
	}
	if key1 == key2 {
		t.Error("duas chamadas de generateAPIKey() geraram a mesma chave")
	}
}

func TestHashAPIKey_Deterministic(t *testing.T) {
	hash1 := hashAPIKey("minha-chave-teste")
	hash2 := hashAPIKey("minha-chave-teste")
	if hash1 != hash2 {
		t.Errorf("hashAPIKey não é determinístico: %q != %q", hash1, hash2)
	}
	if len(hash1) != 64 {
		t.Errorf("hashAPIKey tamanho = %d, esperado 64 (SHA-256 em hex)", len(hash1))
	}
}

func TestHashAPIKey_DifferentInputs(t *testing.T) {
	if hashAPIKey("chave-a") == hashAPIKey("chave-b") {
		t.Error("hashAPIKey('chave-a') e hashAPIKey('chave-b') não deveriam colidir")
	}
}
