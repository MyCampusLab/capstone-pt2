# File Size Limits

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Batas Maksimal Baris per File

| Jenis File | Maksimal Baris | Rekomendasi |
|------------|----------------|-------------|
| Controller | 1000 baris | 500 baris |
| Service/Business Logic | 800 baris | 400 baris |
| Model/Entity | 300 baris | 150 baris |
| Repository | 500 baris | 300 baris |
| Helper/Utility | 400 baris | 200 baris |
| Test File | 800 baris | 500 baris |
| Route File | 200 baris | 100 baris |
| View/Page Component | 500 baris | 300 baris |
| Partial/Component | 300 baris | 150 baris |

**Catatan Penting:**
- Batas di atas adalah **maksimal absolut**. Jika file mendekati batas, pertimbangkan refactor.
- **Separation of Concerns lebih penting dari line count**. Controller 800 baris dengan logic yang terstruktur lebih baik dari controller 200 baris yang campur aduk.
- Untuk project kompleks (multi-tenant, many roles, complex workflows), controller bisa lebih panjang selama tetap maintainable.
- Jika controller >1000 baris, **WAJIB** extract ke Service layer dan pertimbangkan split controller.
- Route file >200 baris **WAJIB** dipecah ke partials per module/sub-module.
- View/Page >500 baris **WAJIB** dipecah ke partials/components.

### Jika File Melebihi Batas

**WAJIB refactor dengan strategi berikut:**

1. **Extract ke Service Layer** - Pindahkan business logic ke Service class
2. **Extract ke Repository** - Pindahkan database queries ke Repository class
3. **Split Controller** - Bagi controller berdasarkan resource/domain
4. **Extract Helper Methods** - Pindahkan utility functions ke Helper class

**Contoh Refactoring:**

```php
// BEFORE: Controller 3000+ baris
class EmployeeController extends Controller {
    public function store(Request $request) {
        // 200 baris validation
        // 300 baris business logic
        // 100 baris database operations
        // 150 baris file handling
        // 100 baris notifications
    }
}

// AFTER: Clean architecture
class EmployeeController extends Controller {
    public function __construct(
        private EmployeeService $employeeService
    ) {}
    
    public function store(StoreEmployeeRequest $request) {
        $employee = $this->employeeService->createEmployee($request->validated());
        return redirect()->route('employees.show', $employee);
    }
}

class EmployeeService {
    public function __construct(
        private EmployeeRepository $repository,
        private EmployeeValidator $validator,
        private NotificationService $notification
    ) {}
    
    public function createEmployee(array $data): Employee {
        $this->validator->validate($data);
        $employee = $this->repository->create($data);
        $this->notification->sendWelcomeEmail($employee);
        return $employee;
    }
}
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
