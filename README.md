<p align="center">
  <img src="assets/app_icon/ic_launcher.png" alt="LaporMin! Logo" width="120"/>
</p>

<h1 align="center">LaporMin!</h1>

<p align="center">
  <strong>Aplikasi Pelaporan Masyarakat Berbasis Mobile</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white" alt="Supabase"></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-FCM-FFCA28?logo=firebase&logoColor=black" alt="Firebase"></a>
  <a href="https://bloclibrary.dev"><img src="https://img.shields.io/badge/BLoC-State%20Management-0083CB" alt="BLoC"></a>
  <a href="https://github.com/JavierGavra/lapormin"><img src="https://img.shields.io/badge/version-1.0.0-blue" alt="Version"></a>
</p>

<p align="center">
  <em>Platform pelaporan digital yang memungkinkan masyarakat untuk melaporkan permasalahan di lingkungan sekitar secara real-time, lengkap dengan sistem manajemen petugas lapangan dan dashboard admin.</em>
</p>

---

## 📋 Daftar Isi

- [Tentang Project](#-tentang-project)
- [Fitur Utama](#-fitur-utama)
- [Screenshot](#-screenshot)
- [Tech Stack](#-tech-stack)
- [Arsitektur](#-arsitektur)
- [Struktur Project](#-struktur-project)
- [Prasyarat](#-prasyarat)
- [Instalasi & Setup](#-instalasi--setup)
- [Menjalankan Aplikasi](#-menjalankan-aplikasi)
- [Environment Variables](#-environment-variables)
- [Supabase Edge Functions](#-supabase-edge-functions)
- [Kontribusi](#-kontribusi)
- [Tim Pengembang](#-tim-pengembang)
- [Lisensi](#-lisensi)

---

## 🎯 Tentang Project

**LaporMin!** adalah aplikasi pelaporan masyarakat (*citizen reporting*) yang dirancang untuk menjembatani komunikasi antara warga, admin, dan petugas lapangan dalam menangani berbagai permasalahan di lingkungan sekitar.

Aplikasi ini mendukung **3 peran pengguna** dengan alur kerja yang terintegrasi:

| Peran | Deskripsi |
|-------|-----------|
| 🧑 **Informant** (Pelapor) | Masyarakat yang membuat dan memantau laporan |
| 🛡️ **Admin** | Mengelola laporan, verifikasi, dan menugaskan petugas |
| 👷 **Field Officer** (Petugas Lapangan) | Melakukan cek lapangan dan tindakan penyelesaian |

---

## ✨ Fitur Utama

### 📝 Manajemen Laporan
- Buat laporan dengan bukti foto & video
- Kategori laporan: **Kriminal**, **Bencana**, **Infrastruktur**, **Layanan Publik**
- Sistem tiket untuk tracking laporan
- Alur status laporan: `Menunggu → Terverifikasi → Cek Lapangan → Tindakan → Selesai`
- Laporan dapat ditolak dengan alasan

### 🗺️ Peta Interaktif
- Peta real-time dengan lokasi laporan di sekitar pengguna
- Location picker saat membuat laporan
- Geocoding otomatis (koordinat → alamat)

### 🔔 Push Notification
- Notifikasi real-time via Firebase Cloud Messaging (FCM)
- Channel notifikasi terpisah (status laporan, laporan baru, penugasan)
- Riwayat notifikasi dan fitur *mark all as read*

### 👷 Manajemen Petugas Lapangan
- Admin dapat menambah petugas lapangan
- Penugasan petugas ke laporan tertentu
- Dashboard statistik petugas

### 👤 Profil Pengguna
- Upload foto profil
- Edit username & ganti password
- Statistik jumlah laporan pengguna

### 📊 Dashboard & Statistik
- Dashboard admin dengan ringkasan laporan
- Statistik laporan berdasarkan status dan kategori
- Dashboard petugas lapangan dengan laporan yang ditugaskan

### 🌐 Offline Handling
- Deteksi koneksi internet
- Penanganan graceful saat tidak ada koneksi

---

## 🛠️ Tech Stack

### Frontend (Mobile)
| Teknologi | Kegunaan |
|-----------|----------|
| [Flutter](https://flutter.dev) `^3.x` | Framework UI cross-platform |
| [Dart](https://dart.dev) `^3.11.5` | Bahasa pemrograman |
| [BLoC](https://bloclibrary.dev) `^9.2.1` | State management |
| [flutter_map](https://pub.dev/packages/flutter_map) `^8.3.0` | Peta interaktif (OpenStreetMap) |
| [Dio](https://pub.dev/packages/dio) `^5.9.2` | HTTP client |
| [GetIt](https://pub.dev/packages/get_it) `^9.2.1` | Dependency injection |
| [Dartz](https://pub.dev/packages/dartz) `^0.10.1` | Functional programming (Either type) |

### Backend & Services
| Teknologi | Kegunaan |
|-----------|----------|
| [Supabase](https://supabase.com) | Database, Auth, Storage, Edge Functions |
| [Firebase](https://firebase.google.com) | Push notification (FCM) |
| [Supabase Edge Functions](https://supabase.com/docs/guides/functions) | Serverless backend logic (Deno) |

### Design System
| Komponen | Detail |
|----------|--------|
| Material Design 3 | UI Components |
| Plus Jakarta Sans | Font primer |
| DM Sans | Font sekunder |
| Custom Color Scheme | Primary `#0839A4`, Tertiary `#EC255A` |

---

## 🏗️ Arsitektur

Project ini menggunakan **Clean Architecture** dengan pendekatan **Feature-Based**, dipadukan dengan **BLoC Pattern** untuk state management.

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER             │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │  Pages   │  │ Widgets  │  │   BLoC    │ │
│  └────┬─────┘  └──────────┘  └─────┬─────┘ │
│       │                            │        │
├───────┼────────────────────────────┼────────┤
│       ▼       DOMAIN LAYER        ▼        │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │ Entities │  │Use Cases │  │Repository │ │
│  │          │  │          │  │(Contract) │ │
│  └──────────┘  └────┬─────┘  └───────────┘ │
│                     │                       │
├─────────────────────┼───────────────────────┤
│                     ▼    DATA LAYER         │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │  Models  │  │Repository│  │   Data    │ │
│  │          │  │  (Impl)  │  │  Sources  │ │
│  └──────────┘  └──────────┘  └───────────┘ │
└─────────────────────────────────────────────┘
```

---

## 📁 Struktur Project

```text
lapormin/
├── lib/
│   ├── core/                       # Utilitas yang dipakai di seluruh aplikasi
│   │   ├── api/                    # Konfigurasi API (URL, Keys)
│   │   ├── bloc/                   # Konfigurasi BLoC Provider
│   │   ├── constants/              # Enum & Konstanta (Role, Status, Kategori)
│   │   ├── database/               # Konfigurasi local data persistance
│   │   ├── error/                  # Definisi Failure dan Exception
│   │   ├── layouts/                # Layout utama (Admin, Field Officer, Informant)
│   │   ├── route/                  # Konfigurasi routing
│   │   ├── services/               # Push notification service
│   │   ├── theme/                  # Material Theme, Warna, Tipografi
│   │   ├── use_case/               # Base UseCase abstraction
│   │   ├── utils/                  # Utility functions (network, date format)
│   │   └── widgets/                # Reusable widgets (AppBar, Button, Card, dll.)
│   │
│   ├── features/                   # Modul fitur (Feature-Based)
│   │   ├── auth/                   # Autentikasi (Login, Register, OTP)
│   │   ├── field_officer/          # Manajemen petugas lapangan
│   │   ├── home/                   # Halaman utama (Admin, Informant, Field Officer)
│   │   ├── location/               # Location picker & geocoding
│   │   ├── map/                    # Peta interaktif
│   │   ├── notification/           # Riwayat notifikasi
│   │   ├── profile/                # Profil pengguna
│   │   └── report/                 # CRUD Laporan & Alur Penanganan
│   │
│   ├── injection.dart              # Dependency injection (GetIt)
│   └── main.dart                   # Entry point aplikasi
│
├── supabase/
│   └── functions/                  # Supabase Edge Functions
│       ├── send-notification/      # Trigger push notification via FCM
│       └── create_field_officer/   # Buat akun petugas lapangan
│
├── assets/
│   ├── animations/                 # Animasi Lottie
│   ├── app_icon/                   # Ikon aplikasi
│   ├── fonts/                      # Font (Plus Jakarta Sans, DM Sans)
│   └── images/                     # Gambar (backgrounds, profiles, cards)
│
├── pubspec.yaml                    # Dependensi Flutter
├── firebase.json                   # Konfigurasi Firebase
├── flutter_launcher_icons.yaml     # Konfigurasi ikon aplikasi
└── .env                            # Environment variables (tidak di-commit)
```

---

## 📦 Prasyarat

Pastikan tools berikut sudah terinstal di mesin Anda:

| Tool | Versi Minimum | Link |
|------|---------------|------|
| Flutter SDK | `3.x` | [Install Flutter](https://docs.flutter.dev/get-started/install) |
| Dart SDK | `^3.11.5` | Termasuk dalam Flutter SDK |
| Android Studio / VS Code | Terbaru | [Android Studio](https://developer.android.com/studio) |
| Git | Terbaru | [Install Git](https://git-scm.com/) |
| Supabase CLI | Terbaru | [Install Supabase CLI](https://supabase.com/docs/guides/cli) |

---

## 🚀 Instalasi & Setup

### 1. Clone Repository

```bash
git clone https://github.com/JavierGavra/lapormin.git
cd lapormin
```

### 2. Konfigurasi Environment Variables

Buat file `.env` di root project:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Konfigurasi Firebase

Pastikan file konfigurasi Firebase sudah tersedia:
- **Android**: `android/app/google-services.json`
- **iOS**: Konfigurasi via Xcode

Atau generate ulang menggunakan FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 5. Generate App Icon (Opsional)

```bash
dart run flutter_launcher_icons
```

---

## ▶️ Menjalankan Aplikasi

### Development

```bash
# Jalankan di device/emulator
flutter run

# Jalankan di mode debug dengan verbose logging
flutter run --verbose
```

### Build Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🔐 Environment Variables

| Variable | Deskripsi | Wajib |
|----------|-----------|:-----:|
| `SUPABASE_URL` | URL project Supabase | ✅ |
| `SUPABASE_ANON_KEY` | Anonymous key Supabase | ✅ |

> **⚠️ Penting:** File `.env` sudah termasuk dalam `.gitignore`. Jangan pernah commit kredensial ke repository.

---

## ⚡ Supabase Edge Functions

Project ini menggunakan **2 Edge Functions** yang berjalan di Supabase (Deno runtime):

### `send-notification`
Mengirim push notification ke pengguna melalui Firebase Cloud Messaging (FCM). Ter-trigger otomatis saat ada record baru di tabel notifikasi.

**Tipe Notifikasi:**
| Type | Deskripsi | Channel |
|------|-----------|---------|
| `ganti_status` | Pergantian status laporan | `status_laporan_channel` |
| `laporan_baru` | Ada laporan baru | `general_channel` |
| `penugasan` | Penugasan petugas ke laporan | `status_laporan_channel` |
| `hasil_laporan` | Hasil dari petugas lapangan | `status_laporan_channel` |
| `laporan_terdekat` | Laporan di sekitar pengguna | `general_channel` |

### `create_field_officer`
Membuat akun petugas lapangan baru melalui Supabase Admin API.

### Deploy Edge Functions

```bash
supabase functions deploy send-notification
supabase functions deploy create_field_officer
```

---

## 🤝 Kontribusi

Kami menyambut kontribusi dari siapa pun! Silakan baca panduan kontribusi lengkap di [CONTRIBUTING.MD](.github/CONTRIBUTING.MD).

### Ringkasan Alur Kontribusi

1. **Buat branch baru** dari `development` dengan format: `type/feature-name`
   ```bash
   git checkout -b feat/fitur-baru
   ```

2. **Lakukan perubahan** dan commit dengan konvensi:
   ```
   type: [Initial Name] Commit message
   ```
   Contoh: `feat: [JG] Create login page`

3. **Push dan buat Pull Request** ke branch `development`
   ```bash
   git push origin feat/fitur-baru
   ```

4. **Tunggu review** dari Project Manager sebelum merge

### Tipe Commit

| Type | Deskripsi |
|------|-----------|
| `feat` | Menambah fitur baru |
| `fix` | Memperbaiki bug atau error |
| `refactor` | Menyederhanakan atau membersihkan kode |
| `docs` | Menambah atau memperbarui dokumentasi |
| `test` | Menambah atau mengubah pengujian |

---

## 👥 Tim Pengembang

<table>
  <tr>
    <td align="center"><strong>JG</strong><br>Javier Gavra</td>
    <td align="center"><strong>MD</strong><br>Mahdana</td>
  </tr>
</table>

---

## 📄 Lisensi

Project ini dikembangkan untuk keperluan akademik (Semester 4).

---

<p align="center">
  Dibuat dengan ❤️ menggunakan Flutter & Supabase
</p>