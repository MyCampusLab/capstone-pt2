# Anti-Patterns

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### 1. God Controller

```php
// ❌ SALAH: Controller 3000+ baris
class EmployeeController {
    public function store(Request $request) {
        // Validation (100 lines)
        // Business logic (200 lines)
        // Database operations (150 lines)
        // File uploads (100 lines)
        // Notifications (80 lines)
        // PDF generation (120 lines)
    }
}
```

**Solusi:** Extract ke Service, Repository, dan specialized classes.

### 2. Fat Model

```php
// ❌ SALAH: Model dengan business logic
class Employee extends Model {
    public function calculateSalary() {
        // 100 baris perhitungan gaji
    }
    
    public function generateReport() {
        // 150 baris report generation
    }
}
```

**Solusi:** Pindahkan business logic ke Service class.

### 3. Nested Conditionals

```php
// ❌ SALAH: Deep nesting
public function process($data) {
    if ($data['type'] == 'A') {
        if ($data['status'] == 'active') {
            if ($data['amount'] > 1000) {
                // logic
            }
        }
    }
}

// ✅ BENAR: Early return
public function process($data) {
    if ($data['type'] !== 'A') {
        return;
    }
    if ($data['status'] !== 'active') {
        return;
    }
    if ($data['amount'] <= 1000) {
        return;
    }
    // logic
}
```

### 4. Magic Numbers

```php
// ❌ SALAH
if ($employee->type === 1) {
    $salary = $base * 1.5;
}

// ✅ BENAR
private const EMPLOYEE_TYPE_PERMANENT = 1;
private const SALARY_MULTIPLIER_PERMANENT = 1.5;

if ($employee->type === self::EMPLOYEE_TYPE_PERMANENT) {
    $salary = $base * self::SALARY_MULTIPLIER_PERMANENT;
}
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
