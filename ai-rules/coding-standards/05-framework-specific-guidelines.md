# Framework-Specific Guidelines

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Laravel

#### Resource Controllers (WAJIB)

Gunakan Resource Controller untuk CRUD operations:

```php
// routes/web.php
Route::resource('employees', EmployeeController::class);

// app/Http/Controllers/EmployeeController.php
class EmployeeController extends Controller {
    public function index() {}      // GET /employees
    public function create() {}     // GET /employees/create
    public function store() {}      // POST /employees
    public function show() {}       // GET /employees/{id}
    public function edit() {}       // GET /employees/{id}/edit
    public function update() {}     // PUT /employees/{id}
    public function destroy() {}    // DELETE /employees/{id}
}
```

#### Form Requests (WAJIB untuk Validation)

```php
// JANGAN validasi di controller
public function store(Request $request) {
    $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:employees',
        // 50 baris validation rules...
    ]);
}

// GUNAKAN Form Request
php artisan make:request StoreEmployeeRequest

// app/Http/Requests/StoreEmployeeRequest.php
class StoreEmployeeRequest extends FormRequest {
    public function rules(): array {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:employees'],
        ];
    }
}

// Controller jadi clean
public function store(StoreEmployeeRequest $request) {
    $this->employeeService->create($request->validated());
}
```

#### Service Layer Pattern

```php
// app/Services/EmployeeService.php
class EmployeeService {
    public function __construct(
        private EmployeeRepository $repository,
        private DocumentService $documentService,
        private NotificationService $notification
    ) {}
    
    public function createEmployee(array $data): Employee {
        return DB::transaction(function () use ($data) {
            $employee = $this->repository->create($data);
            $this->documentService->uploadDocuments($employee, $data['documents']);
            $this->notification->sendWelcomeEmail($employee);
            return $employee;
        });
    }
}
```

#### Repository Pattern

```php
// app/Repositories/EmployeeRepository.php
class EmployeeRepository {
    public function create(array $data): Employee {
        return Employee::create($data);
    }
    
    public function findByEmail(string $email): ?Employee {
        return Employee::where('email', $email)->first();
    }
    
    public function getActiveEmployees(): Collection {
        return Employee::where('status', 'active')
            ->orderBy('name')
            ->get();
    }
}
```

### Express.js / Node.js

#### Controller-Service Pattern

```javascript
// routes/employees.js
router.post('/', employeeController.create);

// controllers/employeeController.js
class EmployeeController {
    constructor(employeeService) {
        this.employeeService = employeeService;
    }
    
    async create(req, res, next) {
        try {
            const employee = await this.employeeService.create(req.body);
            res.status(201).json(employee);
        } catch (error) {
            next(error);
        }
    }
}

// services/employeeService.js
class EmployeeService {
    constructor(employeeRepository) {
        this.employeeRepository = employeeRepository;
    }
    
    async create(data) {
        this.validate(data);
        return await this.employeeRepository.create(data);
    }
}
```

### Go (Fiber/Gin/Echo)

#### Handler-Service Pattern

```go
// handlers/employee_handler.go
type EmployeeHandler struct {
    service *services.EmployeeService
}

func (h *EmployeeHandler) Create(c *fiber.Ctx) error {
    var req CreateEmployeeRequest
    if err := c.BodyParser(&req); err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
    }
    
    employee, err := h.service.CreateEmployee(req)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": err.Error()})
    }
    
    return c.Status(201).JSON(employee)
}

// services/employee_service.go
type EmployeeService struct {
    repo *repositories.EmployeeRepository
}

func (s *EmployeeService) CreateEmployee(req CreateEmployeeRequest) (*models.Employee, error) {
    if err := s.validate(req); err != nil {
        return nil, err
    }
    return s.repo.Create(req.ToModel())
}
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
