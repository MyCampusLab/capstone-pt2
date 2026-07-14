# View/UI Organization

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Prinsip Dasar

- **1 page file = 1 page/view** (maksimal 500 baris)
- Pages **WAJIB** dipecah ke partials/components untuk section yang reusable atau panjang
- Setiap partial/component harus punya **1 tanggung jawab**
- Jika page mendekati 500 baris, **WAJIB** extract ke partials

### Laravel Blade (Monolith)

```
resources/views/pages/hris/employee/
├── index.blade.php                  (200 baris - main page)
├── create.blade.php                 (150 baris)
├── edit.blade.php                   (150 baris)
├── show.blade.php                   (300 baris)
├── form.blade.php                   (400 baris - shared form)
│   ├── @include('pages.hris.employee.partials.form_personal')
│   ├── @include('pages.hris.employee.partials.form_employment')
│   ├── @include('pages.hris.employee.partials.form_documents')
│   └── @include('pages.hris.employee.partials.form_attachments')
└── partials/
    ├── form_personal.blade.php      (100 baris - Personal data section)
    ├── form_employment.blade.php    (120 baris - Employment data section)
    ├── form_documents.blade.php     (80 baris - Documents upload section)
    ├── form_attachments.blade.php   (90 baris - Attachments section)
    ├── show_tabs_regular.blade.php  (50 baris - Regular employee tabs)
    ├── show_tabs_harian.blade.php   (67 baris - Daily worker tabs)
    └── attachment_table.blade.php   (55 baris - Reusable attachment table)
```

**Contoh form.blade.php:**
```blade
@extends('layouts.app')

@section('content')
<div class="container">
    <form action="{{ $action }}" method="POST" enctype="multipart/form-data">
        @csrf
        @if(isset($employee))
            @method('PUT')
        @endif
        
        {{-- Personal Data Section --}}
        @include('pages.hris.employee.partials.form_personal', ['employee' => $employee ?? null])
        
        {{-- Employment Data Section --}}
        @include('pages.hris.employee.partials.form_employment', ['employee' => $employee ?? null])
        
        {{-- Documents Upload Section --}}
        @include('pages.hris.employee.partials.form_documents', ['employee' => $employee ?? null])
        
        {{-- Attachments Section --}}
        @include('pages.hris.employee.partials.form_attachments', ['employee' => $employee ?? null])
        
        <div class="mt-4">
            <button type="submit" class="btn btn-primary">{{ $submitText ?? 'Save' }}</button>
            <a href="{{ route('hris.employee.index') }}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
@endsection
```

**Contoh partials/form_personal.blade.php:**
```blade
<div class="card mb-4">
    <div class="card-header">
        <h5>Personal Information</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Full Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" 
                           value="{{ old('name', $employee->name ?? '') }}" required>
                    @error('name')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control @error('email') is-invalid @enderror" 
                           value="{{ old('email', $employee->email ?? '') }}">
                    @error('email')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>
        </div>
        {{-- More fields... --}}
    </div>
</div>
```

### React (Fullstack Frontend)

```
src/pages/hris/employee/
├── EmployeeList.tsx                 (200 baris - main page)
├── EmployeeForm.tsx                 (300 baris - form wrapper)
│   ├── <PersonalDataSection />
│   ├── <EmploymentDataSection />
│   ├── <DocumentsSection />
│   └── <AttachmentsSection />
├── EmployeeDetail.tsx               (250 baris)
└── components/
    ├── PersonalDataSection.tsx      (120 baris)
    ├── EmploymentDataSection.tsx    (140 baris)
    ├── DocumentsSection.tsx         (100 baris)
    ├── AttachmentsSection.tsx       (110 baris)
    ├── EmployeeTable.tsx            (150 baris - reusable)
    └── EmployeeFilters.tsx          (80 baris - reusable)
```

