# Scheduler Setup — {Application Framework}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB jika aplikasi menggunakan built-in scheduler (Laravel Scheduler, Node-cron, dll)
> **Purpose:** Dokumentasi setup application-level scheduler
> **Output Location:** `{apps|backend|frontend}/docs/operations/cronjobs/` — **INSIDE git repo. DILARANG menulis credential aktual. Gunakan referensi .env atau prod-docs/.**

---

## Overview

**Framework:** {Laravel / Node.js / Go / Python}  
**Scheduler Package:** {Built-in / node-cron / gocron / APScheduler}  
**Tasks:** {List scheduled tasks}

---

## Laravel Scheduler

### Overview

Laravel Scheduler memungkinkan definisi cron jobs di dalam aplikasi (file `app/Console/Kernel.php`) dan hanya membutuhkan **1 cronjob entry** di server.

### Prerequisites

- Laravel sudah terinstall
- Database migration sudah dijalankan
- Queue driver sudah dikonfigurasi (jika task menggunakan queue)

### Setup

**1. Check if scheduler is configured:**
```bash
cd {project_path}
php artisan schedule:list
```

**Expected output:**
```
0 0 * * *  App\Console\Commands\CleanupOldRecords ..........  Next Due In 5 hours
0 */6 * * *  App\Console\Commands\GenerateReports ..........  Next Due In 2 hours
```

**2. Add single cronjob entry:**
```bash
crontab -e
```

**Add:**
```bash
* * * * * cd {project_path} && php artisan schedule:run >> /dev/null 2>&1
```

**3. Verify cronjob:**
```bash
crontab -l
```

### Define Scheduled Tasks

**File:** `app/Console/Kernel.php`

```php
protected function schedule(Schedule $schedule)
{
    // Daily cleanup at midnight
    $schedule->command('cleanup:old-records')
             ->daily()
             ->withoutOverlapping()
             ->runInBackground();
    
    // Every 6 hours
    $schedule->command('reports:generate')
             ->everySixHours()
             ->emailOutputOnFailure('admin@example.com');
    
    // Weekly on Sunday at 1 AM
    $schedule->command('backup:weekly')
             ->weeklyOn(0, '1:00');
}
```

### Common Schedule Methods

```php
->everyMinute();
->everyFiveMinutes();
->everyTenMinutes();
->everyFifteenMinutes();
->everyThirtyMinutes();
->hourly();
->daily();
->dailyAt('13:00');
->weekly();
->weeklyOn(1, '8:00'); // Monday at 8 AM
->monthly();
->yearly();
```

### Advanced Options

```php
->withoutOverlapping()        // Prevent overlapping runs
->runInBackground()           // Run in background
->onOneServer()              // Only run on one server (multi-server setup)
->emailOutputOnFailure($email) // Email on failure
->sendOutputTo($filePath)    // Log output to file
->appendOutputTo($filePath)  // Append output to file
```

---

## Node.js Scheduler (node-cron)

### Overview

Node-cron adalah package untuk menjalankan scheduled tasks di Node.js applications.

### Installation

```bash
npm install node-cron
```

### Setup

**File:** `src/scheduler/index.js`

```javascript
const cron = require('node-cron');

// Daily cleanup at 2 AM
cron.schedule('0 2 * * *', async () => {
    console.log('Running daily cleanup...');
    try {
        await cleanupOldRecords();
        console.log('Cleanup completed');
    } catch (error) {
        console.error('Cleanup failed:', error);
    }
});

// Every 6 hours
cron.schedule('0 */6 * * *', async () => {
    console.log('Running report generation...');
    try {
        await generateReports();
        console.log('Reports generated');
    } catch (error) {
        console.error('Report generation failed:', error);
    }
});

// Weekly on Sunday at 1 AM
cron.schedule('0 1 * * 0', async () => {
    console.log('Running weekly backup...');
    try {
        await weeklyBackup();
        console.log('Weekly backup completed');
    } catch (error) {
        console.error('Weekly backup failed:', error);
    }
});

console.log('Scheduler started');
```

**Start scheduler:**
```bash
# Development
node src/scheduler/index.js

# Production (with PM2)
pm2 start src/scheduler/index.js --name scheduler
pm2 save
```

### Cron Expression Reference

```
* * * * * *
│ │ │ │ │ │
│ │ │ │ │ └── Day of week (0-7, Sunday=0 or 7)
│ │ │ │ └──── Month (1-12)
│ │ │ └────── Day of month (1-31)
│ │ └──────── Hour (0-23)
│ └────────── Minute (0-59)
└──────────── Second (0-59) (optional)
```

---

## Go Scheduler (gocron)

