# Github Workflow
## Branch
- `main` : Production ready
- `development` : Branch utama untuk pengembangan, semua perubahan code harus di merge ke branch ini.

Setiap ingin melakukan perubahan source code harus membuat branch baru. Adapun format penamaan standar
untuk branch yang dibuat yaitu `type/feature-name`, contoh :

- `feat/login`
- `fix/home-masyarakat`
- `refactor/create-report`

Setelah Branch siap untuk di adapatasi ke sistem utama, lakukan pull request (PR) dari branch tersebut ke `development` tetapi jangan di merge terlebih dahulu. Biarkan 'Project Manager' melakukan review pada PR tersebut.

Branch yang dibuat akan dihapus ketika code yang di merge sudah cukup baik.

Before Coding
```sh
git fetch
git pull <remote> <branch>
```

## Commit
Setiap ingin melakukan commit ada aturan format commit yang harus dipatuhi (Commit Convention), yaitu `type: [Initial Name] Commit message`. contoh :

- `feat: [JG] Create login page`
- `fix: [MD] Fixing error handling in Create Laporan`
- `refactor: [MD] Change Bubble sort to Quick sort`

##

Ada beberapa "`type`" yang bisa digunakan. yaitu :
- `docs` : Melakukan/memberikan dokumentasi, bisa berupa `.md` file ataupun comments pada code. 
- `feat` : Menambah fitur baru pada aplikasi.
- `fix` : Memperbaiki bug, error, atau kesalahan pada kode.
- `refactor` : Merombak, menyederhanakan, atau membersihkan struktur kode tanpa menambah fitur baru atau memperbaiki bug.
- `test` : Menambahkan pengujian atau mengubah pengujian yang sudah ada.


# Project Structure
Project menggunakan "Clean Architecture Featured-based" dengan state management "BLoC", berikut adalah pemetaan struktur project-nya :
```text
lib/
├── core/                       # Utilitas yang dipakai di seluruh aplikasi
│   ├── bloc/                   # Konfigurasi BLoC
│   ├── constants/              # URL API, Asset Paths
│   ├── database/               # Konfigrusi utama database
│   ├── error/                  # Definisi Failure dan Exception (misal: ServerException)
│   ├── theme/                  # Konfigurasi Design, Warna, Tipografi
│   ├── use_case/               # Konfigruasi UseCase
│   ├── utils/                  # Format tanggal (untuk notifikasi), dll.
│   └── widgets/                # Widget yang reusable
│
├── features/                   # Modul utama aplikasi (Feature-Based)
│   ├── features_1/
│   │   ├── data/               # Layer DATA (Dari luar ke dalam)
│   │   │   ├── data_sources/   # Pemanggilan data (Remote/Local)
│   │   │   ├── models/         # Representasi JSON (extends Entity)
│   │   │   └── repositories/   # Implementasi dari kontrak di layer Domain
│   │   │
│   │   ├── domain/             # Layer DOMAIN (Jantung aplikasi - Murni logika bisnis)
│   │   │   ├── entities/       # Objek inti (misal: UserEntity)
│   │   │   ├── repositories/   # Kontrak/Interface (Abstract class)
│   │   │   └── use_cases/      # Logika Use Case (misal: LoginAdminUseCase)
│   │   │
│   │   └── presentation/       # Layer PRESENTATION (Antarmuka & State)
│   │       ├── bloc/           # State Management
│   │       ├── pages/          # Halaman UI (LoginScreen)
│   │       └── widgets/        # Komponen khusus Auth (misal: OtpInputField)
│   │
│   └── feature.../             # Fitur berikutnya
│
├── injection.dart              # Depedancy injection
└── main.dart                   # Entry point aplikasi

```

# Run
```sh
flutter pub get
flutter run
```
