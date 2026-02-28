# HRIS (Human Resource Information System) Full-Stack App

Sistem Informasi Sumber Daya Manusia (HRIS) modern yang dibangun menggunakan **NestJS** untuk backend dan **Flutter** untuk aplikasi mobile. Aplikasi ini mendukung fungsionalitas inti HR dengan sistem otentikasi berbasis peran (Role-Based Access Control) untuk Admin dan Employee.

## 🌟 Fitur Utama

- **Role-Based Access (Admin & Employee)**: Otentikasi aman menggunakan JWT.
- **Manajemen Karyawan**: CRUD data karyawan lengkap dengan fitur filter berdasarkan departemen dan status.
- **Sistem Cuti (Leave Management)**: Pengajuan cuti oleh karyawan, dan persetujuan/penolakan oleh Admin. Termasuk pelacakan sisa cuti bulanan/tahunan.
- **Sistem Kehadiran (Attendance)**: Fitur Check-In / Check-Out harian beserta chart tren kehadiran mingguan.
- **Manajemen Penggajian (Payroll)**: Detail slip gaji karyawan dengan rincian pendapatan dan potongan.
- **Admin Dashboard**: Analitik dan statistik interaktif menggunakan chart visual (`fl_chart`).
- **Audit Logging**: Pencatatan aktivitas sistem yang aman (Admin-only).

---

## 🛠️ Teknologi yang Digunakan

### 📱 Frontend (Mobile App)
- **Framework**: Flutter (Dart)
- **State Management**: `provider`
- **Networking**: `http`
- **UI & Analytics**: `fl_chart`, `google_fonts`, Material Design 3

### ⚙️ Backend (REST API)
- **Framework**: NestJS (TypeScript)
- **Database**: PostgreSQL
- **ORM**: Prisma (v5.22.0)
- **Authentication**: JWT, Passport.js, Bcrypt

---

## 📸 Tampilan Aplikasi (Mockups)

Desain UI modern merujuk pada direktori `/mockups` dengan fokus fungsionalitas yang mulus:
1. **Admin Dashboard**: Mengelola 4 modul utama (Karyawan, Cuti, Kehadiran, Analitik).
2. **Employee Directory**: Pencarian dan filter karyawan secara instan.
3. **Leave Approval Center**: Melihat daftar antrean cuti dan sisa hari cuti tiap karyawan.
4. **Detailed Payslip**: Informasi rincian gaji (Take Home Pay).

---

## 🚀 Panduan Menjalankan Aplikasi (Local Development)

### 1. Prasyarat Sistem
- Node.js (v18+)
- PostgreSQL (Database berjalan di background)
- Flutter SDK (v3+)

### 2. Setup Backend (NestJS)
```bash
# 1. Masuk ke folder backend
cd backend

# 2. Install dependensi
npm install

# 3. Setup Variabel Lingkungan
# Edit file .env dan sesuaikan URL database PostgreSQL Anda
# Contoh: DATABASE_URL="postgresql://username:password@localhost:5432/hris?schema=public"

# 4. Generate konfigurasi Prisma dan dorong skema ke database
npx prisma generate
npx prisma db push

# 5. Isi database dengan data awal (Seed)
npm run seed

# 6. Jalankan Server NestJS
npm run start:dev
```
*Backend akan berjalan di `http://localhost:3000/api`*

### 3. Setup Mobile (Flutter)
```bash
# 1. Masuk ke folder mobile
cd mobile

# 2. Install dependensi Flutter
flutter pub get

# 3. (Penting) Konfigurasi Base URL API
# Pada file `lib/services/api_service.dart`, ubah baseUrl sesuai environment Anda:
# - Untuk Android Emulator: 'http://10.0.2.2:3000/api'
# - Untuk Chrome/Web: 'http://localhost:3000/api'
# - Untuk Device Fisik: Gunakan IPv4 LAN PC (contoh: 'http://192.168.1.15:3000/api')

# 4. Jalankan aplikasi (pilih device, misal chrome atau emulator)
flutter run
```

---

## 🔑 Demo Akun (Setelah Seeding Database)

Gunakan akun berikut untuk login ke dalam aplikasi:

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@hris.com` | `password123` |
| **Karyawan** | `budi@hris.com` | `password123` |
| **Karyawan** | `zidane@hris.com` | `password123` |

---

## 📂 Struktur Project

```text
📦 HRIS
 ┣ 📂 backend           # Server REST API (NestJS + Prisma)
 ┃ ┣ 📂 src             # Source Code (Modules: Auth, Leave, Payroll, dll)
 ┃ ┣ 📂 prisma          # Skema Database & script Seeding
 ┃ ┗ 📜 package.json
 ┣ 📂 mobile            # Aplikasi Frontend (Flutter)
 ┃ ┣ 📂 lib             # Source Code (Screens, Models, Providers, Services)
 ┃ ┗ 📜 pubspec.yaml
 ┣ 📂 mockups           # Referensi Desain UI/UX
 ┗ 📜 README.md         # Dokumentasi Project (File ini)
```

---
*Dibuat untuk portofolio pengembangan Full-Stack Mobile System.*