### Overview

Gocron adalah package untuk menjalankan scheduled tasks di Go applications.

### Installation

```bash
go get github.com/go-co-op/gocron
```

### Setup

**File:** `internal/scheduler/scheduler.go`

```go
package scheduler

import (
    "log"
    "time"
    
    "github.com/go-co-op/gocron"
)

func Start() {
    s := gocron.NewScheduler(time.UTC)
    
    // Daily cleanup at 2 AM
    s.Every(1).Day().At("02:00").Do(func() {
        log.Println("Running daily cleanup...")
        if err := cleanupOldRecords(); err != nil {
            log.Printf("Cleanup failed: %v", err)
        } else {
            log.Println("Cleanup completed")
        }
    })
    
    // Every 6 hours
    s.Every(6).Hours().Do(func() {
        log.Println("Running report generation...")
        if err := generateReports(); err != nil {
            log.Printf("Report generation failed: %v", err)
        } else {
            log.Println("Reports generated")
        }
    })
    
    // Weekly on Sunday at 1 AM
    s.Every(1).Sunday().At("01:00").Do(func() {
        log.Println("Running weekly backup...")
        if err := weeklyBackup(); err != nil {
            log.Printf("Weekly backup failed: %v", err)
        } else {
            log.Println("Weekly backup completed")
        }
    })
    
    s.StartAsync()
    log.Println("Scheduler started")
}
```

**Start scheduler in main:**
```go
package main

import (
    "your-project/internal/scheduler"
)

func main() {
    // Start scheduler
    scheduler.Start()
    
    // Start server
    // ...
}
```

---

## Verification

### Laravel

**List scheduled tasks:**
```bash
php artisan schedule:list
```

**Test scheduler manually:**
```bash
php artisan schedule:run
```

**Check scheduler logs:**
```bash
tail -f storage/logs/laravel.log | grep -i schedule
```

### Node.js

**Check PM2 status:**
```bash
pm2 status
pm2 logs scheduler
```

### Go

**Check application logs:**
```bash
journalctl -u your-app -f | grep -i scheduler
```

---

## Troubleshooting

### Laravel scheduler tidak jalan

**Symptom:** Scheduled tasks tidak dijalankan

**Solutions:**
1. Check cronjob exists:
   ```bash
   crontab -l
   ```

2. Test manually:
   ```bash
   php artisan schedule:run
   ```

3. Check logs:
   ```bash
   tail -f storage/logs/laravel.log
   ```

4. Check timezone:
   ```php
   // config/app.php
   'timezone' => 'Asia/Jakarta',
   ```

### Node.js scheduler crash

**Symptom:** PM2 shows scheduler status "errored"

**Solutions:**
1. Check logs:
   ```bash
   pm2 logs scheduler --lines 100
   ```

2. Restart scheduler:
   ```bash
   pm2 restart scheduler
   ```

3. Check memory limit:
   ```bash
   pm2 show scheduler
   ```

### Go scheduler tidak start

**Symptom:** No scheduler logs in application

**Solutions:**
1. Check if `scheduler.Start()` is called in main
2. Check application logs for errors
3. Verify gocron package is installed:
   ```bash
   go list -m github.com/go-co-op/gocron
   ```

---

## Auto-Setup Script

**Script:** `{project_path}/docs/operations/scripts/setup-scheduler.sh`

```bash
#!/bin/bash
# Setup application scheduler

PROJECT_PATH="{project_path}"
FRAMEWORK="{framework}"

cd $PROJECT_PATH

if [ "$FRAMEWORK" = "laravel" ]; then
    # Check if scheduler is configured
    php artisan schedule:list
    
    # Add cronjob
    (crontab -l 2>/dev/null; echo "* * * * * cd $PROJECT_PATH && php artisan schedule:run >> /dev/null 2>&1") | crontab -
    
    echo "Laravel scheduler setup completed"
    
elif [ "$FRAMEWORK" = "nodejs" ]; then
    # Install dependencies
    npm install
    
    # Start with PM2
    pm2 start src/scheduler/index.js --name scheduler
    pm2 save
    pm2 startup
    
    echo "Node.js scheduler setup completed"
    
elif [ "$FRAMEWORK" = "go" ]; then
    # Build application
    go build -o app
    
    echo "Go scheduler is built into application. Start the application to run scheduler."
    
else
    echo "Unsupported framework: $FRAMEWORK"
    exit 1
fi
```

**Run (auto-setup mode):**
```bash
bash {project_path}/docs/operations/scripts/setup-scheduler.sh
```

**Run (manual-setup mode):**
```bash
# Copy commands dari script dan jalankan manual
```