**Contoh EmployeeForm.tsx:**
```tsx
import { useForm } from 'react-hook-form';
import PersonalDataSection from './components/PersonalDataSection';
import EmploymentDataSection from './components/EmploymentDataSection';
import DocumentsSection from './components/DocumentsSection';
import AttachmentsSection from './components/AttachmentsSection';

interface EmployeeFormProps {
  employee?: Employee;
  onSubmit: (data: EmployeeFormData) => void;
}

export default function EmployeeForm({ employee, onSubmit }: EmployeeFormProps) {
  const { control, handleSubmit, watch } = useForm<EmployeeFormData>({
    defaultValues: employee ?? {},
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
      <PersonalDataSection control={control} />
      <EmploymentDataSection control={control} watch={watch} />
      <DocumentsSection control={control} employeeId={employee?.id} />
      <AttachmentsSection control={control} employeeId={employee?.id} />
      
      <div className="flex justify-end gap-3">
        <button type="button" className="btn-secondary">Cancel</button>
        <button type="submit" className="btn-primary">Save</button>
      </div>
    </form>
  );
}
```

**Contoh components/PersonalDataSection.tsx:**
```tsx
import { Control, Controller } from 'react-hook-form';
import { EmployeeFormData } from '../types';

interface Props {
  control: Control<EmployeeFormData>;
}

export default function PersonalDataSection({ control }: Props) {
  return (
    <div className="card">
      <h3 className="card-title">Personal Information</h3>
      <div className="card-body">
        <div className="grid grid-cols-2 gap-4">
          <Controller
            name="name"
            control={control}
            rules={{ required: 'Name is required' }}
            render={({ field, fieldState }) => (
              <div>
                <label>Full Name *</label>
                <input {...field} className={`form-input ${fieldState.error ? 'error' : ''}`} />
                {fieldState.error && <span className="error-text">{fieldState.error.message}</span>}
              </div>
            )}
          />
          {/* More fields... */}
        </div>
      </div>
    </div>
  );
}
```

### Vue.js (Fullstack Frontend)

```
src/pages/hris/employee/
├── EmployeeList.vue                 (200 baris)
├── EmployeeForm.vue                 (250 baris)
│   ├── <PersonalDataSection />
│   ├── <EmploymentDataSection />
│   └── <AttachmentsSection />
└── components/
    ├── PersonalDataSection.vue      (130 baris)
    ├── EmploymentDataSection.vue    (150 baris)
    └── AttachmentsSection.vue       (120 baris)
```

**Contoh EmployeeForm.vue:**
```vue
<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <PersonalDataSection v-model="formData.personal" :errors="errors.personal" />
    <EmploymentDataSection v-model="formData.employment" :errors="errors.employment" />
    <AttachmentsSection v-model="formData.attachments" :employee-id="employeeId" />
    
    <div class="flex justify-end gap-3">
      <button type="button" @click="$emit('cancel')" class="btn-secondary">Cancel</button>
      <button type="submit" class="btn-primary">Save</button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import PersonalDataSection from './components/PersonalDataSection.vue';
import EmploymentDataSection from './components/EmploymentDataSection.vue';
import AttachmentsSection from './components/AttachmentsSection.vue';

const props = defineProps<{ employee?: Employee }>();
const emit = defineEmits(['submit', 'cancel']);

const formData = ref({
  personal: props.employee?.personal ?? {},
  employment: props.employee?.employment ?? {},
  attachments: [],
});

const handleSubmit = () => {
  emit('submit', formData.value);
};
</script>
```

### Nuxt.js (Fullstack Frontend)

```
pages/hris/employee/
├── index.vue                        (150 baris - list page)
├── create.vue                       (100 baris - create wrapper)
├── [id]/
│   ├── index.vue                    (200 baris - detail page)
│   └── edit.vue                     (100 baris - edit wrapper)
└── components/
    ├── EmployeeForm.vue             (300 baris - shared form)
    │   ├── <PersonalSection />
    │   └── <EmploymentSection />
    ├── PersonalSection.vue          (130 baris)
    └── EmploymentSection.vue        (150 baris)
```

---

Kembali ke [Index](../CODING_STANDARDS.md)
