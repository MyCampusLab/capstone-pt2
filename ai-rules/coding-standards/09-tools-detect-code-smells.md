# Tools untuk Detect Code Smells

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### PHP (Laravel)

```bash
# PHPStan - Static analysis
./vendor/bin/phpstan analyse app --level=6

# PHP_CodeSniffer - Coding standards
./vendor/bin/phpcs --standard=PSR12 app/

# PHPMD - Mess detector
./vendor/bin/phpmd app text cleancode,codesize,controversial,design,naming,unusedcode
```

### JavaScript/TypeScript

```bash
# ESLint
npx eslint src/

# SonarJS
npx sonarjs src/
```

### Go

```bash
# golangci-lint
golangci-lint run

# go vet
go vet ./...
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
