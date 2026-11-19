# Tech News ID

Aplikasi berita teknologi Indonesia berbasis Flutter, mengambil data dari GNews API.

## Fitur

- Daftar berita dengan FutureBuilder (4 state: loading, error, kosong, data)
- Pilihan topik lewat chip: Utama, AI, Gadget, Startup, Siber, Game
- Pencarian berita lewat ikon di AppBar, hasil tampil di halaman baru
- Cache hasil per topik (Map) agar hemat kuota API
- Halaman detail berita
- Pull-to-refresh
- Error handling dengan ApiException dan tombol Coba Lagi

## Cara Menjalankan

1. Daftar di https://gnews.io dan ambil API key
2. Salin `config/env.example.json` menjadi `config/env.json`
3. Isi API key pada `config/env.json`
4. Jalankan:

```bash
flutter pub get
flutter run --dart-define-from-file=config/env.json
```

Untuk browser tambahkan `-d chrome`.

## Struktur Folder

```
lib/
├── config/        # pembaca konfigurasi
├── models/        # ArticleModel, NewsResponseModel
├── services/      # NewsApiService, ApiException
├── views/         # HomeView, SearchView, DetailView
├── widgets/       # ArticleCard, ErrorView, NewsImage, SearchDialog
├── controllers/   # DetailController
├── routes/        # AppRoutes, AppPages
└── utils/         # AppColors, DateFormatter
```

## Screenshot

### Halaman utama
![Home](screenshots/home.png)

### Dialog cari
![Dialog cari](screenshots/dialog-cari.png)

### Hasil pencarian
![Hasil cari](screenshots/hasil-cari.png)

### Detail berita
![Detail](screenshots/detail.png)

### Hasil pencarian kosong
![Kosong](screenshots/kosong-hasil-cari.png)

### Skenario error 1: API key salah (401)
![API key salah](screenshots/error-api-key-salah.png)

### Skenario error 2: tidak ada internet
![Offline](screenshots/error-offline.png)

### Skenario error 3: terlalu cepat (429)
![429](screenshots/error-429-terlalu-cepat.png)

### Tombol Coba Lagi berhasil memuat ulang
![Coba lagi](screenshots/coba-lagi-berhasil.png)

### Halaman tanpa kata kunci
![Kata kunci hilang](screenshots/kata-kunci-hilang.png)