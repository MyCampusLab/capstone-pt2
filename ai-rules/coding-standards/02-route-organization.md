# Route Organization

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Prinsip Dasar

- **1 route file = 1 module/domain** (maksimal 200 baris)
- Routes **WAJIB** dikelompokkan berdasarkan module bisnis, bukan berdasarkan HTTP method
- Gunakan route groups untuk prefix, middleware, dan namespace yang sama
- Jika route file mendekati 200 baris, **WAJIB** split ke partials

### Laravel (Monolith)

```
routes/
├── web.php                          (140 baris - core routes only)
├── api.php                          (50 baris - API routes only)
├── hris_web.php                     (200 baris - HRIS module)
│   ├── require routes/partials/hris/employee.php
│   ├── require routes/partials/hris/attendance.php
│   └── require routes/partials/hris/payroll.php
├── asset_web.php                    (200 baris - Asset module)
│   ├── require routes/partials/asset/inventory.php
│   ├── require routes/partials/asset/maintenance.php
│   └── require routes/partials/asset/procurement.php
└── partials/
    ├── hris/
    │   ├── employee.php             (80 baris - Employee CRUD)
    │   ├── attendance.php           (60 baris - Attendance routes)
    │   └── payroll.php              (60 baris - Payroll routes)
    └── asset/
        ├── inventory.php            (70 baris)
        ├── maintenance.php          (65 baris)
        └── procurement.php          (65 baris)
```

**Contoh hris_web.php:**
```php
<?php

use App\Http\Controllers\hris\employee\HrisEmployeeController;

Route::middleware(['auth', 'verified'])->prefix('hris')->name('hris.')->group(function () {
    // Employee routes
    require base_path('routes/partials/hris/employee.php');
    
    // Attendance routes
    require base_path('routes/partials/hris/attendance.php');
    
    // Payroll routes
    require base_path('routes/partials/hris/payroll.php');
});
```

**Contoh partials/hris/employee.php:**
```php
<?php

use App\Http\Controllers\hris\employee\HrisEmployeeController;
use App\Http\Controllers\hris\employee\HrisEmployeeAttachmentController;

Route::prefix('employee')->name('employee.')->group(function () {
    Route::get('/', [HrisEmployeeController::class, 'index'])->name('index');
    Route::get('/create', [HrisEmployeeController::class, 'create'])->name('create');
    Route::post('/', [HrisEmployeeController::class, 'store'])->name('store');
    Route::get('/{id}', [HrisEmployeeController::class, 'show'])->name('show');
    Route::get('/{id}/edit', [HrisEmployeeController::class, 'edit'])->name('edit');
    Route::put('/{id}', [HrisEmployeeController::class, 'update'])->name('update');
    Route::delete('/{id}', [HrisEmployeeController::class, 'destroy'])->name('destroy');
    
    // Attachments
    Route::post('/{id}/attachments', [HrisEmployeeAttachmentController::class, 'store'])->name('attachments.store');
    Route::delete('/attachments/{attachment}', [HrisEmployeeAttachmentController::class, 'destroy'])->name('attachments.destroy');
});
```

### Express.js / Node.js (Fullstack Backend)

```
routes/
├── index.js                         (50 baris - router aggregator)
├── hris/
│   ├── index.js                     (30 baris - HRIS router)
│   ├── employee.js                  (80 baris - Employee routes)
│   ├── attendance.js                (60 baris)
│   └── payroll.js                   (60 baris)
└── asset/
    ├── index.js                     (30 baris)
    ├── inventory.js                 (70 baris)
    └── maintenance.js               (65 baris)
```

**Contoh routes/index.js:**
```javascript
const express = require('express');
const router = express.Router();

router.use('/hris', require('./hris'));
router.use('/asset', require('./asset'));
router.use('/document', require('./document'));

module.exports = router;
```

**Contoh routes/hris/employee.js:**
```javascript
const express = require('express');
const router = express.Router();
const employeeController = require('../../controllers/hris/employeeController');
const { authenticate, authorize } = require('../../middleware/auth');

router.use(authenticate);

router.get('/', employeeController.index);
router.post('/', authorize('hris.employee.create'), employeeController.store);
router.get('/:id', employeeController.show);
router.put('/:id', authorize('hris.employee.update'), employeeController.update);
router.delete('/:id', authorize('hris.employee.delete'), employeeController.destroy);

module.exports = router;
```

### Go (Fiber/Gin)

```
routes/
├── routes.go                        (50 baris - main router setup)
├── hris.go                          (30 baris - HRIS group)
├── hris_employee.go                 (80 baris)
├── hris_attendance.go               (60 baris)
└── asset_inventory.go               (70 baris)
```

**Contoh routes/routes.go:**
```go
package routes

func SetupRoutes(app *fiber.App) {
    api := app.Group("/api", middleware.Auth)
    
    SetupHRISRoutes(api)
    SetupAssetRoutes(api)
    SetupDocumentRoutes(api)
}
```

**Contoh routes/hris_employee.go:**
```go
package routes

func SetupHRISEmployeeRoutes(router fiber.Router) {
    employee := router.Group("/hris/employees")
    
    employee.Get("/", handlers.GetEmployees)
    employee.Post("/", middleware.Authorize("hris.employee.create"), handlers.CreateEmployee)
    employee.Get("/:id", handlers.GetEmployee)
    employee.Put("/:id", middleware.Authorize("hris.employee.update"), handlers.UpdateEmployee)
    employee.Delete("/:id", middleware.Authorize("hris.employee.delete"), handlers.DeleteEmployee)
}
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
